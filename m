Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F6348899
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992137; cv=none; b=oDIPUExM+AZXBnpS58V7a7RBPxdPeZ0USz3NDTv4/vjD0KULexjDlrxokZW1vEc8VW3tj2ghrvP/0gZdYig1sRW+uQDKQxCju39tAC7Zuy/7lKdlVTtgmOYCI80lu7HXrDkxfz5miujLqyX2zjNlZH30FtonxcGIcPyaQEBfYSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992137; c=relaxed/simple;
	bh=r9/SaTDuhADJcxD35E/PXmvo/0b+jPhe1RyqZ/TFzbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfjSWRO6W0hxMRFZyk42NgXuFG2ERlnvM6yt1N7333ugSJIbZlhmKklb+JVOKuNNu0Ep8dpfQOVDVe9c1KfV22SUYtz1V1jG+ElCPFReUOxgR+ee/sOYyjO5QosqTBO11JpnzCm2G/bqdnzv1wRRMl+G/uSZcmBKnz6lW2m/6yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iu45WpZl; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iu45WpZl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992130; x=1797528130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r9/SaTDuhADJcxD35E/PXmvo/0b+jPhe1RyqZ/TFzbQ=;
  b=iu45WpZlKAdE3tPpjvSYwIZKl1G7G+hmhWXCloDLk3qKU9giwBCtKiCD
   ExenNso8fmPOcw8TM7aG6dReLV4A+jHToV1eV/B7AfZc/e7cuTFTfqruS
   2E6aEySqr7hd9uaDaE82VSbhrk9MFbDH9wIBmkzFI4WMHtbflCuyWrngH
   RXlCssmHgwfirS9hSy0VFoxk65rp8rldfQSp0HVsAIHPirBURkcCEB6Z4
   yLyH3SUevgtd6OD9Toex94T73aWyZtpie/ObYSITsEkEccO2JkqbPrSMY
   iJ9fB2O4jBz6mL+kszlzxUYzY0pKhN5E3OowqkgW+wRwcgp2mnwbpxePs
   g==;
X-CSE-ConnectionGUID: R5XU0ImHS1umCn3+sEUAGg==
X-CSE-MsgGUID: Y2C+9Yw6RpGDO34uAepLEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594782"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594782"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:36 -0800
X-CSE-ConnectionGUID: VtBPVA5OTZC6e3Ep4AKi6g==
X-CSE-MsgGUID: D88G+GkYQn6zUA/ZwMjReA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748228"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:34 -0800
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
Subject: [PATCH v17 19/32] x86/resctrl: Find and enable usable telemetry events
Date: Wed, 17 Dec 2025 09:21:06 -0800
Message-ID: <20251217172121.12030-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every event group has a private copy of the data of all telemetry event
aggregators (aka "telemetry regions") tracking its feature type. Included
may be regions that have the same feature type but tracking different guid
from the event group's.

Traverse the event group's telemetry region data and mark all regions that
are not usable by the event group as unusable by clearing those regions'
MMIO addresses. A region is considered unusable if:
1) guid does not match the guid of the event group.
2) Package ID is invalid.
3) The enumerated size of the MMIO region does not match the expected
   value from the XML description file.

Hereafter any telemetry region with an MMIO address is considered valid for
the event group it is associated with.

Enable all the event group's events as long as there is at least one usable
region from where data for its events can be read. Enabling of an event can
fail if the same event has already been enabled as part of another event
group. It should never happen that the same event is described by different
guid supported by the same system so just WARN (via resctrl_enable_mon_event())
and skip the event.

Note that it is architecturally possible that some telemetry events are
only supported by a subset of the packages in the system. It is not expected
that systems will ever do this. If they do the user will see event files in
resctrl that always return "Unavailable".

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h                 |  2 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 67 ++++++++++++++++++++++++-
 fs/resctrl/monitor.c                    | 10 ++--
 3 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index b30f99335bbe..14126d228e61 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -414,7 +414,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 			      unsigned int binary_bits, void *arch_priv);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index c7d08eb26395..611c6b1fc08d 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -16,9 +16,11 @@
 #include <linux/init.h>
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
+#include <linux/printk.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
 #include <linux/stddef.h>
+#include <linux/topology.h>
 #include <linux/types.h>
 
 #include "internal.h"
@@ -110,12 +112,73 @@ static struct event_group *known_event_groups[] = {
 	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
 	     _peg++)
 
-/* Stub for now */
-static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+/*
+ * Clear the address field of regions that did not pass the checks in
+ * skip_telem_region() so they will not be used by intel_aet_read_event().
+ * This is safe to do because intel_pmt_get_regions_by_feature() allocates
+ * a new pmt_feature_group structure to return to each caller and only makes
+ * use of the pmt_feature_group::kref field when intel_pmt_put_feature_group()
+ * returns the structure.
+ */
+static void mark_telem_region_unusable(struct telemetry_region *tr)
 {
+	tr->addr = NULL;
+}
+
+static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
+{
+	if (tr->guid != e->guid)
+		return true;
+	if (tr->plat_info.package_id >= topology_max_packages()) {
+		pr_warn("Bad package %u in guid 0x%x\n", tr->plat_info.package_id,
+			tr->guid);
+		return true;
+	}
+	if (tr->size != e->mmio_size) {
+		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
+			tr->size, e->guid, e->mmio_size);
+		return true;
+	}
+
 	return false;
 }
 
+static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_group *p)
+{
+	bool usable_regions = false;
+
+	for (int i = 0; i < p->count; i++) {
+		if (skip_telem_region(&p->regions[i], e)) {
+			mark_telem_region_unusable(&p->regions[i]);
+			continue;
+		}
+		usable_regions = true;
+	}
+
+	return usable_regions;
+}
+
+static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
+	int skipped_events = 0;
+
+	if (!group_has_usable_regions(e, p))
+		return false;
+
+	for (int j = 0; j < e->num_events; j++) {
+		if (!resctrl_enable_mon_event(e->evts[j].id, true,
+					      e->evts[j].bin_bits, &e->evts[j]))
+			skipped_events++;
+	}
+	if (e->num_events == skipped_events) {
+		pr_info("No events enabled in %s %s:0x%x\n", r->name, e->pfname, e->guid);
+		return false;
+	}
+
+	return true;
+}
+
 static enum pmt_feature_id lookup_pfid(const char *pfname)
 {
 	if (!strcmp(pfname, "energy"))
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index af43a33ce4cb..9af08b673e39 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -997,25 +997,27 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
 			      unsigned int binary_bits, void *arch_priv)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS ||
 			 binary_bits > MAX_BINARY_BITS))
-		return;
+		return false;
 	if (mon_event_all[eventid].enabled) {
 		pr_warn("Duplicate enable for event %d\n", eventid);
-		return;
+		return false;
 	}
 	if (binary_bits && !mon_event_all[eventid].is_floating_point) {
 		pr_warn("Event %d may not be floating point\n", eventid);
-		return;
+		return false;
 	}
 
 	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].binary_bits = binary_bits;
 	mon_event_all[eventid].arch_priv = arch_priv;
 	mon_event_all[eventid].enabled = true;
+
+	return true;
 }
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
-- 
2.52.0

