Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249901170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49057C433C8;
	Mon, 11 Sep 2023 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441188;
	bh=bSPGdTjNUjuHh6+GSNxHxlj8cawtM4EWLf5cF95Vd2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEq24VqsOiiiRiAPiGuZYqaZU7fKIfygAb4a8oStc/1SlUj0Kf09WgeW5f7Hqd71F
	 D6VZTorBTioJQOnKawrGX36HvWq/bSObZfxXJjbU61nfZaluTa6pEDrRtrBkROST8r
	 e3tr1THHmUfPzbF2a9xFe/QzY9TIaDK/s99XW71E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jinyoung Choi <j-young.choi@samsung.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 326/739] block: move the BIO_CLONED checks out of __bio_try_merge_page
Date: Mon, 11 Sep 2023 15:42:05 +0200
Message-ID: <20230911134700.206190009@linuxfoundation.org>
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

[ Upstream commit 939e1a370330841b2c0292a483d7b38f3ee45f88 ]

__bio_try_merge_page is a way too low-level helper to assert that the
bio is not cloned.  Move the check into bio_add_page and
bio_iov_iter_get_pages instead, which are the high level entry points
that should enforce this variant.  bio_add_hw_page already this
check, coverig the third (indirect) caller of __bio_try_merge_page.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jinyoung Choi <j-young.choi@samsung.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20230724165433.117645-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ece1d649b6d ("bio-integrity: create multi-page bvecs in bio_integrity_add_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8672179213b93..fa2d5b15fa0fd 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -945,9 +945,6 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 static bool __bio_try_merge_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off, bool *same_page)
 {
-	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
-		return false;
-
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
@@ -1129,6 +1126,9 @@ int bio_add_page(struct bio *bio, struct page *page,
 {
 	bool same_page = false;
 
+	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
+		return 0;
+
 	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
 		if (bio_full(bio, len))
 			return 0;
@@ -1337,6 +1337,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
 	int ret = 0;
 
+	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
+		return -EIO;
+
 	if (iov_iter_is_bvec(iter)) {
 		bio_iov_bvec_set(bio, iter);
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
-- 
2.40.1



