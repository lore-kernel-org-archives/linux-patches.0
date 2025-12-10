Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73602F49F7
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408481; cv=none; b=W6FYi3ZH98Z22xZtPutT/R3ycniJOWpN+h4gK1urzP9WYlb7KjGoAQAiIJeZ489clOmkcm0OgrRTOW4q8JjWXe60Rxh8T7fePzKpy3tLaMQtSMbwCYVISjGwC0NWUjEOyfCkV85t8Fap6jhjqe5OzhR1SBk6DuIrMjtHsweJ840=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408481; c=relaxed/simple;
	bh=i3pJuukre5TrcwUrPSMBDI2HLkMgDtySD77ogVHDiRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUAUsHDTGDuDj9ZJccUaZMTCLZdIw/ZHnXMQktBW0ovs3BnLFGIxPuHam3uWq3xlJSBy5o6gHxJCmxtxu2GMMcMEQbTpRTOqGDiG9iw0zgCvGkSvVb8leGtAnh8BpBZ/6R11imYyglq4lrSBZv/ACV4PaHcAswjHwZjtxcYvOCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJyfbWRy; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJyfbWRy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408478; x=1796944478;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i3pJuukre5TrcwUrPSMBDI2HLkMgDtySD77ogVHDiRI=;
  b=HJyfbWRyjKgYPGsmATR8x0uBNXASL0UOhEOuARujJEkOLSGENxKot6Nc
   hWX/gpsgaBUQzq+1oFZzmSOEPVH7tNhoOKsap/Nvj8D66joteWwK9QEOi
   pxhA7dYNiSTF4pymK+xySBVH8dOyB64Z5naGv6PdbNbnwfmL79/t/qeYC
   w8gA2t01G8qoKVKxyFL9H7bMZmXvw10dc05DGWEMTsohmJ1g7w21HyBec
   22y3fz3JekorWK+1Uq1W55lI6RJaFijvEXVJIRdBdHLBKD6nfJkAMso5e
   qqUbbSxtNcnvnSRVjyFQ11LHZcPk8tG4wdbFZNdus01/6kf0ULCtXfxVC
   Q==;
X-CSE-ConnectionGUID: 3By7u+wBQXWeK1TsShe7Nw==
X-CSE-MsgGUID: K6Zig8WST/utXX2rGzjZ6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973532"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973532"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:28 -0800
X-CSE-ConnectionGUID: lbyneMkkQvKzPIzL+TPT8Q==
X-CSE-MsgGUID: NFwP6i/YS/KqGiMnYJ6tKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297052"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:28 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v16 07/32] x86,fs/resctrl: Use struct rdt_domain_hdr when reading counters
Date: Wed, 10 Dec 2025 15:13:46 -0800
Message-ID: <20251210231413.59102-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the whole call sequence from mon_event_read() to resctrl_arch_rmid_read() to
pass resource independent struct rdt_domain_hdr instead of an L3 specific domain
structure to prepare for monitoring events in other resources.

This additional layer of indirection obscures which aspects of event counting depend
on a valid domain. Event initialization, support for assignable counters, and normal
event counting implicitly depend on a valid domain while summing of domains does not.
Split summing domains from the core event counting handling to make their respective
dependencies obvious.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h               |  4 +-
 fs/resctrl/internal.h                 | 18 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c | 12 +++-
 fs/resctrl/ctrlmondata.c              |  9 +--
 fs/resctrl/monitor.c                  | 85 ++++++++++++++++++---------
 5 files changed, 78 insertions(+), 50 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 5db37c7e89c5..9b9877fb3238 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -517,7 +517,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
  * @r:			resource that the counter should be read from.
- * @d:			domain that the counter should be read from.
+ * @hdr:		Header of domain that the counter should be read from.
  * @closid:		closid that matches the rmid. Depending on the architecture, the
  *			counter may match traffic of both @closid and @rmid, or @rmid
  *			only.
