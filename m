Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D758D184540;
	Tue, 26 Aug 2025 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213686; cv=none; b=aCwXNp1IrKKBGeM5BYP/hkh5trUN78/rX8uQ5z8KX2p0/LPbWztOUTvfEWw/xMYlLgArPF1ORv65G+vYopMGi+Dv2EsYyKM/jRyJ83PMDwRYhKwllDZ1p5dcCoLsOeCP2QRodKjHykMV7oESxJuQ7rNOLdecwVy7YM4ytDD25zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213686; c=relaxed/simple;
	bh=TkFN7YOhjBMXWYIjaHc0BGpN60VPnc30rhAtHk1ddqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQIgcGdpsswny/A4msKzagOo+7KD0epn4ivtTeKPyNXShM0+X4t/tBKORLnzj9gds/isobluBgdWCNBNlDjUq2JTx2FkO6GF6aw41iGOCBb9rw1iJvsvH3XDScxZRBr7bs6oWen06fperOneDEmE6aeKXkxGY/6xvlr9PV/MU8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlPLWKEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlPLWKEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11049C4CEF1;
	Tue, 26 Aug 2025 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213686;
	bh=TkFN7YOhjBMXWYIjaHc0BGpN60VPnc30rhAtHk1ddqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlPLWKEWa0PyTZ4MiZ6XG+7k40PyweiVvcxEmPbMOtgpfCvKmTy4Ai3JlVt/oucuT
	 09MEEfLrdjf7O84JgAdy4HxRDPozUV6fAdyQTmKz0qCrCLoeMhVMMA2OyCPNvqMX+M
	 0J7kjLHWIVMKEKD0gBfDsfdBa0YNpA9c0cQLmdVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 440/587] block: reject invalid operation in submit_bio_noacct
Date: Tue, 26 Aug 2025 13:09:49 +0200
Message-ID: <20250826111004.148818222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1c042f8d4bc342b7985b1de3d76836f1a1083b65 ]

submit_bio_noacct allows completely invalid operations, or operations
that are not supported in the bio path.  Extent the existing switch
statement to rejcect all invalid types.

Move the code point for REQ_OP_ZONE_APPEND so that it's not right in the
middle of the zone management operations and the switch statement can
follow the numerical order of the operations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231221070538.1112446-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3f66ccbaaef3 ("block: Make REQ_OP_ZONE_FINISH a write operation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c          |   26 +++++++++++++++++++++-----
 include/linux/blk_types.h |    8 ++++----
 2 files changed, 25 insertions(+), 9 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -775,6 +775,15 @@ void submit_bio_noacct(struct bio *bio)
 		bio_clear_polled(bio);
 
 	switch (bio_op(bio)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+		break;
+	case REQ_OP_FLUSH:
+		/*
+		 * REQ_OP_FLUSH can't be submitted through bios, it is only
+		 * synthetized in struct request by the flush state machine.
+		 */
+		goto not_supported;
 	case REQ_OP_DISCARD:
 		if (!bdev_max_discard_sectors(bdev))
 			goto not_supported;
@@ -788,6 +797,10 @@ void submit_bio_noacct(struct bio *bio)
 		if (status != BLK_STS_OK)
 			goto end_io;
 		break;
+	case REQ_OP_WRITE_ZEROES:
+		if (!q->limits.max_write_zeroes_sectors)
+			goto not_supported;
+		break;
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
@@ -799,12 +812,15 @@ void submit_bio_noacct(struct bio *bio)
 		if (!bdev_is_zoned(bio->bi_bdev) || !blk_queue_zone_resetall(q))
 			goto not_supported;
 		break;
-	case REQ_OP_WRITE_ZEROES:
-		if (!q->limits.max_write_zeroes_sectors)
-			goto not_supported;
-		break;
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
+		/*
+		 * Driver private operations are only used with passthrough
+		 * requests.
+		 */
+		fallthrough;
 	default:
-		break;
+		goto not_supported;
 	}
 
 	if (blk_throtl_bio(bio))
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -379,6 +379,8 @@ enum req_op {
 	REQ_OP_DISCARD		= (__force blk_opf_t)3,
 	/* securely erase sectors */
 	REQ_OP_SECURE_ERASE	= (__force blk_opf_t)5,
+	/* write data at the current zone write pointer */
+	REQ_OP_ZONE_APPEND	= (__force blk_opf_t)7,
 	/* write the zero filled sector many times */
 	REQ_OP_WRITE_ZEROES	= (__force blk_opf_t)9,
 	/* Open a zone */
@@ -387,12 +389,10 @@ enum req_op {
 	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)11,
 	/* Transition a zone to full */
 	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)12,
-	/* write data at the current zone write pointer */
-	REQ_OP_ZONE_APPEND	= (__force blk_opf_t)13,
 	/* reset a zone write pointer */
-	REQ_OP_ZONE_RESET	= (__force blk_opf_t)15,
+	REQ_OP_ZONE_RESET	= (__force blk_opf_t)13,
 	/* reset all the zone present on the device */
-	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
+	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)15,
 
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= (__force blk_opf_t)34,


