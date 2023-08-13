Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C2E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE11CC433C7;
	Sun, 13 Aug 2023 21:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962632;
	bh=cOGs0bvySrHx0D6kqztLrfigfYfaAHabak1eE7HqQG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjLWQbGGfgMRRoJq/6dLYzhPBpFBX3/B6+uc9C+DRCW2OzY0S9sxjkm56Xftlexgw
	 xLrs2ldcyhqeuAWieTlySWM7ndIPdyGKnIPgXIU9Utlv3ODOodqZGNnMcdfFW9hfc3
	 y9HF7PaOOgQ9R7OchdD8/7Toy6JEovWu0sn57ixg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alisa Roman <alisa.roman@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 054/149] iio: adc: ad7192: Fix ac excitation feature
Date: Sun, 13 Aug 2023 23:18:19 +0200
Message-ID: <20230813211720.431239213@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alisa Roman <alisa.roman@analog.com>

commit 6bc471b6c3aeaa7b95d1b86a1bb8d91a3c341fa5 upstream.

AC excitation enable feature exposed to user on AD7192, allowing a bit
which should be 0 to be set. This feature is specific only to AD7195. AC
excitation attribute moved accordingly.

In the AD7195 documentation, the AC excitation enable bit is on position
22 in the Configuration register. ACX macro changed to match correct
register and bit.

Note that the fix tag is for the commit that moved the driver out of
staging.

Fixes: b581f748cce0 ("staging: iio: adc: ad7192: move out of staging")
Signed-off-by: Alisa Roman <alisa.roman@analog.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230614155242.160296-1-alisa.roman@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7192.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -62,7 +62,6 @@
 #define AD7192_MODE_STA_MASK	BIT(20) /* Status Register transmission Mask */
 #define AD7192_MODE_CLKSRC(x)	(((x) & 0x3) << 18) /* Clock Source Select */
 #define AD7192_MODE_SINC3	BIT(15) /* SINC3 Filter Select */
-#define AD7192_MODE_ACX		BIT(14) /* AC excitation enable(AD7195 only)*/
 #define AD7192_MODE_ENPAR	BIT(13) /* Parity Enable */
 #define AD7192_MODE_CLKDIV	BIT(12) /* Clock divide by 2 (AD7190/2 only)*/
 #define AD7192_MODE_SCYCLE	BIT(11) /* Single cycle conversion */
@@ -91,6 +90,7 @@
 /* Configuration Register Bit Designations (AD7192_REG_CONF) */
 
 #define AD7192_CONF_CHOP	BIT(23) /* CHOP enable */
+#define AD7192_CONF_ACX		BIT(22) /* AC excitation enable(AD7195 only) */
 #define AD7192_CONF_REFSEL	BIT(20) /* REFIN1/REFIN2 Reference Select */
 #define AD7192_CONF_CHAN(x)	((x) << 8) /* Channel select */
 #define AD7192_CONF_CHAN_MASK	(0x7FF << 8) /* Channel select mask */
@@ -473,7 +473,7 @@ static ssize_t ad7192_show_ac_excitation
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ad7192_state *st = iio_priv(indio_dev);
 
-	return sysfs_emit(buf, "%d\n", !!(st->mode & AD7192_MODE_ACX));
+	return sysfs_emit(buf, "%d\n", !!(st->conf & AD7192_CONF_ACX));
 }
 
 static ssize_t ad7192_show_bridge_switch(struct device *dev,
@@ -514,13 +514,13 @@ static ssize_t ad7192_set(struct device
 
 		ad_sd_write_reg(&st->sd, AD7192_REG_GPOCON, 1, st->gpocon);
 		break;
-	case AD7192_REG_MODE:
+	case AD7192_REG_CONF:
 		if (val)
-			st->mode |= AD7192_MODE_ACX;
+			st->conf |= AD7192_CONF_ACX;
 		else
-			st->mode &= ~AD7192_MODE_ACX;
+			st->conf &= ~AD7192_CONF_ACX;
 
-		ad_sd_write_reg(&st->sd, AD7192_REG_MODE, 3, st->mode);
+		ad_sd_write_reg(&st->sd, AD7192_REG_CONF, 3, st->conf);
 		break;
 	default:
 		ret = -EINVAL;
@@ -580,12 +580,11 @@ static IIO_DEVICE_ATTR(bridge_switch_en,
 
 static IIO_DEVICE_ATTR(ac_excitation_en, 0644,
 		       ad7192_show_ac_excitation, ad7192_set,
-		       AD7192_REG_MODE);
+		       AD7192_REG_CONF);
 
 static struct attribute *ad7192_attributes[] = {
 	&iio_dev_attr_filter_low_pass_3db_frequency_available.dev_attr.attr,
 	&iio_dev_attr_bridge_switch_en.dev_attr.attr,
-	&iio_dev_attr_ac_excitation_en.dev_attr.attr,
 	NULL
 };
 
@@ -596,6 +595,7 @@ static const struct attribute_group ad71
 static struct attribute *ad7195_attributes[] = {
 	&iio_dev_attr_filter_low_pass_3db_frequency_available.dev_attr.attr,
 	&iio_dev_attr_bridge_switch_en.dev_attr.attr,
+	&iio_dev_attr_ac_excitation_en.dev_attr.attr,
 	NULL
 };
 


