Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7315822F14D
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278045; cv=none; b=Eloh+7YT5Xo/0025NMYshNjESgeWkDdODkZAMWtHVJ9CPaY4e175YCVDpvR2H/Miws7f3A9M1URiMOusZ9XxokyrFkkTL+VbbMr+VGXoE8fTbr4NrL2I6Aw02QYxQXBVfjrSRJNe5MzEGM1ZNc7yQtRVmmFOVcGU0toLPGCH8Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278045; c=relaxed/simple;
	bh=H9pNqnslVKf0POo/3redOQn+y5DVSgdkaqPFIc2iWwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kknW8CUN2HrtSJdTh9yHSJAXkPrT5sNurYwusGROw+KT5PNKOim2r+nw/5SJjmVdto5mrA4CL5uoLeEe4hjkUTkI08k7k/GB2GC0d59+WLf6mi//eGmePH4WFvdFoDt8oXyKa5YA+1X7U1PgQcNmy14rzqX6L+6UfDA75EZEi2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DikEoRRI; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DikEoRRI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278043; x=1783814043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H9pNqnslVKf0POo/3redOQn+y5DVSgdkaqPFIc2iWwA=;
  b=DikEoRRIoy3uamoGggnssCGUpTOIXaKGWLRryRaNezNVlq/ClKCPQ+Gc
   kYC75PLY6Dik9GIYvakgSdszNmbcCodiiYQxOm2ExTKf5HUpuNnNxRe8V
   mEiRsSPkinZUWezR8k0oJy72AzgmchYL+jMzjF1uJP7ZrYJyD1VhlfGUu
   2eqe1K0gyy7OSCitFXI8n+V5qhkuWZHQkErl/ZN87bosP6sMCB13hACP/
   VAjciTj5/nkdFmfo16lj2I2oHbSRSJUgEBSE8306+6Q2oZe5+q0VjNKiG
   C1pdC0LTZcv1jImeSC/M3JbusnloOZr3wRt9I81ge2zdINph554WZbCWI
   Q==;
X-CSE-ConnectionGUID: 2NmR3RPuRr2Iq8lZ4VzULw==
X-CSE-MsgGUID: 6RKFDl2JSpqffHuGzyLnbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292717"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292717"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:01 -0700
X-CSE-ConnectionGUID: ySJ5q6xxSW2858DrnSesAQ==
X-CSE-MsgGUID: d3NTwtIsSIuPijuHTNuwvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902140"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:01 -0700
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
Subject: [PATCH v7 18/31] x86/resctrl: Count valid telemetry aggregators per package
Date: Fri, 11 Jul 2025 16:53:25 -0700
Message-ID: <20250711235341.113933-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There may be multiple telemetry aggregators per package, each enumerated
by a telemetry region structure in the feature group.

Scan the array of telemetry region structures and count how many are
in each package in preparation to allocate structures to save the MMIO
addresses for each in a convenient format for use when reading event
counters.

Sanity check that the telemetry region structures have a valid
package_id and that the size they report for the MMIO space is as
large as expected from the XML description of the registers in
the region.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 55 ++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index d177e5aa1f6a..7cd6c06f9205 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/intel_vsec.h>
 #include <linux/resctrl.h>
+#include <linux/slab.h>
 
 #include "internal.h"
 
@@ -25,6 +26,7 @@
  *			telemetry regions.
  * @list:		List of active event groups.
  * @guid:		Unique number per XML description file.
+ * @mmio_size:		Number of bytes of MMIO registers for this group.
  */
 struct event_group {
 	/* Data fields for additional structures to manage this group. */
@@ -33,16 +35,21 @@ struct event_group {
 
 	/* Remaining fields initialized from XML file. */
 	u32				guid;
+	size_t				mmio_size;
 };
 
 static LIST_HEAD(active_event_groups);
 
+#define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status) \
+	(((num_rmids) * (num_events) + (num_extra_status)) * sizeof(u64))
+
 /*
  * Link: https://github.com/intel/Intel-PMT
  * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
  */
 static struct event_group energy_0x26696143 = {
 	.guid		= 0x26696143,
+	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
 };
 
 /*
@@ -51,6 +58,7 @@ static struct event_group energy_0x26696143 = {
  */
 static struct event_group perf_0x26557651 = {
 	.guid		= 0x26557651,
+	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
 };
 
 static struct event_group *known_energy_event_groups[] = {
@@ -65,10 +73,53 @@ static struct event_group *known_perf_event_groups[] = {
 
 #define NUM_KNOWN_PERF_GROUPS ARRAY_SIZE(known_perf_event_groups)
 
-/* Stub for now */
+static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
+{
+	if (tr->guid != e->guid)
+		return true;
+	if (tr->plat_info.package_id >= topology_max_packages()) {
+		pr_warn_once("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,
+			     tr->guid);
+		return true;
+	}
+	if (tr->size != e->mmio_size) {
+		pr_warn_once("MMIO space %zu wrong size for guid 0x%x\n", tr->size, e->guid);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Discover events from one pmt_feature_group.
+ * 1) Count how many usable telemetry regions per package.
+ * 2...) To be continued.
+ */
 static int discover_events(struct event_group *e, struct pmt_feature_group *p)
 {
-	return -EINVAL;
+	int *pkgcounts __free(kfree) = NULL;
+	struct telemetry_region *tr;
+	int num_pkgs;
+
+	num_pkgs = topology_max_packages();
+
+	/* Get per-package counts of telemetry regions for this event group */
+	for (int i = 0; i < p->count; i++) {
+		tr = &p->regions[i];
+		if (skip_this_region(tr, e))
+			continue;
+		if (!pkgcounts) {
+			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
+			if (!pkgcounts)
+				return -ENOMEM;
+		}
+		pkgcounts[tr->plat_info.package_id]++;
+	}
+
+	if (!pkgcounts)
+		return -ENODEV;
+
+	return 0;
 }
 
 DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
-- 
2.50.0

