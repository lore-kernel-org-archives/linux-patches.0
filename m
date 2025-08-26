Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADD7321459;
	Tue, 26 Aug 2025 11:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207211; cv=none; b=fmXFiV7H4ouuz3kmTehLEIUbbm5o3zz7r6v+t/REn7PawIxkesbZhs47GbtnWMx5EwRgtENRVD4rENuEpslWYSGPHzv2bsC2eBoZUw+9rlbU8bai8FDjj+XCKdyC/ddlvzTXDcLPlvgJiI49sB1zI6pZeRNV69JuctmCWD08Dos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207211; c=relaxed/simple;
	bh=H0VKSfbs/N2PQdPsVE0OmRMob9ft5ggO8PUx+wnoiVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw4sPiuf1an8HW46b5qJApct0RMQaqFE7X5Vqv9eEerBtpjMPXWk098PDFn3OiDrEZBTOaphCtBv+b22UdnHoqVdX7OuhoJQtrjsMR8Yslu7l6e5MhOBZC8Cg1h5pn4xTBgqsP0qenDPhEfACMb9G89uVZUmR5LNmIMPeiCgcJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySa5ycc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySa5ycc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0503AC4CEF1;
	Tue, 26 Aug 2025 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207211;
	bh=H0VKSfbs/N2PQdPsVE0OmRMob9ft5ggO8PUx+wnoiVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySa5ycc319+D9GDNPknAj17tjQqlWZ+qCGaI5CpfceBATqesSat/KPcK3FLIVu65Z
	 rVbWRCI2FdW0M5qXdf1/+RPRCEkvaaJ5ChnilxO6ujD9Tyq9EUHnZ841+bURdReWg1
	 bGXoKuwag051GeynrkLxqCCno+pQZT2Cn858qpi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.16 094/457] mtd: rawnand: renesas: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:06:18 +0200
Message-ID: <20250826110939.701271599@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 79e441ee47949376e3bc20f085cf017b70523d0f upstream.

The DMA map functions can fail and should be tested for errors.

Fixes: d8701fe890ec ("mtd: rawnand: renesas: Add new NAND controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/renesas-nand-controller.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mtd/nand/raw/renesas-nand-controller.c
+++ b/drivers/mtd/nand/raw/renesas-nand-controller.c
@@ -426,6 +426,9 @@ static int rnandc_read_page_hw_ecc(struc
 	/* Configure DMA */
 	dma_addr = dma_map_single(rnandc->dev, rnandc->buf, mtd->writesize,
 				  DMA_FROM_DEVICE);
+	if (dma_mapping_error(rnandc->dev, dma_addr))
+		return -ENOMEM;
+
 	writel(dma_addr, rnandc->regs + DMA_ADDR_LOW_REG);
 	writel(mtd->writesize, rnandc->regs + DMA_CNT_REG);
 	writel(DMA_TLVL_MAX, rnandc->regs + DMA_TLVL_REG);
@@ -606,6 +609,9 @@ static int rnandc_write_page_hw_ecc(stru
 	/* Configure DMA */
 	dma_addr = dma_map_single(rnandc->dev, (void *)rnandc->buf, mtd->writesize,
 				  DMA_TO_DEVICE);
+	if (dma_mapping_error(rnandc->dev, dma_addr))
+		return -ENOMEM;
+
 	writel(dma_addr, rnandc->regs + DMA_ADDR_LOW_REG);
 	writel(mtd->writesize, rnandc->regs + DMA_CNT_REG);
 	writel(DMA_TLVL_MAX, rnandc->regs + DMA_TLVL_REG);


