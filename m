Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470121E8332;
	Tue, 17 Jun 2025 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177409; cv=none; b=ihbPY4By8t2Dcis+psBaVgy6HtEKYQn9UxqAwWqJJOd03faxdUFI1YB7Kpu9uY2RJJDBJcN5mDFvtyrM/gb6fvi2NDW376RyRWFrcGBkoAitX/jU7CDv1o+kh7U8WkpWVM7dVSs/MA9vphJNKhd4RXNk0jy731sxXfH/xTZoOXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177409; c=relaxed/simple;
	bh=/cEr+0gjhnvAUkeRBz61N26M+fo9OE1n8fvgPaN1Ras=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buu8yI9cTOB56IZLRWt2pNEYQvcFd1/4Yc78Mw45xZKChJr33e++veAS6Sm3m4ekVIP5HKjJXsi6b/eeplGh0z0GVksrihaoEWtBe17xj/Sohu0zJIFnP0cyM1FX8ZsvWtWmkMhTqOpHsjrRYt9bDvW4g0qGYc1xTN1tdzD+fYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5oLiwzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5oLiwzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5846DC4CEE3;
	Tue, 17 Jun 2025 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177408;
	bh=/cEr+0gjhnvAUkeRBz61N26M+fo9OE1n8fvgPaN1Ras=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5oLiwzrHIi8UyIj+gJuo4vXmw1DfhS3SbIq6SgzZX2JpofKTxvxuIbIPQc4RtNwM
	 i/cvemw3XJhbhHmPzwUmb9Z9hw+KM8VQtBj4viVnoH5ADBsY5EDgZX6Tz6Lw8P5SJN
	 Toy92uQviP0AxRXQa4JbVNCZtU2B7YDF9b0AFKO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Rauber <lukas.rauber@janitza.de>,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/512] iio: adc: mcp3911: fix device dependent mappings for conversion result registers
Date: Tue, 17 Jun 2025 17:25:05 +0200
Message-ID: <20250617152433.342452920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit f62c49d8f32d6ce8871b01795498352775aa61db ]

The conversion result registers differs between devices. Make sure the
mapping is correct by using a device dependent .get_raw() callback function.

Fixes: 732ad34260d3 ("iio: adc: mcp3911: add support for the whole MCP39xx family")
Co-developed-by: Lukas Rauber <lukas.rauber@janitza.de>
Signed-off-by: Lukas Rauber <lukas.rauber@janitza.de>
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20250428-mcp3911-fixes-v2-1-406e39330c3d@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mcp3911.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
index b097f04172c80..4bd6b5aac4fe8 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2018 Kent Gustavsson <kent@minoris.se>
  */
 #include <linux/bitfield.h>
-#include <linux/bits.h>
+#include <linux/bitops.h>
 #include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -79,6 +79,8 @@
 #define MCP3910_CONFIG1_CLKEXT		BIT(6)
 #define MCP3910_CONFIG1_VREFEXT		BIT(7)
 
+#define MCP3910_CHANNEL(ch)		(MCP3911_REG_CHANNEL0 + (ch))
+
 #define MCP3910_REG_OFFCAL_CH0		0x0f
 #define MCP3910_OFFCAL(ch)		(MCP3910_REG_OFFCAL_CH0 + (ch) * 6)
 
