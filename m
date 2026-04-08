Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F923537FC;
	Wed,  8 Apr 2026 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672444; cv=none; b=YZMDKW0Avjyn88u7OBU2pggpjUSBKtmn/yioTuYHVhBWfmbZsJkx5T0IpyLcrmPMKDFpxd/T4jQSVD+UqIspb6aZXVRkYutiIVTsumQECWUDtFZoXtoArd3PEoK7oPfOvyV1MD9vhirUlPLWa0AugLZ+XhuKQaxk+ekxHKZlhIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672444; c=relaxed/simple;
	bh=LR192lMBNVFdOHyQ91qAfuadFQmokAuNobbQQdnFE+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pu5m1DaBMPWgpGVENO8x+/sYzaBSZrG+xW+nxhhxrwfN6+tR3FwcM11igZNUuYxiVuqImMQiPgvAiBrkCT6BSK9GoPPskxGCFPO4ho92u98daNpwrmkADGvS+a9sru/v7FqFmsjh2THTQigoTjrvPEi0TuTKLDmTAkFfBYh05zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7fWcCpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7fWcCpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9B8C19421;
	Wed,  8 Apr 2026 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672444;
	bh=LR192lMBNVFdOHyQ91qAfuadFQmokAuNobbQQdnFE+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7fWcCpjpSmf+VzsvPutDA49S17ormsoZLc2Vn4/H+mcjsu1TlUXAG92sfjH5mjoC
	 zYCCimbaAEwkT16wDAjT9ZcEjCvxt7fn5NaFISpF93Qdxh7VZGJRUcEQA1La3NqeFL
	 XfKUQTIc2UsQaw0ptZqMD5VQmnvwYZMI9Ra6Ygmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/160] spi: geni-qcom: Check DMA interrupts early in ISR
Date: Wed,  8 Apr 2026 20:01:37 +0200
Message-ID: <20260408175913.572473701@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit 8c89a077ca796a2fe248c584e9d7e66cff0388c8 ]

The current interrupt handler only checks the GENI main IRQ status
(m_irq) before deciding to return IRQ_NONE. This can lead to spurious
IRQ_NONE returns when DMA interrupts are pending but m_irq is zero.

Move the DMA TX/RX status register reads to the beginning of the ISR,
right after reading m_irq. Update the early return condition to check
all three status registers (m_irq, dma_tx_status, dma_rx_status) before
returning IRQ_NONE.

Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260313-spi-geni-qcom-fix-dma-irq-handling-v1-1-0bd122589e02@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 37a20652fd2e7..ef1a05837cb97 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -948,10 +948,13 @@ static irqreturn_t geni_spi_isr(int irq, void *data)
 	struct spi_master *spi = data;
 	struct spi_geni_master *mas = spi_master_get_devdata(spi);
 	struct geni_se *se = &mas->se;
-	u32 m_irq;
+	u32 m_irq, dma_tx_status, dma_rx_status;
 
 	m_irq = readl(se->base + SE_GENI_M_IRQ_STATUS);
-	if (!m_irq)
+	dma_tx_status = readl_relaxed(se->base + SE_DMA_TX_IRQ_STAT);
+	dma_rx_status = readl_relaxed(se->base + SE_DMA_RX_IRQ_STAT);
+
+	if (!m_irq && !dma_tx_status && !dma_rx_status)
 		return IRQ_NONE;
 
 	if (m_irq & (M_CMD_OVERRUN_EN | M_ILLEGAL_CMD_EN | M_CMD_FAILURE_EN |
@@ -999,8 +1002,6 @@ static irqreturn_t geni_spi_isr(int irq, void *data)
 		}
 	} else if (mas->cur_xfer_mode == GENI_SE_DMA) {
 		const struct spi_transfer *xfer = mas->cur_xfer;
-		u32 dma_tx_status = readl_relaxed(se->base + SE_DMA_TX_IRQ_STAT);
-		u32 dma_rx_status = readl_relaxed(se->base + SE_DMA_RX_IRQ_STAT);
 
 		if (dma_tx_status)
 			writel(dma_tx_status, se->base + SE_DMA_TX_IRQ_CLR);
-- 
2.53.0



