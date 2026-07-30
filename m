Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEFB1FE44A;
	Thu, 30 Jul 2026 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423112; cv=none; b=Tm+taKJFtmdvNkEVkSUiuecim/L+vCLwSrgl0uNceR8lb9JoQ2q758LxCA2a4s1c/8WKwUIYPV7bTnQCX6LgVC+UVuMwdQMLQi6iDqYdeE7WY7UsllPTbdishimy6y19p2L44ebL8ogLQmkXZpLvseK0b2jY8DhEz8jmz5JDDr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423112; c=relaxed/simple;
	bh=NhSaiHPlCWBIBo6JZGjenTjNIaY7k2U9cqvDJg+uDKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuCu4XjBXF0LsqsX0llqfjhK/ZLeNKDZqzWARk4zImvfCT0M2cI7JyvDtuiMNTipptDXrwgCLPQtP6lxLIT3cg83HG4qg+eXINHMIoOUhtIesUZb6PYUJ70usNFI1ljjee2D/jTseqxOzlVJbjlPvVBT9jIss9yxHfDJIsbAgc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMAri5jm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMAri5jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789991F000E9;
	Thu, 30 Jul 2026 14:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423111;
	bh=4Jt0jq+gzmXcPIaEJKWimCcqmRyoS4trolMyCUxUBdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMAri5jmQxA59lpUnAMxWvjcyi9vXHCx30sBc2kmMBqECPI5hg30TwffDCR5zc4OL
	 PLppPkbvPj/Ea2FohFFwydQDqpxQ2mIrpjWW5CijE27vxk+dgMusZfOVr52v30snpZ
	 R/o9u2TKhayA1YvBlc+gcaaxoI1GgHvqkjLJagNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 670/744] super: fix emergency thaw deadlock on frozen block devices
Date: Thu, 30 Jul 2026 16:15:43 +0200
Message-ID: <20260730141458.505321197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 749d7aa0377aae32af8c0a4ad43371e7bf830ab5 upstream.

do_thaw_all_callback() calls bdev_thaw() while holding sb->s_umount
exclusively. If the block device was frozen via bdev_freeze() dropping
the last block layer freeze reference calls fs_bdev_thaw() which
reacquires s_umount:

  do_thaw_all_callback(sb)
    super_lock_excl(sb)                     # holds sb->s_umount
    bdev_thaw(sb->s_bdev)
      mutex_lock(&bdev->bd_fsfreeze_mutex)
      # bd_fsfreeze_count drops 1 -> 0
      bd_holder_ops->thaw == fs_bdev_thaw
        get_bdev_super(bdev)
          bdev_super_lock(bdev, true)
            super_lock(sb, true)
              down_write(&sb->s_umount)     # same task: deadlock

The emergency thaw worker deadlocks against itself holding both
s_umount and bd_fsfreeze_mutex. That fscks any subsequent unmount,
freeze, or thaw of that filesystem and block device.

  [   81.878470] sysrq: Show Blocked State
  [   81.880140] task:kworker/0:1     state:D stack:0     pid:11    tgid:11    ppid:2      task_flags:0x4208060 flags:0x00080000
  [   81.884876] Workqueue: events do_thaw_all
  [   81.886656] Call Trace:
  [   81.887759]  <TASK>
  [   81.888763]  __schedule+0x579/0x1420
  [   81.890372]  schedule+0x3a/0x100
  [   81.891794]  schedule_preempt_disabled+0x15/0x30
  [   81.893848]  rwsem_down_write_slowpath+0x1ea/0x900
  [   81.895191]  ? __pfx_do_thaw_all_callback+0x10/0x10
  [   81.896528]  down_write+0xbd/0xc0
  [   81.897505]  super_lock+0x91/0x180
  [   81.898457]  ? __mutex_lock+0xa99/0x1140
  [   81.900748]  ? __mutex_unlock_slowpath+0x1f/0x400
  [   81.902069]  bdev_super_lock+0x5b/0x150
  [   81.903132]  get_bdev_super+0x10/0x60
  [   81.904042]  fs_bdev_thaw+0x23/0xf0
  [   81.904755]  bdev_thaw+0x82/0x100
  [   81.905484]  do_thaw_all_callback+0x2c/0x50
  [   81.906298]  __iterate_supers+0x5d/0x130
  [   81.907067]  do_thaw_all+0x20/0x40
  [   81.907739]  process_one_work+0x206/0x5e0
  [   81.908545]  worker_thread+0x1e2/0x3c0
  [   81.909339]  ? __pfx_worker_thread+0x10/0x10
  [   81.910171]  kthread+0xf4/0x130
  [   81.910799]  ? __pfx_kthread+0x10/0x10
  [   81.911528]  ret_from_fork+0x2e2/0x3b0
  [   81.912259]  ? __pfx_kthread+0x10/0x10
  [   81.913010]  ret_from_fork_asm+0x1a/0x30
  [   81.913806]  </TASK>

