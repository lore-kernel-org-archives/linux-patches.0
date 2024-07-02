Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0CE3D978
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941910; cv=none; b=SNuKPmVFknIuo3g8EqlgnhYGqkEPHm7PVhL7OcPV+KOETXx3wrWQuUW0+BkJagHn9wpukBnTyRu9+MCUoulQCNMI8w/zSCWeW+XI9bWyi8Wlu2pX9GKJkh3ECqBsLfL1YGsZS0TfNYyaVgQm3y3SmnUZ9e9Lhua3qyDuoTzmEq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941910; c=relaxed/simple;
	bh=KnpBJdOKZ9dQSq2sxlgQhCQaLzNoFXlSJp/peSNP7jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opEL39wp3B6sx/MVc8xSpsGi2digOn1Gx7awLx4rZnXhpw+nQE8hHpJtdkmKHcE18HSYl7600czkKemriksIzVn8DcE4ehBWk/ej73H+laefdOno63Ze3nYXfcTur1Aip9YLS1qud+ZZ2M2istZPo6l0QwFq+hThTJze07A0zAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZgUlNjH; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZgUlNjH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719941909; x=1751477909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KnpBJdOKZ9dQSq2sxlgQhCQaLzNoFXlSJp/peSNP7jM=;
  b=gZgUlNjH+v6sYoQtIaAPxceERF9tWRd+HaXZI63vcSOrPMf4Gdq0Lv7V
   xbk3Oy/TqvXPCEYFr/GiYJ90uqGBVm4hAPbvpgXMgmXAX5z62kYIcqJNA
   0R1HvWX7Rr+xkIcnDvnE8QUx8bq2Pxp8uB9W+DAdBdrgSM80Oy8PsN/1f
   8Ds4hzWrICBDxQgHT7JcFW+hFo3F7VN2j+vGtFn1dOI79nT3FAo8BAEVC
   9a+CvBtqTEUtKW13Oj6G1EvFbuHpsQBeQJKd2BoknEF1eEv4LSQmDKAD3
   Zc9hr5AvlxJaqw1qmRLdYJQK28gD4tH3B82ID8WGByAh/wvJwr/WsYPxo
   Q==;
X-CSE-ConnectionGUID: xLbjCyF/RAOdsFtpIvmkbQ==
X-CSE-MsgGUID: lksQvpoPQMa/9RKugwe9yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="20035382"
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="20035382"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 10:38:27 -0700
X-CSE-ConnectionGUID: Gy8isY38QSqwq7en43wtAQ==
X-CSE-MsgGUID: eQhLNln+RwWdz7qaTA2KVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,178,1716274800"; 
   d="scan'208";a="45836597"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 10:38:27 -0700
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
Subject: [PATCH 14/19] x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC) mode
Date: Tue,  2 Jul 2024 10:38:19 -0700
Message-ID: <20240702173820.90368-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702173820.90368-1-tony.luck@intel.com>
References: <20240702173820.90368-1-tony.luck@intel.com>
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

Add a helper function to avoid duplicated code.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 35 +++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 8502385e389f..58e53f1f52a0 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3006,22 +3006,45 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
 	return ret;
 }
 
+static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subname)
+{
+	struct kernfs_node *kn;
+
+	kn = kernfs_find_and_get(pkn, name);
+	if (!kn)
+		return;
+	kernfs_put(kn);
+
+	if (kn->dir.subdirs <= 1)
+		kernfs_remove(kn);
+	else
+		kernfs_remove_by_name(kn, subname);
+}
+
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
+		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
 
 		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
-			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
+			mon_rmdir_one_subdir(crgrp->mon.mon_data_kn, name, subname);
 	}
 }
 
@@ -3991,7 +4014,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
+		rmdir_mondata_subdir_allrdtgrp(r, d);
 
 	if (is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
-- 
2.45.2

