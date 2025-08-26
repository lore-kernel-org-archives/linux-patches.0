Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A833093AB;
	Tue, 26 Aug 2025 11:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208803; cv=none; b=GfEtTsjOw0R7s/gVJYcPTJl6fLhbAOCEgpd79F3lQtNP4gCNNPFcJ62LGwS5YR8PVZcqAzCwHIiSQrra4MxQCZ1QPjyXLrg/xROVj44I4+RoZwpnNnHOcBBQQJjmhszqRfx6mc8/UQwTqEq1YTTg6lDNbMQECX3VmJuVvElbE+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208803; c=relaxed/simple;
	bh=hkK0Ygknl+5DZHp72qhEC1iavKW2WHHaKGnAxRcc3HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OarcnzbqndxDo5UUXAS9CSGtoqy5e4kmCBOYYOuYiRvbNTpfjf8gOCTKB4LNnJZ+lpnPnF+3cMpaCc5zHLrBR/oS0P64hcDG/5MWK56sDLzJmRfcyVfgboQItGH9aKKLHmE9tCNDzAbpj4e1f7IIcIU8htO733sIfHdU4KtEtYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouIkcyMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouIkcyMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B824C4CEF1;
	Tue, 26 Aug 2025 11:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208803;
	bh=hkK0Ygknl+5DZHp72qhEC1iavKW2WHHaKGnAxRcc3HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouIkcyMRBYoDRBOgBFM/9pb5c50OqNExNnbIZsnsv5Ms4b/TgZ1rb3DWz0gm/9GCk
	 fYIL5h0UzdaRwbhVkXh8iUlDj9N+PepE93BnMvDcVO+VwalQVz9Pf8r7HqX8xu2Clf
	 8Dx65EZ2o2r9QCc1c+1eRPir/xTcldhkswZAtiP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/322] spi: spi-fsl-lpspi: Clamp too high speed_hz
Date: Tue, 26 Aug 2025 13:11:07 +0200
Message-ID: <20250826110922.154198801@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit af357a6a3b7d685e7aa621c6fb1d4ed6c349ec9e ]

Currently the driver is not able to handle the case that a SPI device
specifies a higher spi-max-frequency than half of per-clk:

    per-clk should be at least two times of transfer speed

Fix this by clamping to the max possible value and use the minimum SCK
period of 2 cycles.

Fixes: 77736a98b859 ("spi: lpspi: add the error info of transfer speed setting")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20250807100742.9917-1-wahrenst@gmx.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 29b9676fe43d..f8cacb9c7408 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -330,13 +330,11 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 	}
 
 	if (config.speed_hz > perclk_rate / 2) {
-		dev_err(fsl_lpspi->dev,
-		      "per-clk should be at least two times of transfer speed");
-		return -EINVAL;
+		div = 2;
+	} else {
+		div = DIV_ROUND_UP(perclk_rate, config.speed_hz);
 	}
 
-	div = DIV_ROUND_UP(perclk_rate, config.speed_hz);
-
 	for (prescale = 0; prescale <= prescale_max; prescale++) {
 		scldiv = div / (1 << prescale) - 2;
 		if (scldiv >= 0 && scldiv < 256) {
-- 
2.50.1



