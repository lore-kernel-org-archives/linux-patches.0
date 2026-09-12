Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466293002B3;
	Sat, 12 Sep 2026 10:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208734; cv=none; b=gxAawe9HGeYno+3gU+OceEjA3yrmaNLiPAzjRNsiqpZbGtEYEuyIeo3n58KEZxKE7i5N4JfqbSB01Vks7oW1qg0lxEEnNgei8k8XKbYHbOzwu6ApgZGmsQ4X/GjN6dkyDb+9HBqNV7KHooDEoCVUIfIYLm10nxkzfiGt8s2K0P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208734; c=relaxed/simple;
	bh=phZAkNJPN9V4K4HWBkf4nhzyiv1kuGC1ubLk8BxTNo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEVAKIp+0+eaOsSv1qa0XBoQlGMGdCBRBCT7YNo9lpfZ+kb0RkPbcUp9bnyD/MvK2O8QSxkE1POgRvr63r4e3ZyfQeIU5HmpX+fu2Cn6S4J9xE/UBe/DyWCBoP6WmZnDXNm6CetlRLVUhONmn/qmqC1kBAtF9D78pn0u5HsPeL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8qXFCM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8qXFCM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13871F000FF;
	Sat, 12 Sep 2026 10:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208733;
	bh=WtRjUs0x9NnVRvsFqWE2zBlAT7QHxk3lZ4MnfmnUYoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8qXFCM8F8gEaJ9525D7KkqvRcW/lYLG4VwVwxSjRD5sThS53SS5WBmbaZpq4qthM
	 oZ4HG2xoHGXYA+2dVQbUFriAHNTmEl9kty5I/7MSz2u8tJCrtbVf/sIoumYK5aojSl
	 N7LNyKwAW6ib2Q0gzXbI062BtnGULgRjA++gifeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0676/1518] blk-crypto: optimize bio splitting in blk_crypto_fallback_encrypt_bio
Date: Sat, 12 Sep 2026 08:47:25 +0200
Message-ID: <20260912065638.724481654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b37fbce460ad60b0c4449c1c7566cf24f3016713 ]

The current code in blk_crypto_fallback_encrypt_bio is inefficient and
prone to deadlocks under memory pressure: It first walks the passed in
plaintext bio to see how much of it can fit into a single encrypted
bio using up to BIO_MAX_VEC PAGE_SIZE segments, and then allocates a
plaintext clone that fits the size, only to allocate another bio for
the ciphertext later.  While the plaintext clone uses a bioset to avoid
deadlocks when allocations could fail, the ciphertex one uses bio_kmalloc
which is a no-go in the file system I/O path.

