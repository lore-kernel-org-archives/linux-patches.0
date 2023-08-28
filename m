Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D8611C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225EDC433C9;
	Mon, 28 Aug 2023 10:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218981;
	bh=lEFMJ5c70/JyhSLffvLSmsbWV21R8iigdNNZ6D7jSpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/ZoqajXK9Q6uF/mE+nOOnAqzrphqJgTywqAullfW1wKFgME0mQH/d2bhc3jKT3+p
	 1fy8R8m/Jxy7IhuXX6C8WyLt37r6clyUuPkrnVs9m79dPX9fGfpN8IoN5BACMpvbwM
	 Nrg7fGC1ZXgxXjt1BmeuCp2kGkR86W8fxblwFGxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Eckert <Frede@cmslaser.com>,
	William Breathitt Gray <william.gray@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/158] iio: adc: stx104: Implement and utilize register structures
Date: Mon, 28 Aug 2023 12:12:07 +0200
Message-ID: <20230828101158.356304018@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

From: William Breathitt Gray <william.gray@linaro.org>

[ Upstream commit 6cfd14c54b1f42f29097244c1b6208f8268d7d5b ]

Reduce magic numbers and improve code readability by implementing and
utilizing named register data structures.

Tested-by: Fred Eckert <Frede@cmslaser.com>
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/8cb91d5b53e57b066120e42ea07000d6c7ef5543.1657213745.git.william.gray@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 4f9b80aefb9e ("iio: addac: stx104: Fix race condition when converting analog-to-digital")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stx104.c | 74 +++++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/iio/adc/stx104.c b/drivers/iio/adc/stx104.c
index 112362f7d3943..6712da1b818c9 100644
--- a/drivers/iio/adc/stx104.c
+++ b/drivers/iio/adc/stx104.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/spinlock.h>
+#include <linux/types.h>
 
 #define STX104_OUT_CHAN(chan) {				\
 	.type = IIO_VOLTAGE,				\
@@ -44,14 +45,36 @@ static unsigned int num_stx104;
 module_param_hw_array(base, uint, ioport, &num_stx104, 0);
 MODULE_PARM_DESC(base, "Apex Embedded Systems STX104 base addresses");
 
+/**
+ * struct stx104_reg - device register structure
+ * @ssr_ad:	Software Strobe Register and ADC Data
+ * @achan:	ADC Channel
+ * @dio:	Digital I/O
+ * @dac:	DAC Channels
+ * @cir_asr:	Clear Interrupts and ADC Status
+ * @acr:	ADC Control
+ * @pccr_fsh:	Pacer Clock Control and FIFO Status MSB
+ * @acfg:	ADC Configuration
+ */
+struct stx104_reg {
+	u16 ssr_ad;
+	u8 achan;
+	u8 dio;
+	u16 dac[2];
+	u8 cir_asr;
+	u8 acr;
+	u8 pccr_fsh;
+	u8 acfg;
+};
+
 /**
  * struct stx104_iio - IIO device private data structure
  * @chan_out_states:	channels' output states
- * @base:		base port address of the IIO device
+ * @reg:		I/O address offset for the device registers
  */
 struct stx104_iio {
 	unsigned int chan_out_states[STX104_NUM_OUT_CHAN];
-	void __iomem *base;
+	struct stx104_reg __iomem *reg;
 };
 
 /**
@@ -64,7 +87,7 @@ struct stx104_iio {
 struct stx104_gpio {
 	struct gpio_chip chip;
 	spinlock_t lock;
-	void __iomem *base;
+	u8 __iomem *base;
 	unsigned int out_state;
 };
 
@@ -72,6 +95,7 @@ static int stx104_read_raw(struct iio_dev *indio_dev,
 	struct iio_chan_spec const *chan, int *val, int *val2, long mask)
 {
 	struct stx104_iio *const priv = iio_priv(indio_dev);
+	struct stx104_reg __iomem *const reg = priv->reg;
 	unsigned int adc_config;
 	int adbu;
 	int gain;
@@ -79,7 +103,7 @@ static int stx104_read_raw(struct iio_dev *indio_dev,
 	switch (mask) {
 	case IIO_CHAN_INFO_HARDWAREGAIN:
 		/* get gain configuration */
-		adc_config = ioread8(priv->base + 11);
+		adc_config = ioread8(&reg->acfg);
 		gain = adc_config & 0x3;
 
 		*val = 1 << gain;
@@ -91,24 +115,26 @@ static int stx104_read_raw(struct iio_dev *indio_dev,
 		}
 
 		/* select ADC channel */
