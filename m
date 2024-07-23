Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA78157A55;
	Tue, 23 Jul 2024 18:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759733; cv=none; b=ogXuyjmOseZn4fGi3Dz9zfI2ZuMxk0WXFcO7peVSgoHhJrmSJGUeq5YGZ4zwyHI9421eE57LTfsPaAyysN25WCNDLArb6PC+RGGRiMgN9ND+Pk7so8x8xncUZorSTj46kHKDXsy4pTGKmZ42PX737McxsGplBT3+exaNcdW5S5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759733; c=relaxed/simple;
	bh=DEjARAg/RV0AXsxvFTWXhLYF6Ggrc0TOwJzqorCCvmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u5RLYpvqdOz6eSWtxLhUkBRUuv5xiDA/yNvJQIMO3JHrceUAx0ClgjOSkVWwT3cTDXI2/xnpd/Y41gyFH4L51Fa7XOMK2paQu/SE6mLqJBzcaCL8xKhf/JybW0x9oJE5MIOD0HKfusO21gNZQLnfZd2JWcrsLvPVNK3Ii1OYhFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPODrYhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPODrYhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7CBC4AF0B;
	Tue, 23 Jul 2024 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759733;
	bh=DEjARAg/RV0AXsxvFTWXhLYF6Ggrc0TOwJzqorCCvmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPODrYhkN76b5E/s+aCDeVtRvwdJl+V2dsQHDLbrKJf5Y6GV7AaHCI7jWHirzqX9i
	 3bhU3DMr+OM/Q/EvZiLK8Pk/7rqzc4TEJlVvXG1InTKaayJOUgOcmQnjBWPdxy61Xl
	 xWfdXhiKR/vsVV/GxcPM1m6mW+CJ50nq4VRRgxKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/129] spi: imx: Dont expect DMA for i.MX{25,35,50,51,53} cspi devices
Date: Tue, 23 Jul 2024 20:24:18 +0200
Message-ID: <20240723180409.041443939@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ce1dac560a74220f2e53845ec0723b562288aed4 ]

While in commit 2dd33f9cec90 ("spi: imx: support DMA for imx35") it was
claimed that DMA works on i.MX25, i.MX31 and i.MX35 the respective
device trees don't add DMA channels. The Reference manuals of i.MX31 and
i.MX25 also don't mention the CSPI core being DMA capable. (I didn't
check the others.)

Since commit e267a5b3ec59 ("spi: spi-imx: Use dev_err_probe for failed
DMA channel requests") this results in an error message

	spi_imx 43fa4000.spi: error -ENODEV: can't get the TX DMA channel!

during boot. However that isn't fatal and the driver gets loaded just
fine, just without using DMA.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://patch.msgid.link/20240508095610.2146640-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index d323b37723929..006860ee03ca0 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1050,7 +1050,7 @@ static struct spi_imx_devtype_data imx35_cspi_devtype_data = {
 	.rx_available = mx31_rx_available,
 	.reset = mx31_reset,
 	.fifo_size = 8,
-	.has_dmamode = true,
+	.has_dmamode = false,
 	.dynamic_burst = false,
 	.has_targetmode = false,
 	.devtype = IMX35_CSPI,
-- 
2.43.0



