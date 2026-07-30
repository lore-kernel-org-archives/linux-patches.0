Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D330383983;
	Thu, 30 Jul 2026 15:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427045; cv=none; b=lPPio4s/Lfgx+Xg0H3SypKKAoa6srl5cEpz/5TKzMed7J3PfNeW4E9N5/DPryzGQGeN2Be0a30vMGynkON8Hh6fdRlBG02w0C0zzGtIlR9utKmXPEjghbAWF0tYh9ANHUKLbkrg7pDslLG59iHmVUwRMstW3rhDeHiMBTV2u1QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427045; c=relaxed/simple;
	bh=HV8l/ytYYQLDG0+9SYzVNFM5Cryygc8CBceLvBPs2h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJJDI53Fm+R6YVF2De5z+O7IbnP/KQEvcj0VV8IxwK+IySk1QXTI2myICJH+W44DRdOv8tvRi88LrEaAqjgR6B9K09AEvI2xOXPBfAIBKpBU13iOc+MNAC2eXu+U/L3JOLZZKe4I2xmKM81ZBYb+z8km3lpZCb5Uip/DgfxR7v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9xX0Z5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9xX0Z5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEEE1F00A3E;
	Thu, 30 Jul 2026 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427044;
	bh=QVTVz3US/KupgWn0ZBGHFwR+FOr8QUIft2rF4adikF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9xX0Z5u01TDfgDyRTXpJZicPXGcn00ToHxnlBU87lE+zZsHbiVON8k6q75FEfDIx
	 CDcPO4nKUOMW7/Mq8335rW70Mcp12CYW8sBfqWtFkVE6eWlJpB0J3eakN+Pyc1Fjn8
	 uXTLyyZq0NKHeUw2u6JgQIG2NpfcYvILnMmLiDuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/484] mtd: nand: mtk-ecc: stop on ECC idle timeouts
Date: Thu, 30 Jul 2026 16:08:49 +0200
Message-ID: <20260730141424.123011300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 16f7ec8d5dc100eafd2c8e06cd30340a30b104a1 ]

mtk_ecc_wait_idle() logs when the encoder or decoder does not become
idle, but returns void. Callers can therefore configure a non-idle ECC
engine or read parity bytes after an unconfirmed encoder idle state.

Return the idle poll result and propagate it from the enable and encode
paths that require the engine to be idle before continuing.

Fixes: 1d6b1e464950 ("mtd: mediatek: driver for MTK Smart Device")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/ecc-mtk.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/ecc-mtk.c b/drivers/mtd/nand/ecc-mtk.c
index c75bb8b80cc1e1..96703f0a418ea2 100644
--- a/drivers/mtd/nand/ecc-mtk.c
+++ b/drivers/mtd/nand/ecc-mtk.c
@@ -123,8 +123,8 @@ static int mt7622_ecc_regs[] = {
 	[ECC_DECIRQ_STA] =      0x144,
 };
 
-static inline void mtk_ecc_wait_idle(struct mtk_ecc *ecc,
-				     enum mtk_ecc_operation op)
+static inline int mtk_ecc_wait_idle(struct mtk_ecc *ecc,
+				    enum mtk_ecc_operation op)
 {
 	struct device *dev = ecc->dev;
 	u32 val;
@@ -136,6 +136,8 @@ static inline void mtk_ecc_wait_idle(struct mtk_ecc *ecc,
 	if (ret)
 		dev_warn(dev, "%s NOT idle\n",
 			 op == ECC_ENCODE ? "encoder" : "decoder");
+
+	return ret;
 }
 
 static irqreturn_t mtk_ecc_irq(int irq, void *id)
@@ -312,7 +314,11 @@ int mtk_ecc_enable(struct mtk_ecc *ecc, struct mtk_ecc_config *config)
 		return ret;
 	}
 
-	mtk_ecc_wait_idle(ecc, op);
+	ret = mtk_ecc_wait_idle(ecc, op);
+	if (ret) {
+		mutex_unlock(&ecc->lock);
+		return ret;
+	}
 
 	ret = mtk_ecc_config(ecc, config);
 	if (ret) {
@@ -412,7 +418,9 @@ int mtk_ecc_encode(struct mtk_ecc *ecc, struct mtk_ecc_config *config,
 	if (ret)
 		goto timeout;
 
-	mtk_ecc_wait_idle(ecc, ECC_ENCODE);
+	ret = mtk_ecc_wait_idle(ecc, ECC_ENCODE);
+	if (ret)
+		goto timeout;
 
 	/* Program ECC bytes to OOB: per sector oob = FDM + ECC + SPARE */
 	len = (config->strength * ecc->caps->parity_bits + 7) >> 3;
-- 
2.53.0



