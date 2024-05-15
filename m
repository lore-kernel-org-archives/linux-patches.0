Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6D915F410
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811826; cv=none; b=GcfBxT914nKUM4BpxZhtHrrgmedBP27385wjh26N7OFoKHGu05OUr5h1OBFJ8bFht8FdubtvC4ovzV5JVpiWd+S7yDjk0hmyqpNqpJdFDrJ/Ms1/rEOuDiiKFpZ3xyYE777yogVBF5ygOtcM+cLgOWT0AHsdGonGoKVo78NPf88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811826; c=relaxed/simple;
	bh=czKlljQin5GaFm+0xyDc9Vi3UAAxcA5z/t7zvNVeNeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9frlFbvW3GvFupsVP8o0T33CcucqQ2KEjVOLVoXIY7byljxWdap5hB6NmyE+32OMdtU8icVZU84k0fCN00lTCtxx1dA3J5r6KadU0tg9o1MCNb9fsN6oZuPzxK0EZ08BgrO1PCP00B5GcnccGbqYcfwO/xvNlbJT6ST+wPWEfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a0tmgwL5; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a0tmgwL5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811825; x=1747347825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=czKlljQin5GaFm+0xyDc9Vi3UAAxcA5z/t7zvNVeNeg=;
  b=a0tmgwL5QUBEBDsFqHcaZ5XvDLqvHtp4J4YPk8V8r57AgUCElW3JwL+T
   EtNzLobBITk0P3+/9TTGJlhq+FwUQqzZpYZF7NgjQoeE+AhqY/Q2FoCSn
   kzdQaBXqePIaRTN4vTgHzb3nZXRAUU7d4C8/xd6d/LI8WgZIzqr8laAfF
   SyeiTwCUXgaarKmeIaAv32mw5pnmkBE9AKHTq7FROMEVfSh41Lu3MA3wp
   KYdl+L3A8CsXF8rNDrKX+cXt6bpf/L95pBjhhLEgpz+kVhxl9lk5iLsiX
   ZZLqOWEF3FUa+8csdBWNfT/rNQPpfMswNRHKbL9JNjiaj2iRHjSo5TBAW
   g==;
X-CSE-ConnectionGUID: +X5m87ZySru7WCP2vEVepg==
X-CSE-MsgGUID: WkYG2TfZQkaikwsewZMU+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671704"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671704"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:36 -0700
X-CSE-ConnectionGUID: wQcXbIbCQlu9THH8nuwuIw==
X-CSE-MsgGUID: tzW/IxadRhSXp+MSTRFJcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989187"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:36 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v18 13/17] x86/resctrl: Handle removing directories in Sub-NUMA (SNC) mode
Date: Wed, 15 May 2024 15:23:21 -0700
Message-ID: <20240515222326.74166-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In SNC mode there are multiple subdirectories in each L3 level monitor
directory (one for each SNC node). If all the CPUs in an SNC node are
taken offline, then just that SNC node directory must be removed. In
non-SNC mode, or when the last SNC node directory is removed, also
remove the L3 monitor directory.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 43 +++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index f0f468babdea..cac32ddd3afd 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3011,17 +3011,46 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
  * and monitor groups with given domain id.
  */
 static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   unsigned int dom_id)
+					   struct rdt_mon_domain *d)
 {
 	struct rdtgroup *prgrp, *crgrp;
+	struct rdt_mon_domain *dom;
+	bool remove_all = true;
+	struct kernfs_node *kn;
+	char subname[32];
 	char name[32];
 
+	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
+	if (r->mon_scope != r->mon_display_scope) {
+		int count = 0;
+
+		list_for_each_entry(dom, &r->mon_domains, hdr.list)
+			if (d->display_id == dom->display_id)
+				count++;
+		if (count > 1) {
+			remove_all = false;
+			sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
+		}
+	}
+
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
-		sprintf(name, "mon_%s_%02d", r->name, dom_id);
-		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
+		if (remove_all) {
+			kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
+		} else {
+			kn = kernfs_find_and_get_ns(prgrp->mon.mon_data_kn, name, NULL);
+			if (kn)
+				kernfs_remove_by_name(kn, subname);
+		}
 
-		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
-			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
+		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
+			if (remove_all) {
+				kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
+			} else {
+				kn = kernfs_find_and_get_ns(prgrp->mon.mon_data_kn, name, NULL);
+				if (kn)
+					kernfs_remove_by_name(kn, subname);
+			}
+		}
 	}
 }
 
@@ -3111,8 +3140,8 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 					   struct rdt_mon_domain *d)
 {
-	struct kernfs_node *parent_kn;
 	struct rdtgroup *prgrp, *crgrp;
+	struct kernfs_node *parent_kn;
 	struct list_head *head;
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
@@ -3984,7 +4013,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
+		rmdir_mondata_subdir_allrdtgrp(r, d);
 
 	if (is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
-- 
2.44.0

