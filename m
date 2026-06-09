Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972691DDC37
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038975; cv=none; b=Fv9qqVWAWbKWD08+l3iX0KsRxXwnzFNy+qsNopt/NYKxGN+0oWRp74aw36PCuzSQaeDuxRSwb//yb1jJytB+ar7IvVdJRQvklqdP5s86kdPtvmg1depmQiJ/Kh6jarPZpXSn6AAzqJ0QuIseq0HbXFDxYVq1pnfp/wZOkLXk80I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038975; c=relaxed/simple;
	bh=MipamcLZAxg3ZzTnxHxnvdROytTJWrIxsz+GUOz26/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8Io09+4ZXIX9zgsZGOBLbRxjkeXc1xGmmWN9KoPT/YSGsHFem601L4mbws+9yxKjUyASt7JZB4ZHyIYbTRMkcUo6cvB6ID7THqnKqK4LZonp9EdoKfA2u4aTVbaVLWNnVtD1oOrI27biz7PFu/CaEPj4gsrkvpSPIJ3yF6aYqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R9rQGKpF; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R9rQGKpF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781038973; x=1812574973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MipamcLZAxg3ZzTnxHxnvdROytTJWrIxsz+GUOz26/Y=;
  b=R9rQGKpFwMNalT1JXCwggOgHYuBSs8IvxD1YGFsd4p5dmnYUBsjjALMq
   3ozWxxL5FOFxEZ97gwJuItXKvn9pj0qWFkhotIHJwCAB81LdEJiNHSdL2
   q4r9JbE5XdUwa4vr5Eg9X3wO2UtTfGeFe1mgsFwzQXWAybWgeFCX+zvyS
   gwyvhWbp0mbTbjMOP+r/oJJSAOtXKVYp5Q+ZMlyx5GJkgceGJ5NBwTycg
   xkhp2i9qvba62aTBetf7OC8tuymIFNRqAgNzE4yHDOVamhFFHxFrgyTAN
   5W2FunozxSuBPX6W4mJcF33Y3bOzq+GcVmzOCftpOFFw8KkmmuQMfqSHd
   Q==;
X-CSE-ConnectionGUID: Yqov201ISEayTAiNTLCtvw==
X-CSE-MsgGUID: PO3xy4R1RqCAyRg5S8dVqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81725050"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81725050"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:52 -0700
X-CSE-ConnectionGUID: KZWu6SpeQ16nxGqIJaTpJA==
X-CSE-MsgGUID: 9dqswrgETBypU07zNbEdpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="251045655"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:50 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 02/11] x86,fs/resctrl: Document safe RCU list traversal
Date: Tue,  9 Jun 2026 14:02:28 -0700
Message-ID: <6e254c033538d597fa0f968827ae3857a5d8339c.1781029125.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1781029125.git.reinette.chatre@intel.com>
References: <cover.1781029125.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rdt_resource::ctrl_domains and rdt_resource::mon_domains are RCU lists with
entries added and removed by architecture from CPU hotplug callbacks that
are run with cpus_write_lock() held. These lists can be traversed safely
from resctrl fs by either holding cpus_read_lock() or relying on an RCU
read-side critical section.

resctrl fs traversals of rdt_resource::ctrl_domains and
rdt_resource::mon_domains are done using list_for_each_entry() with
cpus_read_lock() held. Similarly, x86 architecture callbacks use
list_for_each_entry() expecting that resctrl fs makes the call with
cpus_read_lock() held. Inconsistently, a lockdep_assert_cpus_held() precedes
the list_for_each_entry() call with varying distance to document this safe
RCU list traversal.

In preparation for an upcoming traversal of rdt_resource::ctrl_domains that
needs to be done from RCU read-side critical section there is a requirement
for developers to always know exactly in which context the list is being
traversed.

Replace the list_for_each_entry() traversals of RCU list with
list_for_each_entry_rcu() to document that an RCU list is being traversed
while making use of the built-in lockdep expression that additionally
documents that it is cpus_read_lock() that enables the list to be
traversed from non-RCU protection. Only revert to documenting the
safety of traversal using a comment when lockdep does not have needed
visibility in functions called via smp_call*().

