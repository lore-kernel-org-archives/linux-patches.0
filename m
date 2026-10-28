Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214057;
	b=14KSMnzw2SIrphHUXgd5prbksNKLXUdN1ip+1LGrxDfmc186bR0gE20bd0gWG1+tPIIV
	 3Bj7mUnyxnuRy8OdGR4KjzGBQiPsYLGpP2bd9gah6tFcnQ3Q2PaCJBK9fTdmFqEfd4nPW
	 CwAd7ILb9MhHExSTECPu5kKjKKAoICvPJX5iZ1dbuRS7VRSeSyiNbVHA7aYO+OL8VeEcP
	 rcgd/mh3sJIfmNgQw+rr+cdsP/HiVHWCBRBnGo7fdfwDE52RP6RBdgZE2Pnuqim+6LSPL
	 IWj32uCWDoF7Lsn3sFMHBiTnjs8IDBO/vRzyY0Kj48OI/3gvFt0Xz77MoVSK0lFrVyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VAVFfUehpoDYyCnXXovOHzufR+qk/KnPRwHpMwUlHww=;
	b=FeoQrNAMo+zhioag9FAcff4Ixrgy/7rT0vb6C6mGeEMMMuUKUXfr6sHhDkyRWWTtfeA4
	 fdys6kgndjRdSUg8JJJFGNnIJnOmJ4Bn7/kD+A7aAGGryaYvXThN45TTC3tTs4YmebYOW
	 THCM5B+MbEkzJm9CTJu3pVsVAzy4TEK2UBMKMjDj+sFLIIORxnpi78KBnAaNkiLACoNYQ
	 AOVfPvxQ+5XNYN+M3ZQ5EWX1WeOyu4YawEzAyCrXzRCewmzQGzDYoeSnPUpqk93iFbxfS
	 oQyL50A5OIOhnzFvSN6faU4HEx0LHBWBVAU3y0AONIp8RIfB+ISOOHnDjdNvgNjAFRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDf6gF4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5993606A31C;
	Wed, 28 Oct 2026 19:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDf6gF4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFAE1F01825;
	Wed, 28 Oct 2026 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214056;
	bh=VAVFfUehpoDYyCnXXovOHzufR+qk/KnPRwHpMwUlHww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDf6gF4UvgyphdegGN9+piD3hsG2FZqok1KTez58pCr/cGId66Sult+FrbBypcrF/
	 YVIj+A9qCJj677iOZMcc1XbuGbUxS/wzT0OY1NEYkawOhwFFNtdMyGXWc+0XGTm1KX
	 TEa2CtGlksqJmFPlhV0cULTTfckChRrRUmH6NGes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0725/1887] btrfs: do proper folio cleanup when cow_file_range() failed
Date: Wed, 28 Oct 2026 17:47:01 +0100
Message-ID: <20261028170515.945841394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 06f364284794f149d2abc167c11d556cf20c954b ]

[BUG]
When testing with COW fixup marked as BUG_ON() (this is involved with the
new pin_user_pages*() change, which should not result new out-of-band
dirty pages), I hit a crash triggered by the BUG_ON() from hitting COW
fixup path.

This BUG_ON() happens just after a failed btrfs_run_delalloc_range():

  BTRFS error (device dm-2): failed to run delalloc range, root 348 ino 405 folio 65536 submit_bitmap 6-15 start 90112 len 106496: -28
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/extent_io.c:1444!
  Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
  CPU: 0 UID: 0 PID: 434621 Comm: kworker/u24:8 Tainted: G           OE      6.12.0-rc7-custom+ #86
  Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
  Workqueue: events_unbound btrfs_async_reclaim_data_space [btrfs]
  pc : extent_writepage_io+0x2d4/0x308 [btrfs]
  lr : extent_writepage_io+0x2d4/0x308 [btrfs]
  Call trace:
   extent_writepage_io+0x2d4/0x308 [btrfs]
   extent_writepage+0x218/0x330 [btrfs]
   extent_write_cache_pages+0x1d4/0x4b0 [btrfs]
   btrfs_writepages+0x94/0x150 [btrfs]
   do_writepages+0x74/0x190
   filemap_fdatawrite_wbc+0x88/0xc8
   start_delalloc_inodes+0x180/0x3b0 [btrfs]
   btrfs_start_delalloc_roots+0x174/0x280 [btrfs]
   shrink_delalloc+0x114/0x280 [btrfs]
   flush_space+0x250/0x2f8 [btrfs]
   btrfs_async_reclaim_data_space+0x180/0x228 [btrfs]
   process_one_work+0x164/0x408
   worker_thread+0x25c/0x388
   kthread+0x100/0x118
   ret_from_fork+0x10/0x20
  Code: aa1403e1 9402f3ef aa1403e0 9402f36f (d4210000)
  ---[ end trace 0000000000000000 ]---

