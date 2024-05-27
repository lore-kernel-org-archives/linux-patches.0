Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C842168C4;
	Mon, 27 May 2024 19:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837630; cv=none; b=YVsR3QecLizKImS5VCy+fJUwuzhkEeT8N8JoV8V/uTQSBqAJDo76+CeoOuRBNmlvUCRA6Bj8zUlUELeGqi5SqcLTqet8wXyWBlMHOPhhDpNI7kMLmMLOVtioP0FW+BKSiGtTPM/8C+LPMI9kzWLw4NW0lMzx1xI5BCEOhQifE34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837630; c=relaxed/simple;
	bh=tZqGrNjrVgGzp7soMNTku+9sdVw38kEabu1oi+htdI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1duFoPLc/eZEimCu2heEZDY82tx8d4IrSFwXkmAJVV1+28akdnYqIItP486mKZvl3imehTQXDMNXwJ/sWQsWZWPm2uxNDTOOtlA/C9sVL+UmkMInwPC5Tce2s0DzYlPcp/q3PIzsXm0ctH3DxDi0+BjTceuhntH6TTJhXRdwLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6yieO9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6yieO9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259FDC2BBFC;
	Mon, 27 May 2024 19:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837630;
	bh=tZqGrNjrVgGzp7soMNTku+9sdVw38kEabu1oi+htdI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6yieO9uf6hqJI07/cSu0ivY6AQgJYHED90N2TOEJ3wgwzqHl8Kv24Q0KUCG5uUiW
	 x2nQozwNGoMEp7gfjGmABo0r6/357Eite93Myo+e/QWW87XLgma/WydzeuJF9NKfZS
	 nWjqfxREI+RFQ5TJwVvo6iFM0eVSpjdYHM5FyRSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 081/493] btrfs: take the cleaner_mutex earlier in qgroup disable
Date: Mon, 27 May 2024 20:51:23 +0200
Message-ID: <20240527185632.818661761@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 0f2b8098d72a93890e69aa24ec549ef4bc34f4db ]

One of my CI runs popped the following lockdep splat

======================================================
WARNING: possible circular locking dependency detected
6.9.0-rc4+ #1 Not tainted
------------------------------------------------------
btrfs/471533 is trying to acquire lock:
ffff92ba46980850 (&fs_info->cleaner_mutex){+.+.}-{3:3}, at: btrfs_quota_disable+0x54/0x4c0

but task is already holding lock:
ffff92ba46980bd0 (&fs_info->subvol_sem){++++}-{3:3}, at: btrfs_ioctl+0x1c8f/0x2600

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&fs_info->subvol_sem){++++}-{3:3}:
       down_read+0x42/0x170
       btrfs_rename+0x607/0xb00
       btrfs_rename2+0x2e/0x70
       vfs_rename+0xaf8/0xfc0
       do_renameat2+0x586/0x600
       __x64_sys_rename+0x43/0x50
       do_syscall_64+0x95/0x180
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #1 (&sb->s_type->i_mutex_key#16){++++}-{3:3}:
       down_write+0x3f/0xc0
       btrfs_inode_lock+0x40/0x70
       prealloc_file_extent_cluster+0x1b0/0x370
       relocate_file_extent_cluster+0xb2/0x720
       relocate_data_extent+0x107/0x160
       relocate_block_group+0x442/0x550
       btrfs_relocate_block_group+0x2cb/0x4b0
       btrfs_relocate_chunk+0x50/0x1b0
       btrfs_balance+0x92f/0x13d0
       btrfs_ioctl+0x1abf/0x2600
       __x64_sys_ioctl+0x97/0xd0
       do_syscall_64+0x95/0x180
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

-> #0 (&fs_info->cleaner_mutex){+.+.}-{3:3}:
       __lock_acquire+0x13e7/0x2180
       lock_acquire+0xcb/0x2e0
       __mutex_lock+0xbe/0xc00
       btrfs_quota_disable+0x54/0x4c0
       btrfs_ioctl+0x206b/0x2600
       __x64_sys_ioctl+0x97/0xd0
       do_syscall_64+0x95/0x180
       entry_SYSCALL_64_after_hwframe+0x76/0x7e

other info that might help us debug this:

