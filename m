Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E9D21C9FE
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598984; cv=none; b=qJ1+00L4Vpk4lzN6RmMmJwL4rwiP9QoYJel8IwryHgP2v/KdpIaKrstwWbz3+ar0qUJPc6MeRdNJZEsbdOrNdG1dfW/UZNNl5isvTa734K0Qv30CiraGBv0a3rOkZZT2VX3uBKIZ1pqL6Dce9Q8NTQvWMSFgvV1SHCpRr3D926U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598984; c=relaxed/simple;
	bh=2qZebPO1celI5zXnc6tbjafYOt8jb+LOhGBb2yIgT8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8Hwwv+ybsoa+PhZRFgt7ic4ib8hBXYkM3t8s1AhpYkn2BI9hImfEjiK/9bTQqtwhiwJJ/Jg/3wJJv3MouPtpzPXiZsFksKfh7jmrg1TBC8Zaq6jAEX7jkOi4yNL5GYUBWbCZJ4WqhodE2qmvaaRmAYGTfTWjI4h3ovNNLMIBQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/HVgH7j; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/HVgH7j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598983; x=1774134983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2qZebPO1celI5zXnc6tbjafYOt8jb+LOhGBb2yIgT8Y=;
  b=D/HVgH7je7Dnvyk9UXnTnvgZB/fP1+dWPjRx3x+9NV2gvhwiIEU1FNHE
   4EUX7HSmAY8pbmoRzK5IRP9KmG4/Q29kYNed5HxHv7B33132ZMKza0PGX
   kKoZ+q16bh4ITKfI0CnyDK+BbhLe0ROuQPHKaEeIiPiXImRd/PhZjLoeF
   M9DZ6tfuFlD2OicAvRrwqwnq4EcTTH9onw2/GGfOJXrUxI+nHEEmVuvE4
   nqklIXdQkKVSqYz3iNfhXisLZfJQ3cS+D5C6IUWwJeXJtUJ2TcUC1ShXE
   gCu3dYEcGBZo/rOz8YjMX7Za2p2DqiOjZH2J4zu+jdJAgrIcw6u9+AviD
   g==;
X-CSE-ConnectionGUID: 4jcELwX+SQiMRHX2EJComg==
X-CSE-MsgGUID: fV7SFvLIQWKeERJAY96n7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604568"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604568"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:20 -0700
X-CSE-ConnectionGUID: c4+AXNINQrqB1sn5JSfXdA==
X-CSE-MsgGUID: mXtpd9feSFu+lObkuxo2kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354298"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:20 -0700
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
Subject: [PATCH v2 04/16] x86/resctrl: Change generic monitor functions to use struct rdt_domain_hdr
Date: Fri, 21 Mar 2025 16:15:54 -0700
Message-ID: <20250321231609.57418-5-tony.luck@intel.com>
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

Functions that don't need the internal details of the rdt_mon_domain
can operate on just the rdt_domain_hdr.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c |  2 +-
 fs/resctrl/rdtgroup.c              | 57 +++++++++++++++++++-----------
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 5c7c8bf2c47f..25c3ee78de3d 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -413,7 +413,7 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
 			    u32 closid, enum resctrl_conf_type type);
 int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
-int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
+int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
 void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
 void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
 void resctrl_online_cpu(unsigned int cpu);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 3c343d0d18fb..c316268b4442 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -522,7 +522,7 @@ static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct
 
 	list_add_tail_rcu(&d->hdr.list, add_pos);
 
-	err = resctrl_online_mon_domain(r, d);
+	err = resctrl_online_mon_domain(r, &d->hdr);
 	if (err) {
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 234ec9dbe5b3..dbfb7d3bc3bc 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3048,7 +3048,7 @@ static void mon_rmdir_one_subdir(struct rdtgroup *rdtgrp, char *name, char *subn
  * when last domain being summed is removed.
  */
 static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_mon_domain *d)
+					   struct rdt_domain_hdr *hdr)
 {
 	struct rdtgroup *prgrp, *crgrp;
 	char subname[32];
@@ -3056,9 +3056,15 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	char name[32];
 
 	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
-	if (snc_mode)
-		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
+	if (snc_mode) {
+		struct rdt_mon_domain *d;
+
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
+		sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
+	} else {
+		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	}
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mon_rmdir_one_subdir(prgrp, name, subname);
@@ -3068,11 +3074,12 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	}
 }
 
