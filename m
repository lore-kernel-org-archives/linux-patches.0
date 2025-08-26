Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C872D060B;
	Tue, 26 Aug 2025 13:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214886; cv=none; b=MeHj8jCgWf82W9PaZa77lMlxt0/NlHpXxzHxjmEVpf0KskmStUR+SNCFrEKpXKw0Jolp6DYaag/OnVJ97tAINO/EHHau8/o9JPgexC8YJZvWovCToDE256HVW2eD7l99c5/YscPsfxdp7DrxVNdW7MODWcHK0EKHOifnwWaDud8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214886; c=relaxed/simple;
	bh=iZYfWUmdZDqvvaHX1+y29MkitxNv9EUS9o/amOKAefo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SazPEUrFWHCRvlHowthZDd3OLD5U0VWw40Q7PTSp61Z//wIDMAALdHzvJKoM2aOzMPQA1LSNk09GPAPWzxWYNZQExzWb9Sr/iZU6JtBXi5BE4ug+hkF8xbkRKjR8J4xqRUutlyazwvPqUzAR0iZZY2xmGK5ot3KZeVlVHj9MIVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqqRdGmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqqRdGmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C89C4CEF1;
	Tue, 26 Aug 2025 13:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214885;
	bh=iZYfWUmdZDqvvaHX1+y29MkitxNv9EUS9o/amOKAefo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqqRdGmvUzWrPnreva9atx44BbIMmsP2fGFIFn2/9Ee0QF0bBpetL7bew/ACro8ui
	 BKfk4kX7XDYSdS2fXsReLFQNrWC0ArySHUATwT7eyBrhX3t0rzURUXsUOD6Xao2S/r
	 kxvN23kTfu/dcTXyZKDCyCWsaxc0QfM4V2nDza+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 306/482] mtd: rawnand: renesas: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:09:19 +0200
Message-ID: <20250826110938.359095714@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


