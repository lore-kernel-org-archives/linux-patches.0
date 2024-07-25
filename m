Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6B919D8AA;
	Thu, 25 Jul 2024 14:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918454; cv=none; b=m1yZRQ2TdOKvrVK0Fx1lBLniYjgVD+xS4di0ExH5CflolFVUjJHvCXYwwfpWRdFBaxGMqnHYqUM/W251qAFdDfwZxpR5cB25/MWVlWrk2+uiiNdLGWK472+A7SSC0HzTIIIPNx90V8ji1sp8n70prU2Js8wU7GPU8KLaxF4hpo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918454; c=relaxed/simple;
	bh=aIlY7GAaxP6GGUi33A5disRajKI2U7PZLXBIGYv0bv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QA/Y9EcqfVOGtBlgf8iHcgn293cQt9WMhFBhU3OQIqx9B5+82Gl/+sUBpa5bLQT6XVl+jgTigBz5CK9xA2KS6aXmCGgfssEVeWPCESNaQL/j1ly7dNLncBmgL2dp+dRndm1KH0XuciaYkEwPC5vC7f86DwSq9jFpNvHfhHtnwV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcX72Mjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcX72Mjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E02C116B1;
	Thu, 25 Jul 2024 14:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918454;
	bh=aIlY7GAaxP6GGUi33A5disRajKI2U7PZLXBIGYv0bv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcX72MjnvHmNeRtFzeLmAG5URoXoJ9s/7mETT9mt/TxKysUboCSEmc1+Efkz5Ypcm
	 BZF2kUDQ1IVrRC//Nw3BjqgvMxD9Iu2wjx7yPZMQXeUwjyQe0lpKr8zR/IRdCbfF9w
	 dRpd6xrc5cuKEa1xW+AEr/oKDCG6r/NiwhCHzsfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/33] spi: imx: Dont expect DMA for i.MX{25,35,50,51,53} cspi devices
Date: Thu, 25 Jul 2024 16:36:47 +0200
Message-ID: <20240725142729.426060424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0078cb365d8c2..adcd519c70b19 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -968,7 +968,7 @@ static struct spi_imx_devtype_data imx35_cspi_devtype_data = {
 	.rx_available = mx31_rx_available,
 	.reset = mx31_reset,
 	.fifo_size = 8,
-	.has_dmamode = true,
+	.has_dmamode = false,
 	.dynamic_burst = false,
 	.has_slavemode = false,
 	.devtype = IMX35_CSPI,
-- 
2.43.0



