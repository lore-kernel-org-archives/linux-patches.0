Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E9A400968;
	Thu, 16 Jul 2026 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210000; cv=none; b=GRxbNQJjVgSYb5suAFywJEcY1zCFF7dUv1F72gsRE1bCCk0OzGF7m7nP3HhPYJGMkc6Mq/HfGOu4zv9CDQEWEDeJZFJARI/XILOTaCi8S6ArQSYG6sjsAUxdI8+DbG1d8h8keuvGJvW1wq2mEos0QXofCSKI83d6UN8gsP9uxVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210000; c=relaxed/simple;
	bh=Rhy/gddFftOU+llO1qvOK/3Erlx23+Usz9QfPOiCIZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amg8lWe01d8XWOUwNWETehll+sfSYEzIb9OuU7TQaW2hTwNWUONYWoNhIGAej/FGrk0a+QPbyP6YD3hFQJ+mctUmxTuKlEbGIlrbwEkzsNkJHufyb0OMogy08BKtIO3Jg+jfeKIibxFT7swjuOTP3x8RMifE9RfNn2u12Afu/BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JRdSujN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JRdSujN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABD01F000E9;
	Thu, 16 Jul 2026 13:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209999;
	bh=yHsg17wDHq3n3AZtf8J0RVTb+irCIKrC5It5sI/w5cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0JRdSujNTJG6A7k6JSWbWFqtH5ZJLS9q1GxZnEt1bONbMecweBy4+OLbZGSqIffCK
	 zZLvgeAk8uSlH5fAJMA5Qc+IiHQGv0lrvobwk26u89iDgVhbaHn5cC4PKIm3iZIWWY
	 GsMUmFm+YWv4Fm3qlisMWM/KUktIAONFNryJstHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.1 355/518] btrfs: check and set EXTENT_DELALLOC_NEW before clearing EXTENT_DELALLOC
Date: Thu, 16 Jul 2026 15:30:23 +0200
Message-ID: <20260716133055.595126007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 95ee2231896d5f2a31760411429075a99d6045a7 upstream.

[WARNING]
When running test cases with injected errors or shutdown, e.g.
generic/388 or generic/475, there is a chance that the following kernel
warning is triggered:

  BTRFS info (device dm-2): first mount of filesystem d8a19a28-3232-4809-b0df-38df83e71bff
  BTRFS info (device dm-2): using crc32c checksum algorithm
  BTRFS info (device dm-2): checking UUID tree
  BTRFS info (device dm-2): turning on async discard
  BTRFS info (device dm-2): enabling free space tree
  BTRFS critical (device dm-2 state E): emergency shutdown
  ------------[ cut here ]------------
  WARNING: extent_io.c:1742 at extent_writepage_io+0x437/0x520 [btrfs], CPU#2: kworker/u43:2/651591
  CPU: 2 UID: 0 PID: 651591 Comm: kworker/u43:2 Tainted: G        W  OE       7.0.0-rc6-custom+ #365 PREEMPT(full)  5804053f02137e627472d94b5128cc9fcb110e88
  RIP: 0010:extent_writepage_io+0x437/0x520 [btrfs]
  Call Trace:
   <TASK>
   extent_write_cache_pages+0x2a5/0x820 [btrfs 70299925d0856939e93b17d480651713b3cbba58]
   btrfs_writepages+0x74/0x130 [btrfs 70299925d0856939e93b17d480651713b3cbba58]
   do_writepages+0xd0/0x160
   __writeback_single_inode+0x42/0x340
   writeback_sb_inodes+0x22d/0x580
   wb_writeback+0xc6/0x360
   wb_workfn+0xbd/0x470
   process_one_work+0x198/0x3b0
   worker_thread+0x1c8/0x330
   kthread+0xee/0x120
   ret_from_fork+0x2a6/0x330
   ret_from_fork_asm+0x11/0x20
   </TASK>
  ---[ end trace 0000000000000000 ]---
  BTRFS error (device dm-2 state E): root 5 ino 259 folio 1323008 is marked dirty without notifying the fs
  BTRFS error (device dm-2 state E): failed to submit blocks, root=5 inode=259 folio=1323008 submit_bitmap=0: -117
  BTRFS info (device dm-2 state E): last unmount of filesystem d8a19a28-3232-4809-b0df-38df83e71bff

