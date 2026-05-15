Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC193B19DE;
	Fri, 15 May 2026 16:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862802; cv=none; b=Jg0m0sjZOQHWWZhUqrR9StlzAzWRRtYFq2GQZ2ftXyp4diOqM8ARRPQW5+Zk7/LVAlIrnaq0S0BrbSq003ZLSKC19FZZ4qiO1RNf9kKAIsfPN+RNwkgPfvaEH374FMyK0OG3J2NmqcgCusBURndyrLlGIkqqXyx8uy629k6jQzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862802; c=relaxed/simple;
	bh=l7QSCD9z0MkKfg+23muROYEdaqBPnNfDoRSxF2F9pkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is0/r5pWSptwsVplNJ8bxeiyXseqUW4POSDAlH+Wke3e9ZLo0uMpv7DQX242+U/+ibT24uA/RPXIBgTrcPAPvUqaU1+2MRtQMQaJZqhWyQLI80BudjY1QnareM3zD0bOfHYJzMfQ5kCAhGW+hioc0gHETqzxcnGwQrUaMrThClY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrOnicJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrOnicJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25556C2BCC9;
	Fri, 15 May 2026 16:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862802;
	bh=l7QSCD9z0MkKfg+23muROYEdaqBPnNfDoRSxF2F9pkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrOnicJUcQuehCskNAgn8JB9yrzYjfBVOz3mRJ88yvewmo8xgkmFkbCj4gj55oJP5
	 jRqRbOGLsAJ4PyyZuNEPUqiD72t5RYd4QTctXsOiPj2S0fSQpCalpYYC5z8Gp7r1mI
	 6KUWld1IcKIdvf4zPqZTkhwjIA94KE4WjaHtQFD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keiji Hayashibara <hayashibara.keiji@socionext.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 189/201] spi: uniphier: fix controller deregistration
Date: Fri, 15 May 2026 17:50:07 +0200
Message-ID: <20260515154702.675544332@linuxfoundation.org>
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

[ Upstream commit 0245435f777264ac45945ed2f325dd095a41d1af ]

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Note that clocks were also disabled before the recent commit
fdca270f8f87 ("spi: uniphier: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: 5ba155a4d4cc ("spi: add SPI controller driver for UniPhier SoC")
Cc: stable@vger.kernel.org	# 4.19
Cc: Keiji Hayashibara <hayashibara.keiji@socionext.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-25-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-uniphier.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -746,7 +746,7 @@ static int uniphier_spi_probe(struct pla
 
 	host->max_dma_len = min(dma_tx_burst, dma_rx_burst);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_release_dma;
 
@@ -771,10 +771,16 @@ static void uniphier_spi_remove(struct p
 {
 	struct spi_controller *host = platform_get_drvdata(pdev);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	if (host->dma_tx)
 		dma_release_channel(host->dma_tx);
 	if (host->dma_rx)
 		dma_release_channel(host->dma_rx);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id uniphier_spi_match[] = {


