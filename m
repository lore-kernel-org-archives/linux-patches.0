Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B977434E5C
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 22:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378017; cv=none; b=GZK0D4epV3/QUBZN+fRvle+OqtduKZQaLUfbcZ0q4OvTgQNWod6g4Us9YVqvcby/LsvmVGYeNRJW49GKnrlIN0LBCFIeeDiCQ885GgsTBqQZKHWkUy8k8YVuz8umK0EReoa0K/RISqFzoRmQlMRXzz++QElXmnJKhw2cQUZcwxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378017; c=relaxed/simple;
	bh=N06nFP2rKh9Q082zQ1ti39fOIdamPmbQxeOLFJ/PMqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsjRQlb6Xmsne+V8Q0NNsT3hWOjB9PFHYzRWIebM8dpJjKpImhFWsYWnPvpkCdXmd8VQFn9MGSqD3lHEDAbnreZrn7N2uiwguD0QJ8vrB2WYOVCYxIl7MkkUkG7K3klM4TWXhocTsGIvYF83WAZ4/H3b3rr+Vgoxf2gAq3AX41o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gp0SEJQG; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gp0SEJQG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783378005; x=1814914005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N06nFP2rKh9Q082zQ1ti39fOIdamPmbQxeOLFJ/PMqg=;
  b=Gp0SEJQGchz6wjw/ptS32Sg6cI+7pegSHHgcysVCT1+RK6PJYwx3zNXv
   gVgiBGwd7ED53ixcUX1Z/RfJlSjNS/P3LsxW1EpC7tla+VlqxEFhy8QyF
   QPmQRjBw5yftbwCngZKVFMYbC5HfOnQbRY/hLrV1bAMOSAH4vk2tyhODy
   eQX7kSB7iTzRs/xWcUuzTBELZgo3+wO3xazHJHBLCV7Urbda2HEf+L4ET
   bMWJtozVimN16U2i/YFINyoJHlR9YX05qEYEMLybJlQyu4Tba/HWY5ttU
   p4kISnSCLCc05UBm5PHuQMiP6blvE63+12F5IeqJgnshO7jnVCbOlN1+V
   w==;
X-CSE-ConnectionGUID: kY9Sd8PGTau+HgtqLiyl5w==
X-CSE-MsgGUID: asPRiGbiQuyPpSfMldnNOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="95401522"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="95401522"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:41 -0700
X-CSE-ConnectionGUID: zZOZ/pYYRsiGMZRR4nda2g==
X-CSE-MsgGUID: wDB4i4U3SNirtMg/c0n8WA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:40 -0700
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
Subject: [PATCH v6 06/10] fs/resctrl: Fix deadlock on errors during mount
Date: Mon,  6 Jul 2026 15:46:26 -0700
Message-ID: <64ec3695cd286dfdeaa9043c54ff678fe0386d33.1783377598.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783377598.git.reinette.chatre@intel.com>
References: <cover.1783377598.git.reinette.chatre@intel.com>
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

