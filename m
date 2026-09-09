Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2264D568542;
	Wed,  9 Sep 2026 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962423; cv=none; b=tIdf/aUBnVxcz7RzCDqEcLaU8D2dNjgbcXWKfldUVcik72f2iEzyAawOU2MgHcRIjM6/71QmWnH5YE5SqaQ8E1VdZdnXGwzJ0PX6e1PtdNzzOm/ZmvWtEIFp10V3lGC66sRfk9t9h4zT6LpaGFK+FjtDBCzEVz8qIAUi9o9CoiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962423; c=relaxed/simple;
	bh=Ldjl1PS5ke7G5AUZ78ikcchNJrQULwChRVh2nNQ8NB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD5eU7sodGzmZvo0hsRRfkghTKpdv0G+IVvFfWP2V6Sub3yTJu50ASHutpGSzfNZ3O9E+0qofE+jAVRiBTe/Q1npW/jLi5GfPS0BpkfDEGtbHzNxy6xvJJ40l91SbvL0hIUnb7sGr4tZc2mtS1TVy2l/6cmY8/VuI8FH+/0sbp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPnaxkOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPnaxkOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3AD1F00A3A;
	Wed,  9 Sep 2026 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962422;
	bh=MvZnw+Aj/585FfsvrBJbG5Js6rSIqqS2cTK2GfBx1SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPnaxkOvBKeQ0SuWSsSPNk4D6HFo1nqCtx1m93ig/01l6D8yCv5cayPFpER98c7Sy
	 gFWa4EYJHHZCDVkaeT7PCl12BURaFf1zPAzJFiO5F+6TjCkR9Jc9a7/JSJc8Nrx6ID
	 BG/f1zILsF7Cdox/UEKu067kKt4gTvryQQtkwNTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Geurts <paul.geurts@prodrive-technologies.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 284/556] iio: ti-ads7138: Disable STATS_EN bit while reading conversion results
Date: Wed,  9 Sep 2026 15:39:24 +0200
Message-ID: <20260909134240.654032999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Geurts <paul.geurts@prodrive-technologies.com>

commit bcb721c1bcb02ab225b3937bf131a0bc6fc1fecd upstream.

There is a data race in reading the STATS registers, resulting in wrong
data being read. When the data in the RECENT register switches between
0x24F0 and 0x2500, occasionally value 0x2400 or 0x25F0 is read. This
happens when the value is updated in between reading MSB and LSB.

The data sheet says: "Until a new conversion result is available,
previous values can be read from the statistics registers. Before
reading the statistics registers, set STATS_EN to 0 to prevent any
updates to this register block." As the STATS_EN is currently not
cleared, the values of the stats registers might change mid read,
giving faulty values.

Disable the STATS_EN bit before reading one of the statistics registers to
make sure the device does not update the register mid read. This is
applicable to registers MAX_CHn_xSB, MIN_CHn_xSB and RECENT_CHn_xSB.

This means reading one of the statistics registers resets the MAX and
MIN registers. This is unfortunate, but necessary to get correct data
from the device.

Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
Fixes: 024b08fee342 ("iio: adc: Add driver for ADS7128 / ADS7138")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads7138.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/drivers/iio/adc/ti-ads7138.c
+++ b/drivers/iio/adc/ti-ads7138.c
@@ -227,6 +227,26 @@ static int ads7138_osr_to_bits(int osr)
 	return -EINVAL;
 }
 
+static int ads7138_read_statistics(const struct i2c_client *client, u8 reg,
+				   u8 *out_values, u8 length)
+{
+	int ret;
+
+	/* Disable statistics update so the value is not updated mid read */
+	ret = ads7138_i2c_clear_bit(client, ADS7138_REG_GENERAL_CFG,
+				    ADS7138_GENERAL_CFG_STATS_EN);
+	if (ret)
+		return ret;
+
+	ret = ads7138_i2c_read_block(client, reg, out_values, length);
+	if (ret)
+		return ret;
+
+	/* Enable statistics update after read */
+	return ads7138_i2c_set_bit(client, ADS7138_REG_GENERAL_CFG,
+				   ADS7138_GENERAL_CFG_STATS_EN);
+}
+
 static int ads7138_read_raw(struct iio_dev *indio_dev,
 			    struct iio_chan_spec const *chan, int *val,
 			    int *val2, long mask)
@@ -236,28 +256,32 @@ static int ads7138_read_raw(struct iio_d
 	u8 values[2];
 
 	switch (mask) {
+	/*
+	 * Reading the statistics registers reinitializes them. This is
+	 * unfortunate but necessary to prevent data races.
+	 */
 	case IIO_CHAN_INFO_RAW:
-		ret = ads7138_i2c_read_block(data->client,
-					     ADS7138_REG_RECENT_LSB_CH(chan->channel),
-					     values, ARRAY_SIZE(values));
+		ret = ads7138_read_statistics(data->client,
+					      ADS7138_REG_RECENT_LSB_CH(chan->channel),
+					      values, ARRAY_SIZE(values));
 		if (ret)
 			return ret;
 
 		*val = get_unaligned_le16(values);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_PEAK:
-		ret = ads7138_i2c_read_block(data->client,
-					     ADS7138_REG_MAX_LSB_CH(chan->channel),
-					     values, ARRAY_SIZE(values));
+		ret = ads7138_read_statistics(data->client,
+					      ADS7138_REG_MAX_LSB_CH(chan->channel),
+					      values, ARRAY_SIZE(values));
 		if (ret)
 			return ret;
 
 		*val = get_unaligned_le16(values);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_TROUGH:
-		ret = ads7138_i2c_read_block(data->client,
-					     ADS7138_REG_MIN_LSB_CH(chan->channel),
-					     values, ARRAY_SIZE(values));
+		ret = ads7138_read_statistics(data->client,
+					      ADS7138_REG_MIN_LSB_CH(chan->channel),
+					      values, ARRAY_SIZE(values));
 		if (ret)
 			return ret;
 


