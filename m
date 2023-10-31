Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2A6208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2Sj1R3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ECCC433C7;
	Tue, 31 Oct 2023 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774559;
	bh=1h/2hWAY6vPwRJDuQ3rGetPR3KpTi8dGvzsz/k/wf1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2Sj1R3pPU2lSmTf0EEXNnEZQF9pKgwigoNH9D7D+Bpk/np+YTUyKLkRSiRKhKB6m
	 VZKUPol8deRWH0+XBVQrY2Q+Z0yjKNj0hJELnPhlh4KLlzcfMmkg64jOXqSgyRniY3
	 D7lJAylP7aSeKMh1m/gTy00A/EAgjYIwrmUH8ES4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"OGriofa, Conall" <conall.ogriofa@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	O'Griofa
Subject: [PATCH 6.5 087/112] iio: adc: xilinx-xadc: Correct temperature offset/scale for UltraScale
Date: Tue, 31 Oct 2023 18:01:28 +0100
Message-ID: <20231031165904.059245010@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

commit e2bd8c28b9bd835077eb65715d416d667694a80d upstream.

The driver was previously using offset and scale values for the
temperature sensor readings which were only valid for 7-series devices.
Add per-device-type values for offset and scale and set them appropriately
for each device type.

Note that the values used for the UltraScale family are for UltraScale+
(i.e. the SYSMONE4 primitive) using the internal reference, as that seems
to be the most common configuration and the device tree values Xilinx's
device tree generator produces don't seem to give us anything to tell us
which configuration is used. However, the differences within the UltraScale
family seem fairly minor and it's closer than using the 7-series values
instead in any case.

Fixes: c2b7720a7905 ("iio: xilinx-xadc: Add basic support for Ultrascale System Monitor")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Acked-by: O'Griofa, Conall <conall.ogriofa@amd.com>
Tested-by: O'Griofa, Conall <conall.ogriofa@amd.com>
Link: https://lore.kernel.org/r/20230915001019.2862964-3-robert.hancock@calian.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-xadc-core.c |   17 ++++++++++++++---
 drivers/iio/adc/xilinx-xadc.h      |    2 ++
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -456,6 +456,9 @@ static const struct xadc_ops xadc_zynq_o
 	.interrupt_handler = xadc_zynq_interrupt_handler,
 	.update_alarm = xadc_zynq_update_alarm,
 	.type = XADC_TYPE_S7,
+	/* Temp in C = (val * 503.975) / 2**bits - 273.15 */
+	.temp_scale = 503975,
+	.temp_offset = 273150,
 };
 
 static const unsigned int xadc_axi_reg_offsets[] = {
@@ -566,6 +569,9 @@ static const struct xadc_ops xadc_7s_axi
 	.interrupt_handler = xadc_axi_interrupt_handler,
 	.flags = XADC_FLAGS_BUFFERED | XADC_FLAGS_IRQ_OPTIONAL,
 	.type = XADC_TYPE_S7,
+	/* Temp in C = (val * 503.975) / 2**bits - 273.15 */
+	.temp_scale = 503975,
+	.temp_offset = 273150,
 };
 
 static const struct xadc_ops xadc_us_axi_ops = {
@@ -577,6 +583,12 @@ static const struct xadc_ops xadc_us_axi
 	.interrupt_handler = xadc_axi_interrupt_handler,
 	.flags = XADC_FLAGS_BUFFERED | XADC_FLAGS_IRQ_OPTIONAL,
 	.type = XADC_TYPE_US,
+	/**
+	 * Values below are for UltraScale+ (SYSMONE4) using internal reference.
+	 * See https://docs.xilinx.com/v/u/en-US/ug580-ultrascale-sysmon
+	 */
+	.temp_scale = 509314,
+	.temp_offset = 280231,
 };
 
 static int _xadc_update_adc_reg(struct xadc *xadc, unsigned int reg,
@@ -945,8 +957,7 @@ static int xadc_read_raw(struct iio_dev
 			*val2 = bits;
 			return IIO_VAL_FRACTIONAL_LOG2;
 		case IIO_TEMP:
-			/* Temp in C = (val * 503.975) / 2**bits - 273.15 */
-			*val = 503975;
+			*val = xadc->ops->temp_scale;
 			*val2 = bits;
 			return IIO_VAL_FRACTIONAL_LOG2;
 		default:
@@ -954,7 +965,7 @@ static int xadc_read_raw(struct iio_dev
 		}
 	case IIO_CHAN_INFO_OFFSET:
 		/* Only the temperature channel has an offset */
-		*val = -((273150 << bits) / 503975);
+		*val = -((xadc->ops->temp_offset << bits) / xadc->ops->temp_scale);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SAMP_FREQ:
 		ret = xadc_read_samplerate(xadc);
--- a/drivers/iio/adc/xilinx-xadc.h
+++ b/drivers/iio/adc/xilinx-xadc.h
@@ -85,6 +85,8 @@ struct xadc_ops {
 
 	unsigned int flags;
 	enum xadc_type type;
+	int temp_scale;
+	int temp_offset;
 };
 
 static inline int _xadc_read_adc_reg(struct xadc *xadc, unsigned int reg,


