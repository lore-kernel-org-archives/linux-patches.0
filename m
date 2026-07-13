Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E79834C806
	for <patches@lists.linux.dev>; Mon, 13 Jul 2026 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783964430; cv=none; b=BkJJH6fS8p3PwCZYYD9PMHYRMeA/coFwwRarVPFk4Cj7P9UzBzI3fEXe/4bvupeJhN03H5Wx9Pz/86serwhPzrPvvQAzalhVIUiJtdGFEY8lNtjlU+gO4ykV+cGm0DcFrZd2KHvVB+DTp2mLQR/2K49f3k94+b2i7FKTp0vQ/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783964430; c=relaxed/simple;
	bh=N06nFP2rKh9Q082zQ1ti39fOIdamPmbQxeOLFJ/PMqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHMZFZbz4oxs84rbXMkfWzV+nTYEluhgan6XfGC9g5vsYZpssRU9AFcs/uN0oO+/1jxzK4LzfvqmxLT/kcufUlkfWJ4fbLCG8ksVGKFMgCWf5nX1sl/aJPyIsZDDIyiFUT24otHuuaz6efI2E1KiL41bDTEu+rkmP52OTW3i10A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SOX4DnAe; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SOX4DnAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783964429; x=1815500429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N06nFP2rKh9Q082zQ1ti39fOIdamPmbQxeOLFJ/PMqg=;
  b=SOX4DnAeQGfSrxN3x/UR7B0iHGDNwMakKyJPA38ibiNZYHnA8eqJbfmm
   fQNvt3xj9/oT9znX5Hx2ZTMQ6afGP6t4IPNhSa9GbZnlC3nfjaOvA6YTd
   EhrU5F7r2XxZL8nLapfigkrrtCErJcYFjCXbFXCtuem8G0jkRY3Q6vvLA
   zo0MXnjCJcGRKnP1+RnVbTalfWMCecYrnvucfH7uo0oWqKqR4W8aKkUmH
   BILMwGPhBZCzLZjiN5PNIuaZdNc66YTci+zrQ8JF0QB0Y6crTSgFfsAaw
   aakRXZgnCveN2/UU7JcvVvefsQsXR/Ri/ukGPX+ghFkg9Blfj+dSrkscO
   g==;
X-CSE-ConnectionGUID: yDQeG3/CTIKfcA2e+DZ7tQ==
X-CSE-MsgGUID: HJi8GvRISN67HgOJVin5wA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="107375538"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="107375538"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:26 -0700
X-CSE-ConnectionGUID: 2sQlcYm7QFmobhl3tqEXfQ==
X-CSE-MsgGUID: r1HTY6rsSBuT/mIC8Os5Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254483887"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:25 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v7 3/7] fs/resctrl: Fix deadlock on errors during mount
Date: Mon, 13 Jul 2026 10:39:39 -0700
Message-ID: <fe701825d7f538a6bbac6732230004050300c93e.1783963505.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783963505.git.reinette.chatre@intel.com>
References: <cover.1783963505.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
superblock setup fails inside kernfs_get_tree(), the VFS calls .kill_sb()
(rdt_kill_sb()) on the same thread before kernfs_get_tree() returns.
rdt_kill_sb() unconditionally attempts to acquire rdtgroup_mutex and
deadlock occurs.

Since mount failure resulting from kernfs_get_tree() already calls the
resctrl fs unmount handler (rdt_kill_sb()) let both call the same helper
to make it clear both paths perform the same cleanup.

Call kernfs_get_tree() outside of locks. If kernfs_get_tree() fails and
ctx->kfc.new_sb_created is set, then rdt_kill_sb() has already been called
and no further cleanup is needed.

kernfs_get_tree() may set ctx->kfc.new_sb_created and then fail to obtain
an inode for the new kn, causing the rdt_kill_sb() path to run with one fewer
reference than required for the root to remain accessible in kernfs_kill_sb().
Add an extra hold on rdtgroup_default.kn to defend against this scenario
and ensure the root can be dereferenced safely from kernfs_kill_sb().

Dropping locks before kernfs_get_tree() creates a window where CPU hotplug
callbacks can race with the mount operation. Specifically, an online event
observing resctrl_mounted == true could concurrently append directories to
the unactivated kernfs tree, allocate mon_data structures, and arm background
workers.

