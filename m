Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015160;
	b=XsmzF/aj7aDa6BDfwQBAi7+pbl72jIGy1ejXH3BgW9Jhanfm4h0+Pr/WA+I1HoxBsZZ+
	 ld9SilWDQlJy/xJmj1fi7PY3mKKizOO14nkpR9KmHHPJXIwH6m986K0FgOJY6xfpcgP9a
	 Lmx46XDN8j28ZCAddQc9SBraxkMIOgKrwOflZ5Y2GfvABxG2DsJ47uYSdqSqJ9P3UTvzX
	 lBvelAV4m7i/AJoFf+r2zcNJS4lYX1YL7uFqLTDxMk4bXMw/cKFnr1d6BKhk/uUUHMGTH
	 a6LH5kbk9Xy51LSlP8m+5l0kDR25rIBn6ZwdritSwA5+Z2qIa82OiQSJPJiJfr1hJ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9SrmjmX/Lvea1pRAs/O7OZ9gshi8fhd6EHxplkaWTfE=;
	b=r7zuAaqA4mdRnkA8y2vwjvaW1qOwWVjjeXUsylmcpwHXE7/FXCGONZ5s0iHwZRjsSgwu
	 83YNtkt5J0v3x3vg6L+fZQZVFBIkoKE4krKPxAulFoBDIlv06f5SD2dD4GDwn7OlL/yEr
	 JFOLJ3mgxY9ycqCex6r9e0zvfH5uuC6vsTcAjaZ6/e3hmTRkRwHL1BdLFi0OaY02dXsqN
	 nBB2GSnfNQWOGOWOegLrdUEJN10rYoudMXMksB8/Z7Y9FSWS8KE/Gop1Zt269cUC4N0gr
	 mwEYYvXNiEiWUy1GTt//1TZxul15BmahvdWC0begPqTozmphcD6gGbIDKWFOXMjqd1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xkq7cSrx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34812606A337;
	Wed, 18 Nov 2026 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xkq7cSrx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3461F000CE;
	Wed, 18 Nov 2026 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015160;
	bh=9SrmjmX/Lvea1pRAs/O7OZ9gshi8fhd6EHxplkaWTfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xkq7cSrxkwmQrvAXDtQt5YRhPvD1SVBamYsapunQpqKUwB72AnbSJwQEakARchhXp
	 4rwmfkzW8hbyuU/p7xVNs3/Qv1qxaD9ROcXb2hNupR9pmCc+XLCyAPhwa2qxdR0mXU
	 LYIB54p5UNq9K6lFZWCYUYybzcGSO5kUBQk5UbnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0032/2651] btrfs: replace btrfs_repair_io_failure() to use bio for page iteration
Date: Wed, 18 Nov 2026 15:21:12 +0100
Message-ID: <20261118150249.132792957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 15ed4a938b30fcb72e96187f36e2c4ff0e6e2227 ]

Currently btrfs_repair_io_failure() uses a @paddrs[] array to iterate
pages.

Such a parameter is required for bs > ps cases, as one fs block crosses
several pages.

However there is a much simpler and existing way to iterate pages: bio
and bvec_iter.

This changes btrfs_repair_io_failure() by:

- Use a const @bvec_iter pointer to locate where the pages are
- Extract file offset/logical from the @bbio
- Require no @step parameter
  Above features allow us to shorten the parameter list.

- Rename the function to btrfs_repair_bbio_failure()

- Change the caller in btrfs_repair_eb_io_failure() to allocate a bbio
  Unlike the data read path, we do not have a handy bbio in that case.
  So we need to allocate one just for btrfs_repair_bbio_failure().

- Change the error reporting in btrfs_repair_bbio_failure() to include
  root id and use inode number directly
  Now for btree inode we will report a proper inode number (1).

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: d00b85308abe ("btrfs: raid56: do not verify the content if there is no data checksum")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c     | 61 ++++++++++++++++++++++++++--------------------
 fs/btrfs/bio.h     |  5 ++--
 fs/btrfs/disk-io.c | 25 +++++++++++++------
 3 files changed, 55 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index cc0bd03048bae..f8d4c2d550073 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -186,7 +186,6 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 	 */
 	struct bvec_iter saved_iter = repair_bbio->saved_iter;
 	const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
