Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8332C2AF06;
	Mon,  6 Jan 2025 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178711; cv=none; b=s6CgjOkOlIvPnpybiCNdyBB9nSTUAg3uGWeavlmGceWQxTJurVfh2UEj/vsaOJwUmgvPHcylXcoZeoXrp9fjWLNsktuSBrzRZUUqCIRF5ycSgD/UZOYdGKCQHf0gEBDYaLiNG1nEEHFok/OmKxK+sirVX+euN64l1Hqin8i68Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178711; c=relaxed/simple;
	bh=h+UMg+rWtcWwFCnaxH7wxmuK/+yoc6bUzdq4KG3r1QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+F29rwBdIN6um/jjt6QBhyLg9ApM5BW9hnDCS+3vmBl6S5Ce8D5fkj+dmLSn6C1/zuHwJDpStAuhV7y/2M+5mvu93w6nZqyRG7rRAr5ZpMkMVZwUgLFufF/Q1YsJQxaxvaZVL+L6iSu15E/mGfBjdm2zwuBdaVJ41qiJyL8aqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+1ug7wD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+1ug7wD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADADEC4CED2;
	Mon,  6 Jan 2025 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178711;
	bh=h+UMg+rWtcWwFCnaxH7wxmuK/+yoc6bUzdq4KG3r1QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+1ug7wD4GXEPh0H7l9APSGfxsCMO3jmRqB2hsU1qP2pH86ahENS25kSwjK6Ub6Mg
	 Bq52EEJ3dQBFT8Uz5D1B21quCCnnDl5sGlkp+6YxHcXnHv+zAvoPFLE8vANlmR28zn
	 3kleYs8oGJgX4on9CsU2ZVatQehGHwhnR+fpd2ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 065/168] mtd: rawnand: arasan: Fix missing de-registration of NAND
Date: Mon,  6 Jan 2025 16:16:13 +0100
Message-ID: <20250106151140.915394719@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Andrzejewski <maciej.andrzejewski@m-works.net>

commit 11e6831fd81468cf48155b9b3c11295c391da723 upstream.

The NAND chip-selects are registered for the Arasan driver during
initialization but are not de-registered when the driver is unloaded. As a
result, if the driver is loaded again, the chip-selects remain registered
and busy, making them unavailable for use.

Fixes: 197b88fecc50 ("mtd: rawnand: arasan: Add new Arasan NAND controller")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej Andrzejewski ICEYE <maciej.andrzejewski@m-works.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -1510,8 +1510,15 @@ disable_controller_clk:
 
 static int anfc_remove(struct platform_device *pdev)
 {
+	int i;
 	struct arasan_nfc *nfc = platform_get_drvdata(pdev);
 
+	for (i = 0; i < nfc->ncs; i++) {
+		if (nfc->cs_array[i]) {
+			gpiod_put(nfc->cs_array[i]);
+		}
+	}
+
 	anfc_chips_cleanup(nfc);
 
 	clk_disable_unprepare(nfc->bus_clk);


