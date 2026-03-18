Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5902D47E9
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773853858; cv=none; b=W5B6qiy/RHKPccSbovLUGrPlrd7r2ezIOJqpAXOcPQ9hTP9LxoYR96kmPo6X4qr2Eo5ffxu30Sk5+Ha38FbTWgaXRt5oryV+P8u/dhZv2KIgnB2bc01e3VJwD/qlJZb24W4x9eteXKYKzIpADtc2oMpmM1A98o48uigy/A5kNAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773853858; c=relaxed/simple;
	bh=HwJsiTImxkgHB1mXh8wb/w8hGPVVKYExiEjZDJ0zlNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JTRGhMriVfA4oIuHWZqof07HgFK55EpM4Vc85d8VfGznbpjTq3Bxrjxq857wgKe7iSKqYb9Lava+bya+cJMJuWKNfVfPMsXLv9mEQ3WxZeM2hnKb8QveXfNR1mhLYisig7/PxNzUyTcN7aU/dFjgJ6JdX/JcYPsx3JwSxnAA05c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B4071C2B;
	Wed, 18 Mar 2026 10:10:50 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F9F63F73B;
	Wed, 18 Mar 2026 10:10:54 -0700 (PDT)
Message-ID: <e7e480ed-4dee-4898-a47e-8730eea2dcde@arm.com>
Date: Wed, 18 Mar 2026 17:10:52 +0000
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
 <38e5c384-4d08-425e-a4fb-a63913be35ac@arm.com>
 <f37db924-dc65-432b-ae48-ddd986b3efd9@intel.com>
 <d4460f04-813f-4a6f-ad1f-6f2e5bb1c9fa@arm.com>
 <55a9461e-32f8-4665-905e-bc18b7201c7e@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <55a9461e-32f8-4665-905e-bc18b7201c7e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/18/26 16:35, Reinette Chatre wrote:
