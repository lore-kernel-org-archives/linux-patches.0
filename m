Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02CF17C220;
	Fri, 15 May 2026 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860268; cv=none; b=RzkloL3CSwi80vDMDgDqOSTs2PNByYdtjxkaAac5nBy9LGXMLh50cSIq1nJR8ZLSwMfF9ESshFPWzNrfZvRbFQWjU0gfvicWP9qtXi25OKL2dfWnWD5Ggc6j/8NNja7OaY6rZpV1kTRnm1dLrweg6Xo9YQkSOgVzYOxtccFHK0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860268; c=relaxed/simple;
	bh=gKnWxwOM0C55MSFEE9xQU/hWQsx48yHhkznFblUZI1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGrNIOrifI7TbbsQm3G7w6Mb2q6ySDtwDRXp5EXHBZ9BwfoLBNhqIz8sNUkFyvIZn+kAXFsfNqvO1tn6fHJhaS3UvIwzGqRBcAUdnxyX1U6jfkiHoIcmRFTUUTIRaCA54xsv12MKcoHX2vUoZ8Smyo3b3tUOWvU2CoaFkdGoubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBxDCZSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBxDCZSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30EFC2BCC9;
	Fri, 15 May 2026 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860268;
	bh=gKnWxwOM0C55MSFEE9xQU/hWQsx48yHhkznFblUZI1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBxDCZSA+OIiltP9Zydq/Cj2hJbKZhrwDsIf7e22VXnpsUNRwy79Ys692qdXm1mLJ
	 o8xySbzABk5hVUFjm4y3fhNNHeoUdv+nvWofe5KEJSSdhjRMf8h00q0uVYSbYj7ASo
	 1iJ9JIDc+3iXZDiiiIwNfq8Zh1jMDJOvmtrTzKL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 024/144] spi: lantiq-ssc: fix controller deregistration
Date: Fri, 15 May 2026 17:47:30 +0200
Message-ID: <20260515154654.064245181@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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
@@ -995,7 +995,7 @@ static int lantiq_ssc_probe(struct platf
 		"Lantiq SSC SPI controller (Rev %i, TXFS %u, RXFS %u, DMA %u)\n",
 		revision, spi->tx_fifo_size, spi->rx_fifo_size, supports_dma);
 
-	err = devm_spi_register_controller(dev, host);
+	err = spi_register_controller(host);
 	if (err) {
 		dev_err(dev, "failed to register spi host\n");
 		goto err_wq_destroy;
@@ -1017,6 +1017,10 @@ static void lantiq_ssc_remove(struct pla
 {
 	struct lantiq_ssc_spi *spi = platform_get_drvdata(pdev);
 
+	spi_controller_get(spi->host);
+
+	spi_unregister_controller(spi->host);
+
 	lantiq_ssc_writel(spi, 0, LTQ_SPI_IRNEN);
 	lantiq_ssc_writel(spi, 0, LTQ_SPI_CLC);
 	rx_fifo_flush(spi);
@@ -1025,6 +1029,8 @@ static void lantiq_ssc_remove(struct pla
 
 	destroy_workqueue(spi->wq);
 	clk_put(spi->fpi_clk);
+
+	spi_controller_put(spi->host);
 }
 
 static struct platform_driver lantiq_ssc_driver = {


