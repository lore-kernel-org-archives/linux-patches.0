Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9EE3F2106
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 03:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780457284; cv=none; b=YItGqYtVhUZ7CAOBRAFw7zOkMy9qjQEcWx1u2U7Sid7g/+qQGGB6rSMLqnD+AOzuvny4oxuHXmPF18IXvVJUGL42BPATl27fu3srLCTVpqFwViPvqFa3zYzM1tJA+SEWWXhzke0W296dNhX8W9Vvw0pEf07F0a3WYtmQrMtJjFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780457284; c=relaxed/simple;
	bh=LHCo0MUmMyDzclk6PO+WqAPmteois0/AC1uNvOLDCqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOVtYodaPnIocq3s3vpUUGqLA4MUc/8cltMPed4loxShE3L6VK/OKe3xTmb1ILjroTdrNq0dlcoH+rk2Wy0OvO7tXyQ47DUbPRaI/N4kdMY7hN/AkscAiDmPzUWHuEao/GwuVUJlDFg1uNzlhz9z5lvmIweft5q+GU7aDE9pk6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iy81/ARA; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iy81/ARA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780457283; x=1811993283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LHCo0MUmMyDzclk6PO+WqAPmteois0/AC1uNvOLDCqs=;
  b=iy81/ARAlSMTI7jvpUcJhvuJ0/lDedOdWrr6TSr8DdfH6nU8ONIf//VM
   /YcCifWzZy4HWZhXcf7n3JL7c9bKndU6mCs+vwbn5yKxvQybSa8lziDX9
   pllcgudhLBODhvEHl5WpOW9q6pq/FbVQiuT3n7ZO3+8gR5VfxouZoNFrL
   Ip8IFQ+/gEeX37XzPe8WLqRHhIaL0KZz1jjeFN82Vf08ZL2cJKfzNaoVp
   k0kowyOnrz9ccMV1ng5fHs5kctN2neoTS7fZSkwVhope+ZtRIXq4LPuLW
   gZXOMrQHhwO2Jjd3XjWjwQQOjc9yEs5LfE0s7YROWKGuIkOK4DpKCBd8e
   w==;
X-CSE-ConnectionGUID: 8LIXFc4BT7CYSDyhj8haHQ==
X-CSE-MsgGUID: Xppm9IpnSf6bpEpsg6kURA==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="91939010"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="91939010"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:00 -0700
X-CSE-ConnectionGUID: Dm+WnOybRc2uEBTPpVFKJg==
X-CSE-MsgGUID: LEkV1cLHQcGp9diTW8qpLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241110110"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:00 -0700
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
Subject: [PATCH v4 05/10] fs/resctrl: Fix deadlock on errors during mount
Date: Tue,  2 Jun 2026 20:27:33 -0700
Message-ID: <1184040fb321fb99fde6155a4ab91c654b059b1b.1780456704.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1780456704.git.reinette.chatre@intel.com>
References: <cover.1780456704.git.reinette.chatre@intel.com>
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
index 809f0965474c..0d073d4db734 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2987,10 +2987,34 @@ static void resctrl_fs_teardown(void)
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
@@ -3066,10 +3090,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	ret = kernfs_get_tree(fc);
-	if (ret < 0)
-		goto out_psl;
-
 	if (resctrl_arch_alloc_capable())
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
@@ -3085,10 +3105,38 @@ static int rdt_get_tree(struct fs_context *fc)
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
@@ -3108,7 +3156,6 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
-	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 	return ret;
@@ -3195,26 +3242,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
 
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
2.50.1

