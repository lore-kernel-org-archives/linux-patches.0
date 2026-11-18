Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019585;
	b=ZYaj7CWnRcLw3A2jof2+r+yqnnm39J9Y42r485oEaEJTGtB6r1fCx2nF+lpGlXopyVyP
	 6E/MAE7XKgZYPVh6RSD0uWpyJXDCguZ+AqwYzkY+0AmGhyb20fBEUOOuJ2v323Q9il+Bw
	 8bCqrVrcvvKtHANEbhbUBnvMvt0FDou1KsoG2xm2mNPKCB/YJQ9EQBi5gwX7kTLiPli63
	 DglG7t+5VtDHOJQ+STpvLiUwvHfSYurGUFmougRiCc/jmoRuim1v1UoJYVsyVi9AEN7/t
	 ssYaL7VfBBubCCu4ma+/nnXO4YsMFVNC/XKvRZ81riW5C1/yBMcmTXal882I9qWlI8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1cnRLLmjiqaef0bM1P/0uaj0gWf+MO6Q02IxhNgdoQw=;
	b=sehTaJk8TostzOpser3foOKAQlxu85nIP+u/euY/M1LjFMZZoYu9EbtyBLJ5yMDGKULd
	 yMWmYkv56lF21HQrruOOGAZjiCQDdVoVbrMSNs/so8wAwi1r3sOZm5PtA2Vlm/A7+/anM
	 QJuk0gS6MIWr9XFcg1NH2qiEHzcBb0J7W/8DpW4aJohhdfLDEpRtLJaltn5p3evA0YqQl
	 7YUSIqrr7I6S0bSjxmzdFC22SF0LVo3eUtRLQnF/JGeQQe5nnV4tjJQQh8H4fTkwVbH8R
	 lvi5/qncqSLWFnb0znSK1+V9vZpncFEwfQstocoDF3DOH0oQ6bHbbAwLEQO6DYU3tjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeXj31qj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E25606A33B;
	Wed, 18 Nov 2026 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeXj31qj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79381F000C7;
	Wed, 18 Nov 2026 16:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019585;
	bh=1cnRLLmjiqaef0bM1P/0uaj0gWf+MO6Q02IxhNgdoQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeXj31qjkOeeP9YHaH6lEbOm8FGWsytLmNvmNXNZBChcxKkyWTqBF8FQBTUViPxLJ
	 XFA3aVFIniNbIwDaZ9xmrC6dXRBmEofXWvd9m243JvgKEQSXZX4QvvIxiE4xKW52XT
	 V48aicEOj4bUarM+ACNk8MQcP2ow8fGaXmu8xzvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1647/2651] block: unpin all pages of a bvec in bio_iov_iter_align_down()
Date: Wed, 18 Nov 2026 15:48:07 +0100
Message-ID: <20261118150347.091026340@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit b91a661514f3a3ce5add42fc1f2eb17b61eacaca ]

bio_iov_iter_align_down() drops trailing bvecs with unpin_user_page(),
but a bvec built by iov_iter_extract_bvecs() can span several pages of
one folio, each with its own pin. All but the first pin leak.

The partially trimmed bvec has the same problem. Shrinking bv_len does
not release the pins for the pages cut off by the trim, and
__bio_release_pages() only unpins the pages bv_len still covers at
completion.

Both issues occur only with a logical block size above PAGE_SIZE and a
large folio backing the user buffer. On a device with a 64K logical
block size, an O_DIRECT pwritev() from a hugetlb mapping that ends 16K
past a block boundary leaks one huge page per call, whether the
remainder is its own bvec or the tail of a larger one.

Unpin all pages of a dropped bvec with bvec_unpin(), and unpin the
pages trimmed off the last bvec as well. Move bvec_unpin() up and split
its page count into a helper so both sites share it.

Fixes: 20a0e6276edb ("block: align the bio after building it")
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Link: https://patch.msgid.link/20261009-blkdev-fixes-v6-8-307939c387df@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0f1aa1d6c638a..d4ed8a135e8f6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1197,6 +1197,21 @@ bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter)
 	return true;
 }
 
+static unsigned int bvec_nr_pages(const struct bio_vec *bv)
+{
+	return (bv->bv_offset + bv->bv_len - 1) / PAGE_SIZE -
+		bv->bv_offset / PAGE_SIZE + 1;
+}
+
+static void bvec_unpin(struct bio_vec *bv, bool mark_dirty)
+{
+	struct folio *folio = bvec_folio(bv);
+
+	if (mark_dirty)
+		folio_mark_dirty_lock(folio);
+	unpin_user_folio(folio, bvec_nr_pages(bv));
+}
+
 /*
  * Aligns the bio size to the len_align_mask, releasing excessive bio vecs that
  * __bio_iov_iter_get_pages may have inserted, and reverts the trimmed length
@@ -1206,6 +1221,7 @@ static int bio_iov_iter_align_down(struct bio *bio, struct iov_iter *iter,
 				   struct bio_vec *bv, unsigned len_align_mask)
 {
 	size_t nbytes = bio->bi_iter.bi_size & len_align_mask;
+	unsigned int npages;
 
 	if (!nbytes)
 		return 0;
@@ -1214,14 +1230,24 @@ static int bio_iov_iter_align_down(struct bio *bio, struct iov_iter *iter,
 	bio->bi_iter.bi_size -= nbytes;
 	while (nbytes >= bv->bv_len) {
 		if (bio_flagged(bio, BIO_PAGE_PINNED))
-			unpin_user_page(bv->bv_page);
+			bvec_unpin(bv, false);
 
 		if (!--bio->bi_vcnt)
 			return -EFAULT;
 		nbytes -= bv->bv_len;
 		bv--;
 	}
+
+	/*
+	 * __bio_release_pages() only unpins the pages still covered by
+	 * the trimmed bv_len. Count the pages spanned before and after
+	 * the trim and unpin the difference.
+	 */
+	npages = bvec_nr_pages(bv);
 	bv->bv_len -= nbytes;
+	npages -= bvec_nr_pages(bv);
+	if (npages && bio_flagged(bio, BIO_PAGE_PINNED))
+		unpin_user_folio(bvec_folio(bv), npages);
 	return 0;
 }
 
@@ -1499,17 +1525,6 @@ int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
 	return bio_iov_iter_bounce_read(bio, iter, maxlen, minsize);
 }
 
-static void bvec_unpin(struct bio_vec *bv, bool mark_dirty)
-{
-	struct folio *folio = bvec_folio(bv);
-	size_t nr_pages = (bv->bv_offset + bv->bv_len - 1) / PAGE_SIZE -
-			bv->bv_offset / PAGE_SIZE + 1;
-
-	if (mark_dirty)
-		folio_mark_dirty_lock(folio);
-	unpin_user_folio(folio, nr_pages);
-}
-
 static void bio_iov_iter_unbounce_read(struct bio *bio, bool is_error,
 		bool mark_dirty)
 {
-- 
2.53.0



