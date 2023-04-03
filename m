Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1245612E
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3283CC433D2;
	Mon,  3 Apr 2023 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531688;
	bh=6VhpgjvJnis42Y1hg3Yd4OCu3JdcL2uLe+Izqj45V/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B92bMgHvI8Ab3/Yv/OduKv+vTa9onJn8ybYmc+om4xWhzxPPrqR6W4enEup6fLMkN
	 u24qjiaLygFXRZlO91h2onOjgSBGFwunN/AKZdGMhYO4f+FMp8BiQYGXIxJNktmaGQ
	 lHWLJ4UoxPJQ417A4fAWg7gTIwEtIosBq0hyynLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/104] mtd: rawnand: meson: invalidate cache on polling ECC bit
Date: Mon,  3 Apr 2023 16:09:06 +0200
Message-Id: <20230403140407.044476221@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arseniy Krasnov <avkrasnov@sberdevices.ru>

[ Upstream commit e732e39ed9929c05fd219035bc9653ba4100d4fa ]

'info_buf' memory is cached and driver polls ECC bit in it. This bit
is set by the NAND controller. If 'usleep_range()' returns before device
sets this bit, 'info_buf' will be cached and driver won't see update of
this bit and will loop forever.

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/d4ef0bd6-816e-f6fa-9385-f05f775f0ae2@sberdevices.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index a65aadb54af68..240b493abb86f 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -172,6 +172,7 @@ struct meson_nfc {
 
 	dma_addr_t daddr;
 	dma_addr_t iaddr;
+	u32 info_bytes;
 
 	unsigned long assigned_cs;
 };
@@ -499,6 +500,7 @@ static int meson_nfc_dma_buffer_setup(struct nand_chip *nand, void *databuf,
 					 nfc->daddr, datalen, dir);
 			return ret;
 		}
+		nfc->info_bytes = infolen;
 		cmd = GENCMDIADDRL(NFC_CMD_AIL, nfc->iaddr);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
@@ -516,8 +518,10 @@ static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
 	struct meson_nfc *nfc = nand_get_controller_data(nand);
 
 	dma_unmap_single(nfc->dev, nfc->daddr, datalen, dir);
-	if (infolen)
+	if (infolen) {
 		dma_unmap_single(nfc->dev, nfc->iaddr, infolen, dir);
+		nfc->info_bytes = 0;
+	}
 }
 
 static int meson_nfc_read_buf(struct nand_chip *nand, u8 *buf, int len)
@@ -706,6 +710,8 @@ static void meson_nfc_check_ecc_pages_valid(struct meson_nfc *nfc,
 		usleep_range(10, 15);
 		/* info is updated by nfc dma engine*/
 		smp_rmb();
+		dma_sync_single_for_cpu(nfc->dev, nfc->iaddr, nfc->info_bytes,
+					DMA_FROM_DEVICE);
 		ret = *info & ECC_COMPLETE;
 	} while (!ret);
 }
-- 
2.39.2



