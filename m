Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61FC279DB1;
	Mon, 23 Mar 2026 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279365; cv=none; b=jyVFV/AwzJExyGSn4vG1N5n1yJ6N34BxVyGt/bX7EAsjVhGyGKD4kuvEUjJVN1nBsbJJGhXpOqCYxglnHAyfjfypqX9d4GLvACgCCR15xQr6JRzLdPIBHbV5a3cVUxfgIJK26d6cKpFkuvmSqOhgQ4U1mYXqwRS0HXx6yZGvLg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279365; c=relaxed/simple;
	bh=E+IyMIZkfumY9brqDzJT7jAcl38xLdazqorq15nyFOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFoiSHtmpnVuSM8FhlZv7J0Gw3X2I9q1xQyIaxoLiKw1mBw0TNFyNj/45KHrIZ0ymPYgnTs/9mj7Be++Km0K4n1UjuIuIcN9Qq8rPW76FmRzaudr1E0W6qYg5eAsBnkFCPUbw1Fz4xtK4C+JXj9OTBJv/tn8N+ZEjdUUhI41qdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZqSwEUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZqSwEUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148ACC4CEF7;
	Mon, 23 Mar 2026 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279365;
	bh=E+IyMIZkfumY9brqDzJT7jAcl38xLdazqorq15nyFOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZqSwEURbKvk7cRZfK5jaGlGrrMQlIb6nZeZG6b/LNiS+UWUhL3GxuG4xThYjaJaw
	 w2OjHA3Ul8ytc4C3T8Ya/x6Mj05rRSN7ll5gmvWnd+z/T9rHDGeLDxrUPeMO5tnMLM
	 mC3FLXSJJlBtn0sUBYWY4OFXcrey0gQJrHLfXOG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 561/567] mtd: rawnand: brcmnand: skip DMA during panic write
Date: Mon, 23 Mar 2026 14:48:01 +0100
Message-ID: <20260323134547.910894812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 03d7e26d49537..ece399705bd73 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2411,14 +2411,12 @@ static int brcmnand_write(struct mtd_info *mtd, struct nand_chip *chip,
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



