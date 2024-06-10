Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53E115219C
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044550; cv=none; b=pmi5uVJtUfVWJfyC8eH+o2Hs+khpETAgMwTGWk0U1WUlZzeXbihud6IKrdFOOnZBaho7dQJGKJpL+MOZ9XwHBrGU0Fb+l9R1Gjmquw+6ZASkBNWdccDslZPoahc+hWST28TRvNzjyLOtqj0UdVyLWWy49/bRj5dT5o2N9kRELjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044550; c=relaxed/simple;
	bh=OsyflHWv7H5lJh+AcX50fV9S4jfUXjAggiHcOcESirY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBu48xYCBN1/7B18CQFW6P0is081f0+zvjxXI854+fyIsMobv71XGAuGhE6LXEY8CMYlAufLwqgP74LpXeS5MjJP/NboqumOFtS/eIyll4U4CC+AxlGRl8PEGd+BVRc0yxk4IO4DxGR/E9motevE/kAthXdNHyLSS2VteG/4Glc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eNFymVKp; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eNFymVKp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044549; x=1749580549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OsyflHWv7H5lJh+AcX50fV9S4jfUXjAggiHcOcESirY=;
  b=eNFymVKpKtQeTcQCqbtXGKXIn7czEfwxws5oXPyfVLrNIxDHCWjqUZvc
   ayL5Ar1bCaPPZ+LC1kmMVtOhEr9fET4YtluPV5Flpl7BFOjphyGJg+e+U
   dT/uSNCbe6dpV8zcKMo8Zwu9aeOBJEtxau4CNY+ip6BzTMr+BAQEYFHen
   m3AsWo5HPYvoeGpIQjnrcJonBrTStoulISZrNvzVovuLmC0ZgX0dcb18g
   zQiiLKr8mfmF4RwBJmJFEOxWKgJBHjV9r28bOnpvAl8Cy0gPt06mSx5si
   8YF4KgqJotdBdLCca15lGxq1jkUTQl0/dpX885hNeWRNxW6O/QqjIMZrW
   g==;
X-CSE-ConnectionGUID: fk7QW2ZKRgS3n3zeKLAGoA==
X-CSE-MsgGUID: NUQUEKyjSpO24xmvKq3Law==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004853"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004853"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
X-CSE-ConnectionGUID: 4pXbHkaLRbOjf7Fl0qfpEg==
X-CSE-MsgGUID: 4++j+xrtRHqsAP9d2rSwkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576589"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:39 -0700
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
Subject: [PATCH v20 13/18] x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC) mode
Date: Mon, 10 Jun 2024 11:35:23 -0700
Message-ID: <20240610183528.349198-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 41 +++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index fc7f3f139800..5142ce43ac13 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3004,20 +3004,47 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
 
 /*
  * Remove all subdirectories of mon_data of ctrl_mon groups
- * and monitor groups with given domain id.
+ * and monitor groups for the given domain.
  */
 static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   unsigned int dom_id)
+					   struct rdt_mon_domain *d)
 {
 	struct rdtgroup *prgrp, *crgrp;
+	struct kernfs_node *kn;
+	char subname[32];
 	char name[32];
 
+	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
+	if (r->mon_scope != RESCTRL_L3_CACHE) {
+		/*
+		 * SNC mode: Unless the last domain is being removed must
+		 * just remove the SNC subdomain.
+		 */
+		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
+	}
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
 
@@ -3987,7 +4014,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d->hdr.id);
+		rmdir_mondata_subdir_allrdtgrp(r, d);
 
 	if (is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
-- 
2.45.0

