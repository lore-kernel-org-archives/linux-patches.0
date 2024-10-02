Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE481D07BC;
	Wed,  2 Oct 2024 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879567; cv=none; b=coWEAQiQgOp4hER81NJ7ogafK5cW+tAYfBPoJnOhCP0mjVEDCvez4i0XE4RcL84GkLlxo6R9u/R0Q6aVUsqPSDWtUa/ySbs4FuYmg1136ZWqCaWwiTcbNTo07CZFI/BNSAb06Vfox1ZSgOd3Z1wveaDULMrznexmdo3P79Nbndc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879567; c=relaxed/simple;
	bh=OYQKhUj5mBRTYpKX3HQz7KoitK9XfHB8arAzcANLKr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7R/4UgLwx7paFoD/8dWDHIUEcOLcjpDhUVkFsSvg8a3GcUb+fe8fPT6+ai3JQj71sNJvgSsYC10QW0141y1ZGixS7Qa3uawhY1XgC0e4DqleW885SrYTH9mXZaz97AhE8DduAE9+OCBoBa6qswptLkZAQBzVbWOBOQ5Zc0zrnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Awnyptw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Awnyptw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FB4C4CEC2;
	Wed,  2 Oct 2024 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879567;
	bh=OYQKhUj5mBRTYpKX3HQz7KoitK9XfHB8arAzcANLKr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AwnyptweJm4KzB2hL+VaZ+4slsml6IeA9zn85fqvx2nbQDPv+OkvR+toCuFXeH+Y
	 VzcmdHtew0t9x0xIFqC/nloKOEh2fWgEB3fHBnzcDyUgYYepfUgWMSxOFOft83rTG/
	 iv0NbkRGvkmbCo6TGanS6b4/XZFo4GodMulEVwrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Matthias Brugger <matthias.bgg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/538] mtd: rawnand: mtk: Factorize out the logic cleaning mtk chips
Date: Wed,  2 Oct 2024 14:56:11 +0200
Message-ID: <20241002125757.450653531@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 81cb3be3261e766a1f8efab9e3154a4f4fd9d03d ]

There are some un-freed resources in one of the error path which would
benefit from a helper going through all the registered mtk chips one by
one and perform all the necessary cleanup. This is precisely what the
remove path does, so let's extract the logic in a helper.

There is no functional change.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Matthias Brugger <matthias.bgg@kernel.org>
Link: https://lore.kernel.org/linux-mtd/20240826153019.67106-1-miquel.raynal@bootlin.com
Stable-dep-of: 2073ae37d550 ("mtd: rawnand: mtk: Fix init error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/mtk_nand.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index c4ef4eae5da23..3fb32a59fdf61 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1429,6 +1429,23 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
 	return 0;
 }
 
+static void mtk_nfc_nand_chips_cleanup(struct mtk_nfc *nfc)
+{
+	struct mtk_nfc_nand_chip *mtk_chip;
+	struct nand_chip *chip;
+	int ret;
+
+	while (!list_empty(&nfc->chips)) {
+		mtk_chip = list_first_entry(&nfc->chips,
+					    struct mtk_nfc_nand_chip, node);
+		chip = &mtk_chip->nand;
+		ret = mtd_device_unregister(nand_to_mtd(chip));
+		WARN_ON(ret);
+		nand_cleanup(chip);
+		list_del(&mtk_chip->node);
+	}
+}
+
 static int mtk_nfc_nand_chips_init(struct device *dev, struct mtk_nfc *nfc)
 {
 	struct device_node *np = dev->of_node;
@@ -1567,20 +1584,8 @@ static int mtk_nfc_probe(struct platform_device *pdev)
 static void mtk_nfc_remove(struct platform_device *pdev)
 {
 	struct mtk_nfc *nfc = platform_get_drvdata(pdev);
-	struct mtk_nfc_nand_chip *mtk_chip;
-	struct nand_chip *chip;
-	int ret;
-
-	while (!list_empty(&nfc->chips)) {
-		mtk_chip = list_first_entry(&nfc->chips,
-					    struct mtk_nfc_nand_chip, node);
-		chip = &mtk_chip->nand;
-		ret = mtd_device_unregister(nand_to_mtd(chip));
-		WARN_ON(ret);
-		nand_cleanup(chip);
-		list_del(&mtk_chip->node);
-	}
 
+	mtk_nfc_nand_chips_cleanup(nfc);
 	mtk_ecc_release(nfc->ecc);
 }
 
-- 
2.43.0



