Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B488F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0241C433C7;
	Sun, 16 Jul 2023 19:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537406;
	bh=bq7Z0UIxrDeJr2IDGBA1IvhrO+pekEjraZ0lV27mX4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGvDixF+SC0Fy0gkU0+pOmvohxaATM8GwAGuMSslrBGvHh16pZG333mNFXibGSmaW
	 XxEg5Y+5RtoAsrWwBYVNH/5qlvefPzV+nI0Yj66+xwy+Ee1S626HNdk6f8orwbau6Y
	 q/ocTAv7y05q6igA2zMkD7JQtW6nfJ0sM5leObAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 057/800] btrfs: only call __extent_writepage_io from extent_write_locked_range
Date: Sun, 16 Jul 2023 21:38:30 +0200
Message-ID: <20230716194950.414196700@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit eb34dceace983e304e00d4bf711cec0a603959ac ]

__extent_writepage does a lot of things that make no sense for
extent_write_locked_range, given that extent_write_locked_range itself is
called from __extent_writepage either directly or through a workqueue,
and all this work has already been done in the first invocation and the
pages haven't been unlocked since.  Call __extent_writepage_io directly
instead and open code the logic tracked in
btrfs_bio_ctrl::extent_locked.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7027f87108ce ("btrfs: don't treat zoned writeback as being from an async helper thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 65 ++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ac3aae55d55e5..6116da5d0a1ed 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -103,12 +103,6 @@ struct btrfs_bio_ctrl {
 	blk_opf_t opf;
 	btrfs_bio_end_io_t end_io_func;
 	struct writeback_control *wbc;
-
-	/*
-	 * Tell writepage not to lock the state bits for this range, it still
-	 * does the unlocking.
-	 */
-	bool extent_locked;
 };
 
 static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
@@ -1550,7 +1544,6 @@ static int __extent_writepage(struct page *page, struct btrfs_bio_ctrl *bio_ctrl
 {
 	struct folio *folio = page_folio(page);
 	struct inode *inode = page->mapping->host;
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	const u64 page_start = page_offset(page);
 	const u64 page_end = page_start + PAGE_SIZE - 1;
 	int ret;
@@ -1583,13 +1576,11 @@ static int __extent_writepage(struct page *page, struct btrfs_bio_ctrl *bio_ctrl
 		goto done;
 	}
 
-	if (!bio_ctrl->extent_locked) {
-		ret = writepage_delalloc(BTRFS_I(inode), page, bio_ctrl->wbc);
-		if (ret == 1)
-			return 0;
-		if (ret)
-			goto done;
-	}
+	ret = writepage_delalloc(BTRFS_I(inode), page, bio_ctrl->wbc);
+	if (ret == 1)
+		return 0;
+	if (ret)
+		goto done;
 
 	ret = __extent_writepage_io(BTRFS_I(inode), page, bio_ctrl, i_size, &nr);
 	if (ret == 1)
@@ -1634,21 +1625,7 @@ static int __extent_writepage(struct page *page, struct btrfs_bio_ctrl *bio_ctrl
 	 */
 	if (PageError(page))
 		end_extent_writepage(page, ret, page_start, page_end);
-	if (bio_ctrl->extent_locked) {
-		struct writeback_control *wbc = bio_ctrl->wbc;
-
-		/*
-		 * If bio_ctrl->extent_locked, it's from extent_write_locked_range(),
-		 * the page can either be locked by lock_page() or
-		 * process_one_page().
-		 * Let btrfs_page_unlock_writer() handle both cases.
-		 */
-		ASSERT(wbc);
-		btrfs_page_unlock_writer(fs_info, page, wbc->range_start,
-					 wbc->range_end + 1 - wbc->range_start);
-	} else {
-		unlock_page(page);
-	}
+	unlock_page(page);
 	ASSERT(ret <= 0);
 	return ret;
 }
@@ -2461,10 +2438,10 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end)
 	int first_error = 0;
 	int ret = 0;
 	struct address_space *mapping = inode->i_mapping;
-	struct page *page;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	const u32 sectorsize = fs_info->sectorsize;
+	loff_t i_size = i_size_read(inode);
 	u64 cur = start;
-	unsigned long nr_pages;
-	const u32 sectorsize = btrfs_sb(inode->i_sb)->sectorsize;
 	struct writeback_control wbc_writepages = {
 		.sync_mode	= WB_SYNC_ALL,
 		.range_start	= start,
@@ -2476,17 +2453,15 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end)
 		/* We're called from an async helper function */
 		.opf = REQ_OP_WRITE | REQ_BTRFS_CGROUP_PUNT |
 			wbc_to_write_flags(&wbc_writepages),
-		.extent_locked = 1,
 	};
 
 	ASSERT(IS_ALIGNED(start, sectorsize) && IS_ALIGNED(end + 1, sectorsize));
-	nr_pages = (round_up(end, PAGE_SIZE) - round_down(start, PAGE_SIZE)) >>
-		   PAGE_SHIFT;
-	wbc_writepages.nr_to_write = nr_pages * 2;
 
 	wbc_attach_fdatawrite_inode(&wbc_writepages, inode);
 	while (cur <= end) {
 		u64 cur_end = min(round_down(cur, PAGE_SIZE) + PAGE_SIZE - 1, end);
+		struct page *page;
+		int nr = 0;
 
 		page = find_get_page(mapping, cur >> PAGE_SHIFT);
 		/*
@@ -2497,12 +2472,25 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end)
 		ASSERT(PageLocked(page));
 		ASSERT(PageDirty(page));
 		clear_page_dirty_for_io(page);
-		ret = __extent_writepage(page, &bio_ctrl);
-		ASSERT(ret <= 0);
+
+		ret = __extent_writepage_io(BTRFS_I(inode), page, &bio_ctrl,
+					    i_size, &nr);
+		if (ret == 1)
+			goto next_page;
+
+		/* Make sure the mapping tag for page dirty gets cleared. */
+		if (nr == 0) {
+			set_page_writeback(page);
+			end_page_writeback(page);
+		}
+		if (ret)
+			end_extent_writepage(page, ret, cur, cur_end);
+		btrfs_page_unlock_writer(fs_info, page, cur, cur_end + 1 - cur);
 		if (ret < 0) {
 			found_error = true;
 			first_error = ret;
 		}
+next_page:
 		put_page(page);
 		cur = cur_end + 1;
 	}
@@ -2523,7 +2511,6 @@ int extent_writepages(struct address_space *mapping,
 	struct btrfs_bio_ctrl bio_ctrl = {
 		.wbc = wbc,
 		.opf = REQ_OP_WRITE | wbc_to_write_flags(wbc),
-		.extent_locked = 0,
 	};
 
 	/*
-- 
2.39.2



