Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F8C19F43A;
	Thu,  3 Jul 2025 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554547; cv=none; b=ZMghMB5g/oqajmi5yx/dYQQGNHgY9GdTavHrBkuofKLTy+L+PhH7vnWf20DPZ3QgFW6kYuxfLhJZ1zgyvabveybN/4229uChv2xTyn1oV/BrI9CcpKURAe07UD1rzCW+DaFkUyS1cCW6YPaHUhQJg/mX6JXB/WLjYEPKPGueOu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554547; c=relaxed/simple;
	bh=ey7tr8u1JwxM24yLbz1JnQm1pQiSQzRq05h+UDbuvGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNNvA9CKXkcPAN1RCxAohCQ1X3w57aSHPcDo0Yc3JJteyfw87X9dXcXKoiuZoOcYiprW79Fg/GK4y0KmRjJ5qXhWx8jUhMq1HlI3KXbxTFvKi8DDz4lHCgvJ8aayNwu77HbpSYnnQd/AtXnVZJmPUpUj8VFau+g0gF74xTc1j68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwVZ4+2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwVZ4+2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B4FC4CEE3;
	Thu,  3 Jul 2025 14:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554547;
	bh=ey7tr8u1JwxM24yLbz1JnQm1pQiSQzRq05h+UDbuvGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwVZ4+2jKIVC55ocQFolpepWbTbmt22atf0/u5DAq8Qem63yU6iq+E80IV8JjQPgc
	 CHlPqCs1PWe5acNBtQyOtdu2M/0szMwOWhMoyGigwrMdZHPWQdbiznXKtPiC3yBmYJ
	 K0qvGThQtS+hEHzUmA2ymgfYOZfj/3L0xXP2eeCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/218] iio: dac: ad3552r: changes to use FIELD_PREP
Date: Thu,  3 Jul 2025 16:42:23 +0200
Message-ID: <20250703144004.002303742@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Angelo Dureghello <adureghello@baylibre.com>

[ Upstream commit d5ac6cb1c8f3e14d93e2a50d9357a8acdbc5c166 ]

Changes to use FIELD_PREP, so that driver-specific ad3552r_field_prep
is removed. Variables (arrays) that was used to call ad3552r_field_prep
are removed too.

Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20241028-wip-bl-ad3552r-axi-v0-iio-testing-v9-5-f6960b4f9719@kernel-space.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad3552r.c | 167 ++++++++++++--------------------------
 1 file changed, 50 insertions(+), 117 deletions(-)

diff --git a/drivers/iio/dac/ad3552r.c b/drivers/iio/dac/ad3552r.c
index 390d3fab21478..aa453d3de5e1c 100644
--- a/drivers/iio/dac/ad3552r.c
+++ b/drivers/iio/dac/ad3552r.c
@@ -6,6 +6,7 @@
  * Copyright 2021 Analog Devices Inc.
  */
 #include <linux/unaligned.h>
+#include <linux/bitfield.h>
 #include <linux/device.h>
 #include <linux/iio/triggered_buffer.h>
 #include <linux/iio/trigger_consumer.h>
@@ -210,46 +211,6 @@ static const s32 gains_scaling_table[] = {
 	[AD3552R_CH_GAIN_SCALING_0_125]		= 125
 };
 
