Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114B925C804;
	Mon, 17 Aug 2026 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978982; cv=none; b=uglZJ4jSR+GX+uq8InA36mGNXoFBZngPsL+RsJ7G56xURs8C+ZFl4XL2EgoetRnXsp4rYguSaeM1DvGWKKD+dYMdbqAA5jKSmPutwxCWI0ydwFgwDAttYjlw0KIRx0Z3k3h9Gs8fpCKBk/36LEVW+pdFjUf+1CVn0Zo9OeFuQOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978982; c=relaxed/simple;
	bh=FagSqCj0Mg/aZSqe3WQkfOwP2J0irkB/FC/99JjGswU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPqa/zsnhmTzMl+zfFimZ3Y8K44qGv7Oemdtow8IOpX6WgM7ZKWb/sYzbU+MRecs2Zcsm5G+treM0RmoRBgA36mWi+OnPT5u9viY1lFQMTpVHkgx7uZ2qMkAP/TcACmC9GtZzTLee/iD0tAYaI8ZsZFGK52u4CIMBGfAMPhixcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJSYXSq1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJSYXSq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FBB1F000E9;
	Mon, 17 Aug 2026 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978981;
	bh=VPglO2sJMDSbQluD6FB9pDjVedSQHGnD93OmtI8mh40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJSYXSq1zdOb+v7CgdMQLoV9e2OM7HsuZK/X7ReZmWaxOEwX37JtgyxqTglUA8vX2
	 P2WBEbvHUaIF9hHpYJqafBJoQDs5VikGJpmvF75bI4Gwg0U0Y1Ubm68m90ssv58NZO
	 2yffszPPQ7bwoaXBu9lqI1Gv4S6sKU+cx7tFxh+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/609] mtd: nand: mtk-ecc: stop on ECC idle timeouts
Date: Mon, 17 Aug 2026 15:25:23 +0200
Message-ID: <20260817132544.143498780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9f9b201fe706a8..e2fb7596f49d71 100644
--- a/drivers/mtd/nand/ecc-mtk.c
+++ b/drivers/mtd/nand/ecc-mtk.c
@@ -115,8 +115,8 @@ static int mt7622_ecc_regs[] = {
 	[ECC_DECIRQ_STA] =      0x144,
 };
 
-static inline void mtk_ecc_wait_idle(struct mtk_ecc *ecc,
-				     enum mtk_ecc_operation op)
+static inline int mtk_ecc_wait_idle(struct mtk_ecc *ecc,
+				    enum mtk_ecc_operation op)
 {
 	struct device *dev = ecc->dev;
 	u32 val;
@@ -128,6 +128,8 @@ static inline void mtk_ecc_wait_idle(struct mtk_ecc *ecc,
 	if (ret)
 		dev_warn(dev, "%s NOT idle\n",
 			 op == ECC_ENCODE ? "encoder" : "decoder");
+
+	return ret;
 }
 
 static irqreturn_t mtk_ecc_irq(int irq, void *id)
@@ -304,7 +306,11 @@ int mtk_ecc_enable(struct mtk_ecc *ecc, struct mtk_ecc_config *config)
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
@@ -404,7 +410,9 @@ int mtk_ecc_encode(struct mtk_ecc *ecc, struct mtk_ecc_config *config,
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



