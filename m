Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDC33C5550
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 17:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788800486; cv=none; b=T718m61R42UFKYHwyEEIBf+nD546LJmHoBXGiTdXFt0+xiLP74UVUAFlQDgc+nL/MV9fPfY03sZaGyyxNCTBmJo0b7nvr4M/GY1Zd9fBxwJxRhTqBzj9M4SJTRo0Cxi6WlTxLTcUmjqP9clMfnP3lrTl1T89Qn8gMn30gj2TDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788800486; c=relaxed/simple;
	bh=U1caXaGRX85QR2DKxI/9rgzCuQzuHyAFE2Xlgp+YOB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I7OuYQElMAYrutJmXdDIxc8Y8o2x7jp2i1ymWgoZ6Pfc4ZB/bLZzDmvrows94297qfqG8tKMftdWNq9JrpP5UoXyJ479YbBqSmQCdGjm1QPm8ImD6HsVpbxUV7jsTpn4VznLPKRHZRbqqEEu1bj/5McGyu5uxnGYkZV9gR4HV4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=A7ficnbA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="A7ficnbA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B6081476;
	Mon,  7 Sep 2026 10:01:19 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06D933F528;
	Mon,  7 Sep 2026 10:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788800483; bh=U1caXaGRX85QR2DKxI/9rgzCuQzuHyAFE2Xlgp+YOB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A7ficnbAjBVG4u1+f5j2RkqXyRLvPwVM/rpcZyfqQx7tSiYHnr3CbbQDRRM0KWe/7
	 BM1yDYWZHN41SZbA9qcyPLj/XaBdy0l21RIu+a9Ylu4jjVpTkiZ11xS76lglZwyMPO
	 GULPawWYD+BI6kMrS+3gY/cUEWjP6Tv35fmgm5JI=
Message-ID: <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
Date: Mon, 7 Sep 2026 18:01:20 +0100
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
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 03/09/2026 16:29, Reinette Chatre wrote:
> Hi Ben,
> 
> On 9/2/26 9:10 AM, Ben Horgan wrote:
>> Hi Reinette,
>>
>> On 01/09/2026 00:54, Reinette Chatre wrote:
>>> A single struct mpam_resctrl_dom instance represents both an allocation and
>>> monitor domain. When a system supports allocation and monitoring a single
>>> struct mpam_resctrl_dom instance is created and then added to both the
>>> monitor and control domain lists via
>>> mpam_resctrl_dom::rdt_ctrl_domain::rdt_domain_hdr::list_head
>>> and mpam_resctrl_dom::rdt_l3_mon_domain::rdt_domain_hdr::list_head
>>> respectively.
>>>
>>> Representing both allocation and monitoring domains with a single
>>> architecture domain requires that allocation and monitoring be done at the
>>> same scope and also requires a resource to have 1:1 support for an allocation
>>> control and monitoring. The latter means that when a resource supports
>>> multiple controls for allocation of a resource, for example a "min" bandwidth
>>> control as well as a "max" bandwidth control for memory bandwidth allocation,
>>> then each domain supporting each allocation control needs a matching
>>> monitoring domain. This does not accurately represent the resource
>>> capabilities.
>>
>> For MPAM, the scope of a control is determined by where the MSC are in a system. For the MSC in the
>> L3 we collect the MSC in a cache instance and call that a component and collect those components and
>> call them a class. Similarly for other caches. The scope of a control is based on the component it
>> is in. Hence, we are unable to use all the flexibility that resctrl will offer.
> 
> Thank you very much for this insight. Although, to me the final sentence is an
> unexpected jump from the description since in my view resctrl is catching up to
> what MPAM is capable of :)
> 
>>
>> For MSC at the memory we currently only consider them for resctrl if there is only one memory
>> instance (a single NUMA node) and that this corresponds to the topology of the L3 in the system (i.e
>> only one L3 instance). This will change when NUMA scope is introduced to resctrl but for now the
>> domain associated with the MPAM component for MSC at the memory covers all the cpus and in such a
>> system there is only one L3 domain. The idea being that memory bandwidth controls at the memory are
>> effectively the same as those at L3 if only if there is only one of each and no other caches in
>> between. The initial MPAM driver put up for upstream review was more lenient than this and so the
>> tigtening up ended up leaving some complexity around that is no longer needed. I hope to simplify
>> this in the future and hopefully allow MPAM component to be used more directly to resctrl domain.
> 
> For this I think this change is helpful since it makes it clear that a resctrl
> domain is associated with an MPAM component.
> 
>>
>>>
>>> Split MPAM allocation and monitoring domain management to enable a resource
>>> to support multiple allocation controls. As an initial and knowingly
>>> inefficient approach, duplicate struct mpam_resctrl_dom between the
>>> monitoring and control lists while only initializing the relevant member
>>> structs.
>>>
>>> The goal of this conservative approach is to use something that can only
>>> be compile tested by me to learn from MPAM folks on what the best approach
>>> should be for MPAM to support multiple allocation controls.
>>>
>>> This patch is extracted from the "Generic schema description" PoC [1] that,
>>> among its various goals, aim to add support for MPAM's multiple controls
>>> to resctrl.
>>>
>>> This has only been compile tested by me but Fenghua's work to enable
>>> MPAM's CPU-less NUMA nodes [2] is using it as a baseline.
>>>
>>> I did consider a new layout as below but there seems to be a contradiction
>>> in mpam_resctrl_alloc_domain() where domain addition for allocation as well
>>> as monitoring domains unconditionally fails if there is no "ctrl_comp" while
>>> a comment when adding a monitoring domain states "there may be no ctrl_comp
>>> for the L3".
>>
>> Hmmm, confusing, but there is no real contradiction. Just some bad naming.
>>
>> Quoting the problem area:
>>
>> 	ctrl_comp = NULL;
>> 	guard(srcu)(&mpam_srcu);
>> 	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
>> 				 srcu_read_lock_held(&mpam_srcu)) {
>> 		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
>> 			ctrl_comp = comp_iter;
>> 			break;
>> 		}
>> 	}
> 
> Staring at this more above looks like an open-code of mpam_resctrl.c:find_component()?

