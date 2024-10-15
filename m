Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FC21D4154;
	Tue, 15 Oct 2024 11:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992981; cv=none; b=Z9Xn+uHVvPXDqT/30IvrHYBJUsaa/3zIJh4QmQ6odUG3crwPIbMQ2W58H0q7SAgzVpnyhaHfMX0nluhbsQvOPYDq42qlzf5ckmj1yFcngD4cM85KCoM6AP0DzNCqym3npJHCLU4oDu3L2MzstX+MEh0V2Vk8Vn6Azz0IM5+9ooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992981; c=relaxed/simple;
	bh=OyZYP2Bc6bH1Gb2lLJMgGwbcXpEKv5Z3ZIMYuSwmonw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bsfrfp9lM4VwU32bnBbYmp4YepUYdDziLpfXuUzRrmUc6H9SQbzWtCuIqMcblYdhNNPjwJT8FUhHBuVx7zalceiehsTPamU/Bb2sD8d0Gv/sjZzByNb4pL8v2bWYVq2BeZm/0WTOBTyzCutRpAHcTKW1I+MGjDUyP2foSJc5E1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rkx11wx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rkx11wx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CDBC4CEC6;
	Tue, 15 Oct 2024 11:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992980;
	bh=OyZYP2Bc6bH1Gb2lLJMgGwbcXpEKv5Z3ZIMYuSwmonw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rkx11wx0xyxAgFXT1MJxdU0yILGy2X6awiWgDNLuer6Dkt5a7CedAluX9d1TPZ3GD
	 SUNJc1wesdDPlBJL9JFkI1Bioi8Wafq1nt23WQQhPggWn1DUdbn/tK61Qa8XD5wC6F
	 lvfkcvNRllIU9e3bLsiyPxZQi0REU4rCmmxAnS4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Stols <gstols@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/691] iio: adc: ad7606: fix oversampling gpio array
Date: Tue, 15 Oct 2024 13:23:42 +0200
Message-ID: <20241015112451.221098066@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 0a60ecc69d38e..0faed0a69d59c 100644
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



