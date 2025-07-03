Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAA22EF9BD;
	Thu,  3 Jul 2025 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554523; cv=none; b=NGvlVeJnP4JpcRUYORPJIYU+2Jcb/quNJRNd5w5V0Ju5a5FdXXjv7Ptaa0Wn5VHe0Ox2ZfVq/cykEsFPshdNuWBluesyVXvN8ZsLqLQdPmv+J7Izev2h0KEpYtohvVI4piQcokA2IRCNV75Y1HOSZ6P1XGsdnoZOT3HSSUVmsJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554523; c=relaxed/simple;
	bh=feHzV9NyIThka6vQt7pvM6uryLWZT/F/cp3ldug5ANw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+JrTxtbIXznYhsrwZodctkOAkmUt6jf2RKGAfjBtjTKmi9Bdjoh0KUzY/kwKnLVAVymXZvtbc1BuyQZ+5uKhQ3r2m9vIaPF71/MnJFD/bmjmHUp4bI1RpHS0aodlBS5R2ktmuyeh6NwECD/ssKPBRiOJFy7i++XaCQB8etw9Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djhD5jz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djhD5jz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8DEC4CEE3;
	Thu,  3 Jul 2025 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554523;
	bh=feHzV9NyIThka6vQt7pvM6uryLWZT/F/cp3ldug5ANw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djhD5jz+L5xkHL1hHCENM1T/x3IVMmPgM2ASKjCsAt++i4mBVO4KIyQ+r+rF9RZP7
	 QgdaeuUSFfmBgulO+5zIbRZ0la49Jquxusi57MH/ov4AT1dR5szLWVN88WBVBW0y2X
	 5XyFNQHwFuIr9gCcxROig7HVxHuOEPgCCoUNef/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/218] spi: fsl-qspi: Support per spi-mem operation frequency switches
Date: Thu,  3 Jul 2025 16:42:42 +0200
Message-ID: <20250703144004.770632423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 2438db5253eb17a7c0ccb15aea4252a150dda057 ]

Every ->exec_op() call correctly configures the spi bus speed to the
maximum allowed frequency for the memory using the constant spi default
parameter. Since we can now have per-operation constraints, let's use
the value that comes from the spi-mem operation structure instead. In
case there is no specific limitation for this operation, the default spi
device value will be given anyway.

The per-operation frequency capability is thus advertised to the spi-mem
core.

Cc: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20241224-winbond-6-11-rc1-quad-support-v2-8-ad218dbc406f@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-qspi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index 79bac30e79af6..ce86f44b0e93f 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -522,9 +522,10 @@ static void fsl_qspi_invalidate(struct fsl_qspi *q)
 	qspi_writel(q, reg, q->iobase + QUADSPI_MCR);
 }
 
-static void fsl_qspi_select_mem(struct fsl_qspi *q, struct spi_device *spi)
+static void fsl_qspi_select_mem(struct fsl_qspi *q, struct spi_device *spi,
+				const struct spi_mem_op *op)
 {
-	unsigned long rate = spi->max_speed_hz;
+	unsigned long rate = op->max_freq;
 	int ret;
 
 	if (q->selected == spi_get_chipselect(spi, 0))
@@ -652,7 +653,7 @@ static int fsl_qspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 	fsl_qspi_readl_poll_tout(q, base + QUADSPI_SR, (QUADSPI_SR_IP_ACC_MASK |
 				 QUADSPI_SR_AHB_ACC_MASK), 10, 1000);
 
-	fsl_qspi_select_mem(q, mem->spi);
+	fsl_qspi_select_mem(q, mem->spi, op);
 
 	if (needs_amba_base_offset(q))
 		addr_offset = q->memmap_phy;
@@ -839,6 +840,10 @@ static const struct spi_controller_mem_ops fsl_qspi_mem_ops = {
 	.get_name = fsl_qspi_get_name,
 };
 
+static const struct spi_controller_mem_caps fsl_qspi_mem_caps = {
+	.per_op_freq = true,
+};
+
 static int fsl_qspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr;
@@ -923,6 +928,7 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 	ctlr->bus_num = -1;
 	ctlr->num_chipselect = 4;
 	ctlr->mem_ops = &fsl_qspi_mem_ops;
+	ctlr->mem_caps = &fsl_qspi_mem_caps;
 
 	fsl_qspi_default_setup(q);
 
-- 
2.39.5