This concurrency is safe because the mount has not yet returned to the VFS,
meaning userspace cannot interact with these transient files. If
kernfs_get_tree() subsequently fails, the standard resctrl_unmount() teardown
safely manages the concurrent modifications: any dynamically generated kernfs
nodes are removed, and the associated memory is freed. Any background
workers spawned by the hotplug event will naturally exit without re-arming
when they acquire rdtgroup_mutex and observe resctrl_mounted == false.

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
---
Changes since V2:
- Switch to "Reported-by/Closes" in changelog

Changes since V3:
- Add Ben's Reviewed-by tag.
- Rework subject and changelog.
- s/root kn/root/ in comment. (Chenyu)
- Add Chenyu's Reviewed-by tag.
- Changelog grammar fixes.
- Add snippet to changelog about potential race with hotplug handlers.
---
 fs/resctrl/rdtgroup.c | 83 +++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 27 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 9804e40ad36d..ce964721ba8e 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2989,10 +2989,34 @@ static void resctrl_fs_teardown(void)
 	rdtgroup_destroy_root();
 }
 
+static void resctrl_unmount(void)
+{
+	struct rdt_resource *r;
+
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	rdt_disable_ctx();
+
+	/* Put everything back to default values. */
+	for_each_alloc_capable_rdt_resource(r)
+		resctrl_arch_reset_all_ctrls(r);
+
+	resctrl_fs_teardown();
+	if (resctrl_arch_alloc_capable())
+		resctrl_arch_disable_alloc();
+	if (resctrl_arch_mon_capable())
+		resctrl_arch_disable_mon();
+	resctrl_mounted = false;
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+}
+
 static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
 	unsigned long flags = RFTYPE_CTRL_BASE;
+	struct kernfs_node *rdt_root_kn;
 	struct rdt_l3_mon_domain *dom;
 	struct rdt_resource *r;
 	int ret;
@@ -3068,10 +3092,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	ret = kernfs_get_tree(fc);
-	if (ret < 0)
-		goto out_psl;
-
 	if (resctrl_arch_alloc_capable())
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
@@ -3087,10 +3107,38 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
-	goto out;
+	/*
+	 * Ensure root remains accessible after mutex is unlocked so that
+	 * kernfs_kill_sb() can run safely if called by kernfs_get_tree()'s
+	 * failure path after creating a superblock but before taking reference
+	 * on root kn (for example, if unable to get inode for root kn).
+	 */
+	kernfs_get(rdtgroup_default.kn);
+
+	/*
+	 * Make backup of the current root kn being created to be used in
+	 * kernfs_put(). The additional reference taken above will prevent the
+	 * kn from being freed before kernfs_kill_sb() can run but
+	 * rdtgroup_default.kn may be set to NULL via rdtgroup_destroy_root()
+	 * and its backing root (rdt_root) could be overwritten before
+	 * kernfs_put() can run.
+	 */
+	rdt_root_kn = rdtgroup_default.kn;
+
+	rdt_last_cmd_clear();
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+
+	ret = kernfs_get_tree(fc);
+	/*
+	 * resctrl can only be mounted once, new superblock only expected
+	 * to be created once.
+	 */
+	if (!ctx->kfc.new_sb_created)
+		resctrl_unmount();
+	kernfs_put(rdt_root_kn);
+	return ret;
 
-out_psl:
-	rdt_pseudo_lock_release();
 out_mondata:
 	if (resctrl_arch_mon_capable())
 		kernfs_remove(kn_mondata);
@@ -3110,7 +3158,6 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
-	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 	return ret;
@@ -3197,26 +3244,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
 
 static void rdt_kill_sb(struct super_block *sb)
 {
-	struct rdt_resource *r;
-
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
-
-	rdt_disable_ctx();
-
-	/* Put everything back to default values. */
-	for_each_alloc_capable_rdt_resource(r)
-		resctrl_arch_reset_all_ctrls(r);
-
-	resctrl_fs_teardown();
-	if (resctrl_arch_alloc_capable())
-		resctrl_arch_disable_alloc();
-	if (resctrl_arch_mon_capable())
-		resctrl_arch_disable_mon();
-	resctrl_mounted = false;
+	resctrl_unmount();
 	kernfs_kill_sb(sb);
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 }
 
 static struct file_system_type rdt_fs_type = {
-- 
2.54.0

