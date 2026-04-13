Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C24931F994;
	Mon, 13 Apr 2026 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099316; cv=none; b=VaL2QSeZKalhxefAGFRTgmwQDZzAmOF+NebzMy0+pEV7WYZ9plTOYcR5s0Ba5i61O3MucXlqKUjwKIKWazk6q9t7z9sSi/Xacmd5iUxS6K3Pvihryj4kL46opTtX/BkRtqae4t+YI8+QmLQpbWNgqKfeGu5eeLEqPk5i97+WHgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099316; c=relaxed/simple;
	bh=EaNCCGuPYNP4ri+jW+yTBvXWSYniK8uTCyq6MmjMpKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6ljH42s4EUjJWlgKUlJWkQ4nLcGU52J4AMdS2AFpduqCIYkmuM5yRw8rHosgPCMY6pfXwrUjJoenVZ4AG3TSpkAsjKGyaaKYlmRzRTj1bLUAS647QfREpskO8nFzv3yMOy+YXb85y4OXDvnfkCf5OvrAxO2VyZIVHkIkduc40M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuYNhwfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuYNhwfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FA8C2BCAF;
	Mon, 13 Apr 2026 16:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099316;
	bh=EaNCCGuPYNP4ri+jW+yTBvXWSYniK8uTCyq6MmjMpKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuYNhwfO58IM2GNIXBEE/n+qkcd530BAoXkVpRrEvqr58zZ8hEaqhagXodksO0GPu
	 V/F2JAnAehgJVhCpCw26viBMTvYth6lOxP4mUoSaAk2qmhSAyatt2IlofhiGGBkkLV
	 6F73HkKSBoMmSC7Cvxi79wVVpvYYgTQBHZjx35r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/491] spi: spi-fsl-lpspi: fix teardown order issue (UAF)
Date: Mon, 13 Apr 2026 17:58:59 +0200
Message-ID: <20260413155830.051734675@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
 drivers/spi/spi-fsl-lpspi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -914,7 +914,7 @@ static int fsl_lpspi_probe(struct platfo
 		enable_irq(irq);
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, controller);
+	ret = spi_register_controller(controller);
 	if (ret < 0) {
 		dev_err_probe(&pdev->dev, ret, "spi_register_controller error\n");
 		goto free_dma;
@@ -943,6 +943,7 @@ static int fsl_lpspi_remove(struct platf
 	struct fsl_lpspi_data *fsl_lpspi =
 				spi_controller_get_devdata(controller);
 
+	spi_unregister_controller(controller);
 	fsl_lpspi_dma_exit(controller);
 
 	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);


