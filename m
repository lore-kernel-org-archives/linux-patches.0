Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CAF322A33
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830660; cv=none; b=mbHuSMv6jz7/ShJXFaEvDkGYFpJhtxHW4iHAUmRD8wqXTeVJ8kuLn/PPFrXEnFvVTA2rH8Fv4YDUJXl6AaWd2l4QotjuoxwC6mP9Uc8Qiiihzzp8RxOThHRGiTG6cs/VwWzn1qWtJ5UeodM6V87xYbPOT7rUiI48I84Oq3Loe1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830660; c=relaxed/simple;
	bh=t9iHAyxu8Fi6yLKyyET7uVNtK2AboFitByCgxUevL7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE65sVAsCTYsNyoqnqR/KUv+VZPZDwrvwBJBo0RUSGfg3wceHnfvUGw/psTVrwZ64PneOM95+vJ1sGb43Rn/pdaBZks9T1qWjKzqobWcQWJDXTNLRC1DbLamF2+OLV2+EqeyZiBZvIUweGQMSR8R2DtsNUk7fEqsnGmaR8h96Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h6ghTBIH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h6ghTBIH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830658; x=1790366658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t9iHAyxu8Fi6yLKyyET7uVNtK2AboFitByCgxUevL7Y=;
  b=h6ghTBIHTy5GTtDd91dMTXW5XjRzL31EU70UNbHlg0kdRC7zr/NiYB9r
   d5d6SJ45enWczD3b7Qvy5gsBMWv+gdGSjI/dprFs1brx9v+n9/4ZZdHUW
   +xBFgelH8Auf4y/cLkDrEBu11i1v+Je6vYhG7/GSOXiDy3b4fGEcr4Ij4
   cfpIrljYQ5GVTjFEcI9DjX8WNkEM0v4NEPFTDPQXJPc3vFyevIyUttU93
   vBfLvsdam+XP9lfs+3ZDWT9Wd6X513aTGoBCqu+/Ry63dXBUkiX9BIS/O
   ltcZVT778SFTUgdYw+Avev+xeSSHOHN3aZYGj4J5rPsBmpEkW7t4CqE+Q
   w==;
X-CSE-ConnectionGUID: OXWg0/g8TVeLICDgH6/lRQ==
X-CSE-MsgGUID: EikcXkNMTiayuT5t/weLKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074276"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074276"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:11 -0700
X-CSE-ConnectionGUID: g/8mBfe3TYWvs+8nBaLGtQ==
X-CSE-MsgGUID: gH5mJoO8SDeUrWWSPElkKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003659"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:10 -0700
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
Subject: [PATCH v11 17/31] x86/resctrl: Find and enable usable telemetry events
Date: Thu, 25 Sep 2025 13:03:11 -0700
Message-ID: <20250925200328.64155-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The INTEL_PMT_TELEMETRY driver provides telemetry region structures of the
types requested by resctrl.

Scan these structures to discover which pass sanity checks to derive
a list of valid regions:

1) They have guid known to resctrl.
2) They have a valid package ID.
3) The enumerated size of the MMIO region matches the expected
   value from the XML description file.
4) At least one region passes the above checks.

For each valid region enable all the events in the associated
event_group::evts[].

Pass a pointer to the pmt_event structure of the event within the struct
event_group that resctrl stores in mon_evt::arch_priv. resctrl passes
this pointer back when asking to read the event data which enables the
data to be found in MMIO.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 38 +++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index f9b5f6cd08f8..98ba9ba05ee5 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -20,9 +20,11 @@
 #include <linux/intel_pmt_features.h>
 #include <linux/intel_vsec.h>
 #include <linux/overflow.h>
+#include <linux/printk.h>
 #include <linux/resctrl.h>
 #include <linux/resctrl_types.h>
 #include <linux/stddef.h>
+#include <linux/topology.h>
 #include <linux/types.h>
 
 #include "internal.h"
@@ -114,12 +116,44 @@ static struct event_group *known_perf_event_groups[] = {
 	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
 		if ((*_peg)->pfg)
 
-/* Stub for now */
-static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
 {
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
 
+static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
+{
+	bool usable_events = false;
+
+	for (int i = 0; i < p->count; i++) {
+		if (skip_telem_region(&p->regions[i], e))
+			continue;
+		usable_events = true;
+	}
+
+	if (!usable_events)
+		return false;
+
+	for (int j = 0; j < e->num_events; j++)
+		resctrl_enable_mon_event(e->evts[j].id, true,
+					 e->evts[j].bin_bits, &e->evts[j]);
+
+	return true;
+}
+
 DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
 		if (!IS_ERR_OR_NULL(_T))
 			intel_pmt_put_feature_group(_T))
-- 
2.51.0

