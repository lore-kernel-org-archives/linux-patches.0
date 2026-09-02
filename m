Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850C846D2B9
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 16:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365437; cv=none; b=lH/p48heCEklTnIJfqm2YLbxtTm7oRYbcG3HJ6KVjGLEHHq3m3wUoZZ99uWl4+BtlRtzuPaebJz7RcEyXkSweEL3CroQOQDd7KJUfJNVqrX8MTiDAh659JJQgrWHCbh19V7pC5ZUPf1b1byyUotgjfvKtx2PuYD+krHo/3TfSUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365437; c=relaxed/simple;
	bh=7sKEJxzv6oWdnSG+l/bvz7wN+zpUz7CdCJvv7fb64EQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ToPafblrFgzUFUd7pVEZd+kmKCiNOIyjhX71G/+ILtvMU6x1gvKi7zWKh0vyihcL4QPkcJxRzzCoPYKSTkmubY7x+S/Pc4IQzgpCmj5w2lyR0mmC7AgO4UhzqGT3hq29UQTV01kzhbs2aLmNF1mkejhENy/UGNXFTZxgbqghTJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=En1mNkpi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="En1mNkpi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E256A165C;
	Wed,  2 Sep 2026 09:10:28 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17D4B3F882;
	Wed,  2 Sep 2026 09:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788365432; bh=7sKEJxzv6oWdnSG+l/bvz7wN+zpUz7CdCJvv7fb64EQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=En1mNkpi476gzNKoeJHAipyjHm7WppfgeZlgpffTMxqy+Oa8xwR13SdKrPNm+Z6U4
	 Ly7/LVOEslRRJI1aLzp8BffO0tsc1QuwAJN4R75+iQsr0g1dRhHlVWgZhWWxM57sBq
	 TjI+kq/dUM9YmGKvc7WM4E7yT4FcDPrd5oEnselg=
Message-ID: <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
Date: Wed, 2 Sep 2026 17:10:29 +0100
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
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 01/09/2026 00:54, Reinette Chatre wrote:
> A single struct mpam_resctrl_dom instance represents both an allocation and
> monitor domain. When a system supports allocation and monitoring a single
> struct mpam_resctrl_dom instance is created and then added to both the
> monitor and control domain lists via
> mpam_resctrl_dom::rdt_ctrl_domain::rdt_domain_hdr::list_head
> and mpam_resctrl_dom::rdt_l3_mon_domain::rdt_domain_hdr::list_head
> respectively.
> 
> Representing both allocation and monitoring domains with a single
> architecture domain requires that allocation and monitoring be done at the
> same scope and also requires a resource to have 1:1 support for an allocation
> control and monitoring. The latter means that when a resource supports
> multiple controls for allocation of a resource, for example a "min" bandwidth
> control as well as a "max" bandwidth control for memory bandwidth allocation,
> then each domain supporting each allocation control needs a matching
> monitoring domain. This does not accurately represent the resource
> capabilities.

For MPAM, the scope of a control is determined by where the MSC are in a system. For the MSC in the
L3 we collect the MSC in a cache instance and call that a component and collect those components and
call them a class. Similarly for other caches. The scope of a control is based on the component it
is in. Hence, we are unable to use all the flexibility that resctrl will offer.

For MSC at the memory we currently only consider them for resctrl if there is only one memory
instance (a single NUMA node) and that this corresponds to the topology of the L3 in the system (i.e
only one L3 instance). This will change when NUMA scope is introduced to resctrl but for now the
domain associated with the MPAM component for MSC at the memory covers all the cpus and in such a
system there is only one L3 domain. The idea being that memory bandwidth controls at the memory are
effectively the same as those at L3 if only if there is only one of each and no other caches in
between. The initial MPAM driver put up for upstream review was more lenient than this and so the
tigtening up ended up leaving some complexity around that is no longer needed. I hope to simplify
this in the future and hopefully allow MPAM component to be used more directly to resctrl domain.

