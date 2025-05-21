Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BB523E35D
	for <patches@lists.linux.dev>; Wed, 21 May 2025 22:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867869; cv=none; b=uESeJq+rq+52FemYwGczZxmuJiOlUbIOGtcQqg3Y+VzU2ztV9g6n9/1ocud3CLKrIrcGjFS6ObB8jLOR8ZEukBSBH2KRWyD6E4V25BXCrUSyTeibPIMuRwlCQgz51hOGykZ4hCwEZXg4aIfABSiQrKh4YFChgQt1RqGm8oabBjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867869; c=relaxed/simple;
	bh=822xnb/jdoR2cK+I8yE6V0NV0swnShWV0Uhr4ay0ejM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcO+5L9eTsDbsp+qzsoxgyAaWpXnnND5tPAQA6NLUWuaTxRAPVENOstXj6FEoY/U4CHRGQBERb+OcrN/T8crqBztKIs2zprqfQwgWhDTjWNyykgFlwHKg0RueJfBzNHPPn7r+zC7gjV9kSahPft2PqWizm573tOVrddgT+ODHu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H01gCkce; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H01gCkce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747867867; x=1779403867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=822xnb/jdoR2cK+I8yE6V0NV0swnShWV0Uhr4ay0ejM=;
  b=H01gCkceksiyJ+mRq6a3vRXcuXDxrXt9Iap9yy/fHl9W5sQKO4LNyae5
   uQvVK3oRqFJAisrEzifV8N6Ey9/x8jEMKtiQUxV+IxE6A2/2iESENop37
   240Hnjk2EEhHzbSdD2kmeD9v23b4RX1C/EGDtU4AFXPAJCp+K8ht/OblQ
   UQH+LxzdkXFMZw6xvVh/0NgdqL46XeGb7+G6KmiXqcO/+hJnfdZLDi9sv
   zPniqVa+BKygw8nWdhV7iMLfD53TW8FPf49yp+WjhIcTBf/YP0FS0AYpw
   5FhmAyCSeQpTU7OHA/sZibfAvaHTpZmFcglLk+aKWJkkHcaei1cIaZZAH
   g==;
X-CSE-ConnectionGUID: ubr98wVVQfG34AQ7bw2xAQ==
X-CSE-MsgGUID: 8wBAkkSFToKWS3tmoPkYrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="53677737"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="53677737"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:59 -0700
X-CSE-ConnectionGUID: 1mWQzem4TVSJ2cgR4QxdcQ==
X-CSE-MsgGUID: QSt0W77vSYiFMkKUsRCXdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="141352172"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 15:50:58 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 17/29] x86/resctrl: Discover hardware telemetry events
Date: Wed, 21 May 2025 15:50:35 -0700
Message-ID: <20250521225049.132551-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250521225049.132551-1-tony.luck@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hardware has one or more telemetry event aggregators per package
for each group of telemetry events. Each aggregator provides access
to event counts in an array of 64-bit values in MMIO space. There
is a "guid" (in this case a unique 32-bit integer) which refers to
an XML file published in the https://github.com/intel/Intel-PMT
that provides all the details about each aggregator.

The XML files provide the following information:
1) Which telemetry events are included in the group for this aggregator.
2) The order in which the event counters appear for each RMID.
3) The value type of each event counter (integer or fixed-point).
4) The number of RMIDs supported.
5) Which additional aggregator status registers are included.
6) The total size of the MMIO region for this aggregator.

There is an INTEL_PMT_DISCOVERY driver that enumerate all aggregators
on the system with intel_pmt_get_regions_by_feature(). Call this for
each pmt_feature_id that indicates per-RMID telemetry.

Save the returned pmt_feature_group pointers with guids that are known
to resctrl for use at run time.

Those pointers are returned to the INTEL_PMT_DISCOVERY driver at
resctrl_arch_exit() time.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h  |   3 +
 arch/x86/kernel/cpu/resctrl/core.c      |   5 +
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 129 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
 4 files changed, 138 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 02c9e7d163dc..2b2d4b5a4643 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -167,4 +167,7 @@ void __init intel_rdt_mbm_apply_quirk(void);
 
 void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
 
