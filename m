Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDB844AB64;
	Thu, 30 Jul 2026 15:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425360; cv=none; b=OarhIVylxHHu5c4kiaobOAEOg6d/hXU4qRUlNJrlS9oYuQwVT1D2AvVnOhTAUtH79JMaThrOrz/vvExvdxKc+f/YPlcW+6ekhpsQ5lF+LLxS3dZP0Oxkb7yynNjQcJDREZvyzMy7EpWyPdQ5/9Ztcqw14LQdLxNM+YZJJe71PTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425360; c=relaxed/simple;
	bh=b5XTVLeTzdsmy453rAsf1wNaV4XvdQ2sRULafmYT0hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEdBcFb/bdXo7bc+Clf6VUgIOnWLYmMoDkFRL/1OIpQX1+fbqRoCF3Z/i+1BAC9f5Tv2URY/AvI+vpcqmFm1DC3j1VS8GVPClaVfK8ll7wX+7eCVa/nLJ47yw0ejlToRImlKyWWdD0NJh8A1nnD/wYyxbi1BYAuGmAzOA2D+HQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbpvGFZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbpvGFZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25901F000E9;
	Thu, 30 Jul 2026 15:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425358;
	bh=Gg48sewXGdzdpVsoUachifoHgdaCpMhy68lkSnn9pK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HbpvGFZ1r/MvZJ52RRZnneOfX9jvaRg8u7seqdDmZlExiQVolZlxkbWKhPgS3U/Q0
	 1UtBnvGeySqk0YG5+1PjITJRCldKn8WtQA5F8S+Y9KYqYpgAFqNPSn28yOEZpmW1WK
	 YnxbJ+zb+GVIwCg0T43am3en6vvwgbfhOXr3y554=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/602] mtd: nand: mtk-ecc: stop on ECC idle timeouts
Date: Thu, 30 Jul 2026 16:07:12 +0200
Message-ID: <20260730141436.849658466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



