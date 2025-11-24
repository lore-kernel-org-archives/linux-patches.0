Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17B032549A
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010505; cv=none; b=P1nnOpvBcFv54wCf68Aus5336dtHQj8P7zn5u7E9mIx/4S6xFoXrUPDEk+me5R6fQILSokUp34SA1R9nc8Mx/K7zWPXaMH2X8Xl5kYIBubHP0D0akP1zzt2mWijf/A+GoyM5gy8VAKW+9yrkOYFQf4f8v+xilXkC+CLnENj3Ofo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010505; c=relaxed/simple;
	bh=n+gg9cG6VstFpoCB6IkctOIGC7MzoledoWWzPFL/JkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+9j1eZtj00ytSCs3KD6AwhOrfBMxB/kewmiCBn4bltl1F9yOOwzK5i4viSo7zGOvrHSFCe8tGN3TM255FEo+f6bdhN8GLuxR94ciBr8/3Q3gN5cdftYXM/sdUCHLhLPj44F0Ils05GnguGgWXJ2PbzW0UicXuvmFkMkW05r3zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TJlQzuLa; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TJlQzuLa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010504; x=1795546504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n+gg9cG6VstFpoCB6IkctOIGC7MzoledoWWzPFL/JkU=;
  b=TJlQzuLacMLm3uZsGWY3qCK8bMVC06aAteWziGO30M7h4mjnvhfZ5r70
   JxHcP6mmsSTHOdewWtDJIpjVBAnvBFAnmuiYGTktjVLdtO4voYs7tyTLD
   cg/ndOnTKRcVu/rF9NLpwo6Wof6+lRxzKNj8mUytkdpwyF/lxTiCS66Ht
   GnqXlJZVICown7811s+86ortPd15bEZ7562W+Rg0/aCiSdpHq6BfE0kcJ
   y+IX9U/UkOtBkH2SRdSEzB+ht7gfi/UKMKzztKgKdY9CLhcsUevm+17g3
   SvWiB2CsAyrewJtQbONKqVsqQEVFdgkp/Xp1kwXGv8yqTtT2gcXIDBZIc
   w==;
X-CSE-ConnectionGUID: nkaM3VS/RmeDyxUtHsoQoQ==
X-CSE-MsgGUID: unYR/bLnRFqH3rtrYQha7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636788"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636788"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:29 -0800
X-CSE-ConnectionGUID: id7eI2XmSXGIWufSUd6amg==
X-CSE-MsgGUID: BkIN99UwTDO/9DuGGI8Shw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192225015"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:29 -0800
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
Subject: [PATCH v14 21/32] fs/resctrl: Refactor mkdir_mondata_subdir()
Date: Mon, 24 Nov 2025 10:53:58 -0800
Message-ID: <20251124185412.24155-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Population of a monitor group's mon_data directory is unreasonably complicated
because of the support for Sub-NUMA Cluster (SNC) mode.

Split out the SNC code into a helper function to make it easier to add support
for a new telemetry resource.

Move all the duplicated code to make and set owner of domain directories
into the mon_add_all_files() helper and rename to _mkdir_mondata_subdir().

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/rdtgroup.c | 108 +++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 50 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index dce1f0a6d40b..c0db5d8999ee 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3259,57 +3259,65 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	}
 }
 