> Hi Ben,
> 
> On 3/18/26 4:59 AM, Ben Horgan wrote:
>> On 3/17/26 18:09, Reinette Chatre wrote:
>>> On 3/17/26 3:25 AM, Ben Horgan wrote:
>>>> On 3/16/26 18:18, Reinette Chatre wrote:
>>>>> On 3/16/26 10:44 AM, Ben Horgan wrote:
>>>>>> On 3/2/26 18:46, Reinette Chatre wrote:
>>>>> ...
>>>>>> One related issue I've just noticed is that when ABMC and mbm_assign_on_mkdir are
>>>>>> enabled the creation of MON/CTRL_MON directories may succeed but an error message
>>>>>> is written to last_cmd_status. E.g.
>>>>>>
>>>>>> /sys/fs/resctrl# mkdir mon_groups/new5
>>>>>> /sys/fs/resctrl# cat info/last_cmd_status
>>>>>> Failed to allocate counter for mbm_total_bytes in domain 2
>>>>>>
>>>>>> The failure is ignored, as expected, in rdt_assign_cntrs() but the last_cmd_status
>>>>>> is never cleared. I think this could be fixed by:
>>>>>>
>>>>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>>>>> index 62edb464410a..396f17ed72c6 100644
>>>>>> --- a/fs/resctrl/monitor.c
>>>>>> +++ b/fs/resctrl/monitor.c
>>>>>> @@ -1260,6 +1260,8 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
>>>>>>         if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>>>>>                 rdtgroup_assign_cntr_event(NULL, rdtgrp,
>>>>>>                                            &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
>>>>>> +
>>>>>> +       rdt_last_cmd_clear();
>>>>>>  }
>>>>>>
>>>>>> Is this right thing to do? Let me know if you want a proper patch.
>>>>>
>>>>> Letting group be created without any counters assigned while writing the error
>>>>> to last_cmd_status is the intended behavior. If the last_cmd_status buffer is cleared
>>>>> at this point then user space will never have the opportunity to see the message that
>>>>> contains the details.
>>>>>
>>>>> It did not seem appropriate to let resource group creation fail when no counters
>>>>> are available. I see that the documentation is not clear on this. What do you think
>>>>> of an update to documentation instead? Would something like below help clarify behavior?
>>>>>
>>>>> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
>>>>> index ba609f8d4de5..20dc58d281cf 100644
>>>>> --- a/Documentation/filesystems/resctrl.rst
>>>>> +++ b/Documentation/filesystems/resctrl.rst
>>>>> @@ -478,6 +478,12 @@ with the following files:
>>>>>  	  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_on_mkdir
>>>>>  	  0
>>>>>  
>>>>> +	Automatic counter assignment is done with best effort. If auto assignment
>>>>> +	is enabled but there are not enough available counters then monitor group
>>>>> +	creation could succeed while one or more events belonging to the group may
>>>>> +	not have a counter assigned. Consult last_cmd_status for details during
>>>>> +	such scenario.
>>>>> +
>>>>
>>>> This does the improve the situation but the multiple domain failure behaviour depends
>>>> on the order the domains are iterated through. This is stable as the list is sorted but
>>>> does seem a bit complicated.
>>>> I.e. if you have two domains, with ids 2 and 3, with no counters remaining on domain 2 but
>>>> some on domain 3 then rdtgroup_assign_cntr_event() will fail early and the counter won't
>>>> be assigned for domain 3 but the last_cmd_status will only be about domain 2. The user
>>>> either needs to know a failure at one domain means all higher domains will not be
>>>> considered for that counter or look at the new mbm_L3_assignments to understand what's happened.
>>>> In this case we have:
>>>>
>>>> /sys/fs/resctrl# cat info/L3_MON/mbm_assign_on_mkdir
>>>> 1
>>>> /sys/fs/resctrl# cat info/L3_MON/available_mbm_cntrs
>>>> 2=0;3=1
>>>> /sys/fs/resctrl# mkdir mon_groups/new
>>>> /sys/fs/resctrl# cat info/last_cmd_status
>>>> Failed to allocate counter for mbm_total_bytes in domain 2
>>>> /sys/fs/resctrl# cat mon_groups/new/mbm_L3_assignments
>>>> mbm_total_bytes:2=_;3=_
>>>
>>> Good point.
>>>
>>>>
>>>> Would it be better for each domain to be considered even if a previous failure occurred or
>>>> is this now a fixed behaviour? For illustration:
>>>
>>> I do not believe this needs to be fixed.
>>>
>>>>
>>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>>> index 62edb464410a..8e061bce9742 100644
>>>> --- a/fs/resctrl/monitor.c
>>>> +++ b/fs/resctrl/monitor.c
>>>> @@ -1248,18 +1248,25 @@ static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgro
>>>>  void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
>>>>  {
>>>>         struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>>>> +       struct rdt_l3_mon_domain *d;
>>>>
>>>>         if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r) ||
>>>>             !r->mon.mbm_assign_on_mkdir)
>>>>                 return;
>>>>
>>>> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
>>>> -               rdtgroup_assign_cntr_event(NULL, rdtgrp,
>>>> -                                          &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
>>>> +       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
>>>> +               list_for_each_entry(d, &r->mon_domains, hdr.list) {
>>>> +                       rdtgroup_assign_cntr_event(d, rdtgrp,
>>>> +                                                  &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
>>>> +               }
>>>> +       }
>>>>
>>>> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>>> -               rdtgroup_assign_cntr_event(NULL, rdtgrp,
>>>> -                                          &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
>>>> +       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
>>>> +               list_for_each_entry(d, &r->mon_domains, hdr.list) {
>>>> +                       rdtgroup_assign_cntr_event(d, rdtgrp,
>>>> +                                                  &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
>>>> +               }
>>>> +       }
>>>>  }
>>>
>>> With a solution like this last_cmd_status could potentially contain multiple lines, one
>>> line per domain that failed. last_cmd_status is 512 bytes so if this is a system with 
>>> many domains there is a risk of overflow and user space not seeing all failures.
>>> That may be ok?
>>
>> Probably but maybe we can do better. I wonder that given that we know we are trying to allocate
>> counters in all domains the information in last_cmd_status could summarize which
>> domains failed. 512 bytes isn't that large so a hex encoded bit map or something else information
>> dense would be needed. This does make last_cmd_status a bit less human readable so may not
>> be the way to go.
> 
> Indeed, at this point it becomes difficult to convey all the failures. I expect a bit more
> from user space during such scenarios though. Specifically, a user space needing to work in 
> constrained environment would be better off disabling mbm_assign_on_mkdir and manage counters
> itself or ensure there are enough counters available before creating a new monitor group.
> 
> What resctrl could do in such scenario is to at least convey that some messages were
> dropped. Consider, for example:
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5da305bd36c9..ea77fa6a38f7 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -973,10 +973,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
>  
>  	mutex_lock(&rdtgroup_mutex);
>  	len = seq_buf_used(&last_cmd_status);
> -	if (len)
> +	if (len) {
>  		seq_printf(seq, "%.*s", len, last_cmd_status_buf);
> -	else
> +		if (seq_buf_has_overflowed(&last_cmd_status))
> +			seq_puts(seq, "[truncated]\n");
> +	} else {
>  		seq_puts(seq, "ok\n");
> +	}
>  	mutex_unlock(&rdtgroup_mutex);
>  	return 0;
>  }