> 
> Split MPAM allocation and monitoring domain management to enable a resource
> to support multiple allocation controls. As an initial and knowingly
> inefficient approach, duplicate struct mpam_resctrl_dom between the
> monitoring and control lists while only initializing the relevant member
> structs.
> 
> The goal of this conservative approach is to use something that can only
> be compile tested by me to learn from MPAM folks on what the best approach
> should be for MPAM to support multiple allocation controls.
> 
> This patch is extracted from the "Generic schema description" PoC [1] that,
> among its various goals, aim to add support for MPAM's multiple controls
> to resctrl.
> 
> This has only been compile tested by me but Fenghua's work to enable
> MPAM's CPU-less NUMA nodes [2] is using it as a baseline.
> 
> I did consider a new layout as below but there seems to be a contradiction
> in mpam_resctrl_alloc_domain() where domain addition for allocation as well
> as monitoring domains unconditionally fails if there is no "ctrl_comp" while
> a comment when adding a monitoring domain states "there may be no ctrl_comp
> for the L3".

Hmmm, confusing, but there is no real contradiction. Just some bad naming.

Quoting the problem area:

	ctrl_comp = NULL;
	guard(srcu)(&mpam_srcu);
	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
				 srcu_read_lock_held(&mpam_srcu)) {
		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
			ctrl_comp = comp_iter;
			break;
		}
	}

	/* class has no component for this CPU */
	if (WARN_ON_ONCE(!ctrl_comp))
		return ERR_PTR(-EINVAL);


