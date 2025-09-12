Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F9328489D
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715067; cv=none; b=OKYuNJMHQyVSfuaM2/AaZngV1cTnWKcVrFtHIRYejeraRfwwrmQJFjhwMXbtaIH5xCSvn+jt5j9mHuiy0zN1jlT0Acehb/oUuITMykwErwbgUe5/vmmuyFU/CLIlPsizPXHKl4nDw/+P4XwgtZJZmXBANPpGW4fbLEP77/tD0TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715067; c=relaxed/simple;
	bh=hw4DlDhSWxekZeR06RBFhQsrVsUocA9yGdYbyCh04tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMy4ruiDQ55e0ubKofLPUiTjMm5HAZMHon53PIHZsUGl7zwB0r6B6Fhj0qTpUmaLFQC3teS5zq7UTaSq2B/YqnWEmm9joasvn+55qNoOBsbZfIuk/O1Bz0FhzmDg45oLyS9u06oV7NgSskqtQTUTvTcqB4GLeEiiINN4ZEhIUu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cebGyBUi; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cebGyBUi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715065; x=1789251065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hw4DlDhSWxekZeR06RBFhQsrVsUocA9yGdYbyCh04tg=;
  b=cebGyBUiVOwzVxWbM5dpQfsKfNqbPHmPK6Wy36PTyrKZnu/Rxzcu+y5S
   1Zwyf6R3r/vW0RcyA87MdPl3ZNATlhnKJhysHH3QwsO4BmQhjWbpRCB5x
   jJJKd3dmN8GdDdvEq7tTvF9kaFRERisi8B6iyjJzxwtezrHLhdQ/4gc8U
   WbQ2rpiQ/EnEvBv9/1Q4wXhapPLsIiFObezdcM6UEPcKqcLSJXojOP0j2
   ru/LdYqQIL2FqNple4G04C5uGcTvkrSz2fCf0sDA5oiYnZMwn6lOBdlog
   aALu+zDtHMB+HNDk58nh0C6vlt2JpfTvBH/xk2VMDV8gRL5iDILT4mcsY
   A==;
X-CSE-ConnectionGUID: 0s2qHt1AT0C1gjg1wS5n1w==
X-CSE-MsgGUID: JTblLakRQmaL4IbO5uPYxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002657"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002657"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:03 -0700
X-CSE-ConnectionGUID: 4YgLLFziSsa27bpiNHEHug==
X-CSE-MsgGUID: nnfhAEd4SgieBUP7HRgHaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265140"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:03 -0700
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
Subject: [PATCH v10 06/28] x86,fs/resctrl: Use struct rdt_domain_hdr when reading counters
Date: Fri, 12 Sep 2025 15:10:27 -0700
Message-ID: <20250912221053.11349-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All monitoring events are associated with the L3 resource and it made
sense to use the L3 specific "struct rdt_mon_domain *" arguments to
functions manipulating domains.

Telemetry events will be tied to another resource. This requires the
functions that manipulate domains to not be L3 specific.

Replace the L3 specific domain pointer rmid_read::d with rmid_read::hdr
that points to the generic domain header for the calls from
mon_event_read() via smp_call*() to __mon_event_count() and
resctrl_arch_rmid_read() and resctrl_arch_cntr_read().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h               |  8 +--
 fs/resctrl/internal.h                 |  8 +--
 arch/x86/kernel/cpu/resctrl/monitor.c | 17 +++++-
 fs/resctrl/ctrlmondata.c              |  7 +--
 fs/resctrl/monitor.c                  | 86 +++++++++++++++++----------
 5 files changed, 80 insertions(+), 46 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0b55809af5d7..0fef3045cac3 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -514,7 +514,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
  * @r:			resource that the counter should be read from.
- * @d:			domain that the counter should be read from.
+ * @hdr:		Header of domain that the counter should be read from.
  * @closid:		closid that matches the rmid. Depending on the architecture, the
  *			counter may match traffic of both @closid and @rmid, or @rmid
  *			only.
