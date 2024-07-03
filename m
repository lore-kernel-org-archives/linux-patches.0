Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538FA1946A0;
	Wed,  3 Jul 2024 10:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004321; cv=none; b=XMLBiLCRcF+r+1bbUDsCHM9Rr9teovb+TiUhdWkz9Cbm5GGgRyLdDQGWQHk2JEAkQ/vk80ZyCIWYG96XbxNkmfhPrFqsP/rM6tGpTUh/bWyjkfCa7ukqCrzp3ATpLoQ8i5ZC1VEaExVx3StwfnVc4ODScY8GuwJ0ly/ioQAVb9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004321; c=relaxed/simple;
	bh=NsnQfjdYWRXGtFVKOVAAA8v5vtdnvDOcdwU+krxGl/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P62R0HTJ8zCa14Gr2usGll5gpPI5z0b/UdgknxhaIOC2wg7HHisAhb9XSFTa7ky7OE1kZ9/7kiUhn5PWLC9+h7CRDasDjdiZjdELV1lYeQZnYbex15c6TTTR4ns/8dCqWaFrkX6p1j2AAcvZMznutGkVB5QdEvit7hvtN4kETvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8zrmQay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8zrmQay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9DFC32781;
	Wed,  3 Jul 2024 10:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004321;
	bh=NsnQfjdYWRXGtFVKOVAAA8v5vtdnvDOcdwU+krxGl/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8zrmQayzGvPuYydgQeXdpLzvSzTtHOt3K6BSTHXIP1Yfd9goXmB9erUZ/KOCtKNF
	 LIO2WnTxvZDy79Kmw1+bW3Wz6tjHOwZyFBLKwep9xUwQhePdUGA4N0xFiAWWRtCyCa
	 h96Y8j4k7iJyG8jfSMBKqovAvO3pvnm9fbt099q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 164/189] iio: chemical: bme680: Fix sensor data read operation
Date: Wed,  3 Jul 2024 12:40:25 +0200
Message-ID: <20240703102847.658629549@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit 4241665e6ea063a9c1d734de790121a71db763fc upstream.

A read operation is happening as follows:

a) Set sensor to forced mode
b) Sensor measures values and update data registers and sleeps again
c) Read data registers

In the current implementation the read operation happens immediately
after the sensor is set to forced mode so the sensor does not have
the time to update properly the registers. This leads to the following
2 problems:

1) The first ever value which is read by the register is always wrong
2) Every read operation, puts the register into forced mode and reads
the data that were calculated in the previous conversion.

This behaviour was tested in 2 ways:

1) The internal meas_status_0 register was read before and after every
read operation in order to verify that the data were ready even before
the register was set to forced mode and also to check that after the
forced mode was set the new data were not yet ready.

2) Physically changing the temperature and measuring the temperature

This commit adds the waiting time in between the set of the forced mode
and the read of the data. The function is taken from the Bosch BME68x
Sensor API [1].

[1]: https://github.com/boschsensortec/BME68x_SensorAPI/blob/v4.4.8/bme68x.c#L490

Fixes: 1b3bd8592780 ("iio: chemical: Add support for Bosch BME680 sensor")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240606212313.207550-5-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680.h      |    2 +
 drivers/iio/chemical/bme680_core.c |   46 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

--- a/drivers/iio/chemical/bme680.h
+++ b/drivers/iio/chemical/bme680.h
@@ -54,7 +54,9 @@
 #define   BME680_NB_CONV_MASK			GENMASK(3, 0)
 
 #define BME680_REG_MEAS_STAT_0			0x1D
+#define   BME680_NEW_DATA_BIT			BIT(7)
 #define   BME680_GAS_MEAS_BIT			BIT(6)
+#define   BME680_MEAS_BIT			BIT(5)
 
 /* Calibration Parameters */
 #define BME680_T2_LSB_REG	0x8A
--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -10,6 +10,7 @@
  */
 #include <linux/acpi.h>
 #include <linux/bitfield.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/log2.h>
@@ -524,6 +525,43 @@ static u8 bme680_oversampling_to_reg(u8
 	return ilog2(val) + 1;
 }
 
+/*
+ * Taken from Bosch BME680 API:
+ * https://github.com/boschsensortec/BME68x_SensorAPI/blob/v4.4.8/bme68x.c#L490
+ */
+static int bme680_wait_for_eoc(struct bme680_data *data)
+{
+	struct device *dev = regmap_get_device(data->regmap);
+	unsigned int check;
+	int ret;
+	/*
+	 * (Sum of oversampling ratios * time per oversampling) +
+	 * TPH measurement + gas measurement + wait transition from forced mode
+	 * + heater duration
+	 */
+	int wait_eoc_us = ((data->oversampling_temp + data->oversampling_press +
+			   data->oversampling_humid) * 1936) + (477 * 4) +
+			   (477 * 5) + 1000 + (data->heater_dur * 1000);
+
+	usleep_range(wait_eoc_us, wait_eoc_us + 100);
+
+	ret = regmap_read(data->regmap, BME680_REG_MEAS_STAT_0, &check);
+	if (ret) {
+		dev_err(dev, "failed to read measurement status register.\n");
+		return ret;
+	}
+	if (check & BME680_MEAS_BIT) {
+		dev_err(dev, "Device measurement cycle incomplete.\n");
+		return -EBUSY;
+	}
+	if (!(check & BME680_NEW_DATA_BIT)) {
+		dev_err(dev, "No new data available from the device.\n");
+		return -ENODATA;
+	}
+
+	return 0;
+}
+
 static int bme680_chip_config(struct bme680_data *data)
 {
 	struct device *dev = regmap_get_device(data->regmap);
@@ -614,6 +652,10 @@ static int bme680_read_temp(struct bme68
 	if (ret < 0)
 		return ret;
 
+	ret = bme680_wait_for_eoc(data);
+	if (ret)
+		return ret;
+
 	ret = regmap_bulk_read(data->regmap, BME680_REG_TEMP_MSB,
 			       (u8 *) &tmp, 3);
 	if (ret < 0) {
@@ -730,6 +772,10 @@ static int bme680_read_gas(struct bme680
 	if (ret < 0)
 		return ret;
 
+	ret = bme680_wait_for_eoc(data);
+	if (ret)
+		return ret;
+
 	ret = regmap_read(data->regmap, BME680_REG_MEAS_STAT_0, &check);
 	if (check & BME680_GAS_MEAS_BIT) {
 		dev_err(dev, "gas measurement incomplete\n");


