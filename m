Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350B13FF1DE;
	Fri, 15 May 2026 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860281; cv=none; b=RElZ9M8ci4NLMiiN93kl/PUr0xfrXtzS6Nhr5tFxa2lpa8pROyUN7RauMym0DprK8P7vj+B8Obd5lsekh3VgNo8ZVIY5NtGkqFLj8bkVjd4e/25rsEBbAWbChHqpHhBGXNH8DgP9LqCNxqeXyEdAB8Z9TikMjGEF51qXw6AJpHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860281; c=relaxed/simple;
	bh=WjafgHJW0zut6JgazDykr9ewT6VKrROIq5Nc0MSY4Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jm8cAbYHUaYUlJ7dllE8486FUXiXoxIoaKl6YeKjV8b4VF0wESSLpXyOii88vQlMk/+Dy5+1qY5mUAi3N7kwPpjDeW3lsqqizIqZH+0mf9l4t8CR8PZztr1CE95uLCQ2TPjUQmgbK1rZ1c2fUa0bc+bpU0y4XUcMb149xE1Hqqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K74Xw0vX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K74Xw0vX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3B1C2BCB0;
	Fri, 15 May 2026 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860281;
	bh=WjafgHJW0zut6JgazDykr9ewT6VKrROIq5Nc0MSY4Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K74Xw0vXwubCUhgq8vLe3B7js2J1qC8U59030GhQlGQf+wk8dMNzHJtndQbU7qbn1
	 W0EM1N1JGZQA07MWJyuYsoJ0p5k/IKjrJ/IDeFenXIltsM0W3Z/qv5/7MPf4P/F8o2
	 WLp/g2Fy1y3/ElDwCMxJGS+EGfZLJyIq8FnZUeJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 029/144] spi: aspeed-smc: fix controller deregistration
Date: Fri, 15 May 2026 17:47:35 +0200
Message-ID: <20260515154654.184157578@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 1044e5a4ccd57bf5a64f90100a321b498e0267a2 upstream.

Make sure to deregister the controller before disabling it to allow
SPI device drivers to do I/O during deregistration.

Fixes: e3228ed92893 ("spi: spi-mem: Convert Aspeed SMC driver to spi-mem")
Cc: stable@vger.kernel.org	# 5.19
Cc: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-aspeed-smc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-aspeed-smc.c
+++ b/drivers/spi/spi-aspeed-smc.c
@@ -733,7 +733,7 @@ static int aspeed_spi_probe(struct platf
 		return -ENOMEM;
 
 	aspi = spi_controller_get_devdata(ctlr);
-	platform_set_drvdata(pdev, aspi);
+	platform_set_drvdata(pdev, ctlr);
 	aspi->data = data;
 	aspi->dev = dev;
 
@@ -772,7 +772,7 @@ static int aspeed_spi_probe(struct platf
 	ctlr->num_chipselect = data->max_cs;
 	ctlr->dev.of_node = dev->of_node;
 
-	ret = devm_spi_register_controller(dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret)
 		dev_err(&pdev->dev, "spi_register_controller failed\n");
 
@@ -781,7 +781,10 @@ static int aspeed_spi_probe(struct platf
 
 static void aspeed_spi_remove(struct platform_device *pdev)
 {
-	struct aspeed_spi *aspi = platform_get_drvdata(pdev);
+	struct spi_controller *ctlr = platform_get_drvdata(pdev);
+	struct aspeed_spi *aspi = spi_controller_get_devdata(ctlr);
+
+	spi_unregister_controller(ctlr);
 
 	aspeed_spi_enable(aspi, false);
 }


