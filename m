Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8AD246D574
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 11:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038665; cv=none; b=g7EyKu7gxf1Zlsn6zGlz3U2YJDScBROHbM/oudpzg7VSto0jqKdD41jJRdp4jiNwqvNSavtjE6EVD2M8JRSmYKL+QP4deOVNYwFvBkT0EkUb5fgJi8VRmdIpz6As6Fik8MCKW/STwjZJN5r1g86/nNDBiexGHSPs6tFcwUa1tRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038665; c=relaxed/simple;
	bh=DLb/VVoHEcUTCgDzAP2laNU2OwjWumCalnEjLAmtbNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dk3RyGGLmYVmzC3VBBWpLWkj5t/EtO1uIC3qaZKc3+uUFfbDGjl9hPb64HJV4uSsSh12/dmD6nbzp/FmJgWE+/1GxSH+LPFtj+bcZk6xQHTXtzUhMSVC2AZif00BD4odMnbXKonv632Daa8jwFnTjJITDnZuT5/l1ep1frwpfDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bAmCDpbq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bAmCDpbq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94A20153B;
	Thu, 10 Sep 2026 04:10:59 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 213973F528;
	Thu, 10 Sep 2026 04:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789038663; bh=DLb/VVoHEcUTCgDzAP2laNU2OwjWumCalnEjLAmtbNc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bAmCDpbq48xdqMPhVvOPmYZWwRKW9ysrPAhwGmnBcuZwFtibaCAfujP2DoLNzW8CU
	 lzsPa4H4eAttVklisrP06W4qMnyux2KGyxZR2htar+tWhkQ+APIlqbrxl7zCycX6vE
	 xkJgWw+yHMryuCApe0t/zkupqn722183orq/n4N8=
Message-ID: <ad1f8ed5-266a-4d79-91ef-ad8ab3febfb8@arm.com>
Date: Thu, 10 Sep 2026 12:11:00 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com
Cc: tony.luck@intel.com, babu.moger@amd.com, yu.c.chen@intel.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
 <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
 <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
 <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
 <a3cf9362-007d-4c6c-8f6f-1c9b8b41b1b9@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <a3cf9362-007d-4c6c-8f6f-1c9b8b41b1b9@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 08/09/2026 22:12, Reinette Chatre wrote:
> Hi Ben,
> 
> On 9/7/26 10:01 AM, Ben Horgan wrote:
>> On 03/09/2026 16:29, Reinette Chatre wrote:
>>> On 9/2/26 9:10 AM, Ben Horgan wrote:
>>>> On 01/09/2026 00:54, Reinette Chatre wrote:
> 
> ...
> 
>>>>
>>>> 	/* class has no component for this CPU */
>>>> 	if (WARN_ON_ONCE(!ctrl_comp))
>>>> 		return ERR_PTR(-EINVAL);
>>>>
>>>>
>>>> In mpam_resctrl_alloc_domain() this initial 'ctrl_comp' check ensures that there is for the class
>>>> associated with the given resource, res, a component which includes the given cpu in its affinity
>>>
>>> Why does the monitoring require that there is a component associated with the resource as
>>> opposed to only relying on the component associated with the the monitoring class, specifically
>>> the mpam_resctrl_mon::class? (more below)
>>
>> The class associated with a resource does double duty and is also used as an indication of whether
>> the resource is in used at all, see also mpam_resctrl_online_cpu() and mpam_resctrl_offline_cpu().
>> When a resource only supports monitoring then the class providing the monitors is used for
>> res->class. As such, a check that there is a component for the given cpu, in the monitor only
> 
> Regarding "class providing the monitors": From what I can tell each monitor event is separately
> mapped to a (potentially?) different MPAM class. With MPAM supporting two events, each associated
> with a class, which of these classes are used for the class associated with the resource? 

If the l3 resource has controls as chosen by mpam_resctrl_pick_cache/mba() then that control class
is used. Otherwise, it's just the class for the event in the first call of by
mpam_resctrl_monitor_init() which is is the lowest eventid as it's in the iteration in
mpam_resctrl_setup(). If there are two events they must be QOS_L3_OCCUP_EVENT_ID and
QOS_L3_MBM_LOCAL_EVENT_ID and so by the order of iteration it's QOS_L3_OCCUP_EVENT_ID.

