Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EF2332A36;
	Wed, 17 Sep 2025 12:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113795; cv=none; b=E8yt8VLrgnPsVscxtVsLm7rtmSUmu/aRdsq8/kvF8tTXZfgdK6TsY6Xwvr8pLtwCzRtbxeJyTbOw/+5L33WaDJReI7kHuUC4ibKSPRmoO/ULGvPYi9K/iTR2/AGFjdMcY2dHUV4B3d/3tE/6fAkLRViMXAOmSLNtDExW1IDBUVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113795; c=relaxed/simple;
	bh=VNvLJ+voKsgTFwzwqEj3XitdATa/nlRTv3Lqv1op0B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcDt/7uqB+jrDHsW64vI0mLNuSH+OFU3gXDyhY9Y2g42P1X9OxUwdm5D2HRGN8mhO772wqNqKbgzUCKjAnoezf/7AL/LhrXIitKXDxgWtL/+LNfJNN/Js8W/Y/qTj28ldrpBX23NornJ5pJb0YmbzXEk155EvTji1u5RF0YoLLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjmAZXVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjmAZXVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F6DC4CEF0;
	Wed, 17 Sep 2025 12:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113795;
	bh=VNvLJ+voKsgTFwzwqEj3XitdATa/nlRTv3Lqv1op0B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjmAZXVhg7f0caEoOOSN52ISPtqWk7plmZYYAKc4gC/yYtH8WEQpQPHdU5v8XJpB2
	 etvuRPzAMCEtK+A2O9zNynNEexIbuHQa8a0f3Md3yjqJLyEffZo09zSTYR7hLiq8x4
	 afdJH+DhQkGn+gjrH0zAfhUF+iEFTJ4nr1jFJ1gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/101] btrfs: fix corruption reading compressed range when block size is smaller than page size
Date: Wed, 17 Sep 2025 14:34:37 +0200
Message-ID: <20250917123338.149015453@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 9786531399a679fc2f4630d2c0a186205282ab2f ]

[BUG]
With 64K page size (aarch64 with 64K page size config) and 4K btrfs
block size, the following workload can easily lead to a corrupted read:

        mkfs.btrfs -f -s 4k $dev > /dev/null
        mount -o compress $dev $mnt
        xfs_io -f -c "pwrite -S 0xff 0 64k" $mnt/base > /dev/null
	echo "correct result:"
        od -Ad -t x1 $mnt/base
        xfs_io -f -c "reflink $mnt/base 32k 0 32k" \
		  -c "reflink $mnt/base 0 32k 32k" \
		  -c "pwrite -S 0xff 60k 4k" $mnt/new > /dev/null
	echo "incorrect result:"
        od -Ad -t x1 $mnt/new
        umount $mnt

This shows the following result:

correct result:
0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
*
0065536
incorrect result:
0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
*
0032768 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
0061440 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
*
0065536

Notice the zero in the range [32K, 60K), which is incorrect.

[CAUSE]
With extra trace printk, it shows the following events during od:
(some unrelated info removed like CPU and context)

 od-3457   btrfs_do_readpage: enter r/i=5/258 folio=0(65536) prev_em_start=0000000000000000

The "r/i" is indicating the root and inode number. In our case the file
"new" is using ino 258 from fs tree (root 5).

Here notice the @prev_em_start pointer is NULL. This means the
btrfs_do_readpage() is called from btrfs_read_folio(), not from
btrfs_readahead().

 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=0 got em start=0 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=4096 got em start=0 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=8192 got em start=0 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=12288 got em start=0 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=16384 got em start=0 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=20480 got em start=0 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=24576 got em start=0 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=28672 got em start=0 len=32768

These above 32K blocks will be read from the first half of the
compressed data extent.

 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=32768 got em start=32768 len=32768

Note here there is no btrfs_submit_compressed_read() call. Which is
incorrect now.
Although both extent maps at 0 and 32K are pointing to the same compressed
data, their offsets are different thus can not be merged into the same
read.

So this means the compressed data read merge check is doing something
wrong.

 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=36864 got em start=32768 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=40960 got em start=32768 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=45056 got em start=32768 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=49152 got em start=32768 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=53248 got em start=32768 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=57344 got em start=32768 len=32768
 od-3457   btrfs_do_readpage: r/i=5/258 folio=0(65536) cur=61440 skip uptodate
 od-3457   btrfs_submit_compressed_read: cb orig_bio: file off=0 len=61440

The function btrfs_submit_compressed_read() is only called at the end of
folio read. The compressed bio will only have an extent map of range [0,
32K), but the original bio passed in is for the whole 64K folio.

This will cause the decompression part to only fill the first 32K,
leaving the rest untouched (aka, filled with zero).

This incorrect compressed read merge leads to the above data corruption.

