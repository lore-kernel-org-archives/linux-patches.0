Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540F9234966
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598989; cv=none; b=rbetmqnARcq/UQ7aVYafQ7Pym1og2QcMrickTt0fyici0fXgRQMmCa9x77G+plumcmW/f4pIR401y65TgWa589fW2ii0h1o0Qa8dy37HLy5arwTH8zNaSkr0Kd8wmmEZCzoadMyAWcyecZyEm0HgAna1GhpEZ9oyPXvBKUKCySc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598989; c=relaxed/simple;
	bh=1AOS5NOV/X2OFLA9OJSrKtuSZLspIDShcAFxfbEWq0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpM46k4ljTY58Ho8pe6fwurxUVfEfargMJuAQ6Uf/G+M8VA0Jd35ym8grGONah1b+sPhgKqUe0fD5Wbs8wHHxcM9FSgB7bfLNEnvOqvMn0hoYK8B3u+GorPkzW0f0uE2ZOUPbLjQ6NFUb/ujKtM2XfcyP4fVlg9kYPejosZrHKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X+FiSC5P; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X+FiSC5P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598988; x=1774134988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1AOS5NOV/X2OFLA9OJSrKtuSZLspIDShcAFxfbEWq0E=;
  b=X+FiSC5P4/tV/hxhrgjXYoxKnPo7lmfA+5oLeTeMwbh0mWZ+CQHOforD
   qvj77zzPatbU21ZYYB/Y12XGkNrMu/zP1efUmURbRgthRZ2BgRIJvKXrY
   csF7dc+J37Dpc2UPuXnnTzl2WiXQAhGym4TAF3QZDz8wdIGCv08MZyoJL
   GBgD9vxa9/L4mW4KKDwIDRNHgqbumLUPKW43PhPOi/mA6eWsFy4UkOxwY
   VSTFC6BLhrUayDvTDDose3NSuGYFHX/ol2wElOMowYZJVmWXAhZ5d4nBr
   4bzmC5vqO7tsmFI4tlWiATxxaOgAoVb0KhAzScYFHB3kAIs6ls7tfhiOm
   w==;
X-CSE-ConnectionGUID: eMvP/gBCQ1ye3bo15M0fvw==
X-CSE-MsgGUID: A3w03WS2SJ2L3nqcj61Q/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604620"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604620"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:23 -0700
X-CSE-ConnectionGUID: 1BZc1KJHQNKJiCDrwZSnGw==
X-CSE-MsgGUID: fQ8gWGcQQeCHK72VLxeifQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354321"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:23 -0700
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
Subject: [PATCH v2 11/16] x86/resctrl: Link known events onto RDT_RESOURCE_INTEL_AET.evt_list
Date: Fri, 21 Mar 2025 16:16:01 -0700
Message-ID: <20250321231609.57418-12-tony.luck@intel.com>
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

Core code uses this list to populate "mon_data" directories.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index e2d8eab997fc..9ac912742ef1 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -13,6 +13,7 @@
 
 #include <linux/cpu.h>
 #include <linux/cleanup.h>
+#include <linux/minmax.h>
 #include <linux/slab.h>
 #include "fake_intel_aet_features.h"
 #include <linux/intel_vsec.h>
@@ -308,14 +309,34 @@ void rdt_get_intel_aet_mount(void)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
 	struct rdt_core_mon_domain *d, *tmp;
+	struct telem_entry **tentry;
 	static int do_one_time;
+	struct mon_evt *evt;
+	bool ret = false;
 
 	if (do_one_time)
 		return;
 
 	do_one_time = 1;
 
-	if (!get_events()) {
+	if (!get_events())
+		goto done;
+
+	for (tentry = telem_entry; *tentry; tentry++) {
+		if (!(*tentry)->active)
+			continue;
+		for (int i = 0; (*tentry)->evts[i].evt.name; i++) {
+			evt = &(*tentry)->evts[i].evt;
+			list_add_tail(&evt->list, &r->evt_list);
+			ret = true;
+		}
+		if (!r->num_rmid)
+			r->num_rmid = (*tentry)->num_rmids;
+		else
+			r->num_rmid = min(r->num_rmid, (*tentry)->num_rmids);
+	}
+done:
+	if (!ret) {
 		list_for_each_entry_safe(d, tmp, &r->mon_domains, hdr.list)
 			kfree(d);
 		r->mon_capable = false;
-- 
2.48.1

