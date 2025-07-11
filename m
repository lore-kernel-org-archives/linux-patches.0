Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2045242D95
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 23:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278052; cv=none; b=Aewx6LDnsGKe7Lo9d1M3VkchJWRAmTljJp8Pxf2dCb1dGWxP3fibiyUlv/vuoBaOjPWgqhUgp+vKN7IU2y62DSwyRA7vXDZjXKm9hn+1lE8j3KdtfAJIn34h4ChkAtw4BnYrQCkrGlH9Xs5DSAbDf/B4YYE3BYx8J2swDJ+JVUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278052; c=relaxed/simple;
	bh=thwvGKAkN3Yrg4AdnXZgn8rM20h+gaqUq6l9TVWAfw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4O+QtOBraAqLCdwP5vrToVwz001mJO6Alnr9zefG5feLq7nYqEgMx5ATxdGdI5mb/swdRLxc8qu8CR6KJmqkDk7gceeYFJPOSNtVgBr35t9FG2686trebt29CnKJg6tO2DFwN6tm564MOnZwBPBKNypEhdZ5cTijtNkWU8dJCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NApA9KQv; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NApA9KQv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752278050; x=1783814050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=thwvGKAkN3Yrg4AdnXZgn8rM20h+gaqUq6l9TVWAfw4=;
  b=NApA9KQvA0dYDmjXJa7DNXnWzhJXYfmr+d64vWMo0hfedaeQfzJRJvrd
   w8HKssmhYHfKZSeUYOjGuxCzdzI1Rkk9OmBbnC9qp7z0PLYvlMqYDEp+o
   KJAbO7uh5PPjsvda3Z2J6+IldEZsHWdsFmnMs6Amn/MSekw4XBMFeviCq
   H07Sx+rd+nfY43CigbEhLQbulzUke8eiZFhQWTuu7YCu6J7OCCkrsKHHF
   j707prfAc0Jqda5NYmrQepMfTJdhZRTQbqd72K6La6muZmKJVSlRCo963
   ytcA98iC3Kz3KcNbMo/xt0IOA+Ll6/N9lXfCO2YbXjzshrwVy4xv9aKam
   A==;
X-CSE-ConnectionGUID: MTmeShe6Q+qa86hjrhkufg==
X-CSE-MsgGUID: 3/dodOfMRHa6m5f4MumKgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54292786"
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="54292786"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:06 -0700
X-CSE-ConnectionGUID: AFneF7bST6qApLI7VgPcyw==
X-CSE-MsgGUID: hTi5CuxCSI6f2bjAa5kslw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,305,1744095600"; 
   d="scan'208";a="155902166"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 16:54:06 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 26/31] fs/resctrl: Fix life-cycle of closid_num_dirty_rmid
Date: Fri, 11 Jul 2025 16:53:33 -0700
Message-ID: <20250711235341.113933-27-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711235341.113933-1-tony.luck@intel.com>
References: <20250711235341.113933-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

closid_num_dirty_rmid is specific to the L3 resource, but it
is allocated/freed in the more generic dom_data_{init,exit}().

Add helpers to allocate/free closid_num_dirty_rmid.

Rename resctrl_mon_resource_init() to resctrl_mon_l3_resource_init()
and call the closid_num_dirty_rmid_init() here, instead of
allocating in dom_data_init().

Making matching changes to the exit path by renaming
resctrl_mon_resource_exit() to resctrl_mon_l3_resource_exit()
and free closid_num_dirty_rmid here instead of in dom_data_exit().

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h |  6 ++--
 fs/resctrl/monitor.c  | 69 ++++++++++++++++++++++++-------------------
 fs/resctrl/rdtgroup.c | 12 ++++----
 3 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 56fdccb39375..28d505efdb7c 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -358,7 +358,9 @@ int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
 
-void resctrl_mon_resource_exit(void);
+int resctrl_mon_l3_resource_init(void);
+
+void resctrl_mon_l3_resource_exit(void);
 
 void mon_event_count(void *info);
 
@@ -368,8 +370,6 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
 		    cpumask_t *cpumask, struct mon_evt *evt, int first);
 
-int resctrl_mon_resource_init(void);
-
 void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom,
 				unsigned long delay_ms,
 				int exclude_cpu);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 92798e1fb5b0..e3eceba70713 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -86,6 +86,37 @@ unsigned int resctrl_rmid_realloc_threshold;
  */
 unsigned int resctrl_rmid_realloc_limit;
 