-		iowrite8(chan->channel | (chan->channel << 4), priv->base + 2);
+		iowrite8(chan->channel | (chan->channel << 4), &reg->achan);
 
-		/* trigger ADC sample capture and wait for completion */
-		iowrite8(0, priv->base);
-		while (ioread8(priv->base + 8) & BIT(7));
+		/* trigger ADC sample capture by writing to the 8-bit
+		 * Software Strobe Register and wait for completion
+		 */
+		iowrite8(0, &reg->ssr_ad);
+		while (ioread8(&reg->cir_asr) & BIT(7));
 
-		*val = ioread16(priv->base);
+		*val = ioread16(&reg->ssr_ad);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_OFFSET:
 		/* get ADC bipolar/unipolar configuration */
-		adc_config = ioread8(priv->base + 11);
+		adc_config = ioread8(&reg->acfg);
 		adbu = !(adc_config & BIT(2));
 
 		*val = -32768 * adbu;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		/* get ADC bipolar/unipolar and gain configuration */
-		adc_config = ioread8(priv->base + 11);
+		adc_config = ioread8(&reg->acfg);
 		adbu = !(adc_config & BIT(2));
 		gain = adc_config & 0x3;
 
@@ -130,16 +156,16 @@ static int stx104_write_raw(struct iio_dev *indio_dev,
 		/* Only four gain states (x1, x2, x4, x8) */
 		switch (val) {
 		case 1:
-			iowrite8(0, priv->base + 11);
+			iowrite8(0, &priv->reg->acfg);
 			break;
 		case 2:
-			iowrite8(1, priv->base + 11);
+			iowrite8(1, &priv->reg->acfg);
 			break;
 		case 4:
-			iowrite8(2, priv->base + 11);
+			iowrite8(2, &priv->reg->acfg);
 			break;
 		case 8:
-			iowrite8(3, priv->base + 11);
+			iowrite8(3, &priv->reg->acfg);
 			break;
 		default:
 			return -EINVAL;
@@ -153,7 +179,7 @@ static int stx104_write_raw(struct iio_dev *indio_dev,
 				return -EINVAL;
 
 			priv->chan_out_states[chan->channel] = val;
-			iowrite16(val, priv->base + 4 + 2 * chan->channel);
+			iowrite16(val, &priv->reg->dac[chan->channel]);
 
 			return 0;
 		}
@@ -307,15 +333,15 @@ static int stx104_probe(struct device *dev, unsigned int id)
 	}
 
 	priv = iio_priv(indio_dev);
-	priv->base = devm_ioport_map(dev, base[id], STX104_EXTENT);
-	if (!priv->base)
+	priv->reg = devm_ioport_map(dev, base[id], STX104_EXTENT);
+	if (!priv->reg)
 		return -ENOMEM;
 
 	indio_dev->info = &stx104_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
 	/* determine if differential inputs */
-	if (ioread8(priv->base + 8) & BIT(5)) {
+	if (ioread8(&priv->reg->cir_asr) & BIT(5)) {
 		indio_dev->num_channels = ARRAY_SIZE(stx104_channels_diff);
 		indio_dev->channels = stx104_channels_diff;
 	} else {
@@ -327,14 +353,14 @@ static int stx104_probe(struct device *dev, unsigned int id)
 	indio_dev->dev.parent = dev;
 
 	/* configure device for software trigger operation */
-	iowrite8(0, priv->base + 9);
+	iowrite8(0, &priv->reg->acr);
 
 	/* initialize gain setting to x1 */
-	iowrite8(0, priv->base + 11);
+	iowrite8(0, &priv->reg->acfg);
 
 	/* initialize DAC output to 0V */
-	iowrite16(0, priv->base + 4);
-	iowrite16(0, priv->base + 6);
+	iowrite16(0, &priv->reg->dac[0]);
+	iowrite16(0, &priv->reg->dac[1]);
 
 	stx104gpio->chip.label = dev_name(dev);
 	stx104gpio->chip.parent = dev;
@@ -349,7 +375,7 @@ static int stx104_probe(struct device *dev, unsigned int id)
 	stx104gpio->chip.get_multiple = stx104_gpio_get_multiple;
 	stx104gpio->chip.set = stx104_gpio_set;
 	stx104gpio->chip.set_multiple = stx104_gpio_set_multiple;
-	stx104gpio->base = priv->base + 3;
+	stx104gpio->base = &priv->reg->dio;
 	stx104gpio->out_state = 0x0;
 
 	spin_lock_init(&stx104gpio->lock);
-- 
2.40.1



