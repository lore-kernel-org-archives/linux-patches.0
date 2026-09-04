Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310D73D6664;
	Fri,  4 Sep 2026 05:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499246; cv=none; b=GRnmvyamS3lGhNlzBu/B1+AJGm5WrtLK+nAs/Fye0LLoZn74T6wDsEoX2JbjVIgT20fx42F05OObgwHlzPAEbANoydzK25/nCRArn7wqs2RpsKXhD5u0bZfX2iIBn3n8v/MDONRz4TftOIi+WkXkdBGwH1X31feBkIE2Dq8mFpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499246; c=relaxed/simple;
	bh=bk9g6pyr13cD1tb3qGbiboaqA1cbW4uu2NFODNhJjNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7ZW8ICwUiEIfEDn36vdyT9GW3g3ZhVfa3TRSj8xzsyblYpb9sOHyW7bTpVyJGEZjjr5NDOa4cSq5wG8S/O+J6QP/aR9gdRYFMHKdxAqBcy5FhoCb+nYv6yZJneEnPndbQaWZ4Thkoa9vztOsUNQt5w+H90ZX3YHGM2E+1m5k7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMv8aEuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMv8aEuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EF41F00A3D;
	Fri,  4 Sep 2026 05:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499244;
	bh=uYWubyc2VZJF43caTuKZ9RYM0kNhIqTdGfm2BwN7ssI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMv8aEuVMgH66JXoeeYKfCGe5oWMmxndA6ct4NRQMXeASzpMCL8Xwr9DRfjlqHyaR
	 R69x7iPx5P+vP27j90tUs5xGYa8AIOh8PdnCmk1UGc7BZBlErtUmv8ELlFuL8fr0bG
	 bAfXh5poly28RUMRwjZr3ziseqmUmlaIDnfXSDpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 312/713] block: validate user space vectors during extraction
Date: Fri,  4 Sep 2026 06:54:40 +0200
Message-ID: <20260904045810.828172181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

commit 14b007e178811db72fbb1ebb3535160db6ec1e6a upstream.

The bio-based drivers don't necessarily check the alignment split, and
stacking block drivers don't always handle a misalignment detected after
submitting the bio. Validate user vectors against the device's
dma_alignment as the bio is built from the iov_iter, rejecting
misaligned early with -EINVAL.

