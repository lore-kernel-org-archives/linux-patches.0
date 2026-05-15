Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3CC3FBB55;
	Fri, 15 May 2026 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861916; cv=none; b=s/hB4VipPwW7EJ8UnkHztkxHGHu4NjwfET4I+CIkxERAAXRHKEf+WqCscmUChXAdO9hLMQc3ObzHCetVT914xPpxeOXeX76lTe9RIOCEkIRl8cEOobdOHvKWwu6RP7IcOg120L+pAGAghPv76hbP9brC+TZpnc8TeeCcj1PUH+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861916; c=relaxed/simple;
	bh=LRptmQ1SRm136kPFDVeEcfe96vov2128wJySPVCwwyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzuLI5qXS3ImZQNUghlgNdrYM7XDuXdcx4fgA/RYIW+712IlH3AxQGKPgNlULoEoJfcbaC0VylvZg6tYe+aiyi3lcRW4+Z/018Tgnm5gYPw5DWDuApKMFjQnrFfVgIgFxkR/hnZcPssswmxTiZRtUFGGQvRm7XvUBd0x3F4Sm5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7n01s5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7n01s5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DC8C2BCB0;
	Fri, 15 May 2026 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861916;
	bh=LRptmQ1SRm136kPFDVeEcfe96vov2128wJySPVCwwyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7n01s5BXp1YtdSAlAuBXkYFjJwKnNHK4/DtmGaJFI5qcsPHCFD6OjPI1/CpExHye
	 +QliSTGr4QwaBHSEfKzBCr6Y50AcEVaGihU2r2Bs5zlO9lDIva8b0lK1Vlx4F+g9P5
	 0vbKUK4kTcV04ajTBbR8PtxeYNjcftuNUHCqDtyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 037/188] spi: lantiq-ssc: fix controller deregistration
Date: Fri, 15 May 2026 17:47:34 +0200
Message-ID: <20260515154658.113703800@linuxfoundation.org>
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


