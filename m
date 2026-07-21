Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0F4375AC3;
	Tue, 21 Jul 2026 17:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654710; cv=none; b=D37QEygPPev4vXC6Yt0culWxU5YAAt8XOcjJpvWVBadAIyxVQIuY010h2p5XZbVkUFOQbc1pI+Jn2KE1MmmPCQoFvWElRp6jecEALPjPYrBVxBxT2OVBf7987R0fysFQICvBrp1oJeQg8VED4fHiCfla2Q6YeSxk+2tzMyAdAXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654710; c=relaxed/simple;
	bh=+ci7tKCnRxm53Wesh1qdA/fenWPy+qzmepg301DEnpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2E75Rx1Xq7c8O2LOFDOHK3DPDwz05EN4fquXcfyMpOOdqDx8nZT37kPUPThYrIaHCJOnHwbgTt6bm2K9s/0JBB7Qdnq+aA4h8KfVcPo/SEAi4Ifr2T/ml1iKOTQ8+w0wuUYXeFIFVvQGoyJSBHCeBUN4EpTZFAEiajOmau3YIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Md6I7/s9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Md6I7/s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA3C1F000E9;
	Tue, 21 Jul 2026 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654709;
	bh=Z9aMnFpmXUIAPrhacDN54iKeWBceurtBqkqC3+pwhhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Md6I7/s9co5LZsGECqkyWkyHqIkB9womjXD1UHTjApEZDxyUmonkzO27paEgy16a5
	 pA9i/8Rkb+KmkvTvPtfF7XQS5PkYbqUwnuOeobqnaXPfnhiufMt9Z4/n7S//6RMCza
	 OzUJm/PAmq+hZfjsf/NDZtnrBI+RHCCz5zNDqINM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Fernandez Pastrana <javier.pastrana@linutronix.de>,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 1809/2077] spi: imx: reconfigure for PIO when DMA cannot be started
Date: Tue, 21 Jul 2026 17:24:42 +0200
Message-ID: <20260721152635.415572413@linuxfoundation.org>
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

From: Javier Fernandez Pastrana <javier.pastrana@linutronix.de>

commit 245404c26563aafb36aafb01298f148db1851be3 upstream.

When spi_imx_can_dma() selects DMA, the ECSPI is configured for DMA:
spi_imx_setupxfer() sets CTRL.SMC and clears dynamic_burst, and
spi_imx_dma_transfer() programs the dynamic-burst BURST_LENGTH and the
SDMA watermarks.

If the DMA descriptor cannot be prepared (dmaengine_prep_slave_single()
returns NULL), the transfer is failed with SPI_TRANS_FAIL_NO_START and
falls back to PIO. The dynamic-burst DMA path uses its own bounce
buffers instead of the SPI core's mapping, so xfer->{tx,rx}_sg_mapped
are not set and the core's DMA->PIO retry is skipped; the driver falls
back to PIO internally. But none of the DMA-mode configuration is
undone, so the PIO transfer runs with CTRL.SMC set, the wrong burst
length and dynamic_burst cleared, and the transferred data is corrupted.

This is easily hit on i.MX8MP boards that describe ECSPI DMA in the
device tree but run SDMA on ROM firmware (no external sdma-imx7d.bin):
every ECSPI DMA prepare fails. An Infineon SLB9670 TPM on ECSPI1 then
returns shifted TPM2_GetCapability data, is flagged "field failure
mode", /dev/tpmrm0 is never created.

Set controller->fallback before re-running spi_imx_setupxfer() so the
ECSPI is reconfigured exactly like a normal PIO transfer. With
controller->fallback set, spi_imx_setupxfer() sees spi_imx_can_dma()
return false, so it clears spi_imx->usedma and reprograms the controller
(clears CTRL.SMC, restores dynamic_burst and the PIO burst length). No
explicit spi_imx->usedma = false is needed: setupxfer() already updates
it from the can_dma() result.

Fixes: faa8e404ad8e ("spi: imx: support dynamic burst length for ECSPI DMA mode")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Fernandez Pastrana <javier.pastrana@linutronix.de>
Acked-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260624151958.18626-1-javier.pastrana@linutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index ae9912905c67..79a6c1a60b0a 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -2152,7 +2152,8 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
 	if (spi_imx->usedma) {
 		ret = spi_imx_dma_transfer(spi_imx, transfer);
 		if (transfer->error & SPI_TRANS_FAIL_NO_START) {
-			spi_imx->usedma = false;
+			controller->fallback = true;
+			spi_imx_setupxfer(spi, transfer);
 			if (spi_imx->target_mode)
 				return spi_imx_pio_transfer_target(spi, transfer);
 			else
-- 
2.55.0



