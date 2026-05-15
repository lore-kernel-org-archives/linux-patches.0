Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F073B9D91;
	Fri, 15 May 2026 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862388; cv=none; b=S8a7KrHrxXGfq/WOFiEGC9wQiFJTsMo/FxRZTKj6nS8csthRtqpedmKlTsMYwfogX+v9vY7fWiVgsVdtssmWG5ScK6noYtO7uJy1CDQrLC3OdQTkK9b6ej5gbrl7zX2VJT5rz5oFd1i8eGezWcp1qOttJM8N22jrFStK7hyrJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862388; c=relaxed/simple;
	bh=TCEWR1NZxo6zKg/Y3yvZcWJYlhO9HtyeNvtEOruhoAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRHR5GAtKI17Lnp3tMmROgWCN+5PG/iF1dDRuWK1Do2zeg/mf44J4UIuhjQ1HxDjPphsIf7N8BIWzd4v5/MTSahh1r1H94Tu82AAeKgCs3Qg5u2SS4Ay80aKQc7Is4u2CkA+mW1QnKpD+4GmwBQV/NhP3X+YQxLNIKgpVeuFVlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ogtvl12N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ogtvl12N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE9FC2BCB0;
	Fri, 15 May 2026 16:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862388;
	bh=TCEWR1NZxo6zKg/Y3yvZcWJYlhO9HtyeNvtEOruhoAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ogtvl12N9pCI9WUlHIghxp4Y/KvojSgXkMeWMOWGNOu2Rsf1naG8F7u3t7Ad3xDL3
	 JVaAo6sb8zS5uckSPz8Y3tUbOGz1rU+WF1cg/VIMJJFtLHeNZgViWwIN7Mk8MTJDXL
	 L/a6qLd0D3MzkInSy9pPTco0ptbwl2yLr89c58Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 029/201] spi: atmel: fix controller deregistration
Date: Fri, 15 May 2026 17:47:27 +0200
Message-ID: <20260515154659.164878139@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8d4de97e83520be89d0ff40610ca633b3963a7de upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 754ce4f29937 ("[PATCH] SPI: atmel_spi driver")
Cc: stable@vger.kernel.org	# 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-5-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-atmel.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1654,7 +1654,7 @@ static int atmel_spi_probe(struct platfo
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_free_dma;
 
@@ -1688,8 +1688,12 @@ static void atmel_spi_remove(struct plat
 	struct spi_controller	*host = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(host);
+
 	/* reset the hardware and block queue progress */
 	if (as->use_dma) {
 		atmel_spi_stop_dma(host);
@@ -1716,6 +1720,8 @@ static void atmel_spi_remove(struct plat
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static int atmel_spi_runtime_suspend(struct device *dev)


