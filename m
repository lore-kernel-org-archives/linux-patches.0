Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484AF46AA62;
	Tue, 21 Jul 2026 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648101; cv=none; b=WaCQrfoUi4+0rcAERcTrCpxHYYorf8xlBBv9Z41R2+xwc2dh2/chOkPYQzKPH7AmlcWIrqVh3gMUNZ96SGiw1+uGdBl9OVDdETq4xrfZUSImx7dvA6X+GcMUNZDrdYdZ8K+GUe/F/wHuyA9vyiUlXoxG5fUDc4EBlEvNdWZVIhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648101; c=relaxed/simple;
	bh=nq9RhjaJpPqMfVGF7H54OSlUdtOWoCVYee7UUsxSQuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8BptlS9q3frZQX1XxFr/lLES4HGbk8z7z6sDvBJQ7rsMlC+BkD5inJaKotHNyt84W0egW3uOnk1FC946x07aBx74PnqothLzxKSIKFuIdv3/DwFK2J/X1VndZwoTnPKWCF4fx9eatInJ2iIzmwN+J7DTfHnU9pP7tp79XARgQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4IS4/Z0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4IS4/Z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1531F00A3D;
	Tue, 21 Jul 2026 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648100;
	bh=/pnWlOe/NMsLN0Z9kHsxRFyjK5X5ISq0jbG6jnwk0dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4IS4/Z0N8aeeuOW1m29512r9cUZlvgxs0L2plynAKoXoqFiwMKxZwVh/A+Q1cSG3
	 z1l3jDwDiXLN2iQTKOHeax+NNqvi6of32CWE+rnkBTG7Rhhbei6MVVG8dT/oR+pa1J
	 2a87hKocZAdIkn+8EZ2esIWQrLBwF7beVg9SpIiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0071/2077] spi: atcspi200: fix use-after-free when driver unbind
Date: Tue, 21 Jul 2026 16:55:44 +0200
Message-ID: <20260721152554.366280483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 565bdf45125a05aa8f622f58f598283f46ba43f4 ]

DMA resource is initialized after SPI controller registration. So
when driver unbind, this can trigger a use-after-free when DMA is
torn down while the controller is still alive and triggers DMA transfers.

Fixes: 34e3815ea459 ("spi: atcspi200: Add ATCSPI200 SPI controller driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260417-atcspi-v1-1-854831667d63@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-atcspi200.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-atcspi200.c b/drivers/spi/spi-atcspi200.c
index 3832d9db3cbf84..c5cf1aa2d67438 100644
--- a/drivers/spi/spi-atcspi200.c
+++ b/drivers/spi/spi-atcspi200.c
@@ -575,12 +575,6 @@ static int atcspi_probe(struct platform_device *pdev)
 	if (ret)
 		goto free_controller;
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
-	if (ret) {
-		dev_err_probe(spi->dev, ret,
-			      "Failed to register SPI controller\n");
-		goto free_controller;
-	}
 	spi->use_dma = false;
 	if (ATCSPI_DMA_SUPPORT) {
 		ret = atcspi_configure_dma(spi);
@@ -591,6 +585,13 @@ static int atcspi_probe(struct platform_device *pdev)
 			spi->use_dma = true;
 	}
 
+	ret = devm_spi_register_controller(&pdev->dev, host);
+	if (ret) {
+		dev_err_probe(spi->dev, ret,
+			      "Failed to register SPI controller\n");
+		goto free_controller;
+	}
+
 	return 0;
 
 free_controller:
-- 
2.53.0



