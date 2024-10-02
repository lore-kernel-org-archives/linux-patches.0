Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A61B1D0412;
	Wed,  2 Oct 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875792; cv=none; b=ZucgDb/+DOTkk/7p2DwYfFksv/CvfUO/Mr6OCNl9xQRzaxsAaw60VNdsYMPjkXz+NPbWOqAJhiasYBL8u754YpO/gS4dnjgn1aW/yjJwMD8nm52tWRKkDNrg14wYwvYqQa9m/MHvv/v1IDwR6CXEWIFMPgnzm2ijBTkIOh8ASaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875792; c=relaxed/simple;
	bh=CNCDiK8oZCiBXolk22d/VrFgz9gsYRG+IPnObUqeeUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4cYGr+Z7zfNVQWEnyb6mDWYayvSVaMBTdo0VXpKzn9t/A6GE2TJKhipFiO2utrT5EhuCja5NQtkmtUTL0P/jU0blyv5hXwfzv9lyYUmfYGvQ/VuZXuLtu7oN/XVViwTdvVKyYqMlZjhgRAKHHUpymfWlp5XdmB3Kz1oZ2pUvZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5jtmhwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5jtmhwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC460C4CECD;
	Wed,  2 Oct 2024 13:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875792;
	bh=CNCDiK8oZCiBXolk22d/VrFgz9gsYRG+IPnObUqeeUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5jtmhwoMpRBRt60hHInxtjxBaRqJjOVFxvbOu1bzNvHvwms1YNrTHeWhJndgETh+
	 Jq+Q0jFIWe7B1sYZ0jDgHS6TSAnk7R9dnzr0l+5nBiRutFzcNaHIe9o0GpzUI4Rmrl
	 QiTpWiYcljdM8p1WguqfNfVIG6OEsSRC7LB72BIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Matthias Brugger <matthias.bgg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 191/695] mtd: rawnand: mtk: Factorize out the logic cleaning mtk chips
Date: Wed,  2 Oct 2024 14:53:09 +0200
Message-ID: <20241002125830.093306670@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d65e6371675bb..bf845dd167374 100644
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



