Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB192E6135;
	Tue, 15 Jul 2025 13:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586515; cv=none; b=JDCvrSaRIBcuQY7+IASY4flAHPwI6ltbbtYJmg6JlWCgnHvbRDiZfUzjTT7qsN6aaD4hEVMWY0MOo+EnwZUjP6lF1jMRuXpOFPlOvNib1/ErS6mlcrBF0LUpnQEZYUmDMrUUFTcZfob7O/RgQYJu3YfiUO09E5KLm0S9yOrjlYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586515; c=relaxed/simple;
	bh=7RkmQ0jxXwTK+kOy6o6Oj5i2pYfmVk2jw2V6F7a7ufA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRjhD4qYlsPpn/4pytHqPQ24w+qdiG9ju8XVCPk9TRE9aKjIwwTqjOocWJLEJQOHj8ndzHwzTmCUfVJMpCvrpX6lrhaxdKZAI+Jv+30do5y7pOoKImbcM2Y/eKnj3asLbtXGcYdkOtu3u4C+aMpYVyGUj6YUMS4i63h48qvaKPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtMEyNnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtMEyNnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080AEC4CEE3;
	Tue, 15 Jul 2025 13:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586515;
	bh=7RkmQ0jxXwTK+kOy6o6Oj5i2pYfmVk2jw2V6F7a7ufA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtMEyNnMQf3crxdr9E8n9cRiMuiI3gs8jbFVl/zQmJMIyaWrs2kWoPPHw+DIcTrHD
	 OdA+bIX9MemKSQ9qM3kYrrBKKhup1EnDsfrHEt1GfvEhqfFkNOesmrTF6/g0ImkJxd
	 D7tIXvC9DtXo6ioT95A92lk+hKe2YpGxBfJgyiFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/148] spi: spi-fsl-dspi: Clear completion counter before initiating transfer
Date: Tue, 15 Jul 2025 15:13:36 +0200
Message-ID: <20250715130804.078624486@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit fa60c094c19b97e103d653f528f8d9c178b6a5f5 ]

In target mode, extra interrupts can be received between the end of a
transfer and halting the module if the host continues sending more data.
If the interrupt from this occurs after the reinit_completion() then the
completion counter is left at a non-zero value. The next unrelated
transfer initiated by userspace will then complete immediately without
waiting for the interrupt or writing to the RX buffer.

Fix it by resetting the counter before the transfer so that lingering
values are cleared. This is done after clearing the FIFOs and the
status register but before the transfer is initiated, so no interrupts
should be received at this point resulting in other race conditions.

Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250627-james-nxp-spi-dma-v4-1-178dba20c120@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 7b62ecbe36321..de203b9e3f1b8 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -773,10 +773,28 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 		trans_mode = dspi->devtype_data->trans_mode;
 		switch (trans_mode) {
 		case DSPI_EOQ_MODE:
+			/*
+			 * Reinitialize the completion before transferring data
+			 * to avoid the case where it might remain in the done
+			 * state due to a spurious interrupt from a previous
+			 * transfer. This could falsely signal that the current
+			 * transfer has completed.
+			 */
+			if (dspi->irq)
+				reinit_completion(&dspi->xfer_done);
 			regmap_write(dspi->regmap, SPI_RSER, SPI_RSER_EOQFE);
 			dspi_eoq_write(dspi);
 			break;
 		case DSPI_TCFQ_MODE:
+			/*
+			 * Reinitialize the completion before transferring data
+			 * to avoid the case where it might remain in the done
+			 * state due to a spurious interrupt from a previous
+			 * transfer. This could falsely signal that the current
+			 * transfer has completed.
+			 */
+			if (dspi->irq)
+				reinit_completion(&dspi->xfer_done);
 			regmap_write(dspi->regmap, SPI_RSER, SPI_RSER_TCFQE);
 			dspi_tcfq_write(dspi);
 			break;
@@ -796,7 +814,6 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 		if (trans_mode != DSPI_DMA_MODE) {
 			if (dspi->irq) {
 				wait_for_completion(&dspi->xfer_done);
-				reinit_completion(&dspi->xfer_done);
 			} else {
 				do {
 					status = dspi_poll(dspi);
-- 
2.39.5



