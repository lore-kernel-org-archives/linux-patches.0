Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9C37B3F7;
	Sat, 12 Sep 2026 10:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208748; cv=none; b=DY0OC4V0ovUXN1ZbDMrH9whiw1BWtQ3r2m6H9cr8KXvY/gizo6utOv2L2hDRtDT1EpLKALLoT5lMWpLOWnbw9PyeonvN09fAi3ctz43cnhd1vieynLjbyazYWyJ9ouV8EL+Tkv0+bxh3WFaoGgxUwrWJSFRueQPqkei6B1n6juc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208748; c=relaxed/simple;
	bh=DVI8wOXDTocE7l5PpjeDm931ovZccpMszEJMcOAxhLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp0t5cfDnmTf9OC5xtO7YtPB1EAytyfpuFIKoE+etKQBYw7SG6e0tWbXue9jbwHOyutVwXKoQoQ09VV+fmLz7m9SEeCcDQ/xCq26B7jRGX9PjeGO5ED9yZlTXcckoWRfTywt/clWJWYtGjeCZEh9w9981FE+/j3goQnPZy96xHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaNizNFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaNizNFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951F21F000FF;
	Sat, 12 Sep 2026 10:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208746;
	bh=4R8kkUC/67HB3cVhWWTGf8TeFg7P3OSfAcQ1p0b1pXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaNizNFsiw6fGxCjcgR6JU6xo7IHINCVhEo9awZ2nA0BGNbUKSDLjkaR60/NafNCt
	 z2IP0rvnIWYUYz1apCXTxlvuLvn1nodJUYif3lk8cyS/bMNmqILWPJ1s0h7kWDZH/E
	 OaSLl7PVYT8TuBNrUW4vjWDr0upVvm+LTmA7jKas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Md Haris Iqbal <haris.iqbal@linux.dev>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0679/1518] block: add a bio_endio_status helper
Date: Sat, 12 Sep 2026 08:47:28 +0200
Message-ID: <20260912065638.793199448@linuxfoundation.org>
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

[ Upstream commit a7d8eaee7fafe2e2c58aef9579bdef778c144029 ]

Add a helper that sets bi_status and call bio_endio() as that is a very
common pattern and convert the core block code over to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Md Haris Iqbal <haris.iqbal@linux.dev>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260528084632.2505277-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 702a2a9f3dfe ("block: fix dio leak on metadata mapping error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c            | 11 ++++-------
 block/blk-crypto-fallback.c |  9 +++------
 block/blk-crypto.c          |  3 +--
 block/blk-merge.c           |  6 ++----
 block/blk-mq.c              |  6 ++----
 block/fops.c                |  3 +--
 include/linux/bio.h         | 19 +++++++++++++++----
 7 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index db8b5100c483d..c2300b201d4ff 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -639,12 +639,10 @@ static void __submit_bio(struct bio *bio)
 		struct gendisk *disk = bio->bi_bdev->bd_disk;
 	
 		if ((bio->bi_opf & REQ_POLLED) &&
-		    !(disk->queue->limits.features & BLK_FEAT_POLL)) {
-			bio->bi_status = BLK_STS_NOTSUPP;
-			bio_endio(bio);
-		} else {
+		    !(disk->queue->limits.features & BLK_FEAT_POLL))
+			bio_endio_status(bio, BLK_STS_NOTSUPP);
+		else
 			disk->fops->submit_bio(bio);
-		}
 		blk_queue_exit(disk->queue);
 	}
 
@@ -882,8 +880,7 @@ void submit_bio_noacct(struct bio *bio)
 not_supported:
 	status = BLK_STS_NOTSUPP;
 end_io:
-	bio->bi_status = status;
-	bio_endio(bio);
+	bio_endio_status(bio, status);
 }
 EXPORT_SYMBOL(submit_bio_noacct);
 
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 4a682230c2783..f523b0cf143af 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -305,8 +305,7 @@ static void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
 	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
 					bc->bc_key, &slot);
 	if (status != BLK_STS_OK) {
-		src_bio->bi_status = status;
-		bio_endio(src_bio);
+		bio_endio_status(src_bio, status);
 		return;
 	}
 	__blk_crypto_fallback_encrypt_bio(src_bio,
@@ -378,8 +377,7 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	}
 	mempool_free(f_ctx, bio_fallback_crypt_ctx_pool);
 
