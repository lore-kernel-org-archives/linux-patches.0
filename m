Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57B629CE6;
	Thu, 15 Aug 2024 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731753; cv=none; b=nWZwUrLGequKchMQBvk4b5Yde6A2iPDN780YQ7A8XNtJagNwNIv2sPeiJPze5YmkYg4iZx1hrCWgCetSus/MbBXTbQb2huLXyIBBY356Rht8AuaOtu48nEEwLUC05uvsOK5Ruv67YhbAUs3W9GG0S4f8oKovKa8aovNp471DJDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731753; c=relaxed/simple;
	bh=C+eu428rsEMNSXX2YlEu8DoJuHJsKPrQfRW4ZunyHzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZOaLnggcyBkwF8GXJv9nNmuax61/zbraxBrqduP/4tBQt1deJjm2sR1iksA8o2D9W4xkkjae6UUyGP1JzXuBAhpAsuJ63cH+cCeBugOIB1H2/qdzSHJMl660G9H/AHr9Rcd/MMP/iMTnhEhJoNRLKD29CXf4Ia6vioGZNFipeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t10yUc5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t10yUc5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351BEC32786;
	Thu, 15 Aug 2024 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731753;
	bh=C+eu428rsEMNSXX2YlEu8DoJuHJsKPrQfRW4ZunyHzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t10yUc5AoQn7bKoi9WvA78nof3Wwy1CH/ZPmVi9fvrJfvNs+2ZyyP5qXY9Q2RHdHp
	 KedsNXW65xh8XIAEe/5UAEvbQIFrLeb8EKTPUBsgtFTCYWc5IH5b5zkoZYOTyU7leo
	 gfyPkbYIckKXJBAcczkOmEoDb8Q6l266Bnt5VifY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 226/259] spi: spi-fsl-lpspi: Fix scldiv calculation
Date: Thu, 15 Aug 2024 15:25:59 +0200
Message-ID: <20240815131911.509082955@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/spi/spi-fsl-lpspi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 5351185fd9af7..2708bf15e1263 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -317,7 +317,7 @@ static void fsl_lpspi_set_watermark(struct fsl_lpspi_data *fsl_lpspi)
 static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 {
 	struct lpspi_config config = fsl_lpspi->config;
-	unsigned int perclk_rate, scldiv;
+	unsigned int perclk_rate, scldiv, div;
 	u8 prescale;
 
 	perclk_rate = clk_get_rate(fsl_lpspi->clk_per);
@@ -328,8 +328,10 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
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
-- 
2.43.0