-static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
-			     struct rdt_resource *r, struct rdtgroup *prgrp,
-			     bool do_sum)
+/*
+ * Create a directory for a domain and populate it with monitor files. Create
+ * summing monitors when @hdr is NULL. No need to initialize summing monitors.
+ */
+static struct kernfs_node *_mkdir_mondata_subdir(struct kernfs_node *parent_kn, char *name,
+						 struct rdt_domain_hdr *hdr,
+						 struct rdt_resource *r,
+						 struct rdtgroup *prgrp, int domid)
 {
-	struct rdt_l3_mon_domain *d;
 	struct rmid_read rr = {0};
+	struct kernfs_node *kn;
 	struct mon_data *priv;
 	struct mon_evt *mevt;
-	int ret, domid;
+	int ret;
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-		return -EINVAL;
+	kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
+	if (IS_ERR(kn))
+		return kn;
+
+	ret = rdtgroup_kn_set_ugid(kn);
+	if (ret)
+		goto out_destroy;
 
-	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	for_each_mon_event(mevt) {
 		if (mevt->rid != r->rid || !mevt->enabled)
 			continue;
-		domid = do_sum ? d->ci_id : d->hdr.id;
-		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
-		if (WARN_ON_ONCE(!priv))
-			return -EINVAL;
+		priv = mon_get_kn_priv(r->rid, domid, mevt, !hdr);
+		if (WARN_ON_ONCE(!priv)) {
+			ret = -EINVAL;
+			goto out_destroy;
+		}
 
 		ret = mon_addfile(kn, mevt->name, priv);
 		if (ret)
-			return ret;
+			goto out_destroy;
 
-		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
+		if (hdr && resctrl_is_mbm_event(mevt->evtid))
 			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt, true);
 	}
 
-	return 0;
+	return kn;
+out_destroy:
+	kernfs_remove(kn);
+	return ERR_PTR(ret);
 }
 
-static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
-				struct rdt_domain_hdr *hdr,
-				struct rdt_resource *r, struct rdtgroup *prgrp)
+static int mkdir_mondata_subdir_snc(struct kernfs_node *parent_kn,
+				    struct rdt_domain_hdr *hdr,
+				    struct rdt_resource *r, struct rdtgroup *prgrp)
 {
-	struct kernfs_node *kn, *ckn;
+	struct kernfs_node *ckn, *kn;
 	struct rdt_l3_mon_domain *d;
 	char name[32];
-	bool snc_mode;
-	int ret = 0;
-
-	lockdep_assert_held(&rdtgroup_mutex);
 
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
+	sprintf(name, "mon_%s_%02d", r->name, d->ci_id);
 	kn = kernfs_find_and_get(parent_kn, name);
 	if (kn) {
 		/*
@@ -3318,41 +3326,41 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		 */
 		kernfs_put(kn);
 	} else {
-		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
+		kn = _mkdir_mondata_subdir(parent_kn, name, NULL, r, prgrp, d->ci_id);
 		if (IS_ERR(kn))
 			return PTR_ERR(kn);
+	}
 
-		ret = rdtgroup_kn_set_ugid(kn);
-		if (ret)
-			goto out_destroy;
-		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
-		if (ret)
-			goto out_destroy;
+	sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
+	ckn = _mkdir_mondata_subdir(kn, name, hdr, r, prgrp, hdr->id);
+	if (IS_ERR(ckn)) {
+		kernfs_remove(kn);
+		return PTR_ERR(ckn);
 	}
 
-	if (snc_mode) {
-		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
-		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
-		if (IS_ERR(ckn)) {
-			ret = -EINVAL;
-			goto out_destroy;
-		}
+	kernfs_activate(kn);
+	return 0;
+}
 
-		ret = rdtgroup_kn_set_ugid(ckn);
-		if (ret)
-			goto out_destroy;
+static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
+				struct rdt_domain_hdr *hdr,
+				struct rdt_resource *r, struct rdtgroup *prgrp)
+{
+	struct kernfs_node *kn;
+	char name[32];
 
-		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
-		if (ret)
-			goto out_destroy;
-	}
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	if (r->rid == RDT_RESOURCE_L3 && r->mon_scope == RESCTRL_L3_NODE)
+		return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
+
+	sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	kn = _mkdir_mondata_subdir(parent_kn, name, hdr, r, prgrp, hdr->id);
+	if (IS_ERR(kn))
+		return PTR_ERR(kn);
 
 	kernfs_activate(kn);
 	return 0;
-
-out_destroy:
-	kernfs_remove(kn);
-	return ret;
 }
 
 /*
-- 
2.51.1

