Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1C88F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AE5C433C7;
	Sun, 16 Jul 2023 19:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537403;
	bh=162XbSXobg2Aw/MEUmG7ePp+WzV77Grj7ynQn8BUJE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sT6zrprQ7m2Bk3h9cnLVu+aTqk13u2jj0dFFQzQzf+hIsNQuGZUjXG9zutKhS1du4
	 K7bjLZQPGLequUqffGZGqRl/64a82MZ3b2qNF9slVzPMZgbh7xKwpIaEQxeHSLuofr
	 lkqiIxQ1OHvAnmp5LKTi5FGG1o5FV6B9DC/EfiS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 056/800] btrfs: dont fail writeback when allocating the compression context fails
Date: Sun, 16 Jul 2023 21:38:29 +0200
Message-ID: <20230716194950.391411359@linuxfoundation.org>
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

[ Upstream commit 973fb26e81a9f59dfe45b079a698c0e238f7bf69 ]

If cow_file_range_async fails to allocate the asynchronous writeback
context, it currently returns an error and entirely fails the writeback.
This is not a good idea as a writeback failure is a non-temporary error
condition that will make the file system unusable.  Just fall back to
synchronous uncompressed writeback instead.  This requires us to delay
setting the BTRFS_INODE_HAS_ASYNC_EXTENT flag until we've committed to
the async writeback.

The compression checks INODE_NOCOMPRESS and FORCE_COMPRESS are moved
from cow_file_range_async to the preceding checks btrfs_run_delalloc_range().

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 7027f87108ce ("btrfs: don't treat zoned writeback as being from an async helper thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 74 ++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7fcafcc5292c8..3d12dba145152 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1521,58 +1521,36 @@ static noinline void async_cow_free(struct btrfs_work *work)
 		kvfree(async_cow);
 }
 
-static int cow_file_range_async(struct btrfs_inode *inode,
-				struct writeback_control *wbc,
-				struct page *locked_page,
-				u64 start, u64 end, int *page_started,
-				unsigned long *nr_written)
+static bool cow_file_range_async(struct btrfs_inode *inode,
+				 struct writeback_control *wbc,
+				 struct page *locked_page,
+				 u64 start, u64 end, int *page_started,
+				 unsigned long *nr_written)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct cgroup_subsys_state *blkcg_css = wbc_blkcg_css(wbc);
 	struct async_cow *ctx;
 	struct async_chunk *async_chunk;
 	unsigned long nr_pages;
-	u64 cur_end;
 	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
 	int i;
-	bool should_compress;
 	unsigned nofs_flag;
 	const blk_opf_t write_flags = wbc_to_write_flags(wbc);
 
-	unlock_extent(&inode->io_tree, start, end, NULL);
-
-	if (inode->flags & BTRFS_INODE_NOCOMPRESS &&
-	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
-		num_chunks = 1;
-		should_compress = false;
-	} else {
-		should_compress = true;
-	}
-
 	nofs_flag = memalloc_nofs_save();
 	ctx = kvmalloc(struct_size(ctx, chunks, num_chunks), GFP_KERNEL);
 	memalloc_nofs_restore(nofs_flag);
+	if (!ctx)
+		return false;
 
-	if (!ctx) {
-		unsigned clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC |
-			EXTENT_DELALLOC_NEW | EXTENT_DEFRAG |
-			EXTENT_DO_ACCOUNTING;
-		unsigned long page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK |
-					 PAGE_END_WRITEBACK | PAGE_SET_ERROR;
-
-		extent_clear_unlock_delalloc(inode, start, end, locked_page,
-					     clear_bits, page_ops);
-		return -ENOMEM;
-	}
+	unlock_extent(&inode->io_tree, start, end, NULL);
+	set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT, &inode->runtime_flags);
 
 	async_chunk = ctx->chunks;
 	atomic_set(&ctx->num_chunks, num_chunks);
 
 	for (i = 0; i < num_chunks; i++) {
-		if (should_compress)
-			cur_end = min(end, start + SZ_512K - 1);
-		else
-			cur_end = end;
+		u64 cur_end = min(end, start + SZ_512K - 1);
 
 		/*
 		 * igrab is called higher up in the call chain, take only the
@@ -1633,7 +1611,7 @@ static int cow_file_range_async(struct btrfs_inode *inode,
 		start = cur_end + 1;
 	}
 	*page_started = 1;
-	return 0;
+	return true;
 }
 
 static noinline int run_delalloc_zoned(struct btrfs_inode *inode,
@@ -2214,7 +2192,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 		u64 start, u64 end, int *page_started, unsigned long *nr_written,
 		struct writeback_control *wbc)
 {
-	int ret;
+	int ret = 0;
 	const bool zoned = btrfs_is_zoned(inode->root->fs_info);
 
 	/*
@@ -2235,19 +2213,23 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 		ASSERT(!zoned || btrfs_is_data_reloc_root(inode->root));
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, nr_written);
-	} else if (!btrfs_inode_can_compress(inode) ||
-		   !inode_need_compress(inode, start, end)) {
-		if (zoned)
-			ret = run_delalloc_zoned(inode, locked_page, start, end,
-						 page_started, nr_written);
-		else
-			ret = cow_file_range(inode, locked_page, start, end,
-					     page_started, nr_written, 1, NULL);
-	} else {
-		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT, &inode->runtime_flags);
-		ret = cow_file_range_async(inode, wbc, locked_page, start, end,
-					   page_started, nr_written);
+		goto out;
 	}
+
+	if (btrfs_inode_can_compress(inode) &&
+	    inode_need_compress(inode, start, end) &&
+	    cow_file_range_async(inode, wbc, locked_page, start,
+				 end, page_started, nr_written))
+		goto out;
+
+	if (zoned)
+		ret = run_delalloc_zoned(inode, locked_page, start, end,
+					 page_started, nr_written);
+	else
+		ret = cow_file_range(inode, locked_page, start, end,
+				     page_started, nr_written, 1, NULL);
+
+out:
 	ASSERT(ret <= 0);
 	if (ret)
 		btrfs_cleanup_ordered_extents(inode, locked_page, start,
-- 
2.39.2



