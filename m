Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B131621C9FE
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598986; cv=none; b=txY1NLIC5eTA4ZpfxDqEZfvQVCAo5s7oEF1Y7jkk9gx0DuR8pYA8IgzlHSD341uJIyb3neXsyOwEllsi8CxbvCv2OS/VeWz8y8o3k/At9CzHe64Rz+lvd4Eho0aWCeY8YrFO524hQZf4AKmuM0F+6JcqIyw6+IaV1aTivhED6J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598986; c=relaxed/simple;
	bh=5pUAwn0PpJ0GvI4TOD5atFueR3MvGjgzGmsNB3jneVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gt8tqw8XT5uE7VpTbe5j3JVkDiw5+G5oEO7Ai9FTbkJSyMo60TP7cYyxnKB9DNK3O496+eeNsrphHpk8/RPlPtisbXUaQH78SwKwKhuewEKSQCRYGVXlNsrgWJ2kfEjZ0NFCQxegXjsfOG/KsrkczbfhkOYt9L+ZXltGLHNK7uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dOKQ1+G2; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dOKQ1+G2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598985; x=1774134985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5pUAwn0PpJ0GvI4TOD5atFueR3MvGjgzGmsNB3jneVA=;
  b=dOKQ1+G2hlnpocJpVNw2xZtq1EKZ/e8YUEqll9blaWx/tAoPWULwA8Vw
   2lptx+dbBiS5HqfVy6DzdbX5d90H5yJn7IwHuSvt/eFH///rxfPaj7b4V
   3Fh0XAGU7s63FCOv69Kn7xMJ49nJgsl4A18s410Wi6KfaVgFTMHK14A+z
   ckOgrwYdwZDSx3Nnfzxsqm4PX4aRfXRkKEq4Gi0LsPAsP2+RuCwV+5JDd
   ESz5TwEsV7X7kj4bfEOT+AoeANdPRfKuGVMy8NYkRuBC4onXDhlcpCQdD
   zY79MfciKdWbV91YiMwi2DvfTO50wNB7vK0xwbjMTwQoHnVcVcQh5zney
   Q==;
X-CSE-ConnectionGUID: 7MjogRbTReSszh5WDoifhw==
X-CSE-MsgGUID: /6nn0ts9RPOuCOSg1gMOAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604589"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604589"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:22 -0700
X-CSE-ConnectionGUID: MqmpnjQTTPO4Zuxgaqno1Q==
X-CSE-MsgGUID: 7P6NfqYBTnOVVY0xNRM5Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354309"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:21 -0700
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
Subject: [PATCH v2 07/16] x86/resctrl: Add initialization hook for Intel PMT events
Date: Fri, 21 Mar 2025 16:15:57 -0700
Message-ID: <20250321231609.57418-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
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

Move definition of struct mon_evt to <linux/resctrl_types.h>

