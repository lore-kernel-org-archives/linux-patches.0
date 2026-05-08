Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A443D6CB1
	for <patches@lists.linux.dev>; Fri,  8 May 2026 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778264515; cv=none; b=ORoSUgD7fWZsLeppBvQ2wwqYioCN08BDdrEQdRFiaKUHpa2bgbKLPnOFG8wJpWfNDO0jedw44J0JxpT8AuwWn9kQP080W8ILdxFREUR4AJvFXCqjzps2zQEGuEYnr3iKQJDPG5QPAxE01QOpBNiB8hvc03YNqNdwm2cCFIxtD+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778264515; c=relaxed/simple;
	bh=Gdc4Bymf/uM3xFnsXyHvyT6lXDJ0pEDBpo1UAzXz3Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMkjnpYnteJN3tk7XBHQk7GjZJLil36Cs/jqks303MY5129P6STxDjTYRHoS53RnEP+9pRWM+ODfqALdABAZ3ULAcXsaLfEc7fw7POHk3US5Onhkhm3kVeZ7cFi0OP78nszxoimn7C1t3bvYEFqPnUKZLPamdg1oFPxzTzeniqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cbyI1mSG; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cbyI1mSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778264513; x=1809800513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gdc4Bymf/uM3xFnsXyHvyT6lXDJ0pEDBpo1UAzXz3Sc=;
  b=cbyI1mSGBA71ea8Zeyns9Vskqk791vBWDNIe7rPcg74xYTNOUC2++xxU
   hoSdap1awlNhuY7J1MxZ5AI5uiwQJ5+dqlHAYQwCFVrJsQrzHKwSIldi9
   BeY2VDKaovKUd12dGPLsT2Nc5zid9/UyaijNV/Qw0s6ey+uJJIdPIAlJp
   WcZ1Bgq74H6YTLzfy7Gsv9P6ZFbJGGsf2Iwci7ATOkplUMaFdXoM8Y2Bl
   T0y5uE/RyM/7dlUXVftOShz8vArI0kC6zIo/rYMrTIdBI47EWmlxY4r6K
   1YSLWOqreP3Oz+S74jl1QUZEgujc5je/5/uHxODTV5UTlSmuTxs9+zd+I
   w==;
X-CSE-ConnectionGUID: YColBmDERwa2QlRZ8LHmOg==
X-CSE-MsgGUID: Tjnj7ekbShK1bwpPx6rClQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="79264157"
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="79264157"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 11:21:49 -0700
X-CSE-ConnectionGUID: qkLsgst9RiiRxErpdCrUCA==
X-CSE-MsgGUID: KDtj6dQLRLW+baELP4BDLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="233776433"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.98])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 11:21:49 -0700
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
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
Date: Fri,  8 May 2026 11:21:42 -0700
Message-ID: <20260508182143.14592-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260508182143.14592-1-tony.luck@intel.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Reinette Chatre <reinette.chatre@intel.com>

Sashiko noticed[1] a deadlock in the resctrl mount code.

rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
the same thread before the call returns.  rdt_kill_sb() unconditionally
attempts to acquire rdtgroup_mutex and deadlock occurs.

Move the call to kernfs_get_tree() outside of locks.

Add resctrl_unmount() helper to keep code consistent between the
rdt_get_tree() failure path and a normal unmount.

If kernfs_get_tree() fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb()
has already been called and no further cleanup is needed.

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
---
 fs/resctrl/rdtgroup.c | 63 ++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0db1a92aefbe..62e1e4c30f78 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2970,6 +2970,29 @@ static void resctrl_fs_teardown(void)
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
@@ -3043,10 +3066,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	ret = kernfs_get_tree(fc);
-	if (ret < 0)
-		goto out_psl;
-
 	if (resctrl_arch_alloc_capable())
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
@@ -3062,10 +3081,19 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
-	goto out;
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
+	return ret;
 
-out_psl:
-	rdt_pseudo_lock_release();
 out_mondata:
 	if (resctrl_arch_mon_capable()) {
 		mon_put_kn_priv();
@@ -3086,7 +3114,6 @@ static int rdt_get_tree(struct fs_context *fc)
 out_root:
 	rdtgroup_destroy_root();
 out:
-	rdt_last_cmd_clear();
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 	return ret;
@@ -3173,26 +3200,8 @@ static int rdt_init_fs_context(struct fs_context *fc)
 
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

