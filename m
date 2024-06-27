Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018901A2577
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 20:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520759; cv=none; b=cB5pfEwY3I1RNo6e/sA3YQ5E4wPta7JdLmDa+YIrsLPuGIfcdwqdKXOi8Xi33FvAUbkw1emPRFi/aWacggNQvPvFc8qyuJ/qzlBhWswySMI3rPyfcTZ2lYgdjy9t/VjYN4hFXVua6JAdF1FZY5J5vqBxk503jrMmgZhnRM4YHh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520759; c=relaxed/simple;
	bh=QyDHWOy1sSaunKLVu4tBjbfGSBLpsHu64tRbyDPgVm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahLhNQhuu3MSrx9r699cQyBJIr4+lMSAABrpUFThKvLdBCjBtkJWmNlTCzGeGf5YfK4hxoSHg1pS6+RcQVKNw5AhXipXI/7+eJCgaCkneA7Kj6T+QSOdFt4ComKmQMlg7RHspAOv3p/UTPxNRt3nHHpXu7FlD3Hfn/2KQH/0BTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OEtJQG4g; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OEtJQG4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719520757; x=1751056757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QyDHWOy1sSaunKLVu4tBjbfGSBLpsHu64tRbyDPgVm0=;
  b=OEtJQG4gaBOxjp+M1HG49MjmXNC97R1S6etqErFz5hHgBKFM+mNHfaPV
   S3HQJSxx0vMtfut1Pvpx/gEhxax7PTdRqLKcD8gRAkU1zC1NQZqifJe2V
   9bk6VRWQk3PMNa5t+PKd+gKzowINCO0z2DiXVqoJnNH4hBdFMHQnH5OEz
   1TRaUDA+8HLML6DQI5kohkFL5GLTEMKvYZlO2bzxbCU5Eqqx9ebUV8S61
   3UZoGRgdQZYY28IWg5B/Z3PeNZ6bIMoBI7b3vc1bBVr91i34Yc34Zn+Ru
   O2jBxgE/iH9IBAx9eweZxDHU6vxlq6UuCtdgD/qC8jLxX1Pk2FOEpSqeJ
   Q==;
X-CSE-ConnectionGUID: TqsUvnLASyqaV7kfSco5Jg==
X-CSE-MsgGUID: OA9NhE3rTbeqs7YlpD5qgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16809829"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16809829"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:10 -0700
X-CSE-ConnectionGUID: c4TPycXPR3SV8uNzjbTK+g==
X-CSE-MsgGUID: y+z1GLdjRLyxadh1DFEDbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="82052916"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:10 -0700
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
Subject: [PATCH v22 13/18] x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC) mode
Date: Thu, 27 Jun 2024 13:38:51 -0700
Message-ID: <20240627203856.66628-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627203856.66628-1-tony.luck@intel.com>
References: <20240627203856.66628-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In SNC mode there are multiple subdirectories in each L3 level monitor
directory (one for each SNC node). If all the CPUs in an SNC node are
taken offline, just remove the SNC directory for that node. In
non-SNC mode, or when the last SNC node directory is removed,
remove the L3 monitor directory.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 40 +++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 8502385e389f..67a8188c6d8f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3008,20 +3008,46 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
 
 /*
  * Remove all subdirectories of mon_data of ctrl_mon groups
- * and monitor groups with given domain id.
+ * and monitor groups for the given domain.
+ * Remove files and directories containing "sum" of domain data
+ * when last domain being summed is removed.
  */
 static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   unsigned int dom_id)
+					   struct rdt_mon_domain *d)
 {
 	struct rdtgroup *prgrp, *crgrp;
+	struct kernfs_node *kn;
+	char subname[32];
+	bool snc_mode;
 	char name[32];
 
+	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
+	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
+	if (snc_mode)
+		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
+
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
-		sprintf(name, "mon_%s_%02d", r->name, dom_id);
-		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
+		kn = kernfs_find_and_get(prgrp->mon.mon_data_kn, name);
+		if (!kn)
+			continue;
+		kernfs_put(kn);
+
+		if (kn->dir.subdirs <= 1)
+			kernfs_remove(kn);
+		else
+			kernfs_remove_by_name(kn, subname);
 
-		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
-			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
+		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
+			kn = kernfs_find_and_get(crgrp->mon.mon_data_kn, name);
+			if (!kn)
+				continue;
+			kernfs_put(kn);
+
+			if (kn->dir.subdirs <= 1)
+				kernfs_remove(kn);
+			else
+				kernfs_remove_by_name(kn, subname);
+		}
 	}
 }
 
@@ -3991,7 +4017,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
+		rmdir_mondata_subdir_allrdtgrp(r, d);
 
 	if (is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
-- 
2.45.2

