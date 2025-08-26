Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B276E30AAD8;
	Tue, 26 Aug 2025 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215098; cv=none; b=r4RR4VeAfAQec+DV6O6U+rYJcJcM3/nuHzcVJXpqbdorJhBgqGWhRkcsELeFcKLZOu5EQg8TQ+ZXvNiYeha8+QU9aMgKZGuEtT5OVx2ayGzM0ImluYspVPBDgBfmlRyuduIfRxP++oWZ7iJsFbFKtSJpmMHI3CIp2XmnhC+VQKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215098; c=relaxed/simple;
	bh=0gkdsYPfGYclXAlNfIRapktOZGcLqQeSD/0MT6A2e/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cu+2QKXAxlqmImiZ3owns4TVoxfJgYygQZvBoWW9UVFobhfqPXZIZCeeNWtbm3J4vzs9FrLp6Qob7ySnQJBI23TeFjBc3nLPSenBkxlBOInECcGQNnCWbhoNBCM7ruJQE2na3MdVtsjBobSflQnjkg03fq0Dipi9ch4VK3m50g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juzO2ZNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juzO2ZNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15FFC4CEF1;
	Tue, 26 Aug 2025 13:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215096;
	bh=0gkdsYPfGYclXAlNfIRapktOZGcLqQeSD/0MT6A2e/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juzO2ZNO4QbIg859/Q7bEsxantckiPHxpyzAJO04jol/C5lo1tpj86FeQZlxVEUWO
	 qn3NagX14M9/tJthb4bFwII2yRbL4n8fFkPU81fR53WcgM52bxD0sd7TPbotQXHq/7
	 aJFikFSGgqxVDT1GaLoGEPGvVYSYJJKK8eubz9P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 355/482] block: reject invalid operation in submit_bio_noacct
Date: Tue, 26 Aug 2025 13:10:08 +0200
Message-ID: <20250826110939.604598711@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -755,6 +755,15 @@ void submit_bio_noacct(struct bio *bio)
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
@@ -768,6 +777,10 @@ void submit_bio_noacct(struct bio *bio)
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
@@ -779,12 +792,15 @@ void submit_bio_noacct(struct bio *bio)
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
@@ -366,6 +366,8 @@ enum req_op {
 	REQ_OP_DISCARD		= (__force blk_opf_t)3,
 	/* securely erase sectors */
 	REQ_OP_SECURE_ERASE	= (__force blk_opf_t)5,
+	/* write data at the current zone write pointer */
+	REQ_OP_ZONE_APPEND	= (__force blk_opf_t)7,
 	/* write the zero filled sector many times */
 	REQ_OP_WRITE_ZEROES	= (__force blk_opf_t)9,
 	/* Open a zone */
@@ -374,12 +376,10 @@ enum req_op {
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