Cc: stable@vger.kernel.org
Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://patch.msgid.link/20260720201057.1862857-6-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c          |   56 ++++++++++++++++++++++++++++++++++++++++++++++++---
 block/blk-map.c      |    2 -
 block/fops.c         |    2 -
 fs/iomap/direct-io.c |    1 
 include/linux/bio.h  |    2 -
 include/linux/uio.h  |   10 ++++++++-
 lib/iov_iter.c       |    9 +++++++-
 7 files changed, 74 insertions(+), 8 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1221,10 +1221,45 @@ static int bio_iov_iter_align_down(struc
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_KERNEL
+static inline bool bio_iov_bvec_aligned(const struct bio *bio,
+					unsigned mem_align_mask)
+{
+	struct bvec_iter iter;
+	struct bio_vec bv;
+
+	/*
+	 * Correct callers never break the alignment requirements, so this
+	 * exhaustive check is only paid for in debug builds.
+	 */
+	for_each_mp_bvec(bv, bio->bi_io_vec, iter, bio->bi_iter)
+		if ((bv.bv_offset | bv.bv_len) & mem_align_mask)
+			return false;
+	return true;
+}
+#else
+static inline bool bio_iov_bvec_aligned(const struct bio *bio,
+					unsigned mem_align_mask)
+{
+	/*
+	 * We forward the bio_vec as-is, so ITER_BVEC callers must provide
+	 * segments already aligned to the device's DMA alignment. The only
+	 * unchecked user-controllable offset that reaches here is an io_uring
+	 * registered buffer where just the first segment can be unaligned
+	 * (the rest is virtually contiguous), so checking only that one is
+	 * sufficient to know if the entire vector is valid.
+	 */
+	return !(mp_bvec_iter_offset(bio->bi_io_vec, bio->bi_iter) &
+							mem_align_mask);
+}
+#endif
+
 /**
  * bio_iov_iter_get_pages - add user or kernel pages to a bio
  * @bio: bio to add pages to
  * @iter: iov iterator describing the region to be added
+ * @mem_align_mask: the mask the source address and length must be aligned to,
+ *	0 for no requirement
  * @len_align_mask: the mask to align the total size to, 0 for any length
  *
  * This takes either an iterator pointing to user memory, or one pointing to
@@ -1243,7 +1278,7 @@ static int bio_iov_iter_align_down(struc
  * is returned only if 0 pages could be pinned.
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-			   unsigned len_align_mask)
+			   unsigned mem_align_mask, unsigned len_align_mask)
 {
 	iov_iter_extraction_t flags = 0;
 
@@ -1252,6 +1287,10 @@ int bio_iov_iter_get_pages(struct bio *b
 
 	if (iov_iter_is_bvec(iter)) {
 		bio_iov_bvec_set(bio, iter);
+
+		if (!bio_iov_bvec_aligned(bio, mem_align_mask))
+			return -EINVAL;
+
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
 		return 0;
 	}
@@ -1266,8 +1305,19 @@ int bio_iov_iter_get_pages(struct bio *b
 
 		ret = iov_iter_extract_bvecs(iter, bio->bi_io_vec,
 				BIO_MAX_SIZE - bio->bi_iter.bi_size,
-				&bio->bi_vcnt, bio->bi_max_vecs, flags);
+				&bio->bi_vcnt, bio->bi_max_vecs,
+				mem_align_mask, flags);
 		if (ret <= 0) {
+			/*
+			 * A misaligned vector fails the whole I/O.  Release any
+			 * pages pinned by earlier iterations before returning
+			 * since this bio won't be submitted to release them.
+			 */
+			if (ret == -EINVAL) {
+				bio_release_pages(bio, false);
+				bio_clear_flag(bio, BIO_PAGE_PINNED);
+				bio->bi_vcnt = 0;
+			}
 			if (!bio->bi_vcnt)
 				return ret;
 			break;
@@ -1380,7 +1430,7 @@ static int bio_iov_iter_bounce_read(stru
 
 	do {
 		ret = iov_iter_extract_bvecs(iter, bio->bi_io_vec + 1, len,
-				&bio->bi_vcnt, bio->bi_max_vecs - 1, 0);
+				&bio->bi_vcnt, bio->bi_max_vecs - 1, 0, 0);
 		if (ret <= 0) {
 			if (!bio->bi_vcnt)
 				goto out_folio_put;
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -274,7 +274,7 @@ static int bio_map_user_iov(struct reque
 	 * No alignment requirements on our part to support arbitrary
 	 * passthrough commands.
 	 */
-	ret = bio_iov_iter_get_pages(bio, iter, 0);
+	ret = bio_iov_iter_get_pages(bio, iter, 0, 0);
 	if (ret)
 		goto out_put;
 	ret = blk_rq_append_bio(rq, bio);
--- a/block/fops.c
+++ b/block/fops.c
@@ -46,7 +46,7 @@ static bool blkdev_dio_invalid(struct bl
 static inline int blkdev_iov_iter_get_pages(struct bio *bio,
 		struct iov_iter *iter, struct block_device *bdev)
 {
-	return bio_iov_iter_get_pages(bio, iter,
+	return bio_iov_iter_get_pages(bio, iter, bdev_dma_alignment(bdev),
 			bdev_logical_block_size(bdev) - 1);
 }
 
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -358,6 +358,7 @@ static ssize_t iomap_dio_bio_iter_one(st
 				iomap_max_bio_size(&iter->iomap), alignment);
 	else
 		ret = bio_iov_iter_get_pages(bio, dio->submit.iter,
+					     bdev_dma_alignment(bio->bi_bdev),
 					     alignment - 1);
 	if (unlikely(ret))
 		goto out_put_bio;
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -477,7 +477,7 @@ int bdev_rw_virt(struct block_device *bd
 		size_t len, enum req_op op);
 
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-		unsigned len_align_mask);
+		unsigned mem_align_mask, unsigned len_align_mask);
 
 void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -389,9 +389,17 @@ ssize_t iov_iter_extract_pages(struct io
 			       size_t maxsize, unsigned int maxpages,
 			       iov_iter_extraction_t extraction_flags,
 			       size_t *offset0);
+/*
+ * Block-layer consumers (e.g. bio_iov_iter_get_pages()) require that the
+ * segments of an ITER_BVEC iterator are already aligned to the target device's
+ * DMA alignment, and forward them as-is.  In-kernel users that build their own
+ * bvecs must not create sub-aligned segments; iov_iter_extract_bvecs() enforces
+ * the same for the segments it extracts via @mem_align_mask.
+ */
 ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv,
 		size_t max_size, unsigned short *nr_vecs,
-		unsigned short max_vecs, iov_iter_extraction_t extraction_flags);
+		unsigned short max_vecs, unsigned mem_align_mask,
+		iov_iter_extraction_t extraction_flags);
 
 /**
  * iov_iter_extract_will_pin - Indicate how pages from the iterator will be retained
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1904,6 +1904,8 @@ static unsigned int get_contig_folio_len
  * @max_size:	maximum size to extract from @iter
  * @nr_vecs:	number of vectors in @bv (on in and output)
  * @max_vecs:	maximum vectors in @bv, including those filled before calling
+ * @mem_align_mask:	reject with -EINVAL if the source address or
+ *		length is not aligned to this mask
  * @extraction_flags: flags to qualify request
  *
  * Like iov_iter_extract_pages(), but returns physically contiguous ranges
@@ -1915,14 +1917,19 @@ static unsigned int get_contig_folio_len
  */
 ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv,
 		size_t max_size, unsigned short *nr_vecs,
-		unsigned short max_vecs, iov_iter_extraction_t extraction_flags)
+		unsigned short max_vecs, unsigned mem_align_mask,
+		iov_iter_extraction_t extraction_flags)
 {
+	unsigned long start = (unsigned long)iter_iov_addr(iter);
 	unsigned short entries_left = max_vecs - *nr_vecs;
 	unsigned short nr_pages, i = 0;
 	size_t left, offset, len;
 	struct page **pages;
 	ssize_t size;
 
+	if ((start | iter_iov_len(iter)) & mem_align_mask)
+		return -EINVAL;
+
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far as
 	 * possible so that we can start filling biovecs from the beginning


