Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FF0371048;
	Wed, 20 May 2026 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301722; cv=none; b=XFUzUv4XVzMnaZ4qmwCKBtZq8BKHkobCbde80tjgq92NGtN+5sekj2oe9XGeNiafJCP/V23wQ8POrWWae/ZWhzU7CP4Y8lCu+PW0D/UFIQCAGfl/Okqi/D+jgYCCgh9Bqt/7ginlx+mDktmYWGBD/79Kkx5ZaA90P6lWzWg7oSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301722; c=relaxed/simple;
	bh=OwwhIz5dKWrxdNuJkjxiZPtSdOEsHvFhMdHK5OawJjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqCDlj8Kh4+MTTcyk9Ude9R7V911HZjYUk4a+c0zsbL+u3JjacsmfIZjAxbtUjHAfG77JEaQMGEGyxCvQKApKry3cnQyiY8fjAAGBUc+L073Wb6w70tF//pYIqpU9Rdd6pkLEurnlmEiVRhTLmbrwJM21aot6w4VdgPd+a8eADQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADZIhLHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADZIhLHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD0B1F000E9;
	Wed, 20 May 2026 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301720;
	bh=RZwMJyGIyoc+fdHsMY8FToa+FQBQWsHIWiuGP3JTUBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADZIhLHDKIwzfi+P3jHdNGEmWZjxJbRU5IPSgNBlXGK3vCEtjXsrpNEkqhNpxnIkD
	 HIOoL2so7yFEvyRV+IWKs5xFxDjK+afLo4kbjYn+ILBR+4z818ci1/IOmzSUkIO8Q+
	 RI4izXEtVMNUJxGENa8x1u+jVPOTFnP4T6/xGXhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yash Shah <yash.shah@sifive.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 663/666] spi: sifive: fix controller deregistration
Date: Wed, 20 May 2026 18:24:34 +0200
Message-ID: <20260520162125.660409995@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

[ Upstream commit 0f25236694a2854627c1597465a071e6bb6fe572 ]

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind.

Note that clocks were also disabled before the recent commit
140039c23aca ("spi: sifive: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: 484a9a68d669 ("spi: sifive: Add driver for the SiFive SPI controller")
Cc: stable@vger.kernel.org	# 5.1
Cc: Yash Shah <yash.shah@sifive.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-15-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sifive.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sifive.c
+++ b/drivers/spi/spi-sifive.c
@@ -393,7 +393,7 @@ static int sifive_spi_probe(struct platf
 	dev_info(&pdev->dev, "mapped; irq=%d, cs=%d\n",
 		 irq, host->num_chipselect);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "spi_register_host failed\n");
 		goto put_host;
@@ -412,8 +412,14 @@ static void sifive_spi_remove(struct pla
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct sifive_spi *spi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	/* Disable all the interrupts just in case */
 	sifive_spi_write(spi, SIFIVE_SPI_REG_IE, 0);
+
+	spi_controller_put(host);
 }
 
 static int sifive_spi_suspend(struct device *dev)