@@ -110,6 +112,7 @@ struct mcp3911_chip_info {
 	int (*get_offset)(struct mcp3911 *adc, int channel, int *val);
 	int (*set_offset)(struct mcp3911 *adc, int channel, int val);
 	int (*set_scale)(struct mcp3911 *adc, int channel, u32 val);
+	int (*get_raw)(struct mcp3911 *adc, int channel, int *val);
 };
 
 struct mcp3911 {
@@ -170,6 +173,18 @@ static int mcp3911_update(struct mcp3911 *adc, u8 reg, u32 mask, u32 val, u8 len
 	return mcp3911_write(adc, reg, val, len);
 }
 
+static int mcp3911_read_s24(struct mcp3911 *const adc, u8 const reg, s32 *const val)
+{
+	u32 uval;
+	int const ret = mcp3911_read(adc, reg, &uval, 3);
+
+	if (ret)
+		return ret;
+
+	*val = sign_extend32(uval, 23);
+	return ret;
+}
+
 static int mcp3910_enable_offset(struct mcp3911 *adc, bool enable)
 {
 	unsigned int mask = MCP3910_CONFIG0_EN_OFFCAL;
@@ -194,6 +209,11 @@ static int mcp3910_set_offset(struct mcp3911 *adc, int channel, int val)
 	return adc->chip->enable_offset(adc, 1);
 }
 
+static int mcp3910_get_raw(struct mcp3911 *adc, int channel, s32 *val)
+{
+	return mcp3911_read_s24(adc, MCP3910_CHANNEL(channel), val);
+}
+
 static int mcp3911_enable_offset(struct mcp3911 *adc, bool enable)
 {
 	unsigned int mask = MCP3911_STATUSCOM_EN_OFFCAL;
@@ -218,6 +238,11 @@ static int mcp3911_set_offset(struct mcp3911 *adc, int channel, int val)
 	return adc->chip->enable_offset(adc, 1);
 }
 
+static int mcp3911_get_raw(struct mcp3911 *adc, int channel, s32 *val)
+{
+	return mcp3911_read_s24(adc, MCP3911_CHANNEL(channel), val);
+}
+
 static int mcp3910_get_osr(struct mcp3911 *adc, u32 *val)
 {
 	int ret;
@@ -321,12 +346,9 @@ static int mcp3911_read_raw(struct iio_dev *indio_dev,
 	guard(mutex)(&adc->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		ret = mcp3911_read(adc,
-				   MCP3911_CHANNEL(channel->channel), val, 3);
+		ret = adc->chip->get_raw(adc, channel->channel, val);
 		if (ret)
 			return ret;
-
-		*val = sign_extend32(*val, 23);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_OFFSET:
 		ret = adc->chip->get_offset(adc, channel->channel, val);
@@ -799,6 +821,7 @@ static const struct mcp3911_chip_info mcp3911_chip_info[] = {
 		.get_offset = mcp3910_get_offset,
 		.set_offset = mcp3910_set_offset,
 		.set_scale = mcp3910_set_scale,
+		.get_raw = mcp3910_get_raw,
 	},
 	[MCP3911] = {
 		.channels = mcp3911_channels,
@@ -810,6 +833,7 @@ static const struct mcp3911_chip_info mcp3911_chip_info[] = {
 		.get_offset = mcp3911_get_offset,
 		.set_offset = mcp3911_set_offset,
 		.set_scale = mcp3911_set_scale,
+		.get_raw = mcp3911_get_raw,
 	},
 	[MCP3912] = {
 		.channels = mcp3912_channels,
@@ -821,6 +845,7 @@ static const struct mcp3911_chip_info mcp3911_chip_info[] = {
 		.get_offset = mcp3910_get_offset,
 		.set_offset = mcp3910_set_offset,
 		.set_scale = mcp3910_set_scale,
+		.get_raw = mcp3910_get_raw,
 	},
 	[MCP3913] = {
 		.channels = mcp3913_channels,
@@ -832,6 +857,7 @@ static const struct mcp3911_chip_info mcp3911_chip_info[] = {
 		.get_offset = mcp3910_get_offset,
 		.set_offset = mcp3910_set_offset,
 		.set_scale = mcp3910_set_scale,
+		.get_raw = mcp3910_get_raw,
 	},
 	[MCP3914] = {
 		.channels = mcp3914_channels,
@@ -843,6 +869,7 @@ static const struct mcp3911_chip_info mcp3911_chip_info[] = {
 		.get_offset = mcp3910_get_offset,
 		.set_offset = mcp3910_set_offset,
 		.set_scale = mcp3910_set_scale,
+		.get_raw = mcp3910_get_raw,
 	},
 	[MCP3918] = {
 		.channels = mcp3918_channels,
@@ -854,6 +881,7 @@ static const struct mcp3911_chip_info mcp3911_chip_info[] = {
 		.get_offset = mcp3910_get_offset,
 		.set_offset = mcp3910_set_offset,
 		.set_scale = mcp3910_set_scale,
+		.get_raw = mcp3910_get_raw,
 	},
 	[MCP3919] = {
 		.channels = mcp3919_channels,
@@ -865,6 +893,7 @@ static const struct mcp3911_chip_info mcp3911_chip_info[] = {
 		.get_offset = mcp3910_get_offset,
 		.set_offset = mcp3910_set_offset,
 		.set_scale = mcp3910_set_scale,
+		.get_raw = mcp3910_get_raw,
 	},
 };
 static const struct of_device_id mcp3911_dt_ids[] = {
-- 
2.39.5



