Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA881C07E0;
	Tue, 15 Oct 2024 13:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997478; cv=none; b=HVUwkORLeDLQTPio/aJoiHfgBlryfuIgqUKqOBmOUooMOZcv8i0L2IYNGw3UjnJPK8w/5T6PypppugrHx7rAJYrRjd+Q3eg+7mMG+owbbMJpGWGPNwV0i+mGNM84p334Ff3IPX2ffvT7Pn0jLsXeN9nbfiAiwRshYBoPGnONFeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997478; c=relaxed/simple;
	bh=dDUnrbnroriOKP4a2QssemmCuyVyIMUT3++tDl0KFRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghnK6IBrSs9OyB7w925jZZH6T91wZl5NKAqWwdxyfMViraj0g1QNMF+RPNY6/wcg/YLXUiudxwwPEhyiTNeH74vwKsYa58r2796VJiDKLMl2LPMA64fYiyXKL1dJx6Nq/7wBdq2YUnp0WfLGs8d9eqC6GIvvrKZ6rfaVwRPTwD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jFM955i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jFM955i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79362C4CEC6;
	Tue, 15 Oct 2024 13:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997478;
	bh=dDUnrbnroriOKP4a2QssemmCuyVyIMUT3++tDl0KFRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jFM955iDxFDq6oUREOXyRH/Kl6lNJVEbCxkt1Hc3CIFNpCZBWejIrr6mU8fjclQK
	 stPwrTM/HUwWbExblpekSjVYegUBRHNbS87RvcDUKZlxQWKE58cCaOOw2TVN3eHLhJ
	 JbRdrSBl43UCs8tJLkN75thU2kIHb18YGkp9aBQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/518] iio: adc: ad7606: fix oversampling gpio array
Date: Tue, 15 Oct 2024 14:41:38 +0200
Message-ID: <20241015123924.469868220@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Stols <gstols@baylibre.com>

[ Upstream commit 8dc4594b54dbaaba40dc8884ad3d42083de39434 ]

gpiod_set_array_value was misused here: the implementation relied on the
assumption that an unsigned long was required for each gpio, while the
function expects a bit array stored in "as much unsigned long as needed
for storing one bit per GPIO", i.e it is using a bit field.

This leaded to incorrect parameter passed to gpiod_set_array_value, that
would set 1 value instead of 3.
It also prevents to select the software mode correctly for the AD7606B.

Fixes: d2a415c86c6b ("iio: adc: ad7606: Add support for AD7606B ADC")
Fixes: 41f71e5e7daf ("staging: iio: adc: ad7606: Use find_closest() macro")
Signed-off-by: Guillaume Stols <gstols@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606.c     | 4 ++--
 drivers/iio/adc/ad7606_spi.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index ee7b108688b33..d1223cfd8fb41 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -238,9 +238,9 @@ static int ad7606_write_os_hw(struct iio_dev *indio_dev, int val)
 	struct ad7606_state *st = iio_priv(indio_dev);
 	DECLARE_BITMAP(values, 3);
 
-	values[0] = val;
+	values[0] = val & GENMASK(2, 0);
 
-	gpiod_set_array_value(ARRAY_SIZE(values), st->gpio_os->desc,
+	gpiod_set_array_value(st->gpio_os->ndescs, st->gpio_os->desc,
 			      st->gpio_os->info, values);
 
 	/* AD7616 requires a reset to update value */
diff --git a/drivers/iio/adc/ad7606_spi.c b/drivers/iio/adc/ad7606_spi.c
index 29945ad07dca8..e1ad2cd61b7f9 100644
--- a/drivers/iio/adc/ad7606_spi.c
+++ b/drivers/iio/adc/ad7606_spi.c
@@ -249,8 +249,9 @@ static int ad7616_sw_mode_config(struct iio_dev *indio_dev)
 static int ad7606B_sw_mode_config(struct iio_dev *indio_dev)
 {
 	struct ad7606_state *st = iio_priv(indio_dev);
-	unsigned long os[3] = {1};
+	DECLARE_BITMAP(os, 3);
 
+	bitmap_fill(os, 3);
 	/*
 	 * Software mode is enabled when all three oversampling
 	 * pins are set to high. If oversampling gpios are defined
@@ -258,7 +259,7 @@ static int ad7606B_sw_mode_config(struct iio_dev *indio_dev)
 	 * otherwise, they must be hardwired to VDD
 	 */
 	if (st->gpio_os) {
-		gpiod_set_array_value(ARRAY_SIZE(os),
+		gpiod_set_array_value(st->gpio_os->ndescs,
 				      st->gpio_os->desc, st->gpio_os->info, os);
 	}
 	/* OS of 128 and 256 are available only in software mode */
-- 
2.43.0



