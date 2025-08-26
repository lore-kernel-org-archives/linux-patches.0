Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A3D18DF9D;
	Tue, 26 Aug 2025 11:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208383; cv=none; b=ccudqF+ckEyYy56EeZEISPsA5bTPYFP3c1wIWLi+8LaInSf2RBFhFu7gdDi4JVa7ooBRqU/2K1Nj+swbGR/3eLnu1S8jJsp7DIs9vlBbe1d3bft1pObUaVGe6/XKP34yx1q1cSoaNt2U+wIegmRfgkVrZ422gAGh/zPvh7YcBng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208383; c=relaxed/simple;
	bh=4WPodyJabJzLRSsHy+UYNBQ2r2zBr+1YDoNEHdDxsPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtymwHGVqG5WmYYII0NM4f6D/AyuHqE8Qp9MAntoI6/2Nc31J9EvQ60+x5DJv8OKvVzBfsM9qzJ/uM/vObFrExGEuj6G+/3a79V+8+xNW5N5xMWwtOKi7OZBUjEAKJExilmQoIy8JLU6jwqUIiJobAWlusS9BOfjNuDZxqu2DvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCcNpCYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCcNpCYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6073C4CEF1;
	Tue, 26 Aug 2025 11:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208382;
	bh=4WPodyJabJzLRSsHy+UYNBQ2r2zBr+1YDoNEHdDxsPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCcNpCYv0+bWsntlZENx8nlTUg1jfQ/Fkbzb+qzCkHzC/kPL2PcJBtiLDFDyOsuA6
	 tE8L6o3GGo38cxzCE40LCQzZSPSqRmm0JB3FcROpRUxHnwC4f5B4DZdZsOc5nJzhno
	 4p3AeiuLHFPvixj3d5Qg59iwtTKbZA7IkqCHB6Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 072/322] mtd: rawnand: renesas: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:08:07 +0200
Message-ID: <20250826110917.365003762@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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


