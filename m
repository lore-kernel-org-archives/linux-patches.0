Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832803FF1BD;
	Fri, 15 May 2026 16:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862653; cv=none; b=EqNd+s6/fPWR0s2dovBmcWfXMHSVEVoMjNXNmNlrs2cPg5d/a4SOQTGCFxCzk3czR+oLDuAiYVahQlohU3sGMAMzB5d+f99ceP+NFfS+6dcPlDkE/rvTrSY0+BYKVanIMZKDNTPoDvoeL8dNI/4qi2+VtDE4QAd4OC10onIxCE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862653; c=relaxed/simple;
	bh=g5buawMkLghtXhTZNf2OHY30VWHji0DmME9v8owy6KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3Q5Q5NNtyN2um3GfgsrXQQgktHq864Ivwf1jliGoXqcdHDB2j5EUXtte3Hiygsygvy4VRs13ZyzD22/NAo7rBU2Ga5R9vazPzStSd3I+Zb/Of3w0bWUUdT8/6uuPGF5NCxI0LHYLyJHyd8uFdRzBNTsBwT4IohXD6iMdyA8ZDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpYHy4c0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpYHy4c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165F2C2BCB0;
	Fri, 15 May 2026 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862653;
	bh=g5buawMkLghtXhTZNf2OHY30VWHji0DmME9v8owy6KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpYHy4c0EJL8t6HC9Q2zBGCNuGPlUGoysJgUtVMWzXBFU3TFA58K+0xUK3NZIob5K
	 GCSITXJBnnMFeVXRQimuKxk4rPACoRcoi/RJN5FrAkoEOAEEXjy7I+p43J/C+hsjNd
	 ySu/ZNJRpctfLthO7G+z7p+q8p4JT3i2bF0o0qY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 090/201] spi: ep93xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:28 +0200
Message-ID: <20260515154700.482431020@linuxfoundation.org>
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

commit f4838934b695a58eda0833583cb8028e73a19529 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 011f23a3c2f2 ("spi/ep93xx: implemented driver for Cirrus EP93xx SPI controller")
Cc: stable@vger.kernel.org	# 2.6.35
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-13-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ep93xx.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -689,7 +689,7 @@ static int ep93xx_spi_probe(struct platf
 	/* make sure that the hardware is disabled */
 	writel(0, espi->mmio + SSPCR1);
 
-	error = devm_spi_register_controller(&pdev->dev, host);
+	error = spi_register_controller(host);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register SPI host\n");
 		goto fail_free_dma;
@@ -713,7 +713,13 @@ static void ep93xx_spi_remove(struct pla
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct ep93xx_spi *espi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	ep93xx_spi_release_dma(espi);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id ep93xx_spi_of_ids[] = {