@@ -538,7 +538,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * Return:
  * 0 on success, or -EIO, -EINVAL etc on error.
  */
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *arch_mon_ctx);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 5e52269b391e..9912b774a580 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -106,24 +106,26 @@ struct mon_data {
  *	   resource group then its event count is summed with the count from all
  *	   its child resource groups.
  * @r:	   Resource describing the properties of the event being read.
- * @d:	   Domain that the counter should be read from. If NULL then sum all
- *	   domains in @r sharing L3 @ci.id
+ * @hdr:   Header of domain that the counter should be read from. If NULL then
+ *	   sum all domains in @r sharing L3 @ci.id
  * @evtid: Which monitor event to read.
  * @first: Initialize MBM counter when true.
- * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
+ * @ci:    Cacheinfo for L3. Only set when @hdr is NULL. Used when summing
+ *	   domains.
  * @is_mbm_cntr: true if "mbm_event" counter assignment mode is enabled and it
  *	   is an MBM event.
  * @err:   Error encountered when reading counter.
- * @val:   Returned value of event counter. If @rgrp is a parent resource group,
- *	   @val includes the sum of event counts from its child resource groups.
- *	   If @d is NULL, @val includes the sum of all domains in @r sharing @ci.id,
- *	   (summed across child resource groups if @rgrp is a parent resource group).
+ * @val:   Returned value of event counter. If @rgrp is a parent resource
+ *	   group, @val includes the sum of event counts from its child
+ *	   resource groups.  If @hdr is NULL, @val includes the sum of all
+ *	   domains in @r sharing @ci.id, (summed across child resource groups
+ *	   if @rgrp is a parent resource group).
  * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only).
  */
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
-	struct rdt_mon_domain	*d;
+	struct rdt_domain_hdr	*hdr;
 	enum resctrl_event_id	evtid;
 	bool			first;
 	struct cacheinfo	*ci;
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index dffcc8307500..3da970ea1903 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -238,19 +238,25 @@ static u64 get_corrected_val(struct rdt_resource *r, struct rdt_mon_domain *d,
 	return chunks * hw_res->mon_scale;
 }
 
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *ignored)
 {
-	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
-	int cpu = cpumask_any(&d->hdr.cpu_mask);
+	struct rdt_hw_mon_domain *hw_dom;
 	struct arch_mbm_state *am;
+	struct rdt_mon_domain *d;
 	u64 msr_val;
 	u32 prmid;
+	int cpu;
 	int ret;
 
 	resctrl_arch_rmid_read_context_check();
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return -EINVAL;
 
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	hw_dom = resctrl_to_arch_mon_dom(d);
+	cpu = cpumask_any(&hdr->cpu_mask);
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 	ret = __rmid_read_phys(prmid, eventid, &msr_val);
 
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 3154cdc98a31..9242a2982e77 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -554,25 +554,18 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first)
 {
-	struct rdt_mon_domain *d = NULL;
 	int cpu;
 
 	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
-	if (hdr) {
-		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-			return;
-		d = container_of(hdr, struct rdt_mon_domain, hdr);
-	}
-
 	/*
 	 * Setup the parameters to pass to mon_event_count() to read the data.
 	 */
 	rr->rgrp = rdtgrp;
 	rr->evtid = evtid;
 	rr->r = r;
-	rr->d = d;
+	rr->hdr = hdr;
 	rr->first = first;
 	if (resctrl_arch_mbm_cntr_assign_enabled(r) &&
 	    resctrl_is_mbm_event(evtid)) {
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index b5e0db38c8bf..e1c12201388f 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -159,7 +159,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
 			break;
 
 		entry = __rmid_entry(idx);
-		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
+		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
 					   QOS_L3_OCCUP_EVENT_ID, &val,
 					   arch_mon_ctx)) {
 			rmid_dirty = true;
@@ -421,11 +421,16 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	struct rdt_mon_domain *d;
 	int cntr_id = -ENOENT;
 	struct mbm_state *m;
-	int err, ret;
 	u64 tval = 0;
 
+	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)) {
+		rr->err = -EIO;
+		return -EINVAL;
+	}
+	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+
 	if (rr->is_mbm_cntr) {
-		cntr_id = mbm_cntr_get(rr->r, rr->d, rdtgrp, rr->evtid);
+		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
 		if (cntr_id < 0) {
 			rr->err = -ENOENT;
 			return -EINVAL;
@@ -434,31 +439,50 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 
 	if (rr->first) {
 		if (rr->is_mbm_cntr)
-			resctrl_arch_reset_cntr(rr->r, rr->d, closid, rmid, cntr_id, rr->evtid);
+			resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evtid);
 		else
-			resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
-		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+			resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
+		m = get_mbm_state(d, closid, rmid, rr->evtid);
 		if (m)
 			memset(m, 0, sizeof(struct mbm_state));
 		return 0;
 	}
 
-	if (rr->d) {
-		/* Reading a single domain, must be on a CPU in that domain. */
-		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
-			return -EINVAL;
-		if (rr->is_mbm_cntr)
-			rr->err = resctrl_arch_cntr_read(rr->r, rr->d, closid, rmid, cntr_id,
-							 rr->evtid, &tval);
-		else
-			rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
-							 rr->evtid, &tval, rr->arch_mon_ctx);
-		if (rr->err)
-			return rr->err;
+	/* Reading a single domain, must be on a CPU in that domain. */
+	if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
+		return -EINVAL;
+	if (rr->is_mbm_cntr)
+		rr->err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
+						 rr->evtid, &tval);
+	else
+		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
+						 rr->evtid, &tval, rr->arch_mon_ctx);
+	if (rr->err)
+		return rr->err;
 
