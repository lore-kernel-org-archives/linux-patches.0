Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C61280035
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 09:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757670719; cv=none; b=T1MqSZ5JLOV8lxgdjUtbi144dC1DTVGstn7vhoV0KEsMS15t5Aw71LfWux2HXzWf701WFneCBbqj/fm+RNzGblHkI9n1vdNqgrLDvpzLW98wSkH3giSWeC2iJvm5q1IhXUxGI046zOfH6DrpCU7EE7k99ZhPEXKuMQdUL5CN/zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757670719; c=relaxed/simple;
	bh=+ioCe3wAu9329cOPHSap3mzKytcTbXHSNgkpLdL4yk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUp/VrkxI8hgbKlFE0La8oUmHtRDR/7qTG6iKx6cvQAbMsrjSyKR5eXGQDo66l7Rk02sDVebDHP7JsNTnqBH4Vyu5OoOSxW4fsazwxVsCTC7KqkTSHa7COTHC7Plb76d7fi1SI8LvDZojqsr3dCqk8JbFkkZRDngLxdxLTfarg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=B8UoJMYn; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="B8UoJMYn"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757670713; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=g2hZtuy4aSO7mUbB7MC7MtcQt3zYiBcJ2gAuIsO45DM=;
	b=B8UoJMYnNRXizRPtrpHOMLFG8M89+2Jv+Nr3AoS6FlmIhpbmt7OL8s1v+AZq3X2n7hN67ijzrB0/BSuIas4Nw14htKNdfsI6a9YNlbQ8piYflHVi/iOdUkNxMxZ4NqwqVUg8GzrQUZbm+5i5OeNSktjisTlkxMa7fl4do0uloZs=
Received: from 30.178.65.122(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0WnquE8w_1757670705 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 17:51:52 +0800
Message-ID: <611ec112-02ee-492f-baef-270edbd08957@linux.alibaba.com>
Date: Fri, 12 Sep 2025 17:51:45 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH] fs/resctrl: Eliminate false positive lockdep warning when
 reading SNC counters
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peternewman@google.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <0819ce534d0cb919f728e940d9412c3bab1a27c7.1757369564.git.reinette.chatre@intel.com>
From: qinyuntan <qinyuntan@linux.alibaba.com>
In-Reply-To: <0819ce534d0cb919f728e940d9412c3bab1a27c7.1757369564.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Reinette,

Thank you for reporting this issue, and my apologies for the delayed 
reply :).

I was able to reproduce the same lockdep warning on my local SNC-3 
system, and the warning disappears after applying your patch.

The change looks good to me.

Reviewed-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

Thanks,

On 9/9/25 6:15 AM, Reinette Chatre wrote:
> Running resctrl_tests on an SNC-2 system with lockdep debugging enabled
> triggers several warnings with following trace:
> 	WARNING: CPU: 0 PID: 1914 at kernel/cpu.c:528 lockdep_assert_cpus_held+0x8a/0xc0
> 	...
> 	Call Trace:
> 	__mon_event_count
> 	? __lock_acquire
> 	? __pfx___mon_event_count
> 	mon_event_count
> 	? __pfx_smp_mon_event_count
> 	smp_mon_event_count
> 	smp_call_on_cpu_callback
> 	<snip>
> 
> get_cpu_cacheinfo_level() called from __mon_event_count() requires CPU
> hotplug lock to be held. The hotplug lock is indeed held during this time,
> as confirmed by the lockdep_assert_cpus_held() within mon_event_read()
> that calls mon_event_count() via IPI, but the lockdep tracking is not able
> to follow the IPI.
> 
> Fresh CPU cache information via get_cpu_cacheinfo_level() from
> __mon_event_count() was added to support the fix for the issue where
> resctrl inappropriately maintained links to L3 cache information that will
> be stale in the case when the associated CPU goes offline.
> 
> Keep the cacheinfo ID in struct rdt_mon_domain to ensure that
> resctrl does not maintain stale cache information while CPUs can go
> offline. Return to using a pointer to the L3 cache information (struct
> cacheinfo) in struct rmid_read, rmid_read::ci. Initialize rmid_read::ci
> before the IPI where it is used. CPU hotplug lock is held across
> rmid_read::ci initialization and use to ensure that it points to accurate
> cache information.
> 
> Fixes: 594902c986e2 ("x86,fs/resctrl: Remove inappropriate references to cacheinfo in the resctrl subsystem")
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>   fs/resctrl/ctrlmondata.c | 2 +-
>   fs/resctrl/internal.h    | 4 ++--
>   fs/resctrl/monitor.c     | 6 ++----
>   3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index d98e0d2de09f..3c39cfacb251 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -625,11 +625,11 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>   		 */
>   		list_for_each_entry(d, &r->mon_domains, hdr.list) {
>   			if (d->ci_id == domid) {
> -				rr.ci_id = d->ci_id;
>   				cpu = cpumask_any(&d->hdr.cpu_mask);
>   				ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
>   				if (!ci)
>   					continue;
> +				rr.ci = ci;
>   				mon_event_read(&rr, r, NULL, rdtgrp,
>   					       &ci->shared_cpu_map, evtid, false);
>   				goto checkresult;
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 0a1eedba2b03..9a8cf6f11151 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -98,7 +98,7 @@ struct mon_data {
>    *	   domains in @r sharing L3 @ci.id
>    * @evtid: Which monitor event to read.
>    * @first: Initialize MBM counter when true.
> - * @ci_id: Cacheinfo id for L3. Only set when @d is NULL. Used when summing domains.
> + * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
>    * @err:   Error encountered when reading counter.
>    * @val:   Returned value of event counter. If @rgrp is a parent resource group,
>    *	   @val includes the sum of event counts from its child resource groups.
> @@ -112,7 +112,7 @@ struct rmid_read {
>   	struct rdt_mon_domain	*d;
>   	enum resctrl_event_id	evtid;
>   	bool			first;
> -	unsigned int		ci_id;
> +	struct cacheinfo	*ci;
>   	int			err;
>   	u64			val;
>   	void			*arch_mon_ctx;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index f5637855c3ac..7326c28a7908 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -361,7 +361,6 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   {
>   	int cpu = smp_processor_id();
>   	struct rdt_mon_domain *d;
> -	struct cacheinfo *ci;
>   	struct mbm_state *m;
>   	int err, ret;
>   	u64 tval = 0;
> @@ -389,8 +388,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   	}
>   
>   	/* Summing domains that share a cache, must be on a CPU for that cache. */
> -	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
> -	if (!ci || ci->id != rr->ci_id)
> +	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
>   		return -EINVAL;
>   
>   	/*
> @@ -402,7 +400,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   	 */
>   	ret = -EINVAL;
>   	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> -		if (d->ci_id != rr->ci_id)
> +		if (d->ci_id != rr->ci->id)
>   			continue;
>   		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
>   					     rr->evtid, &tval, rr->arch_mon_ctx);

