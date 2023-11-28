Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4175E40BF1
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 23:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y1B8Pgw/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701213287; x=1732749287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wC9bPYbbCelZT4Vxsu7enasvU8lzd+Wr5nV9hwS3+PE=;
  b=Y1B8Pgw/Ua7X6hzJthWZaILGNp9gcpG8x4q/b6orJSmbF/+78zbizzeM
   /QqL5hUUVh5vqvkYfVbOrBWUBZjRvNv3SkqEnpm0GqxXWrI39EQkY+7L2
   AJmKmlQJ6PY0OaQ50VVVVt62sKM+086nTuxAusW0TQ80sViIv/oBfQ4FV
   xY43UB254TAjDolf4tzeON1gJNXbpCdjymIOLVMBWL8ZwwS/4WVSAbYaC
   DVIH1SPGnr7ojfRHCzfXiGPQoYe2AQokIJKiRd3nJoiPONKeR/ecoXlcB
   hf863HHDP3IxlCAFNRmSqLcmX/nggRjg5SWnZU5/WKJLHQJAAnSGopY1I
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="479246469"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="479246469"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 15:14:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="886615851"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="886615851"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 15:14:45 -0800
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
Subject: [PATCH v4] x86/resctrl: Add mount option to pick total MBM event
Date: Tue, 28 Nov 2023 15:14:39 -0800
Message-ID: <20231128231439.81691-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231026200214.16017-1-tony.luck@intel.com>
References: <20231026200214.16017-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a "total" mount option to be used in conjunction with "mba_MBps"
to request use of the total memory bandwidth event as the feedback
input to the control loop.

Also fall back to using the total event if the local event is not
supported by the CPU.

Update the once-per-second polling code to use the event (local
or total memory bandwidth).

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Changes since v3:

Reinette suggested that users might like the option to use the total
memory bandwidth event. I tried out some code to make the event runtime
selectable via a r/w file in the resctrl/info directories. But that
got complicated because of the amount of state that needs to be updated
when switching events. Since there isn't a firm use case for user
selectable event, this latest version falls back to the far simpler
case of using a mount option.

 Documentation/arch/x86/resctrl.rst     |  3 +++
 arch/x86/kernel/cpu/resctrl/internal.h |  3 +++
 arch/x86/kernel/cpu/resctrl/monitor.c  | 20 +++++++++-----------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 15 ++++++++++++++-
 4 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index a6279df64a9d..29c3e7137eb8 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -46,6 +46,9 @@ mount options are:
 "mba_MBps":
 	Enable the MBA Software Controller(mba_sc) to specify MBA
 	bandwidth in MBps
+"total":
+	Use total instead of local memory bandwidth to drive the
+	MBA Software Controller
 "debug":
 	Make debug files accessible. Available debug files are annotated with
 	"Available only with debug option".
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index a4f1aa15f0a2..f98fc9adc2da 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -59,6 +59,7 @@ struct rdt_fs_context {
 	bool				enable_cdpl2;
 	bool				enable_cdpl3;
 	bool				enable_mba_mbps;
+	bool				use_mbm_total;
 	bool				enable_debug;
 };
 
@@ -428,6 +429,8 @@ extern struct rdt_hw_resource rdt_resources_all[];
 extern struct rdtgroup rdtgroup_default;
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
 
