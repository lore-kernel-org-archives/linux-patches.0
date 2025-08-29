Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3783B258ED8
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496047; cv=none; b=VJRda6s+Mvdknc+ef8uhR1xna4V7hGUqFJ3AAu8wdFXpUZ7VvZ+iS+eXhCWiyRvsIi+cxrCT5aCxrcduGJ4sbueBlpOcz4JucLTmEKjsSiW0PXjGMvwZLT0Zg34c+DZX3Qd2sXH3dAeNJBCLKoD4mJGY/wAmW8cWwKw+RlEqWx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496047; c=relaxed/simple;
	bh=nzH2Fa3D4fRTQoArXoTrumRIuF3KqGyOVq5e6UBpk3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrMuMvwoSOqzbqONj82u8w9ALJekf25ud7kVpkc1wPZVWXKQ2I3L+4qrzQBanyc9CFmBL/c11Ebmc2yPg/QWF26ZPQBKVO4AjaQWzr5zzOeGGISAKuaYKwxMH/90GosjyTYZwd8QSpyMfvy3KUxuxafRGDRdtfsfucJzsoFu5nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lO5sln0k; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lO5sln0k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496044; x=1788032044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nzH2Fa3D4fRTQoArXoTrumRIuF3KqGyOVq5e6UBpk3A=;
  b=lO5sln0kRP08J4rYIuODH0aslPLxjyfB3vGmVGdAhVsFDFsC3JDBbO8S
   QoMvS1djFWfqmGSxdELh+BwPcN13JeFJeVx5+brababOagISCH5rMaKmU
   HbzGdh8rXbR3egCXEC0lc0M+u6tDqdfQPdBY2dt/Bro9aXo7CEDcaRrsG
   q1NEmmOEi91zZac36Xd6n+QpixH64/KsW07B1KCY6SizqIIj8XJSTvpMZ
   /qKxAldZIw2KbHwKnxyUtptxwDKd0Hk4HaYCeofj4pbys3uHIs1pSb9XZ
   VJHJPfqsVkCQlT5aNHRRr+6AgytBAasywJjovFTyh6RSOV+9X1kIvBXN3
   Q==;
X-CSE-ConnectionGUID: WnQRnS/2TUmyREg4O1IeSw==
X-CSE-MsgGUID: L/UOExRNSJ+wgaDE23lHhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625242"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625242"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:54 -0700
X-CSE-ConnectionGUID: BCPCHOqwSsCSIrml1X366g==
X-CSE-MsgGUID: HO6IZZJbSJqxM5zuWjeqxQ==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:54 -0700
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
Subject: [PATCH v9 12/31] fs/resctrl: Make event details accessible to functions when reading events
Date: Fri, 29 Aug 2025 12:33:24 -0700
Message-ID: <20250829193346.31565-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
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
 fs/resctrl/ctrlmondata.c | 16 ++++++++--------
 fs/resctrl/monitor.c     | 17 +++++++++--------
 fs/resctrl/rdtgroup.c    |  6 +++---
 4 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 70572f6cc223..b2a236b373c0 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -76,7 +76,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
  * struct mon_data - Monitoring details for each event file.
  * @list:            Member of the global @mon_data_kn_priv_list list.
  * @rid:             Resource id associated with the event file.
- * @evtid:           Event id associated with the event file.
+ * @evt:             Event structure associated with the event file.
  * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
  *                   across multiple domains.
  * @domid:           When @sum is zero this is the domain to which
@@ -90,7 +90,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
 struct mon_data {
 	struct list_head	list;
 	enum resctrl_res_level	rid;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	int			domid;
 	bool			sum;
 };
@@ -103,7 +103,7 @@ struct mon_data {
  * @r:	   Resource describing the properties of the event being read.
  * @hdr:   Header of domain that the counter should be read from. If NULL then sum all
  *	   domains in @r sharing L3 @ci.id
- * @evtid: Which monitor event to read.
+ * @evt:   Which monitor event to read.
  * @first: Initialize MBM counter when true.
  * @ci_id: Cacheinfo id for L3. Only set when @hdr is NULL. Used when summing domains.
  * @err:   Error encountered when reading counter.
@@ -117,7 +117,7 @@ struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_domain_hdr	*hdr;
-	enum resctrl_event_id	evtid;
+	struct mon_evt		*evt;
 	bool			first;
 	unsigned int		ci_id;
 	int			err;
@@ -355,7 +355,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first);
+		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
 void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 1d7086509bfa..a99903ac5d27 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -548,7 +548,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
