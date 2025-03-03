Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B88823E25B
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044894; cv=none; b=mOqcIxgoqF2tFnxvXmXXnefFJ1Z3hGFVD2G8l2Bp8FwXHV0num5D9W9QxSAfOIueq1FX5F2Nxlsy7RwxfPU381k6BBxZjefp36NSp2tp+0wk/VRdHf/zbhcjyab3VQyjxhlp/Jkq/n0bUozal0121SG3K14hSHLLVDwo7sN0IG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044894; c=relaxed/simple;
	bh=bl4AE5B4dRHgkyzVt059Ks754gGBJoIMCieRISa5Q+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uez71tHPdPOmFBRnM95tYRwAtef228PP+ES0JfkuC1ltC16wJNN5kp6XQ6/Z+udS0nQGm8WhDyyEo4oaflxy2Ab+hCWI6J4r75wmoDNY7feXd+30HiJQ1nX9l8IeNK7+R8zZBuglmrYQhTqX3ysBr2Xk6Cp0H9saAxALWG1/kmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WuJVD5mu; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WuJVD5mu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044893; x=1772580893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bl4AE5B4dRHgkyzVt059Ks754gGBJoIMCieRISa5Q+Q=;
  b=WuJVD5muxRkQl89rhpEtDIVBZfFGY739nGdYqK6/CNd4nLor+tXBmd9B
   2tuH4kyDDnZJNVRmJ/JO+VZyQIEfDJn8tr6KpVdR5ZwnRPoAl67WYsNZ2
   O9egJit4gBwbfGYrKqhkzSsVdApaCK3j31GfZjPUIANiZSnQ7I7nfwhWL
   XPQlia5odbBnwbwgcIT1v76CEKjKCOfbZd0gD0ZVprXdYyXsRH9eI5vnU
   soylb2WF/NskKbXNHIxcPZrlcAqRPycbYSBusbZ79Ooj62QdHV/YTyVzS
   284nMxEBFckObmwY/yMPzZjOo0CE2giUv9zHvHSgPoP8+a6WHMehXxoQg
   w==;
X-CSE-ConnectionGUID: rBbz/lVLRFi7Wa64isPuKQ==
X-CSE-MsgGUID: 7Y/Dj+GTQUehJGNZMTRn8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835948"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835948"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:47 -0800
X-CSE-ConnectionGUID: vck0jeC+QSSNw+vCsiPgqQ==
X-CSE-MsgGUID: V7CDaGh5SsOpEu+d/8Hhcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982294"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:52 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 08/17] x86/resctrl: Add initialization hook for Intel PMT events
Date: Mon,  3 Mar 2025 15:33:28 -0800
Message-ID: <20250303233340.333743-9-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call the OOBMSM discovery code to find out if there are any
event groups that match unique identifiers understood by resctrl.

Note that initiialzation must happen in two phases because the
OOBMSM VSEC discovery process is not complete at resctrl
"lateinit()" initialization time. So there is an initial hook
that assumes that Intel PMT will exist, called early so that
package scoped domain groups are initialized.

At first mount the remainder of initialization is done. If there
are no Intel PMT events, the package domain lists are removed.

Events for specific systems to be added by a separate patch.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |   8 ++
 arch/x86/kernel/cpu/resctrl/internal.h  |   7 +
 arch/x86/kernel/cpu/resctrl/core.c      |   9 +-
 arch/x86/kernel/cpu/resctrl/intel_pmt.c | 169 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c  |   3 +
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 6 files changed, 194 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_pmt.c

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 9b64993a6cc8..6e463c65451b 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -118,6 +118,14 @@ struct rdt_mon_domain {
 	int				cqm_work_cpu;
 };
 
