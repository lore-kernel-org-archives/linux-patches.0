Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD4C334391
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715071; cv=none; b=hhkEjVmv0pMfMf0lBPnGjzfUnzdVVO77VejHaoE0t20/4eLlmi8XjU2PlGj0C1Rd3J+WV0ZruoGc3oL9n52gChwaVqgPIGF7EqQ/TBD2g6WvGXoS8NXcnqQqeJGEzxRCrecm9uqhAqCyt9CEmtuW0Z5hxJ5rGfJsCHPUqdR0GAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715071; c=relaxed/simple;
	bh=zBr2F7YtvavX+OoaxZZKYTXP+VT1SpfRwRDX3COlwaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5Zi5OVNgJoht9cC1VBnmC8M6UugbmcHZTaMDMqOTn1kk/9wu3IruJP5WJYjPW+zT8agO9wy4EnB4rFVfZkNckmQfkQ2bTTiaKCjgDE0yfr4f+1zn5mtONb86mpxoljjfSH/yBGIfo03dxVokqrXUuQxsOhM16t2M1rpEHcPyvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4fJxa5E; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4fJxa5E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715067; x=1789251067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zBr2F7YtvavX+OoaxZZKYTXP+VT1SpfRwRDX3COlwaU=;
  b=E4fJxa5ES4HntLk23Qh8OXApeUweTPnisXqU4DhvUpsJmpXCFgjyl6Vb
   Mv4Lwex6PWV5qtp2OpP3PC+eN7OvA72TODaGeA+tebLEBHjh4oiF1+lJS
   uSVeJ/5eve63EM74yGoAm266qWbuCtB4zw4AKbogG0N8YK8P8C5PQ6tSm
   4xXMZOrqEXKPyE/bHADiuYn4Tfh5YDe14uTCpeaRZ2NHG9/z4IlQGOip0
   RR7RI3IhJLvUOt5NkF32YQsu1EWQ8Qf6l1+v0hk7ewAmZd4tsPeZ05rzZ
   qzZt6HVivAFSt48leVcTJV5r4kNjqanKBfUeOK5Ms5w+Er6DYFWf4FDLZ
   g==;
X-CSE-ConnectionGUID: AXbSTlQ8SHy98N3pURZr1Q==
X-CSE-MsgGUID: g55en4bdQzmP3TVSKAcBqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002681"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002681"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:05 -0700
X-CSE-ConnectionGUID: OXCyoVcoQgujC92kdb14kw==
X-CSE-MsgGUID: k8+Lvnb3RJeleS0hlXaHYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265157"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:05 -0700
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
Subject: [PATCH v10 09/28] fs/resctrl: Make event details accessible to functions when reading events
Date: Fri, 12 Sep 2025 15:10:30 -0700
Message-ID: <20250912221053.11349-10-tony.luck@intel.com>
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

All details about a monitor event are kept in the mon_evt structure.

Upper levels of code only provide the event id via the mon_data and
rmid_read structures to the functions finally reading the monitoring data.

The event id is sufficient for reading existing monitoring event
data that requires programming of event id into MSR when reading the
counter. Reading monitoring data from MMIO requires more context to be
able to read the correct memory. struct mon_evt is the appropriate place
for this event specific context.

Change the mon_data and rmid_read structures to hold a pointer
to the mon_evt structure instead of just taking a copy of the
event id.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h    | 10 +++++-----
 fs/resctrl/ctrlmondata.c | 18 +++++++++---------
 fs/resctrl/monitor.c     | 24 ++++++++++++------------
 fs/resctrl/rdtgroup.c    |  6 +++---
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 1892e3f4fe72..b6578e572f60 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -81,7 +81,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * struct mon_data - Monitoring details for each event file.
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
- * @evtid:           Event id associated with the event file.
+ * @evt:             Event structure associated with the event file.
  * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
  *                   across multiple domains.
  * @domid:           When @sum is zero this is the domain to which
@@ -95,7 +95,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
 struct mon_data {
 	struct list_head	list;
 	enum resctrl_res_level	rid;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	int			domid;
 	bool			sum;
 };
@@ -108,7 +108,7 @@ struct mon_data {
  * @r:	   Resource describing the properties of the event being read.
  * @hdr:   Header of domain that the counter should be read from. If NULL then sum all
  *	   domains in @r sharing L3 @ci.id
- * @evtid: Which monitor event to read.
+ * @evt:   Which monitor event to read.
  * @first: Initialize MBM counter when true.
  * @is_mbm_cntr: true if "mbm_event" counter assignment mode is enabled and it
  *	   is an MBM event.
@@ -124,7 +124,7 @@ struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_domain_hdr	*hdr;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	bool			first;
 	bool			is_mbm_cntr;
 	struct cacheinfo	*ci;
@@ -365,7 +365,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first);
+		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
 void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index c95f8eb8e731..77602563cb1f 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -548,7 +548,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first)
