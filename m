Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CBF1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05658C433C7;
	Mon, 11 Sep 2023 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441194;
	bh=mreJ62WD1SOXlrqdhrFWHAivBuaeVc6Wfj9oUjEA4LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQeYL3KXmip5SpAE5vD+El2D/mCv3Av29W6Zvh77qrDRghxYKvBhR980hkwg6K0tW
	 6GMerNJFTVIz/TyTVsSHfbeGHiSZBqGZyQMQkNLUTGRVdbIWRElHvQyuNIxglSyJ3l
	 ju0jJbXEBUk/OMGagvZmHdhLF+3HM0OagOBqUeO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jinyoung Choi <j-young.choi@samsung.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 328/739] block: move the bi_size overflow check in __bio_try_merge_page
Date: Mon, 11 Sep 2023 15:42:07 +0200
Message-ID: <20230911134700.261573529@linuxfoundation.org>
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

[ Upstream commit 613699050a49760f1d70c74f71bd0b013ca3c356 ]

Checking for availability in bi_size in a function that attempts to
merge into an existing segment is a bit odd, as the limit also applies
when adding a new segment.  This code works fine as we always call
__bio_try_merge_page, but contributes to sub-optimal calling conventions
and doesn't lead to clear code.

Move it to two of the callers instead, the third one already has a more
strict check that includes max_hw_segments anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jinyoung Choi <j-young.choi@samsung.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20230724165433.117645-6-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ece1d649b6d ("bio-integrity: create multi-page bvecs in bio_integrity_add_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4369c9a355c3c..b9b8328d1bc82 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -949,10 +949,6 @@ static bool __bio_try_merge_page(struct bio *bio, struct page *page,
 
 	if (!page_is_mergeable(bv, page, len, off, same_page))
 		return false;
-	if (bio->bi_iter.bi_size > UINT_MAX - len) {
-		*same_page = false;
-		return false;
-	}
 	bv->bv_len += len;
 	bio->bi_iter.bi_size += len;
 	return true;
@@ -1125,6 +1121,8 @@ int bio_add_page(struct bio *bio, struct page *page,
 
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return 0;
+	if (bio->bi_iter.bi_size > UINT_MAX - len)
+		return 0;
 
 	if (bio->bi_vcnt > 0 &&
 	    __bio_try_merge_page(bio, page, len, offset, &same_page))
@@ -1206,6 +1204,9 @@ static int bio_iov_add_page(struct bio *bio, struct page *page,
 {
 	bool same_page = false;
 
+	if (WARN_ON_ONCE(bio->bi_iter.bi_size > UINT_MAX - len))
+		return -EIO;
+
 	if (bio->bi_vcnt > 0 &&
 	    __bio_try_merge_page(bio, page, len, offset, &same_page)) {
 		if (same_page)
-- 
2.40.1