+static int closid_num_dirty_rmid_init(struct rdt_resource *r)
+{
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID) &&
+	    !closid_num_dirty_rmid) {
+		u32 num_closid = resctrl_arch_get_num_closid(r);
+		u32 *tmp;
+
+		/*
+		 * If the architecture hasn't provided a sanitised value here,
+		 * this may result in larger arrays than necessary. Resctrl will
+		 * use a smaller system wide value based on the resources in
+		 * use.
+		 */
+		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
+		if (!tmp)
+			return -ENOMEM;
+
+		closid_num_dirty_rmid = tmp;
+	}
+
+	return 0;
+}
+
+static void closid_num_dirty_rmid_exit(void)
+{
+	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
+		kfree(closid_num_dirty_rmid);
+		closid_num_dirty_rmid = NULL;
+	}
+}
+
 /*
  * x86 and arm64 differ in their handling of monitoring.
  * x86's RMID are independent numbers, there is only one source of traffic
@@ -805,36 +836,14 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 static int dom_data_init(struct rdt_resource *r)
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
-	u32 num_closid = resctrl_arch_get_num_closid(r);
 	struct rmid_entry *entry = NULL;
 	int err = 0, i;
 	u32 idx;
 
 	mutex_lock(&rdtgroup_mutex);
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-		u32 *tmp;
-
-		/*
-		 * If the architecture hasn't provided a sanitised value here,
-		 * this may result in larger arrays than necessary. Resctrl will
-		 * use a smaller system wide value based on the resources in
-		 * use.
-		 */
-		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
-		if (!tmp) {
-			err = -ENOMEM;
-			goto out_unlock;
-		}
-
-		closid_num_dirty_rmid = tmp;
-	}
 
 	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
 	if (!rmid_ptrs) {
-		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-			kfree(closid_num_dirty_rmid);
-			closid_num_dirty_rmid = NULL;
-		}
 		err = -ENOMEM;
 		goto out_unlock;
 	}
@@ -870,11 +879,6 @@ static void dom_data_exit(struct rdt_resource *r)
 	if (!r->mon_capable)
 		goto out_unlock;
 
-	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
-		kfree(closid_num_dirty_rmid);
-		closid_num_dirty_rmid = NULL;
-	}
-
 	kfree(rmid_ptrs);
 	rmid_ptrs = NULL;
 
@@ -938,7 +942,7 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
 }
 
 /**
- * resctrl_mon_resource_init() - Initialise global monitoring structures.
+ * resctrl_mon_l3_resource_init() - Initialise global monitoring structures.
  *
  * Allocate and initialise global monitor resources that do not belong to a
  * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
@@ -949,7 +953,7 @@ bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid)
  *
  * Returns 0 for success, or -ENOMEM.
  */
-int resctrl_mon_resource_init(void)
+int resctrl_mon_l3_resource_init(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	int ret;
@@ -957,6 +961,10 @@ int resctrl_mon_resource_init(void)
 	if (!r->mon_capable)
 		return 0;
 
+	ret = closid_num_dirty_rmid_init(r);
+	if (ret)
+		return ret;
+
 	ret = dom_data_init(r);
 	if (ret)
 		return ret;
@@ -980,9 +988,10 @@ int resctrl_mon_resource_init(void)
 	return 0;
 }
 
-void resctrl_mon_resource_exit(void)
+void resctrl_mon_l3_resource_exit(void)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 
+	closid_num_dirty_rmid_exit();
 	dom_data_exit(r);
 }
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 9e4df213906f..b45f3d63c629 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4114,7 +4114,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
  * Called when the first CPU of a domain comes online, regardless of whether
  * the filesystem is mounted.
  * During boot this may be called before global allocations have been made by
- * resctrl_mon_resource_init().
+ * resctrl_mon_l3_resource_init().
  *
  * Returns 0 for success, or -ENOMEM.
  */
@@ -4298,13 +4298,13 @@ int resctrl_init(void)
 
 	thread_throttle_mode_init();
 
-	ret = resctrl_mon_resource_init();
+	ret = resctrl_mon_l3_resource_init();
 	if (ret)
 		return ret;
 
 	ret = sysfs_create_mount_point(fs_kobj, "resctrl");
 	if (ret) {
-		resctrl_mon_resource_exit();
+		resctrl_mon_l3_resource_exit();
 		return ret;
 	}
 
@@ -4339,7 +4339,7 @@ int resctrl_init(void)
 
 cleanup_mountpoint:
 	sysfs_remove_mount_point(fs_kobj, "resctrl");
-	resctrl_mon_resource_exit();
+	resctrl_mon_l3_resource_exit();
 
 	return ret;
 }
@@ -4375,7 +4375,7 @@ static bool resctrl_online_domains_exist(void)
  * When called by the architecture code, all CPUs and resctrl domains must be
  * offline. This ensures the limbo and overflow handlers are not scheduled to
  * run, meaning the data structures they access can be freed by
- * resctrl_mon_resource_exit().
+ * resctrl_mon_l3_resource_exit().
  *
  * After resctrl_exit() returns, the architecture code should return an
  * error from all resctrl_arch_ functions that can do this.
@@ -4402,5 +4402,5 @@ void resctrl_exit(void)
 	 * it can be used to umount resctrl.
 	 */
 
-	resctrl_mon_resource_exit();
+	resctrl_mon_l3_resource_exit();
 }
-- 
2.50.0

