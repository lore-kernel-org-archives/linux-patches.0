Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C391D30C365;
	Mon, 13 Oct 2025 15:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368849; cv=none; b=DB0IK5oYYblIOAGEyg7bwhjb3y4az1S1VzqOxK33fXIzBPiK6o2NDNeMYEIJLV4ypb9dpKqljOUx+z8++3CjpVsx2YCHINfhWBxDTR6KgXj0N+uZbP+71sR8v5jJUXiS7WXTw9jQmnc/wAP2SkXYveBQO1unxsrHcM0BtJt+o5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368849; c=relaxed/simple;
	bh=xgZc4SUlQs9NIf+LqOsRwgkbkyUAIYFw8tWkNtUBVXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nusopwRLIN5CZ30kgk2QjHMardlW+y6F2iGUfcYDnJAnRhCu5k1rjvekf+hvkLL+xhn/IQ3Wm93VUOO31gV2QUgEZ3sEYy37SfHVCvlp8wCNelYVz8phGpDefrTWauvWSFiwd1vkOTCzdfz8Xza5zqKoUzh+1IcWqD4qY/neRgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JW5Cc+kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JW5Cc+kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A5AC4CEE7;
	Mon, 13 Oct 2025 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368849;
	bh=xgZc4SUlQs9NIf+LqOsRwgkbkyUAIYFw8tWkNtUBVXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JW5Cc+kf7EWc/baCCTGg0HkHUcJ273AhMH2Dtb7MqFON6eqFztQdp59WThGRHdCdb
	 P2aUXtDr3pz2nmyotwH5lZ9omahRc3vmI1KEdx+pLnNDbqVkGVnA/HbWi81j/r57l5
	 T66qhuM/QqinfLd2oGzUaKkHc9MpBk/I8zzWalL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 040/563] btrfs: fix symbolic link reading when bs > ps
Date: Mon, 13 Oct 2025 16:38:21 +0200
Message-ID: <20251013144412.744205986@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 67378b754608a3524d125bfa5744508a49fe48be ]

[BUG DURING BS > PS TEST]
When running the following script on a btrfs whose block size is larger
than page size, e.g. 8K block size and 4K page size, it will trigger a
kernel BUG:

  # mkfs.btrfs -s 8k $dev
  # mount $dev $mnt
  # mkdir $mnt/dir
  # ln -s dir $mnt/link
  # ls $mnt/link

The call trace looks like this:

  BTRFS warning (device dm-2): support for block size 8192 with page size 4096 is experimental, some features may be missing
  BTRFS info (device dm-2): checking UUID tree
  BTRFS info (device dm-2): enabling ssd optimizations
  BTRFS info (device dm-2): enabling free space tree
  ------------[ cut here ]------------
  kernel BUG at /home/adam/linux/include/linux/highmem.h:275!
  Oops: invalid opcode: 0000 [#1] SMP
  CPU: 8 UID: 0 PID: 667 Comm: ls Tainted: G           OE       6.17.0-rc4-custom+ #283 PREEMPT(full)
  Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
  RIP: 0010:zero_user_segments.constprop.0+0xdc/0xe0 [btrfs]
  Call Trace:
   <TASK>
   btrfs_get_extent.cold+0x85/0x101 [btrfs 7453c70c03e631c8d8bfdd4264fa62d3e238da6f]
   btrfs_do_readpage+0x244/0x750 [btrfs 7453c70c03e631c8d8bfdd4264fa62d3e238da6f]
   btrfs_read_folio+0x9c/0x100 [btrfs 7453c70c03e631c8d8bfdd4264fa62d3e238da6f]
   filemap_read_folio+0x37/0xe0
   do_read_cache_folio+0x94/0x3e0
   __page_get_link.isra.0+0x20/0x90
   page_get_link+0x16/0x40
   step_into+0x69b/0x830
   path_lookupat+0xa7/0x170
   filename_lookup+0xf7/0x200
   ? set_ptes.isra.0+0x36/0x70
   vfs_statx+0x7a/0x160
   do_statx+0x63/0xa0
   __x64_sys_statx+0x90/0xe0
   do_syscall_64+0x82/0xae0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
   </TASK>

Please note bs > ps support is still under development and the
enablement patch is not even in btrfs development branch.

[CAUSE]
Btrfs reuses its data folio read path to handle symbolic links, as the
symbolic link target is stored as an inline data extent.

But for newly created inodes, btrfs only set the minimal order if the
target inode is a regular file.

Thus for above newly created symbolic link, it doesn't properly respect
the minimal folio order, and triggered the above crash.

[FIX]
Call btrfs_set_inode_mapping_order() unconditionally inside
btrfs_create_new_inode().

For symbolic links this will fix the crash as now the folio will meet
the minimal order.

For regular files this brings no change.

For directory/bdev/char and all the other types of inodes, they won't
go through the data read path, thus no effect either.

Fixes: cc38d178ff33 ("btrfs: enable large data folio support under CONFIG_BTRFS_EXPERIMENTAL")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 18db1053cdf08..cd8a09e3d1dc0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6479,6 +6479,7 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	if (!args->subvol)
 		btrfs_inherit_iflags(BTRFS_I(inode), BTRFS_I(dir));
 
+	btrfs_set_inode_mapping_order(BTRFS_I(inode));
 	if (S_ISREG(inode->i_mode)) {
 		if (btrfs_test_opt(fs_info, NODATASUM))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
@@ -6486,7 +6487,6 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
 				BTRFS_INODE_NODATASUM;
 		btrfs_update_inode_mapping_flags(BTRFS_I(inode));
-		btrfs_set_inode_mapping_order(BTRFS_I(inode));
 	}
 
 	ret = btrfs_insert_inode_locked(inode);
-- 
2.51.0