bdev_super_lock() even documents the violated requirement with
lockdep_assert_not_held(&sb->s_umount).

Acquiring bd_fsfreeze_mutex under s_umount also inverts the
bd_fsfreeze_mutex vs. s_umount ordering established by
bdev_{freeze,thaw}() and can thus ABBA against a concurrent block-layer
freeze even when the recursive path isn't hit.

Fix this by not holding s_umount around the bdev_thaw() loop at all. Pin
the superblock with an active reference instead as
filesystems_freeze_callback() does. The active reference keeps the
superblock from being shut down and so ->s_bdev stays valid without
holding s_umount. The block-layer-held freeze is dropped by
fs_bdev_thaw() with FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE exactly as
a regular unfreeze would and thaw_super_locked() handles
filesystem-level freezes as before.

The emergency thaw path has deadlocked like this in one form or
another for a long long time but the current exclusively-held
shape dates back to commit [1] where thaw_bdev() already ended in
thaw_super() with s_umount held by do_thaw_all_callback().

Fixes: 08fdc8a0138a ("buffer.c: call thaw_super during emergency thaw") [1]
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260723-work-super-emergency_thaw-v1-1-7c315c600245@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -1143,16 +1143,30 @@ void emergency_remount(void)
 	}
 }
 
+static inline bool get_active_super(struct super_block *sb)
+{
+	bool active = false;
+
+	if (super_lock_excl(sb)) {
+		active = atomic_inc_not_zero(&sb->s_active);
+		super_unlock_excl(sb);
+	}
+	return active;
+}
+
 static void do_thaw_all_callback(struct super_block *sb, void *unused)
 {
-	if (!super_lock_excl(sb))
+	if (!get_active_super(sb))
 		return;
 
+	/* fs_bdev_thaw() acquires s_umount so it must not be held here */
 	if (IS_ENABLED(CONFIG_BLOCK))
 		while (sb->s_bdev && !bdev_thaw(sb->s_bdev))
 			pr_warn("Emergency Thaw on %pg\n", sb->s_bdev);
 
-	thaw_super_locked(sb, FREEZE_HOLDER_USERSPACE, NULL);
+	if (super_lock_excl(sb))
+		thaw_super_locked(sb, FREEZE_HOLDER_USERSPACE, NULL);
+	deactivate_super(sb);
 }
 
 static void do_thaw_all(struct work_struct *work)
@@ -1178,17 +1192,6 @@ void emergency_thaw_all(void)
 	}
 }
 
-static inline bool get_active_super(struct super_block *sb)
-{
-	bool active = false;
-
-	if (super_lock_excl(sb)) {
-		active = atomic_inc_not_zero(&sb->s_active);
-		super_unlock_excl(sb);
-	}
-	return active;
-}
-
 static const char *filesystems_freeze_ptr = "filesystems_freeze";
 
 static void filesystems_freeze_callback(struct super_block *sb, void *freeze_all_ptr)


