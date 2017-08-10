select d.Request_at
, round(sum(is_cancelled_by_NB_client) / count(*), 2) as rate1
, case 
	when sum(is_cancelled) = 0
    then 0.00
    else round(sum(is_cancelled_by_NB_client) / sum(is_cancelled), 2)
    end as rate2
, round(sum(is_cancelled) / count(*), 2) as 'Cancellation Rate'
from 
(select t.Status
, t.Request_at 
, u1.Banned as client_banned
, u2.Banned as driver_banned
, case 
	when t.Status like 'cancelled_%'
	then 1
    else 0
    end as is_cancelled
, case 
	when (t.Status = 'cancelled_by_client' and u1.Banned = 'No')
	then 1
    else 0
    end as is_cancelled_by_NB_client
from trips as t
left outer join users as u1
	on t.Client_Id = u1.Users_Id
left outer join users as u2
	on t.Driver_Id = u2.Users_Id
-- where u1.Banned = 'No'
order by t.Request_at
    ) as d
group by d.Request_at

