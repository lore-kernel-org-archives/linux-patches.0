Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2833A453E
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 10:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773743156; cv=none; b=n6x5R3WaxusgZ7H3l+681u9e9btIsc3iRlyw11Ah9ntqAUf6CxQzUGHFWmcXxloJVKkZuCCA3NlGvMF4wT0OBzgQ3ebO7ammExXZpCsu35bMDHJMn3Qdp2uBAIwCFIR+IQW/Km6N2owkSZupWS2zs47RLQ/cSucADjXeIuUpNOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773743156; c=relaxed/simple;
	bh=VHsiFpKo5SgzLMsfo/a7HNHakGh6u50Eav3aFbJ+fVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CtoAJDvvu0IR35u6z9M2S5BkPFgsDwkBpRkLsiasPRl52byjcSeuQKYxduJpmGBDG9Yw9g+Ma1xyrQoIw9zZjajVRXtFSa8JKTY3oL6fDJRhCtJD7wUAtOE4SusU4Q2J67MrNkC5F7NViGZX0O50kF5WAiQTOqrkdgUo1maUSXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDE7C1476;
	Tue, 17 Mar 2026 03:25:48 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33E263F7BD;
	Tue, 17 Mar 2026 03:25:53 -0700 (PDT)
Message-ID: <38e5c384-4d08-425e-a4fb-a63913be35ac@arm.com>
Date: Tue, 17 Mar 2026 10:25:51 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <8be6feef-b7a5-4fd7-9bc0-9aeed7ef0fda@arm.com>
 <e334f16f-2576-43af-b64d-013d7a14f291@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <e334f16f-2576-43af-b64d-013d7a14f291@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/16/26 18:18, Reinette Chatre wrote:
> Hi Ben,
> 
> On 3/16/26 10:44 AM, Ben Horgan wrote:
>> On 3/2/26 18:46, Reinette Chatre wrote:
> ...
>> One related issue I've just noticed is that when ABMC and mbm_assign_on_mkdir are
>> enabled the creation of MON/CTRL_MON directories may succeed but an error message
>> is written to last_cmd_status. E.g.
>>
>> /sys/fs/resctrl# mkdir mon_groups/new5
>> /sys/fs/resctrl# cat info/last_cmd_status
>> Failed to allocate counter for mbm_total_bytes in domain 2
>>
>> The failure is ignored, as expected, in rdt_assign_cntrs() but the last_cmd_status
>> is never cleared. I think this could be fixed by:
>>
>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>> index 62edb464410a..396f17ed72c6 100644
>> --- a/fs/resctrl/monitor.c
>> +++ b/fs/resctrl/monitor.c
>> @@ -1260,6 +1260,8 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
>>         if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>                 rdtgroup_assign_cntr_event(NULL, rdtgrp,
>>                                            &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
>> +
>> +       rdt_last_cmd_clear();
>>  }
>>
>> Is this right thing to do? Let me know if you want a proper patch.
> 
> Letting group be created without any counters assigned while writing the error
> to last_cmd_status is the intended behavior. If the last_cmd_status buffer is cleared
> at this point then user space will never have the opportunity to see the message that
> contains the details.
> 
> It did not seem appropriate to let resource group creation fail when no counters
> are available. I see that the documentation is not clear on this. What do you think
> of an update to documentation instead? Would something like below help clarify behavior?
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index ba609f8d4de5..20dc58d281cf 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -478,6 +478,12 @@ with the following files:
>  	  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_on_mkdir
>  	  0
>  
> +	Automatic counter assignment is done with best effort. If auto assignment
> +	is enabled but there are not enough available counters then monitor group
> +	creation could succeed while one or more events belonging to the group may
> +	not have a counter assigned. Consult last_cmd_status for details during
> +	such scenario.
> +

This does the improve the situation but the multiple domain failure behaviour depends
on the order the domains are iterated through. This is stable as the list is sorted but
does seem a bit complicated.
I.e. if you have two domains, with ids 2 and 3, with no counters remaining on domain 2 but
some on domain 3 then rdtgroup_assign_cntr_event() will fail early and the counter won't
be assigned for domain 3 but the last_cmd_status will only be about domain 2. The user
either needs to know a failure at one domain means all higher domains will not be
considered for that counter or look at the new mbm_L3_assignments to understand what's happened.
In this case we have:

/sys/fs/resctrl# cat info/L3_MON/mbm_assign_on_mkdir
1
/sys/fs/resctrl# cat info/L3_MON/available_mbm_cntrs
2=0;3=1
/sys/fs/resctrl# mkdir mon_groups/new
/sys/fs/resctrl# cat info/last_cmd_status
Failed to allocate counter for mbm_total_bytes in domain 2
/sys/fs/resctrl# cat mon_groups/new/mbm_L3_assignments
mbm_total_bytes:2=_;3=_

Would it be better for each domain to be considered even if a previous failure occurred or
is this now a fixed behaviour? For illustration:

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 62edb464410a..8e061bce9742 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1248,18 +1248,25 @@ static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgro
 void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
 {
        struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+       struct rdt_l3_mon_domain *d;

        if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r) ||
            !r->mon.mbm_assign_on_mkdir)
                return;

-       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-               rdtgroup_assign_cntr_event(NULL, rdtgrp,
-                                          &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
+       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
+               list_for_each_entry(d, &r->mon_domains, hdr.list) {
+                       rdtgroup_assign_cntr_event(d, rdtgrp,
+                                                  &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
+               }
+       }

-       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-               rdtgroup_assign_cntr_event(NULL, rdtgrp,
-                                          &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
+       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
+               list_for_each_entry(d, &r->mon_domains, hdr.list) {
+                       rdtgroup_assign_cntr_event(d, rdtgrp,
+                                                  &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
+               }
+       }
 }

Thanks,

Ben



>  "max_threshold_occupancy":
>  		Read/write file provides the largest value (in
>  		bytes) at which a previously used LLC_occupancy
> 
> Reinette
> 
> 
> 

