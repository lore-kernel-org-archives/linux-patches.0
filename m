Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3C21B87F2;
	Tue, 12 Aug 2025 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022675; cv=none; b=Gl3BsiSucWTAh3NBsn76XuHw1w68qZyy1GMF0BTSWL94gu3HzACFE2zZFI4qRsbdRF7dnlaPV1CgH4fLb+4UNugjJ7coIcqUF8nsT59Iit6Q8tHyFkPLXpdsIhZFDznIK252aGjeOnJyBBpXJc1ca6yP80qyCIXIgGwcqiqYoxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022675; c=relaxed/simple;
	bh=UrfQNFk39M5q9uvHeT1MKNc/i7LvxBT5my1xJ3Ac0w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edoRh/Xi1/uczR8ygkXkfmRiK1lgIqrBfVhHV/mlM4Yv65jbhKVYCZmOCYmVaZHAgYToabL4NPWl6CUE3VX4IpR2AUGmJri6rpr5FPUegDl4liEbyNL87PHkMqVIiTxYDacGHzybxYYPcbtFcgzbxbIOan3jdU+gN4TITzGm9bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcEOSC8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcEOSC8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934C1C4CEF0;
	Tue, 12 Aug 2025 18:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022675;
	bh=UrfQNFk39M5q9uvHeT1MKNc/i7LvxBT5my1xJ3Ac0w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcEOSC8Fa1R+EwToA4CMvacbQ9tuBwUxH2bHZPNBKudQoc68JH8JPKanQV38Gq+bN
	 8qdCfiizXN6D5sauYFTtggQXBJnelFKS8Junwa8k0KWfhhkIu3JjPUEtBvqVp8+g0G
	 dxJfXWksQqZiydihp9HlxsitUr3aoJ0ME8wLewd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/369] mtd: rawnand: rockchip: Add missing check after DMA map
Date: Tue, 12 Aug 2025 19:28:43 +0200
Message-ID: <20250812173023.264403906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

[ Upstream commit 3b36f86dc47261828f96f826077131a35dd825fd ]

The DMA map functions can fail and should be tested for errors.

Fixes: 058e0e847d54 ("mtd: rawnand: rockchip: NFC driver for RK3308, RK2928 and others")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/rockchip-nand-controller.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/mtd/nand/raw/rockchip-nand-controller.c b/drivers/mtd/nand/raw/rockchip-nand-controller.c
index 51c9cf9013dc..1b65b3aa6aa2 100644
--- a/drivers/mtd/nand/raw/rockchip-nand-controller.c
+++ b/drivers/mtd/nand/raw/rockchip-nand-controller.c
@@ -656,9 +656,16 @@ static int rk_nfc_write_page_hwecc(struct nand_chip *chip, const u8 *buf,
 
 	dma_data = dma_map_single(nfc->dev, (void *)nfc->page_buf,
 				  mtd->writesize, DMA_TO_DEVICE);
+	if (dma_mapping_error(nfc->dev, dma_data))
+		return -ENOMEM;
+
 	dma_oob = dma_map_single(nfc->dev, nfc->oob_buf,
 				 ecc->steps * oob_step,
 				 DMA_TO_DEVICE);
+	if (dma_mapping_error(nfc->dev, dma_oob)) {
+		dma_unmap_single(nfc->dev, dma_data, mtd->writesize, DMA_TO_DEVICE);
+		return -ENOMEM;
+	}
 
 	reinit_completion(&nfc->done);
 	writel(INT_DMA, nfc->regs + nfc->cfg->int_en_off);
@@ -772,9 +779,17 @@ static int rk_nfc_read_page_hwecc(struct nand_chip *chip, u8 *buf, int oob_on,
 	dma_data = dma_map_single(nfc->dev, nfc->page_buf,
 				  mtd->writesize,
 				  DMA_FROM_DEVICE);
+	if (dma_mapping_error(nfc->dev, dma_data))
+		return -ENOMEM;
+
 	dma_oob = dma_map_single(nfc->dev, nfc->oob_buf,
 				 ecc->steps * oob_step,
 				 DMA_FROM_DEVICE);
+	if (dma_mapping_error(nfc->dev, dma_oob)) {
+		dma_unmap_single(nfc->dev, dma_data, mtd->writesize,
+				 DMA_FROM_DEVICE);
+		return -ENOMEM;
+	}
 
 	/*
 	 * The first blocks (4, 8 or 16 depending on the device)
-- 
2.39.5



