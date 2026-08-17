Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5492C1594;
	Mon, 17 Aug 2026 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975393; cv=none; b=DEzt9osLw9Jh/Xqx/mh+BQpVvlZZLXjdQO6n5c+JM4QLP/4eDz0OEjkdGVRJ5qNpkIhr/+Muah1G0zF5PXBTNvifCVVpaHBgNuJrZtQpgahhCP0qOmWxwP/7hT+hLduowsXZT7xe9y0Su4NTdowlzFh0FOECnTNSoFi8bvUbi1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975393; c=relaxed/simple;
	bh=bpbMUHYfLrhQQG20cMz5Hquy/ZaeIVfN4QojXnlXa/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgGR847QT2UHo5jHDqmeL6ky/MIOXyueBUmoemVzQ72zaIsAEbKuQDoUP58EAuZ3kAXwBMYrDr2MD0OGoNxZ8pxKgRHvUcnM9hSlULb8zRiQlSMz4lDg+fZpsdaCxoYM0NuIT2pEeWdtSnIAdm/YmdEJhz3OSk4m1Z/iLGogncc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxnr+WTK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxnr+WTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06F41F000E9;
	Mon, 17 Aug 2026 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975392;
	bh=NCVMlK1hQNYMB5RnEWuMiuT48dqMln2it7W21TlypUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxnr+WTKKxrQk4BnZ6cljlNx1VTQWffLUs71C7gmpDXRUPDUKHnJF03tMu9+9PJcz
	 LR7EiKZhFForYQJsNSABzUXbxXr/1kH/CSMHdrUC89hp7sWExoEESGn7CVmRsifC91
	 X+t3Ek2jq2a8aHlgM5JlfcLkizqYB1l3mL1oUzqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/389] mtd: nand: mtk-ecc: stop on ECC idle timeouts
Date: Mon, 17 Aug 2026 15:27:32 +0200
Message-ID: <20260817132539.366599321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/mtd/nand/raw/mtk_ecc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/mtk_ecc.c b/drivers/mtd/nand/raw/mtk_ecc.c
index c115e03ede889b..c60e04cdf03a52 100644
--- a/drivers/mtd/nand/raw/mtk_ecc.c
+++ b/drivers/mtd/nand/raw/mtk_ecc.c
@@ -116,8 +116,8 @@ static int mt7622_ecc_regs[] = {
 	[ECC_DECIRQ_STA] =      0x144,
 };
 
-static inline void mtk_ecc_wait_idle(struct mtk_ecc *ecc,
-				     enum mtk_ecc_operation op)
+static inline int mtk_ecc_wait_idle(struct mtk_ecc *ecc,
+				    enum mtk_ecc_operation op)
 {
 	struct device *dev = ecc->dev;
 	u32 val;
@@ -129,6 +129,8 @@ static inline void mtk_ecc_wait_idle(struct mtk_ecc *ecc,
 	if (ret)
 		dev_warn(dev, "%s NOT idle\n",
 			 op == ECC_ENCODE ? "encoder" : "decoder");
+
+	return ret;
 }
 
 static irqreturn_t mtk_ecc_irq(int irq, void *id)
@@ -302,7 +304,11 @@ int mtk_ecc_enable(struct mtk_ecc *ecc, struct mtk_ecc_config *config)
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
@@ -402,7 +408,9 @@ int mtk_ecc_encode(struct mtk_ecc *ecc, struct mtk_ecc_config *config,
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



