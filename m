Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C5126CE11;
	Fri, 15 May 2026 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862023; cv=none; b=oxXdZA9sVMsMbRK8R2fbH8xPXdqsTtwn2JKjUq+8yBitqIfWGXotoN+RCDfJaeVM7k4y6nbgG9tLWvygK8QZ/f96OeabPbOoQzRLJk2U6bT089PNGqraZI2WxAio1njCY4zAdh/rhgTsCfA0bMJlGzOojQsteEsGCxNKuSgUhO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862023; c=relaxed/simple;
	bh=/io5XgpOaPV598PPmO/HngyBXoeA4PGVpXI7EcyroAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJk7uTNNuXsIPkcaajMsX3fQiQ2CvEuKP8u+iq9fvFswm+2sVqm7zP4HoTlqE1hVPw+oMyb5idPTYjEOt8AyE/4VsFafgXp9+l8Arj/b3Yc02tfXNSmhQBN0BdWHLEqZtu1Jp2Yx0odRgF+ZJn2wgt4DiwhLWHGFTNcmEfHMXHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubynW9Ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubynW9Ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E034C2BCB0;
	Fri, 15 May 2026 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862023;
	bh=/io5XgpOaPV598PPmO/HngyBXoeA4PGVpXI7EcyroAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubynW9BaTmftaiojMmOL4UdZh4X0iTa2dV43e02VG+gDVsDqihznto3o9DguUAXa1
	 3nmE7IgFlKCg/g4GShS4wMzAo6hpR0AvhjImqk8TPC1ikhaUrJhPZYm5q7EvBjWDSj
	 IP3fWDwdZWqJf+pOIHMbdToVAlK4te/zV+KJOa0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purna Chandra Mandal <purna.mandal@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 079/188] spi: pic32-sqi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:16 +0200
Message-ID: <20260515154659.033412566@linuxfoundation.org>
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


