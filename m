Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3267817990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pVX/eHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5880FC433B8;
	Mon,  9 Oct 2023 13:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856859;
	bh=MN+bvM6OurT1OvaPGfHtM3j8quD8NWDHJc5Ml4S3xGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pVX/eHEsOyE9qM1N6RQsR8pmzhxQjENB8BBf+58GPzCEpHOFSuFdd1Qvu9LlEcai
	 FwjElFOgtuQNWhby/MTXuL6qBRfPGzN0jYJjmyROOQKZm5TN3GXCs4L5QfL3qbRN0p
	 yzPsHaRtYeIqnZV5yiZB618YgLg81xhmuZultVLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 015/163] btrfs: remove btrfs_writepage_endio_finish_ordered
Date: Mon,  9 Oct 2023 14:59:39 +0200
Message-ID: <20231009130124.436919442@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6648cedd86135db197410e56b5372b2945f2b311 ]

btrfs_writepage_endio_finish_ordered is a small wrapper around
btrfs_mark_ordered_io_finished that just changs the argument passing
slightly, and adds a tracepoint.

Move the tracpoint to btrfs_mark_ordered_io_finished, which means
it now also covers the error handling in btrfs_cleanup_ordered_extent
and switch all callers to just call btrfs_mark_ordered_io_finished
directly.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: b595d2599632 ("btrfs: don't clear uptodate on write errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h  |  3 ---
 fs/btrfs/extent_io.c    | 17 ++++++++---------
 fs/btrfs/inode.c        |  9 ---------
 fs/btrfs/ordered-data.c |  4 ++++
 4 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d47a927b3504d..90e60ad9db620 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -501,9 +501,6 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 			     u64 start, u64 end, int *page_started,
 			     unsigned long *nr_written, struct writeback_control *wbc);
 int btrfs_writepage_cow_fixup(struct page *page);
-void btrfs_writepage_endio_finish_ordered(struct btrfs_inode *inode,
-					  struct page *page, u64 start,
-					  u64 end, bool uptodate);
 int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
 					     int compress_type);
 int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7cc0ed7532793..b051b6e52022c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -504,17 +504,15 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	struct btrfs_inode *inode;
 	const bool uptodate = (err == 0);
 	int ret = 0;
+	u32 len = end + 1 - start;
 
+	ASSERT(end + 1 - start <= U32_MAX);
 	ASSERT(page && page->mapping);
 	inode = BTRFS_I(page->mapping->host);
-	btrfs_writepage_endio_finish_ordered(inode, page, start, end, uptodate);
+	btrfs_mark_ordered_io_finished(inode, page, start, len, uptodate);
 
 	if (!uptodate) {
 		const struct btrfs_fs_info *fs_info = inode->root->fs_info;
-		u32 len;
-
-		ASSERT(end + 1 - start <= U32_MAX);
-		len = end + 1 - start;
 
 		btrfs_page_clear_uptodate(fs_info, page, start, len);
 		ret = err < 0 ? err : -EIO;
@@ -1382,6 +1380,7 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 
 	bio_ctrl->end_io_func = end_bio_extent_writepage;
 	while (cur <= end) {
+		u32 len = end - cur + 1;
 		u64 disk_bytenr;
 		u64 em_end;
 		u64 dirty_range_start = cur;
@@ -1389,8 +1388,8 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 		u32 iosize;
 
 		if (cur >= i_size) {
-			btrfs_writepage_endio_finish_ordered(inode, page, cur,
-							     end, true);
+			btrfs_mark_ordered_io_finished(inode, page, cur, len,
+						       true);
 			/*
 			 * This range is beyond i_size, thus we don't need to
 			 * bother writing back.
@@ -1399,7 +1398,7 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 			 * writeback the sectors with subpage dirty bits,
 			 * causing writeback without ordered extent.
 			 */
-			btrfs_page_clear_dirty(fs_info, page, cur, end + 1 - cur);
+			btrfs_page_clear_dirty(fs_info, page, cur, len);
 			break;
 		}
 
@@ -1410,7 +1409,7 @@ static noinline_for_stack int __extent_writepage_io(struct btrfs_inode *inode,
 			continue;
 		}
 
-		em = btrfs_get_extent(inode, NULL, 0, cur, end - cur + 1);
+		em = btrfs_get_extent(inode, NULL, 0, cur, len);
 		if (IS_ERR(em)) {
 			ret = PTR_ERR_OR_ZERO(em);
 			goto out_error;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d5c112f6091b1..e0bb4018ddb28 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3391,15 +3391,6 @@ int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered)
 	return btrfs_finish_one_ordered(ordered);
 }
 
-void btrfs_writepage_endio_finish_ordered(struct btrfs_inode *inode,
-					  struct page *page, u64 start,
-					  u64 end, bool uptodate)
-{
-	trace_btrfs_writepage_end_io_hook(inode, start, end, uptodate);
-
-	btrfs_mark_ordered_io_finished(inode, page, start, end + 1 - start, uptodate);
-}
-
 /*
  * Verify the checksum for a single sector without any extra action that depend
  * on the type of I/O.
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5b1aac3fc8e4a..eea5215280dfe 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -410,6 +410,10 @@ void btrfs_mark_ordered_io_finished(struct btrfs_inode *inode,
 	unsigned long flags;
 	u64 cur = file_offset;
 
+	trace_btrfs_writepage_end_io_hook(inode, file_offset,
+					  file_offset + num_bytes - 1,
+					  uptodate);
+
 	spin_lock_irqsave(&tree->lock, flags);
 	while (cur < file_offset + num_bytes) {
 		u64 entry_end;
-- 
2.40.1