> 
>> resource case, is just a way to error out early when the monitoring class has no cpu. We shouldn't
>> hit this though as all monitoring classes are check that they have the same topology of the l3,
>> cover all cpus and there components correspond to l3 instances.
> 
> It seems as though there is a requirement that all the monitoring classes as well as the control
> class cover the same CPUs with the implementation flexible to support otherwise while assuming it does?

Yes... Some parts of the driver are overly flexible and so overly complicated. I hope to find some
time to make this cleaner.

> 
>>
>> The resource supports monitoring but not controls case only occurs when there are no l3 controls and
>> the condidtions for pretending the memory bandwidth counters at the memory are at the l3 are met.
>> Those conditions for pretending occur when there is single l3, a single NUMA node and no
>> intermediate caches.
>>
>>>
>>>
>>>> mask. The class is all the L3 MSC or an equivalent of the same scope, see mpam_resctrl_monitor_init().
>>>>
>>>> 	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
>>>> 	if (!dom)
>>>> 		return ERR_PTR(-ENOMEM);
>>>>
>>>> 	if (r->alloc_capable) {
>>>> 		dom->ctrl_comp = ctrl_comp;
>>>>
>>>> If the resource is alloc capable this component is used as the domain ctrl_comp.
>>>>
>>>> 		ctrl_d = &dom->resctrl_ctrl_dom;
>>>> 		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
>>>> 		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
>>>> 		err = resctrl_online_ctrl_domain(r, ctrl_d);
>>>> 		if (err)
>>>> 			goto free_domain;
>>>>
>>>> 		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>>>> 	} else {
>>>> 		pr_debug("Skipped control domain online - no controls\n");
>>>> 	}
>>>>
>>>> 	if (r->mon_capable) {
>>>> 		struct mpam_component *any_mon_comp = NULL;
>>>> 		struct mpam_resctrl_mon *mon;
>>>> 		enum resctrl_event_id eventid;
>>>>
>>>> 		/*
>>>> 		 * Even if the monitor domain is backed by a different
>>>> 		 * component, the L3 component IDs need to be used... only
>>>> 		 * there may be no ctrl_comp for the L3.
>>>> 		 * Search each event's class list for a component with
>>>> 		 * overlapping CPUs and set up the dom->mon_comp array.
>>>> 		 */
>>>> The MSC at the L3 may only have monitors and so no control component.
>>>
>>> The code that follows is:
>>>
>>>         for_each_mpam_resctrl_mon(mon, eventid) {
>>>                 struct mpam_component *mon_comp;
>>>
>>>                 if (!mon->class)
>>>                         continue;       // dummy resource
>>>
>>>                 mon_comp = find_component(mon->class, cpu);
>>>
>>> Is this find_component() perhaps sufficient by itself (without the earlier "ctrl_comp" check)
>>> to determine if there is a valid component associated with this CPU to support this
>>> monitoring feature? 
>>
>> Yes, I think is the "ctrl_comp" check is taken away but would have failed we will end up not finding
>> any relevant monitoring components.
>>
>> Although, as written it seems that it is ok for mon_comp to be NULL?
> 
> Yes. Are there scenarios under which it will be NULL? If it can be NULL, does it not
> mean that the event that was already enabled during init cannot actually be supported in all
> domains/components?
> 
>>
>> Isn't any_mon_comp the relevant thing?
> 
> (answer below)
> 
>>
>>>
>>> It is not clear to me if a mon_comp of NULL is able to handle all scenarios since it looks
>>> like mpam_resctrl_get_mon_domain_from_cpu() and mpam_resctrl_online_domain_hdr() does not
>>> consider the component at all. Would that not cause monitoring features to depend on which
>>> CPU of a domain comes online first?
>>>
>>> Could mon_comp perhaps be required to be !NULL here as a replacement for the earlier
>>> "ctrl_comp" check to ensure there is a component with the CPU in its affinity mask?
>>
>> Doesn't the !any_mon_comp check provide this?
> 
> This is the part that I do not understand since any_mon_comp seems to support the scenario
> where a mon_comp may be NULL which is a scenario that I do not think resctrl can support.

Ah, I see what you are getting at. As the monitor components are only considered when there topology
matches the l3 cache (same cpu affinity for each instance) then the find_component() call will never
fail and so mon_comp can't be NULL at this point.

> 
> At a high level there seems to be three affinity masks used by the monitoring code:
> the CPU affinity of the component belonging to the control resource class, the CPU affinity
> of each component supporting each monitoring event, while these are three separate masks with
> code sometimes treating them as though they can be different they are actually required to be the same?

Monitor component CPU affinity is enforced by topology_matches_l3() to be the same as the L3.
Additionally, traffic_matches_l3() adds extra conditions that mean that there can be considered an
uninterrupted link between l3 and memory and so an MSC at either end is effectively the same. Namely
the same restrictions I've mentioned before, only a single l3 cache, a single NUMA node and no
intermediate caches.

You list two rather than three here? Possibly you are also thinking the MSC cpu affinity which can
be different from that of the components as it indicates which cpus the MSC is reliably accessible
from. This may be a larger set of cpus than those affine to the component it controls, e.g. every
CPU if the MSC is always on and it's register interface can be reached by all the cpus.

> 
>>
>>>
>>>                 dom->mon_comp[eventid] = mon_comp;
>>>                 if (mon_comp)
>>>                         any_mon_comp = mon_comp;
>>>         }
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>> 	struct mpam_resctrl_mon_dom {
>>>>> 		struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
>>>>> 		struct rdt_l3_mon_domain	resctrl_mon_dom;
>>>>> 	}
>>>>>
>>>>> 	struct mpam_resctrl_ctrl_dom {
>>>>> 		struct mpam_component		*ctrl_comp;
>>>>> 		struct rdt_ctrl_domain		resctrl_ctrl_dom;
>>>>> 	};
>>>>
>>>> What you have looks to work for me, with some local cmax, mbw_min, mbw_max additions but with the
>>>> new layout also works. I gave it a go with this mechanical patch which uses the new layout.
>>>>
>>>> Thanks,
>>>>
>>>> Ben
>>>>
>>>> commit c67c624149474b96e07ccedda11a11ce968e5599
>>>> Author: Ben Horgan <ben.horgan@arm.com>
>>>> Date:   Tue Sep 1 17:36:29 2026 +0100
>>>>
>>>>     arm_mpam: resctrl: Separate monitor and control domain structure
>>>>
>>>> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
>>>> index 3304ef64fcae..855f06657554 100644
>>>> --- a/drivers/resctrl/mpam_internal.h
>>>> +++ b/drivers/resctrl/mpam_internal.h
>>>> @@ -393,18 +393,14 @@ struct mpam_resctrl_ctrl {
>>>>  	struct resctrl_ctrl	r_ctrl;
>>>>  };
>>>>
>>>> -struct mpam_resctrl_dom {
>>>> -	struct mpam_component		*ctrl_comp;
>>>> -
>>>> -	/*
>>>> -	 * There is no single mon_comp because different events may be backed
>>>> -	 * by different class/components. mon_comp is indexed by the event
>>>> -	 * number.
>>>> -	 */
>>>> +struct mpam_resctrl_mon_dom {
>>>>  	struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
>>>> +	struct rdt_l3_mon_domain	resctrl_mon_dom;
>>>> +};
>>>>
>>>> +struct mpam_resctrl_ctrl_dom {
>>>> +	struct mpam_component		*ctrl_comp;
>>>>  	struct rdt_ctrl_domain		resctrl_ctrl_dom;
>>>> -	struct rdt_l3_mon_domain	resctrl_mon_dom;
>>>>  };
>>>>
>>>
>>> Thank you very much for trying this out. I find this layout better since the
>>> architecture domain structure only contains those members related to the domain. 
>>> I see your snippet is based on the PoC, would you prefer I incorporate it into a new
>>> version of the PoC to get some more testing or to create a new version based on
>>> current upstream so that we can work on its upstream inclusion for the multiple
>>> controller support to build on?
>>
>> In the spirit of getting the precursors for your PoC upstream I think it would make sense to work on
>> this for upstream. Whatever you think is best for progressing multiple control support is ok with me
>> though.
> 
> I think that it will support the multiple control work if this is done upstream first.
> I will incorporate your changes in the next version ... I believe that would make you
> a co-author?

I don't think co-author is necessary as I've just offered review and you mentioned you'd already
tried out the new structures. Up to you though.

Thanks for helping with MPAM,

Ben

> 
> Thank you very much.
> 
> Reinette

