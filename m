Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09575FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF58C433EF;
	Mon, 15 May 2023 17:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172039;
	bh=NlzS0RL4Pi630zBVYQ2TJU/HyJ13rISl9HPrJUmL5Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwORmxkWtU6TTemk2tTB2L2rmUBLDIFMgDzgkr6uYGDA+aaWWxisjCQI8G98R9sXX
	 gYt7Mr+604RdC7FWwS5IY8qRDK51FU8HS1d3QKR+hPV/LFQbGqmpu4UcUbkyWCNS6d
	 kRm30foFGNQ3GYNpncls8IsGa9M/mrmcyC2HXj0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Huckleberry <nhuck@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 024/381] blk-mq: release crypto keyslot before reporting I/O complete
Date: Mon, 15 May 2023 18:24:35 +0200
Message-Id: <20230515161737.873159364@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit 9cd1e566676bbcb8a126acd921e4e194e6339603 upstream.

Once all I/O using a blk_crypto_key has completed, filesystems can call
blk_crypto_evict_key().  However, the block layer currently doesn't call
blk_crypto_put_keyslot() until the request is being freed, which happens
after upper layers have been told (via bio_endio()) the I/O has
completed.  This causes a race condition where blk_crypto_evict_key()
can see 'slot_refs != 0' without there being an actual bug.

This makes __blk_crypto_evict_key() hit the
'WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)' and return without
doing anything, eventually causing a use-after-free in
blk_crypto_reprogram_all_keys().  (This is a very rare bug and has only
been seen when per-file keys are being used with fscrypt.)

There are two options to fix this: either release the keyslot before
bio_endio() is called on the request's last bio, or make
__blk_crypto_evict_key() ignore slot_refs.  Let's go with the first
solution, since it preserves the ability to report bugs (via
WARN_ON_ONCE) where a key is evicted while still in-use.

Fixes: a892c8d52c02 ("block: Inline encryption support for blk-mq")
Cc: stable@vger.kernel.org
Reviewed-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20230315183907.53675-2-ebiggers@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c            |    7 +++++++
 block/blk-crypto-internal.h |   25 +++++++++++++++++++++----
 block/blk-crypto.c          |   24 ++++++++++++------------
 block/blk-merge.c           |    2 ++
 block/blk-mq.c              |    2 +-
 5 files changed, 43 insertions(+), 17 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1444,6 +1444,13 @@ bool blk_update_request(struct request *
 		req->q->integrity.profile->complete_fn(req, nr_bytes);
 #endif
 
+	/*
+	 * Upper layers may call blk_crypto_evict_key() anytime after the last
+	 * bio_endio().  Therefore, the keyslot must be released before that.
+	 */
+	if (blk_crypto_rq_has_keyslot(req) && nr_bytes >= blk_rq_bytes(req))
+		__blk_crypto_rq_put_keyslot(req);
+
 	if (unlikely(error && !blk_rq_is_passthrough(req) &&
 		     !(req->rq_flags & RQF_QUIET)))
 		print_req_error(req, error, __func__);
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -60,6 +60,11 @@ static inline bool blk_crypto_rq_is_encr
 	return rq->crypt_ctx;
 }
 
+static inline bool blk_crypto_rq_has_keyslot(struct request *rq)
+{
+	return rq->crypt_keyslot;
+}
+
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 static inline bool bio_crypt_rq_ctx_compatible(struct request *rq,
@@ -93,6 +98,11 @@ static inline bool blk_crypto_rq_is_encr
 	return false;
 }
 
+static inline bool blk_crypto_rq_has_keyslot(struct request *rq)
+{
+	return false;
+}
+
 #endif /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 void __bio_crypt_advance(struct bio *bio, unsigned int bytes);
@@ -127,14 +137,21 @@ static inline bool blk_crypto_bio_prep(s
 	return true;
 }
 
-blk_status_t __blk_crypto_init_request(struct request *rq);
-static inline blk_status_t blk_crypto_init_request(struct request *rq)
+blk_status_t __blk_crypto_rq_get_keyslot(struct request *rq);
+static inline blk_status_t blk_crypto_rq_get_keyslot(struct request *rq)
 {
 	if (blk_crypto_rq_is_encrypted(rq))
-		return __blk_crypto_init_request(rq);
+		return __blk_crypto_rq_get_keyslot(rq);
 	return BLK_STS_OK;
 }
 
+void __blk_crypto_rq_put_keyslot(struct request *rq);
+static inline void blk_crypto_rq_put_keyslot(struct request *rq)
+{
+	if (blk_crypto_rq_has_keyslot(rq))
+		__blk_crypto_rq_put_keyslot(rq);
+}
+
 void __blk_crypto_free_request(struct request *rq);
 static inline void blk_crypto_free_request(struct request *rq)
 {
@@ -173,7 +190,7 @@ static inline blk_status_t blk_crypto_in
 {
 
 	if (blk_crypto_rq_is_encrypted(rq))
-		return blk_crypto_init_request(rq);
+		return blk_crypto_rq_get_keyslot(rq);
 	return BLK_STS_OK;
 }
 
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -216,26 +216,26 @@ static bool bio_crypt_check_alignment(st
 	return true;
 }
 
-blk_status_t __blk_crypto_init_request(struct request *rq)
+blk_status_t __blk_crypto_rq_get_keyslot(struct request *rq)
 {
 	return blk_ksm_get_slot_for_key(rq->q->ksm, rq->crypt_ctx->bc_key,
 					&rq->crypt_keyslot);
 }
 
-/**
- * __blk_crypto_free_request - Uninitialize the crypto fields of a request.
- *
- * @rq: The request whose crypto fields to uninitialize.
- *
- * Completely uninitializes the crypto fields of a request. If a keyslot has
- * been programmed into some inline encryption hardware, that keyslot is
- * released. The rq->crypt_ctx is also freed.
- */
-void __blk_crypto_free_request(struct request *rq)
+void __blk_crypto_rq_put_keyslot(struct request *rq)
 {
 	blk_ksm_put_slot(rq->crypt_keyslot);
+	rq->crypt_keyslot = NULL;
+}
+
+void __blk_crypto_free_request(struct request *rq)
+{
+	/* The keyslot, if one was needed, should have been released earlier. */
+	if (WARN_ON_ONCE(rq->crypt_keyslot))
+		__blk_crypto_rq_put_keyslot(rq);
+
 	mempool_free(rq->crypt_ctx, bio_crypt_ctx_pool);
-	blk_crypto_rq_set_defaults(rq);
+	rq->crypt_ctx = NULL;
 }
 
 /**
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -801,6 +801,8 @@ static struct request *attempt_merge(str
 	if (!blk_discard_mergable(req))
 		elv_merge_requests(q, req, next);
 
+	blk_crypto_rq_put_keyslot(next);
+
 	/*
 	 * 'next' is going away, so update stats accordingly
 	 */
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2193,7 +2193,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *b
 
 	blk_mq_bio_to_request(rq, bio, nr_segs);
 
-	ret = blk_crypto_init_request(rq);
+	ret = blk_crypto_rq_get_keyslot(rq);
 	if (ret != BLK_STS_OK) {
 		bio->bi_status = ret;
 		bio_endio(bio);