The lockdep expression within list_for_each_entry_rcu() depends on
RCU_EXPERT that is not set in a typical debug kernel so keep the existing
lockdep_assert_cpus_held() that is active with CONFIG_LOCKDEP=y found in
typical debug kernel.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v3:
- New patch.
---
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  4 ++--
 arch/x86/kernel/cpu/resctrl/monitor.c     |  2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  4 ++--
 fs/resctrl/ctrlmondata.c                  | 12 +++++++-----
 fs/resctrl/monitor.c                      | 23 +++++++++++++---------
 fs/resctrl/pseudo_lock.c                  |  2 +-
 fs/resctrl/rdtgroup.c                     | 24 +++++++++++------------
 7 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index b20e705606b8..e74f1ed54b86 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -53,7 +53,7 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid)
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		hw_dom = resctrl_to_arch_ctrl_dom(d);
 		msr_param.res = NULL;
 		for (t = 0; t < CDP_NUM_TYPES; t++) {
@@ -115,7 +115,7 @@ static void _resctrl_sdciae_enable(struct rdt_resource *r, bool enable)
 	lockdep_assert_cpus_held();
 
 	/* Update MSR_IA32_L3_QOS_EXT_CFG MSR on all the CPUs in all domains */
-	list_for_each_entry(d, &r->ctrl_domains, hdr.list)
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held())
 		on_each_cpu_mask(&d->hdr.cpu_mask, resctrl_sdciae_set_one_amd, &enable, 1);
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 569894d6e5c8..430b8fae0b77 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -510,7 +510,7 @@ static void _resctrl_abmc_enable(struct rdt_resource *r, bool enable)
 
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		on_each_cpu_mask(&d->hdr.cpu_mask, resctrl_abmc_set_one_amd,
 				 &enable, 1);
 		resctrl_arch_reset_rmid_all(r, d);
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 885026468440..5ffa39fa86fa 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -151,7 +151,7 @@ static int set_cache_qos_cfg(int level, bool enable)
 		return -ENOMEM;
 
 	r_l = &rdt_resources_all[level].r_resctrl;
