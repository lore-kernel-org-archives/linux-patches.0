Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440E12F5491;
	Tue, 31 Mar 2026 17:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976644; cv=none; b=fWTDmR6xg5NOkG7C49fSquQUz9aRcKv4n+keMIyB4iNyJTetMlFFuF2I6cx3GoNPMobmnjKykNgvDrFH5QjzlKp6jmgL4mOYVqNx0I7h0F2SJNO+munL43DOCM1sqPKZUIRncdegXVpW2+eQX/8uSbRToZMTeanCk4isx0RRiLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976644; c=relaxed/simple;
	bh=eYxi5crwyflC1V3vfJs97KjaV228/n8jTRthDgFX3Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh1VJd1OQX3uE2z6h6rzGsGPQgYMz+zBXcfURLIkH7ELhLEG3tSEMJ/fzFiPE7aozk8A292aZBXrbCqSN3wCG8k2x+/bbYIgz5A2POhDkD5hibKsQsbBPh7e6hINpD2uH6vy/bxlCKp4z+kW53ZiHHiybs0kFGfaLT2pMBqgYxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoogfQzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoogfQzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB65C19423;
	Tue, 31 Mar 2026 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976644;
	bh=eYxi5crwyflC1V3vfJs97KjaV228/n8jTRthDgFX3Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoogfQzCqgxxdn2bNqA++bjdgCaKoe1tATW70waNjvInwxgkRVS9i/nynKpLITpaQ
	 P5UC67Od7cT99TViopZZmjxhAxHvMIz2Yiiwb52Pkz+PCf6Vm2PX49u0n244UkyAfo
	 j0wmH8TrZv9HWoDNVsyyHWov+bKGgY0+I55CA0G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/309] spi: spi-fsl-lpspi: fix teardown order issue (UAF)
Date: Tue, 31 Mar 2026 18:21:16 +0200
Message-ID: <20260331161759.834265205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index 065456aba2aea..47d372557e4f6 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -972,7 +972,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 		enable_irq(irq);
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, controller);
+	ret = spi_register_controller(controller);
 	if (ret < 0) {
 		dev_err_probe(&pdev->dev, ret, "spi_register_controller error\n");
 		goto free_dma;
@@ -998,6 +998,7 @@ static void fsl_lpspi_remove(struct platform_device *pdev)
 	struct fsl_lpspi_data *fsl_lpspi =
 				spi_controller_get_devdata(controller);
 
+	spi_unregister_controller(controller);
 	fsl_lpspi_dma_exit(controller);
 
 	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
-- 
2.53.0



