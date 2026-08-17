Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF02408617;
	Mon, 17 Aug 2026 14:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976346; cv=none; b=tOBNZTCdgy2FT4lQMNPYbQ9NNTlYVcoh1jyunkpyifYxl98hspfZQGHsG4VAkCjajdl42UdMyysyK/FczCR8LilEj4RniLx6h4KZHvcTwUI/RVBKouYWKJXxm5gfLON4UKyjGP5gkPxxEV9yeHzNp+Y9bEeQGCJ1DOJiJqIDVp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976346; c=relaxed/simple;
	bh=xQmgurbE2H6ZOJLeqBzgxXZw32krU3ufBT6Nn+Pmgu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGYrpSfmvvAjdqLPfQ8+V/wlKaD9xHB/il6VnRvIdVtxAMx8RTxIz/QsfENCu7XIJnu2DYJYD+miLQEwXCaO28/0efeBGSqv0zG5SqWxrhwSHCoJovSHEsho5qjAgofr77ejrQHBHvZtpB5av7GWwxmHS/Q9h8dMd2TCr5X0o/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1uLNNgY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1uLNNgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52491F000E9;
	Mon, 17 Aug 2026 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976345;
	bh=MW3+f66djtRWRiWwq173fif0+1Ad2fi0XhONqYEkOCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1uLNNgYVC+KDtDydIbp+ACvOXCzqg4Sk5pdCSLprBTL8nFTUdNA5oe2oZCx6xKqE
	 CrOyNYXaR/RRJLPPsL9v9TwM70WOzFvEgTAhk4sIyxX2xGy76WDFA3/waiQwm+0/IY
	 3LW9xoOaZolj1YQeE+H6teKxv9rm1cWaQmwkcFdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/389] spi: spi-fsl-dspi: Avoid setup_accel logic for DMA transfers
Date: Mon, 17 Aug 2026 15:33:00 +0200
Message-ID: <20260817132552.136331721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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