Yes, I should clean that up.

> 
>>
>> 	/* class has no component for this CPU */
>> 	if (WARN_ON_ONCE(!ctrl_comp))
>> 		return ERR_PTR(-EINVAL);
>>
>>
>> In mpam_resctrl_alloc_domain() this initial 'ctrl_comp' check ensures that there is for the class
>> associated with the given resource, res, a component which includes the given cpu in its affinity
> 
> Why does the monitoring require that there is a component associated with the resource as
> opposed to only relying on the component associated with the the monitoring class, specifically
> the mpam_resctrl_mon::class? (more below)

The class associated with a resource does double duty and is also used as an indication of whether
the resource is in used at all, see also mpam_resctrl_online_cpu() and mpam_resctrl_offline_cpu().
When a resource only supports monitoring then the class providing the monitors is used for
res->class. As such, a check that there is a component for the given cpu, in the monitor only
resource case, is just a way to error out early when the monitoring class has no cpu. We shouldn't
hit this though as all monitoring classes are check that they have the same topology of the l3,
cover all cpus and there components correspond to l3 instances.

The resource supports monitoring but not controls case only occurs when there are no l3 controls and
the condidtions for pretending the memory bandwidth counters at the memory are at the l3 are met.
Those conditions for pretending occur when there is single l3, a single NUMA node and no
intermediate caches.

