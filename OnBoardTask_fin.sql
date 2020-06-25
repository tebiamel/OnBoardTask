/* a. Display a list of all property names and their property id’s for Owner Id: 1426*/

	SELECT 
		p.Name,op.PropertyId, op.OwnerId  
	FROM 
		Property p
	INNER JOIN 
		OwnerProperty op ON p.Id = op.PropertyId
	WHERE
		op.OwnerId = 1426


/* b. Display the current home value for each property in question a*/

	SELECT DISTINCT
		op.PropertyId, op.OwnerId, p.Name, hv.Value
	FROM 
		Property p
	INNER JOIN 
		OwnerProperty op ON p.Id = op.PropertyId
	INNER JOIN 
		PropertyHomeValue hv ON op.PropertyId = hv.PropertyId
	WHERE
		op.OwnerId = 1426


/* c) For each property in question a), return the following: */

--i. Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date.--

--Option 1--

	SELECT 
		p.Id, p.Name, CONVERT(varchar(10),tp.StartDate,103) AS StartDate
        ,CONVERT(varchar(10),tp.EndDate, 103) AS EndDate 
		,rp.Amount,  
			CASE 
				WHEN rp.FrequencyType = 1 THEN 'Weekly' 
				WHEN rp.FrequencyType = 2 THEN 'Fortnightly' 
				ELSE 'Monthly'
			END AS Frequency,

			CASE 
				WHEN rp.FrequencyType = 1 THEN DATEDIFF("ww", tp.StartDate, tp.EndDate) * rp.Amount
				WHEN rp.FrequencyType = 2 THEN DATEDIFF("ww", tp.StartDate, tp.EndDate)/2 *rp.Amount
				ELSE DATEDIFF("mm", tp.StartDate, tp.EndDate)* rp.Amount
			END AS SumOfPayments
	FROM 
		Property p
	INNER JOIN 
		OwnerProperty op ON p.Id = op.PropertyId
	INNER JOIN 
		PropertyRentalPayment rp ON op.PropertyId = rp.PropertyId
	INNER JOIN
		TenantProperty tp ON rp.PropertyId = tp.PropertyId
	WHERE
		op.OwnerId = 1426 AND p.IsActive = 1


--Option 2--

	SELECT DISTINCT
		p.Id, p.Name, CONVERT(varchar(10),tp.StartDate,103) AS StartDate
        ,CONVERT(varchar(10),tp.EndDate, 103) AS EndDate 
		,tp.PaymentAmount,  
			CASE 
				WHEN tp.PaymentFrequencyId = 1 THEN 'Weekly' 
				WHEN tp.PaymentFrequencyId = 2 THEN 'Fortnightly' 
				ELSE 'Monthly'
			END AS Frequency,

			CASE 
				WHEN tp.PaymentFrequencyId = 1 THEN DATEDIFF("ww", tp.StartDate, tp.EndDate) * tp.PaymentAmount
				WHEN tp.PaymentFrequencyId = 2 THEN DATEDIFF("ww", tp.StartDate, tp.EndDate)/2 *tp.PaymentAmount
				ELSE DATEDIFF("mm", tp.StartDate, tp.EndDate)* tp.PaymentAmount
			END AS SumOfPayments
	FROM 
		Property p
	INNER JOIN 
		OwnerProperty op ON p.Id = op.PropertyId
	INNER JOIN 
		PropertyRentalPayment rp ON op.PropertyId = rp.PropertyId
	INNER JOIN
		TenantProperty tp ON rp.PropertyId = tp.PropertyId
	WHERE
		op.OwnerId = 1426


--ii. Display the yield--

	SELECT 
		p.Name AS PropertyName, pf.Yield
	FROM
		Property p
	INNER JOIN 
		OwnerProperty op ON p.Id = op.PropertyId
	INNER JOIN
		PropertyFinance pf ON op.PropertyId = pf.PropertyId
	WHERE 
		OwnerId = 1426


/* d) Display all the jobs available */

	SELECT 
		j.PropertyId, j.JobDescription, js.Status
	FROM 
		Job j
	INNER JOIN 
		JobStatus js ON j.JobStatusId = js.Id
	WHERE 
		j.JobStatusId = 1 

/* e) Display all property names, current tenants first and last names and rental payments per week/ fortnight/month 
for the properties in question a */

	SELECT DISTINCT
		p.Id, p.Name, ps.FirstName, ps.LastName 
		,tp.PaymentAmount, 
			CASE
				WHEN tp.PaymentFrequencyId = 1 THEN 'Weekly'
				WHEN tp.PaymentFrequencyId = 2 THEN 'Fortnightly'
				ELSE 'Monthly'
			END AS PaymentFrequency
	FROM 
		Property p
	INNER JOIN 
		OwnerProperty op ON p.Id = op.PropertyId
	INNER JOIN 
		PropertyRentalPayment rp ON op.PropertyId = rp.PropertyId
	INNER JOIN
		TenantProperty tp ON rp.PropertyId = tp.PropertyId
	INNER JOIN 
		Person ps ON tp.TenantId = ps.Id
	WHERE
		op.OwnerId = 1426






