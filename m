Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E9E1AAE02;
	Mon, 14 Oct 2024 14:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917671; cv=none; b=FwylvgTGcZni3NMoqzwFAUxZNfHACwIEMybywZyJ8AQ90majzRv8dTYArgp5eO5Vv16x9chqnhDb3XWbxy4t6wISCMmZ/cJuuPi3pzhe1k1hIwfm+a8PhXcB2eI3nJ57RR3gGzzhThSuSRBOaQoscet2ENktMZlWdZwdLMAZr0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917671; c=relaxed/simple;
	bh=RbEERxQFQZnYtsy29SH5sLye4HENN+ZVyfL4B4qUZ20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTC5L1rPtti2x1gOkQOcvtrpakxJE7Ybh1zpJOaS9OMvvN+JpVouf1qp7czvrKu3eo0V3OsEpCnIS6b7M+0gj2Uc6junh8dbSUAb/39Dwj40p+WhuKTmmf07E91VG236jHkYImpMCM8B4xEvvvJm5fPiO5OxMYAL+74doKV23QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPp4538d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPp4538d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05279C4CECF;
	Mon, 14 Oct 2024 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917671;
	bh=RbEERxQFQZnYtsy29SH5sLye4HENN+ZVyfL4B4qUZ20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPp4538d4f87NIuz2WjqSyWgNfNGMdoLwE1uVV3VlVBpCuVINVsx14wuPmDvoQ6+5
	 0VNpeZfn/DKd5aUFNX/zDvS8W/yeeKuO5yTaD2Y595IjysAOnV0NvL9TvgV8uv0ZLu
	 pu3ju1SB+uzGUjuCcFtfJSuBPw0ac5JRMspfFNCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Matthias Brugger <matthias.bgg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/798] mtd: rawnand: mtk: Factorize out the logic cleaning mtk chips
Date: Mon, 14 Oct 2024 16:10:54 +0200
Message-ID: <20241014141221.859561640@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 537ac81e661fc..3a2b801937398 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1456,6 +1456,23 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
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
@@ -1601,20 +1618,8 @@ static int mtk_nfc_probe(struct platform_device *pdev)
 static int mtk_nfc_remove(struct platform_device *pdev)
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
 	mtk_nfc_disable_clk(&nfc->clk);
 
-- 
2.43.0



