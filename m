Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A9D8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2D8C433C8;
	Sun, 16 Jul 2023 20:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537664;
	bh=nFEGZ5+2DFaaUlC1wPd3QXgv9jAuD//KLcWqW9MwZZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqqnGe5OIr8+WB6kDWjyAhnX2tH+wfkZ0ZK19XXb5tsVhJX0cqnb+Phf1GeKWpQOH
	 r9zY+iPk+lqk3+QV3QLpXgjgIuzK+VCZd/5CKNPAFOokFkRdFumvvd2zEYu/JQA6/k
	 nDLspiKVumwu5DOohXhV1HWIS1dLYuQp1CkN9GcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>,
	Douglas Anderson <dianders@chromium.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 149/800] soc: qcom: geni-se: Add interfaces geni_se_tx_init_dma() and geni_se_rx_init_dma()
Date: Sun, 16 Jul 2023 21:40:02 +0200
Message-ID: <20230716194952.555732298@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>

[ Upstream commit 6d6e57594957ee9131bc3802dfc8657ca6f78fee ]

The geni_se_xx_dma_prep() interfaces necessarily do DMA mapping before
initiating DMA transfers. This is not suitable for spi where framework
is expected to handle map/unmap.

Expose new interfaces geni_se_xx_init_dma() which do only DMA transfer.

Signed-off-by: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/1684325894-30252-2-git-send-email-quic_vnivarth@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3a76c7ca9e77 ("spi: spi-geni-qcom: Do not do DMA map/unmap inside driver, use framework instead")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c  | 67 +++++++++++++++++++++++---------
 include/linux/soc/qcom/geni-se.h |  4 ++
 2 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 795a2e1d59b3a..dd50a255fa6cb 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -682,6 +682,30 @@ EXPORT_SYMBOL(geni_se_clk_freq_match);
 #define GENI_SE_DMA_EOT_EN BIT(1)
 #define GENI_SE_DMA_AHB_ERR_EN BIT(2)
 #define GENI_SE_DMA_EOT_BUF BIT(0)
+
+/**
+ * geni_se_tx_init_dma() - Initiate TX DMA transfer on the serial engine
+ * @se:			Pointer to the concerned serial engine.
+ * @iova:		Mapped DMA address.
+ * @len:		Length of the TX buffer.
+ *
+ * This function is used to initiate DMA TX transfer.
+ */
+void geni_se_tx_init_dma(struct geni_se *se, dma_addr_t iova, size_t len)
+{
+	u32 val;
+
+	val = GENI_SE_DMA_DONE_EN;
+	val |= GENI_SE_DMA_EOT_EN;
+	val |= GENI_SE_DMA_AHB_ERR_EN;
+	writel_relaxed(val, se->base + SE_DMA_TX_IRQ_EN_SET);
+	writel_relaxed(lower_32_bits(iova), se->base + SE_DMA_TX_PTR_L);
+	writel_relaxed(upper_32_bits(iova), se->base + SE_DMA_TX_PTR_H);
+	writel_relaxed(GENI_SE_DMA_EOT_BUF, se->base + SE_DMA_TX_ATTR);
+	writel(len, se->base + SE_DMA_TX_LEN);
+}
+EXPORT_SYMBOL(geni_se_tx_init_dma);
+
 /**
  * geni_se_tx_dma_prep() - Prepare the serial engine for TX DMA transfer
  * @se:			Pointer to the concerned serial engine.
@@ -697,7 +721,6 @@ int geni_se_tx_dma_prep(struct geni_se *se, void *buf, size_t len,
 			dma_addr_t *iova)
 {
 	struct geni_wrapper *wrapper = se->wrapper;
-	u32 val;
 
 	if (!wrapper)
 		return -EINVAL;
@@ -706,17 +729,34 @@ int geni_se_tx_dma_prep(struct geni_se *se, void *buf, size_t len,
 	if (dma_mapping_error(wrapper->dev, *iova))
 		return -EIO;
 
+	geni_se_tx_init_dma(se, *iova, len);
+	return 0;
+}
+EXPORT_SYMBOL(geni_se_tx_dma_prep);
+
+/**
+ * geni_se_rx_init_dma() - Initiate RX DMA transfer on the serial engine
+ * @se:			Pointer to the concerned serial engine.
+ * @iova:		Mapped DMA address.
+ * @len:		Length of the RX buffer.
+ *
+ * This function is used to initiate DMA RX transfer.
+ */
+void geni_se_rx_init_dma(struct geni_se *se, dma_addr_t iova, size_t len)
+{
+	u32 val;
+
 	val = GENI_SE_DMA_DONE_EN;
 	val |= GENI_SE_DMA_EOT_EN;
 	val |= GENI_SE_DMA_AHB_ERR_EN;
-	writel_relaxed(val, se->base + SE_DMA_TX_IRQ_EN_SET);
-	writel_relaxed(lower_32_bits(*iova), se->base + SE_DMA_TX_PTR_L);
-	writel_relaxed(upper_32_bits(*iova), se->base + SE_DMA_TX_PTR_H);
-	writel_relaxed(GENI_SE_DMA_EOT_BUF, se->base + SE_DMA_TX_ATTR);
-	writel(len, se->base + SE_DMA_TX_LEN);
-	return 0;
+	writel_relaxed(val, se->base + SE_DMA_RX_IRQ_EN_SET);
+	writel_relaxed(lower_32_bits(iova), se->base + SE_DMA_RX_PTR_L);
+	writel_relaxed(upper_32_bits(iova), se->base + SE_DMA_RX_PTR_H);
+	/* RX does not have EOT buffer type bit. So just reset RX_ATTR */
+	writel_relaxed(0, se->base + SE_DMA_RX_ATTR);
+	writel(len, se->base + SE_DMA_RX_LEN);
 }
