Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052158837;
	Mon, 28 Oct 2024 06:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098397; cv=none; b=p20Bk+3JkhoR4r0mY0UYOnYqbJEBSbUbjwi/WbMA6ZvhPGKk+w95lf8WPWQ5kPDvG7HhwFtClt57N6fAUElJj3zwJmtm7lvAaIC7rYCfncyTsOE/jxrZqNjys32BpiP4bslDySl6a7rJTCI9NVd/h+qUf68EBzWxl7lFNaSZmvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098397; c=relaxed/simple;
	bh=eOt8oT9LbDkmljj7xCjq8uEO+DNeJBiExzvaogzspxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfdH91L1wn/3bO8XiYtVMo6Lesu0jfj+ojucHuh386BgPrHAdz9qTGgZcELwc/mCRsjyU8mUhVMZUKBEHk0d+012y4deSzFnHE8UUrwT53xybvw4FqKXE1RPyCyMBJgDyf6K7EDgtwbPZE8DxleIsBwrLYiUHOoCPXPqJVMZzRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkUl8cWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkUl8cWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D0BC4CEC7;
	Mon, 28 Oct 2024 06:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098396;
	bh=eOt8oT9LbDkmljj7xCjq8uEO+DNeJBiExzvaogzspxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkUl8cWqaEODrjSVGr3BMFz5mBxqCauICgbOZNUgJMsbCRlx2uq5lXzybS7Ia9O9N
	 9QYsOV7rUeroLPryhRkwa0xXQzSBdXtfzKqArl5v3w25MeJiEY9Jhhg3I7ggjeCYYc
	 TX8hP8DzR+aM8rdypheIvN/ZgUNZu0ypYAuT6UXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56360f93efa90ff15870@syzkaller.appspotmail.com,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 207/261] btrfs: reject ro->rw reconfiguration if there are hard ro requirements
Date: Mon, 28 Oct 2024 07:25:49 +0100
Message-ID: <20241028062317.259537745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 3c36a72c1d27de6618c1c480c793d9924640f5bb upstream.

[BUG]
Syzbot reports the following crash:

  BTRFS info (device loop0 state MCS): disabling free space tree
  BTRFS info (device loop0 state MCS): clearing compat-ro feature flag for FREE_SPACE_TREE (0x1)
  BTRFS info (device loop0 state MCS): clearing compat-ro feature flag for FREE_SPACE_TREE_VALID (0x2)
  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
  RIP: 0010:backup_super_roots fs/btrfs/disk-io.c:1691 [inline]
  RIP: 0010:write_all_supers+0x97a/0x40f0 fs/btrfs/disk-io.c:4041
  Call Trace:
   <TASK>
   btrfs_commit_transaction+0x1eae/0x3740 fs/btrfs/transaction.c:2530
   btrfs_delete_free_space_tree+0x383/0x730 fs/btrfs/free-space-tree.c:1312
   btrfs_start_pre_rw_mount+0xf28/0x1300 fs/btrfs/disk-io.c:3012
   btrfs_remount_rw fs/btrfs/super.c:1309 [inline]
   btrfs_reconfigure+0xae6/0x2d40 fs/btrfs/super.c:1534
   btrfs_reconfigure_for_mount fs/btrfs/super.c:2020 [inline]
   btrfs_get_tree_subvol fs/btrfs/super.c:2079 [inline]
   btrfs_get_tree+0x918/0x1920 fs/btrfs/super.c:2115
   vfs_get_tree+0x90/0x2b0 fs/super.c:1800
   do_new_mount+0x2be/0xb40 fs/namespace.c:3472
   do_mount fs/namespace.c:3812 [inline]
   __do_sys_mount fs/namespace.c:4020 [inline]
   __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
   do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

[CAUSE]
To support mounting different subvolume with different RO/RW flags for
the new mount APIs, btrfs introduced two workaround to support this feature:

- Skip mount option/feature checks if we are mounting a different
  subvolume

- Reconfigure the fs to RW if the initial mount is RO

Combining these two, we can have the following sequence:

- Mount the fs ro,rescue=all,clear_cache,space_cache=v1
  rescue=all will mark the fs as hard read-only, so no v2 cache clearing
  will happen.

- Mount a subvolume rw of the same fs.
  We go into btrfs_get_tree_subvol(), but fc_mount() returns EBUSY
  because our new fc is RW, different from the original fs.

  Now we enter btrfs_reconfigure_for_mount(), which switches the RO flag
  first so that we can grab the existing fs_info.
  Then we reconfigure the fs to RW.

- During reconfiguration, option/features check is skipped
  This means we will restart the v2 cache clearing, and convert back to
  v1 cache.
  This will trigger fs writes, and since the original fs has "rescue=all"
  option, it skips the csum tree read.

  And eventually causing NULL pointer dereference in super block
  writeback.

[FIX]
For reconfiguration caused by different subvolume RO/RW flags, ensure we
always run btrfs_check_options() to ensure we have proper hard RO
requirements met.

In fact the function btrfs_check_options() doesn't really do many
complex checks, but hard RO requirement and some feature dependency
checks, thus there is no special reason not to do the check for mount
reconfiguration.

Reported-by: syzbot+56360f93efa90ff15870@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/0000000000008c5d090621cb2770@google.com/
Fixes: f044b318675f ("btrfs: handle the ro->rw transition for mounting different subvolumes")
CC: stable@vger.kernel.org # 6.8+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3f8673f97432..926d7a9ed99d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1507,8 +1507,7 @@ static int btrfs_reconfigure(struct fs_context *fc)
 	sync_filesystem(sb);
 	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
 
-	if (!mount_reconfigure &&
-	    !btrfs_check_options(fs_info, &ctx->mount_opt, fc->sb_flags))
+	if (!btrfs_check_options(fs_info, &ctx->mount_opt, fc->sb_flags))
 		return -EINVAL;
 
 	ret = btrfs_check_features(fs_info, !(fc->sb_flags & SB_RDONLY));
-- 
2.47.0



