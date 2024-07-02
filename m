Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BF615B0FE;
	Tue,  2 Jul 2024 17:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940424; cv=none; b=Xx3HvR3EjeBL94ogb4baXP8yIGBWhic8ceVwxODeaOL3sYY1UGW7MzQbizUb5G4zJvwWP/ZXrFJnu2nkwzmtu+N3Vt0TqsPCyBmIlt65+MSpsOHqtziKdStK8OoLG3BWsfAosNS+oooS87qr5HO1yVfx116cT8TC+SBKrUYz5Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940424; c=relaxed/simple;
	bh=Mw8ljh/VLWUU/J3vmQ9uhlvITRjUTFHqYufatRV2xiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afjKHwQcrsZgepc2D9u5YudMyOBk9+HsvHObcNn17bw3zyWTjk7M2HoT+Si6YacB7b4y1jOAejte7W/Qrytl+CoJ/cd8WfYakCIZCY4wK5F1Of8TVf1oBo0WGiVN0HCaHB0DrONlVP7cUmHb+fzAu+bHvwRtrI489oFOfpSMDcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zgcjsqpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zgcjsqpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F0FC116B1;
	Tue,  2 Jul 2024 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940424;
	bh=Mw8ljh/VLWUU/J3vmQ9uhlvITRjUTFHqYufatRV2xiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgcjsqprHYjC5qkDpevCR3zBDziM3GEuhVExjAEJQknn4621nr88FALMYBTrLWFzz
	 GxlGcxOnjrL3wkbjv62w4BqkWPh8BJxKnUokP4ECQze1Q0X2pwNp4AtPkedHX8wYbf
	 ErnqDamID0Etqqd00Hnuicgd4/GA9aGlfcxW6JD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Antonov <saproj@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 120/222] Revert "mmc: moxart-mmc: Use sg_miter for PIO"
Date: Tue,  2 Jul 2024 19:02:38 +0200
Message-ID: <20240702170248.557207365@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 84bb8d8bbd8384081c3fc5c4f20b223524af529d upstream.

This reverts commit 3ee0e7c3e67cab83ffbbe7707b43df8d41c9fe47.

The patch is not working for unknown reasons and I would
need access to the hardware to fix the bug.

This shouldn't matter anyway: the Moxa Art is not expected
to use highmem, and sg_miter() is only necessary to have
to properly deal with highmem.