-enum ad3552r_dev_attributes {
-	/* - Direct register values */
-	/* From 0-3 */
-	AD3552R_SDO_DRIVE_STRENGTH,
-	/*
-	 * 0 -> Internal Vref, vref_io pin floating (default)
-	 * 1 -> Internal Vref, vref_io driven by internal vref
-	 * 2 or 3 -> External Vref
-	 */
-	AD3552R_VREF_SELECT,
-	/* Read registers in ascending order if set. Else descending */
-	AD3552R_ADDR_ASCENSION,
-};
-
-enum ad3552r_ch_attributes {
-	/* DAC powerdown */
-	AD3552R_CH_DAC_POWERDOWN,
-	/* DAC amplifier powerdown */
-	AD3552R_CH_AMPLIFIER_POWERDOWN,
-	/* Select the output range. Select from enum ad3552r_ch_output_range */
-	AD3552R_CH_OUTPUT_RANGE_SEL,
-	/*
-	 * Over-rider the range selector in order to manually set the output
-	 * voltage range
-	 */
-	AD3552R_CH_RANGE_OVERRIDE,
-	/* Manually set the offset voltage */
-	AD3552R_CH_GAIN_OFFSET,
-	/* Sets the polarity of the offset. */
-	AD3552R_CH_GAIN_OFFSET_POLARITY,
-	/* PDAC gain scaling */
-	AD3552R_CH_GAIN_SCALING_P,
-	/* NDAC gain scaling */
-	AD3552R_CH_GAIN_SCALING_N,
-	/* Rfb value */
-	AD3552R_CH_RFB,
-	/* Channel select. When set allow Input -> DAC and Mask -> DAC */
-	AD3552R_CH_SELECT,
-};
-
 struct ad3552r_ch_data {
 	s32	scale_int;
 	s32	scale_dec;
@@ -285,45 +246,6 @@ struct ad3552r_desc {
 	unsigned int		num_ch;
 };
 
-static const u16 addr_mask_map[][2] = {
-	[AD3552R_ADDR_ASCENSION] = {
-			AD3552R_REG_ADDR_INTERFACE_CONFIG_A,
-			AD3552R_MASK_ADDR_ASCENSION
-	},
-	[AD3552R_SDO_DRIVE_STRENGTH] = {
-			AD3552R_REG_ADDR_INTERFACE_CONFIG_D,
-			AD3552R_MASK_SDO_DRIVE_STRENGTH
-	},
-	[AD3552R_VREF_SELECT] = {
-			AD3552R_REG_ADDR_SH_REFERENCE_CONFIG,
-			AD3552R_MASK_REFERENCE_VOLTAGE_SEL
-	},
-};
-
-/* 0 -> reg addr, 1->ch0 mask, 2->ch1 mask */
-static const u16 addr_mask_map_ch[][3] = {
-	[AD3552R_CH_DAC_POWERDOWN] = {
-			AD3552R_REG_ADDR_POWERDOWN_CONFIG,
-			AD3552R_MASK_CH_DAC_POWERDOWN(0),
-			AD3552R_MASK_CH_DAC_POWERDOWN(1)
-	},
-	[AD3552R_CH_AMPLIFIER_POWERDOWN] = {
-			AD3552R_REG_ADDR_POWERDOWN_CONFIG,
-			AD3552R_MASK_CH_AMPLIFIER_POWERDOWN(0),
-			AD3552R_MASK_CH_AMPLIFIER_POWERDOWN(1)
-	},
-	[AD3552R_CH_OUTPUT_RANGE_SEL] = {
-			AD3552R_REG_ADDR_CH0_CH1_OUTPUT_RANGE,
-			AD3552R_MASK_CH_OUTPUT_RANGE_SEL(0),
-			AD3552R_MASK_CH_OUTPUT_RANGE_SEL(1)
-	},
-	[AD3552R_CH_SELECT] = {
-			AD3552R_REG_ADDR_CH_SELECT_16B,
-			AD3552R_MASK_CH(0),
-			AD3552R_MASK_CH(1)
-	}
-};
-
 static u8 _ad3552r_reg_len(u8 addr)
 {
 	switch (addr) {
@@ -399,11 +321,6 @@ static int ad3552r_read_reg(struct ad3552r_desc *dac, u8 addr, u16 *val)
 	return 0;
 }
 
-static u16 ad3552r_field_prep(u16 val, u16 mask)
-{
-	return (val << __ffs(mask)) & mask;
-}
-
 /* Update field of a register, shift val if needed */
 static int ad3552r_update_reg_field(struct ad3552r_desc *dac, u8 addr, u16 mask,
 				    u16 val)
@@ -416,21 +333,11 @@ static int ad3552r_update_reg_field(struct ad3552r_desc *dac, u8 addr, u16 mask,
 		return ret;
 
 	reg &= ~mask;
-	reg |= ad3552r_field_prep(val, mask);
+	reg |= val;
 
 	return ad3552r_write_reg(dac, addr, reg);
 }
 
-static int ad3552r_set_ch_value(struct ad3552r_desc *dac,
-				enum ad3552r_ch_attributes attr,
-				u8 ch,
-				u16 val)
-{
-	/* Update register related to attributes in chip */
-	return ad3552r_update_reg_field(dac, addr_mask_map_ch[attr][0],
-				       addr_mask_map_ch[attr][ch + 1], val);
-}
-
 #define AD3552R_CH_DAC(_idx) ((struct iio_chan_spec) {		\
 	.type = IIO_VOLTAGE,					\
 	.output = true,						\
@@ -510,8 +417,14 @@ static int ad3552r_write_raw(struct iio_dev *indio_dev,
 					val);
 		break;
 	case IIO_CHAN_INFO_ENABLE:
-		err = ad3552r_set_ch_value(dac, AD3552R_CH_DAC_POWERDOWN,
-					   chan->channel, !val);
+		if (chan->channel == 0)
+			val = FIELD_PREP(AD3552R_MASK_CH_DAC_POWERDOWN(0), !val);
+		else
+			val = FIELD_PREP(AD3552R_MASK_CH_DAC_POWERDOWN(1), !val);
+
+		err = ad3552r_update_reg_field(dac, AD3552R_REG_ADDR_POWERDOWN_CONFIG,
+					       AD3552R_MASK_CH_DAC_POWERDOWN(chan->channel),
+					       val);
 		break;
 	default:
 		err = -EINVAL;
@@ -721,9 +634,9 @@ static int ad3552r_reset(struct ad3552r_desc *dac)
 		return ret;
 
 	return ad3552r_update_reg_field(dac,
-					addr_mask_map[AD3552R_ADDR_ASCENSION][0],
-					addr_mask_map[AD3552R_ADDR_ASCENSION][1],
-					val);
+					AD3552R_REG_ADDR_INTERFACE_CONFIG_A,
+					AD3552R_MASK_ADDR_ASCENSION,
+					FIELD_PREP(AD3552R_MASK_ADDR_ASCENSION, val));
 }
 
 static void ad3552r_get_custom_range(struct ad3552r_desc *dac, s32 i, s32 *v_min,
@@ -818,20 +731,20 @@ static int ad3552r_configure_custom_gain(struct ad3552r_desc *dac,
 				     "mandatory custom-output-range-config property missing\n");
 
 	dac->ch_data[ch].range_override = 1;
-	reg |= ad3552r_field_prep(1, AD3552R_MASK_CH_RANGE_OVERRIDE);
+	reg |= FIELD_PREP(AD3552R_MASK_CH_RANGE_OVERRIDE, 1);
 
 	err = fwnode_property_read_u32(gain_child, "adi,gain-scaling-p", &val);
 	if (err)
 		return dev_err_probe(dev, err,
 				     "mandatory adi,gain-scaling-p property missing\n");
-	reg |= ad3552r_field_prep(val, AD3552R_MASK_CH_GAIN_SCALING_P);
+	reg |= FIELD_PREP(AD3552R_MASK_CH_GAIN_SCALING_P, val);
 	dac->ch_data[ch].p = val;
 
 	err = fwnode_property_read_u32(gain_child, "adi,gain-scaling-n", &val);
 	if (err)
 		return dev_err_probe(dev, err,
 				     "mandatory adi,gain-scaling-n property missing\n");
-	reg |= ad3552r_field_prep(val, AD3552R_MASK_CH_GAIN_SCALING_N);
+	reg |= FIELD_PREP(AD3552R_MASK_CH_GAIN_SCALING_N, val);
 	dac->ch_data[ch].n = val;
 
 	err = fwnode_property_read_u32(gain_child, "adi,rfb-ohms", &val);
@@ -847,9 +760,9 @@ static int ad3552r_configure_custom_gain(struct ad3552r_desc *dac,
 	dac->ch_data[ch].gain_offset = val;
 
 	offset = abs((s32)val);
-	reg |= ad3552r_field_prep((offset >> 8), AD3552R_MASK_CH_OFFSET_BIT_8);
+	reg |= FIELD_PREP(AD3552R_MASK_CH_OFFSET_BIT_8, (offset >> 8));
 
-	reg |= ad3552r_field_prep((s32)val < 0, AD3552R_MASK_CH_OFFSET_POLARITY);
+	reg |= FIELD_PREP(AD3552R_MASK_CH_OFFSET_POLARITY, (s32)val < 0);
 	addr = AD3552R_REG_ADDR_CH_GAIN(ch);
 	err = ad3552r_write_reg(dac, addr,
 				offset & AD3552R_MASK_CH_OFFSET_BITS_0_7);
@@ -892,9 +805,9 @@ static int ad3552r_configure_device(struct ad3552r_desc *dac)
 	}
 
 	err = ad3552r_update_reg_field(dac,
-				       addr_mask_map[AD3552R_VREF_SELECT][0],
-				       addr_mask_map[AD3552R_VREF_SELECT][1],
-				       val);
+				       AD3552R_REG_ADDR_SH_REFERENCE_CONFIG,
+				       AD3552R_MASK_REFERENCE_VOLTAGE_SEL,
+				       FIELD_PREP(AD3552R_MASK_REFERENCE_VOLTAGE_SEL, val));
 	if (err)
 		return err;
 
