Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00BC78F49;
	Mon,  6 Jan 2025 15:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177647; cv=none; b=h/VRivQZLVofscWgNhoBmPULo0QmuCXeIjgBjLLc+fbVMfaQ0HXihU3CD8dHuHsRQJkl04pcWgdNHUGssCoLdqG4c+zsrz59wYWlma9HhCF8xR+CsK3iRLb0Z2iApEm/VqffF5EBaYj3O8BJcj5gZSbu5kM9pDuvDwlI//ZlYRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177647; c=relaxed/simple;
	bh=J1PnFJhvVmrxFuZkTbz07xMLUyDAMArSwzKVNe3Zz6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuSRDFukWyDe9SaXGDX9+gQjdBmmRA3evg5Ip8xEUf0QGQ6DiTGvoHr2UIODIvpn80qXvx5eQk2bSYs5xBN+PGfqG0ms146OTbZxM2bHrpXy/z+lqtyfo+tcgEw4K9iWjfJd1FDSvTDoRfPeZj2Uk1cpYCKTFwiDzMMblascf9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdYTKzr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdYTKzr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65E2C4CED2;
	Mon,  6 Jan 2025 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177647;
	bh=J1PnFJhvVmrxFuZkTbz07xMLUyDAMArSwzKVNe3Zz6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdYTKzr30ftLjSqoFSLophiQ2xvB3WapO+afJA7rrgTCkQTsT8u215iJqsoDin/r8
	 Ahb7iBZUarePDaqAEC27pW1ua1JUsHQK2q9v/yEVlINo7L9XFIqXBYg/bZrH2szPax
	 0iUqpnU8Makgb/wWtNeKrqUjXhVOLVsDhzjIADSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/156] block: lift bio_is_zone_append to bio.h
Date: Mon,  6 Jan 2025 16:14:56 +0100
Message-ID: <20250106151142.132842011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0ef2b9e698dbf9ba78f67952a747f35eb7060470 ]

Make bio_is_zone_append globally available, because file systems need
to use to check for a zone append bio in their end_io handlers to deal
with the block layer emulation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20241104062647.91160-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 6c3864e05548 ("btrfs: use bio_is_zone_append() in the completion handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk.h         |  9 ---------
 include/linux/bio.h | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 88fab6a81701..1426f9c28197 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -469,11 +469,6 @@ static inline bool bio_zone_write_plugging(struct bio *bio)
 {
 	return bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
 }
-static inline bool bio_is_zone_append(struct bio *bio)
-{
-	return bio_op(bio) == REQ_OP_ZONE_APPEND ||
-		bio_flagged(bio, BIO_EMULATES_ZONE_APPEND);
-}
 void blk_zone_write_plug_bio_merged(struct bio *bio);
 void blk_zone_write_plug_init_request(struct request *rq);
 static inline void blk_zone_update_request_bio(struct request *rq,
@@ -522,10 +517,6 @@ static inline bool bio_zone_write_plugging(struct bio *bio)
 {
 	return false;
 }
-static inline bool bio_is_zone_append(struct bio *bio)
-{
-	return false;
-}
 static inline void blk_zone_write_plug_bio_merged(struct bio *bio)
 {
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index faceadb040f9..66b7620a1b53 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -677,6 +677,23 @@ static inline void bio_clear_polled(struct bio *bio)
 	bio->bi_opf &= ~REQ_POLLED;
 }
 
+/**
+ * bio_is_zone_append - is this a zone append bio?
+ * @bio:	bio to check
+ *
+ * Check if @bio is a zone append operation.  Core block layer code and end_io
+ * handlers must use this instead of an open coded REQ_OP_ZONE_APPEND check
+ * because the block layer can rewrite REQ_OP_ZONE_APPEND to REQ_OP_WRITE if
+ * it is not natively supported.
+ */
+static inline bool bio_is_zone_append(struct bio *bio)
+{
+	if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED))
+		return false;
+	return bio_op(bio) == REQ_OP_ZONE_APPEND ||
+		bio_flagged(bio, BIO_EMULATES_ZONE_APPEND);
+}
+
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp);
 struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new);
-- 
2.39.5



