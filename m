Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44902EB5CE;
	Tue, 15 Jul 2025 13:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587652; cv=none; b=Lw2x1rUg7EMwjFxsMxWmX/zFNoFxA96U91xgcR9OOXGAI1T0Q7ci8H6JdXEL+hgUNhPITgJow5D65EljDi13x7Znrb+ZmHBMKrlPp58kqiGdmVpvBTMcg7KdeauuN23ycU5SQggvDUo+PRotGNCNCT7U+BJFKIaBUBLMgqJx/m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587652; c=relaxed/simple;
	bh=jC4tySXhEgKwxyS7GjOnfVD128U9hnKpE6m7fe522Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUFSeSclqQWUC94lR5JcMrj78HtAUYjeK3g8V6U/ta2TmT+zdGAaQQfNfu9v0/6EbpzPDxID671MspD/+S5Y3lngVGhooNnXykPow79QoUe01h1lM2Z6XHdvVANNTVpOGRWOeRYifhQFpLZ6UAMmi/rU6xDOkGIGy5m7MyCk/RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FA+BZoub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FA+BZoub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC39C4CEE3;
	Tue, 15 Jul 2025 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587652;
	bh=jC4tySXhEgKwxyS7GjOnfVD128U9hnKpE6m7fe522Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FA+BZoubnja4OI1xXuSxWRP+zVlTNTCa6tG0RYd6NSInuwdS66jwgTS/GasvdNLGm
	 CDWlWQxxXW9jz2GGxFEKfH9aOEw036kvuDbBwoXpSXLGgtv8x230SDby6hhgCfb7H7
	 SnTQUuseEj23bDYZStuCGjl2loLl2ODOKiRxeJMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/208] spi: spi-fsl-dspi: Clear completion counter before initiating transfer
Date: Tue, 15 Jul 2025 15:13:20 +0200
Message-ID: <20250715130814.585905304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/spi/spi-fsl-dspi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index eda7ed618369d..580fdcbcd9b6c 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -964,11 +964,20 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 		if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE) {
 			status = dspi_dma_xfer(dspi);
 		} else {
+			/*
+			 * Reinitialize the completion before transferring data
+			 * to avoid the case where it might remain in the done
+			 * state due to a spurious interrupt from a previous
+			 * transfer. This could falsely signal that the current
+			 * transfer has completed.
+			 */
+			if (dspi->irq)
+				reinit_completion(&dspi->xfer_done);
+
 			dspi_fifo_write(dspi);
 
 			if (dspi->irq) {
 				wait_for_completion(&dspi->xfer_done);
-				reinit_completion(&dspi->xfer_done);
 			} else {
 				do {
 					status = dspi_poll(dspi);
-- 
2.39.5



