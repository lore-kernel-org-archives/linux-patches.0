Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5E837F8C2;
	Wed,  8 Apr 2026 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671910; cv=none; b=Vgtpq4EVs/y7v7A8U+p204w/bpAIuN1fA/VUbSws5n0BLcuH68btFAMJ9SnYOFFTllFJ7qpO6vD5kBeuYMc1yN8PsEt0k8/ncIFqrfcpOAGFlmTzTWAv/gFAmKc0L5mhOVSfcn65uu3wc5/TWZYz6cLvuZF6E33760p31r4aOAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671910; c=relaxed/simple;
	bh=VcZRfN19WlTqLnytL/YC+biLArvEvg/gJ3VkxMCuJn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2cLU0UTgYVOw0iMfruRqjNubM1y6Fiybdic5EgYnZpTIuytXYr/9jUsr0Db4YjZJtp2S/V9tQ5M1UsI+Wk2lqJ576a8LfCntDbqX4RG50GwTlwEXdF8fvTjmPIR0AbHAE34ieWF8w3cPJTjcz0q+pKSpAEqvxoBo0fiKh2rlA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4s341Gx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4s341Gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3177C19421;
	Wed,  8 Apr 2026 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671910;
	bh=VcZRfN19WlTqLnytL/YC+biLArvEvg/gJ3VkxMCuJn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4s341GxFS1Oc6k/eps5HhuYrZof2rzCfaowZf4dKGx8bpqBiJsDYlCfu7Ws+W8VG
	 iPqHuNvYxGPkXV8spH8rpBQMJKzS5aMo1OiSV8lc/Jz/wghY1hXHAxMfdZbQu842rN
	 TkC3qO4jtKmu0zGWepfpiOmttLNII03Ys7FG9rec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/312] spi: spi-fsl-lpspi: fix teardown order issue (UAF)
Date: Wed,  8 Apr 2026 20:00:05 +0200
Message-ID: <20260408175937.032777795@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit b341c1176f2e001b3adf0b47154fc31589f7410e ]

There is a teardown order issue in the driver. The SPI controller is
registered using devm_spi_register_controller(), which delays
unregistration of the SPI controller until after the fsl_lpspi_remove()
function returns.

As the fsl_lpspi_remove() function synchronously tears down the DMA
channels, a running SPI transfer triggers the following NULL pointer
dereference due to use after free:

| fsl_lpspi 42550000.spi: I/O Error in DMA RX
| Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[...]
| Call trace:
|  fsl_lpspi_dma_transfer+0x260/0x340 [spi_fsl_lpspi]
|  fsl_lpspi_transfer_one+0x198/0x448 [spi_fsl_lpspi]
|  spi_transfer_one_message+0x49c/0x7c8
|  __spi_pump_transfer_message+0x120/0x420
|  __spi_sync+0x2c4/0x520
|  spi_sync+0x34/0x60
|  spidev_message+0x20c/0x378 [spidev]
|  spidev_ioctl+0x398/0x750 [spidev]
[...]

Switch from devm_spi_register_controller() to spi_register_controller() in
fsl_lpspi_probe() and add the corresponding spi_unregister_controller() in
fsl_lpspi_remove().

Fixes: 5314987de5e5 ("spi: imx: add lpspi bus driver")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://patch.msgid.link/20260319-spi-fsl-lpspi-fixes-v1-1-b433e435b2d8@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index c0e15d8a913df..b3e6dcdb47f60 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -913,7 +913,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 		enable_irq(irq);
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, controller);
+	ret = spi_register_controller(controller);
 	if (ret < 0) {
 		dev_err_probe(&pdev->dev, ret, "spi_register_controller error\n");
 		goto free_dma;
@@ -942,6 +942,7 @@ static int fsl_lpspi_remove(struct platform_device *pdev)
 	struct fsl_lpspi_data *fsl_lpspi =
 				spi_controller_get_devdata(controller);
 
+	spi_unregister_controller(controller);
 	fsl_lpspi_dma_exit(controller);
 
 	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
-- 
2.53.0



