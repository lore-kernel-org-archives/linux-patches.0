Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A4119ADA2;
	Thu,  6 Jun 2024 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683048; cv=none; b=S4Ki9Dh5RNsH3EilfFNYbv7MiU6GH3XGiDaXdTDPxc8LyeW9vAMBFeD89ZR6dP5bsEAl/hOmkidzTrLq//K3/HdLQlStL00BzL+KRbJw0y+30dnRsahFPIdQOn2omWW7DBBR/JPfwe3+qDLwJwyKEuswQoDSybwHJ2nFhpI8fC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683048; c=relaxed/simple;
	bh=ThaqRi+cN+Ptt8YfUNn6bb8SvXgkU88NOL9NTpRJhFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pzWlWuyo+CW5OwfL6O0DrG+TB86EHv4/PJ1U5h7RtC7HaV27DW9FrWUf6qRT6BgTUwNL0RtHdxSEBTlnwOQMpNPwnlbiiOBZDyj+0L8hirvQ4TGdGyGOeFV2H4e+WuEVFTGqselXvQrlDcfO0xbUUSp3pG7iQcEj5ZwzS5I8jfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxPS8wVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxPS8wVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997DEC4AF0A;
	Thu,  6 Jun 2024 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683048;
	bh=ThaqRi+cN+Ptt8YfUNn6bb8SvXgkU88NOL9NTpRJhFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxPS8wVH1rfEOfI0iTr7XdpKsEV4R7mYOHgoi3l324Kjmz9ProyPl5zXj7uDzhZCh
	 5rYZe/ItA4ISn3ApXnyysOIwyz+sUI2zNzFvXdTZjenax9Ol1X+Lwx67YKghjYhOWT
	 CE34XBHAF+PDku742CPGXbcGmq8QrtiwlHDIXI3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Leonard=20G=C3=B6hrs?= <l.goehrs@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 287/374] spi: stm32: Revert change that enabled controller before asserting CS
Date: Thu,  6 Jun 2024 16:04:26 +0200
Message-ID: <20240606131701.507920283@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit a827ad9b3c2fc243e058595533f91ce41a312527 ]

On stm32mp157 enabling the controller before asserting CS makes the
hardware trigger spurious interrupts in a tight loop and the transfers
fail. Revert the commit that swapped the order of enable and CS. This
reintroduces the problem that swapping was supposed to fix, which
however is less grave.

Reported-by: Leonard Göhrs <l.goehrs@pengutronix.de>
Link: https://lore.kernel.org/all/39033ed7-3e57-4339-80b4-fc8919e26aa7@pengutronix.de/
Fixes: 52b62e7a5d4f ("spi: stm32: enable controller before asserting CS")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://msgid.link/r/20240523103326.792907-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 4a68abcdcc353..e4e7ddb7524a9 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1016,8 +1016,10 @@ static irqreturn_t stm32fx_spi_irq_event(int irq, void *dev_id)
 static irqreturn_t stm32fx_spi_irq_thread(int irq, void *dev_id)
 {
 	struct spi_controller *ctrl = dev_id;
+	struct stm32_spi *spi = spi_controller_get_devdata(ctrl);
 
 	spi_finalize_current_transfer(ctrl);
+	stm32fx_spi_disable(spi);
 
 	return IRQ_HANDLED;
 }
@@ -1185,8 +1187,6 @@ static int stm32_spi_prepare_msg(struct spi_controller *ctrl,
 			 ~clrb) | setb,
 			spi->base + spi->cfg->regs->cpol.reg);
 
-	stm32_spi_enable(spi);
-
 	spin_unlock_irqrestore(&spi->lock, flags);
 
 	return 0;
@@ -1204,6 +1204,7 @@ static void stm32fx_spi_dma_tx_cb(void *data)
 
 	if (spi->cur_comm == SPI_SIMPLEX_TX || spi->cur_comm == SPI_3WIRE_TX) {
 		spi_finalize_current_transfer(spi->ctrl);
+		stm32fx_spi_disable(spi);
 	}
 }
 
@@ -1218,6 +1219,7 @@ static void stm32_spi_dma_rx_cb(void *data)
 	struct stm32_spi *spi = data;
 
 	spi_finalize_current_transfer(spi->ctrl);
+	spi->cfg->disable(spi);
 }
 
 /**
@@ -1305,6 +1307,8 @@ static int stm32fx_spi_transfer_one_irq(struct stm32_spi *spi)
 
 	stm32_spi_set_bits(spi, STM32FX_SPI_CR2, cr2);
 
+	stm32_spi_enable(spi);
+
 	/* starting data transfer when buffer is loaded */
 	if (spi->tx_buf)
 		spi->cfg->write_tx(spi);
@@ -1341,6 +1345,8 @@ static int stm32h7_spi_transfer_one_irq(struct stm32_spi *spi)
 
 	spin_lock_irqsave(&spi->lock, flags);
 
+	stm32_spi_enable(spi);
+
 	/* Be sure to have data in fifo before starting data transfer */
 	if (spi->tx_buf)
 		stm32h7_spi_write_txfifo(spi);
@@ -1372,6 +1378,8 @@ static void stm32fx_spi_transfer_one_dma_start(struct stm32_spi *spi)
 		 */
 		stm32_spi_set_bits(spi, STM32FX_SPI_CR2, STM32FX_SPI_CR2_ERRIE);
 	}
+
+	stm32_spi_enable(spi);
 }
 
 /**
@@ -1405,6 +1413,8 @@ static void stm32h7_spi_transfer_one_dma_start(struct stm32_spi *spi)
 
 	stm32_spi_set_bits(spi, STM32H7_SPI_IER, ier);
 
+	stm32_spi_enable(spi);
+
 	if (STM32_SPI_HOST_MODE(spi))
 		stm32_spi_set_bits(spi, STM32H7_SPI_CR1, STM32H7_SPI_CR1_CSTART);
 }
-- 
2.43.0