+/**
+ * struct rdt_core_mon_domain - CPUs sharing an Intel-PMT-scoped resctrl monitor resource
+ * @hdr:		common header for different domain types
+ */
+struct rdt_core_mon_domain {
+	struct rdt_domain_hdr	hdr;
+};
+
 /**
  * struct resctrl_cache - Cache allocation related data
  * @cbm_len:		Length of the cache bit mask
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index c8da6fac4720..f530382d8871 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -637,6 +637,13 @@ void closid_free(int closid);
 int alloc_rmid(u32 closid);
 void free_rmid(u32 closid, u32 rmid);
 int rdt_get_mon_l3_config(struct rdt_resource *r);
+#ifdef CONFIG_INTEL_PMT_RESCTRL
+int rdt_get_intel_pmt_mon_config(void);
+void rdt_get_intel_pmt_mount(void);
+#else
+static inline int rdt_get_intel_pmt_mon_config(void) { return 0; }
+static inline void rdt_get_intel_pmt_mount(void) { }
+#endif
 void __exit rdt_put_mon_l3_config(void);
 bool __init rdt_cpu_has(int flag);
 void mon_event_count(void *info);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 75a815383427..c18d79e470d2 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -972,6 +972,7 @@ static __init bool get_rdt_alloc_resources(void)
 static __init bool get_rdt_mon_resources(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	int ret1 = -EINVAL, ret2;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
 		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
@@ -980,15 +981,17 @@ static __init bool get_rdt_mon_resources(void)
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
 		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
 
-	if (!rdt_mon_features)
-		return false;
+	if (rdt_mon_features)
+		ret1 = rdt_get_mon_l3_config(r);
+
+	ret2 = rdt_get_intel_pmt_mon_config();
 
 	if (is_mbm_local_enabled())
 		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
 	else if (is_mbm_total_enabled())
 		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
 
-	return !rdt_get_mon_l3_config(r);
+	return ret1 == 0 || ret2;
 }
 
 static __init void __check_quirks_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/intel_pmt.c b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
new file mode 100644
index 000000000000..44373052ca49
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Resource Director Technology(RDT)
+ * - Intel Telemetry Event Monitoring code
+ *
+ * Copyright (C) 2025 Intel Corporation
+ *
+ * Author:
+ *    Tony Luck <tony.luck@intel.com>
+ */
+
+#define pr_fmt(fmt)   "resctrl: " fmt
+
+#include <linux/cpu.h>
+#include <linux/cleanup.h>
+#include <linux/slab.h>
+#include "fake_intel_pmt_features.h"
+#include <linux/intel_vsec.h>
+#include <asm/resctrl.h>
+
+#include "internal.h"
+
+static struct pmt_feature_group *feat_energy;
+static struct pmt_feature_group *feat_perf;
+
+enum pmt_event_id {
+	PMT_EVENT_ENERGY,
+	PMT_EVENT_ACTIVITY,
+	PMT_EVENT_STALLS_LLC_HIT,
+	PMT_EVENT_C1_RES,
+	PMT_EVENT_UNHALTED_CORE_CYCLES,
+	PMT_EVENT_STALLS_LLC_MISS,
+	PMT_EVENT_AUTO_C6_RES,
+	PMT_EVENT_UNHALTED_REF_CYCLES,
+	PMT_EVENT_UOPS_RETIRED,
+
+	PMT_NUM_EVENTS
+};
+
+enum evt_type {
+	EVT_U64,
+	EVT_U46_18,
+};
+
+#define EVT(id, evtname, offset, t)		\
+	{					\
+		.evt = {			\
+			.evtid = id,		\
+			.name = evtname		\
+		},				\
+		.evt_offset = offset,		\
+		.evt_type = t			\
+	}
+
+struct pmt_event {
+	struct mon_evt	evt;
+	int		evt_offset;
+	enum evt_type	evt_type;
+};
+
+struct telem_entry {
+	char	*name;
+	int	guid;
+	int	num_rmids;
+	int	stride;
+	int	overflow_counter_off;
+	int	last_overflow_tstamp_off;
+	int	last_update_tstamp_off;
+	bool	active;
+	struct pmt_event evts[];
+};
+
+static struct telem_entry *telem_entry[] = {
+	NULL
+};
+
+static struct pkg_info {
+	int			count;
+	struct telemetry_region	*regions;
+} *pkg_info;
+
+static bool count_events(struct pkg_info *pkg, int max_pkgs, struct pmt_feature_group *p)
+{
+	struct telem_entry **tentry;
+	bool found = false;
+
+	for (int i = 0; i < p->count; i++) {
+		struct telemetry_region *tr = &p->regions[i];
+
+		for (tentry = telem_entry; *tentry; tentry++) {
+			if (tr->guid == (*tentry)->guid) {
+				if (tr->plat_info.package_id > max_pkgs) {
+					pr_warn_once("Bad package %d\n", tr->plat_info.package_id);
+					continue;
+				}
+				found = true;
+				(*tentry)->active = true;
+				pkg[tr->plat_info.package_id].count++;
+				break;
+			}
+		}
+	}
+
+	return found;
+}
+
+DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
+	if (!IS_ERR_OR_NULL(_T))					\
+		intel_pmt_put_feature_group(_T))
+
+static bool get_events(void)
+{
+	struct pmt_feature_group *p1 __free(intel_pmt_put_feature_group) = NULL;
+	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
+	int num_pkgs = topology_max_packages();
+	struct pkg_info *pkg __free(kfree) = NULL;
+
+	pkg = kmalloc_array(num_pkgs, sizeof(*pkg_info), GFP_KERNEL | __GFP_ZERO);
+	if (!pkg)
+		return false;
+
+	p1 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_ENERGY_TELEM);
+	p2 = intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_PERF_TELEM);
+
+	if (IS_ERR_VALUE(p1) && IS_ERR_VALUE(p1))
+		return false;
+
+	if (!IS_ERR_VALUE(p1))
+		if (!count_events(pkg, num_pkgs, p1))
+			intel_pmt_put_feature_group(no_free_ptr(p1));
+	if (!IS_ERR_VALUE(p2))
+		if (!count_events(pkg, num_pkgs, p2))
+			intel_pmt_put_feature_group(no_free_ptr(p2));
+
+	if (!IS_ERR_OR_NULL(p1))
+		feat_energy = no_free_ptr(p1);
+	if (!IS_ERR_OR_NULL(p2))
+		feat_perf = no_free_ptr(p2);
+	pkg_info = no_free_ptr(pkg);
+
+	return true;
+}
+
+int rdt_get_intel_pmt_mon_config(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_PMT].r_resctrl;
+
+	INIT_LIST_HEAD(&r->evt_list);
+
+	return 1;
+}
+
+void rdt_get_intel_pmt_mount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_PMT].r_resctrl;
+	struct rdt_core_mon_domain *d, *tmp;
+	static int do_one_time;
+
+	if (do_one_time)
+		return;
+
+	do_one_time = 1;
+
+	if (!get_events()) {
+		list_for_each_entry_safe(d, tmp, &r->mon_domains, hdr.list)
+			kfree(d);
+		r->mon_capable = false;
+	}
+}
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index d2f3718f16af..4259bded5b7b 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2645,6 +2645,9 @@ static int rdt_get_tree(struct fs_context *fc)
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
+
+	rdt_get_intel_pmt_mount();
+
 	/*
 	 * resctrl file system can only be mounted once.
 	 */
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index 72621ea6cd6a..fc79e767b263 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)	+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)	+= ctrlmondata.o pseudo_lock.o
+obj-$(CONFIG_INTEL_PMT_RESCTRL)	+= intel_pmt.o
 obj-$(CONFIG_INTEL_PMT_RESCTRL)	+= fake_intel_pmt_features.o
 CFLAGS_pseudo_lock.o = -I$(src)
-- 
2.48.1