Reported-by: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: 3ee0e7c3e67c ("mmc: moxart-mmc: Use sg_miter for PIO")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240606-mmc-moxart-revert-v1-1-a01c2f40de9c@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/moxart-mmc.c | 78 +++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 9a5f75163aca..8ede4ce93271 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -131,10 +131,12 @@ struct moxart_host {
 	struct dma_async_tx_descriptor	*tx_desc;
 	struct mmc_host			*mmc;
 	struct mmc_request		*mrq;
+	struct scatterlist		*cur_sg;
 	struct completion		dma_complete;
 	struct completion		pio_complete;
 
-	struct sg_mapping_iter		sg_miter;
+	u32				num_sg;
+	u32				data_remain;
 	u32				data_len;
 	u32				fifo_width;
 	u32				timeout;
@@ -146,6 +148,35 @@ struct moxart_host {
 	bool				is_removed;
 };
 
+static inline void moxart_init_sg(struct moxart_host *host,
+				  struct mmc_data *data)
+{
+	host->cur_sg = data->sg;
+	host->num_sg = data->sg_len;
+	host->data_remain = host->cur_sg->length;
+
+	if (host->data_remain > host->data_len)
+		host->data_remain = host->data_len;
+}
+
+static inline int moxart_next_sg(struct moxart_host *host)
+{
+	int remain;
+	struct mmc_data *data = host->mrq->cmd->data;
+
+	host->cur_sg++;
+	host->num_sg--;
+
+	if (host->num_sg > 0) {
+		host->data_remain = host->cur_sg->length;
+		remain = host->data_len - data->bytes_xfered;
+		if (remain > 0 && remain < host->data_remain)
+			host->data_remain = remain;
+	}
+
+	return host->num_sg;
+}
+
 static int moxart_wait_for_status(struct moxart_host *host,
 				  u32 mask, u32 *status)
 {
@@ -278,29 +309,14 @@ static void moxart_transfer_dma(struct mmc_data *data, struct moxart_host *host)
 
 static void moxart_transfer_pio(struct moxart_host *host)
 {
-	struct sg_mapping_iter *sgm = &host->sg_miter;
 	struct mmc_data *data = host->mrq->cmd->data;
 	u32 *sgp, len = 0, remain, status;
 
 	if (host->data_len == data->bytes_xfered)
 		return;
 
-	/*
-	 * By updating sgm->consumes this will get a proper pointer into the
-	 * buffer at any time.
-	 */
-	if (!sg_miter_next(sgm)) {
-		/* This shold not happen */
-		dev_err(mmc_dev(host->mmc), "ran out of scatterlist prematurely\n");
-		data->error = -EINVAL;
-		complete(&host->pio_complete);
-		return;
-	}
-	sgp = sgm->addr;
-	remain = sgm->length;
-	if (remain > host->data_len)
-		remain = host->data_len;
-	sgm->consumed = 0;
+	sgp = sg_virt(host->cur_sg);
+	remain = host->data_remain;
 
 	if (data->flags & MMC_DATA_WRITE) {
 		while (remain > 0) {
@@ -315,7 +331,6 @@ static void moxart_transfer_pio(struct moxart_host *host)
 				sgp++;
 				len += 4;
 			}
-			sgm->consumed += len;
 			remain -= len;
 		}
 
@@ -332,22 +347,22 @@ static void moxart_transfer_pio(struct moxart_host *host)
 				sgp++;
 				len += 4;
 			}
-			sgm->consumed += len;
 			remain -= len;
 		}
 	}
 
-	data->bytes_xfered += sgm->consumed;
-	if (host->data_len == data->bytes_xfered) {
+	data->bytes_xfered += host->data_remain - remain;
+	host->data_remain = remain;
+
+	if (host->data_len != data->bytes_xfered)
+		moxart_next_sg(host);
+	else
 		complete(&host->pio_complete);
-		return;
-	}
 }
 
 static void moxart_prepare_data(struct moxart_host *host)
 {
 	struct mmc_data *data = host->mrq->cmd->data;
-	unsigned int flags = SG_MITER_ATOMIC; /* Used from IRQ */
 	u32 datactrl;
 	int blksz_bits;
 
@@ -358,19 +373,15 @@ static void moxart_prepare_data(struct moxart_host *host)
 	blksz_bits = ffs(data->blksz) - 1;
 	BUG_ON(1 << blksz_bits != data->blksz);
 
+	moxart_init_sg(host, data);
+
 	datactrl = DCR_DATA_EN | (blksz_bits & DCR_BLK_SIZE);
 
-	if (data->flags & MMC_DATA_WRITE) {
-		flags |= SG_MITER_FROM_SG;
+	if (data->flags & MMC_DATA_WRITE)
 		datactrl |= DCR_DATA_WRITE;
-	} else {
-		flags |= SG_MITER_TO_SG;
-	}
 
 	if (moxart_use_dma(host))
 		datactrl |= DCR_DMA_EN;
-	else
-		sg_miter_start(&host->sg_miter, data->sg, data->sg_len, flags);
 
 	writel(DCR_DATA_FIFO_RESET, host->base + REG_DATA_CONTROL);
 	writel(MASK_DATA | FIFO_URUN | FIFO_ORUN, host->base + REG_CLEAR);
@@ -443,9 +454,6 @@ static void moxart_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	}
 
 request_done:
-	if (!moxart_use_dma(host))
-		sg_miter_stop(&host->sg_miter);
-
 	spin_unlock_irqrestore(&host->lock, flags);
 	mmc_request_done(host->mmc, mrq);
 }
-- 
2.45.2



