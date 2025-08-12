Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF852E7BD4;
	Tue, 12 Aug 2025 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024642; cv=none; b=lfwSqTvcFiNNJasoW3To+ombK6kYD7kC8AaJ5rJ3vcG1lJr6Z9vMm5N6SZV6OHGEPuwn//TWwCJ4iftRbOfjRzXcO4K/isxjFBreBi3Bfx8meZWPREUcAJ/NHMZmdvwaIzax/wQPGHznHvnI/oPbtWPp7I8rXBOxTA6TVoJYyCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024642; c=relaxed/simple;
	bh=NpdngMKdrJgPjiu50cAZ/S68AJ4R4YeMmkrryfVIMnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLgdR38PqJI818p6MGsMfLRyYeiTscRR2OHDKNul63bKITu1WamPEM5V+A8dxqM121Fs4Mai3Wk23sihKMfguB6kkOvBROCcNFHHVzZRNM6dhJFvrC663Mzp7B4N7GgKfY5M/lF/EOHbAMqfFvoM4p7NFjNJ97g2xMQrukVOLy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVFWkIFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVFWkIFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A668C4CEF0;
	Tue, 12 Aug 2025 18:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024642;
	bh=NpdngMKdrJgPjiu50cAZ/S68AJ4R4YeMmkrryfVIMnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVFWkIFRiOGxRu37df+HanolPKKTti53e9KojVhz1SDJbEiRjaqdVLOJrECfWUHEn
	 hRigVZFb9jDrrOydiE04u6DMdvtVygfA3T40c2zBi1eUJubfXQb0lz6D4M0CQXBNtC
	 VNMJ6/GgIoxpr5FyKUkI9mP9o3nCXwK04G9LxSys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 434/627] mtd: rawnand: atmel: Fix dma_mapping_error() address
Date: Tue, 12 Aug 2025 19:32:09 +0200
Message-ID: <20250812173435.789353906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

[ Upstream commit e1e6b933c56b1e9fda93caa0b8bae39f3f421e5c ]

It seems like what was intended is to test if the dma_map of the
previous line failed but the wrong dma address was passed.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20250702064515.18145-2-fourier.thomas%40gmail.com
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index dedcca87defc..84ab4a83cbd6 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -373,7 +373,7 @@ static int atmel_nand_dma_transfer(struct atmel_nand_controller *nc,
 	dma_cookie_t cookie;
 
 	buf_dma = dma_map_single(nc->dev, buf, len, dir);
-	if (dma_mapping_error(nc->dev, dev_dma)) {
+	if (dma_mapping_error(nc->dev, buf_dma)) {
 		dev_err(nc->dev,
 			"Failed to prepare a buffer for DMA access\n");
 		goto err;
-- 
2.39.5



