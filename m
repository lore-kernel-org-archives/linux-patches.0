Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D284037B011
	for <patches@lists.linux.dev>; Fri, 22 May 2026 19:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477330; cv=none; b=qn2zE892tGPXOs3FHkWEHMdOUWcMUKHv8SL7FMEa6d1Mlo2e0oGNyJL7BzIytesNI2Qv00PSLejXs9MuWJwP4ExPrM7GOMyXQvm/PaeAiJXgfOMLybJmEKhc9L3J2Pb1FWZTWOfHjlHr6Ru63jkpAXgrdJIW8pUVex3f2zny6J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477330; c=relaxed/simple;
	bh=pAqfW0Xh8KljEKywHhDPZm56mnGruKod6pG9vzhZKY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzZt4XVkjjuc9/j63ZY3JWLCLVgaTUy5iMTdQaPO/qjLpuu0OpWl7wXFppJ/ojmHDCK+XwuSBumUv5mhfnzviJ9LGhNt4Y4HRDoB7kEA+kNGpdrfY2I1TYXbm8vjvk2YhOcq3QAkr+U3JNTaCYWo+TYb4U7d10xzBdfhMCYpMWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n/rxogOJ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n/rxogOJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779477328; x=1811013328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pAqfW0Xh8KljEKywHhDPZm56mnGruKod6pG9vzhZKY4=;
  b=n/rxogOJSGzXNckNDTKhF1hvWBqAmgaUSe/74Ni64yyv99/d52tAGKpg
   c4n2XpFiRaAI2ipFChV+oby0MnkZRuqMIAcPk4+ye+F5bfHJsoso5G0jT
   eVyu+kpAcaAPS6Sp20IvBcUyu/Evhie2Y4XfD9V45TMnDjJIqO2IPc1rQ
   beYSSLui923Nh9a/cJAdgi1p1zVzzHBxKWK1z1B4XlryAjKiWWCT8kLd6
   /d+ZsWMdnhNHy8b96wAbFSJa7ExIG9GihN3MtQpkXENrnS7LUZqlFyVLI
   ut2QQVBDeOGx68yqXZyg84EePG5Z0sqg7AYataFZ1hvjXTe6V696ewcZC
   A==;
X-CSE-ConnectionGUID: HlO33/raTGGSqUpd/62MLA==
X-CSE-MsgGUID: sJ1CI2igQJy8XmdaucKddQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11794"; a="80140467"
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="80140467"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:23 -0700
X-CSE-ConnectionGUID: bhTRB8K+TX+i268WHcW5aQ==
X-CSE-MsgGUID: y2bX4aFWT5CGk0FT/0nRaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="271336468"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:24 -0700
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
Subject: [PATCH v3 4/9] fs/resctrl: Fix deadlock for errors during mount
Date: Fri, 22 May 2026 12:15:08 -0700
Message-ID: <2e44b91263f1ccc4403a969524594800bead95c4.1779476724.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1779476724.git.reinette.chatre@intel.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
the same thread before the call returns.  rdt_kill_sb() unconditionally
attempts to acquire rdtgroup_mutex and deadlock occurs.

Move the call to kernfs_get_tree() outside of locks. If kernfs_get_tree()
fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb() has already
been called and no further cleanup is needed.

Add an extra hold in this error path on rdtgroup_default.kn to defend against
other races destroying the root which is then dereferenced in kernfs_kill_sb()

Add resctrl_unmount() helper to keep code consistent between the
rdt_get_tree() failure path and a normal unmount.

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- Switch to "Reported-by/Closes" in changelog
---
 fs/resctrl/rdtgroup.c | 82 +++++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 27 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 8a1457825919..d323b515060b 100644
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
@@ -3085,10 +3105,37 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
-	goto out;
+	/*
+	 * Ensure root kn remains accessible after mutex is unlocked so that
+	 * kernfs_kill_sb() can run safely if called by kernfs_get_tree()'s
+	 * failure path after creating a superblock but before taking reference
+	 * on root kn.
+	 */
+	kernfs_get(rdtgroup_default.kn);
+
+	/*
+	 * Make backup of the current root kn being created to be used in kernfs_put().
+	 * The additional reference taken above will prevent the kn from being freed
+	 * before kernfs_kill_sb() can run but rdtgroup_default.kn may be set to NULL
+	 * via rdtgroup_destroy_root() and its backing root (rdt_root) could be overwritten
+	 * before kernfs_put() can run.
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
@@ -3108,7 +3155,6 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
-	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 	return ret;
@@ -3195,26 +3241,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
 
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