[CAUSE]
Inside btrfs we have the following pattern in several locations, for
example inside btrfs_dirty_folio():

	btrfs_clear_extent_bit(&inode->io_tree, start_pos, end_of_last_block,
			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
			       cached);

	ret = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
					extra_bits, cached);
	if (ret)
		return ret;

However btrfs_set_extent_delalloc() can return IO errors other than -ENOMEM
through the following callchain:

 btrfs_set_extent_delalloc()
 \- btrfs_find_new_delalloc_bytes()
    \- btrfs_get_extent()
       \- btrfs_lookup_file_extent()
          \- btrfs_search_slot()

When such IO error happened, the previous btrfs_clear_extent_bit() has
cleared the EXTENT_DELALLOC for the range, and we're expecting
btrfs_set_extent_delalloc() to re-set EXTENT_DELALLOC.

But since btrfs_set_extent_delalloc() failed before
btrfs_set_extent_bit(), EXTENT_DELALLOC flag is no longer present.

And if the folio range is dirty before entering
btrfs_set_extent_delalloc(), we got a dirty folio but no EXTENT_DELALLOC
flag now.

Then we hit the folio writeback:

  extent_writepage()
  |- writepage_delalloc()
  |  No ordered extent is created, as there is no EXTENT_DELALLOC set
  |  for the folio range.
  |  This also means the folio has no ordered flag set.
  |
  |- extent_writepage_io()
     \- if (unlikely(!folio_test_ordered(folio))
        Now we hit the warning.

[FIX]
Introduce a new helper, btrfs_reset_extent_delalloc() to replace the
currently open-coded btrfs_clear_extent_bit() +
btrfs_set_extent_delalloc() combination.

Instead of calling btrfs_clear_extent_bit() first, update
EXTENT_DELALLOC_NEW first, as that part can fail due to metadata IO,
meanwhile btrfs_clear_extent_bit() and btrfs_set_extent_bit() won't
return any error but retry memory allocation until succeeded.

This allows us to fail early without clearing EXTENT_DELALLOC bit, so
even if that new btrfs_reset_extent_delalloc() failed before touching
EXTENT_DELALLOC, the existing dirty range will still have their old
EXTENT_DELALLOC flag present, thus avoid the warning.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/btrfs_inode.h |    2 +
 fs/btrfs/file.c        |   25 ++------------------
 fs/btrfs/inode.c       |   61 +++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/reflink.c     |    4 ---
 4 files changed, 60 insertions(+), 32 deletions(-)

--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -569,6 +569,8 @@ int btrfs_start_delalloc_roots(struct bt
 int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state);
+int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
+				unsigned int extra_bits, struct extent_state **cached_state);
 
 struct btrfs_new_inode_args {
 	/* Input */
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -93,16 +93,8 @@ int btrfs_dirty_folio(struct btrfs_inode
 
 	end_of_last_block = start_pos + num_bytes - 1;
 
-	/*
-	 * The pages may have already been dirty, clear out old accounting so
-	 * we can set things up properly
-	 */
-	btrfs_clear_extent_bit(&inode->io_tree, start_pos, end_of_last_block,
-			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-			       cached);
-
-	ret = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
-					extra_bits, cached);
+	ret = btrfs_reset_extent_delalloc(inode, start_pos, end_of_last_block,
+					  extra_bits, cached);
 	if (ret)
 		return ret;
 
@@ -1966,18 +1958,7 @@ again:
 		}
 	}
 
