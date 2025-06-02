Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D32253EE;
	Mon,  2 Jun 2025 15:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877417; cv=none; b=KthrLa0tFZy61z6ARyyKyQnsq0JcdMSXGyG0Zgn6kp/WPXaXl6tTDkIHdLBGGZufiSW3Oxl/Xl6eN3I7juPbF7OHSNlYU0FJyM8E+de878sO5ICB3zN6Mgzl0JQXMay1pospW1cdgzdYuqfCxN0v7dss5EQldlrsXJkr11N09l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877417; c=relaxed/simple;
	bh=+BeOkcuiVdU7JwtPSSpo4UMRKdoHIsUlvZV1q9UcnTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAWSz+0ieMRrJCBv6puwdV6+aaiy8vrs+VI9b7YFfVB4hA45Ou9q3ug3XJ1mbFRo9ltDnggZ+dmwZSa369Tb8eypysLke7vT2NppnOmHBsktk3+e7zEOHe6omhG7CgMY6l97OYhhfeEjD2kin2KZEn+baT5xsnn7gSwtetBT4co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRDY7dT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRDY7dT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B87FC4CEEB;
	Mon,  2 Jun 2025 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877414;
	bh=+BeOkcuiVdU7JwtPSSpo4UMRKdoHIsUlvZV1q9UcnTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRDY7dT4O32vB7sD31jaFlFpcmHJUNJzdhAgNYQ5XHpPDbWwhHKWle+R4K1howjsl
	 xtbaoJY8YZHrwpnR6T6wRp1ZACmNsfHUFt65AhxRPMO/qsPbqjPgRP7vHtQ8KFbVOF
	 0OgQV8EXx2OnLRATLyvOAKt14QvYbxCjYGwhyvOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 269/325] spi: spi-fsl-dspi: Reset SR flags before sending a new message
Date: Mon,  2 Jun 2025 15:49:05 +0200
Message-ID: <20250602134330.701675603@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 93cdc52f0fb06..5374c6d44519a 100644
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



