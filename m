Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A9C1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15085C433D6;
	Wed, 23 Nov 2022 09:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197368;
	bh=HIrx8m6Fx5PlbrksYrqOPKEpKdAbJVbC/M3xeQpmUQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyKyh14vL5ermabWBAWzpY0pmo9+ciVwWq1nbI1FkQ7vgkOx8RNDwT9Tii2SMuiHy
	 LhzIMxx1+T+Ipo8TRQgC2ISUFvkZaY0n5/4xbYnJwrY7gVm7cGuwKOg9zzCbw7/27w
	 AXr19pz/fxrpqActM2KJfjrZoyYYep48G6HAYTYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Robertson <dan@dlrobertson.com>,
	Stable@vger.kernel.org
Subject: [PATCH 6.0 244/314] iio: accel: bma400: Ensure VDDIO is enable defore reading the chip ID.
Date: Wed, 23 Nov 2022 09:51:29 +0100
Message-Id: <20221123084636.547800830@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 57572cacd36e6d4be7722d7770d23f4430219827 upstream.

The regulator enables were after the check on the chip variant, which was
very unlikely to return a correct value when not powered.
Presumably all the device anyone is testing on have a regulator that
is already powered up when this code runs for reasons beyond the scope
of this driver. Move the read call down a few lines.

Fixes: 3cf7ded15e40 ("iio: accel: bma400: basic regulator support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dan Robertson <dan@dlrobertson.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221002144133.3771029-1-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/bma400_core.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -737,18 +737,6 @@ static int bma400_init(struct bma400_dat
 	unsigned int val;
 	int ret;
 
-	/* Try to read chip_id register. It must return 0x90. */
-	ret = regmap_read(data->regmap, BMA400_CHIP_ID_REG, &val);
-	if (ret) {
-		dev_err(data->dev, "Failed to read chip id register\n");
-		return ret;
-	}
-
-	if (val != BMA400_ID_REG_VAL) {
-		dev_err(data->dev, "Chip ID mismatch\n");
-		return -ENODEV;
-	}
-
 	data->regulators[BMA400_VDD_REGULATOR].supply = "vdd";
 	data->regulators[BMA400_VDDIO_REGULATOR].supply = "vddio";
 	ret = devm_regulator_bulk_get(data->dev,
@@ -774,6 +762,18 @@ static int bma400_init(struct bma400_dat
 	if (ret)
 		return ret;
 
+	/* Try to read chip_id register. It must return 0x90. */
+	ret = regmap_read(data->regmap, BMA400_CHIP_ID_REG, &val);
+	if (ret) {
+		dev_err(data->dev, "Failed to read chip id register\n");
+		return ret;
+	}
+
+	if (val != BMA400_ID_REG_VAL) {
+		dev_err(data->dev, "Chip ID mismatch\n");
+		return -ENODEV;
+	}
+
 	ret = bma400_get_power_mode(data);
 	if (ret) {
 		dev_err(data->dev, "Failed to get the initial power-mode\n");