In mpam_resctrl_alloc_domain() this initial 'ctrl_comp' check ensures that there is for the class
associated with the given resource, res, a component which includes the given cpu in its affinity
mask. The class is all the L3 MSC or an equivalent of the same scope, see mpam_resctrl_monitor_init().

	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
	if (!dom)
		return ERR_PTR(-ENOMEM);

	if (r->alloc_capable) {
		dom->ctrl_comp = ctrl_comp;

If the resource is alloc capable this component is used as the domain ctrl_comp.

		ctrl_d = &dom->resctrl_ctrl_dom;
		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
		err = resctrl_online_ctrl_domain(r, ctrl_d);
		if (err)
			goto free_domain;

		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
	} else {
		pr_debug("Skipped control domain online - no controls\n");
	}

	if (r->mon_capable) {
		struct mpam_component *any_mon_comp = NULL;
		struct mpam_resctrl_mon *mon;
		enum resctrl_event_id eventid;

		/*
		 * Even if the monitor domain is backed by a different
		 * component, the L3 component IDs need to be used... only
		 * there may be no ctrl_comp for the L3.
		 * Search each event's class list for a component with
		 * overlapping CPUs and set up the dom->mon_comp array.
		 */
The MSC at the L3 may only have monitors and so no control component.





> 	struct mpam_resctrl_mon_dom {
> 		struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
> 		struct rdt_l3_mon_domain	resctrl_mon_dom;
> 	}
> 
> 	struct mpam_resctrl_ctrl_dom {
> 		struct mpam_component		*ctrl_comp;
> 		struct rdt_ctrl_domain		resctrl_ctrl_dom;
> 	};

What you have looks to work for me, with some local cmax, mbw_min, mbw_max additions but with the
new layout also works. I gave it a go with this mechanical patch which uses the new layout.

Thanks,

Ben

commit c67c624149474b96e07ccedda11a11ce968e5599
Author: Ben Horgan <ben.horgan@arm.com>
Date:   Tue Sep 1 17:36:29 2026 +0100

    arm_mpam: resctrl: Separate monitor and control domain structure

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 3304ef64fcae..855f06657554 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -393,18 +393,14 @@ struct mpam_resctrl_ctrl {
 	struct resctrl_ctrl	r_ctrl;
 };

-struct mpam_resctrl_dom {
-	struct mpam_component		*ctrl_comp;
-
-	/*
-	 * There is no single mon_comp because different events may be backed
-	 * by different class/components. mon_comp is indexed by the event
-	 * number.
-	 */
+struct mpam_resctrl_mon_dom {
 	struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
+	struct rdt_l3_mon_domain	resctrl_mon_dom;
+};

+struct mpam_resctrl_ctrl_dom {
+	struct mpam_component		*ctrl_comp;
 	struct rdt_ctrl_domain		resctrl_ctrl_dom;
-	struct rdt_l3_mon_domain	resctrl_mon_dom;
 };

 struct mpam_resctrl_res {
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index faaa390ac5bf..9a198f71bac8 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -516,7 +516,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
 			   void *arch_priv, u64 *val, void *arch_mon_ctx)
 {
-	struct mpam_resctrl_dom *l3_dom;
+	struct mpam_resctrl_mon_dom *l3_dom;
 	struct mpam_component *mon_comp;
 	u32 mon_idx = *(u32 *)arch_mon_ctx;
 	enum mpam_device_features mon_type;
@@ -530,7 +530,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	if (eventid >= QOS_NUM_EVENTS || !mon->class)
 		return -EINVAL;

-	l3_dom = container_of(hdr, struct mpam_resctrl_dom, resctrl_mon_dom.hdr);
+	l3_dom = container_of(hdr, struct mpam_resctrl_mon_dom, resctrl_mon_dom.hdr);
 	mon_comp = l3_dom->mon_comp[eventid];

 	if (eventid != QOS_L3_OCCUP_EVENT_ID)
@@ -1316,7 +1316,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
 	struct mpam_config *cfg;
 	struct mpam_props *cprops;
 	struct mpam_resctrl_res *res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 	enum mpam_device_features configured_by;

 	lockdep_assert_cpus_held();
@@ -1325,7 +1325,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
 		return resctrl_get_default_ctrlval(ctrl);

 	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
-	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
+	dom = container_of(d, struct mpam_resctrl_ctrl_dom, resctrl_ctrl_dom);
 	cprops = &res->class->props;

 	/*
@@ -1399,7 +1399,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
 	struct mpam_config cfg;
 	struct mpam_props *cprops;
 	struct mpam_resctrl_res *res;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;

 	lockdep_assert_cpus_held();
 	lockdep_assert_irqs_enabled();
@@ -1412,7 +1412,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct resctrl_ctrl *ctrl,
 	 * resctrl_arch_update_domains() relies on this.
 	 */
 	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
-	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
+	dom = container_of(d, struct mpam_resctrl_ctrl_dom, resctrl_ctrl_dom);
 	cprops = &res->class->props;

 	if (mpam_resctrl_hide_cdp(r))
@@ -1626,12 +1626,12 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
 	return NULL;
 }

-static struct mpam_resctrl_dom *
+static struct mpam_resctrl_ctrl_dom *
 mpam_resctrl_alloc_ctrl_domain(unsigned int cpu, struct mpam_resctrl_res *res,
 			       struct resctrl_ctrl *ctrl)
 {
 	int err;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;
 	struct rdt_ctrl_domain *ctrl_d;
 	struct mpam_class *class = res->class;
 	struct mpam_component *comp_iter, *ctrl_comp;
@@ -1680,11 +1680,11 @@ mpam_resctrl_alloc_ctrl_domain(unsigned int cpu, struct mpam_resctrl_res *res,
 	return dom;
 }

-static struct mpam_resctrl_dom *
+static struct mpam_resctrl_mon_dom *
 mpam_resctrl_alloc_mon_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 {
 	int err;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_mon_dom *dom;
 	struct rdt_l3_mon_domain *mon_d;
 	struct mpam_class *class = res->class;
 	struct mpam_component *comp_iter, *ctrl_comp;
@@ -1766,11 +1766,11 @@ mpam_resctrl_alloc_mon_domain(unsigned int cpu, struct mpam_resctrl_res *res)
  * This relies on mpam_resctrl_pick_domain_id() using the L3 cache-id
  * for anything that is not a cache.
  */
-static struct mpam_resctrl_dom *
+static struct mpam_resctrl_mon_dom *
 mpam_resctrl_get_mon_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 {
 	int cache_id;
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_mon_dom *dom;
 	struct rdt_resource *r = &res->resctrl_res;

 	lockdep_assert_cpus_held();
@@ -1792,10 +1792,10 @@ mpam_resctrl_get_mon_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
 	return NULL;
 }

-static struct mpam_resctrl_dom *
+static struct mpam_resctrl_ctrl_dom *
 mpam_resctrl_get_ctrl_domain_from_cpu(int cpu, struct resctrl_ctrl *ctrl)
 {
-	struct mpam_resctrl_dom *dom;
+	struct mpam_resctrl_ctrl_dom *dom;

 	lockdep_assert_cpus_held();

@@ -1814,7 +1814,6 @@ int mpam_resctrl_online_cpu(unsigned int cpu)

 	guard(mutex)(&domain_list_lock);
 	for_each_mpam_resctrl_control(res, rid) {
-		struct mpam_resctrl_dom *dom;
 		struct rdt_resource *r = &res->resctrl_res;
 		struct resctrl_ctrl *ctrl;

@@ -1822,27 +1821,32 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 			continue;	// dummy_resource;

 		if (r->alloc_capable) {
+			struct mpam_resctrl_ctrl_dom *ctrl_dom;
+
 			for_each_resource_ctrl(ctrl, r) {
-				dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, ctrl);
-				if (!dom) {
-					dom = mpam_resctrl_alloc_ctrl_domain(cpu, res, ctrl);
-					if (IS_ERR(dom))
-						return PTR_ERR(dom);
+				ctrl_dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, ctrl);
+				if (!ctrl_dom) {
+					ctrl_dom = mpam_resctrl_alloc_ctrl_domain(cpu, res, ctrl);
+					if (IS_ERR(ctrl_dom))
+						return PTR_ERR(ctrl_dom);
 				} else {
-					struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
+					struct rdt_ctrl_domain *ctrl_d;

+					ctrl_d = &ctrl_dom->resctrl_ctrl_dom;
 					mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
 				}
 			}
 		}
 		if (r->mon_capable) {
-			dom = mpam_resctrl_get_mon_domain_from_cpu(cpu, res);
-			if (!dom) {
-				dom = mpam_resctrl_alloc_mon_domain(cpu, res);
-				if (IS_ERR(dom))
-					return PTR_ERR(dom);
+			struct mpam_resctrl_mon_dom *mon_dom;
+
+			mon_dom = mpam_resctrl_get_mon_domain_from_cpu(cpu, res);
+			if (!mon_dom) {
+				mon_dom = mpam_resctrl_alloc_mon_domain(cpu, res);
+				if (IS_ERR(mon_dom))
+					return PTR_ERR(mon_dom);
 			} else {
-				struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
+				struct rdt_l3_mon_domain *mon_d = &mon_dom->resctrl_mon_dom;

 				mpam_resctrl_online_domain_hdr(cpu, &mon_d->hdr);
 			}
@@ -1863,7 +1867,6 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)

 	guard(mutex)(&domain_list_lock);
 	for_each_mpam_resctrl_control(res, rid) {
-		struct mpam_resctrl_dom *dom;
 		struct rdt_l3_mon_domain *mon_d;
 		struct rdt_ctrl_domain *ctrl_d;
 		struct resctrl_ctrl *ctrl;
@@ -1874,28 +1877,32 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 			continue;	// dummy resource

 		if (r->alloc_capable) {
+			struct mpam_resctrl_ctrl_dom *ctrl_dom;
+
 			for_each_resource_ctrl(ctrl, r) {
-				dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, ctrl);
-				if (WARN_ON_ONCE(!dom))
+				ctrl_dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, ctrl);
+				if (WARN_ON_ONCE(!ctrl_dom))
 					continue;
-				ctrl_d = &dom->resctrl_ctrl_dom;
+				ctrl_d = &ctrl_dom->resctrl_ctrl_dom;
 				dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
 				if (dom_empty) {
 					resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl, ctrl_d);
-					kfree(dom);
+					kfree(ctrl_dom);
 				}
 			}
 		}

 		if (r->mon_capable) {
-			dom = mpam_resctrl_get_mon_domain_from_cpu(cpu, res);
-			if (WARN_ON_ONCE(!dom))
+			struct mpam_resctrl_mon_dom *mon_dom;
+
+			mon_dom = mpam_resctrl_get_mon_domain_from_cpu(cpu, res);
+			if (WARN_ON_ONCE(!mon_dom))
 				continue;
-			mon_d = &dom->resctrl_mon_dom;
+			mon_d = &mon_dom->resctrl_mon_dom;
 			dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
 			if (dom_empty) {
 				resctrl_offline_mon_domain(&res->resctrl_res, &mon_d->hdr);
-				kfree(dom);
+				kfree(mon_dom);
 			}
 		}
 	}

> 
> Any feedback is appreciated.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Link: https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/ # [1]
> Link: https://lore.kernel.org/lkml/20260831172245.42253-1-fenghuay@nvidia.com/ # [2]
> ---
> - Extracted from "generic schema description"
>   https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/
> 
> Changes since extract from PoC:
> - Rebased on v7.3-rc1
> - Re-wrote changelog
> - Return NULL instead of ERR_PTR() when searching for monitoring domain
>   to ensure the if (!dom) check works.
> ---
>  drivers/resctrl/mpam_resctrl.c | 207 +++++++++++++++++++--------------
>  1 file changed, 121 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 9d223057953a..c888773f3d03 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1616,11 +1616,10 @@ static struct mpam_component *find_component(struct mpam_class *class, int cpu)
>  }
>  
>  static struct mpam_resctrl_dom *
> -mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
> +mpam_resctrl_alloc_ctrl_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  {
>  	int err;
>  	struct mpam_resctrl_dom *dom;
> -	struct rdt_l3_mon_domain *mon_d;
>  	struct rdt_ctrl_domain *ctrl_d;
>  	struct mpam_class *class = res->class;
>  	struct mpam_component *comp_iter, *ctrl_comp;
> @@ -1628,6 +1627,9 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  
>  	lockdep_assert_held(&domain_list_lock);
>  
> +	if (!r->alloc_capable)
> +		return ERR_PTR(-EINVAL);
> +
>  	ctrl_comp = NULL;
>  	guard(srcu)(&mpam_srcu);
>  	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
> @@ -1646,70 +1648,97 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	if (!dom)
>  		return ERR_PTR(-ENOMEM);
>  
> -	if (r->alloc_capable) {
> -		dom->ctrl_comp = ctrl_comp;
> +	dom->ctrl_comp = ctrl_comp;
>  
> -		ctrl_d = &dom->resctrl_ctrl_dom;
> -		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
> -		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
> -		err = resctrl_online_ctrl_domain(r, ctrl_d);
> -		if (err)
> -			goto free_domain;
> +	ctrl_d = &dom->resctrl_ctrl_dom;
> +	mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
> +	ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
> +	err = resctrl_online_ctrl_domain(r, ctrl_d);
> +	if (err)
> +		goto free_domain;
>  
> -		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
> -	} else {
> -		pr_debug("Skipped control domain online - no controls\n");
> -	}
> +	mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>  
> -	if (r->mon_capable) {
> -		struct mpam_component *any_mon_comp = NULL;
> -		struct mpam_resctrl_mon *mon;
> -		enum resctrl_event_id eventid;
> +	return dom;
>  
> -		/*
> -		 * Even if the monitor domain is backed by a different
> -		 * component, the L3 component IDs need to be used... only
> -		 * there may be no ctrl_comp for the L3.
> -		 * Search each event's class list for a component with
> -		 * overlapping CPUs and set up the dom->mon_comp array.
> -		 */
> +free_domain:
> +	kfree(dom);
> +	dom = ERR_PTR(err);
> +
> +	return dom;
> +}
> +
> +static struct mpam_resctrl_dom *
> +mpam_resctrl_alloc_mon_domain(unsigned int cpu, struct mpam_resctrl_res *res)
> +{
> +	int err;
> +	struct mpam_resctrl_dom *dom;
> +	struct rdt_l3_mon_domain *mon_d;
> +	struct mpam_class *class = res->class;
> +	struct mpam_component *comp_iter, *ctrl_comp;
> +	struct rdt_resource *r = &res->resctrl_res;
> +	struct mpam_component *any_mon_comp = NULL;
> +	struct mpam_resctrl_mon *mon;
> +	enum resctrl_event_id eventid;
>  
> -		for_each_mpam_resctrl_mon(mon, eventid) {
> -			struct mpam_component *mon_comp;
> +	lockdep_assert_held(&domain_list_lock);
>  
> -			if (!mon->class)
> -				continue;       // dummy resource
> +	if (!r->mon_capable)
> +		return ERR_PTR(-EINVAL);
>  
> -			mon_comp = find_component(mon->class, cpu);
> -			dom->mon_comp[eventid] = mon_comp;
> -			if (mon_comp)
> -				any_mon_comp = mon_comp;
> -		}
> -		if (!any_mon_comp) {
> -			WARN_ON_ONCE(0);
> -			err = -EFAULT;
> -			goto offline_ctrl_domain;
> +	ctrl_comp = NULL;
> +	guard(srcu)(&mpam_srcu);
> +	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
> +				 srcu_read_lock_held(&mpam_srcu)) {
> +		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
> +			ctrl_comp = comp_iter;
> +			break;
>  		}
> +	}
>  
> -		mon_d = &dom->resctrl_mon_dom;
> -		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
> -		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
> -		err = resctrl_online_mon_domain(r, &mon_d->hdr);
> -		if (err)
> -			goto offline_ctrl_domain;
> +	/* class has no component for this CPU */
> +	if (WARN_ON_ONCE(!ctrl_comp))
> +		return ERR_PTR(-EINVAL);
>  
> -		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
> -	} else {
> -		pr_debug("Skipped monitor domain online - no monitors\n");
> +	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!dom)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/*
> +	 * Even if the monitor domain is backed by a different
> +	 * component, the L3 component IDs need to be used... only
> +	 * there may be no ctrl_comp for the L3.
> +	 * Search each event's class list for a component with
> +	 * overlapping CPUs and set up the dom->mon_comp array.
> +	 */
> +	for_each_mpam_resctrl_mon(mon, eventid) {
> +		struct mpam_component *mon_comp;
> +
> +		if (!mon->class)
> +			continue;       // dummy resource
> +
> +		mon_comp = find_component(mon->class, cpu);
> +		dom->mon_comp[eventid] = mon_comp;
> +		if (mon_comp)
> +			any_mon_comp = mon_comp;
>  	}
> +	if (!any_mon_comp) {
> +		WARN_ON_ONCE(0);
> +		err = -EFAULT;
> +		goto free_domain;
> +	}
> +
> +	mon_d = &dom->resctrl_mon_dom;
> +	mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
> +	mon_d->hdr.type = RESCTRL_MON_DOMAIN;
> +	err = resctrl_online_mon_domain(r, &mon_d->hdr);
> +	if (err)
> +		goto free_domain;
> +
> +	mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
>  
>  	return dom;
>  
> -offline_ctrl_domain:
> -	if (r->alloc_capable) {
> -		mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> -		resctrl_offline_ctrl_domain(r, ctrl_d);
> -	}
>  free_domain:
>  	kfree(dom);
>  	dom = ERR_PTR(err);
> @@ -1724,21 +1753,25 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>   * This relies on mpam_resctrl_pick_domain_id() using the L3 cache-id
>   * for anything that is not a cache.
>   */
> -static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
> +static struct mpam_resctrl_dom *
> +mpam_resctrl_get_mon_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
>  {
>  	int cache_id;
>  	struct mpam_resctrl_dom *dom;
> -	struct mpam_resctrl_res *l3 = &mpam_resctrl_controls[RDT_RESOURCE_L3];
> +	struct rdt_resource *r = &res->resctrl_res;
>  
>  	lockdep_assert_cpus_held();
>  
> -	if (!l3->class)
> +	if (r->rid != RDT_RESOURCE_L3)
> +		return NULL;
> +
> +	if (!res->class)
>  		return NULL;
>  	cache_id = get_cpu_cacheinfo_id(cpu, 3);
>  	if (cache_id < 0)
>  		return NULL;
>  
> -	list_for_each_entry_rcu(dom, &l3->resctrl_res.mon_domains, resctrl_mon_dom.hdr.list) {
> +	list_for_each_entry_rcu(dom, &res->resctrl_res.mon_domains, resctrl_mon_dom.hdr.list) {
>  		if (dom->resctrl_mon_dom.hdr.id == cache_id)
>  			return dom;
>  	}
> @@ -1747,7 +1780,7 @@ static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
>  }
>  
>  static struct mpam_resctrl_dom *
> -mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
> +mpam_resctrl_get_ctrl_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
>  {
>  	struct mpam_resctrl_dom *dom;
>  	struct rdt_resource *r = &res->resctrl_res;
> @@ -1759,11 +1792,7 @@ mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
>  			return dom;
>  	}
>  
> -	if (r->rid != RDT_RESOURCE_L3)
> -		return NULL;
> -
> -	/* Search the mon domain list too - needed on monitor only platforms. */
> -	return mpam_resctrl_get_mon_domain_from_cpu(cpu);
> +	return NULL;
>  }
>  
>  int mpam_resctrl_online_cpu(unsigned int cpu)
> @@ -1779,18 +1808,25 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
>  		if (!res->class)
>  			continue;	// dummy_resource;
>  
> -		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> -		if (!dom) {
> -			dom = mpam_resctrl_alloc_domain(cpu, res);
> -			if (IS_ERR(dom))
> -				return PTR_ERR(dom);
> -		} else {
> -			if (r->alloc_capable) {
> +		if (r->alloc_capable) {
> +			dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, res);
> +			if (!dom) {
> +				dom = mpam_resctrl_alloc_ctrl_domain(cpu, res);
> +				if (IS_ERR(dom))
> +					return PTR_ERR(dom);
> +			} else {
>  				struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
>  
>  				mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
>  			}
> -			if (r->mon_capable) {
> +		}
> +		if (r->mon_capable) {
> +			dom = mpam_resctrl_get_mon_domain_from_cpu(cpu, res);
> +			if (!dom) {
> +				dom = mpam_resctrl_alloc_mon_domain(cpu, res);
> +				if (IS_ERR(dom))
> +					return PTR_ERR(dom);
> +			} else {
>  				struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
>  
>  				mpam_resctrl_online_domain_hdr(cpu, &mon_d->hdr);
> @@ -1815,36 +1851,35 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
>  		struct mpam_resctrl_dom *dom;
>  		struct rdt_l3_mon_domain *mon_d;
>  		struct rdt_ctrl_domain *ctrl_d;
> -		bool ctrl_dom_empty, mon_dom_empty;
> +		bool dom_empty;
>  		struct rdt_resource *r = &res->resctrl_res;
>  
>  		if (!res->class)
>  			continue;	// dummy resource
>  
> -		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> -		if (WARN_ON_ONCE(!dom))
> -			continue;
> -
>  		if (r->alloc_capable) {
> +			dom = mpam_resctrl_get_ctrl_domain_from_cpu(cpu, res);
> +			if (WARN_ON_ONCE(!dom))
> +				continue;
>  			ctrl_d = &dom->resctrl_ctrl_dom;
> -			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> -			if (ctrl_dom_empty)
> +			dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> +			if (dom_empty) {
>  				resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl_d);
> -		} else {
> -			ctrl_dom_empty = true;
> +				kfree(dom);
> +			}
>  		}
>  
>  		if (r->mon_capable) {
> +			dom = mpam_resctrl_get_mon_domain_from_cpu(cpu, res);
> +			if (WARN_ON_ONCE(!dom))
> +				continue;
>  			mon_d = &dom->resctrl_mon_dom;
> -			mon_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
> -			if (mon_dom_empty)
> +			dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
> +			if (dom_empty) {
>  				resctrl_offline_mon_domain(&res->resctrl_res, &mon_d->hdr);
> -		} else {
> -			mon_dom_empty = true;
> +				kfree(dom);
> +			}
>  		}
> -
> -		if (ctrl_dom_empty && mon_dom_empty)
> -			kfree(dom);
>  	}
>  }
>  

