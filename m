Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667E32AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37FCC433C9;
	Wed, 20 Sep 2023 11:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211063;
	bh=PVBvjKyV50B3tuc3sJt/MadM3/vKZ1NRG1FWiWR64x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKnMpIHS19zxV5k6TiOIa1gvuJURsB7oz86VjzkzM8X7+wkJFhPRFdmOeiMRX0/Mm
	 mc6Y5qDdOKXL5xkWFa0F1F3QUFjov1uM0enO8j6F2AsIfUj/yQyhbFt0+HPhb55izE
	 7rlLsmg/1CkREimlrKTV8JNJfa9YScV3/QBYwZp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/139] block: factor out a bvec_set_page helper
Date: Wed, 20 Sep 2023 13:30:28 +0200
Message-ID: <20230920112839.110444048@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d58cdfae6a22e5079656c487aad669597a0635c8 ]

Add a helper to initialize a bvec based of a page pointer.  This will help
removing various open code bvec initializations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20230203150634.3199647-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 1f0bbf28940c ("nvmet-tcp: pass iov_len instead of sg->length to bvec_set_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c |  7 +------
 block/bio.c           | 12 ++----------
 include/linux/bvec.h  | 15 +++++++++++++++
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 91ffee6fc8cb4..4533eb4916610 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -124,23 +124,18 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 			   unsigned int len, unsigned int offset)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	struct bio_vec *iv;
 
 	if (bip->bip_vcnt >= bip->bip_max_vcnt) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}
 
-	iv = bip->bip_vec + bip->bip_vcnt;
-
 	if (bip->bip_vcnt &&
 	    bvec_gap_to_prev(&bdev_get_queue(bio->bi_bdev)->limits,
 			     &bip->bip_vec[bip->bip_vcnt - 1], offset))
 		return 0;
 
-	iv->bv_page = page;
-	iv->bv_len = len;
-	iv->bv_offset = offset;
+	bvec_set_page(&bip->bip_vec[bip->bip_vcnt], page, len, offset);
 	bip->bip_vcnt++;
 
 	return len;
diff --git a/block/bio.c b/block/bio.c
index d5cd825d6efc0..9ec72a78f1149 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -976,10 +976,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 	if (bio->bi_vcnt >= queue_max_segments(q))
 		return 0;
 
-	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
-	bvec->bv_len = len;
-	bvec->bv_offset = offset;
+	bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt], page, len, offset);
 	bio->bi_vcnt++;
 	bio->bi_iter.bi_size += len;
 	return len;
@@ -1055,15 +1052,10 @@ EXPORT_SYMBOL_GPL(bio_add_zone_append_page);
 void __bio_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off)
 {
-	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
-
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
 	WARN_ON_ONCE(bio_full(bio, len));
 
-	bv->bv_page = page;
-	bv->bv_offset = off;
-	bv->bv_len = len;
-
+	bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt], page, len, off);
 	bio->bi_iter.bi_size += len;
 	bio->bi_vcnt++;
 }
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 35c25dff651a5..9e3dac51eb26b 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -35,6 +35,21 @@ struct bio_vec {
 	unsigned int	bv_offset;
 };
 
+/**
+ * bvec_set_page - initialize a bvec based off a struct page
+ * @bv:		bvec to initialize
+ * @page:	page the bvec should point to
+ * @len:	length of the bvec
+ * @offset:	offset into the page
+ */
+static inline void bvec_set_page(struct bio_vec *bv, struct page *page,
+		unsigned int len, unsigned int offset)
+{
+	bv->bv_page = page;
+	bv->bv_len = len;
+	bv->bv_offset = offset;
+}
+
 struct bvec_iter {
 	sector_t		bi_sector;	/* device address in 512 byte
 						   sectors */
-- 
2.40.1



