Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E89355049;
	Fri, 15 May 2026 16:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862570; cv=none; b=vCk+EAiLK7jqTcRNTiZCoZmwL6ceTg5h/3kJ3xmMXck4JnuGorqqukbsEUYwyW8KNk9dwnY5Ae5DcFad9xAkii2g/SlxpG9sFa9rFg+wUzqM6qbhOn/YNas/wgmPML+njBgNb9jsBX4Why4XWLjOaDreD6Xw0+ENHEW1DuBAIvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862570; c=relaxed/simple;
	bh=0FS610BWkRv/vH7qG7FG+bXXotVV+3hsi9AyrjHGI+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwSPSR2565dWgnNisg0hMkiTWrJR4RVGw8ikpsrElWXifrFh/n9WFYIbF8xab3fKLkhrPTAmHBONsmh42rbKd1nqUktuaVyAS5ybtZk70kQQY9CWWHODPfyyiBJY7DiMyj2PUGiutL6bwkonOU340WxmBp35CQeSOvcYh1FeuWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwmBiqOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwmBiqOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DB3C2BCB0;
	Fri, 15 May 2026 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862570;
	bh=0FS610BWkRv/vH7qG7FG+bXXotVV+3hsi9AyrjHGI+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwmBiqOfab0hs9vpnYnsDDnTqC/LI0yKDjp2QWKOSHmUYfefCfvyVEBtqwVaHjKj1
	 Kxvj6sYCav2Ji2phIqkxgiiOvaSAJ+12DM3eo1brkXlf/LuUJPf5u5JuSDukfKFbTg
	 Z63lcnAJPrDw6GPLPNaKKmbkwFqyIe2XlMBaJ+iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purna Chandra Mandal <purna.mandal@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 100/201] spi: pic32-sqi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:38 +0200
Message-ID: <20260515154700.704412324@linuxfoundation.org>
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

commit 420df79d1a618951eb0eb4331df95c9f4f763b8b upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 3270ac230f66 ("spi: pic32-sqi: add SPI driver for PIC32 SQI controller.")
Cc: stable@vger.kernel.org	# 4.7
Cc: Purna Chandra Mandal <purna.mandal@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-8-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pic32-sqi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-pic32-sqi.c
+++ b/drivers/spi/spi-pic32-sqi.c
@@ -642,7 +642,7 @@ static int pic32_sqi_probe(struct platfo
 	host->prepare_transfer_hardware	= pic32_sqi_prepare_hardware;
 	host->unprepare_transfer_hardware	= pic32_sqi_unprepare_hardware;
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&host->dev, "failed registering spi host\n");
 		free_irq(sqi->irq, sqi);
@@ -665,9 +665,15 @@ static void pic32_sqi_remove(struct plat
 {
 	struct pic32_sqi *sqi = platform_get_drvdata(pdev);
 
+	spi_controller_get(sqi->host);
+
+	spi_unregister_controller(sqi->host);
+
 	/* release resources */
 	free_irq(sqi->irq, sqi);
 	ring_desc_ring_free(sqi);
+
+	spi_controller_put(sqi->host);
 }
 
 static const struct of_device_id pic32_sqi_of_ids[] = {


