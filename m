Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449B73F44CC;
	Fri, 15 May 2026 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862090; cv=none; b=p4oeFyC7dteYCZdinAFseY02qAPGWNV9Vo8CPsSBWR4PYfNeS3kR/gfQGDm6QzT3WS76D2AdSyxu0PqrVpgKnWRXINlGPkIclC4VBlK9ws4M53vABtd4MrxUohcee/jXF0cLza2S6vERxFKeaNte8puUVIAkDudShth8I21+Gn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862090; c=relaxed/simple;
	bh=l4oHMNpmuYFpfVkn0InMtH2x65sXa8vyVL5YQfWCFHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1xtCv/POLComb4jqvy4MZjH1wNCzWS5A7ExSdM5VGxoGqDSxtdUNiKO9slCap50iy8b1EX1GKcPNkRrGAiLrzvjjjSp4S+AbZzdZ6p6Tjz65839AeTXPM9CQPaaTNFa5JtSlETSTcWRgA0tCy6f9ubdgXMmkHVBHZIfI07rBy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgmhpUf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgmhpUf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5BDC2BCB0;
	Fri, 15 May 2026 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862090;
	bh=l4oHMNpmuYFpfVkn0InMtH2x65sXa8vyVL5YQfWCFHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgmhpUf7SrEKQToLXWV46HIfNA5R9wV4exwnEOHPJYqWLrjJzphy5HLr7VbR7NVpE
	 0rS69bXkmC4eiVbCt1APCnksLBZexzaYR16GcoDhL+8JHXESpsFVorl5OFSF/tbrEA
	 ExDazB4URC0tKTxh70xQxjRjvFq8BNdpZzuT7TLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 067/188] spi: fsl-espi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:04 +0200
Message-ID: <20260515154658.770128169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

commit e506a700a7ad229f5c8f01f4b8350119cccb4158 upstream.

Make sure to deregister the controller before disabling runtime PM
(which can leave the controller disabled) to allow SPI device drivers to
do I/O during deregistration.

Fixes: e9abb4db8d10 ("spi: fsl-espi: add runtime PM")
Cc: stable@vger.kernel.org	# 4.3
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-14-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-espi.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -719,7 +719,7 @@ static int fsl_espi_probe(struct device
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0)
 		goto err_pm;
 
@@ -783,7 +783,15 @@ static int of_fsl_espi_probe(struct plat
 
 static void of_fsl_espi_remove(struct platform_device *dev)
 {
+	struct spi_controller *host = platform_get_drvdata(dev);
+
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&dev->dev);
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM_SLEEP