-	/*
-	 * page_mkwrite gets called when the page is firstly dirtied after it's
-	 * faulted in, but write(2) could also dirty a page and set delalloc
-	 * bits, thus in this case for space account reason, we still need to
-	 * clear any delalloc bits within this page range since we have to
-	 * reserve data&meta space before lock_page() (see above comments).
-	 */
-	btrfs_clear_extent_bit(io_tree, page_start, end,
-			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
-			       EXTENT_DEFRAG, &cached_state);
-
-	ret = btrfs_set_extent_delalloc(inode, page_start, end, 0, &cached_state);
+	ret = btrfs_reset_extent_delalloc(inode, page_start, end, 0, &cached_state);
 	if (ret < 0) {
 		btrfs_unlock_extent(io_tree, page_start, page_end, &cached_state);
 		goto out_unlock;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2810,7 +2810,13 @@ int btrfs_set_extent_delalloc(struct btr
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state)
 {
-	WARN_ON(PAGE_ALIGNED(end));
+	const u32 blocksize = inode->root->fs_info->sectorsize;
+
+	/* Basic alignment check. */
+	ASSERT(IS_ALIGNED(start, blocksize), "start=%llu blocksize=%u",
+	       start, blocksize);
+	ASSERT(IS_ALIGNED(end + 1, blocksize), "inclusive end=%llu blocksize=%u",
+	       end, blocksize);
 
 	if (start >= i_size_read(&inode->vfs_inode) &&
 	    !(inode->flags & BTRFS_INODE_PREALLOC)) {
@@ -3035,6 +3041,52 @@ int btrfs_writepage_cow_fixup(struct fol
 	return -EAGAIN;
 }
 
+/*
+ * Clear the old accounting flags and set EXTENT_DELALLOC for the range.
+ *
+ * Return <0 for error, in that case no range has EXTENT_DELALLOC bit cleared or set.
+ */
+int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
+				unsigned int extra_bits, struct extent_state **cached_state)
+{
+	const u32 blocksize = inode->root->fs_info->sectorsize;
+
+	/* The @extra_bits can only be EXTENT_NORESERVE for now. */
+	ASSERT(!(extra_bits & ~EXTENT_NORESERVE), "extra_bits=0x%x", extra_bits);
+
+	/* Basic alignment check. */
+	ASSERT(IS_ALIGNED(start, blocksize), "start=%llu blocksize=%u",
+	       start, blocksize);
+	ASSERT(IS_ALIGNED(end + 1, blocksize), "inclusive end=%llu blocksize=%u",
+	       end, blocksize);
+
+	/*
+	 * Check and set DELALLOC_NEW flag, this needs to search tree thus can
+	 * fail early.  Thus we want to do this before clearing EXTENT_DELALLOC.
+	 */
+	if (start >= i_size_read(&inode->vfs_inode) &&
+	    !(inode->flags & BTRFS_INODE_PREALLOC)) {
+		/*
+		 * There can't be any extents following EOF in this case so just
+		 * set the delalloc new bit for the range directly.
+		 */
+		extra_bits |= EXTENT_DELALLOC_NEW;
+	} else {
+		int ret;
+
+		ret = btrfs_find_new_delalloc_bytes(inode, start, end + 1 - start,
+						    NULL);
+		if (unlikely(ret))
+			return ret;
+	}
+	/* Clear the old accounting as the range may already be dirty. */
+	btrfs_clear_extent_bit(&inode->io_tree, start, end,
+			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
+			       EXTENT_DEFRAG, cached_state);
+	return btrfs_set_extent_bit(&inode->io_tree, start, end,
+				    EXTENT_DELALLOC | extra_bits, cached_state);
+}
+
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       struct btrfs_inode *inode, u64 file_pos,
 				       struct btrfs_file_extent_item *stack_fi,
@@ -5181,12 +5233,7 @@ again:
 		goto again;
 	}
 
-	btrfs_clear_extent_bit(&inode->io_tree, block_start, block_end,
-			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-			       &cached_state);
-
-	ret = btrfs_set_extent_delalloc(inode, block_start, block_end, 0,
-					&cached_state);
+	ret = btrfs_reset_extent_delalloc(inode, block_start, block_end, 0, &cached_state);
 	if (ret) {
 		btrfs_unlock_extent(io_tree, block_start, block_end, &cached_state);
 		goto out_unlock;
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -94,9 +94,7 @@ static int copy_inline_to_page(struct bt
 	if (ret < 0)
 		goto out_unlock;
 
-	btrfs_clear_extent_bit(&inode->io_tree, file_offset, range_end,
-			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, NULL);
-	ret = btrfs_set_extent_delalloc(inode, file_offset, range_end, 0, NULL);
+	ret = btrfs_reset_extent_delalloc(inode, file_offset, range_end, 0, NULL);
 	if (ret)
 		goto out_unlock;
 


