Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD30136EA81;
	Mon,  9 Feb 2026 14:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647470; cv=none; b=hSVbYMscJr452PIEFEF4d28V0IVzGuSzWWoqWVsnfd12590k7qfyefAjpNV9Xqf1C3ojmRF/c79vhVs3iDsBjaoFW2Lt53WN4pBsUqxAkiYh3IbXAmQ3uQkRY8qQGNgOtx7tOnubb+ibm2L19wvVtB7/spJ2dTwvYc3PatEOMsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647470; c=relaxed/simple;
	bh=ZrK6q+/LoC7KIlR1LdSc9ax1tFG5/vVTD9CBhjgHpUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEU2AJVELDpLyvWy76AlprQpwolxQ4DTRjMYylQAOFB3t0CgPn/30bHIB3G8c6kUk9shms5GAijOqq8zA1SU9bmsXd2jMLFbdBfus3/3rDsRhxnPcDBEB8v3h+E5luZxjjmqVpt0HJRImmOC7wajutKNdqT1Et/8QrUVGTzhNz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJOY6REP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJOY6REP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044F9C116C6;
	Mon,  9 Feb 2026 14:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647470;
	bh=ZrK6q+/LoC7KIlR1LdSc9ax1tFG5/vVTD9CBhjgHpUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJOY6REPqDq5Xv6GHLgnCvOSilYu3ErIPfnKoaW3FQ055VtRskaCvKzVAcvoeT7TT
	 Gp7CZfUA8VUl6S9JwNMz64c98N75TwV5G09JqgZZCphjvZ5rDj1N2+6COGcyQhEO9B
	 dyounGLV9uEzN/Pl5Fs3seu9EivYTlSKV6+LPJjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/175] btrfs: reject new transactions if the fs is fully read-only
Date: Mon,  9 Feb 2026 15:23:02 +0100
Message-ID: <20260209142324.341433636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 1972f44c189c8aacde308fa9284e474c1a5cbd9f ]

[BUG]
There is a bug report where a heavily fuzzed fs is mounted with all
rescue mount options, which leads to the following warnings during
unmount:

  BTRFS: Transaction aborted (error -22)
  Modules linked in:
  CPU: 0 UID: 0 PID: 9758 Comm: repro.out Not tainted
  6.19.0-rc5-00002-gb71e635feefc #7 PREEMPT(full)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  RIP: 0010:find_free_extent_update_loop fs/btrfs/extent-tree.c:4208 [inline]
  RIP: 0010:find_free_extent+0x52f0/0x5d20 fs/btrfs/extent-tree.c:4611
  Call Trace:
   <TASK>
   btrfs_reserve_extent+0x2cd/0x790 fs/btrfs/extent-tree.c:4705
   btrfs_alloc_tree_block+0x1e1/0x10e0 fs/btrfs/extent-tree.c:5157
   btrfs_force_cow_block+0x578/0x2410 fs/btrfs/ctree.c:517
   btrfs_cow_block+0x3c4/0xa80 fs/btrfs/ctree.c:708
   btrfs_search_slot+0xcad/0x2b50 fs/btrfs/ctree.c:2130
   btrfs_truncate_inode_items+0x45d/0x2350 fs/btrfs/inode-item.c:499
   btrfs_evict_inode+0x923/0xe70 fs/btrfs/inode.c:5628
   evict+0x5f4/0xae0 fs/inode.c:837
   __dentry_kill+0x209/0x660 fs/dcache.c:670
   finish_dput+0xc9/0x480 fs/dcache.c:879
   shrink_dcache_for_umount+0xa0/0x170 fs/dcache.c:1661
   generic_shutdown_super+0x67/0x2c0 fs/super.c:621
   kill_anon_super+0x3b/0x70 fs/super.c:1289
   btrfs_kill_super+0x41/0x50 fs/btrfs/super.c:2127
   deactivate_locked_super+0xbc/0x130 fs/super.c:474
   cleanup_mnt+0x425/0x4c0 fs/namespace.c:1318
   task_work_run+0x1d4/0x260 kernel/task_work.c:233
   exit_task_work include/linux/task_work.h:40 [inline]
   do_exit+0x694/0x22f0 kernel/exit.c:971
   do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
   __do_sys_exit_group kernel/exit.c:1123 [inline]
   __se_sys_exit_group kernel/exit.c:1121 [inline]
   __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1121
   x64_sys_call+0x2210/0x2210 arch/x86/include/generated/asm/syscalls_64.h:232
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xe8/0xf80 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x44f639
  Code: Unable to access opcode bytes at 0x44f60f.
  RSP: 002b:00007ffc15c4e088 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
  RAX: ffffffffffffffda RBX: 00000000004c32f0 RCX: 000000000044f639
  RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
  RBP: 0000000000000001 R08: ffffffffffffffc0 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004c32f0
  R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
   </TASK>

Since rescue mount options will mark the full fs read-only, there should
be no new transaction triggered.

But during unmount we will evict all inodes, which can trigger a new
transaction, and triggers warnings on a heavily corrupted fs.

[CAUSE]
Btrfs allows new transaction even on a read-only fs, this is to allow
log replay happen even on read-only mounts, just like what ext4/xfs do.

However with rescue mount options, the fs is fully read-only and cannot
be remounted read-write, thus in that case we should also reject any new
transactions.

[FIX]
If we find the fs has rescue mount options, we should treat the fs as
error, so that no new transaction can be started.

Reported-by: Jiaming Zhang <r772577952@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CANypQFYw8Nt8stgbhoycFojOoUmt+BoZ-z8WJOZVxcogDdwm=Q@mail.gmail.com/
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 13 +++++++++++++
 fs/btrfs/fs.h      |  8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 19d8c8fc45951..745ae698bbc8a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3248,6 +3248,15 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	return 0;
 }
 
+static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
+{
+	if (!sb_rdonly(fs_info->sb))
+		return false;
+	if (unlikely(fs_info->mount_opt & BTRFS_MOUNT_FULL_RO_MASK))
+		return true;
+	return false;
+}
+
 int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
 {
 	u32 sectorsize;
@@ -3356,6 +3365,10 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_ERROR)
 		WRITE_ONCE(fs_info->fs_error, -EUCLEAN);
 
+	/* If the fs has any rescue options, no transaction is allowed. */
+	if (fs_is_full_ro(fs_info))
+		WRITE_ONCE(fs_info->fs_error, -EROFS);
+
 	/* Set up fs_info before parsing mount options */
 	nodesize = btrfs_super_nodesize(disk_super);
 	sectorsize = btrfs_super_sectorsize(disk_super);
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 814bbc9417d2a..37aa8d141a83d 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -250,6 +250,14 @@ enum {
 	BTRFS_MOUNT_REF_TRACKER			= (1ULL << 33),
 };
 
+/* These mount options require a full read-only fs, no new transaction is allowed. */
+#define BTRFS_MOUNT_FULL_RO_MASK		\
+	(BTRFS_MOUNT_NOLOGREPLAY |		\
+	 BTRFS_MOUNT_IGNOREBADROOTS |		\
+	 BTRFS_MOUNT_IGNOREDATACSUMS |		\
+	 BTRFS_MOUNT_IGNOREMETACSUMS |		\
+	 BTRFS_MOUNT_IGNORESUPERFLAGS)
+
 /*
  * Compat flags that we support.  If any incompat flags are set other than the
  * ones specified below then we will fail to mount
-- 
2.51.0