-EXPORT_SYMBOL(geni_se_tx_dma_prep);
+EXPORT_SYMBOL(geni_se_rx_init_dma);
 
 /**
  * geni_se_rx_dma_prep() - Prepare the serial engine for RX DMA transfer
@@ -733,7 +773,6 @@ int geni_se_rx_dma_prep(struct geni_se *se, void *buf, size_t len,
 			dma_addr_t *iova)
 {
 	struct geni_wrapper *wrapper = se->wrapper;
-	u32 val;
 
 	if (!wrapper)
 		return -EINVAL;
@@ -742,15 +781,7 @@ int geni_se_rx_dma_prep(struct geni_se *se, void *buf, size_t len,
 	if (dma_mapping_error(wrapper->dev, *iova))
 		return -EIO;
 
-	val = GENI_SE_DMA_DONE_EN;
-	val |= GENI_SE_DMA_EOT_EN;
-	val |= GENI_SE_DMA_AHB_ERR_EN;
-	writel_relaxed(val, se->base + SE_DMA_RX_IRQ_EN_SET);
-	writel_relaxed(lower_32_bits(*iova), se->base + SE_DMA_RX_PTR_L);
-	writel_relaxed(upper_32_bits(*iova), se->base + SE_DMA_RX_PTR_H);
-	/* RX does not have EOT buffer type bit. So just reset RX_ATTR */
-	writel_relaxed(0, se->base + SE_DMA_RX_ATTR);
-	writel(len, se->base + SE_DMA_RX_LEN);
+	geni_se_rx_init_dma(se, *iova, len);
 	return 0;
 }
 EXPORT_SYMBOL(geni_se_rx_dma_prep);
diff --git a/include/linux/soc/qcom/geni-se.h b/include/linux/soc/qcom/geni-se.h
index c55a0bc8cb0e9..821a19135bb66 100644
--- a/include/linux/soc/qcom/geni-se.h
+++ b/include/linux/soc/qcom/geni-se.h
@@ -490,9 +490,13 @@ int geni_se_clk_freq_match(struct geni_se *se, unsigned long req_freq,
 			   unsigned int *index, unsigned long *res_freq,
 			   bool exact);
 
+void geni_se_tx_init_dma(struct geni_se *se, dma_addr_t iova, size_t len);
+
 int geni_se_tx_dma_prep(struct geni_se *se, void *buf, size_t len,
 			dma_addr_t *iova);
 
+void geni_se_rx_init_dma(struct geni_se *se, dma_addr_t iova, size_t len);
+
 int geni_se_rx_dma_prep(struct geni_se *se, void *buf, size_t len,
 			dma_addr_t *iova);
 
-- 
2.39.2



