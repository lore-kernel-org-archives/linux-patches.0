Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D45A3FADF1;
	Thu, 30 Jul 2026 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423425; cv=none; b=Fsf4lpNle8+SgRwLS+M3FHLPn5irfhBfrwOGgo7mrZcPQ2bGETFMCDko90kZKhVNBgKugLwdaPhd7oKd2PAdf77v8gghQLn0jBvTYWYLGgi6tjsEZ9I1OGflxt8Iw9g1CqpUVIfaa+CCDdF8W9r2dMNPGFxJ6CvDMQ77Xbt39kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423425; c=relaxed/simple;
	bh=is+VWtq02EQlkORjaybxfkng+bRt38jfYsSepqdshko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDdorkpnkyBe0SpG2AiWe5H7jFm1UMkD2nUGkb9n3C2NmMt0JmGYkMAmukrfsstV3Rrz2sAra8wc71HYGayWPhPtogPJeSCii8hHDtT0bVwYomRGTGVEy1vofW2xzHCFCw78AT06qPtzNKsnq0Up8v5sL3Dxyd7rYWCE8k7YjXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eH36cCRX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eH36cCRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97EA1F000E9;
	Thu, 30 Jul 2026 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423424;
	bh=lop09a3cJiGAiUE3zulVkGNKQgMPHAkAe+d4MEGHI/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eH36cCRX6som6HHNjuZPJMeYVQxAmm1M2QsrxHZfdqq1ebStW3YrWO3pyDPOMcBdd
	 U5WsINkBwZJde3+d8qLHT/VSxW3BJv2maHEzGms3elF+HxgZdSPs7uJ2EIqHaaFzpU
	 JizIqqVGux88PbvA2XSD8a3KAkL3yKx0TRSsoftU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/675] mtd: nand: mtk-ecc: stop on ECC idle timeouts
Date: Thu, 30 Jul 2026 16:06:10 +0200
Message-ID: <20260730141445.972015979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



