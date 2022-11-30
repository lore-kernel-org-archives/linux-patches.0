Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3F679C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F086C433D7;
	Wed, 30 Nov 2022 18:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834242;
	bh=HcP+71BM3SnGxy9OqCi44C8XtNSsKtqVG0uhMhAkcNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qj++1DQsL446iN3gZLMxA53vk2IXB6wlnM4SMFaLPsQyMF+gJjZZwXcreCxYswHR/
	 YjvB1Z+rWmNgPMDDWwyouZsaKjbGQvwUji+5m+YMq88JwMOuoLr9FMQJ59EkycT8T9
	 6KvN6gzjU6TQLF/aQywm3DZ7xuSd6NRIhamooV2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Fabio Estevam <festevam@gmail.com>,
	David Jander <david@protonic.nl>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.0 182/289] spi: spi-imx: spi_imx_transfer_one(): check for DMA transfer first
Date: Wed, 30 Nov 2022 19:22:47 +0100
Message-Id: <20221130180548.253428826@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit e85e9e0d8cb759013d6474011c227f92e442d746 upstream.

The SPI framework checks for each transfer (with the struct
spi_controller::can_dma callback) whether the driver wants to use DMA
for the transfer. If the driver returns true, the SPI framework will
map the transfer's data to the device, start the actual transfer and
map the data back.

In commit 07e759387788 ("spi: spi-imx: add PIO polling support") the
spi-imx driver's spi_imx_transfer_one() function was extended. If the
estimated duration of a transfer does not exceed a configurable
duration, a polling transfer function is used. This check happens
before checking if the driver decided earlier for a DMA transfer.

If spi_imx_can_dma() decided to use a DMA transfer, and the user
configured a big maximum polling duration, a polling transfer will be
used. The DMA unmap after the transfer destroys the transferred data.

To fix this problem check in spi_imx_transfer_one() if the driver
decided for DMA transfer first, then check the limits for a polling
transfer.

Fixes: 07e759387788 ("spi: spi-imx: add PIO polling support")
Link: https://lore.kernel.org/all/20221111003032.82371-1-festevam@gmail.com
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reported-by: Fabio Estevam <festevam@gmail.com>
Tested-by: Fabio Estevam <festevam@gmail.com>
Cc: David Jander <david@protonic.nl>
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20221116164930.855362-1-mkl@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 468ce0a2b282..d209930069cf 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1606,6 +1606,13 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
 	if (spi_imx->slave_mode)
 		return spi_imx_pio_transfer_slave(spi, transfer);
 
+	/*
+	 * If we decided in spi_imx_can_dma() that we want to do a DMA
+	 * transfer, the SPI transfer has already been mapped, so we
+	 * have to do the DMA transfer here.
+	 */
+	if (spi_imx->usedma)
+		return spi_imx_dma_transfer(spi_imx, transfer);
 	/*
 	 * Calculate the estimated time in us the transfer runs. Find
 	 * the number of Hz per byte per polling limit.
@@ -1617,9 +1624,6 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
 	if (transfer->len < byte_limit)
 		return spi_imx_poll_transfer(spi, transfer);
 
-	if (spi_imx->usedma)
-		return spi_imx_dma_transfer(spi_imx, transfer);
-
 	return spi_imx_pio_transfer(spi, transfer);
 }
 
-- 
2.38.1