-		rr->val += tval;
+	rr->val += tval;
 
-		return 0;
+	return 0;
+}
+
+static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+{
+	int cpu = smp_processor_id();
+	u32 closid = rdtgrp->closid;
+	u32 rmid = rdtgrp->mon.rmid;
+	struct rdt_mon_domain *d;
+	u64 tval = 0;
+	int err, ret;
+
+	/*
+	 * Summing across domains is only done for systems that implement
+	 * Sub-NUMA Cluster. There is no overlap with systems that support
+	 * assignable counters.
+	 */
+	if (rr->is_mbm_cntr) {
+		pr_warn_once("Summing domains using assignable counters is not supported\n");
+		rr->err = -EINVAL;
+		return -EINVAL;
 	}
 
 	/* Summing domains that share a cache, must be on a CPU for that cache. */
@@ -476,12 +500,8 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
 		if (d->ci_id != rr->ci->id)
 			continue;
-		if (rr->is_mbm_cntr)
-			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
-						     rr->evtid, &tval);
-		else
-			err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
-						     rr->evtid, &tval, rr->arch_mon_ctx);
+		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
+					     rr->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -498,7 +518,10 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
 	switch (rr->r->rid) {
 	case RDT_RESOURCE_L3:
-		return __l3_mon_event_count(rdtgrp, rr);
+		if (rr->hdr)
+			return __l3_mon_event_count(rdtgrp, rr);
+		else
+			return __l3_mon_event_count_sum(rdtgrp, rr);
 	default:
 		rr->err = -EINVAL;
 		return -EINVAL;
@@ -522,9 +545,13 @@ static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	u64 cur_bw, bytes, cur_bytes;
 	u32 closid = rdtgrp->closid;
 	u32 rmid = rdtgrp->mon.rmid;
+	struct rdt_mon_domain *d;
 	struct mbm_state *m;
 
-	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return;
+	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+	m = get_mbm_state(d, closid, rmid, rr->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -697,7 +724,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 	struct rmid_read rr = {0};
 
 	rr.r = r;
-	rr.d = d;
+	rr.hdr = &d->hdr;
 	rr.evtid = evtid;
 	if (resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rr.is_mbm_cntr = true;
-- 
2.51.1