-		    cpumask_t *cpumask, int evtid, int first)
+		    cpumask_t *cpumask, struct mon_evt *evt, int first)
 {
 	int cpu;
 
@@ -559,11 +559,11 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * Setup the parameters to pass to mon_event_count() to read the data.
 	 */
 	rr->rgrp = rdtgrp;
-	rr->evtid = evtid;
+	rr->evt = evt;
 	rr->r = r;
 	rr->hdr = hdr;
 	rr->first = first;
-	rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evtid);
+	rr->arch_mon_ctx = resctrl_arch_mon_ctx_alloc(r, evt->evtid);
 	if (IS_ERR(rr->arch_mon_ctx)) {
 		rr->err = -EINVAL;
 		return;
@@ -582,20 +582,20 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
-	resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
+	resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
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
@@ -612,7 +612,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 
 	resid = md->rid;
 	domid = md->domid;
-	evtid = md->evtid;
+	evt = md->evt;
 	r = resctrl_arch_get_resource(resid);
 
 	if (md->sum) {
@@ -636,7 +636,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 				if (!ci)
 					continue;
 				mon_event_read(&rr, r, NULL, rdtgrp,
-					       &ci->shared_cpu_map, evtid, false);
+					       &ci->shared_cpu_map, evt, false);
 				goto checkresult;
 			}
 		}
@@ -652,7 +652,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 			ret = -ENOENT;
 			goto out;
 		}
-		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
+		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evt, false);
 	}
 
 checkresult:
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 614c753929e0..81c3fb6a95b6 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -369,8 +369,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return -EINVAL;
 		d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
-		resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evtid);
-		m = get_mbm_state(d, closid, rmid, rr->evtid);
+		resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evt->evtid);
+		m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 		if (m)
 			memset(m, 0, sizeof(struct mbm_state));
 		return 0;
@@ -381,7 +381,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (!cpumask_test_cpu(cpu, &rr->hdr->cpu_mask))
 			return -EINVAL;
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-						 rr->evtid, &tval, rr->arch_mon_ctx);
+						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -410,7 +410,7 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (d->ci_id != rr->ci_id)
 			continue;
 		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
-					     rr->evtid, &tval, rr->arch_mon_ctx);
+					     rr->evt->evtid, &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -444,7 +444,7 @@ static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return;
 	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
-	m = get_mbm_state(d, closid, rmid, rr->evtid);
+	m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
 	if (WARN_ON_ONCE(!m))
 		return;
 
@@ -615,12 +615,13 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_l3_mon_domain *dom_m
 static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
 				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
 {
+	struct mon_evt *evt = &mon_event_all[evtid];
 	struct rmid_read rr = {0};
 
 	rr.r = r;
 	rr.hdr = &d->hdr;
-	rr.evtid = evtid;
-	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+	rr.evt = evt;
+	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, evt->evtid);
 	if (IS_ERR(rr.arch_mon_ctx)) {
 		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
 				    PTR_ERR(rr.arch_mon_ctx));
@@ -636,7 +637,7 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_l3_mon_domai
 	if (is_mba_sc(NULL))
 		mbm_bw_count(closid, rmid, &rr);
 
-	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+	resctrl_arch_mon_ctx_free(rr.r, evt->evtid, rr.arch_mon_ctx);
 }
 
 static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0203f43b7883..f98f34e75f35 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2903,7 +2903,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 
 	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
 		if (priv->rid == rid && priv->domid == domid &&
-		    priv->sum == do_sum && priv->evtid == mevt->evtid)
+		    priv->sum == do_sum && priv->evt == mevt)
 			return priv;
 	}
 
@@ -2914,7 +2914,7 @@ static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
 	priv->rid = rid;
 	priv->domid = domid;
 	priv->sum = do_sum;
-	priv->evtid = mevt->evtid;
+	priv->evt = mevt;
 	list_add_tail(&priv->list, &mon_data_kn_priv_list);
 
 	return priv;
@@ -3079,7 +3079,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			return ret;
 
 		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
+			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
 	return 0;
-- 
2.50.1

