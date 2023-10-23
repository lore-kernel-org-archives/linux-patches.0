Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59FD15484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIt9akVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2535BC433CA;
	Mon, 23 Oct 2023 11:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060193;
	bh=rjRxJRt5o67ZHq0tVXwNoXbP/TbZIwl1QnE6hDNXDs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIt9akVv7Ti3lgjLCy19wZ/ZpTVhqburS84h43FI/i10lIMiXcw9NqNhG1D11oIY7
	 bz0vfd6MriyQpeIxHWG3MnAngx4H3JKUT2zb1OiDsmO+Y9iUFDk/cKZQDtBjljCFh+
	 6h21rEwyuO9s1/zcnkgXzIY8DOQt6vRGGDvG1VIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alisa-Dariana Roman <alisa.roman@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/196] iio: adc: ad7192: Correct reference voltage
Date: Mon, 23 Oct 2023 12:55:55 +0200
Message-ID: <20231023104831.083118765@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alisa-Dariana Roman <alisa.roman@analog.com>

[ Upstream commit 7e7dcab620cd6d34939f615cac63fc0ef7e81c72 ]

The avdd and the reference voltage are two different sources but the
reference voltage was assigned according to the avdd supply.

Add vref regulator structure and set the reference voltage according to
the vref supply from the devicetree.

In case vref supply is missing, reference voltage is set according to
the avdd supply for compatibility with old devicetrees.

Fixes: b581f748cce0 ("staging: iio: adc: ad7192: move out of staging")
Signed-off-by: Alisa-Dariana Roman <alisa.roman@analog.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230924152149.41884-1-alisadariana@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index 18520f7bedccd..faf680140c178 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -177,6 +177,7 @@ struct ad7192_chip_info {
 struct ad7192_state {
 	const struct ad7192_chip_info	*chip_info;
 	struct regulator		*avdd;
+	struct regulator		*vref;
 	struct clk			*mclk;
 	u16				int_vref_mv;
 	u32				fclk;
@@ -1014,10 +1015,30 @@ static int ad7192_probe(struct spi_device *spi)
 	if (ret)
 		return dev_err_probe(&spi->dev, ret, "Failed to enable specified DVdd supply\n");
 
-	ret = regulator_get_voltage(st->avdd);
-	if (ret < 0) {
-		dev_err(&spi->dev, "Device tree error, reference voltage undefined\n");
-		return ret;
+	st->vref = devm_regulator_get_optional(&spi->dev, "vref");
+	if (IS_ERR(st->vref)) {
+		if (PTR_ERR(st->vref) != -ENODEV)
+			return PTR_ERR(st->vref);
+
+		ret = regulator_get_voltage(st->avdd);
+		if (ret < 0)
+			return dev_err_probe(&spi->dev, ret,
+					     "Device tree error, AVdd voltage undefined\n");
+	} else {
+		ret = regulator_enable(st->vref);
+		if (ret) {
+			dev_err(&spi->dev, "Failed to enable specified Vref supply\n");
+			return ret;
+		}
+
+		ret = devm_add_action_or_reset(&spi->dev, ad7192_reg_disable, st->vref);
+		if (ret)
+			return ret;
+
+		ret = regulator_get_voltage(st->vref);
+		if (ret < 0)
+			return dev_err_probe(&spi->dev, ret,
+					     "Device tree error, Vref voltage undefined\n");
 	}
 	st->int_vref_mv = ret / 1000;
 
-- 
2.40.1