-	const u64 logical = repair_bbio->saved_iter.bi_sector << SECTOR_SHIFT;
 	const u32 nr_steps = repair_bbio->saved_iter.bi_size / step;
 	int mirror = repair_bbio->mirror_num;
 	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
@@ -220,9 +219,8 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
 
 	do {
 		mirror = prev_repair_mirror(fbio, mirror);
-		btrfs_repair_io_failure(fs_info, btrfs_ino(inode),
-				  repair_bbio->file_offset, fs_info->sectorsize,
-				  logical, paddrs, step, mirror);
+		btrfs_repair_bbio_failure(repair_bbio, &repair_bbio->saved_iter,
+					  fs_info->sectorsize, mirror);
 	} while (mirror != fbio->bbio->mirror_num);
 
 done:
@@ -925,21 +923,23 @@ void btrfs_submit_bbio(struct btrfs_bio *bbio, int mirror_num)
  * The I/O is issued synchronously to block the repair read completion from
  * freeing the bio.
  *
- * @ino:	Offending inode number
- * @fileoff:	File offset inside the inode
+ * @bbio:	Original bbio where the repair is needed
+ * @orig_iter:	Points to where the repair start is
  * @length:	Length of the repair write
- * @logical:	Logical address of the range
- * @paddrs:	Physical address array of the content
- * @step:	Length of for each paddrs
  * @mirror_num: Mirror number to write to. Must not be zero
  */
-int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
-			    u32 length, u64 logical, const phys_addr_t paddrs[],
-			    unsigned int step, int mirror_num)
+int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *orig_iter,
+			      u32 length, int mirror_num)
 {
-	const u32 nr_steps = DIV_ROUND_UP_POW2(length, step);
+	struct btrfs_inode *inode = bbio->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_io_stripe smap = { 0 };
-	struct bio *bio = NULL;
+	struct bvec_iter iter = *orig_iter;
+	struct bio *repair_bio = NULL;
+	const u64 logical = iter.bi_sector << SECTOR_SHIFT;
+	const u64 fileoff = bbio->file_offset +
+			    ((iter.bi_sector - bbio->saved_iter.bi_sector) << SECTOR_SHIFT);
+	u32 cur = 0;
 	int ret = 0;
 
 	BUG_ON(!mirror_num);
@@ -950,8 +950,9 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
 	ASSERT(IS_ALIGNED(fileoff, fs_info->sectorsize));
 	/* Either it's a single data or metadata block. */
 	ASSERT(length <= BTRFS_MAX_BLOCKSIZE);
-	ASSERT(step <= length);
-	ASSERT(is_power_of_2(step));
+
+	/* Our current iter should not be before the original bbio saved_iter. */
+	ASSERT(iter.bi_sector >= bbio->saved_iter.bi_sector);
 
 	/*
 	 * The fs either mounted RO or hit critical errors, no need
@@ -979,15 +980,22 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
 		goto out_counter_dec;
 	}
 
-	bio = bio_alloc(smap.dev->bdev, nr_steps, REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
-	bio->bi_iter.bi_sector = smap.physical >> SECTOR_SHIFT;
-	for (int i = 0; i < nr_steps; i++) {
-		ret = bio_add_page(bio, phys_to_page(paddrs[i]), step, offset_in_page(paddrs[i]));
-		/* We should have allocated enough slots to contain all the different pages. */
-		ASSERT(ret == step);
+	repair_bio = bio_alloc(smap.dev->bdev, max(1, length >> PAGE_SHIFT),
+			       REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
+	repair_bio->bi_iter.bi_sector = smap.physical >> SECTOR_SHIFT;
+	while (cur < length) {
+		struct page *page = bio_iter_page(&bbio->bio, iter);
+		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
+		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), length - cur);
+
+		ret = bio_add_page(repair_bio, page, cur_len, pg_off);
+		ASSERT(ret == cur_len);
+		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
+		cur += cur_len;
 	}
