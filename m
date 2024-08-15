Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F767DA78;
	Thu, 15 Aug 2024 13:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728977; cv=none; b=MlYVpH+5/LxBpwCMhZPCuSfVq+sm96D7vzpQq4mBo2VZGDgTnIouUTd9W4tUsN4q5HNRq3DR4i0iUhS1vPWa+wIyZ73Gr2k/FSHHh0RNnY27auSDnEbWXN/WoBR5tRmFianzzS943C6YecWjnWdFpFgSTZFN/2C6bx5qPIGF/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728977; c=relaxed/simple;
	bh=1hRREk6sC5zGfmOFWpNj6dKZwZZ34Ls6VabanM7VH5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjHqzEz7p9zJsxxIrYU6B5aiXbtFOfVNhY+8cyBuzgtUcNcsQ95ajdWLsTMA4/3EPHe20Hpc+om8VGmF2rqg9YTDLTEuKyDgHlKpqdKIe7KJkJrmLqkzsedNzkHnK9VFdERfokDXrMtxqm/rLLTQ9ydPoYM3ioS6pewlBvmxWkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKGwy9J0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKGwy9J0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE95C32786;
	Thu, 15 Aug 2024 13:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728977;
	bh=1hRREk6sC5zGfmOFWpNj6dKZwZZ34Ls6VabanM7VH5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKGwy9J0xDfAuta2nBcZ4vjyhxxCqSSxvNwh+qpKVHjZLkTJ5N4Q1RuP7pR3rGUGz
	 iGcOiq5+pVYBnnDZ1huIFtc8V8rME7K2U1teIfwsgphZaSEi1ymRNyijNdUNgA2TNi
	 rTVNnDGc70F+uvwkd4LjbRItx7XTxMkjjMJ5MJL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/196] spi: spi-fsl-lpspi: Fix scldiv calculation
Date: Thu, 15 Aug 2024 15:24:48 +0200
Message-ID: <20240815131858.613083596@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 730bbfaf7d4890bd99e637db7767dc68cfeb24e7 ]

The effective SPI clock frequency should never exceed speed_hz
otherwise this might result in undefined behavior of the SPI device.

Currently the scldiv calculation could violate this constraint.
For the example parameters perclk_rate = 24 MHz and speed_hz = 7 MHz,
the function fsl_lpspi_set_bitrate will determine perscale = 0 and
scldiv = 1, which is a effective SPI clock of 8 MHz.

So fix this by rounding up the quotient of perclk_rate and speed_hz.
While this never change within the loop, we can pull this out.

Fixes: 5314987de5e5 ("spi: imx: add lpspi bus driver")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20240804113611.83613-1-wahrenst@gmx.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -257,7 +257,7 @@ static void fsl_lpspi_set_watermark(stru
 static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 {
 	struct lpspi_config config = fsl_lpspi->config;
-	unsigned int perclk_rate, scldiv;
+	unsigned int perclk_rate, scldiv, div;
 	u8 prescale;
 
 	perclk_rate = clk_get_rate(fsl_lpspi->clk_per);
@@ -268,8 +268,10 @@ static int fsl_lpspi_set_bitrate(struct
 		return -EINVAL;
 	}
 
+	div = DIV_ROUND_UP(perclk_rate, config.speed_hz);
+
 	for (prescale = 0; prescale < 8; prescale++) {
-		scldiv = perclk_rate / config.speed_hz / (1 << prescale) - 2;
+		scldiv = div / (1 << prescale) - 2;
 		if (scldiv < 256) {
 			fsl_lpspi->config.prescale = prescale;
 			break;


