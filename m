Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B001170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF8DC433C9;
	Mon, 11 Sep 2023 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441191;
	bh=HyO3lJNzc+QKmbcQTg13xI9UuQ4qzAXEpnzUe6vOm2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSkUi8Mlz8E2IyNQoCgr7x7P2R5ZVUAJjd2DuZFtxvT5lalfqycKak3AJC5DjeTTK
	 KqmxbdW8wsNZKJb0X6vkN2L3GshkZ2zQkjtQPzhrsyaCCE89tELRKmOoaMrgPvfwlc
	 q6oBe6+ySubJu8n4K4etn3duS07DJK3ybFH9H16I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jinyoung Choi <j-young.choi@samsung.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 327/739] block: move the bi_vcnt check out of __bio_try_merge_page
Date: Mon, 11 Sep 2023 15:42:06 +0200
Message-ID: <20230911134700.234030987@linuxfoundation.org>
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

[ Upstream commit 0eca8b6f97ac705c5806f7d062207379094fb114 ]

Move the bi_vcnt out of __bio_try_merge_page and into the two callers
that don't already have it in preparation for additional changes to
__bio_try_merge_page.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jinyoung Choi <j-young.choi@samsung.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20230724165433.117645-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ece1d649b6d ("bio-integrity: create multi-page bvecs in bio_integrity_add_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index fa2d5b15fa0fd..4369c9a355c3c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -945,20 +945,17 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 static bool __bio_try_merge_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off, bool *same_page)
 {
-	if (bio->bi_vcnt > 0) {
-		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
-
-		if (page_is_mergeable(bv, page, len, off, same_page)) {
-			if (bio->bi_iter.bi_size > UINT_MAX - len) {
-				*same_page = false;
-				return false;
-			}
-			bv->bv_len += len;
-			bio->bi_iter.bi_size += len;
-			return true;
-		}
+	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+	if (!page_is_mergeable(bv, page, len, off, same_page))
+		return false;
+	if (bio->bi_iter.bi_size > UINT_MAX - len) {
+		*same_page = false;
+		return false;
 	}
-	return false;
+	bv->bv_len += len;
+	bio->bi_iter.bi_size += len;
+	return true;
 }
 
 /*
@@ -1129,11 +1126,13 @@ int bio_add_page(struct bio *bio, struct page *page,
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
-	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
-		if (bio_full(bio, len))
-			return 0;
-		__bio_add_page(bio, page, len, offset);
-	}
+	if (bio->bi_vcnt > 0 &&
+	    __bio_try_merge_page(bio, page, len, offset, &same_page))
+		return len;
+
+	if (bio_full(bio, len))
+		return 0;
+	__bio_add_page(bio, page, len, offset);
 	return len;
 }
 EXPORT_SYMBOL(bio_add_page);
@@ -1207,13 +1206,13 @@ static int bio_iov_add_page(struct bio *bio, struct page *page,
 {
 	bool same_page = false;
 
-	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
-		__bio_add_page(bio, page, len, offset);
+	if (bio->bi_vcnt > 0 &&
+	    __bio_try_merge_page(bio, page, len, offset, &same_page)) {
+		if (same_page)
+			bio_release_page(bio, page);
 		return 0;
 	}
-
-	if (same_page)
-		bio_release_page(bio, page);
+	__bio_add_page(bio, page, len, offset);
 	return 0;
 }
 
-- 
2.40.1



