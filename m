Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50907225A38;
	Mon, 13 Apr 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097824; cv=none; b=e1LjGTo29QXjJaemkmacGoMbwSrdxqs7Dt2bwMFQujdfOPieJt4ORpGRA6LC81QC0+oA0GKcEOE/GeqxEtZ0QSkx3V6TP1tiQMtaNhpTriHXuY4ajplpLwdhyEM68FfzJhkMyTRKzvHMwSqcdjBmNJVqtNAdPY4QXg3QuPVB+78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097824; c=relaxed/simple;
	bh=V/xXh/wlgpQiZjBC953H2gKwdomgh7P60eIKBkZ6K70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXLsUYIfXzsOg1/UyfHanUsHKm/KbIsPuEFIK8jmFj/Y4Zo9ILCJQ7KQ7DyzQeBb93rbRxY0FPWUV9FVe9QWoCeaw6bUOkWl9sKZnHWDc2YALZIPRSXoOBYymCeCF8bcIbprHv5Mo96gv3yg9eE/JuDKrhnRfJYP/kBZ9MLtbr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnyXN/kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnyXN/kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABB9C2BCAF;
	Mon, 13 Apr 2026 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097824;
	bh=V/xXh/wlgpQiZjBC953H2gKwdomgh7P60eIKBkZ6K70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnyXN/kpGwjSCAWHkd5NVEJUtKEeONgAp61MNpEJEsro4AWW6V53/GHcULVqLex7W
	 FrgSwVHCSdDH7OG5EURhsRgDjSaggQ98AdXYLVQ3gYhPffSRH4a2r1skAha4yDLTOI
	 f6j5YnkSLR3ELJsKLAVSLlZSK6WzN3wEU98UMQgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/570] mtd: rawnand: brcmnand: skip DMA during panic write
Date: Mon, 13 Apr 2026 17:56:57 +0200
Message-ID: <20260413155841.205753278@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Dasu <kamal.dasu@broadcom.com>

[ Upstream commit da9ba4dcc01e7cf52b7676f0ee9607b8358c2171 ]

When oops_panic_write is set, the driver disables interrupts and
switches to PIO polling mode but still falls through into the DMA
path. DMA cannot be used reliably in panic context, so make the
DMA path an else branch to ensure only PIO is used during panic
writes.

Fixes: c1ac2dc34b51 ("mtd: rawnand: brcmnand: When oops in progress use pio and interrupt polling")
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Reviewed-by: William Zhang <william.zhang@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index aa89fcfd71ea0..4bf91b00a2183 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2399,14 +2399,12 @@ static int brcmnand_write(struct mtd_info *mtd, struct nand_chip *chip,
 	for (i = 0; i < ctrl->max_oob; i += 4)
 		oob_reg_write(ctrl, i, 0xffffffff);
 
-	if (mtd->oops_panic_write)
+	if (mtd->oops_panic_write) {
 		/* switch to interrupt polling and PIO mode */
 		disable_ctrl_irqs(ctrl);
-
-	if (use_dma(ctrl) && (has_edu(ctrl) || !oob) && flash_dma_buf_ok(buf)) {
+	} else if (use_dma(ctrl) && (has_edu(ctrl) || !oob) && flash_dma_buf_ok(buf)) {
 		if (ctrl->dma_trans(host, addr, (u32 *)buf, oob, mtd->writesize,
 				    CMD_PROGRAM_PAGE))
-
 			ret = -EIO;
 
 		goto out;
-- 
2.51.0