@@ -535,7 +535,7 @@ void resctrl_offline_cpu(unsigned int cpu);
  * Return:
  * 0 on success, or -EIO, -EINVAL etc on error.
  */
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *arch_mon_ctx);
 
@@ -630,7 +630,7 @@ void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
  *			      assigned to the RMID, event pair for this resource
  *			      and domain.
  * @r:		Resource that the counter should be read from.
- * @d:		Domain that the counter should be read from.
+ * @hdr:	Header of domain that the counter should be read from.
  * @closid:	CLOSID that matches the RMID.
  * @rmid:	The RMID to which @cntr_id is assigned.
  * @cntr_id:	The counter to read.
@@ -644,7 +644,7 @@ void resctrl_arch_config_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
  * Return:
  * 0 on success, or -EIO, -EINVAL etc on error.
  */
-int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, int cntr_id,
 			   enum resctrl_event_id eventid, u64 *val);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 6c78b1a4ca3a..480d20ee0c29 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -106,24 +106,24 @@ struct mon_data {
  *	   resource group then its event count is summed with the count from all
  *	   its child resource groups.
  * @r:	   Resource describing the properties of the event being read.
- * @d:	   Domain that the counter should be read from. If NULL then sum all
+ * @hdr:   Header of domain that the counter should be read from. If NULL then sum all
  *	   domains in @r sharing L3 @ci.id
  * @evtid: Which monitor event to read.
  * @first: Initialize MBM counter when true.
  * @is_mbm_cntr: true if "mbm_event" counter assignment mode is enabled and it
  *	   is an MBM event.
- * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
+ * @ci:    Cacheinfo for L3. Only set when @hdr is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
  * @val:   Returned value of event counter. If @rgrp is a parent resource group,
  *	   @val includes the sum of event counts from its child resource groups.
- *	   If @d is NULL, @val includes the sum of all domains in @r sharing @ci.id,
+ *	   If @hdr is NULL, @val includes the sum of all domains in @r sharing @ci.id,
  *	   (summed across child resource groups if @rgrp is a parent resource group).
  * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only).
  */
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
-	struct rdt_mon_domain	*d;
+	struct rdt_domain_hdr	*hdr;
 	enum resctrl_event_id	evtid;
 	bool			first;
 	bool			is_mbm_cntr;
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index c8945610d455..cee1cd7fbdce 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -238,17 +238,23 @@ static u64 get_corrected_val(struct rdt_resource *r, struct rdt_mon_domain *d,
 	return chunks * hw_res->mon_scale;
 }
 
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
 			   u64 *val, void *ignored)
 {
-	int cpu = cpumask_any(&d->hdr.cpu_mask);
+	struct rdt_mon_domain *d;
 	u64 msr_val;
 	u32 prmid;
+	int cpu;
 	int ret;
 
 	resctrl_arch_rmid_read_context_check();
 
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return -EINVAL;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
+	cpu = cpumask_any(&hdr->cpu_mask);
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 	ret = __rmid_read_phys(prmid, eventid, &msr_val);
 	if (ret)
@@ -312,13 +318,18 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
 	}
 }
 
-int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, int cntr_id,
 			   enum resctrl_event_id eventid, u64 *val)
 {
+	struct rdt_mon_domain *d;
 	u64 msr_val;
 	int ret;
 
+	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+		return -EINVAL;
+
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	ret = __cntr_id_read(cntr_id, &msr_val);
 	if (ret)
 		return ret;
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 3bbfb5398e6f..7b9fc5d3bdc8 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -550,11 +550,8 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, int evtid, int first)
 {
-	struct rdt_mon_domain *d;
 	int cpu;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
-
 	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
@@ -564,7 +561,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	rr->rgrp = rdtgrp;
 	rr->evtid = evtid;
 	rr->r = r;
-	rr->d = d;
+	rr->hdr = hdr;
 	rr->first = first;
 	if (resctrl_arch_mbm_cntr_assign_enabled(r) &&
 	    resctrl_is_mbm_event(evtid)) {
@@ -653,7 +650,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 * the resource to find the domain with "domid".
 		 */
 		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
-		if (!hdr || !domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, resid)) {
+		if (!hdr) {
 			ret = -ENOENT;
 			goto out;
 		}
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index c58d1cd7fc46..1bc1e5ebf5f5 100644
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
@@ -413,9 +413,28 @@ static void mbm_cntr_free(struct rdt_mon_domain *d, int cntr_id)
 	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
 }
 
+/*
+ * Called from preemptible but non-migratable process context (mon_event_count()
+ * via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
+ * smp_call_function_any()) for events that need to be read on a specific CPU.
+ */
+static bool cpu_on_correct_domain(struct rmid_read *rr)
+{
+	int cpu;
+
+	cpu = smp_processor_id();
+
+	/* Single domain. Must be on a CPU in that domain. */
+	if (rr->hdr)
+		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
+
+	/* Summing domains that share a cache, must be on a CPU for that cache. */
+	return cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map);
+}
+
+
 static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
