Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB1425A34F;
	Wed, 30 Jul 2025 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868996; cv=none; b=FQrCokZQb686HaSBKF3deWhmoMfE+Fn6HydlsrthqYHPn+rxDGYo1LR0MdJ5BXV2t4XCke90QV8i2LyTFOfImqm1d3ofrJhggHiV0KfU0+MHh82wov3Qtaiqiv+hLtiChVw2Ik5ApTgbVtqbcRqTpSd47cv3MVPmbpd6BVo3wuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868996; c=relaxed/simple;
	bh=h5Jov4owEO38QanwqW4sCjqsVirrA08OzOIfKPrcAxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1vnzAnjq7hEXACTKiJcUVOAAxPe4vLmPG1FgOV33J9UgXXLd/umTqQaem9vrTGulAiiwUsZp9xgxwiZl7Wkn68GmY8fl4PxaB44VC+IBMRHIUAsjjTeM3iMEXENMsOKQwdnJj1ciYBEEV6+7Iy/2qA7g+4mllW20Cs5xs1W37c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7OwAhQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7OwAhQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862BEC4CEF5;
	Wed, 30 Jul 2025 09:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868996;
	bh=h5Jov4owEO38QanwqW4sCjqsVirrA08OzOIfKPrcAxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7OwAhQf1oIORqYj3InoZXWkXPlBpVStZjSORzC8rr3cHF7A7JA2axS7EHemcKE+b
	 ieO+HSJcxNOo02BxctiXnAM1IcfkmKbKIASpuG3pnbS4PbCj2Fgcp3B8Fc+x96ODfq
	 sV0G6iY/gYIsHvOaOL3iDXCheSUFbyem7MVz3jks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andy@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 11/92] iio: adc: ad7949: use spi_is_bpw_supported()
Date: Wed, 30 Jul 2025 11:35:19 +0200
Message-ID: <20250730093231.061053993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 7b86482632788acd48d7b9ee1867f5ad3a32ccbb ]

Use spi_is_bpw_supported() instead of directly accessing spi->controller
->bits_per_word_mask. bits_per_word_mask may be 0, which implies that
8-bits-per-word is supported. spi_is_bpw_supported() takes this into
account while spi_ctrl_mask == SPI_BPW_MASK(8) does not.

Fixes: 0b2a740b424e ("iio: adc: ad7949: enable use with non 14/16-bit controllers")
Closes: https://lore.kernel.org/linux-spi/c8b8a963-6cef-4c9b-bfef-dab2b7bd0b0f@sirena.org.uk/
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20250611-iio-adc-ad7949-use-spi_is_bpw_supported-v1-1-c4e15bfd326e@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7949.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ad7949.c b/drivers/iio/adc/ad7949.c
index edd0c3a35ab73..202561cad4012 100644
--- a/drivers/iio/adc/ad7949.c
+++ b/drivers/iio/adc/ad7949.c
@@ -308,7 +308,6 @@ static void ad7949_disable_reg(void *reg)
 
 static int ad7949_spi_probe(struct spi_device *spi)
 {
-	u32 spi_ctrl_mask = spi->controller->bits_per_word_mask;
 	struct device *dev = &spi->dev;
 	const struct ad7949_adc_spec *spec;
 	struct ad7949_adc_chip *ad7949_adc;
@@ -337,11 +336,11 @@ static int ad7949_spi_probe(struct spi_device *spi)
 	ad7949_adc->resolution = spec->resolution;
 
 	/* Set SPI bits per word */
-	if (spi_ctrl_mask & SPI_BPW_MASK(ad7949_adc->resolution)) {
+	if (spi_is_bpw_supported(spi, ad7949_adc->resolution)) {
 		spi->bits_per_word = ad7949_adc->resolution;
-	} else if (spi_ctrl_mask == SPI_BPW_MASK(16)) {
+	} else if (spi_is_bpw_supported(spi, 16)) {
 		spi->bits_per_word = 16;
-	} else if (spi_ctrl_mask == SPI_BPW_MASK(8)) {
+	} else if (spi_is_bpw_supported(spi, 8)) {
 		spi->bits_per_word = 8;
 	} else {
 		dev_err(dev, "unable to find common BPW with spi controller\n");
-- 
2.39.5



