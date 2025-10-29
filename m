Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E530734BA33
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754904; cv=none; b=blLEfDNFBpbKCba0X5RSCl5UFUzIrMdHQx9uiVAG20FA6UNoWRay9UXNrQoJ5BiFaj6fZOoUFCJpaJjWYyIJPU+Bm6d/wKRsrzVK0BLRx4IeVwNyclkpDQ3nyjJaxzZ+MNe0K0w3E0PVMpYLB1uZOygnAIfcBF3Z110jKwOuKdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754904; c=relaxed/simple;
	bh=8waToVXIRH1+Who05gUQ619chnkbQ33UmlggM94nuh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5lktK+Vl0zJLSYwlRdetNqWP/RiTI7RJ+Eg+ctThJxnqVxoRSoMLjs8VVPkjVdBH2zfCZHNeqiPThz6kU5ym8AUFkBpLrxlp7x4R+fh2BP6FW7B1/IeEfu63hZiyv5rPUwaEbja+TZbJWTHte1xWUFVsKW5t9avBiksiHLvBTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J7xhwBt+; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J7xhwBt+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754902; x=1793290902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8waToVXIRH1+Who05gUQ619chnkbQ33UmlggM94nuh4=;
  b=J7xhwBt+qPkDcjfxMaXrEaZ2buEfPfHWRyttrIub/+NMe9vxXQaRWKx7
   RPEDgyyv93c0Z8LUkI1HM9sL/dJ42XBKUquBXJ1IJt75bYhzk7/efLztt
   RDEZXH69l6ZK1gSZLKHfPAemsyWEydX7hib/BPv8N2bmH9/yox9Wd33g7
   aQXzuaxavW7/eB5m3FeaPZFMj+YeVwjUW5Isme6DMNj/y9Eru29i/iC8b
   56FySiJOsg2GDJrHdQM+1aAQiH2c3hwL18OyH3SJFIpIcuRwgn8lNKgDu
   3zimppcZ4JXIkDjU8RZVyUs8B2LkJ37VVf9D+psRG9invo54YTFpdNizi
   A==;
X-CSE-ConnectionGUID: waD2MS7sTYKqIiZ3Be2NUw==
X-CSE-MsgGUID: 8CAt7wE+RrqCDyu72DCNJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481331"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481331"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:32 -0700
X-CSE-ConnectionGUID: 2LH8gmHFSj2x+5v29Jtqdw==
X-CSE-MsgGUID: A/nrCL40SqGmyfsz6o0LQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901376"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:31 -0700
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
Subject: [PATCH v13 19/32] x86/resctrl: Find and enable usable telemetry events
Date: Wed, 29 Oct 2025 09:21:02 -0700
Message-ID: <20251029162118.40604-20-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl requests a copy of struct pmt_feature_group from the INTEL_PMT_TELEMETRY
driver for each event_group known to resctrl.

Scan pmt_feature_group::regions[] and mark those that fail the following tests:

1) guid does not match the guid for the event_group.
2) Package ID is invalid.
3) The enumerated size of the MMIO region does not match the expected
   value from the XML description file.

If there are any regions that pass all of these checks enable each of the
telemetry events in event_group::evts[].

Note that it is architecturally possible that some telemetry events are only
supported by a subset of the packages in the system. It is not expected that
systems will ever do this. If they do the user will see event files in resctrl
that always return "Unavailable".

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 58 ++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 5aec929c3441..e8da70eaa7c6 100644
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
@@ -117,12 +119,64 @@ static struct event_group *known_event_groups[] = {
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
+{
+	tr->addr = NULL;
+}
+
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
+	if (!group_has_usable_regions(e, p))
+		return false;
+
+	for (int j = 0; j < e->num_events; j++)
+		resctrl_enable_mon_event(e->evts[j].id, true,
+					 e->evts[j].bin_bits, &e->evts[j]);
+
+	return true;
+}
+
 /*
  * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
  * pmt_feature_group for each known feature. If there is one, the returned
-- 
2.51.0

