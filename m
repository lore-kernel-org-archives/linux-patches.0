Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67EA1C6FE1;
	Tue, 11 Nov 2025 00:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822772; cv=none; b=Kfggs+aP8MN6iWoLGVpXGUm6LT+0IVotsIs5W+bXtGbQrBaNKsuZux4oZcE9B4hpnVh3iFsJ2fWMd+e+IAySLpKojQwGt06ERsfI88AhI6Pi72mpqjk9k+mZMIrHki5uksIVqLCSe2nuBjqJu6X1vW5heGiQKME17v753oZXE/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822772; c=relaxed/simple;
	bh=hFI320JiMLbZMjk+H8wq24MvTz43ZMJq/rQytYxuk7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3er4SumgVPBOjFoF58XxA5b3wrlrJ+c0FiViadtA0oIJxnSOcLqJsscbm22VSR+CkkGyb4Az0NXwUNt6sHJOQAmid36atrdsx68pZnZ0/OnVdw4qIRwBBLWIWkMfJqcS336TALo1V4UnBDcUco5wIqujwx4S/aXbuPRZQiiHlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKK+BKEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKK+BKEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86313C113D0;
	Tue, 11 Nov 2025 00:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822771;
	bh=hFI320JiMLbZMjk+H8wq24MvTz43ZMJq/rQytYxuk7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKK+BKEM2A57225oe5UGneK4xgpbtqM4IO2l/pdp0mFWk9vE1yvNDJudjlElbtm0G
	 TmVd7hugNj4o3Kt5uTiiKtTSoMB4yyIkH4QSm1krZ7AYQvxcCBVAKAVeyTCJJ0Ol2T
	 RCg+Yqg19CIPBkCGZI8T7loz1iXcTbK8L0bWlLLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 164/849] block: check for valid bio while splitting
Date: Tue, 11 Nov 2025 09:35:34 +0900
Message-ID: <20251111004540.397994402@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit fec2e705729dc93de5399d8b139e4746805c3d81 ]

We're already iterating every segment, so check these for a valid IO
lengths at the same time. Individual segment lengths will not be checked
on passthrough commands. The read/write command segments must be sized
to the dma alignment.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c        |  2 +-
 block/blk-merge.c      | 21 +++++++++++++++++----
 include/linux/bio.h    |  4 ++--
 include/linux/blkdev.h |  7 +++++++
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 23e5d5ebe59ec..6d1268aa82715 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -443,7 +443,7 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 	int ret;
 
 	/* check that the data layout matches the hardware restrictions */
-	ret = bio_split_rw_at(bio, lim, &nr_segs, max_bytes);
+	ret = bio_split_io_at(bio, lim, &nr_segs, max_bytes, 0);
 	if (ret) {
 		/* if we would have to split the bio, copy instead */
 		if (ret > 0)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 77488f11a9441..37864c5d287ef 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -303,25 +303,30 @@ static unsigned int bio_split_alignment(struct bio *bio,
 }
 
 /**
- * bio_split_rw_at - check if and where to split a read/write bio
+ * bio_split_io_at - check if and where to split a bio
  * @bio:  [in] bio to be split
  * @lim:  [in] queue limits to split based on
  * @segs: [out] number of segments in the bio with the first half of the sectors
  * @max_bytes: [in] maximum number of bytes per bio
+ * @len_align_mask: [in] length alignment mask for each vector
  *
  * Find out if @bio needs to be split to fit the queue limits in @lim and a
  * maximum size of @max_bytes.  Returns a negative error number if @bio can't be
  * split, 0 if the bio doesn't have to be split, or a positive sector offset if
  * @bio needs to be split.
  */
-int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
-		unsigned *segs, unsigned max_bytes)
+int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
+		unsigned *segs, unsigned max_bytes, unsigned len_align_mask)
 {
 	struct bio_vec bv, bvprv, *bvprvp = NULL;
 	struct bvec_iter iter;
 	unsigned nsegs = 0, bytes = 0;
 
 	bio_for_each_bvec(bv, bio, iter) {
+		if (bv.bv_offset & lim->dma_alignment ||
+		    bv.bv_len & len_align_mask)
+			return -EINVAL;
+
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
@@ -363,8 +368,16 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	 * Individual bvecs might not be logical block aligned. Round down the
 	 * split size so that each bio is properly block size aligned, even if
 	 * we do not use the full hardware limits.
+	 *
+	 * It is possible to submit a bio that can't be split into a valid io:
+	 * there may either be too many discontiguous vectors for the max
+	 * segments limit, or contain virtual boundary gaps without having a
+	 * valid block sized split. A zero byte result means one of those
+	 * conditions occured.
 	 */
 	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
+	if (!bytes)
+		return -EINVAL;
 
 	/*
 	 * Bio splitting may cause subtle trouble such as hang when doing sync
@@ -374,7 +387,7 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	bio_clear_polled(bio);
 	return bytes >> SECTOR_SHIFT;
 }
-EXPORT_SYMBOL_GPL(bio_split_rw_at);
+EXPORT_SYMBOL_GPL(bio_split_io_at);
 
 struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 		unsigned *nr_segs)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 46ffac5caab78..519a1d59805f8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -322,8 +322,8 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
 void bio_trim(struct bio *bio, sector_t offset, sector_t size);
 extern struct bio *bio_split(struct bio *bio, int sectors,
 			     gfp_t gfp, struct bio_set *bs);
-int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
-		unsigned *segs, unsigned max_bytes);
+int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
+		unsigned *segs, unsigned max_bytes, unsigned len_align);
 
 /**
  * bio_next_split - get next @sectors from a bio, splitting if necessary
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cc221318712e7..37fa7169fa9f4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1872,6 +1872,13 @@ bdev_atomic_write_unit_max_bytes(struct block_device *bdev)
 	return queue_atomic_write_unit_max_bytes(bdev_get_queue(bdev));
 }
 
+static inline int bio_split_rw_at(struct bio *bio,
+		const struct queue_limits *lim,
+		unsigned *segs, unsigned max_bytes)
+{
+	return bio_split_io_at(bio, lim, segs, max_bytes, lim->dma_alignment);
+}
+
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
 
 #endif /* _LINUX_BLKDEV_H */
-- 
2.51.0



