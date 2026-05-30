Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AECB332EA7;
	Sat, 30 May 2026 16:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160209; cv=none; b=JxIXnncNUmUdNOXk+51heqH+BmvKS69yr1X0t/BkVWZlB/uwoJcbVuOhJX5IQsNbalJIryYM1Ot66x4ORNXCWQY9WqORoqkPxYABd/6cvRS/4zeaqUiJ3A1kd248/Kc5HEgb8RurFxBkhPnC9MVDJFC+5L2gK6c1dC/+WDy8Xa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160209; c=relaxed/simple;
	bh=4nJWUnU6M2iTFNHz9ZsMM7gIAsEGEzdOFv91VaDO+8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojl4yyhoep3ux1eAF9RDSLEGxSMhvMgonskjtpkmQhzZ7XSsxbkAFJ0S3dkZ0HSqLLsbPoIz2xnGRt4fXHTRLPZ1k9P8QMDSOExoz0MBLD3pdVnfBJsLcmirTCf50oEWrcNKQSDlcp6XnC7jbUzsHgiJmw9WvZMhvGBCbR2OrXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DP+7l2ym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DP+7l2ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6571F00893;
	Sat, 30 May 2026 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160208;
	bh=nqd5xaMwBb2MGVEB2VmMKQQjuz8grq5xtUj7xnifvWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DP+7l2ymve3y+w8uSFga3AOnY1VPP5OochusLhNcqFcjjyLk29VyfXs+oQahNEF2l
	 iwxbTlsdfcrVe66WalDnuzjd4HEKyj17X1yISK2EyvN1Z8TNAKPOmobYRJ3EBa/Fyl
	 fEdKEsU3k2Zc4avUy9ay/yUCPVNDhrBUK20WH87Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Bin Liu <b-liu@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 227/969] mmc: block: use single block write in retry
Date: Sat, 30 May 2026 17:55:51 +0200
Message-ID: <20260530160306.723096615@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1401,6 +1401,9 @@ static void mmc_blk_data_prep(struct mmc
 		    rq_data_dir(req) == WRITE &&
 		    (md->flags & MMC_BLK_REL_WR);
 
+	if (mqrq->flags & MQRQ_XFER_SINGLE_BLOCK)
+		recovery_mode = 1;
+
 	memset(brq, 0, sizeof(struct mmc_blk_request));
 
 	mmc_crypto_prepare_req(mqrq);
@@ -1540,10 +1543,13 @@ static void mmc_blk_cqe_complete_rq(stru
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
@@ -2081,6 +2087,8 @@ static void mmc_blk_mq_complete_rq(struc
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


