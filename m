Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6A8325707
	for <patches@lists.linux.dev>; Fri,  1 May 2026 18:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777661782; cv=none; b=owvCZCUqIM53NBiIqXDgGNKWHUQrYCwF7XQLX+vOgTjRD4SBr7g4z976HynNBPg9SDXziIuM7LbsK1gCBcI+E2NgYqp5P4jEHZNN8IXS8HHv94SyYw1wgPN2Z0Qo2Ft2O5WWWRONd/SNnRXVKoStNriQ5JFIqryWP2MFAFtie8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777661782; c=relaxed/simple;
	bh=thdqw6/+ec+7pTGO9RAk4ZX6ubx6cT7WJFBO3JMEV0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lPiKVzSBVfNl3g13JgoTk6b26szyh9X5gdshQW/U0qvm0l92AriDVWyLpmzWV/3s61kky0t6Dz+J+uPdP+k1qWFQLRfreYPQ85DrZAw08OagIJd1vSJJ8UYa5ROzup3ZW6bki1tRdOYz9y+xnIMuP2Wx0bbciP9XP6ud1sv/rUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=in8oGgN3; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="in8oGgN3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777661780; x=1809197780;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=thdqw6/+ec+7pTGO9RAk4ZX6ubx6cT7WJFBO3JMEV0k=;
  b=in8oGgN33rKQcdUiTufIsYNy30gHOFaIxBpg+KfEmd6Uzmoa2WaRFw/P
   oxyyrGZ/sVHpn/MZG0QIgaz4X088XMvirQtHwRPjN8FXunmropg22d/98
   ypibKVtoxfa8UAFrH4yENyA/o0XgqZd5eEgOIcC/MzdZKp4YjVlv7GrTD
   GAN2xErINaj+N/hGgzc9ZVVBDVfOlByva82sTG8+KWEcIsH7DUwkmCoad
   b5WkT3TE62A73aGE3V1abRD2gYA1EJ71W/+MLMyMwC8UXXu0blnDejr3B
   LucUFCDk+bl3xAOl6mZkt3Uzv0JUXGUxxB3AroIohIqzqEGsmJnRtJxrS
   w==;
X-CSE-ConnectionGUID: xotgPTlLRCGJFFgBACUqeg==
X-CSE-MsgGUID: J9Mz9S8hSOeQvUYITBwvmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="89215937"
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="89215937"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 11:56:19 -0700
X-CSE-ConnectionGUID: 44TKclu6S7S6xCumedNBiw==
X-CSE-MsgGUID: VdVHWEh1QXGTW9cNISdmig==
X-ExtLoop1: 1
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.155])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 11:56:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] fs/resctrl: Fix deadlock for errors during mount
Date: Fri,  1 May 2026 11:56:12 -0700
Message-ID: <20260501185612.14442-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko noticed[1] a deadlock in the resctrl mount code.

rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
the same thread before the call returns.  rdt_kill_sb() unconditionally
attempts to acquire rdtgroup_mutex and deadlock occurs.

Add a boolean rdt_kill_sb_locked flag. Set it for the duration of
kernfs_get_tree() and check in rdt_kill_sb() to determine if locks
are already held.

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Assisted-by: GitHub-Copilot:claude-sonnet-4.6
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
---
 fs/resctrl/rdtgroup.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dfdaa6f9d8f..8544020ef420 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2782,6 +2782,9 @@ static void schemata_list_destroy(void)
 	}
 }
 
+/* Protected by the serialized mount path (rdtgroup_mutex + resctrl_mounted). */
+static bool rdt_kill_sb_locked;
+
 static int rdt_get_tree(struct fs_context *fc)
 {
 	struct rdt_fs_context *ctx = rdt_fc2context(fc);
@@ -2855,7 +2858,9 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
+	rdt_kill_sb_locked = true;
 	ret = kernfs_get_tree(fc);
+	rdt_kill_sb_locked = false;
 	if (ret < 0)
 		goto out_psl;
 
@@ -3173,8 +3178,10 @@ static void rdt_kill_sb(struct super_block *sb)
 {
 	struct rdt_resource *r;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!rdt_kill_sb_locked) {
+		cpus_read_lock();
+		mutex_lock(&rdtgroup_mutex);
+	}
 
 	rdt_disable_ctx();
 
@@ -3189,8 +3196,10 @@ static void rdt_kill_sb(struct super_block *sb)
 		resctrl_arch_disable_mon();
 	resctrl_mounted = false;
 	kernfs_kill_sb(sb);
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	if (!rdt_kill_sb_locked) {
+		mutex_unlock(&rdtgroup_mutex);
+		cpus_read_unlock();
+	}
 }
 
 static struct file_system_type rdt_fs_type = {
-- 
2.54.0