Switch blk_crypto_fallback_encrypt_bio to walk the source plaintext bio
while consuming bi_iter without cloning it, and instead allocate a
ciphertext bio at the beginning and whenever we fille up the previous
one.  The existing bio_set for the plaintext clones is reused for the
ciphertext bios to remove the deadlock risk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 702a2a9f3dfe ("block: fix dio leak on metadata mapping error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-crypto-fallback.c | 189 +++++++++++++++---------------------
 1 file changed, 80 insertions(+), 109 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index cc9e90be23b7f..4ec7da3422805 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -81,7 +81,7 @@ static struct blk_crypto_fallback_keyslot {
 static struct blk_crypto_profile *blk_crypto_fallback_profile;
 static struct workqueue_struct *blk_crypto_wq;
 static mempool_t *blk_crypto_bounce_page_pool;
-static struct bio_set crypto_bio_split;
+static struct bio_set enc_bio_set;
 
 /*
  * This is the key we set when evicting a keyslot. This *should* be the all 0's
@@ -150,37 +150,29 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 		mempool_free(enc_bio->bi_io_vec[i].bv_page,
 			     blk_crypto_bounce_page_pool);
 
-	src_bio->bi_status = enc_bio->bi_status;
+	if (enc_bio->bi_status)
+		cmpxchg(&src_bio->bi_status, 0, enc_bio->bi_status);
 
-	bio_uninit(enc_bio);
-	kfree(enc_bio);
+	bio_put(enc_bio);
 	bio_endio(src_bio);
 }
 
-static struct bio *blk_crypto_fallback_clone_bio(struct bio *bio_src)
+static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
+		unsigned int nr_segs)
 {
-	unsigned int nr_segs = bio_segments(bio_src);
-	struct bvec_iter iter;
-	struct bio_vec bv;
 	struct bio *bio;
 
-	bio = bio_kmalloc(nr_segs, GFP_NOIO);
-	if (!bio)
-		return NULL;
-	bio_init_inline(bio, bio_src->bi_bdev, nr_segs, bio_src->bi_opf);
+	bio = bio_alloc_bioset(bio_src->bi_bdev, nr_segs, bio_src->bi_opf,
+			GFP_NOIO, &enc_bio_set);
 	if (bio_flagged(bio_src, BIO_REMAPPED))
 		bio_set_flag(bio, BIO_REMAPPED);
+	bio->bi_private		= bio_src;
+	bio->bi_end_io		= blk_crypto_fallback_encrypt_endio;
 	bio->bi_ioprio		= bio_src->bi_ioprio;
 	bio->bi_write_hint	= bio_src->bi_write_hint;
 	bio->bi_write_stream	= bio_src->bi_write_stream;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
-	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
-
-	bio_for_each_segment(bv, bio_src, iter)
-		bio->bi_io_vec[bio->bi_vcnt++] = bv;
-
 	bio_clone_blkg_association(bio, bio_src);
-
 	return bio;
 }
 
@@ -208,32 +200,6 @@ blk_crypto_fallback_alloc_cipher_req(struct blk_crypto_keyslot *slot,
 	return true;
 }
 
-static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
-{
-	struct bio *bio = *bio_ptr;
-	unsigned int i = 0;
-	unsigned int num_sectors = 0;
-	struct bio_vec bv;
-	struct bvec_iter iter;
-
-	bio_for_each_segment(bv, bio, iter) {
-		num_sectors += bv.bv_len >> SECTOR_SHIFT;
-		if (++i == BIO_MAX_VECS)
-			break;
-	}
-
-	if (num_sectors < bio_sectors(bio)) {
-		bio = bio_submit_split_bioset(bio, num_sectors,
-					      &crypto_bio_split);
-		if (!bio)
-			return false;
-
-		*bio_ptr = bio;
-	}
-
-	return true;
-}
-
 union blk_crypto_iv {
 	__le64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 	u8 bytes[BLK_CRYPTO_MAX_IV_SIZE];
@@ -257,46 +223,35 @@ static void blk_crypto_dun_to_iv(const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
  */
 static void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
 {
-	struct bio *enc_bio;
-	struct bio_crypt_ctx *bc;
-	struct blk_crypto_keyslot *slot;
-	int data_unit_size;
+	struct bio_crypt_ctx *bc = src_bio->bi_crypt_context;
+	int data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
 	struct skcipher_request *ciph_req = NULL;
+	struct blk_crypto_keyslot *slot;
 	DECLARE_CRYPTO_WAIT(wait);
 	u64 curr_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 	struct scatterlist src, dst;
 	union blk_crypto_iv iv;
-	unsigned int i, j;
-	blk_status_t blk_st;
-
-	/* Split the bio if it's too big for single page bvec */
-	if (!blk_crypto_fallback_split_bio_if_needed(&src_bio))
-		goto out_endio;
-
-	bc = src_bio->bi_crypt_context;
-	data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
-
-	/* Allocate bounce bio for encryption */
-	enc_bio = blk_crypto_fallback_clone_bio(src_bio);
-	if (!enc_bio) {
-		src_bio->bi_status = BLK_STS_RESOURCE;
-		goto out_endio;
-	}
+	unsigned int nr_enc_pages, enc_idx;
+	struct bio *enc_bio;
+	blk_status_t status;
+	unsigned int i;
 
 	/*
 	 * Get a blk-crypto-fallback keyslot that contains a crypto_skcipher for
 	 * this bio's algorithm and key.
 	 */
-	blk_st = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
+	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
 					bc->bc_key, &slot);
-	if (blk_st != BLK_STS_OK) {
-		src_bio->bi_status = blk_st;
-		goto out_put_enc_bio;
+	if (status != BLK_STS_OK) {
+		src_bio->bi_status = status;
+		bio_endio(src_bio);
+		return;
 	}
 
 	/* and then allocate an skcipher_request for it */
 	if (!blk_crypto_fallback_alloc_cipher_req(slot, &ciph_req, &wait)) {
 		src_bio->bi_status = BLK_STS_RESOURCE;
+		bio_endio(src_bio);
 		goto out_release_keyslot;
 	}
 
@@ -307,59 +262,75 @@ static void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
 	skcipher_request_set_crypt(ciph_req, &src, &dst, data_unit_size,
 				   iv.bytes);
 
-	/* Encrypt each page in the bounce bio */
-	for (i = 0; i < enc_bio->bi_vcnt; i++) {
-		struct bio_vec *enc_bvec = &enc_bio->bi_io_vec[i];
-		struct page *plaintext_page = enc_bvec->bv_page;
-		struct page *ciphertext_page =
-			mempool_alloc(blk_crypto_bounce_page_pool, GFP_NOIO);
-
-		enc_bvec->bv_page = ciphertext_page;
-
-		if (!ciphertext_page) {
-			src_bio->bi_status = BLK_STS_RESOURCE;
-			goto out_free_bounce_pages;
-		}
-
-		sg_set_page(&src, plaintext_page, data_unit_size,
-			    enc_bvec->bv_offset);
-		sg_set_page(&dst, ciphertext_page, data_unit_size,
-			    enc_bvec->bv_offset);
-
-		/* Encrypt each data unit in this page */
-		for (j = 0; j < enc_bvec->bv_len; j += data_unit_size) {
+	/*
+	 * Encrypt each page in the source bio.  Because the source bio could
+	 * have bio_vecs that span more than a single page, but the encrypted
+	 * bios are limited to a single page per bio_vec, this can generate
+	 * more than a single encrypted bio per source bio.
+	 */
+new_bio:
+	nr_enc_pages = min(bio_segments(src_bio), BIO_MAX_VECS);
+	enc_bio = blk_crypto_alloc_enc_bio(src_bio, nr_enc_pages);
+	enc_idx = 0;
+	for (;;) {
+		struct bio_vec src_bv =
+			bio_iter_iovec(src_bio, src_bio->bi_iter);
+		struct page *enc_page;
+
+		enc_page = mempool_alloc(blk_crypto_bounce_page_pool,
+				GFP_NOIO);
+		__bio_add_page(enc_bio, enc_page, src_bv.bv_len,
+				src_bv.bv_offset);
+
+		sg_set_page(&src, src_bv.bv_page, data_unit_size,
+			    src_bv.bv_offset);
+		sg_set_page(&dst, enc_page, data_unit_size, src_bv.bv_offset);
+
+		/*
+		 * Increment the index now that the encrypted page is added to
+		 * the bio.  This is important for the error unwind path.
+		 */
+		enc_idx++;
+
+		/*
+		 * Encrypt each data unit in this page.
+		 */
+		for (i = 0; i < src_bv.bv_len; i += data_unit_size) {
 			blk_crypto_dun_to_iv(curr_dun, &iv);
 			if (crypto_wait_req(crypto_skcipher_encrypt(ciph_req),
 					    &wait)) {
-				i++;
-				src_bio->bi_status = BLK_STS_IOERR;
-				goto out_free_bounce_pages;
+				bio_io_error(enc_bio);
+				goto out_free_request;
 			}
 			bio_crypt_dun_increment(curr_dun, 1);
 			src.offset += data_unit_size;
 			dst.offset += data_unit_size;
 		}
+
+		bio_advance_iter_single(src_bio, &src_bio->bi_iter,
+				src_bv.bv_len);
+		if (!src_bio->bi_iter.bi_size)
+			break;
+
+		if (enc_idx == nr_enc_pages) {
+			/*
+			 * For each additional encrypted bio submitted,
+			 * increment the source bio's remaining count.  Each
+			 * encrypted bio's completion handler calls bio_endio on
+			 * the source bio, so this keeps the source bio from
+			 * completing until the last encrypted bio does.
+			 */
+			bio_inc_remaining(src_bio);
+			submit_bio(enc_bio);
+			goto new_bio;
+		}
 	}
 
-	enc_bio->bi_private = src_bio;
-	enc_bio->bi_end_io = blk_crypto_fallback_encrypt_endio;
-	skcipher_request_free(ciph_req);
-	blk_crypto_put_keyslot(slot);
 	submit_bio(enc_bio);
-	return;
-
-out_free_bounce_pages:
-	while (i > 0)
-		mempool_free(enc_bio->bi_io_vec[--i].bv_page,
-			     blk_crypto_bounce_page_pool);
+out_free_request:
 	skcipher_request_free(ciph_req);
 out_release_keyslot:
 	blk_crypto_put_keyslot(slot);
-out_put_enc_bio:
-	bio_uninit(enc_bio);
-	kfree(enc_bio);
-out_endio:
-	bio_endio(src_bio);
 }
 
 /*
@@ -533,7 +504,7 @@ static int blk_crypto_fallback_init(void)
 
 	get_random_bytes(blank_key, sizeof(blank_key));
 
-	err = bioset_init(&crypto_bio_split, 64, 0, 0);
+	err = bioset_init(&enc_bio_set, 64, 0, BIOSET_NEED_BVECS);
 	if (err)
 		goto out;
 
@@ -603,7 +574,7 @@ static int blk_crypto_fallback_init(void)
 fail_free_profile:
 	kfree(blk_crypto_fallback_profile);
 fail_free_bioset:
-	bioset_exit(&crypto_bio_split);
+	bioset_exit(&enc_bio_set);
 out:
 	return err;
 }
-- 
2.53.0



