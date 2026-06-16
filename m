Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659803DEAD8;
	Tue, 16 Jun 2026 19:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636641; cv=none; b=U8GpnU9RwARagdTqPOQ1gcdEl9LvG5fQtY/HL1HhuupqNw7P3MvhSquIwsFXvQNOdgrsngsY4twn4SXpdx83t0YnN8kycaGl3XmciZk/GBMcGJ0rIKsSNo/3Q7w7M0gMG0HVtAOaJ2TnvvoJjB4oHcXYv/MLIAAKJVpJ4kZGkb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636641; c=relaxed/simple;
	bh=ZqigasSOjEEe0hbCIm3CE02fiY9bL0cSMSyMD2lVFQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3Nfi1PN2Bo3Cef08xBblgAnl3vPytsYyY9jvrusicncR9HdoH9Qom55i0bbk/kWg6Fo/KxsTQN8nK6/+3nEAXwn6A2o3S1DwKxE7jG2jt6EfNOy4guiYzuz66XP/pjYsj9b8A9xwH9DSZ4eOaI4mIR+v3O8b5F2Zj7rbtvR+QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzqaaU7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzqaaU7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570B61F000E9;
	Tue, 16 Jun 2026 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636640;
	bh=aajQ19UjW11YvDf8z1zgdTLrZ8ovXFHgpuzsYzgSlVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzqaaU7Qkc5Osuz3rsXMS4sdNtKgebXSaaKwR9HksEHjyXVtz/dtLz9flkqelI8+Z
	 oZEIZWPxuJfdw0WoB/QOlJd02a6V++bx4rSeI6r0yD69WBeczx3MwnY11+gV9b5JaK
	 6sLa2uVTwsUVvZQvzLBsoB/DekWj4d1U0aTxW2ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/342] spi: lantiq-ssc: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:33 +0530
Message-ID: <20260616145101.285063242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b99206710d032c16b7f8b75e4bc18414d8e4b9f4 ]

Make sure to deregister the controller before releasing underlying
resources like clocks during driver unbind.

Fixes: 17f84b793c01 ("spi: lantiq-ssc: add support for Lantiq SSC SPI controller")
Cc: stable@vger.kernel.org	# 4.11
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-17-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ adapted spi_controller/host naming to spi_master/master and preserved the int-returning remove() with trailing return 0 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-lantiq-ssc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-lantiq-ssc.c
+++ b/drivers/spi/spi-lantiq-ssc.c
@@ -1003,7 +1003,7 @@ static int lantiq_ssc_probe(struct platf
 		"Lantiq SSC SPI controller (Rev %i, TXFS %u, RXFS %u, DMA %u)\n",
 		revision, spi->tx_fifo_size, spi->rx_fifo_size, supports_dma);
 
-	err = devm_spi_register_master(dev, master);
+	err = spi_register_master(master);
 	if (err) {
 		dev_err(dev, "failed to register spi_master\n");
 		goto err_wq_destroy;
@@ -1027,6 +1027,10 @@ static int lantiq_ssc_remove(struct plat
 {
 	struct lantiq_ssc_spi *spi = platform_get_drvdata(pdev);
 
+	spi_master_get(spi->master);
+
+	spi_unregister_master(spi->master);
+
 	lantiq_ssc_writel(spi, 0, LTQ_SPI_IRNEN);
 	lantiq_ssc_writel(spi, 0, LTQ_SPI_CLC);
 	rx_fifo_flush(spi);
@@ -1037,6 +1041,8 @@ static int lantiq_ssc_remove(struct plat
 	clk_disable_unprepare(spi->spi_clk);
 	clk_put(spi->fpi_clk);
 
+	spi_master_put(spi->master);
+
 	return 0;
 }
 