Adding a truncation indication makes sense to me. Would it be good to reserve space in the
last_cmd_status_buf[] to ensure this can always be displayed? It looks like space could be
made by interacting with seq->size directly but I'm not sure if there is a cleaner way
to do it.

Thanks,

Ben

> 
> 
>>
>>>
>>> I think this can be simplified within rdt_assign_cntr_event() though. Consider:
>>>
>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index 49f3f6b846b2..a6a791a15e30 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -1209,12 +1209,13 @@ static int rdtgroup_alloc_assign_cntr(struct rdt_resource *r, struct rdt_l3_mon_
>>>   * NULL; otherwise, assign the counter to the specified domain @d.
>>>   *
>>>   * If all counters in a domain are already in use, rdtgroup_alloc_assign_cntr()
>>> - * will fail. The assignment process will abort at the first failure encountered
>>> - * during domain traversal, which may result in the event being only partially
>>> - * assigned.
>>> + * will fail. Ignore errors when attempting to assign a counter to all domains
>>> + * since only some domains may have counters available and goal is to assign
>>> + * counters where possible. Only caller providing @d of NULL is
>>> + * rdtgroup_assign_cntrs() that ignores errors.
>>>   *
>>>   * Return:
>>> - * 0 on success, < 0 on failure.
>>> + * 0 on success when @d is specified, 0 always when @d is NULL, < 0 on failure.
>>>   */
>>>  static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
>>>  				      struct mon_evt *mevt)
>>> @@ -1223,11 +1224,8 @@ static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgro
>>>  	int ret = 0;
>>>  
>>>  	if (!d) {
>>> -		list_for_each_entry(d, &r->mon_domains, hdr.list) {
>>> -			ret = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
>>> -			if (ret)
>>> -				return ret;
>>> -		}
>>> +		list_for_each_entry(d, &r->mon_domains, hdr.list)
>>> +			rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
>>>  	} else {
>>>  		ret = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
>>>  	}
>>
>> That does the job but is it simpler to delete rdtgroup_assign_cntr_event()
>> and call rdtgroup_alloc_assign_cntr() directly from rdtgroup_assign_cntrs()
>> and rdtgroup_modify_assign_state() rather than special casing it further?
> 
> Yes, I agree, that would be much simpler.
> 
> Reinette
> 

