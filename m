Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709251170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55ECC433C7;
	Mon, 11 Sep 2023 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441200;
	bh=KGDFfqeGMG8RbEVZ3GkPgBiP326N5HGZ/UB6fyJ7kL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCJIp80/8RMAYVk6mbu3mb+aEpaVRjoD14LMr5AsYiMBOfqHluxLshEvn+MRCzj17
	 /ccjyH00d2eJA8zOdgNKv+Kk3JnEygnL8SBXiBd4eRGv7MhI4nmpZxP68A05vokMYt
	 Z+c+trltpHBQ8JRm6+J6b1m49rSG68t7VEyug8bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jinyoung Choi <j-young.choi@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 330/739] block: dont pass a bio to bio_try_merge_hw_seg
Date: Mon, 11 Sep 2023 15:42:09 +0200
Message-ID: <20230911134700.313660557@linuxfoundation.org>
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

[ Upstream commit ae42f0b3bf65912e122fc2e8d5f6d94b51156dba ]

There is no good reason to pass the bio to bio_try_merge_hw_seg.  Just
pass the current bvec and rename the function to bvec_try_merge_hw_page.
This will allow reusing this function for supporting multi-page integrity
payload bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jinyoung Choi <j-young.choi@samsung.com>
Link: https://lore.kernel.org/r/20230724165433.117645-9-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ece1d649b6d ("bio-integrity: create multi-page bvecs in bio_integrity_add_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index c30f7489e4482..0766584563f6e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -934,11 +934,10 @@ static bool bvec_try_merge_page(struct bio_vec *bv, struct page *page,
  * size limit.  This is not for normal read/write bios, but for passthrough
  * or Zone Append operations that we can't split.
  */
-static bool bio_try_merge_hw_seg(struct request_queue *q, struct bio *bio,
-				 struct page *page, unsigned len,
-				 unsigned offset, bool *same_page)
+static bool bvec_try_merge_hw_page(struct request_queue *q, struct bio_vec *bv,
+		struct page *page, unsigned len, unsigned offset,
+		bool *same_page)
 {
-	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 	unsigned long mask = queue_segment_boundary(q);
 	phys_addr_t addr1 = page_to_phys(bv->bv_page) + bv->bv_offset;
 	phys_addr_t addr2 = page_to_phys(page) + offset + len - 1;
@@ -967,8 +966,6 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		struct page *page, unsigned int len, unsigned int offset,
 		unsigned int max_sectors, bool *same_page)
 {
-	struct bio_vec *bvec;
-
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
@@ -976,7 +973,9 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		return 0;
 
 	if (bio->bi_vcnt > 0) {
-		if (bio_try_merge_hw_seg(q, bio, page, len, offset,
+		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		if (bvec_try_merge_hw_page(q, bv, page, len, offset,
 				same_page)) {
 			bio->bi_iter.bi_size += len;
 			return len;
@@ -986,8 +985,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		 * If the queue doesn't support SG gaps and adding this segment
 		 * would create a gap, disallow it.
 		 */
-		bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
-		if (bvec_gap_to_prev(&q->limits, bvec, offset))
+		if (bvec_gap_to_prev(&q->limits, bv, offset))
 			return 0;
 	}
 
-- 
2.40.1



