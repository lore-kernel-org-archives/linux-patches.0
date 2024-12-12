Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A407223E62;
	Thu, 12 Dec 2024 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020314; cv=none; b=LlQKxCPRMFt2eyVc3OCzjzDj3m6X1euDY4tqTSCTkk7W3oZfLew1xpikhIka+cWZLgI+wYUkoRahRO496ngMa+NQ1WOVsQGDzSGYKh8t7uGqvRL8wJrTnCElq52z8VaNF8gV7ztWr523q9RFL94x/HJ2+zUiPWYf/y0CJ4eZ1H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020314; c=relaxed/simple;
	bh=mAsqCoFEvEZsZ89dNh4v7hC9NxuA6Hrna7YFyA2oFeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf9llpuohanSPiOtATHMILqKMX3L0Po1Qt3iMlosL05oIxsAVwEoP9UNOZQGV/gJ514pvKMfXDsVxtgAL7c6yRREOD48mNjAlhU+X9D9i4pPA+OjyqUwrYuP8H+rXwpjGFVUWxv1nhpg0zTifSlR1yrVuN7hwYZviBE61vyDM/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9nFunLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9nFunLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB7EC4CECE;
	Thu, 12 Dec 2024 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020314;
	bh=mAsqCoFEvEZsZ89dNh4v7hC9NxuA6Hrna7YFyA2oFeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9nFunLRkhIpp7Ii5uMBtSIytxGqTt+ilYNhogSWq4rWFBVkRzQu8lWCbI3MfNA9W
	 zsZLU30DWIZJnXeDEOjzEL2WkG91dQVFvCO/W9/JYDRUcduM+WmAC1uTLJHOThRkIT
	 gBf5FMZaGfSrJrfEn0LEevyT0XPq3GC46N+M4Oho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 436/772] ubifs: authentication: Fix use-after-free in ubifs_tnc_end_commit
Date: Thu, 12 Dec 2024 15:56:21 +0100
Message-ID: <20241212144407.947907101@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit 4617fb8fc15effe8eda4dd898d4e33eb537a7140 ]

After an insertion in TNC, the tree might split and cause a node to
change its `znode->parent`. A further deletion of other nodes in the
tree (which also could free the nodes), the aforementioned node's
`znode->cparent` could still point to a freed node. This
`znode->cparent` may not be updated when getting nodes to commit in
`ubifs_tnc_start_commit()`. This could then trigger a use-after-free
when accessing the `znode->cparent` in `write_index()` in
`ubifs_tnc_end_commit()`.

This can be triggered by running

  rm -f /etc/test-file.bin
  dd if=/dev/urandom of=/etc/test-file.bin bs=1M count=60 conv=fsync

