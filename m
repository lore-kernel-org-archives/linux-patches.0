Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6A5187554;
	Tue, 26 Aug 2025 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213620; cv=none; b=nSWdr8irJ8VpRbxO3QP4P5+dKY12K2u+F3dpFvwTIIN+T6sG6YPJZYumSGRVyAuOxLtk8K2rfdzYtivNPcXzCX56StgNnoe9S+br6kevYg8iziK/dcpQ2hJMqahcQNGCM306HVTsfIpcGw6tZk+R+U+s+jwiAVSWo3gLT9a3Cjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213620; c=relaxed/simple;
	bh=kh2t8/dauVWhGcidylulSewL1u57yfjBLGK9jaaD54o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUZQYM/7rcUZTB+jp2E7ddU1ehpftcOBN/Usp9Su+Jk4EsD0oHXnpkbw6v/pKjHpK5De70sV7n0GDDOI4WvemSPxdiDtaMR4vzhrxGsxAkWYaqOYUTogWDb3fCu3ApAjE2a5/yRYE5tqo56bcJg8C3U2wTXSf2nEjTOrw+CHbvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpXv8H3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpXv8H3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1420C4CEF1;
	Tue, 26 Aug 2025 13:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213620;
	bh=kh2t8/dauVWhGcidylulSewL1u57yfjBLGK9jaaD54o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpXv8H3kbc22YejJhWF/Nr34I4uIX36cmRgeYATkTcXW8N8i1A/2nJCSxyUKE9EGp
	 0G4LHoxMpiNJ8dRnOSo7gdOIMQ5ang+JUDRiy2hn8qo2BnkXMzUBkWYVqaZFRLs3Ja
	 eA1eWHrn/AC2Mrlm/mUFPE+wkAEy5ateewSkNB58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 383/587] mtd: rawnand: renesas: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:08:52 +0200
Message-ID: <20250826111002.651706632@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


