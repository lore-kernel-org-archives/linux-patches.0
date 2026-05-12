Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7BA3EDE70;
	Tue, 12 May 2026 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608551; cv=none; b=uMBPipXyepwednmgmNMCbmGzeFl25PrTY37kLLnn0LaK8yy3tX+Zo+Tuo6VXRmAQm6PAyesABp8pXr0f0u/GnaGj0dkGfho5eXvy3loi0oJpJf/NrAg0Dxj3nvR7cNIQB7siy5IC8Wi6QjfYBQavl3WNZJrafd/SIoFf6GlMTqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608551; c=relaxed/simple;
	bh=VW22apXuoGghhVhKwhJA3kQvwTCcmmKra76IPvlPTsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEkytx8qI/tgZTMxpRwTmulDQXklUh0NXBaMVw8WCZCNA4FLt3Gc6cDKhHqTFoUtxgYcS03HIetBkcG0Ef/dfFpjeVYAIOZ1mSz4pgz8SBV6nfF1ZTVgHFUi0OhhGNzKT/tDSH2N1bE4lJ+Uo9ssmu6TGVHh43LKIyAlBWFydJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hwXVyZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hwXVyZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0350C2BD05;
	Tue, 12 May 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608551;
	bh=VW22apXuoGghhVhKwhJA3kQvwTCcmmKra76IPvlPTsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hwXVyZUjGE77D0WfpNsuA/4jw4o9K81rokMgT69n7MSZkp6AX3hQJnkaqxX2AZ10
	 hqIKd1Z8CF6EV08BfXZn/+58pgL/0dThJ868qD6KsX3ZEEFHEiNWxAzB8CK4Tsl9qM
	 U89y0wvL8XopBnK9shYSEzCrZ8hqht5ncnrfjGpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 081/270] spi: sun6i: fix controller deregistration
Date: Tue, 12 May 2026 19:38:02 +0200
Message-ID: <20260512173940.162478960@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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