@@ -906,9 +819,9 @@ static int ad3552r_configure_device(struct ad3552r_desc *dac)
 		}
 
 		err = ad3552r_update_reg_field(dac,
-					       addr_mask_map[AD3552R_SDO_DRIVE_STRENGTH][0],
-					       addr_mask_map[AD3552R_SDO_DRIVE_STRENGTH][1],
-					       val);
+					       AD3552R_REG_ADDR_INTERFACE_CONFIG_D,
+					       AD3552R_MASK_SDO_DRIVE_STRENGTH,
+					       FIELD_PREP(AD3552R_MASK_SDO_DRIVE_STRENGTH, val));
 		if (err)
 			return err;
 	}
@@ -944,9 +857,15 @@ static int ad3552r_configure_device(struct ad3552r_desc *dac)
 						     "Invalid adi,output-range-microvolt value\n");
 
 			val = err;
-			err = ad3552r_set_ch_value(dac,
-						   AD3552R_CH_OUTPUT_RANGE_SEL,
-						   ch, val);
+			if (ch == 0)
+				val = FIELD_PREP(AD3552R_MASK_CH_OUTPUT_RANGE_SEL(0), val);
+			else
+				val = FIELD_PREP(AD3552R_MASK_CH_OUTPUT_RANGE_SEL(1), val);
+
+			err = ad3552r_update_reg_field(dac,
+						       AD3552R_REG_ADDR_CH0_CH1_OUTPUT_RANGE,
+						       AD3552R_MASK_CH_OUTPUT_RANGE_SEL(ch),
+						       val);
 			if (err)
 				return err;
 