[CAUSE]
That failure is mostly from cow_file_range(), where we can hit -ENOSPC.

Although the -ENOSPC is already a bug related to our space reservation
code, let's just focus on the error handling.

For example, we have the following dirty range [0, 64K) of an inode,
with 4K sector size and 4K page size:

   0        16K        32K       48K       64K
   |///////////////////////////////////////|
   |#######################################|

Where |///| means page are still dirty, and |###| means the extent io
tree has EXTENT_DELALLOC flag.

- Enter extent_writepage() for page 0

- Enter btrfs_run_delalloc_range() for range [0, 64K)

- Enter cow_file_range() for range [0, 64K)

- Function btrfs_reserve_extent() only reserved one 16K extent
  So we created extent map and ordered extent for range [0, 16K)

   0        16K        32K       48K       64K
   |////////|//////////////////////////////|
   |<- OE ->|##############################|

   And range [0, 16K) has its delalloc flag cleared.
   But since we haven't yet submit any bio, involved 4 pages are still
   dirty.

- Function btrfs_reserve_extent() returns with -ENOSPC
  Now we have to run error cleanup, which will clear all
  EXTENT_DELALLOC* flags and clear the dirty flags for the remaining
  ranges:

   0        16K        32K       48K       64K
   |////////|                              |
   |        |                              |

  Note that range [0, 16K) still has its pages dirty.

- Some time later, writeback is triggered again for the range [0, 16K)
  since the page range still has dirty flags.

- btrfs_run_delalloc_range() will do nothing because there is no
  EXTENT_DELALLOC flag.

- extent_writepage_io() finds page 0 has no ordered flag
  Which falls into the COW fixup path, triggering the BUG_ON().

Unfortunately this error handling bug dates back to the introduction of
btrfs.  Thankfully with the abuse of COW fixup, at least it won't crash
the kernel.

[FIX]
Instead of immediately unlocking the extent and folios, we keep the extent
and folios locked until either erroring out or the whole delalloc range
finished.

When the whole delalloc range finished without error, we just unlock the
whole range with PAGE_SET_ORDERED (and PAGE_UNLOCK for !keep_locked
cases), with EXTENT_DELALLOC and EXTENT_LOCKED cleared.
And the involved folios will be properly submitted, with their dirty
flags cleared during submission.

For the error path, it will be a little more complex:

- The range with ordered extent allocated (range (1))
  We only clear the EXTENT_DELALLOC and EXTENT_LOCKED, as the remaining
  flags are cleaned up by
  btrfs_mark_ordered_io_finished()->btrfs_finish_one_ordered().

  For folios we finish the IO (clear dirty, start writeback and
  immediately finish the writeback) and unlock the folios.

- The range with reserved extent but no ordered extent (range(2))
- The range we never touched (range(3))
  For both range (2) and range(3) the behavior is not changed.

Now even if cow_file_range() failed halfway with some successfully
reserved extents/ordered extents, we will keep all folios clean, so
there will be no future writeback triggered on them.

CC: stable@vger.kernel.org
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 63 ++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e53b42a047e8b..7d1eab71f17b4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1265,6 +1265,17 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 
 	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
 