in a loop, and with `CONFIG_UBIFS_FS_AUTHENTICATION`. KASAN then
reports:

  BUG: KASAN: use-after-free in ubifs_tnc_end_commit+0xa5c/0x1950
  Write of size 32 at addr ffffff800a3af86c by task ubifs_bgt0_20/153

  Call trace:
   dump_backtrace+0x0/0x340
   show_stack+0x18/0x24
   dump_stack_lvl+0x9c/0xbc
   print_address_description.constprop.0+0x74/0x2b0
   kasan_report+0x1d8/0x1f0
   kasan_check_range+0xf8/0x1a0
   memcpy+0x84/0xf4
   ubifs_tnc_end_commit+0xa5c/0x1950
   do_commit+0x4e0/0x1340
   ubifs_bg_thread+0x234/0x2e0
   kthread+0x36c/0x410
   ret_from_fork+0x10/0x20

  Allocated by task 401:
   kasan_save_stack+0x38/0x70
   __kasan_kmalloc+0x8c/0xd0
   __kmalloc+0x34c/0x5bc
   tnc_insert+0x140/0x16a4
   ubifs_tnc_add+0x370/0x52c
   ubifs_jnl_write_data+0x5d8/0x870
   do_writepage+0x36c/0x510
   ubifs_writepage+0x190/0x4dc
   __writepage+0x58/0x154
   write_cache_pages+0x394/0x830
   do_writepages+0x1f0/0x5b0
   filemap_fdatawrite_wbc+0x170/0x25c
   file_write_and_wait_range+0x140/0x190
   ubifs_fsync+0xe8/0x290
   vfs_fsync_range+0xc0/0x1e4
   do_fsync+0x40/0x90
   __arm64_sys_fsync+0x34/0x50
   invoke_syscall.constprop.0+0xa8/0x260
   do_el0_svc+0xc8/0x1f0
   el0_svc+0x34/0x70
   el0t_64_sync_handler+0x108/0x114
   el0t_64_sync+0x1a4/0x1a8

  Freed by task 403:
   kasan_save_stack+0x38/0x70
   kasan_set_track+0x28/0x40
   kasan_set_free_info+0x28/0x4c
   __kasan_slab_free+0xd4/0x13c
   kfree+0xc4/0x3a0
   tnc_delete+0x3f4/0xe40
   ubifs_tnc_remove_range+0x368/0x73c
   ubifs_tnc_remove_ino+0x29c/0x2e0
   ubifs_jnl_delete_inode+0x150/0x260
   ubifs_evict_inode+0x1d4/0x2e4
   evict+0x1c8/0x450
   iput+0x2a0/0x3c4
   do_unlinkat+0x2cc/0x490
   __arm64_sys_unlinkat+0x90/0x100
   invoke_syscall.constprop.0+0xa8/0x260
   do_el0_svc+0xc8/0x1f0
   el0_svc+0x34/0x70
   el0t_64_sync_handler+0x108/0x114
   el0t_64_sync+0x1a4/0x1a8

The offending `memcpy()` in `ubifs_copy_hash()` has a use-after-free
when a node becomes root in TNC but still has a `cparent` to an already
freed node. More specifically, consider the following TNC:

         zroot
         /
        /
      zp1
      /
     /
    zn

Inserting a new node `zn_new` with a key smaller then `zn` will trigger
a split in `tnc_insert()` if `zp1` is full:

         zroot
         /   \
        /     \
      zp1     zp2
      /         \
     /           \
  zn_new          zn

`zn->parent` has now been moved to `zp2`, *but* `zn->cparent` still
points to `zp1`.

Now, consider a removal of all the nodes _except_ `zn`. Just when
`tnc_delete()` is about to delete `zroot` and `zp2`:

         zroot
             \
              \
              zp2
                \
                 \
                 zn

`zroot` and `zp2` get freed and the tree collapses:

           zn

`zn` now becomes the new `zroot`.

`get_znodes_to_commit()` will now only find `zn`, the new `zroot`, and
`write_index()` will check its `znode->cparent` that wrongly points to
the already freed `zp1`. `ubifs_copy_hash()` thus gets wrongly called
with `znode->cparent->zbranch[znode->iip].hash` that triggers the
use-after-free!

Fix this by explicitly setting `znode->cparent` to `NULL` in
`get_znodes_to_commit()` for the root node. The search for the dirty
nodes is bottom-up in the tree. Thus, when `find_next_dirty(znode)`
returns NULL, the current `znode` _is_ the root node. Add an assert for
this.

Fixes: 16a26b20d2af ("ubifs: authentication: Add hashes to index nodes")
Tested-by: Waqar Hameed <waqar.hameed@axis.com>
Co-developed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/tnc_commit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
index 01362ad5f804a..efd52cc534364 100644
--- a/fs/ubifs/tnc_commit.c
+++ b/fs/ubifs/tnc_commit.c
@@ -657,6 +657,8 @@ static int get_znodes_to_commit(struct ubifs_info *c)
 		znode->alt = 0;
 		cnext = find_next_dirty(znode);
 		if (!cnext) {
+			ubifs_assert(c, !znode->parent);
+			znode->cparent = NULL;
 			znode->cnext = c->cnext;
 			break;
 		}
-- 
2.43.0



