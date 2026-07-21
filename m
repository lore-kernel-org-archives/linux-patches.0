Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8110F413D69;
	Tue, 21 Jul 2026 22:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672826; cv=none; b=EA0xAymIulvl1LfBmw3aGEpVJ8L4WuBuSu2uqQsHo1y/+A2qWnYWESqV2erAUrMYQm9SfGJ66HwVv1GY9g+r0mirzyQUS1jeRBZndHetTIkS5zQ5PvnZcEuJC+hFNq+xYCrxnAj45gT7gsTTHW7P86kosjbR0nUoyNXaXx3kIGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672826; c=relaxed/simple;
	bh=/ezqzMcx2pbBLRt9OTW9i9VhFDd4R0AgFzXPGTU3uMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KReCCb7ZC7Kbw2wCFiaq87FzNs0CjQKk/h8PpKfwvjeatoJW8i8LqFJMK5QU1aAPyuceTD6YR2pqUxuCnwAD2bNcvMJP+4UwpJHtto85/VUJ3oh55UWk6eQj4CgTJ3yLdN1qb3m5aSda//j3Xxf/nRJCGeFrofsU7UMB1KhMUQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUja3KIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUja3KIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FB21F000E9;
	Tue, 21 Jul 2026 22:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672825;
	bh=qB9yQyZIv7491H/pPZMB5Kin2Avg2SOhtNVS5NCkbYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUja3KIk66ACOO1JEnSkUTm7RhmnLmPrks8ipkdqkIvnHJ/KxvthVv1MRRPGzmi+l
	 T7E6L39cOwjHtQOtQsCPch4X4Qvl+HaxpgExQs0vOCCOU/DMmnfo6WI9bMbi8EzAm2
	 kJlwW1AFWGufQk5qjQomi5qjPJeH8X/EgC/+DBWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 728/843] mtd: rawnand: lpc32xx_mlc: fail DMA transfers on timeout
Date: Tue, 21 Jul 2026 17:26:03 +0200
Message-ID: <20260721152422.418099979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit dbf590b662695b16fbf5917ef129697be4410ea9 upstream.

lpc32xx_xmit_dma() starts a DMA transfer and waits up to one second
for its completion, but it ignores the wait result and returns success
after unmapping the buffer.

A timed out read can therefore return success with incomplete data, and
a timed out write can continue the NAND operation without proof that the
DMA payload reached the controller.

Terminate the DMA channel on timeout, unmap the scatterlist through the
existing cleanup path, and return -ETIMEDOUT to the NAND read/write
callers. Initialize the shared cleanup-path result before using it for
dmaengine_prep_slave_sg() failures.

Fixes: 70f7cb78ec53 ("mtd: add LPC32xx MLC NAND driver")
Cc: stable@vger.kernel.org
Reviewed-by: Vladimir Zapolskiy <vz@kernel.org>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/lpc32xx_mlc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_mlc.c
@@ -396,6 +396,7 @@ static int lpc32xx_xmit_dma(struct mtd_i
 	struct lpc32xx_nand_host *host = nand_get_controller_data(chip);
 	struct dma_async_tx_descriptor *desc;
 	int flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
+	unsigned long time_left;
 	int res;
 
 	sg_init_one(&host->sgl, mem, len);
@@ -410,6 +411,7 @@ static int lpc32xx_xmit_dma(struct mtd_i
 				       flags);
 	if (!desc) {
 		dev_err(mtd->dev.parent, "Failed to prepare slave sg\n");
+		res = -ENXIO;
 		goto out1;
 	}
 
@@ -420,7 +422,13 @@ static int lpc32xx_xmit_dma(struct mtd_i
 	dmaengine_submit(desc);
 	dma_async_issue_pending(host->dma_chan);
 
-	wait_for_completion_timeout(&host->comp_dma, msecs_to_jiffies(1000));
+	time_left = wait_for_completion_timeout(&host->comp_dma,
+						msecs_to_jiffies(1000));
+	if (!time_left) {
+		dmaengine_terminate_sync(host->dma_chan);
+		res = -ETIMEDOUT;
+		goto out1;
+	}
 
 	dma_unmap_sg(host->dma_chan->device->dev, &host->sgl, 1,
 		     DMA_BIDIRECTIONAL);
@@ -428,7 +436,7 @@ static int lpc32xx_xmit_dma(struct mtd_i
 out1:
 	dma_unmap_sg(host->dma_chan->device->dev, &host->sgl, 1,
 		     DMA_BIDIRECTIONAL);
-	return -ENXIO;
+	return res;
 }
 
 static int lpc32xx_read_page(struct nand_chip *chip, uint8_t *buf,


