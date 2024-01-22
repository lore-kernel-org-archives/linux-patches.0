Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E9F62A13;
	Tue, 23 Jan 2024 01:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974995; cv=none; b=YcRITLh141uDpQKsJrPOUNU/v9jaNNCADBgjwmUsU8I8oiwsCpx6ObYMxuu8ihXucWkBzj9GMCuUNnMugtDzLZ9hGs4rxP8fa4v6WfZEAJ35aWuHcRceuqQ6hzAYVGw6uFSSDm++b5MpNQDPDXXRGUG737ZZxSJTZVDPa69Kg2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974995; c=relaxed/simple;
	bh=TaHfLp9Ic5qjfFdUXjr1+qEbBmaKel28jGayV3RuBBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rqn+5dKZh9AT704zmy+zchZ21naa01wvJ3Ngc/NbjHUGnBMy+SzUHrbSfMxSBN5AoH9+ahGQD/nEkvt8GNQ8e6+zY/jhrKtXENOEDL23BbJAfuvygV2Z+umWdV8HXO2Lz6ifLDZNjmIR1COI4hOlXmD105/h+DogcK98X06Hz4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvLIBz/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvLIBz/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BB9C433F1;
	Tue, 23 Jan 2024 01:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974995;
	bh=TaHfLp9Ic5qjfFdUXjr1+qEbBmaKel28jGayV3RuBBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvLIBz/WW+FfANZBzWZxf+BFD7zNuO6IURRf0f0tt6G5tvkkR0w+SklKi+E5E03PD
	 M9G0WG2e5isRKKcw1W7ak4KH0sT88PfZou2RvODwu/dXtuPSTwhW6DPoTjRWcGOcnE
	 nPgfSrCMIgcdjKeDcsMaxxUpCdzWQtVpbjf5mtpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/374] iio: adc: ad9467: dont ignore error codes
Date: Mon, 22 Jan 2024 15:59:29 -0800
Message-ID: <20240122235755.762777865@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit e072e149cfb827e0ab4cafb0547e9658e35393cd ]

Make sure functions that return errors are not ignored.

Fixes: ad6797120238 ("iio: adc: ad9467: add support AD9467 ADC")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20231207-iio-backend-prep-v2-2-a4a33bc4d70e@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad9467.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/adc/ad9467.c b/drivers/iio/adc/ad9467.c
index 46c85748a07e..09ff5b27cee5 100644
--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -162,9 +162,10 @@ static int ad9467_reg_access(struct adi_axi_adc_conv *conv, unsigned int reg,
 
 	if (readval == NULL) {
 		ret = ad9467_spi_write(spi, reg, writeval);
-		ad9467_spi_write(spi, AN877_ADC_REG_TRANSFER,
-				 AN877_ADC_TRANSFER_SYNC);
-		return ret;
+		if (ret)
+			return ret;
+		return ad9467_spi_write(spi, AN877_ADC_REG_TRANSFER,
+					AN877_ADC_TRANSFER_SYNC);
 	}
 
 	ret = ad9467_spi_read(spi, reg);
@@ -272,10 +273,13 @@ static int ad9467_get_scale(struct adi_axi_adc_conv *conv, int *val, int *val2)
 	const struct ad9467_chip_info *info1 = to_ad9467_chip_info(info);
 	struct ad9467_state *st = adi_axi_adc_conv_priv(conv);
 	unsigned int i, vref_val;
+	int ret;
 
-	vref_val = ad9467_spi_read(st->spi, AN877_ADC_REG_VREF);
+	ret = ad9467_spi_read(st->spi, AN877_ADC_REG_VREF);
+	if (ret < 0)
+		return ret;
 
-	vref_val &= info1->vref_mask;
+	vref_val = ret & info1->vref_mask;
 
 	for (i = 0; i < info->num_scales; i++) {
 		if (vref_val == info->scale_table[i][1])
@@ -296,6 +300,7 @@ static int ad9467_set_scale(struct adi_axi_adc_conv *conv, int val, int val2)
 	struct ad9467_state *st = adi_axi_adc_conv_priv(conv);
 	unsigned int scale_val[2];
 	unsigned int i;
+	int ret;
 
 	if (val != 0)
 		return -EINVAL;
@@ -305,11 +310,13 @@ static int ad9467_set_scale(struct adi_axi_adc_conv *conv, int val, int val2)
 		if (scale_val[0] != val || scale_val[1] != val2)
 			continue;
 
-		ad9467_spi_write(st->spi, AN877_ADC_REG_VREF,
-				 info->scale_table[i][1]);
-		ad9467_spi_write(st->spi, AN877_ADC_REG_TRANSFER,
-				 AN877_ADC_TRANSFER_SYNC);
-		return 0;
+		ret = ad9467_spi_write(st->spi, AN877_ADC_REG_VREF,
+				       info->scale_table[i][1]);
+		if (ret < 0)
+			return ret;
+
+		return ad9467_spi_write(st->spi, AN877_ADC_REG_TRANSFER,
+					AN877_ADC_TRANSFER_SYNC);
 	}
 
 	return -EINVAL;
-- 
2.43.0



