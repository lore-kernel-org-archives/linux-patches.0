Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C53130C622;
	Mon, 13 Oct 2025 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369087; cv=none; b=CSzqIR+CgnFakwBPoq1nHRSc0nj6gU5eSL5vEbIvEpgfTJQFHH0kU1TCmkshhihQjOd7wF10SLP6tmv8Hv9Nm1y20sFG08GewvloAxz8dpGzSFHIF3XWmPBjJkXesfttHoXhPPBx+jwtSN1ZjXCwCp6L8upGpXsY/b3lE0Qk5ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369087; c=relaxed/simple;
	bh=2f1a2X+XCNaQowmWC82F1b72BnixKT8bb0dmE4YP8Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgPRaVDWR2h2PV4Pe0/7z5FffswtTDNYkWikaOR/hQiICToKeTWTLqlmqy0S2ylvFx1ypco8RI07SZK55ldBkoqUUMw1u5V92D/hIKYzGksJPk9Sqp508ACFPvcaotg5BcNd+T7K1oADXcvPGRicJ4FzgsWuETHmGBx75ByEVqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psHkRfuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psHkRfuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A3AC4CEE7;
	Mon, 13 Oct 2025 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369087;
	bh=2f1a2X+XCNaQowmWC82F1b72BnixKT8bb0dmE4YP8Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psHkRfuDL+bglmmqWeOKKX3+xQpbmmS1YtdkB7thZB8EQY59KX3VBNEFK/WIdY2eN
	 i5AAdl3C5h2j9YGfhAl5AztDc2PO7qCRbaKTIukMVHGBlMyJMv+OOUClZJ+c86XfvN
	 mYbG56cK/0QpyRqNr7Fq7gOdMoDio62Khmx1mX60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 122/563] block: factor out a helper bio_submit_split_bioset()
Date: Mon, 13 Oct 2025 16:39:43 +0200
Message-ID: <20251013144415.713568438@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e37b5596a19be9a150cb194ec32e78f295a3574b ]

No functional changes are intended, some drivers like mdraid will split
bio by internal processing, prepare to unify bio split codes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b2f5974079d8 ("block: fix ordering of recursive split IO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c      | 59 ++++++++++++++++++++++++++++--------------
 include/linux/blkdev.h |  2 ++
 2 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5538356770a47..51fe4ed5b7c0b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -104,33 +104,54 @@ static unsigned int bio_allowed_max_sectors(const struct queue_limits *lim)
 	return round_down(UINT_MAX, lim->logical_block_size) >> SECTOR_SHIFT;
 }
 
+/*
+ * bio_submit_split_bioset - Submit a bio, splitting it at a designated sector
+ * @bio:		the original bio to be submitted and split
+ * @split_sectors:	the sector count at which to split
+ * @bs:			the bio set used for allocating the new split bio
+ *
+ * The original bio is modified to contain the remaining sectors and submitted.
+ * The caller is responsible for submitting the returned bio.
+ *
+ * If succeed, the newly allocated bio representing the initial part will be
+ * returned, on failure NULL will be returned and original bio will fail.
+ */
+struct bio *bio_submit_split_bioset(struct bio *bio, unsigned int split_sectors,
+				    struct bio_set *bs)
+{
+	struct bio *split = bio_split(bio, split_sectors, GFP_NOIO, bs);
+
+	if (IS_ERR(split)) {
+		bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+		bio_endio(bio);
+		return NULL;
+	}
+
+	bio_chain(split, bio);
+	trace_block_split(split, bio->bi_iter.bi_sector);
+	WARN_ON_ONCE(bio_zone_write_plugging(bio));
+	submit_bio_noacct(bio);
+
+	return split;
+}
+EXPORT_SYMBOL_GPL(bio_submit_split_bioset);
+
 static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 {
-	if (unlikely(split_sectors < 0))
-		goto error;
+	if (unlikely(split_sectors < 0)) {
+		bio->bi_status = errno_to_blk_status(split_sectors);
+		bio_endio(bio);
+		return NULL;
+	}
 
 	if (split_sectors) {
-		struct bio *split;
-
-		split = bio_split(bio, split_sectors, GFP_NOIO,
+		bio = bio_submit_split_bioset(bio, split_sectors,
 				&bio->bi_bdev->bd_disk->bio_split);
-		if (IS_ERR(split)) {
-			split_sectors = PTR_ERR(split);
-			goto error;
-		}
-		split->bi_opf |= REQ_NOMERGE;
-		bio_chain(split, bio);
-		trace_block_split(split, bio->bi_iter.bi_sector);
-		WARN_ON_ONCE(bio_zone_write_plugging(bio));
-		submit_bio_noacct(bio);
-		return split;
+		if (bio)
+			bio->bi_opf |= REQ_NOMERGE;
 	}
 
 	return bio;
-error:
-	bio->bi_status = errno_to_blk_status(split_sectors);
-	bio_endio(bio);
-	return NULL;
 }
 
 struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fe1797bbec420..cc221318712e7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -999,6 +999,8 @@ extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 void submit_bio_noacct(struct bio *bio);
 struct bio *bio_split_to_limits(struct bio *bio);
+struct bio *bio_submit_split_bioset(struct bio *bio, unsigned int split_sectors,
+				    struct bio_set *bs);
 
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags);
-- 
2.51.0



