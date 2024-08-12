Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92750183CA6;
	Mon, 12 Aug 2024 16:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479588; cv=none; b=ed0O9sD11YGeoWDZIP+wuKYWFWcViXC4uBozpU750hH5lG1x+Uph9q+iSDztmFbQIRiUseBWWzvjLb2hOUYilSwOhoS9r30il2qVEUTzZXbVX4QCNFuicZ2VhTSWO2yBA1DiWfJ/7nJjreCm0RLQ42f+RiAV2UiSxa1xB4tRsYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479588; c=relaxed/simple;
	bh=HJqGqr5jVPWubxgcZJTa5iHV0cEIAWw/8CxCEKNZyGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuFEmMsY7tVfdFRnGWkKkJyBrojrOfeEruZv6hxoYtP1HSgA1V0T/j/xNk0JwL41dJH1zfc4l+Er0+CtPp97eaKD+S+WnXs0x/qy1axPUVo/vDCrutm//av4owSIuukS4qDDIC4+nZuMA+10/EJ0osz6lhcMC07ir/S42dAfU/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mByNj7A6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mByNj7A6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1756C4AF09;
	Mon, 12 Aug 2024 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479588;
	bh=HJqGqr5jVPWubxgcZJTa5iHV0cEIAWw/8CxCEKNZyGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mByNj7A6b9+NN2RgfdMEtauYWAL5YUzPLrN2u/J6SOefBFXeiUGHKngog2p0NkeIE
	 kKsNSZrjEtZeb5Un+bHXEzmm+9lcuxWb5rAR289KbZKGbR3VQOzQQHRm5s20sic82s
	 lbw5gf+/Q+satKGT1wgavCC+NOuzID3c6k8Kl+f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/189] spi: spi-fsl-lpspi: Fix scldiv calculation
Date: Mon, 12 Aug 2024 18:02:38 +0200
Message-ID: <20240812160136.068485035@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 079035db7dd85..3c0f7dc9614d1 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -296,7 +296,7 @@ static void fsl_lpspi_set_watermark(struct fsl_lpspi_data *fsl_lpspi)
 static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 {
 	struct lpspi_config config = fsl_lpspi->config;
-	unsigned int perclk_rate, scldiv;
+	unsigned int perclk_rate, scldiv, div;
 	u8 prescale;
 
 	perclk_rate = clk_get_rate(fsl_lpspi->clk_per);
@@ -313,8 +313,10 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
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



