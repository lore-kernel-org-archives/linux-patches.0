Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385C62C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC35C4339B;
	Tue,  7 Feb 2023 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775634;
	bh=iUrqqy/r2mKWdnOJficXoLwV2cpR7Umu9Z0q8nrtkyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1GT8n1uYL7PrT/c+hb0yu7Ngsx7LkNbzuAg/xWPNVFTWLhuIjGGEaozr4t3ubyhP
	 AOguNVAspOvZx06MT5hXUi4l+cCAUc6XBTVElZxfjCpxpPXisOzDL6vkGooP31LFts
	 iENMyjRegt4etPGywdSH1C8iWpW9sEf+6n92uFGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 076/120] iio:adc:twl6030: Enable measurements of VUSB, VBAT and others
Date: Tue,  7 Feb 2023 13:57:27 +0100
Message-Id: <20230207125621.979521960@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Kemnade <andreas@kemnade.info>

commit f804bd0dc28683a93a60f271aaefb2fc5b0853dd upstream.

Some inputs need to be wired up to produce proper measurements,
without this change only near zero values are reported.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Fixes: 1696f36482e70 ("iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver")
Link: https://lore.kernel.org/r/20221201181635.3522962-1-andreas@kemnade.info
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/twl6030-gpadc.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -57,6 +57,18 @@
 #define TWL6030_GPADCS				BIT(1)
 #define TWL6030_GPADCR				BIT(0)
 
+#define USB_VBUS_CTRL_SET			0x04
+#define USB_ID_CTRL_SET				0x06
+
+#define TWL6030_MISC1				0xE4
+#define VBUS_MEAS				0x01
+#define ID_MEAS					0x01
+
+#define VAC_MEAS                0x04
+#define VBAT_MEAS               0x02
+#define BB_MEAS                 0x01
+
+
 /**
  * struct twl6030_chnl_calib - channel calibration
  * @gain:		slope coefficient for ideal curve
@@ -927,6 +939,26 @@ static int twl6030_gpadc_probe(struct pl
 		return ret;
 	}
 
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, VBUS_MEAS, USB_VBUS_CTRL_SET);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, ID_MEAS, USB_ID_CTRL_SET);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID0,
+				VBAT_MEAS | BB_MEAS | BB_MEAS,
+				TWL6030_MISC1);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
 	indio_dev->name = DRIVER_NAME;
 	indio_dev->info = &twl6030_gpadc_iio_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;


