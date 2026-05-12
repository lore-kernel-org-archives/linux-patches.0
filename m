Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F90385D85;
	Tue, 12 May 2026 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607875; cv=none; b=QYZkk5kRZw+k83P3tXPO7tS9f1q3jtI8yM94xlBgegzSFnlebIYBtab4KWVRaNAXFww15sX9lXswI2OcsVxYYW/ARAMy2jIE3ASPmzoqSsW1XSLkFx8TC+blO69Z0ySOJZWBb4UKE1Mt0MA5kTqFfwW2FVMeoj1DYbVcRigyZLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607875; c=relaxed/simple;
	bh=DxoTHwV5Trm+WSbbODlftWg/zdUnPBDkyapzM63UYFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixdafjL5XlXFiWqwLc6c1VYcFupFchHOHtSttYJHTBSYO6PjjaN7zj6GC0TewmY4zBNR9PpbqgMQjc+tjfvWq8eOsILKutYkNlMfLqF4t9oj4puW5pa6CAtCa8xWoYkzR64xUWxY/40qxoSnq3mUyvt3J1Gm0g5Vocx5FANFIMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kud5dyf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kud5dyf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DE2C2BCB0;
	Tue, 12 May 2026 17:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607874;
	bh=DxoTHwV5Trm+WSbbODlftWg/zdUnPBDkyapzM63UYFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kud5dyf4DP6lx/fWaD4ABanyFcHe+2vpm4lC5FsriHlK1fJ+p20Xqxq8DlXPX/R1X
	 VowrPRSczE7/ccQ22INsa2BCu5orEl32DZFtKPl3jgDRjPvoZfPdsdge8ys8qFGR3b
	 KqIfwr0PyrqrJVQQwQ8xZQL1DKphB3DQIBb/NTOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 070/206] spi: sun6i: fix controller deregistration
Date: Tue, 12 May 2026 19:38:42 +0200
Message-ID: <20260512173934.329987185@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit d874a1c33aee0d88fb4ba2f8aeadaa9f1965209a upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 3558fe900e8a ("spi: sunxi: Add Allwinner A31 SPI controller driver")
Cc: stable@vger.kernel.org	# 3.15
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-20-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun6i.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -743,7 +743,7 @@ static int sun6i_spi_probe(struct platfo
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register SPI host\n");
 		goto err_pm_disable;
@@ -769,12 +769,18 @@ static void sun6i_spi_remove(struct plat
 {
 	struct spi_controller *host = platform_get_drvdata(pdev);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_force_suspend(&pdev->dev);
 
 	if (host->dma_tx)
 		dma_release_channel(host->dma_tx);
 	if (host->dma_rx)
 		dma_release_channel(host->dma_rx);
+
+	spi_controller_put(host);
 }
 
 static const struct sun6i_spi_cfg sun6i_a31_spi_cfg = {


