Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EC61DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7VNRMHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E1BC433C7;
	Wed,  4 Oct 2023 18:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444193;
	bh=ANYR1BUoEdEAT8L1HwamQqO6oHAHDx6Z4EH84dbXAhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7VNRMHtjkhgaHaiLlVgeqmh8hLACexeAvNTnH/XFgPvh9lerlaDVfS5Sa/GbQZ/2
	 mT5NCq9jDXaTG2zVU76CfT5ovt3LVlnUdEN9J0uykhMqGqshBv48dMuM8mGSwqU+sJ
	 +Xl+yxOYzEFyYgPiWo41D4AEIGOB3n0P71O6xKZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schramm <t.schramm@manjaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 164/321] spi: sun6i: fix race between DMA RX transfer completion and RX FIFO drain
Date: Wed,  4 Oct 2023 19:55:09 +0200
Message-ID: <20231004175236.857197676@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Schramm <t.schramm@manjaro.org>

[ Upstream commit 1f11f4202caf5710204d334fe63392052783876d ]

Previously the transfer complete IRQ immediately drained to RX FIFO to
read any data remaining in FIFO to the RX buffer. This behaviour is
correct when dealing with SPI in interrupt mode. However in DMA mode the
transfer complete interrupt still fires as soon as all bytes to be
transferred have been stored in the FIFO. At that point data in the FIFO
still needs to be picked up by the DMA engine. Thus the drain procedure
and DMA engine end up racing to read from RX FIFO, corrupting any data
read. Additionally the RX buffer pointer is never adjusted according to
DMA progress in DMA mode, thus calling the RX FIFO drain procedure in DMA
mode is a bug.
Fix corruptions in DMA RX mode by draining RX FIFO only in interrupt mode.
Also wait for completion of RX DMA when in DMA mode before returning to
ensure all data has been copied to the supplied memory buffer.

Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
Link: https://lore.kernel.org/r/20230827152558.5368-3-t.schramm@manjaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun6i.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sun6i.c b/drivers/spi/spi-sun6i.c
index bc9c88dce067a..26abd26dc3652 100644
--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -106,6 +106,7 @@ struct sun6i_spi {
 	struct reset_control	*rstc;
 
 	struct completion	done;
+	struct completion	dma_rx_done;
 
 	const u8		*tx_buf;
 	u8			*rx_buf;
@@ -200,6 +201,13 @@ static size_t sun6i_spi_max_transfer_size(struct spi_device *spi)
 	return SUN6I_MAX_XFER_SIZE - 1;
 }
 
+static void sun6i_spi_dma_rx_cb(void *param)
+{
+	struct sun6i_spi *sspi = param;
+
+	complete(&sspi->dma_rx_done);
+}
+
 static int sun6i_spi_prepare_dma(struct sun6i_spi *sspi,
 				 struct spi_transfer *tfr)
 {
@@ -224,6 +232,8 @@ static int sun6i_spi_prepare_dma(struct sun6i_spi *sspi,
 						 DMA_PREP_INTERRUPT);
 		if (!rxdesc)
 			return -EINVAL;
+		rxdesc->callback_param = sspi;
+		rxdesc->callback = sun6i_spi_dma_rx_cb;
 	}
 
 	txdesc = NULL;
@@ -279,6 +289,7 @@ static int sun6i_spi_transfer_one(struct spi_master *master,
 		return -EINVAL;
 
 	reinit_completion(&sspi->done);
+	reinit_completion(&sspi->dma_rx_done);
 	sspi->tx_buf = tfr->tx_buf;
 	sspi->rx_buf = tfr->rx_buf;
 	sspi->len = tfr->len;
@@ -479,6 +490,22 @@ static int sun6i_spi_transfer_one(struct spi_master *master,
 	start = jiffies;
 	timeout = wait_for_completion_timeout(&sspi->done,
 					      msecs_to_jiffies(tx_time));
+
+	if (!use_dma) {
+		sun6i_spi_drain_fifo(sspi);
+	} else {
+		if (timeout && rx_len) {
+			/*
+			 * Even though RX on the peripheral side has finished
+			 * RX DMA might still be in flight
+			 */
+			timeout = wait_for_completion_timeout(&sspi->dma_rx_done,
+							      timeout);
+			if (!timeout)
+				dev_warn(&master->dev, "RX DMA timeout\n");
+		}
+	}
+
 	end = jiffies;
 	if (!timeout) {
 		dev_warn(&master->dev,
@@ -506,7 +533,6 @@ static irqreturn_t sun6i_spi_handler(int irq, void *dev_id)
 	/* Transfer complete */
 	if (status & SUN6I_INT_CTL_TC) {
 		sun6i_spi_write(sspi, SUN6I_INT_STA_REG, SUN6I_INT_CTL_TC);
-		sun6i_spi_drain_fifo(sspi);
 		complete(&sspi->done);
 		return IRQ_HANDLED;
 	}
@@ -665,6 +691,7 @@ static int sun6i_spi_probe(struct platform_device *pdev)
 	}
 
 	init_completion(&sspi->done);
+	init_completion(&sspi->dma_rx_done);
 
 	sspi->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 	if (IS_ERR(sspi->rstc)) {
-- 
2.40.1



