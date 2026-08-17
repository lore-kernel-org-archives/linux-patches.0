Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602E82DC783;
	Mon, 17 Aug 2026 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977757; cv=none; b=Sm7T1rQ7U91IsgKUUdZR8GkBd/sjtAgp/5OjHWbZ21ti3eCMkyXn+PPZBn+J4Q9tYYzJMz7tV+ONCHDhHkX0I6giY7G+izNqiJuayBRktcsYlDGjHEOtIQhKUrd0WHbIJ5CWQF1tmckKkI7noCfLuq3R5JFco8Ozr/UmmJaQqYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977757; c=relaxed/simple;
	bh=894uWa2af3q2DKHVx/TyLgcQFoBMnpYufBrt2jdWBpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kByQlM5PhTRQv+eSmE/PHTkanL747GIg2w1PeaUhe4eHOPHP7HmyEOUfXWsxkOiFQmIaDKD8yQ1rIFf0t/22031M70fuBMLbgTV9O2PEzboqMCPhFIPcPnrrGcZJafamt26E82Ds5qlmuLPUoAqcthkO5vttSyPrsBLafaKt6VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1DyAWka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1DyAWka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF51F000E9;
	Mon, 17 Aug 2026 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977756;
	bh=3CuoRw+mlrND97WNuhcFZKR3c2w3tJLV6jLmqYJk7xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1DyAWkal3Gl1xpX2c5cY9mtLkjbwUZo2w66WKqXTaEUFfCCWg1jPSYEhblenuAMP
	 a/bdgeIEZ0oYi56cNYYRhZ9w/VjpzDXYNXJrKCuJCDFLPhIssJF6Z1j90oWuPR09Cj
	 xhr5zPLYh3bDKZNePf3drhulEdjq6dwFpLYLRnq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/456] spi: spi-fsl-dspi: Avoid setup_accel logic for DMA transfers
Date: Mon, 17 Aug 2026 15:33:09 +0200
Message-ID: <20260817132554.954253658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit cac7e5054115fcc41b1cb050af8e8971f7c9b22b ]

Repacking multiple smaller words into larger ones to make use of the
full FIFO doesn't save anything in DMA mode, so don't bother doing it.

Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250522-james-nxp-spi-v2-8-bea884630cfb@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 580fdcbcd9b6c..2bf8cc137d31e 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -751,8 +751,12 @@ static void dspi_setup_accel(struct fsl_dspi *dspi)
 	struct spi_transfer *xfer = dspi->cur_transfer;
 	bool odd = !!(dspi->len & 1);
 
-	/* No accel for frames not multiple of 8 bits at the moment */
-	if (xfer->bits_per_word % 8)
+	/*
+	 * No accel for DMA transfers or frames not multiples of 8 bits at the
+	 * moment.
+	 */
+	if (dspi->devtype_data->trans_mode == DSPI_DMA_MODE ||
+	    xfer->bits_per_word % 8)
 		goto no_accel;
 
 	if (!odd && dspi->len <= dspi->devtype_data->fifo_size * 2) {
@@ -761,10 +765,7 @@ static void dspi_setup_accel(struct fsl_dspi *dspi)
 		dspi->oper_bits_per_word = 8;
 	} else {
 		/* Start off with maximum supported by hardware */
-		if (dspi->devtype_data->trans_mode == DSPI_XSPI_MODE)
-			dspi->oper_bits_per_word = 32;
-		else
-			dspi->oper_bits_per_word = 16;
+		dspi->oper_bits_per_word = 32;
 
 		/*
 		 * And go down only if the buffer can't be sent with
-- 
2.53.0



