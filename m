Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D55513FD8D
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934826; cv=none; b=UwPQQiXak9SIdIvqA1+cJvAjrC5eY82x6Y3+TrI/VsDR/nNdBGGIckUpnzq+VlOrEIGMGiWyozRK0r7+fPzjJnLs2/i6hfztLZJqKDq04DxoAEBvj9gmDXOA5c8w2CsSuvSWWhyCysqw2jpKU7ojV9E9ef8N0PBTc80F3nPH0jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934826; c=relaxed/simple;
	bh=im/Pz9hg/qCEbfF9S4v7tyMMvbxX1QBNERgbrYVF2eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zp6uJLBP32SvFKtni7WwTE/Ur9Y82oWvKma5rku6u8VXd9NdgaajnN0LKexVN57A4pns8czOqPGMkIDcrpJcVOozjL0OoQQNVUysifv0S001Dh9mkauaJcEkgSWH1JMvOybCF08zxFYzsWqETc8QnsEvfaRTJ8EiktaZ7dF6hb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e1jtw4DL; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e1jtw4DL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934825; x=1748470825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=im/Pz9hg/qCEbfF9S4v7tyMMvbxX1QBNERgbrYVF2eo=;
  b=e1jtw4DLdApY2lHY9w5a/8K+T5fA852hvQI6BQR9l4Y1JLtnFzwKFAR4
   hdwydA+VlFu4Ixh2kKzRt93PshIREG1TcL7gU306tShZUzoFdBvJ98LXn
   fSR1sr2NvAIPWVukGmMSw1f5Fm7T25ZkvZa/qgLEv0MaU3Xur1FNDQOOi
   zPKylenaQdBqGA4fQnL43LEYwHNfIRyMw+xCOUktX26NGiSn7NUzq0FRn
   cnq0lRcoNr+tYC+4r1xKQgu+jf47pXbpXzUR+7QM412xUzp/Df4Rty2Ey
   iIMso6IVJWlkpaEb2+hWIn2r5yqUoaMGxDyk7JCLUrLYT4PjstRGCLRNS
   w==;
X-CSE-ConnectionGUID: oAEVDss0R9yMIh/INZZ8hQ==
X-CSE-MsgGUID: xAD/vV/4TZOPQPOwXhUTXA==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812227"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812227"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:19 -0700
X-CSE-ConnectionGUID: jkHzCNU4SBC1GnfbGCmfyw==
X-CSE-MsgGUID: 3hkeNKh0RqWdZPyGmhO2kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090750"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:18 -0700
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
Subject: [PATCH v19 13/20] x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC) mode
Date: Tue, 28 May 2024 15:19:58 -0700
Message-ID: <20240528222006.58283-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In SNC mode there are multiple subdirectories in each L3 level monitor
directory (one for each SNC node). If all the CPUs in an SNC node are
taken offline, just remove the SNC  directory for that node. In
non-SNC mode, or when the last SNC node directory is removed, also
remove the L3 monitor directory.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 39 ++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 6a5c35a176d5..cdcae13d6c6d 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3011,17 +3011,44 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
  * and monitor groups with given domain id.
  */
 static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   unsigned int dom_id)
+					   struct rdt_mon_domain *d)
 {
 	struct rdtgroup *prgrp, *crgrp;
+	bool remove_all = true;
+	struct kernfs_node *kn;
+	char subname[32];
 	char name[32];
 
+	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
+	if (r->mon_scope != RESCTRL_L3_CACHE) {
+		/*
+		 * SNC mode: If the last domain is being removed, the count of
+		 * CPUs sharing the L3 cache should be 1 (current CPU).
+		 */
+		if (cpumask_weight(&d->ci->shared_cpu_map) > 1) {
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
+			kn = kernfs_find_and_get(prgrp->mon.mon_data_kn, name);
+			if (kn)
+				kernfs_remove_by_name(kn, subname);
+		}
 
-		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
-			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
+		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
+			if (remove_all) {
+				kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
+			} else {
+				kn = kernfs_find_and_get(crgrp->mon.mon_data_kn, name);
+				if (kn)
+					kernfs_remove_by_name(kn, subname);
+			}
+		}
 	}
 }
 
@@ -3984,7 +4011,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
+		rmdir_mondata_subdir_allrdtgrp(r, d);
 
 	if (is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
-- 
2.45.0

