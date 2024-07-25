Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADF219AA5F;
	Thu, 25 Jul 2024 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918598; cv=none; b=KNuKo+BdxdLMeaqVGC/jggVoiMmQyCQGJxVFfvJDyOti+z+1NsNW7AyDTqKnkqHesF4PkmGtY15H61fJIFOYN2/Xz9XZ1SjR4sMWQl7kHf4ERZJlyFM8Tcr4y7nVhDyrzJixXizrNuCwyzFqa/FAKwkzPcxga8o/XAHtAH4YGEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918598; c=relaxed/simple;
	bh=DxNdMtmC+DEYMwE4PaVKXp80kvgPssaM7sEmZW3FlJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LMBpIh5scErGe1ZXOycAVwvu4ZZGzaScD8r1pbduB/I9DzK6uxbO30UmaLRPj5W8QF/NCju9tOrZVlejul755/U5dhUTWfdQTOxM2/+mbM8AkH9pDXFB9QDSj4Uh/pUovby4lmLvsocyOuyw+8UAp5jX4iTdutypvHgGvVEfagc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0JpPlAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0JpPlAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00831C116B1;
	Thu, 25 Jul 2024 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918598;
	bh=DxNdMtmC+DEYMwE4PaVKXp80kvgPssaM7sEmZW3FlJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0JpPlAJ5zOS+sNvx7f5A0UEi1uWivVEXQwqAE7LbmzX0NzhU2ZFjf+7OLtK2F4Gg
	 4nihmbLvY5fTwWud/jlYdpdSdJZvL4xEt20qvCHUCptqRZA2zKVG44CAkIXZ3MCFnO
	 +YSC/HaPudO3rIH9HTk6KSCmztsjxAm6pwETlbJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/43] spi: imx: Dont expect DMA for i.MX{25,35,50,51,53} cspi devices
Date: Thu, 25 Jul 2024 16:36:56 +0200
Message-ID: <20240725142731.722223097@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 67f31183c1180..8c9bafee58f9f 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -993,7 +993,7 @@ static struct spi_imx_devtype_data imx35_cspi_devtype_data = {
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