There were similar problems that happened in the past, commit 808f80b46790
("Btrfs: update fix for read corruption of compressed and shared
extents") is doing pretty much the same fix for readahead.

But that's back to 2015, where btrfs still only supports bs (block size)
== ps (page size) cases.
This means btrfs_do_readpage() only needs to handle a folio which
contains exactly one block.

Only btrfs_readahead() can lead to a read covering multiple blocks.
Thus only btrfs_readahead() passes a non-NULL @prev_em_start pointer.

With v5.15 kernel btrfs introduced bs < ps support. This breaks the above
assumption that a folio can only contain one block.

Now btrfs_read_folio() can also read multiple blocks in one go.
But btrfs_read_folio() doesn't pass a @prev_em_start pointer, thus the
existing bio force submission check will never be triggered.

In theory, this can also happen for btrfs with large folios, but since
large folio is still experimental, we don't need to bother it, thus only
bs < ps support is affected for now.

[FIX]
Instead of passing @prev_em_start to do the proper compressed extent
check, introduce one new member, btrfs_bio_ctrl::last_em_start, so that
the existing bio force submission logic will always be triggered.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -104,6 +104,24 @@ struct btrfs_bio_ctrl {
 	btrfs_bio_end_io_t end_io_func;
 	struct writeback_control *wbc;
 	struct readahead_control *ractl;
+
+	/*
+	 * The start offset of the last used extent map by a read operation.
+	 *
+	 * This is for proper compressed read merge.
+	 * U64_MAX means we are starting the read and have made no progress yet.
+	 *
+	 * The current btrfs_bio_is_contig() only uses disk_bytenr as
+	 * the condition to check if the read can be merged with previous
+	 * bio, which is not correct. E.g. two file extents pointing to the
+	 * same extent but with different offset.
+	 *
+	 * So here we need to do extra checks to only merge reads that are
+	 * covered by the same extent map.
+	 * Just extent_map::start will be enough, as they are unique
+	 * inside the same inode.
+	 */
+	u64 last_em_start;
 };
 
 static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
@@ -978,7 +996,7 @@ static void btrfs_readahead_expand(struc
  * return 0 on success, otherwise return error
  */
 static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
-		      struct btrfs_bio_ctrl *bio_ctrl, u64 *prev_em_start)
+		      struct btrfs_bio_ctrl *bio_ctrl)
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -1095,12 +1113,11 @@ static int btrfs_do_readpage(struct page
 		 * non-optimal behavior (submitting 2 bios for the same extent).
 		 */
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
-		    prev_em_start && *prev_em_start != (u64)-1 &&
-		    *prev_em_start != em->start)
+		    bio_ctrl->last_em_start != (u64)-1 &&
+		    bio_ctrl->last_em_start != em->start)
 			force_bio_submit = true;
 
-		if (prev_em_start)
-			*prev_em_start = em->start;
+		bio_ctrl->last_em_start = em->start;
 
 		free_extent_map(em);
 		em = NULL;
@@ -1146,12 +1163,15 @@ int btrfs_read_folio(struct file *file,
 	struct btrfs_inode *inode = BTRFS_I(page->mapping->host);
 	u64 start = page_offset(page);
 	u64 end = start + PAGE_SIZE - 1;
-	struct btrfs_bio_ctrl bio_ctrl = { .opf = REQ_OP_READ };
+	struct btrfs_bio_ctrl bio_ctrl = {
+		.opf = REQ_OP_READ,
+		.last_em_start = (u64)-1,
+	};
 	int ret;
 
 	btrfs_lock_and_flush_ordered_range(inode, start, end, NULL);
 
-	ret = btrfs_do_readpage(page, NULL, &bio_ctrl, NULL);
+	ret = btrfs_do_readpage(page, NULL, &bio_ctrl);
 	/*
 	 * If btrfs_do_readpage() failed we will want to submit the assembled
 	 * bio to do the cleanup.
@@ -1163,8 +1183,7 @@ int btrfs_read_folio(struct file *file,
 static inline void contiguous_readpages(struct page *pages[], int nr_pages,
 					u64 start, u64 end,
 					struct extent_map **em_cached,
-					struct btrfs_bio_ctrl *bio_ctrl,
-					u64 *prev_em_start)
+					struct btrfs_bio_ctrl *bio_ctrl)
 {
 	struct btrfs_inode *inode = BTRFS_I(pages[0]->mapping->host);
 	int index;
@@ -1172,8 +1191,7 @@ static inline void contiguous_readpages(
 	btrfs_lock_and_flush_ordered_range(inode, start, end, NULL);
 
 	for (index = 0; index < nr_pages; index++) {
-		btrfs_do_readpage(pages[index], em_cached, bio_ctrl,
-				  prev_em_start);
+		btrfs_do_readpage(pages[index], em_cached, bio_ctrl);
 		put_page(pages[index]);
 	}
 }
@@ -2255,11 +2273,11 @@ void extent_readahead(struct readahead_c
 {
 	struct btrfs_bio_ctrl bio_ctrl = {
 		.opf = REQ_OP_READ | REQ_RAHEAD,
-		.ractl = rac
+		.ractl = rac,
+		.last_em_start = (u64)-1,
 	};
 	struct page *pagepool[16];
 	struct extent_map *em_cached = NULL;
-	u64 prev_em_start = (u64)-1;
 	int nr;
 
 	while ((nr = readahead_page_batch(rac, pagepool))) {
@@ -2267,7 +2285,7 @@ void extent_readahead(struct readahead_c
 		u64 contig_end = contig_start + readahead_batch_length(rac) - 1;
 
 		contiguous_readpages(pagepool, nr, contig_start, contig_end,
-				&em_cached, &bio_ctrl, &prev_em_start);
+				&em_cached, &bio_ctrl);
 	}
 
 	if (em_cached)