+bool intel_aet_get_events(void);
+void __exit intel_aet_exit(void);
+
 #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index ce4885c751e4..64ce561e77a0 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -727,6 +727,9 @@ void resctrl_arch_pre_mount(void)
 
 	if (!atomic_try_cmpxchg(&only_once, &old, 1))
 		return;
+
+	if (!intel_aet_get_events())
+		return;
 }
 
 enum {
@@ -1079,6 +1082,8 @@ late_initcall(resctrl_arch_late_init);
 
 static void __exit resctrl_arch_exit(void)
 {
+	intel_aet_exit();
+
 	cpuhp_remove_state(rdt_online);
 
 	resctrl_exit();
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
new file mode 100644
index 000000000000..df73b9476c4d
--- /dev/null
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -0,0 +1,129 @@
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
+#include <linux/cleanup.h>
+#include <linux/cpu.h>
+#include <linux/resctrl.h>
+
+/* Temporary - delete from final version */
+#include "fake_intel_aet_features.h"
+
+#include "internal.h"
+
+/**
+ * struct event_group - All information about a group of telemetry events.
+ * @pfg:		Points to the aggregated telemetry space information
+ *			within the OOBMSM driver that contains data for all
+ *			telemetry regions.
+ * @guid:		Unique number per XML description file.
+ */
+struct event_group {
+	/* Data fields used by this code. */
+	struct pmt_feature_group	*pfg;
+
+	/* Remaining fields initialized from XML file. */
+	u32				guid;
+};
+
+/*
+ * Link: https://github.com/intel/Intel-PMT
+ * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
+ */
+static struct event_group energy_0x26696143 = {
+	.guid		= 0x26696143,
+};
+
+/*
+ * Link: https://github.com/intel/Intel-PMT
+ * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
+ */
+static struct event_group perf_0x26557651 = {
+	.guid		= 0x26557651,
+};
+
+static struct event_group *known_event_groups[] = {
+	&energy_0x26696143,
+	&perf_0x26557651,
+};
+
+#define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
+
+/* Stub for now */
+static int configure_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	return -EINVAL;
+}
+
+DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,	\
+	if (!IS_ERR_OR_NULL(_T))					\
+		intel_pmt_put_feature_group(_T))
+
+/*
+ * Make a request to the INTEL_PMT_DISCOVERY driver for the
+ * pmt_feature_group for a specific feature. If there is
+ * one the returned structure has an array of telemetry_region
+ * structures. Each describes one telemetry aggregator.
+ * Try to configure any with a known matching guid.
+ */
+static bool get_pmt_feature(enum pmt_feature_id feature)
+{
+	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
+	struct event_group **peg;
+	bool ret;
+
+	p = intel_pmt_get_regions_by_feature(feature);
+
+	if (IS_ERR_OR_NULL(p))
+		return false;
+
+	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
+		for (int i = 0; i < p->count; i++) {
+			if ((*peg)->guid == p->regions[i].guid) {
+				ret = configure_events(*peg, p);
+				if (!ret) {
+					(*peg)->pfg = no_free_ptr(p);
+					return true;
+				}
+				break;
+			}
+		}
+	}
+
+	return false;
+}
+
+/*
+ * Ask OOBMSM discovery driver for all the RMID based telemetry groups
+ * that it supports.
+ */
+bool intel_aet_get_events(void)
+{
+	bool ret1, ret2;
+
+	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
+	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
+
+	return ret1 || ret2;
+}
+
+void __exit intel_aet_exit(void)
+{
+	struct event_group **peg;
+
+	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
+		if ((*peg)->pfg) {
+			intel_pmt_put_feature_group((*peg)->pfg);
+			(*peg)->pfg = NULL;
+		}
+	}
+}
diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
index cf4fac58d068..cca23f06d15d 100644
--- a/arch/x86/kernel/cpu/resctrl/Makefile
+++ b/arch/x86/kernel/cpu/resctrl/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
+obj-$(CONFIG_X86_CPU_RESCTRL)		+= intel_aet.o
 obj-$(CONFIG_X86_CPU_RESCTRL)		+= fake_intel_aet_features.o
 obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
 
-- 
2.49.0