Chain exists of:
  &fs_info->cleaner_mutex --> &sb->s_type->i_mutex_key#16 --> &fs_info->subvol_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&fs_info->subvol_sem);
                               lock(&sb->s_type->i_mutex_key#16);
                               lock(&fs_info->subvol_sem);
  lock(&fs_info->cleaner_mutex);

 *** DEADLOCK ***

2 locks held by btrfs/471533:
 #0: ffff92ba4319e420 (sb_writers#14){.+.+}-{0:0}, at: btrfs_ioctl+0x3b5/0x2600
 #1: ffff92ba46980bd0 (&fs_info->subvol_sem){++++}-{3:3}, at: btrfs_ioctl+0x1c8f/0x2600

stack backtrace:
CPU: 1 PID: 471533 Comm: btrfs Kdump: loaded Not tainted 6.9.0-rc4+ #1
Call Trace:
 <TASK>
 dump_stack_lvl+0x77/0xb0
 check_noncircular+0x148/0x160
 ? lock_acquire+0xcb/0x2e0
 __lock_acquire+0x13e7/0x2180
 lock_acquire+0xcb/0x2e0
 ? btrfs_quota_disable+0x54/0x4c0
 ? lock_is_held_type+0x9a/0x110
 __mutex_lock+0xbe/0xc00
 ? btrfs_quota_disable+0x54/0x4c0
 ? srso_return_thunk+0x5/0x5f
 ? lock_acquire+0xcb/0x2e0
 ? btrfs_quota_disable+0x54/0x4c0
 ? btrfs_quota_disable+0x54/0x4c0
 btrfs_quota_disable+0x54/0x4c0
 btrfs_ioctl+0x206b/0x2600
 ? srso_return_thunk+0x5/0x5f
 ? __do_sys_statfs+0x61/0x70
 __x64_sys_ioctl+0x97/0xd0
 do_syscall_64+0x95/0x180
 ? srso_return_thunk+0x5/0x5f
 ? reacquire_held_locks+0xd1/0x1f0
 ? do_user_addr_fault+0x307/0x8a0
 ? srso_return_thunk+0x5/0x5f
 ? lock_acquire+0xcb/0x2e0
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? find_held_lock+0x2b/0x80
 ? srso_return_thunk+0x5/0x5f
 ? lock_release+0xca/0x2a0
 ? srso_return_thunk+0x5/0x5f
 ? do_user_addr_fault+0x35c/0x8a0
 ? srso_return_thunk+0x5/0x5f
 ? trace_hardirqs_off+0x4b/0xc0
 ? srso_return_thunk+0x5/0x5f
 ? lockdep_hardirqs_on_prepare+0xde/0x190
 ? srso_return_thunk+0x5/0x5f

This happens because when we call rename we already have the inode mutex
held, and then we acquire the subvol_sem if we are a subvolume.  This
makes the dependency

inode lock -> subvol sem

When we're running data relocation we will preallocate space for the
data relocation inode, and we always run the relocation under the
->cleaner_mutex.  This now creates the dependency of

cleaner_mutex -> inode lock (from the prealloc) -> subvol_sem

Qgroup delete is doing this in the opposite order, it is acquiring the
subvol_sem and then it is acquiring the cleaner_mutex, which results in
this lockdep splat.  This deadlock can't happen in reality, because we
won't ever rename the data reloc inode, nor is the data reloc inode a
subvolume.

However this is fairly easy to fix, simply take the cleaner mutex in the
case where we are disabling qgroups before we take the subvol_sem.  This
resolves the lockdep splat.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c  | 33 ++++++++++++++++++++++++++++++---
 fs/btrfs/qgroup.c | 21 ++++++++-------------
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6b93fae74403d..8851ba7a1e271 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3722,15 +3722,43 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
-	down_write(&fs_info->subvol_sem);
-
 	switch (sa->cmd) {
 	case BTRFS_QUOTA_CTL_ENABLE:
 	case BTRFS_QUOTA_CTL_ENABLE_SIMPLE_QUOTA:
+		down_write(&fs_info->subvol_sem);
 		ret = btrfs_quota_enable(fs_info, sa);
+		up_write(&fs_info->subvol_sem);
 		break;
 	case BTRFS_QUOTA_CTL_DISABLE:
+		/*
+		 * Lock the cleaner mutex to prevent races with concurrent
+		 * relocation, because relocation may be building backrefs for
+		 * blocks of the quota root while we are deleting the root. This
+		 * is like dropping fs roots of deleted snapshots/subvolumes, we
+		 * need the same protection.
+		 *
+		 * This also prevents races between concurrent tasks trying to
+		 * disable quotas, because we will unlock and relock
+		 * qgroup_ioctl_lock across BTRFS_FS_QUOTA_ENABLED changes.
+		 *
+		 * We take this here because we have the dependency of
+		 *
+		 * inode_lock -> subvol_sem
+		 *
+		 * because of rename.  With relocation we can prealloc extents,
+		 * so that makes the dependency chain
+		 *
+		 * cleaner_mutex -> inode_lock -> subvol_sem
+		 *
+		 * so we must take the cleaner_mutex here before we take the
+		 * subvol_sem.  The deadlock can't actually happen, but this
+		 * quiets lockdep.
+		 */
+		mutex_lock(&fs_info->cleaner_mutex);
+		down_write(&fs_info->subvol_sem);
 		ret = btrfs_quota_disable(fs_info);
+		up_write(&fs_info->subvol_sem);
+		mutex_unlock(&fs_info->cleaner_mutex);
 		break;
 	default:
 		ret = -EINVAL;
@@ -3738,7 +3766,6 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	}
 
 	kfree(sa);
-	up_write(&fs_info->subvol_sem);
 drop_write:
 	mnt_drop_write_file(file);
 	return ret;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 82d4559eb4b1e..cacc12d0ff33f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1342,16 +1342,10 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	lockdep_assert_held_write(&fs_info->subvol_sem);
 
 	/*
-	 * Lock the cleaner mutex to prevent races with concurrent relocation,
-	 * because relocation may be building backrefs for blocks of the quota
-	 * root while we are deleting the root. This is like dropping fs roots
-	 * of deleted snapshots/subvolumes, we need the same protection.
-	 *
-	 * This also prevents races between concurrent tasks trying to disable
-	 * quotas, because we will unlock and relock qgroup_ioctl_lock across
-	 * BTRFS_FS_QUOTA_ENABLED changes.
+	 * Relocation will mess with backrefs, so make sure we have the
+	 * cleaner_mutex held to protect us from relocate.
 	 */
-	mutex_lock(&fs_info->cleaner_mutex);
+	lockdep_assert_held(&fs_info->cleaner_mutex);
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root)
@@ -1373,9 +1367,13 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 
+	/*
+	 * We have nothing held here and no trans handle, just return the error
+	 * if there is one.
+	 */
 	ret = flush_reservations(fs_info);
 	if (ret)
-		goto out_unlock_cleaner;
+		return ret;
 
 	/*
 	 * 1 For the root item
@@ -1439,9 +1437,6 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 		btrfs_end_transaction(trans);
 	else if (trans)
 		ret = btrfs_commit_transaction(trans);
-out_unlock_cleaner:
-	mutex_unlock(&fs_info->cleaner_mutex);
-
 	return ret;
 }
 
-- 
2.43.0



