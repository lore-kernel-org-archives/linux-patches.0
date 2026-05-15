Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6404EA380;
	Fri, 15 May 2026 16:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862440; cv=none; b=XhogsuMNYZQqEYnrYotGzSQTmLdJ84clwjcMyISCpjxtlWvjHDLY50Wj7Cl1HpP8Fu2GXodFsX3sxJwZd1MoXHzg3O5VLT8Yk4oy3wrKCZgf4e9XeVbQ4E48AcUmNvZIDB/JpPClgDSWrplVpl27kRpRU+lKVoCBQY80FHqvhdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862440; c=relaxed/simple;
	bh=xwM9E8BMSsNcz0+w3Hpk+V4yvW8iP5WGs/kLLZvxbCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2MqlcHJuIBngN9+ikTfDcEiCoMyG44xCbKd0ZU+32+JibXtw2hNEulOEH+7RcUHdSRgxazhxOcOg1caa1w2C5aPEYIwTXWEt6qvQcLylwZDAl6AJvoOPk7EN6ytCk3BRVtWE4/fYgU4C1ZYnpFR8C65j/MJkxZ59WDmNDyV5rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7/Rx7ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7/Rx7ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FC4C2BCB0;
	Fri, 15 May 2026 16:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862440;
	bh=xwM9E8BMSsNcz0+w3Hpk+V4yvW8iP5WGs/kLLZvxbCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7/Rx7ml6nJtQAQBiG8AC+hHqNN7DkxIEU55kCKzCPiDmU80boJ6R5CKOg/0xWEH5
	 GOiK4IFwHJcvC+bWSGIj5yXBsPCxYKpkgybyLph6bX7CEff8Kj3jZK9wZjnt4cjlBM
	 2lVHeA+YmfdIbkjBPxyzPZGR/9MDmCbqvMDRfigg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 050/201] spi: lantiq-ssc: fix controller deregistration
Date: Fri, 15 May 2026 17:47:48 +0200
Message-ID: <20260515154659.617744475@linuxfoundation.org>
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

commit b99206710d032c16b7f8b75e4bc18414d8e4b9f4 upstream.

Make sure to deregister the controller before releasing underlying
resources like clocks during driver unbind.

Fixes: 17f84b793c01 ("spi: lantiq-ssc: add support for Lantiq SSC SPI controller")
Cc: stable@vger.kernel.org	# 4.11
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-17-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-lantiq-ssc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-lantiq-ssc.c
+++ b/drivers/spi/spi-lantiq-ssc.c
@@ -994,7 +994,7 @@ static int lantiq_ssc_probe(struct platf
 		"Lantiq SSC SPI controller (Rev %i, TXFS %u, RXFS %u, DMA %u)\n",
 		revision, spi->tx_fifo_size, spi->rx_fifo_size, supports_dma);
 
-	err = devm_spi_register_controller(dev, host);
+	err = spi_register_controller(host);
 	if (err) {
 		dev_err(dev, "failed to register spi host\n");
 		goto err_wq_destroy;
@@ -1016,6 +1016,10 @@ static void lantiq_ssc_remove(struct pla
 {
 	struct lantiq_ssc_spi *spi = platform_get_drvdata(pdev);
 
+	spi_controller_get(spi->host);
+
+	spi_unregister_controller(spi->host);
+
 	lantiq_ssc_writel(spi, 0, LTQ_SPI_IRNEN);
 	lantiq_ssc_writel(spi, 0, LTQ_SPI_CLC);
 	rx_fifo_flush(spi);
@@ -1024,6 +1028,8 @@ static void lantiq_ssc_remove(struct pla
 
 	destroy_workqueue(spi->wq);
 	clk_put(spi->fpi_clk);
+
+	spi_controller_put(spi->host);
 }
 
 static struct platform_driver lantiq_ssc_driver = {


