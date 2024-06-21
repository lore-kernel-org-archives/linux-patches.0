Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E0F170848
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009561; cv=none; b=SJhvx0Qh5b8eseD31F7PooljH/IRQMSVfodXjJJjFz5g6vIWcrYpydzCBGVrohp/pqbQuYw81G2tRL9J5Mll32s3NMjD4L5oPt8FH4bM7eNRhKYDurph/elEkI9odc73EvHYh64dkWgseFRBLDyPqWZMFhCJkCkBsPV+q62LPGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009561; c=relaxed/simple;
	bh=vbo3czjO6fjkVi5lDSOnA6tC+Rn+QstNo8ENLZyaPzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHLxtwfUDNVJCws0wG7NnSVsinvocFe3aH6g4f6SgnxCYCwV84hKM1Qz6InH5s7skSWwKDhy4B4KBsYmM/nYcz+dBL0B8PsqsPnND35VfAw4cIzxrnZevuQ4/F0lGWPA3MgdeVRHEXmwPmKScwYwD1+R+rCwesLND6+wUhshpb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G3A9rtqT; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G3A9rtqT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009559; x=1750545559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vbo3czjO6fjkVi5lDSOnA6tC+Rn+QstNo8ENLZyaPzI=;
  b=G3A9rtqTil1hyTatbxPkUpv3Zxks2bkklRCVa7VA7tpu36Qd3DaXAuP9
   L71G4X1mctA2UeOEUG2r4lAPWugEwHgLLBLN4fCqdfFT43LLWqUXO/TKh
   nCOfnxJNFZKlbsbeBrQhL0WuxaCK8h0kAY3Zkg2cmc5GLbMNIR+eFIBoi
   SeUvc+jfecYQkcRde3QimJH5ymS1+prl2VrmaS3Zok2bzFKBwT/7q1Ihf
   KYLqOaA1QRZ+zxqhd++2ZU8kSl6X+lp3b+D5Pjvb0gZoS6+qn3fvt6arb
   v+zuIRnhsSyulhAgIGYQ7ZBxrGIjq9AHY17Eybp/CEMx+2JYl+Wi3vdU3
   w==;
X-CSE-ConnectionGUID: 7HclIA3kQ9ads/AR9mxvQA==
X-CSE-MsgGUID: auwjGIEGS5u4OzBscgvSqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691341"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691341"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:09 -0700
X-CSE-ConnectionGUID: lpCfsW6TRB2G59aQDiBLzQ==
X-CSE-MsgGUID: mYqYVxABQ6Cq0nNpr7nTqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935680"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:08 -0700
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
Subject: [PATCH v21 13/18] x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC) mode
Date: Fri, 21 Jun 2024 15:38:54 -0700
Message-ID: <20240621223859.43471-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621223859.43471-1-tony.luck@intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
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
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 39 +++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 2591a6876232..14482d88b68c 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3008,20 +3008,45 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
 
 /*
  * Remove all subdirectories of mon_data of ctrl_mon groups
- * and monitor groups with given domain id.
+ * and monitor groups for the given domain. In SNC mode just
+ * remove the subdomain directory (unless it is the last one).
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
 
@@ -3991,7 +4016,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
+		rmdir_mondata_subdir_allrdtgrp(r, d);
 
 	if (is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
-- 
2.45.2