-static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
+static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
 			     struct rdt_resource *r, struct rdtgroup *prgrp,
 			     bool do_sum)
 {
 	struct rmid_read rr = {0};
+	struct rdt_mon_domain *d;
 	struct mon_data *priv;
 	struct mon_evt *mevt;
 	int ret;
@@ -3080,6 +3087,8 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 	if (WARN_ON(list_empty(&r->evt_list)))
 		return -EPERM;
 
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
+
 	list_for_each_entry(mevt, &r->evt_list, list) {
 		priv = mon_get_default_kn_priv(r, d, mevt, prgrp, do_sum);
 		if (WARN_ON_ONCE(!priv))
@@ -3089,7 +3098,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 		if (ret)
 			return ret;
 
-		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
+		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
 			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
 	}
 
@@ -3097,10 +3106,11 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 }
 
 static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
-				struct rdt_mon_domain *d,
+				struct rdt_domain_hdr *hdr,
 				struct rdt_resource *r, struct rdtgroup *prgrp)
 {
 	struct kernfs_node *kn, *ckn;
+	struct rdt_mon_domain *d;
 	char name[32];
 	bool snc_mode;
 	int ret = 0;
@@ -3108,7 +3118,12 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	lockdep_assert_held(&rdtgroup_mutex);
 
 	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
-	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
+	if (snc_mode) {
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
+	} else {
+		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
+	}
 	kn = kernfs_find_and_get(parent_kn, name);
 	if (kn) {
 		/*
@@ -3124,7 +3139,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		ret = rdtgroup_kn_set_ugid(kn);
 		if (ret)
 			goto out_destroy;
-		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
+		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
 		if (ret)
 			goto out_destroy;
 	}
@@ -3141,7 +3156,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 		if (ret)
 			goto out_destroy;
 
-		ret = mon_add_all_files(ckn, d, r, prgrp, false);
+		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
 		if (ret)
 			goto out_destroy;
 	}
@@ -3159,7 +3174,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
  * and "monitor" groups with given domain id.
  */
 static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
-					   struct rdt_mon_domain *d)
+					   struct rdt_domain_hdr *hdr)
 {
 	struct kernfs_node *parent_kn;
 	struct rdtgroup *prgrp, *crgrp;
@@ -3170,17 +3185,17 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 	 * so that mon_get_default_kn_priv() can find the allocated structure
 	 * on subsequent calls.
 	 */
-	mkdir_mondata_subdir(kn_mondata, d, r, &rdtgroup_default);
+	mkdir_mondata_subdir(kn_mondata, hdr, r, &rdtgroup_default);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		parent_kn = prgrp->mon.mon_data_kn;
 		if (prgrp != &rdtgroup_default)
-			mkdir_mondata_subdir(parent_kn, d, r, prgrp);
+			mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
 
 		head = &prgrp->mon.crdtgrp_list;
 		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
 			parent_kn = crgrp->mon.mon_data_kn;
-			mkdir_mondata_subdir(parent_kn, d, r, crgrp);
+			mkdir_mondata_subdir(parent_kn, hdr, r, crgrp);
 		}
 	}
 }
@@ -3189,14 +3204,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
 				       struct rdt_resource *r,
 				       struct rdtgroup *prgrp)
 {
-	struct rdt_mon_domain *dom;
+	struct rdt_domain_hdr *hdr;
 	int ret;
 
 	/* Walking r->domains, ensure it can't race with cpuhp */
 	lockdep_assert_cpus_held();
 
-	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
-		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
+	list_for_each_entry(hdr, &r->mon_domains, list) {
+		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
 		if (ret)
 			return ret;
 	}
@@ -4055,7 +4070,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	 * per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		rmdir_mondata_subdir_allrdtgrp(r, d);
+		rmdir_mondata_subdir_allrdtgrp(r, &d->hdr);
 
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
@@ -4137,10 +4152,12 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
 	return err;
 }
 
-int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
+int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
+	struct rdt_mon_domain *d;
 	int err;
 
+	d = container_of(hdr, struct rdt_mon_domain, hdr);
 	mutex_lock(&rdtgroup_mutex);
 
 	err = domain_setup_mon_state(r, d);
@@ -4163,7 +4180,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
 	 * If resctrl is mounted, add per domain monitor data directories.
 	 */
 	if (resctrl_mounted && resctrl_arch_mon_capable())
-		mkdir_mondata_subdir_allrdtgrp(r, d);
+		mkdir_mondata_subdir_allrdtgrp(r, hdr);
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-- 
2.48.1

