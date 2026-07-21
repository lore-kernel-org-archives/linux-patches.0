Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D933E49F0;
	Tue, 21 Jul 2026 17:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655399; cv=none; b=KECVhIr3b0LYxkObBrGGUXSi5/YsZ5vWRsSvNy90DkpcLg2Q4HrqkHbkCApqjycUx/ZvisB+fMGEoxJ90R7Jig2HjfkOPjqFO14HGi+4Id53toTodB8Ev3KsLes6fbFnbGZov1L9teyJjbi7lzlNdO0rAjuFp81e8w2fMPwivnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655399; c=relaxed/simple;
	bh=ozYXv/1PK6iEnQbONvy4olFRZbHmYjDKwFeCDvp88EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npUDnu7aOcpvDYJqw4H63PTlUJMmah9Fv9oJiCQezNrMbhhL+ZLw85cfHD7tZ8eJfLuGTHKCfI9HcOrE9VJ4fH77bivqycxmlcNYW6nCSQQqac1dxk7MMDtRf1b4SjmL+zoeJUXufpHTJ+JX0dMei0SBroEVobnJJlxo1Js5wqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gak+Aus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gak+Aus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456601F000E9;
	Tue, 21 Jul 2026 17:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655398;
	bh=qXEZTeq5cq322THJ6z+5z082RauNeCLv/sxuU9ImxwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Gak+Auslxh5UY+dnwLSU5+CypIqnKBQtSZUz+lTHCQUkCTNoueW2OU1/zf4BQoWp
	 JwsYaApZfDw2N9JLTle1745Cshf/A3TE56PhyAStq6+5sJCU0JNBeoxN7f0WpvrgKM
	 lChhzXNaJzeAd8tJeH7WjCc4QrUunb7G8TLSOdwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 2032/2077] mtd: rawnand: lpc32xx_mlc: fail DMA transfers on timeout
Date: Tue, 21 Jul 2026 17:28:25 +0200
Message-ID: <20260721152640.626959511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


