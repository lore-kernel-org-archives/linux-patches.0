Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E1E1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA057C433C8;
	Mon, 11 Sep 2023 14:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441197;
	bh=EjhX3ISOepAWN1LJRW4JMVaSQgYGCWc9Mq8/XM3nIIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/PbWTR2lhPVgQHDZaxEc+WhlmS/Y8OFqdkGmBxpJXdOcmrvETVOEfHQwNbPy5nAG
	 QslftNJXk+Wb3aj7i2TS5IKEau+pakii+HQgXgv7QQqC1Hm3dEjuWjvdNASUq9JIE1
	 Y7w8GElpj/18OYKW11hk6Pe7eENr9ip6V9/CMomM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jinyoung Choi <j-young.choi@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 329/739] block: move the bi_size update out of __bio_try_merge_page
Date: Mon, 11 Sep 2023 15:42:08 +0200
Message-ID: <20230911134700.287810653@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

[ Upstream commit 858c708d9efb7e8e5c6320793b778cc17cf8368a ]

The update of bi_size is the only thing in __bio_try_merge_page that
needs a bio.  Move it to the callers, and merge __bio_try_merge_page
and page_is_mergeable into a single bvec_try_merge_page that only takes
the current bvec instead of a full bio.  This will allow reusing this
function for supporting multi-page integrity payload bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jinyoung Choi <j-young.choi@samsung.com>
Link: https://lore.kernel.org/r/20230724165433.117645-8-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ece1d649b6d ("bio-integrity: create multi-page bvecs in bio_integrity_add_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 57 +++++++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 37 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b9b8328d1bc82..c30f7489e4482 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -903,9 +903,8 @@ static inline bool bio_full(struct bio *bio, unsigned len)
 	return false;
 }
 
-static inline bool page_is_mergeable(const struct bio_vec *bv,
-		struct page *page, unsigned int len, unsigned int off,
-		bool *same_page)
+static bool bvec_try_merge_page(struct bio_vec *bv, struct page *page,
+		unsigned int len, unsigned int off, bool *same_page)
 {
 	size_t bv_end = bv->bv_offset + bv->bv_len;
 	phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) + bv_end - 1;
@@ -919,38 +918,14 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 		return false;
 
 	*same_page = ((vec_end_addr & PAGE_MASK) == page_addr);
-	if (*same_page)
-		return true;
-	else if (IS_ENABLED(CONFIG_KMSAN))
-		return false;
-	return (bv->bv_page + bv_end / PAGE_SIZE) == (page + off / PAGE_SIZE);
-}
-
-/**
- * __bio_try_merge_page - try appending data to an existing bvec.
- * @bio: destination bio
- * @page: start page to add
- * @len: length of the data to add
- * @off: offset of the data relative to @page
- * @same_page: return if the segment has been merged inside the same page
- *
- * Try to add the data at @page + @off to the last bvec of @bio.  This is a
- * useful optimisation for file systems with a block size smaller than the
- * page size.
- *
- * Warn if (@len, @off) crosses pages in case that @same_page is true.
- *
- * Return %true on success or %false on failure.
- */
-static bool __bio_try_merge_page(struct bio *bio, struct page *page,
-		unsigned int len, unsigned int off, bool *same_page)
-{
-	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+	if (!*same_page) {
+		if (IS_ENABLED(CONFIG_KMSAN))
+			return false;
+		if (bv->bv_page + bv_end / PAGE_SIZE != page + off / PAGE_SIZE)
+			return false;
+	}
 
-	if (!page_is_mergeable(bv, page, len, off, same_page))
-		return false;
 	bv->bv_len += len;
-	bio->bi_iter.bi_size += len;
 	return true;
 }
 
@@ -972,7 +947,7 @@ static bool bio_try_merge_hw_seg(struct request_queue *q, struct bio *bio,
 		return false;
 	if (bv->bv_len + len > queue_max_segment_size(q))
 		return false;
-	return __bio_try_merge_page(bio, page, len, offset, same_page);
+	return bvec_try_merge_page(bv, page, len, offset, same_page);
 }
 
 /**
@@ -1001,8 +976,11 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		return 0;
 
 	if (bio->bi_vcnt > 0) {
-		if (bio_try_merge_hw_seg(q, bio, page, len, offset, same_page))
+		if (bio_try_merge_hw_seg(q, bio, page, len, offset,
+				same_page)) {
+			bio->bi_iter.bi_size += len;
 			return len;
+		}
 
 		/*
 		 * If the queue doesn't support SG gaps and adding this segment
@@ -1125,8 +1103,11 @@ int bio_add_page(struct bio *bio, struct page *page,
 		return 0;
 
 	if (bio->bi_vcnt > 0 &&
-	    __bio_try_merge_page(bio, page, len, offset, &same_page))
+	    bvec_try_merge_page(&bio->bi_io_vec[bio->bi_vcnt - 1],
+				page, len, offset, &same_page)) {
+		bio->bi_iter.bi_size += len;
 		return len;
+	}
 
 	if (bio_full(bio, len))
 		return 0;
@@ -1208,7 +1189,9 @@ static int bio_iov_add_page(struct bio *bio, struct page *page,
 		return -EIO;
 
 	if (bio->bi_vcnt > 0 &&
-	    __bio_try_merge_page(bio, page, len, offset, &same_page)) {
+	    bvec_try_merge_page(&bio->bi_io_vec[bio->bi_vcnt - 1],
+				page, len, offset, &same_page)) {
+		bio->bi_iter.bi_size += len;
 		if (same_page)
 			bio_release_page(bio, page);
 		return 0;
-- 
2.40.1



