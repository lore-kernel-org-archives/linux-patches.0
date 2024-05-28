Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152213F437
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934824; cv=none; b=XyCVqwCToFALMFaNREzze0SsXl5SXESlikUsPUhbZD/1n/CoB1poz7vpMsR+ZHhiAf+CTAzdtTaI1uWWYyZr3VmjLgT7IGubIT8b3YSdHZtQS0WFF8lEsjOpAxUEUO+vPKErNCJZa9NQftQY6eKQquqloTADvMGqCmLDSrrgjgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934824; c=relaxed/simple;
	bh=twBCzOXf9mz4/ADeVLkUTL4eEWTYmC/srg32N+Mi/+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBOWU6JCl/tPh8xcq6ZseuaaAzgaVkDeLRc40fOSgXnMtBGIgcIYgEjY4Y9xQ9wSUsNAnh2sM2McFpTJKZdVE9DqZlF/xW8NumPoZXAr9T7o/R0SmUvrT8CUs7ELjvNmkvDtCHcCEwIXunMlDT+tS2PFjCBzDmi60e2xGUKI4vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=coJHjqyF; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="coJHjqyF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934823; x=1748470823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=twBCzOXf9mz4/ADeVLkUTL4eEWTYmC/srg32N+Mi/+A=;
  b=coJHjqyFXmfl1kTe5hbmLOOWm3EyxaZef5eUm49ko+Tg6YCmLgbzjr50
   8DGZgvfzW5dSwDyxdPYtJPFV0il6Y5LNwvb1UqRAz5mcd8GLR8DbWWykr
   b0ISPShp7ZbKjSzvGJ50ESz/dNgtc9Zofoqcb/ArBZQW0EQXUDmldpcJ4
   G/nDxfXTHqeeSKv4qZ7HhDZvcz6oo+qeb7xzKSAVaDk0ey2m7j2ieJfjM
   r/ZQfZX361znqrwrLTK5TsQlpcvDqM/EiaTOIL09agkYFO2hJELTN22no
   IoH+i+BdTLdqPUozMU9BBzjoNMzWiLdvLfNfZ25/NIKs14llIAyEj9RdA
   w==;
X-CSE-ConnectionGUID: uIzW9Iy5Rv+DbTSimmqFOQ==
X-CSE-MsgGUID: aZmS0t/zTkGrI1L4jJTPuA==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812220"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812220"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:18 -0700
X-CSE-ConnectionGUID: ybok1rAHS0WMcX8u4O7WHg==
X-CSE-MsgGUID: UOIvO2aoRUKDzWT3NECVLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090747"
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
Subject: [PATCH v19 12/20] x86/resctrl: Create Sub-NUMA Cluster (SNC) monitor files
Date: Tue, 28 May 2024 15:19:57 -0700
Message-ID: <20240528222006.58283-13-tony.luck@intel.com>
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

When SNC mode is enabled, create subdirectories and files to monitor
at the SNC node granularity. Monitor files at the L3 granularity are
tagged with a "sum" attribute to indicate that all SNC nodes sharing
an L3 cache should be read and summed to provide the result to the
user.

Note that the "domid" field for files that must sum across SNC domains
has the L3 cache instance id, while non-summing files use the domain id.

Also the "sum" files do not need to make a call to mon_event_read() to
initialize the MBM counters. This will be handled by initializing the
individual SNC nodes that share the L3.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 53 ++++++++++++++++++--------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index dd386ad9458a..6a5c35a176d5 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3026,7 +3026,8 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 }
 
 static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
-			     struct rdt_resource *r, struct rdtgroup *prgrp)
+			     struct rdt_resource *r, struct rdtgroup *prgrp,
+			     bool do_sum)
 {
 	union mon_data_bits priv;
 	struct mon_evt *mevt;
@@ -3037,15 +3038,18 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 		return -EPERM;
 
 	priv.u.rid = r->rid;
-	priv.u.domid = d->hdr.id;
+	priv.u.domid = do_sum ? d->ci->id : d->hdr.id;
+	priv.u.sum = do_sum;
 	list_for_each_entry(mevt, &r->evt_list, list) {
 		priv.u.evtid = mevt->evtid;
 		ret = mon_addfile(kn, mevt->name, priv.priv);
 		if (ret)
 			return ret;
 
-		if (is_mbm_event(mevt->evtid))
+		if (!do_sum && is_mbm_event(mevt->evtid)) {
+			rr.sumdomains = 0;
 			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
+		}
 	}
 
 	return 0;
@@ -3055,23 +3059,42 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 				struct rdt_mon_domain *d,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
-	struct kernfs_node *kn;
+	struct kernfs_node *kn, *ckn;
 	char name[32];
+	bool snc_mode;
 	int ret;
 
-	sprintf(name, "mon_%s_%02d", r->name, d->hdr.id);
-	/* create the directory */
-	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
-	if (IS_ERR(kn))
-		return PTR_ERR(kn);
+	snc_mode = r->mon_scope != RESCTRL_L3_CACHE;
+	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
+	kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
+	if (!kn) {
+		/* create the directory */
+		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
+		if (IS_ERR(kn))
+			return PTR_ERR(kn);
 
-	ret = rdtgroup_kn_set_ugid(kn);
-	if (ret)
-		goto out_destroy;
+		ret = rdtgroup_kn_set_ugid(kn);
+		if (ret)
+			goto out_destroy;
+		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
+		if (ret)
+			goto out_destroy;
+	}
 
-	ret = mon_add_all_files(kn, d, r, prgrp);
-	if (ret)
-		goto out_destroy;
+	if (snc_mode) {
+		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
+		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
+		if (IS_ERR(ckn))
+			goto out_destroy;
+
+		ret = rdtgroup_kn_set_ugid(ckn);
+		if (ret)
+			goto out_destroy;
+
+		ret = mon_add_all_files(ckn, d, r, prgrp, false);
+		if (ret)
+			goto out_destroy;
+	}
 
 	kernfs_activate(kn);
 	return 0;
-- 
2.45.0