+extern enum resctrl_event_id mba_mbps_evt_id;
+
 extern struct dentry *debugfs_resctrl;
 
 enum resctrl_res_level {
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index f136ac046851..230297603836 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -431,9 +431,10 @@ static int __mon_event_count(u32 rmid, struct rmid_read *rr)
  */
 static void mbm_bw_count(u32 rmid, struct rmid_read *rr)
 {
-	struct mbm_state *m = &rr->d->mbm_local[rmid];
 	u64 cur_bw, bytes, cur_bytes;
+	struct mbm_state *m;
 
+	m = get_mbm_state(rr->d, rmid, rr->evtid);
 	cur_bytes = rr->val;
 	bytes = cur_bytes - m->prev_bw_bytes;
 	m->prev_bw_bytes = cur_bytes;
@@ -518,6 +519,7 @@ void mon_event_count(void *info)
  */
 static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_domain *dom_mbm)
 {
+	enum resctrl_event_id evt_id = mba_mbps_evt_id;
 	u32 closid, rmid, cur_msr_val, new_msr_val;
 	struct mbm_state *pmbm_data, *cmbm_data;
 	u32 cur_bw, delta_bw, user_bw;
@@ -526,14 +528,14 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_domain *dom_mbm)
 	struct list_head *head;
 	struct rdtgroup *entry;
 
-	if (!is_mbm_local_enabled())
+	if (!is_mbm_enabled())
 		return;
 
 	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
 	closid = rgrp->closid;
 	rmid = rgrp->mon.rmid;
-	pmbm_data = &dom_mbm->mbm_local[rmid];
+	pmbm_data = get_mbm_state(dom_mbm, rmid, evt_id);
 
 	dom_mba = get_domain_from_cpu(smp_processor_id(), r_mba);
 	if (!dom_mba) {
@@ -553,7 +555,7 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_domain *dom_mbm)
 	 */
 	head = &rgrp->mon.crdtgrp_list;
 	list_for_each_entry(entry, head, mon.crdtgrp_list) {
-		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
+		cmbm_data = get_mbm_state(dom_mbm, entry->mon.rmid, evt_id);
 		cur_bw += cmbm_data->prev_bw;
 		delta_bw += cmbm_data->delta_bw;
 	}
@@ -616,18 +618,14 @@ static void mbm_update(struct rdt_resource *r, struct rdt_domain *d, int rmid)
 		rr.evtid = QOS_L3_MBM_TOTAL_EVENT_ID;
 		rr.val = 0;
 		__mon_event_count(rmid, &rr);
+		if (is_mba_sc(NULL) && rr.evtid == mba_mbps_evt_id)
+			mbm_bw_count(rmid, &rr);
 	}
 	if (is_mbm_local_enabled()) {
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
+		if (is_mba_sc(NULL) && rr.evtid == mba_mbps_evt_id)
 			mbm_bw_count(rmid, &rr);
 	}
 }
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 69a1de92384a..39a5b73af4ef 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -57,6 +57,8 @@ static char last_cmd_status_buf[512];
 static int rdtgroup_setup_root(struct rdt_fs_context *ctx);
 static void rdtgroup_destroy_root(void);
 
+enum resctrl_event_id mba_mbps_evt_id;
+
 struct dentry *debugfs_resctrl;
 
 static bool resctrl_debug;
@@ -2294,7 +2296,7 @@ static bool supports_mba_mbps(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
-	return (is_mbm_local_enabled() &&
+	return (is_mbm_enabled() &&
 		r->alloc_capable && is_mba_linear());
 }
 
@@ -2470,6 +2472,10 @@ static int rdt_enable_ctx(struct rdt_fs_context *ctx)
 		ret = set_mba_sc(true);
 		if (ret)
 			goto out_cdpl3;
+		if (ctx->use_mbm_total || !is_mbm_local_enabled())
+			mba_mbps_evt_id = QOS_L3_MBM_TOTAL_EVENT_ID;
+		else
+			mba_mbps_evt_id = QOS_L3_MBM_LOCAL_EVENT_ID;
 	}
 
 	if (ctx->enable_debug)
@@ -2683,6 +2689,7 @@ enum rdt_param {
 	Opt_cdp,
 	Opt_cdpl2,
 	Opt_mba_mbps,
+	Opt_mba_mbps_total,
 	Opt_debug,
 	nr__rdt_params
 };
@@ -2691,6 +2698,7 @@ static const struct fs_parameter_spec rdt_fs_parameters[] = {
 	fsparam_flag("cdp",		Opt_cdp),
 	fsparam_flag("cdpl2",		Opt_cdpl2),
 	fsparam_flag("mba_MBps",	Opt_mba_mbps),
+	fsparam_flag("total",		Opt_mba_mbps_total),
 	fsparam_flag("debug",		Opt_debug),
 	{}
 };
@@ -2717,6 +2725,11 @@ static int rdt_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			return -EINVAL;
 		ctx->enable_mba_mbps = true;
 		return 0;
+	case Opt_mba_mbps_total:
+		if (!is_mbm_total_enabled())
+			return -EINVAL;
+		ctx->use_mbm_total = true;
+		return 0;
 	case Opt_debug:
 		ctx->enable_debug = true;
 		return 0;
-- 
2.41.0