Events for specific systems to be added by a separate patch.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                 |  14 ++
 include/linux/resctrl_types.h           |  14 ++
 arch/x86/kernel/cpu/resctrl/internal.h  |   6 +
 fs/resctrl/internal.h                   |  14 --
 arch/x86/kernel/cpu/resctrl/core.c      |   9 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 211 ++++++++++++++++++++++++
 fs/resctrl/rdtgroup.c                   |   3 +
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 8 files changed, 255 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 6c895ec220fe..999e0802a26e 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -170,6 +170,14 @@ struct rdt_mon_domain {
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
@@ -522,4 +530,10 @@ extern unsigned int resctrl_rmid_realloc_limit;
 int resctrl_init(void);
 void resctrl_exit(void);
 
+#ifdef CONFIG_INTEL_AET_RESCTRL
+void rdt_get_intel_aet_mount(void);
+#else
+static inline void rdt_get_intel_aet_mount(void) { }
+#endif
+
 #endif /* _RESCTRL_H */
diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index 8f967e03af5a..d56fcd082d2c 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -57,4 +57,18 @@ enum resctrl_event_id {
 
 #define QOS_NUM_EVENTS		(QOS_L3_MBM_LOCAL_EVENT_ID + 1)
 
+/**
+ * struct mon_evt - Entry in the event list of a resource
+ * @evtid:		per resource event id
+ * @name:		name of the event
+ * @configurable:	true if the event is configurable
+ * @list:		entry in &rdt_resource->evt_list
+ */
+struct mon_evt {
+	unsigned int		evtid;
+	char			*name;
+	bool			configurable;
+	struct list_head	list;
+};
+
 #endif /* __LINUX_RESCTRL_TYPES_H */
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 521db28efb3f..ada402c7678b 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -168,6 +168,12 @@ void rdt_ctrl_update(void *arg);
 
 int rdt_get_mon_l3_config(struct rdt_resource *r);
 
+#ifdef CONFIG_INTEL_AET_RESCTRL
+int rdt_get_intel_aet_mon_config(void);
+#else
+static inline int rdt_get_intel_aet_mon_config(void) { return 0; }
+#endif
+
 bool rdt_cpu_has(int flag);
 
 void __init intel_rdt_mbm_apply_quirk(void);
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 422f36573db7..f5a698b49e97 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -67,20 +67,6 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
 	return container_of(kfc, struct rdt_fs_context, kfc);
 }
 
-/**
- * struct mon_evt - Entry in the event list of a resource
- * @evtid:		per resource event id
- * @name:		name of the event
- * @configurable:	true if the event is configurable
- * @list:		entry in &rdt_resource->evt_list
- */
-struct mon_evt {
-	unsigned int		evtid;
-	char			*name;
-	bool			configurable;
-	struct list_head	list;
-};
-
 /**
  * struct mon_data - Monitoring details for each event file.
  * @rid:             Resource id associated with the event file.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c8cc3104f56c..1ab0f5eec244 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -882,6 +882,7 @@ static __init bool get_rdt_alloc_resources(void)
 static __init bool get_rdt_mon_resources(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	int ret1 = -EINVAL, ret2;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
 		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
@@ -890,10 +891,12 @@ static __init bool get_rdt_mon_resources(void)
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
 		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
 
-	if (!rdt_mon_features)
-		return false;
+	if (rdt_mon_features)
+		ret1 = rdt_get_mon_l3_config(r);
+
+	ret2 = rdt_get_intel_aet_mon_config();
 
-	return !rdt_get_mon_l3_config(r);
+	return ret1 == 0 || ret2;
 }
 
 static __init void __check_quirks_intel(void)
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..9a8ccb62b4ab
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Resource Director Technology(RDT)
+ * - Intel Application Energy Telemetry
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
+#include "fake_intel_aet_features.h"
+#include <linux/intel_vsec.h>
+#include <asm/resctrl.h>
+
+#include "internal.h"
+
+static struct pmt_feature_group *feat_energy;
+static struct pmt_feature_group *feat_perf;
+
+/* All telemetry events from Intel CPUs */
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
+/**
+ * enum evt_type - Type for values for each event.
+ * @EVT_U64:	Integer up to 64 bits
+ * @EVT_U46_18:	Fixed point binary, 46 bits for integer, 18 binary place bits
+ */
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
+/**
+ * struct pmt_event - Telemetry event.
+ * @evt:	Resctrl event
+ * @evt_offset:	MMIO offset of counter
+ * @evt_type:	Type
+ */
+struct pmt_event {
+	struct mon_evt	evt;
+	int		evt_offset;
+	enum evt_type	evt_type;
+};
+
+/**
+ * struct telem_entry - Summarized form from XML telemetry description
+ * @name:			Name for this group of events
+ * @guid:			Unique ID for this group
+ * @num_rmids:			Number of RMIDS supported
+ * @stride:			Number of bytes of counters for each RMID
+ * @overflow_counter_off:	Offset od overflow count
+ * @last_overflow_tstamp_off:	Offset of overflow timestamp
+ * @last_update_tstamp_off:	Offset of last update timestamp
+ * @active:			Marks this group as active on current CPU
+ * @evts:			Telemetry events in this group
+ */
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
+/* All known telemetry event groups */
+static struct telem_entry *telem_entry[] = {
+	NULL
+};
+
+/* Per-package event groups active on this machine */
+static struct pkg_info {
+	int			count;
+	struct telemetry_region	*regions;
+} *pkg_info;
+
+/*
+ * Scan a feature group looking for guids recognized by this code
+ * and update the per-package counts of known groups.
+ */
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
+/*
+ * Ask OOBMSM discovery driver for all the RMID based telemetry groups
+ * that it supports.
+ */
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
+/*
+ * Early initialization. Cannot do much here because OOBMSM has not
+ * completed enumeration of telemetry event groups.
+ */
+int rdt_get_intel_aet_mon_config(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
+
+	INIT_LIST_HEAD(&r->evt_list);
+
+	return 1;
+}
+
+/*
+ * Late (first mount) initialization. Safe to ask OOBMSM which telemetry
+ * event groups are supported.
+ */
+void rdt_get_intel_aet_mount(void)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
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
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a90291f57330..4833dfa08ce3 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2572,6 +2572,9 @@ static int rdt_get_tree(struct fs_context *fc)
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
+
+	rdt_get_intel_aet_mount();
+
 	/*
 	 * resctrl file system can only be mounted once.
 	 */
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index 2c3b09f95127..a47e1c214087 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
+obj-$(CONFIG_INTEL_AET_RESCTRL)		+= intel_aet.o
 obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
 
 # To allow define_trace.h's recursive include:
-- 
2.48.1

