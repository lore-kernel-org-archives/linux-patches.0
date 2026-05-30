Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE8519D8AC;
	Sat, 30 May 2026 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163340; cv=none; b=EcCuvMqUHJUHyQro5YD1o6wjsTFQTyzqMcBEyGRbEwubf68945o78Z7Ck9o97Po3wJ/ZREEotdJZJz27AVe6plNG+i2h2gXpaTVefRXO/PY/PyNIwqzjzZ9sba+vNwsQ0MDTE1NQ5w629m9lXjHLNsjSvUrKrvpixVh9eDPFPgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163340; c=relaxed/simple;
	bh=BK1a8pDN79W66P3ABawm8qpGNeB7jspaiKOnopDADGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rt7KFz0TIdhG9MhwplflwgPtxjNwu6tYmUqkvt4BNl8RSZ/Oj+uxgOxaFSnWo4UUaDRz5imFP+4Rn+J3altlBo6M5DEZ4YZ+FmF17L/ps3IrNGg2rj76NG7kRb6L7+YirmXlWTCMNu46OnvHrxchFzwodGZMMoXrbm90BC6HuIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qhd9UkLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qhd9UkLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3157F1F00893;
	Sat, 30 May 2026 17:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163339;
	bh=2YRbBctd3tv2wYcPjDxn7cpuDRl0YcteoWv2pqMcdqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qhd9UkLBGAZFgwKJACANQoGnMSBf/K9iOUsAJKEiTDnQYm1iruIL1Zw4Hb1T4ty+f
	 xn1yGdfzQGVP8lojkBaEdFBaIJjdFRghfCX72bSHBwGZ3rwL1iybPJkMy4IxWDR0ML
	 diEFc+o6Opmhy1VC6qwmzBI3ybsv4Co0Svm4WAoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Bin Liu <b-liu@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 227/776] mmc: block: use single block write in retry
Date: Sat, 30 May 2026 17:59:01 +0200
Message-ID: <20260530160246.391049799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bin Liu <b-liu@ti.com>

commit c7c6d4f5103864f73ee3a78bfd6da241f84197dd upstream.

Due to errata i2493[0], multi-block write would still fail in retries.

With i2493, the MMC interface has the potential of write failures when
issuing multi-block writes operating in HS200 mode with excessive IO
supply noise.

While the errata provides guidance in hardware design and layout to
minimize the IO supply noise, in theory the write failure cannot be
resolved in hardware. The software solution to ensure the data integrity
is to add minimum 5us delay between block writes. Single-block write is
the practical way to introduce the delay.

This patch reuses recovery_mode flag, and switches to single-block
write in retry when multi-block write fails. It covers both CQE and
non-CQE cases.

[0] https://www.ti.com/lit/pdf/sprz582
Cc: stable@vger.kernel.org
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |   12 ++++++++++--
 drivers/mmc/core/queue.h |    3 +++
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1361,6 +1361,9 @@ static void mmc_blk_data_prep(struct mmc
 		    rq_data_dir(req) == WRITE &&
 		    (md->flags & MMC_BLK_REL_WR);
 
+	if (mqrq->flags & MQRQ_XFER_SINGLE_BLOCK)
+		recovery_mode = 1;
+
 	memset(brq, 0, sizeof(struct mmc_blk_request));
 
 	mmc_crypto_prepare_req(mqrq);
@@ -1500,10 +1503,13 @@ static void mmc_blk_cqe_complete_rq(stru
 		err = 0;
 
 	if (err) {
-		if (mqrq->retries++ < MMC_CQE_RETRIES)
+		if (mqrq->retries++ < MMC_CQE_RETRIES) {
+			if (rq_data_dir(req) == WRITE)
+				mqrq->flags |= MQRQ_XFER_SINGLE_BLOCK;
 			blk_mq_requeue_request(req, true);
-		else
+		} else {
 			blk_mq_end_request(req, BLK_STS_IOERR);
+		}
 	} else if (mrq->data) {
 		if (blk_update_request(req, BLK_STS_OK, mrq->data->bytes_xfered))
 			blk_mq_requeue_request(req, true);
@@ -2041,6 +2047,8 @@ static void mmc_blk_mq_complete_rq(struc
 	} else if (!blk_rq_bytes(req)) {
 		__blk_mq_end_request(req, BLK_STS_IOERR);
 	} else if (mqrq->retries++ < MMC_MAX_RETRIES) {
+		if (rq_data_dir(req) == WRITE)
+			mqrq->flags |= MQRQ_XFER_SINGLE_BLOCK;
 		blk_mq_requeue_request(req, true);
 	} else {
 		if (mmc_card_removed(mq->card))
--- a/drivers/mmc/core/queue.h
+++ b/drivers/mmc/core/queue.h
@@ -61,6 +61,8 @@ enum mmc_drv_op {
 	MMC_DRV_OP_GET_EXT_CSD,
 };
 
+#define	MQRQ_XFER_SINGLE_BLOCK		BIT(0)
+
 struct mmc_queue_req {
 	struct mmc_blk_request	brq;
 	struct scatterlist	*sg;
@@ -69,6 +71,7 @@ struct mmc_queue_req {
 	void			*drv_op_data;
 	unsigned int		ioc_count;
 	int			retries;
+	u32			flags;
 };
 
 struct mmc_queue {