> 
> 
>> mask. The class is all the L3 MSC or an equivalent of the same scope, see mpam_resctrl_monitor_init().
>>
>> 	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
>> 	if (!dom)
>> 		return ERR_PTR(-ENOMEM);
>>
>> 	if (r->alloc_capable) {
>> 		dom->ctrl_comp = ctrl_comp;
>>
>> If the resource is alloc capable this component is used as the domain ctrl_comp.
>>
>> 		ctrl_d = &dom->resctrl_ctrl_dom;
>> 		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
>> 		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
>> 		err = resctrl_online_ctrl_domain(r, ctrl_d);
>> 		if (err)
>> 			goto free_domain;
>>
>> 		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>> 	} else {
>> 		pr_debug("Skipped control domain online - no controls\n");
>> 	}
>>
>> 	if (r->mon_capable) {
>> 		struct mpam_component *any_mon_comp = NULL;
>> 		struct mpam_resctrl_mon *mon;
>> 		enum resctrl_event_id eventid;
>>
>> 		/*
>> 		 * Even if the monitor domain is backed by a different
>> 		 * component, the L3 component IDs need to be used... only
>> 		 * there may be no ctrl_comp for the L3.
>> 		 * Search each event's class list for a component with
>> 		 * overlapping CPUs and set up the dom->mon_comp array.
>> 		 */
>> The MSC at the L3 may only have monitors and so no control component.
> 
> The code that follows is:
> 
>         for_each_mpam_resctrl_mon(mon, eventid) {
>                 struct mpam_component *mon_comp;
> 
>                 if (!mon->class)
>                         continue;       // dummy resource
> 
>                 mon_comp = find_component(mon->class, cpu);
> 
> Is this find_component() perhaps sufficient by itself (without the earlier "ctrl_comp" check)
> to determine if there is a valid component associated with this CPU to support this
> monitoring feature? 

Yes, I think is the "ctrl_comp" check is taken away but would have failed we will end up not finding
any relevant monitoring components.

Although, as written it seems that it is ok for mon_comp to be NULL?

Isn't any_mon_comp the relevant thing?

> 
> It is not clear to me if a mon_comp of NULL is able to handle all scenarios since it looks
> like mpam_resctrl_get_mon_domain_from_cpu() and mpam_resctrl_online_domain_hdr() does not
> consider the component at all. Would that not cause monitoring features to depend on which
> CPU of a domain comes online first?
> 
> Could mon_comp perhaps be required to be !NULL here as a replacement for the earlier
> "ctrl_comp" check to ensure there is a component with the CPU in its affinity mask?

Doesn't the !any_mon_comp check provide this?

> 
>                 dom->mon_comp[eventid] = mon_comp;
>                 if (mon_comp)
>                         any_mon_comp = mon_comp;
>         }
> >
>>
>>
>>
>>
>>
>>> 	struct mpam_resctrl_mon_dom {
>>> 		struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
>>> 		struct rdt_l3_mon_domain	resctrl_mon_dom;
>>> 	}
>>>
>>> 	struct mpam_resctrl_ctrl_dom {
>>> 		struct mpam_component		*ctrl_comp;
>>> 		struct rdt_ctrl_domain		resctrl_ctrl_dom;
>>> 	};
>>
>> What you have looks to work for me, with some local cmax, mbw_min, mbw_max additions but with the
>> new layout also works. I gave it a go with this mechanical patch which uses the new layout.
>>
>> Thanks,
>>
>> Ben
>>
>> commit c67c624149474b96e07ccedda11a11ce968e5599
>> Author: Ben Horgan <ben.horgan@arm.com>
>> Date:   Tue Sep 1 17:36:29 2026 +0100
>>
>>     arm_mpam: resctrl: Separate monitor and control domain structure
>>
>> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
>> index 3304ef64fcae..855f06657554 100644
>> --- a/drivers/resctrl/mpam_internal.h
>> +++ b/drivers/resctrl/mpam_internal.h
>> @@ -393,18 +393,14 @@ struct mpam_resctrl_ctrl {
>>  	struct resctrl_ctrl	r_ctrl;
>>  };
>>
>> -struct mpam_resctrl_dom {
>> -	struct mpam_component		*ctrl_comp;
>> -
>> -	/*
>> -	 * There is no single mon_comp because different events may be backed
>> -	 * by different class/components. mon_comp is indexed by the event
>> -	 * number.
>> -	 */
>> +struct mpam_resctrl_mon_dom {
>>  	struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
>> +	struct rdt_l3_mon_domain	resctrl_mon_dom;
>> +};
>>
>> +struct mpam_resctrl_ctrl_dom {
>> +	struct mpam_component		*ctrl_comp;
>>  	struct rdt_ctrl_domain		resctrl_ctrl_dom;
>> -	struct rdt_l3_mon_domain	resctrl_mon_dom;
>>  };
>>
> 
> Thank you very much for trying this out. I find this layout better since the
> architecture domain structure only contains those members related to the domain. 
> I see your snippet is based on the PoC, would you prefer I incorporate it into a new
> version of the PoC to get some more testing or to create a new version based on
> current upstream so that we can work on its upstream inclusion for the multiple
> controller support to build on?

In the spirit of getting the precursors for your PoC upstream I think it would make sense to work on
this for upstream. Whatever you think is best for progressing multiple control support is ok with me
though.

Thanks,

Ben

> 
> Thank you
> 
> Reinette