+		    cpumask_t *cpumask, struct mon_evt *evt, int first)
 {
 	int cpu;
 
@@ -559,15 +559,15 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * Setup the parameters to pass to mon_event_count() to read the data.
 	 */
 	rr->rgrp = rdtgrp;
-	rr->evtid = evtid;
+	rr->evt = evt;
 	rr->r = r;
 	rr->hdr = hdr;
 	rr->first = first;
 	if (resctrl_arch_mbm_cntr_assign_enabled(r) &&
-	    resctrl_is_mbm_event(evtid)) {
+	    resctrl_is_mbm_event(evt->evtid)) {
 		rr->is_mbm_cntr = true;
 	} else {
-		rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
+		rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evt->evtid);
 		if (IS_ERR(rr->arch_mon_ctx)) {
 			rr->err = -EINVAL;
 			return;
@@ -588,20 +588,20 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
 	if (rr->arch_mon_ctx)
-		resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
+		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
 
 int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 {
 	struct kernfs_open_file *of = m->private;
 	enum resctrl_res_level resid;
-	enum resctrl_event_id evtid;
 	struct rdt_domain_hdr *hdr;
 	struct rmid_read rr = {0};
 	struct rdtgroup *rdtgrp;
 	int domid, cpu, ret = 0;
 	struct rdt_resource *r;
 	struct cacheinfo *ci;
+	struct mon_evt *evt;
 	struct mon_data *md;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
@@ -618,7 +618,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 	resid = md->rid;
 	domid = md->domid;
-	evtid = md->evtid;
+	evt = md->evt;
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
@@ -638,7 +638,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 					continue;
 				rr.ci = ci;
 				mon_event_read(&rr, r, NULL, rdtgrp,
-					       &ci->shared_cpu_map, evtid, false);
+					       &ci->shared_cpu_map, evt, false);
 				goto checkresult;
 			}
 		}
@@ -654,7 +654,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			ret = -ENOENT;
 			goto out;
 		}
-		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
+		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evt, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 552cc23ecc57..276041c1a922 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -452,7 +452,7 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
 
 		if (rr->is_mbm_cntr) {
-			cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evtid);
+			cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evt->evtid);
 			if (cntr_id < 0) {
 				rr->err = -ENOENT;
 				return -EINVAL;
@@ -461,10 +461,10 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 
 		if (rr->first) {
 			if (rr->is_mbm_cntr)
-				resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evtid);
+				resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evt->evtid);
 			else
-				resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
-			m = get_mbm_state(d, closid, rmid, rr->evtid);
+				resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evt->evtid);
+			m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 			if (m)
 				memset(m, 0, sizeof(struct mbm_state));
 			return 0;
@@ -475,10 +475,10 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 		/* Single domain. */
 		if (rr->is_mbm_cntr)
 			rr->err = resctrl_arch_cntr_read(rr->r, rr->hdr, closid, rmid, cntr_id,
-							 rr->evtid, &tval);
+							 rr->evt->evtid, &tval);
 		else
 			rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-							 rr->evtid, &tval, rr->arch_mon_ctx);
+							 rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -500,10 +500,10 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 			continue;
 		if (rr->is_mbm_cntr)
 			err = resctrl_arch_cntr_read(rr->r, &d->hdr, closid, rmid, cntr_id,
-						     rr->evtid, &tval);
+						     rr->evt->evtid, &tval);
 		else
 			err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
-						     rr->evtid, &tval, rr->arch_mon_ctx);
+						     rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -539,7 +539,7 @@ static void mbm_bw_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return;
 	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
-	m = get_mbm_state(d, closid, rmid, rr->evtid);
+	m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -713,11 +713,11 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 
 	rr.r = r;
 	rr.hdr = &d->hdr;
-	rr.evtid = evtid;
+	rr.evt = &mon_event_all[evtid];
 	if (resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rr.is_mbm_cntr = true;
 	} else {
-		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, evtid);
 		if (IS_ERR(rr.arch_mon_ctx)) {
 			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
 					    PTR_ERR(rr.arch_mon_ctx));
@@ -735,7 +735,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 		mbm_bw_count(rdtgrp, &rr);
 
 	if (rr.arch_mon_ctx)
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+		resctrl_arch_mon_ctx_free(rr.r, evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0b46ac02253f..4f992b497092 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3042,7 +3042,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evtid == mevt->evtid)
+		    priv->sum == do_sum && priv->evt == mevt)
 			return priv;
 	}
 
@@ -3053,7 +3053,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 	priv->rid = rid;
 	priv->domid = domid;
 	priv->sum = do_sum;
-	priv->evtid = mevt->evtid;
+	priv->evt = mevt;
 	list_add_tail(&priv->list, &mon_data_kn_priv_list);
 
 	return priv;
@@ -3219,7 +3219,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			return ret;
 
 		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
+			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
 	return 0;
-- 
2.51.0

