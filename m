Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6763C21E098;
	Sat, 30 May 2026 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165960; cv=none; b=RAS79b5qzTQQGNY9AoHDSLj/JprLeBMKA97PbkP2Naj8jG4a5eDAZmUw1dYJ8Zfq3qpjLfpfNJNO8yiZPFG/N/WkqE8JcnZS9D/HIGDfU9jk0XEP5E/ZECEe4PNhuYL/VPiyujpxW2Kbheikn5yS5921op8wg3V3L0Hx9jmSJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165960; c=relaxed/simple;
	bh=a3ltCbPFd8OMLIOoLNMaIX/Lb1guvserTTMt1siOHw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sao+hLQ4yXtm0z8SKGLEaniJIqX1J5zpRqLhB+6Gdd32sBJl82k0N8TO2uAF1jvnasF80sYAYrxhG9AoQoZoKAaAS3LHLpLVBPcTUj6qbtn4kS9UM4Nh84+cZu6ft1yxk/kn/Nh12FL6LIxi2HvN4fMkm6AUS37DxS5Ju/VKEAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtW9lkel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtW9lkel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0951F00893;
	Sat, 30 May 2026 18:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165959;
	bh=U12pBnEw0cxFHo0s75xMRu1wLsy97nh2cARiFAX2MPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtW9lkelDSpvypArF18hTEZzXCJmbIeZHtw/ahHQWGGGvN+ul19OCBRsdUlLafmAa
	 haDsWlR2FYD6XzlI7rzSZUqBTh9HJhmVoqbcI07XPX/vKtfXwyN1jFQauQMbZMb4Ca
	 ygUXkFnTMaOkQvibWG2ppCZa1qGjJlWnMeiA9qzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjit Waghmode <ranjit.waghmode@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 232/589] spi: zynqmp-gqspi: fix controller deregistration
Date: Sat, 30 May 2026 18:01:53 +0200
Message-ID: <20260530160231.081726764@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

commit 6895fc4faafc9082e15e4e624b23dd5f0c98feb5 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: dfe11a11d523 ("spi: Add support for Zynq Ultrascale+ MPSoC GQSPI controller")
Cc: stable@vger.kernel.org	# 4.2: 64640f6c972e
Cc: stable@vger.kernel.org	# 4.2
Cc: Ranjit Waghmode <ranjit.waghmode@xilinx.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-26-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynqmp-gqspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1175,7 +1175,7 @@ static int zynqmp_qspi_probe(struct plat
 			    SPI_TX_DUAL | SPI_TX_QUAD;
 	ctlr->dev.of_node = np;
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_controller failed\n");
 		goto clk_dis_all;
@@ -1209,6 +1209,8 @@ static int zynqmp_qspi_remove(struct pla
 {
 	struct zynqmp_qspi *xqspi = platform_get_drvdata(pdev);
 
+	spi_unregister_controller(xqspi->ctlr);
+
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 	clk_disable_unprepare(xqspi->refclk);
 	clk_disable_unprepare(xqspi->pclk);