@@ -964,7 +883,14 @@ static int ad3552r_configure_device(struct ad3552r_desc *dac)
 		ad3552r_calc_gain_and_offset(dac, ch);
 		dac->enabled_ch |= BIT(ch);
 
-		err = ad3552r_set_ch_value(dac, AD3552R_CH_SELECT, ch, 1);
+		if (ch == 0)
+			val = FIELD_PREP(AD3552R_MASK_CH(0), 1);
+		else
+			val = FIELD_PREP(AD3552R_MASK_CH(1), 1);
+
+		err = ad3552r_update_reg_field(dac,
+					       AD3552R_REG_ADDR_CH_SELECT_16B,
+					       AD3552R_MASK_CH(ch), val);
 		if (err < 0)
 			return err;
 
@@ -976,8 +902,15 @@ static int ad3552r_configure_device(struct ad3552r_desc *dac)
 	/* Disable unused channels */
 	for_each_clear_bit(ch, &dac->enabled_ch,
 			   dac->model_data->num_hw_channels) {
-		err = ad3552r_set_ch_value(dac, AD3552R_CH_AMPLIFIER_POWERDOWN,
-					   ch, 1);
+		if (ch == 0)
+			val = FIELD_PREP(AD3552R_MASK_CH_AMPLIFIER_POWERDOWN(0), 1);
+		else
+			val = FIELD_PREP(AD3552R_MASK_CH_AMPLIFIER_POWERDOWN(1), 1);
+
+		err = ad3552r_update_reg_field(dac,
+					       AD3552R_REG_ADDR_POWERDOWN_CONFIG,
+					       AD3552R_MASK_CH_AMPLIFIER_POWERDOWN(ch),
+					       val);
 		if (err)
 			return err;
 	}
-- 
2.39.5