-	ret = submit_bio_wait(bio);
-	bio_put(bio);
+
+	ret = submit_bio_wait(repair_bio);
+	bio_put(repair_bio);
 	if (ret) {
 		/* try to remap that extent elsewhere? */
 		btrfs_dev_stat_inc_and_print(smap.dev, BTRFS_DEV_STAT_WRITE_ERRS);
@@ -995,8 +1003,9 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
 	}
 
 	btrfs_info_rl(fs_info,
-		"read error corrected: ino %llu off %llu (dev %s sector %llu)",
-			     ino, fileoff, btrfs_dev_name(smap.dev),
+		"read error corrected: root %llu ino %llu off %llu (dev %s sector %llu)",
+			     btrfs_root_id(inode->root), btrfs_ino(inode), fileoff,
+			     btrfs_dev_name(smap.dev),
 			     smap.physical >> SECTOR_SHIFT);
 	ret = 0;
 
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index 303ed6c7103d9..b7bd377a01624 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -126,8 +126,7 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status);
 
 void btrfs_submit_bbio(struct btrfs_bio *bbio, int mirror_num);
 void btrfs_submit_repair_write(struct btrfs_bio *bbio, int mirror_num, bool dev_replace);
-int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
-			    u32 length, u64 logical, const phys_addr_t paddrs[],
-			    unsigned int step, int mirror_num);
+int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *orig_iter,
+			      u32 length, int mirror_num);
 
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dc7ad92876c0b..0f3e8e74b7682 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -176,19 +176,24 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 				      int mirror_num)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
-	const u32 step = min(fs_info->nodesize, PAGE_SIZE);
-	const u32 nr_steps = eb->len / step;
-	phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
+	struct btrfs_bio *bbio;
+	int ret;
 
 	if (sb_rdonly(fs_info->sb))
 		return -EROFS;
 
+	/*
+	 * This bbio is only to queue all pages for btrfs_repair_bbio_failure().
+	 * Thus it will never get its endio called.
+	 */
+	bbio = btrfs_bio_alloc(max(1, fs_info->nodesize >> PAGE_SHIFT), REQ_OP_READ,
+			       BTRFS_I(fs_info->btree_inode), eb->start, NULL, NULL);
+	bbio->bio.bi_iter.bi_sector = eb->start >> SECTOR_SHIFT;
 	for (int i = 0; i < num_extent_pages(eb); i++) {
 		struct folio *folio = eb->folios[i];
 
 		/* No large folio support yet. */
 		ASSERT(folio_order(folio) == 0);
-		ASSERT(i < nr_steps);
 
 		/*
 		 * For nodesize < page size, there is just one paddr, with some
@@ -197,11 +202,17 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 		 * For nodesize >= page size, it's one or more paddrs, and eb->start
 		 * must be aligned to page boundary.
 		 */
-		paddrs[i] = page_to_phys(&folio->page) + offset_in_page(eb->start);
+		ret = bio_add_page(&bbio->bio, &folio->page, min(PAGE_SIZE, fs_info->nodesize),
+				   offset_in_page(eb->start));
+		ASSERT(ret == min(PAGE_SIZE, fs_info->nodesize));
 	}
+	/* Since the bbio is never submitted, we have to save the iter manually. */
+	bbio->saved_iter = bbio->bio.bi_iter;
 
-	return btrfs_repair_io_failure(fs_info, 0, eb->start, eb->len,
-				       eb->start, paddrs, step, mirror_num);
+	ret = btrfs_repair_bbio_failure(bbio, &bbio->saved_iter, fs_info->nodesize,
+					mirror_num);
+	bio_put(&bbio->bio);
+	return ret;
 }
 
 /*
-- 
2.53.0