-	bio->bi_status = status;
-	bio_endio(bio);
+	bio_endio_status(bio, status);
 }
 
 /**
@@ -440,8 +438,7 @@ bool blk_crypto_fallback_bio_prep(struct bio *bio)
 
 	if (!__blk_crypto_cfg_supported(blk_crypto_fallback_profile,
 					&bc->bc_key->crypto_cfg)) {
-		bio->bi_status = BLK_STS_NOTSUPP;
-		bio_endio(bio);
+		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		return false;
 	}
 
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 69e869d1c9bd8..9792e7273110b 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -301,8 +301,7 @@ bool __blk_crypto_bio_prep(struct bio *bio)
 		if (!IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)) {
 			pr_warn_once("%pg: crypto API fallback disabled; failing request.\n",
 				bdev);
-			bio->bi_status = BLK_STS_NOTSUPP;
-			bio_endio(bio);
+			bio_endio_status(bio, BLK_STS_NOTSUPP);
 			return false;
 		}
 		return blk_crypto_fallback_bio_prep(bio);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 03b61923cf109..7b984e01f7be7 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -122,8 +122,7 @@ struct bio *bio_submit_split_bioset(struct bio *bio, unsigned int split_sectors,
 	struct bio *split = bio_split(bio, split_sectors, GFP_NOIO, bs);
 
 	if (IS_ERR(split)) {
-		bio->bi_status = errno_to_blk_status(PTR_ERR(split));
-		bio_endio(bio);
+		bio_endio_status(bio, errno_to_blk_status(PTR_ERR(split)));
 		return NULL;
 	}
 
@@ -143,8 +142,7 @@ EXPORT_SYMBOL_GPL(bio_submit_split_bioset);
 static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 {
 	if (unlikely(split_sectors < 0)) {
-		bio->bi_status = errno_to_blk_status(split_sectors);
-		bio_endio(bio);
+		bio_endio_status(bio, errno_to_blk_status(split_sectors));
 		return NULL;
 	}
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 56158b70d0c72..6b4643a279dbf 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3149,8 +3149,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	}
 
 	if ((bio->bi_opf & REQ_POLLED) && !blk_mq_can_poll(q)) {
-		bio->bi_status = BLK_STS_NOTSUPP;
-		bio_endio(bio);
+		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		goto queue_exit;
 	}
 
@@ -3193,8 +3192,7 @@ void blk_mq_submit_bio(struct bio *bio)
 
 	ret = blk_crypto_rq_get_keyslot(rq);
 	if (ret != BLK_STS_OK) {
-		bio->bi_status = ret;
-		bio_endio(bio);
+		bio_endio_status(bio, ret);
 		blk_mq_free_request(rq);
 		return;
 	}
diff --git a/block/fops.c b/block/fops.c
index 5e3db9fead77c..56ade36fb6564 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -221,8 +221,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
 		if (unlikely(ret)) {
-			bio->bi_status = BLK_STS_IOERR;
-			bio_endio(bio);
+			bio_endio_status(bio, BLK_STS_IOERR);
 			break;
 		}
 		if (iocb->ki_flags & IOCB_NOWAIT) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 257ff84dbd56b..eb60727fd21e8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -376,16 +376,27 @@ void submit_bio(struct bio *bio);
 
 extern void bio_endio(struct bio *);
 
-static inline void bio_io_error(struct bio *bio)
+/**
+ * bio_endio_status - end I/O on a bio with a specific status
+ * @bio:	bio
+ * @status:	status to set
+ *
+ * Set @bio->bi_status to @status and call bio_endio().
+ **/
+static inline void bio_endio_status(struct bio *bio, blk_status_t status)
 {
-	bio->bi_status = BLK_STS_IOERR;
+	bio->bi_status = status;
 	bio_endio(bio);
 }
 
+static inline void bio_io_error(struct bio *bio)
+{
+	bio_endio_status(bio, BLK_STS_IOERR);
+}
+
 static inline void bio_wouldblock_error(struct bio *bio)
 {
-	bio->bi_status = BLK_STS_AGAIN;
-	bio_endio(bio);
+	bio_endio_status(bio, BLK_STS_AGAIN);
 }
 
 /*
-- 
2.53.0