-	int cpu = smp_processor_id();
 	u32 closid = rdtgrp->closid;
 	u32 rmid = rdtgrp->mon.rmid;
 	struct rdt_mon_domain *d;
@@ -424,34 +443,41 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	int err, ret;
 	u64 tval = 0;
 
-	if (rr->is_mbm_cntr) {
-		cntr_id = mbm_cntr_get(rr->r, rr->d, rdtgrp, rr->evtid);
-		if (cntr_id < 0) {
-			rr->err = -ENOENT;
+	if (!cpu_on_correct_domain(rr))
+		return -EINVAL;
+
+	if (rr->r->rid == RDT_RESOURCE_L3) {
+		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return -EINVAL;
+		d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
+
+		if (rr->is_mbm_cntr) {
+			cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
+			if (cntr_id < 0) {
+				rr->err = -ENOENT;
+				return -EINVAL;
+			}
 		}
-	}
 
-	if (rr->first) {
-		if (rr->is_mbm_cntr)
-			resctrl_arch_reset_cntr(rr->r, rr->d, closid, rmid, cntr_id, rr->evtid);
-		else
-			resctrl_arch_reset_rmid(rr->r, rr->d, closid, rmid, rr->evtid);
-		m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
-		if (m)
-			memset(m, 0, sizeof(struct mbm_state));
-		return 0;
+		if (rr->first) {
+			if (rr->is_mbm_cntr)
+				resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evtid);
+			else
+				resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
+			m = get_mbm_state(d, closid, rmid, rr->evtid);
+			if (m)
+				memset(m, 0, sizeof(struct mbm_state));
+			return 0;
+		}
 	}
 
-	if (rr->d) {
-		/* Reading a single domain, must be on a CPU in that domain. */
-		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
-			return -EINVAL;
+	if (rr->hdr) {
+		/* Single domain. */
 		if (rr->is_mbm_cntr)
-			rr->err = resctrl_arch_cntr_read(rr->r, rr->d, closid, rmid, cntr_id,
+			rr->err = resctrl_arch_cntr_read(rr->r, rr->hdr, closid, rmid, cntr_id,
 							 rr->evtid, &tval);
 		else
-			rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
+			rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
 							 rr->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
@@ -461,10 +487,6 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		return 0;
 	}
 
-	/* Summing domains that share a cache, must be on a CPU for that cache. */
-	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
-		return -EINVAL;
-
 	/*
 	 * Legacy files must report the sum of an event across all
 	 * domains that share the same L3 cache instance.
@@ -477,10 +499,10 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		if (d->ci_id != rr->ci->id)
 			continue;
 		if (rr->is_mbm_cntr)
-			err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
+			err = resctrl_arch_cntr_read(rr->r, &d->hdr, closid, rmid, cntr_id,
 						     rr->evtid, &tval);
 		else
-			err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
+			err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
 						     rr->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
@@ -511,9 +533,13 @@ static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
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
 
@@ -686,7 +712,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 	struct rmid_read rr = {0};
 
 	rr.r = r;
-	rr.d = d;
+	rr.hdr = &d->hdr;
 	rr.evtid = evtid;
 	if (resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rr.is_mbm_cntr = true;
-- 
2.51.0