+	/*
+	 * We're not doing compressed IO, don't unlock the first page (which
+	 * the caller expects to stay locked), don't clear any dirty bits and
+	 * don't set any writeback bits.
+	 *
+	 * Do set the Ordered (Private2) bit so we know this page was properly
+	 * setup for writepage.
+	 */
+	page_ops = unlock ? PAGE_UNLOCK : 0;
+	page_ops |= PAGE_SET_ORDERED;
+
 	/*
 	 * Relocation relies on the relocated extents to have exactly the same
 	 * size as the original extents. Normally writeback for relocation data
@@ -1335,21 +1346,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 
 		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 
-		/*
-		 * We're not doing compressed IO, don't unlock the first page
-		 * (which the caller expects to stay locked), don't clear any
-		 * dirty bits and don't set any writeback bits
-		 *
-		 * Do set the Ordered (Private2) bit so we know this page was
-		 * properly setup for writepage.
-		 */
-		page_ops = unlock ? PAGE_UNLOCK : 0;
-		page_ops |= PAGE_SET_ORDERED;
-
-		extent_clear_unlock_delalloc(inode, start, start + ram_size - 1,
-					     locked_page,
-					     EXTENT_LOCKED | EXTENT_DELALLOC,
-					     page_ops);
 		if (num_bytes < cur_alloc_size)
 			num_bytes = 0;
 		else
@@ -1366,6 +1362,8 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		if (ret)
 			goto out_unlock;
 	}
+	extent_clear_unlock_delalloc(inode, orig_start, end, locked_page,
+				     EXTENT_LOCKED | EXTENT_DELALLOC, page_ops);
 out:
 	return ret;
 
@@ -1380,10 +1378,15 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	 * caller to write out the successfully allocated region and retry.
 	 */
 	if (done_offset && ret == -EAGAIN) {
-		if (orig_start < start)
+		if (orig_start < start) {
+			extent_clear_unlock_delalloc(inode, orig_start, start - 1,
+						     locked_page,
+						     EXTENT_LOCKED | EXTENT_DELALLOC,
+						     page_ops);
 			*done_offset = start - 1;
-		else
+		} else {
 			*done_offset = start;
+		}
 		return ret;
 	} else if (ret == -EAGAIN) {
 		/* Convert to -ENOSPC since the caller cannot retry. */
@@ -1399,29 +1402,31 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	 * We process each region below.
 	 */
 
-	clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
-		EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV;
-	page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK;
-
 	/*
 	 * For the range (1). We have already instantiated the ordered extents
 	 * for this region. They are cleaned up by
 	 * btrfs_cleanup_ordered_extents() in e.g,
-	 * btrfs_run_delalloc_range(). EXTENT_LOCKED | EXTENT_DELALLOC are
-	 * already cleared in the above loop. And, EXTENT_DELALLOC_NEW |
-	 * EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV are handled by the cleanup
-	 * function.
+	 * btrfs_run_delalloc_range().
+	 * EXTENT_DELALLOC_NEW | EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV
+	 * are also handled by the cleanup function.
 	 *
-	 * However, in case of unlock == 0, we still need to unlock the pages
-	 * (except @locked_page) to ensure all the pages are unlocked.
+	 * So here we only clear EXTENT_LOCKED and EXTENT_DELALLOC flag, and
+	 * finish the writeback of the involved folios, which will be never submitted.
 	 */
-	if (!unlock && orig_start < start) {
+	if (orig_start < start) {
+		clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC;
+		page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK;
+
 		if (!locked_page)
 			mapping_set_error(inode->vfs_inode.i_mapping, ret);
 		extent_clear_unlock_delalloc(inode, orig_start, start - 1,
-					     locked_page, 0, page_ops);
+					     locked_page, clear_bits, page_ops);
 	}
 
+	clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+		     EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV;
+	page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK;
+
 	/*
 	 * For the range (2). If we reserved an extent for our delalloc range
 	 * (or a subrange) and failed to create the respective ordered extent,
-- 
2.53.0



