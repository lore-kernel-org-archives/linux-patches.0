Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31F23431FE;
	Tue, 26 Aug 2025 13:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215958; cv=none; b=nXNAdkn8DB0UcvP2jRP3aV3v4zZAlC0hyHeAkHHEEwOTx7O+llkVeHMghSnb6g3si0yaGnW1ivQrlwX2629WVH/PLIhdcQQLL0y2SVeHWCyTUBnf9GorHUWSzfTex5BUhZgfBbh99MLHPEyFBbbZw11RPcKVn6lUv2VjQcUETGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215958; c=relaxed/simple;
	bh=IfXfa2yHT5+7dnVM8pUEZuNFzlGejP8Q/j+lmErukBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfCKuYI2gyWxdVY5sqijE55bi+2KSiTg09hWxvtAWx09yxI2xRXEo2X1vRRyrXHtCt+81PSfWMAoBAhweGDE/sXumk9jPZ7NWbBdQ82iM4mLdDsVBXqPcIQGmgFQkAfPvmlKPSGwyLHiqzuxHz1Rx+g+CAMysqJqfRXD+nR/eDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05jTPJ5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05jTPJ5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67165C4CEF1;
	Tue, 26 Aug 2025 13:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215958;
	bh=IfXfa2yHT5+7dnVM8pUEZuNFzlGejP8Q/j+lmErukBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05jTPJ5aelLsW/PNBxEy2LZgo5ND4HfYzxb0HJeEFmMspmQyoxK+p4f9faSzhBQ2Q
	 goBIhbhTZpij4MNp1DYDuY3I2i6vqQFzgg+ThPb0JYIE10wUMids2B8WBvR6HGmzj2
	 bf4+zNf0j5iIS4MU3ljXe0MBsqkUpq9+PSeLswyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/644] mtd: rawnand: atmel: Fix dma_mapping_error() address
Date: Tue, 26 Aug 2025 13:04:50 +0200
Message-ID: <20250826110951.374505153@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 73956a9f5449..060e2c11b8e0 100644
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