-	list_for_each_entry(d, &r_l->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r_l->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (r_l->cache.arch_has_per_cpu_cfg)
 			/* Pick all the CPUs in the domain instance */
 			for_each_cpu(cpu, &d->hdr.cpu_mask)
@@ -249,7 +249,7 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
 	 * CBMs in all ctrl_domains to the maximum mask value. Pick one CPU
 	 * from each domain to update the MSRs below.
 	 */
-	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		hw_dom = resctrl_to_arch_ctrl_dom(d);
 
 		for (i = 0; i < hw_res->num_closid; i++)
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 9a7dfc48cb2e..f33712c17d38 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -261,7 +261,7 @@ static int parse_line(char *line, struct resctrl_schema *s,
 		return -EINVAL;
 	}
 	dom = strim(dom);
-	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (d->hdr.id == dom_id) {
 			data.buf = dom;
 			data.closid = rdtgrp->closid;
@@ -397,7 +397,7 @@ static void show_doms(struct seq_file *s, struct resctrl_schema *schema,
 
 	if (resource_name)
 		seq_printf(s, "%*s:", max_name_width, resource_name);
-	list_for_each_entry(dom, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(dom, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (sep)
 			seq_puts(s, ";");
 
@@ -535,6 +535,8 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 	struct rdt_domain_hdr *d;
 	struct list_head *l;
 
+	lockdep_assert_cpus_held();
+
 	list_for_each(l, h) {
 		d = list_entry(l, struct rdt_domain_hdr, list);
 		/* When id is found, return its domain. */
@@ -717,7 +719,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 * struct mon_data. Search all domains in the resource for
 		 * one that matches this cache id.
 		 */
-		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 			if (d->ci_id == domid) {
 				cpu = cpumask_any(&d->hdr.cpu_mask);
 				ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
@@ -817,7 +819,7 @@ static int resctrl_io_alloc_init_cbm(struct resctrl_schema *s, u32 closid)
 	/* Keep CDP_CODE and CDP_DATA of io_alloc CLOSID's CBM in sync. */
 	if (resctrl_arch_get_cdp_enabled(r->rid)) {
 		peer_type = resctrl_peer_type(s->conf_type);
-		list_for_each_entry(d, &s->res->ctrl_domains, hdr.list)
+		list_for_each_entry_rcu(d, &s->res->ctrl_domains, hdr.list, lockdep_is_cpus_held())
 			memcpy(&d->staged_config[peer_type],
 			       &d->staged_config[s->conf_type],
 			       sizeof(d->staged_config[0]));
@@ -980,7 +982,7 @@ static int resctrl_io_alloc_parse_line(char *line,  struct rdt_resource *r,
 	}
 
 	dom = strim(dom);
-	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (update_all || d->hdr.id == dom_id) {
 			data.buf = dom;
 			data.mode = RDT_MODE_SHAREABLE;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index a932a1fea818..2dacb589625d 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -309,7 +309,7 @@ static void add_rmid_to_limbo(struct rmid_entry *entry)
 	idx = resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid);
 
 	entry->busy = 0;
-	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		/*
 		 * For the first limbo RMID in the domain,
 		 * setup up the limbo worker.
@@ -507,6 +507,11 @@ static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *r
 	 * all domains fail for any reason.
 	 */
 	ret = -EINVAL;
+	/*
+	 * RCU list being traversed with CPU hotplug lock held. lockdep
+	 * unable to help prove this here since this work is scheduled via
+	 * smp_call*(). Not called from MBM overflow handler.
+	 */
 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
 		if (d->ci_id != rr->ci->id)
 			continue;
@@ -1231,7 +1236,7 @@ static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgro
 	int ret = 0;
 
 	if (!d) {
-		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 			int err;
 
 			err = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
@@ -1303,7 +1308,7 @@ static void rdtgroup_unassign_cntr_event(struct rdt_l3_mon_domain *d, struct rdt
 	struct rdt_resource *r = resctrl_arch_get_resource(mevt->rid);
 
 	if (!d) {
-		list_for_each_entry(d, &r->mon_domains, hdr.list)
+		list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held())
 			rdtgroup_free_unassign_cntr(r, d, rdtgrp, mevt);
 	} else {
 		rdtgroup_free_unassign_cntr(r, d, rdtgrp, mevt);
@@ -1375,7 +1380,7 @@ static void rdtgroup_update_cntr_event(struct rdt_resource *r, struct rdtgroup *
 	struct rdt_l3_mon_domain *d;
 	int cntr_id;
 
-	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		cntr_id = mbm_cntr_get(r, d, rdtgrp, evtid);
 		if (cntr_id >= 0)
 			rdtgroup_assign_cntr(r, d, evtid, rdtgrp->mon.rmid,
@@ -1545,7 +1550,7 @@ ssize_t resctrl_mbm_assign_mode_write(struct kernfs_open_file *of, char *buf,
 		/*
 		 * Reset all the non-achitectural RMID state and assignable counters.
 		 */
-		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 			mbm_cntr_free_all(r, d);
 			resctrl_reset_rmid_all(r, d);
 		}
@@ -1568,7 +1573,7 @@ int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of,
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
-	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(dom, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (sep)
 			seq_putc(s, ';');
 
@@ -1602,7 +1607,7 @@ int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(dom, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (sep)
 			seq_putc(s, ';');
 
@@ -1652,7 +1657,7 @@ int mbm_L3_assignments_show(struct kernfs_open_file *of, struct seq_file *s, voi
 
 		sep = false;
 		seq_printf(s, "%s:", mevt->name);
-		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 			if (sep)
 				seq_putc(s, ';');
 
@@ -1750,7 +1755,7 @@ static int resctrl_parse_mbm_assignment(struct rdt_resource *r, struct rdtgroup
 	}
 
 	/* Verify if the dom_id is valid */
-	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (d->hdr.id == dom_id) {
 			ret = rdtgroup_modify_assign_state(dom_str, d, rdtgrp, mevt);
 			if (ret) {
diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
index d1cb0986006e..dea2b4bf966f 100644
--- a/fs/resctrl/pseudo_lock.c
+++ b/fs/resctrl/pseudo_lock.c
@@ -656,7 +656,7 @@ bool rdtgroup_pseudo_locked_in_hierarchy(struct rdt_ctrl_domain *d)
 	 * associated with them.
 	 */
 	for_each_alloc_capable_rdt_resource(r) {
-		list_for_each_entry(d_i, &r->ctrl_domains, hdr.list) {
+		list_for_each_entry_rcu(d_i, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 			if (d_i->plr)
 				cpumask_or(cpu_with_psl, cpu_with_psl,
 					   &d_i->hdr.cpu_mask);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index af2cbab14497..2a6221925767 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -117,7 +117,7 @@ void rdt_staged_configs_clear(void)
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	for_each_alloc_capable_rdt_resource(r) {
-		list_for_each_entry(dom, &r->ctrl_domains, hdr.list)
+		list_for_each_entry_rcu(dom, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held())
 			memset(dom->staged_config, 0, sizeof(dom->staged_config));
 	}
 }
@@ -1063,7 +1063,7 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
-	list_for_each_entry(dom, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(dom, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (sep)
 			seq_putc(seq, ';');
 		hw_shareable = r->cache.shareable_bits;
@@ -1415,7 +1415,7 @@ static bool rdtgroup_mode_test_exclusive(struct rdtgroup *rdtgrp)
 		if (r->rid == RDT_RESOURCE_MBA || r->rid == RDT_RESOURCE_SMBA)
 			continue;
 		has_cache = true;
-		list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+		list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 			ctrl = resctrl_arch_get_config(r, d, closid,
 						       s->conf_type);
 			if (rdtgroup_cbm_overlaps(s, d, ctrl, closid, false)) {
@@ -1604,7 +1604,7 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 		type = schema->conf_type;
 		sep = false;
 		seq_printf(s, "%*s:", max_name_width, schema->name);
-		list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+		list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 			if (sep)
 				seq_putc(s, ';');
 			if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
@@ -1649,7 +1649,7 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
-	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(dom, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (sep)
 			seq_puts(s, ";");
 
@@ -1763,7 +1763,7 @@ static int mon_config_write(struct rdt_resource *r, char *tok, u32 evtid)
 		return -EINVAL;
 	}
 
-	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (d->hdr.id == dom_id) {
 			mbm_config_write_domain(r, d, evtid, val);
 			goto next;
@@ -2554,7 +2554,7 @@ static int set_mba_sc(bool mba_sc)
 
 	rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
 
-	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		for (i = 0; i < num_closid; i++)
 			d->mbps_val[i] = MBA_MAX_MBPS;
 	}
@@ -2879,7 +2879,7 @@ static int rdt_get_tree(struct fs_context *fc)
 
 	if (resctrl_is_mbm_enabled()) {
 		r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-		list_for_each_entry(dom, &r->mon_domains, hdr.list)
+		list_for_each_entry_rcu(dom, &r->mon_domains, hdr.list, lockdep_is_cpus_held())
 			mbm_setup_overflow_handler(dom, MBM_OVERFLOW_INTERVAL,
 						   RESCTRL_PICK_ANY_CPU);
 	}
@@ -3435,7 +3435,7 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(hdr, &r->mon_domains, list) {
+	list_for_each_entry_rcu(hdr, &r->mon_domains, list, lockdep_is_cpus_held()) {
 		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
 		if (ret)
 			return ret;
@@ -3620,7 +3620,7 @@ int rdtgroup_init_cat(struct resctrl_schema *s, u32 closid)
 	struct rdt_ctrl_domain *d;
 	int ret;
 
-	list_for_each_entry(d, &s->res->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &s->res->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		ret = __init_one_rdt_domain(d, s, closid);
 		if (ret < 0)
 			return ret;
@@ -3635,7 +3635,7 @@ static void rdtgroup_init_mba(struct rdt_resource *r, u32 closid)
 	struct resctrl_staged_config *cfg;
 	struct rdt_ctrl_domain *d;
 
-	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (is_mba_sc(r)) {
 			d->mbps_val[closid] = MBA_MAX_MBPS;
 			continue;
@@ -4506,7 +4506,7 @@ static struct rdt_l3_mon_domain *get_mon_domain_from_cpu(int cpu,
 
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		/* Find the domain that contains this CPU */
 		if (cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
 			return d;
-- 
2.50.1

