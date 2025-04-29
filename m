Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA3C20C46D
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886867; cv=none; b=AtAjVrraIVFVTsY5+a//AzdsQ3FX74GdBB5dAxIh/17nDjJW+4FuPt3/hpgHOCAnLt67UARvoKCW8iGXMd/VIEOE9b+RFLoAFDvkLjY8Q2huVxu2Kp5+6StrAE7l0u0HcLPCyk3Cs1NYjniK7R/AABl9TFBc44qDZyL+wxoN8bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886867; c=relaxed/simple;
	bh=Be8xmCPgLLae0t8N+ASzNaMmLpZD+PZ5AUQZY9NvT8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXnyI7SisOcGZzr/5prwpKu+h7hnDmhljvhrEVg9I/9XzwAMKX7FLaWOaHSw6BdySeE80NyZ2dddv1h61kMoXJed+oywHrJDPIgvHH66YsAjMcHzhoanbi81r4tYHaJDy+sC6FhQnIvfc7N74zOunLfxbxXKDU6gssuiNSvsyIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TeckOM2w; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TeckOM2w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886865; x=1777422865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Be8xmCPgLLae0t8N+ASzNaMmLpZD+PZ5AUQZY9NvT8s=;
  b=TeckOM2wUcV4BEjHBeX44DRoiF0+jawmnxYTQwUu1zYOh8TfK7RUAXfo
   ZgrxEpxuwf/eB7pm8/5FOkKio0sExEvBXAgH1wi9ytxfHMmoOl8CADXLP
   YofCK3YjFVuBI90ZRqextX8aufKzrKoSdsnpPyN8ClfN73xzvcH2Rh+I5
   MOtGPIhSvg9XQg/ipoGdX3QYdgVYXh2ewVzTjyb/ef8oCDxOKL5m5CbuB
   u+WQHzrXMc3kF4OcxYAdauEkRamNJi7r9Re9F55OCDskB3tpjR09kL3U2
   2dNWh/3WuNEm91wAkBBx7vYY3iEGENkZ3Zwdg8ymf208CYCY4lXo9QwYc
   Q==;
X-CSE-ConnectionGUID: iAmWLNc4R7its6QFVAhj1w==
X-CSE-MsgGUID: u9vT70mSRp6el686nCEwjg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148226"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148226"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:19 -0700
X-CSE-ConnectionGUID: PKS2wv+NT6CRD/aoT20yDQ==
X-CSE-MsgGUID: wB95YmXASoaY6NNbeFSg3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394035"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:18 -0700
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
Subject: [PATCH v4 20/31] x86/resctrl: Check for adequate MMIO space
Date: Mon, 28 Apr 2025 17:33:46 -0700
Message-ID: <20250429003359.375508-21-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MMIO space for each telemetry aggregator is arranged as a array of
count registers for each event for RMID 0, followed by RMID 1, and so on.
After all event counters there are three status registers.  All registers
are 8 bytes each.

The total size of MMIO space as described by the XML files is thus:

	(NUM_RMIDS * NUM_COUNTERS + 3) * 8

Add an "mmio_size" field to the event_group structure and a sanity
check that the size reported in the telemetry_region structure obtained
from intel_pmt_get_regions_by_feature() is as large as expected.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 7e4f6a6672d4..37dd493df250 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -49,6 +49,7 @@ struct pmt_event {
  *                      retrieved from intel_pmt_get_regions_by_feature().
  * @pfg:		The pmt_feature_group for this event group
  * @guid:		Unique number per XML description file
+ * @mmio_size:		Number of bytes of mmio registers for this group
  * @pkginfo:		Per-package MMIO addresses
  * @num_events:		Number of events in this group
  * @evts:		Array of event descriptors
@@ -56,6 +57,7 @@ struct pmt_event {
 struct event_group {
 	struct pmt_feature_group	*pfg;
 	int				guid;
+	int				mmio_size;
 	struct mmio_info		**pkginfo;
 	int				num_events;
 	struct pmt_event		evts[] __counted_by(num_events);
@@ -64,6 +66,7 @@ struct event_group {
 /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-ENERGY *.xml */
 static struct event_group energy_0x26696143 = {
 	.guid		= 0x26696143,
+	.mmio_size	= (576 * 2 + 3) * 8,
 	.num_events	= 2,
 	.evts				= {
 		EVT(PMT_EVENT_ENERGY, 0),
@@ -74,6 +77,7 @@ static struct event_group energy_0x26696143 = {
 /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-PERF *.xml */
 static struct event_group perf_0x26557651 = {
 	.guid		= 0x26557651,
+	.mmio_size	= (576 * 7 + 3) * 8,
 	.num_events	= 7,
 	.evts				= {
 		EVT(PMT_EVENT_STALLS_LLC_HIT, 0),
@@ -134,6 +138,10 @@ static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
 			pr_warn_once("Bad package %d\n", tr->plat_info.package_id);
 			continue;
 		}
+		if (tr->size < e->mmio_size) {
+			pr_warn_once("MMIO space too small for guid 0x%x\n", e->guid);
+			continue;
+		}
 		pkgcounts[tr->plat_info.package_id]++;
 	}
 
@@ -151,7 +159,8 @@ static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
 	/* Save MMIO address(es) for each aggregator in per-package structures */
 	for (int i = 0; i < p->count; i++) {
 		tr = &p->regions[i];
-		if (tr->guid != e->guid || tr->plat_info.package_id >= num_pkgs)
+		if (tr->guid != e->guid || tr->plat_info.package_id >= num_pkgs ||
+		    tr->size < e->mmio_size)
 			continue;
 		mmi = pkginfo[tr->plat_info.package_id];
 		mmi->addrs[--pkgcounts[tr->plat_info.package_id]] = tr->addr;
-- 
2.48.1

