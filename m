Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3A136C9E5;
	Tue, 16 Jun 2026 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632541; cv=none; b=pybk75C0l0v139kKDfwOvhpFfHJYNG2lcJmavXDBM5x60wZ2OWpU7qGmpxRdcpsch3nT6jVgMDNoH7MEtCWde5quCemYrsPqyaUxOk54xTlJaFMhTK3RSf27LYJDc8XLQW2lmQxYfTtOSSICCwNsp1JNlckp/nV1vjwjDdoM7nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632541; c=relaxed/simple;
	bh=yRQr2GsynTTOCX70OAT6pQJh8iGzNu8JsehVgafUAWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kukSk6PbI1pRflgnQu3d2yAN7Jp1XW87nmuCjEa8kXeqm35WywCD2V+y50RCt3XIburSag/0p1XifHK/OzQsiQ9ewUe2nHwLdy1+ogl/tApUaHNmIgfS0CGkEy8LURrmXjSLAnXrTWLSm/bnzmXDJJ7QXEoPsgsSYTssNdxbars=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDUcfkBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDUcfkBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183B51F000E9;
	Tue, 16 Jun 2026 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632539;
	bh=HMv4w/PMpZZ4ntIMnYFdvIgGgppgKWwmK/Y3xrplMeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDUcfkBZcmfLi6zYFD0sFdMLFEIvSSGNDgtxFuJ2+1iRrWAuQmaVWCK2UbPpy+y6n
	 Qmx9EwN/pwMzQQR8VIrto4Qjbh+V7DnCiIeUHlntz89sIfcsIAJtBUyj8QDOJ4BVp7
	 s4XOC9DZdqlWProOmjyqDLkERGWqzjm6atLyVDkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 430/522] spi: lantiq-ssc: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:37 +0530
Message-ID: <20260616145146.087996431@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -997,7 +997,7 @@ static int lantiq_ssc_probe(struct platf
 		"Lantiq SSC SPI controller (Rev %i, TXFS %u, RXFS %u, DMA %u)\n",
 		revision, spi->tx_fifo_size, spi->rx_fifo_size, supports_dma);
 
-	err = devm_spi_register_master(dev, master);
+	err = spi_register_master(master);
 	if (err) {
 		dev_err(dev, "failed to register spi_master\n");
 		goto err_wq_destroy;
@@ -1021,6 +1021,10 @@ static int lantiq_ssc_remove(struct plat
 {
 	struct lantiq_ssc_spi *spi = platform_get_drvdata(pdev);
 
+	spi_master_get(spi->master);
+
+	spi_unregister_master(spi->master);
+
 	lantiq_ssc_writel(spi, 0, LTQ_SPI_IRNEN);
 	lantiq_ssc_writel(spi, 0, LTQ_SPI_CLC);
 	rx_fifo_flush(spi);
@@ -1031,6 +1035,8 @@ static int lantiq_ssc_remove(struct plat
 	clk_disable_unprepare(spi->spi_clk);
 	clk_put(spi->fpi_clk);
 
+	spi_master_put(spi->master);
+
 	return 0;
 }
 


