Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C432FF16B;
	Tue, 12 Aug 2025 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021863; cv=none; b=Q8bvM9/9jqxk58lCDcU12MV3G/bPZhaGEmUXWkukhG30ZKWfo8Z141rP70PG1craaOHdpg9T/YLLAylk2iGB3apmJRgeF2BnEQ1c0tsWkT0WgWb3SPubyc5aunSGD3GAG+hY/j/hqbPOmZMF16oK2wq9qqHoKT9iMyzy3xzdZaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021863; c=relaxed/simple;
	bh=vM0WbaT3uZFz6Lk5z8ulWG0KBLAIhK53qi13eCzLxaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kgPX9RwpNzUXfkeiNIcRfZAzzpdV17dBk53qBnuPOZkN+0W4/GiR0qJLlsPBHJIxBU9EOlS6KKYvDPH2kWzmos0Tzrir248PGGn8XzHzvoGyOmU9sxSOCZB+wl1oH+mTqKRJvgfO5ym2NNk5QPMnMtzPmodan1t9LW34TjCyreA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAyFn+lp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAyFn+lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACDBC4CEF6;
	Tue, 12 Aug 2025 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021863;
	bh=vM0WbaT3uZFz6Lk5z8ulWG0KBLAIhK53qi13eCzLxaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAyFn+lp0NIp765cabSVVVuc2mDKe9J4f8T3FFYLVXlGbOmKp682/qPHw+A5rc9u1
	 C9SiIpvDXgBJZnPJ80LzDHlqT6l1HUDBUgvf5twtwk0yNy/mfdBAYzQbROqeh2qotq
	 a8iYgk7JRnylyxobTv31P90wIwZjWPluRAH2rXLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/262] i2c: stm32f7: unmap DMA mapped buffer
Date: Tue, 12 Aug 2025 19:30:35 +0200
Message-ID: <20250812173003.669015455@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Le Goffic <clement.legoffic@foss.st.com>

[ Upstream commit 6aae87fe7f180cd93a74466cdb6cf2aa9bb28798 ]

Before each I2C transfer using DMA, the I2C buffer is DMA'pped to make
sure the memory buffer is DMA'able. This is handle in the function
`stm32_i2c_prep_dma_xfer()`.
If the transfer fails for any reason the I2C buffer must be unmap.
Use the dma_callback to factorize the code and fix this issue.

Note that the `stm32f7_i2c_dma_callback()` is now called in case of DMA
transfer success and error and that the `complete()` on the dma_complete
completion structure is done inconditionnally in case of transfer
success or error as well as the `dmaengine_terminate_async()`.
This is allowed as a `complete()` in case transfer error has no effect
as well as a `dmaengine_terminate_async()` on a transfer success.

Also fix the unneeded cast and remove not more needed variables.

Fixes: 7ecc8cfde553 ("i2c: i2c-stm32f7: Add DMA support")
Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Cc: <stable@vger.kernel.org> # v4.18+
Acked-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250704-i2c-upstream-v4-2-84a095a2c728@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -726,10 +726,11 @@ static void stm32f7_i2c_disable_dma_req(
 
 static void stm32f7_i2c_dma_callback(void *arg)
 {
-	struct stm32f7_i2c_dev *i2c_dev = (struct stm32f7_i2c_dev *)arg;
+	struct stm32f7_i2c_dev *i2c_dev = arg;
 	struct stm32_i2c_dma *dma = i2c_dev->dma;
 
 	stm32f7_i2c_disable_dma_req(i2c_dev);
+	dmaengine_terminate_async(dma->chan_using);
 	dma_unmap_single(i2c_dev->dev, dma->dma_buf, dma->dma_len,
 			 dma->dma_data_dir);
 	complete(&dma->dma_complete);
@@ -1525,7 +1526,6 @@ static irqreturn_t stm32f7_i2c_isr_event
 {
 	struct stm32f7_i2c_dev *i2c_dev = data;
 	struct stm32f7_i2c_msg *f7_msg = &i2c_dev->f7_msg;
-	struct stm32_i2c_dma *dma = i2c_dev->dma;
 	void __iomem *base = i2c_dev->base;
 	u32 status, mask;
 	int ret;
@@ -1540,10 +1540,8 @@ static irqreturn_t stm32f7_i2c_isr_event
 		dev_dbg(i2c_dev->dev, "<%s>: Receive NACK (addr %x)\n",
 			__func__, f7_msg->addr);
 		writel_relaxed(STM32F7_I2C_ICR_NACKCF, base + STM32F7_I2C_ICR);
-		if (i2c_dev->use_dma) {
-			stm32f7_i2c_disable_dma_req(i2c_dev);
-			dmaengine_terminate_async(dma->chan_using);
-		}
+		if (i2c_dev->use_dma)
+			stm32f7_i2c_dma_callback(i2c_dev);
 		f7_msg->result = -ENXIO;
 	}
 
@@ -1561,8 +1559,7 @@ static irqreturn_t stm32f7_i2c_isr_event
 			ret = wait_for_completion_timeout(&i2c_dev->dma->dma_complete, HZ);
 			if (!ret) {
 				dev_dbg(i2c_dev->dev, "<%s>: Timed out\n", __func__);
-				stm32f7_i2c_disable_dma_req(i2c_dev);
-				dmaengine_terminate_async(dma->chan_using);
+				stm32f7_i2c_dma_callback(i2c_dev);
 				f7_msg->result = -ETIMEDOUT;
 			}
 		}
@@ -1604,7 +1601,6 @@ static irqreturn_t stm32f7_i2c_isr_error
 	u16 addr = f7_msg->addr;
 	void __iomem *base = i2c_dev->base;
 	struct device *dev = i2c_dev->dev;
-	struct stm32_i2c_dma *dma = i2c_dev->dma;
 	u32 status;
 
 	status = readl_relaxed(i2c_dev->base + STM32F7_I2C_ISR);
@@ -1648,10 +1644,8 @@ static irqreturn_t stm32f7_i2c_isr_error
 	}
 
 	/* Disable dma */
-	if (i2c_dev->use_dma) {
-		stm32f7_i2c_disable_dma_req(i2c_dev);
-		dmaengine_terminate_async(dma->chan_using);
-	}
+	if (i2c_dev->use_dma)
+		stm32f7_i2c_dma_callback(i2c_dev);
 
 	i2c_dev->master_mode = false;
 	complete(&i2c_dev->complete);


