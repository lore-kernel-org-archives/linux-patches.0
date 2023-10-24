Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9BB3B7A9
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i5JSJsXS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698171369; x=1729707369;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=svJxEnxlJxMe9ykA9n2RRTqPvoiO12Rhjx+c7UZ7Qtc=;
  b=i5JSJsXS1Qn9ZXORcAlzqUb1dKtfc8cNBveyu2L0OiUqFzoWX6pe7TZe
   gaWrH9opY3r4rbhKbNRaVBie/aUd5VhPo3lXeF356xn963eaMZMfcjeEq
   2eU5p/N4SLylGDpYTnmblFLNHW05QO61N3hv0ZYZInEIzZDfEyvoQwgjL
   7uesGQfB+gA+PG2WGD4qVQhUPkCSSUKR02DeTEW5CHJ5mOnDFa7b+I0Dr
   dHMJvRv8sessIjWT+3TCr8ENXdmDI2lepJhDrExovqt6H/eXYc8Uoyp5Y
   sN7W3BR7Ov+wWacHwRpVoj5ucLHHo+Q+U6AsUgsrcBThlrOB5flyBvPLi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="8684420"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="8684420"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 11:16:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="1089950438"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="1089950438"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 11:16:07 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/resctrl: mba_MBps: Fall back to total b/w if local b/w unavailable
Date: Tue, 24 Oct 2023 11:16:00 -0700
Message-ID: <20231024181600.8270-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Intel the various resource director technology (RDT) features are all
orthogonal and independently enumerated. Thus it is possible to have
a system that  provides "total" memory bandwidth measurements without
providing "local" bandwidth measurements.

If local bandwidth measurement is not available, do not give up on
providing the "mba_MBps" feedback option completely, make the code fall
back to using total bandwidth.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c  | 34 ++++++++++++++++----------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  2 +-
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index f136ac046851..3b9531cce807 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -418,6 +418,14 @@ static int __mon_event_count(u32 rmid, struct rmid_read *rr)
 	return 0;
 }
 
+static struct mbm_state *get_mbm_data(struct rdt_domain *dom_mbm, int rmid)
+{
+	if (is_mbm_local_enabled())
+		return &dom_mbm->mbm_local[rmid];
+
+	return &dom_mbm->mbm_total[rmid];
+}
+
 /*
  * mbm_bw_count() - Update bw count from values previously read by
  *		    __mon_event_count().
@@ -431,7 +439,7 @@ static int __mon_event_count(u32 rmid, struct rmid_read *rr)
  */
 static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 {
-	struct mbm_state *m = &rr->d->mbm_local[rmid];
+	struct mbm_state *m = get_mbm_data(rr->d, rmid);
 	u64 cur_bw, bytes, cur_bytes;
 
 	cur_bytes = rr->val;
@@ -526,14 +534,14 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_domain *dom_mbm)
 	struct list_head *head;
 	struct rdtgroup *entry;
 
-	if (!is_mbm_local_enabled())
+	if (!is_mbm_enabled())
 		return;
 
 	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
 	closid = rgrp->closid;
 	rmid = rgrp->mon.rmid;
-	pmbm_data = &dom_mbm->mbm_local[rmid];
+	pmbm_data = get_mbm_data(dom_mbm, rmid);
 
 	dom_mba = get_domain_from_cpu(smp_processor_id(), r_mba);
 	if (!dom_mba) {
@@ -553,7 +561,7 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_domain *dom_mbm)
 	 */
 	head = &rgrp->mon.crdtgrp_list;
 	list_for_each_entry(entry, head, mon.crdtgrp_list) {
-		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
+		cmbm_data = get_mbm_data(dom_mbm, entry->mon.rmid);
 		cur_bw += cmbm_data->prev_bw;
 		delta_bw += cmbm_data->delta_bw;
 	}
@@ -595,7 +603,7 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_domain *dom_mbm)
 	 */
 	pmbm_data->delta_comp = true;
 	list_for_each_entry(entry, head, mon.crdtgrp_list) {
-		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
+		cmbm_data = get_mbm_data(dom_mbm, entry->mon.rmid);
 		cmbm_data->delta_comp = true;
 	}
 }
@@ -621,15 +629,15 @@ static void mbm_update(struct rdt_resource *r, struct rdt_domain *d, int rmid)
 		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
 		rr.val = 0;
 		__mon_event_count(rmid, &rr);
-
-		/*
-		 * Call the MBA software controller only for the
-		 * control groups and when user has enabled
-		 * the software controller explicitly.
-		 */
-		if (is_mba_sc(NULL))
-			mbm_bw_count(rmid, &rr);
 	}
+
+	/*
+	 * Call the MBA software controller only for the
+	 * control groups and when user has enabled
+	 * the software controller explicitly.
+	 */
+	if (is_mba_sc(NULL))
+		mbm_bw_count(rmid, &rr);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 69a1de92384a..0c4f8a1b8df0 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2294,7 +2294,7 @@ static bool supports_mba_mbps(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
-	return (is_mbm_local_enabled() &&
+	return (is_mbm_enabled() &&
 		r->alloc_capable && is_mba_linear());
 }
 
-- 
2.41.0

