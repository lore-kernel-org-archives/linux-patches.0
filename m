Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E01B237164;
	Mon,  2 Jun 2025 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875812; cv=none; b=J3X9aDm+7Mk0WEyPnRqy8PDDRSFfJdcZ95x4SwPbLnI4LcLyKXEX2Sslix+W0QZgP8a5ku2rvvqqePRldOj0DmXVSnh2ODdj1UGUvYS+0bdYRba1qACXiWAio5oR4qNkSdlts2lw0CitaInUgFEzMKx2wM6sAQzKm+G/Fz27G+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875812; c=relaxed/simple;
	bh=Rft51Q/fl5pepx9p6AGzEB6Hlwhyz0UjDj0nG2K8Azo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmW09ANoFHmLDlZ3Sve5buN6/aTVU5XokT5oFAS2rhN+XyObAzm7h589ydO70c/Lz4ooX9PA39GxaXXTva881rQLZbYqDyMlCE3ITJVrhUvUX9w1w8NsuHHxx1hBEfz0THTsgdto5Tl/DrF+lHTVUosAzgkhFiJLF+0rl2GBRxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebxAlwBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebxAlwBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CCEC4CEEB;
	Mon,  2 Jun 2025 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875812;
	bh=Rft51Q/fl5pepx9p6AGzEB6Hlwhyz0UjDj0nG2K8Azo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebxAlwBVZhL6ei4h56nmqHJ4ofLP0UCo04+J0ADUdsyEZvH6vctQdrjIM2LgjPXhq
	 gbKTbEC5GkPqd51hTYmxmqimIrMLBqI1q7Og5bt/QRwXd4wzmyCSKXk2AggAD8HPnc
	 WlqJUVAO019mfBM0BIFfQog4/xpSEBdGIRx1LiG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/270] spi: spi-fsl-dspi: Reset SR flags before sending a new message
Date: Mon,  2 Jun 2025 15:48:56 +0200
Message-ID: <20250602134317.591687667@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit 7aba292eb15389073c7f3bd7847e3862dfdf604d ]

If, in a previous transfer, the controller sends more data than expected
by the DSPI target, SR.RFDF (RX FIFO is not empty) will remain asserted.
When flushing the FIFOs at the beginning of a new transfer (writing 1
into MCR.CLR_TXF and MCR.CLR_RXF), SR.RFDF should also be cleared.
Otherwise, when running in target mode with DMA, if SR.RFDF remains
asserted, the DMA callback will be fired before the controller sends any
data.

Take this opportunity to reset all Status Register fields.

Fixes: 5ce3cc567471 ("spi: spi-fsl-dspi: Provide support for DSPI slave mode operation (Vybryd vf610)")
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250522-james-nxp-spi-v2-3-bea884630cfb@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index fdfd104fde9e2..eda7ed618369d 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -956,6 +956,8 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 				   SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF,
 				   SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF);
 
+		regmap_write(dspi->regmap, SPI_SR, SPI_SR_CLEAR);
+
 		spi_take_timestamp_pre(dspi->ctlr, dspi->cur_transfer,
 				       dspi->progress, !dspi->irq);
 
-- 
2.39.5



