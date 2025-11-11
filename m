Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1755D330B1F;
	Tue, 11 Nov 2025 01:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823369; cv=none; b=VXTT84xCRk0n/G1kJ6zXC2tDBQ/7fzpjB3UO+XEX8Z9RRWEvxS4wSvo+deiNCeIb04jOeHvpbgw2V0XYRjZhzHT92JZDCFkQvbKgwKMyT3XGTZXUng6NGTVtHlfA3PQop01mwKSwhJK4xSBs93l2WtPJSjNPPxO+jP6p9KuetCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823369; c=relaxed/simple;
	bh=2onommx/dYMWH4XzVD3e45+W71VgGPGha1HLiKu0wlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUsZ1URiSkyJqe+hUDeC8OkMoNr8W2rDvSXRe8W9gbmL0H8k1Qrju4NJJW+4U3+UWCG85WxOHn5oydZFJHbOZl1W+x6xFxLxewNDIMIr1wq9i/HjkDSVkm2VJmfBCa+8B9YvmMZsyTbDDIFQ7xWJmDwB+wuSdwGb3J1187vwxbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnrBTbDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnrBTbDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A887EC113D0;
	Tue, 11 Nov 2025 01:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823368;
	bh=2onommx/dYMWH4XzVD3e45+W71VgGPGha1HLiKu0wlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnrBTbDnzQWTpNcPNhjU8GdRqyZSolXRCiJBJ2+i3hDYm6pl4sFynUWd+Qn+BSYBg
	 zdNkG75HzfzldlwX8ZMd+jcHA6fNH/GRBzM2+o87AqXUmxPfkKi1XJTKQvRcu3gDbu
	 o8utE5OyVOEWty94mF5c4xSQ1zd0HeDa4G0nogcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Primoz Fiser <primoz.fiser@norik.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/565] iio: adc: imx93_adc: load calibrated values even calibration failed
Date: Tue, 11 Nov 2025 09:41:24 +0900
Message-ID: <20251111004532.047490308@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 12c9b09e981ab14ebec8e4eefa946cbd26dd306b ]

ADC calibration might fail because of the noise on reference voltage.
To avoid calibration fail, need to meet the following requirement:
    ADC reference voltage Noise < 1.8V * 1/2^ENOB

For the case which the ADC reference voltage on board do not meet
the requirement, still load the calibrated values, so ADC can also
work but maybe not that accurate.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Primoz Fiser <primoz.fiser@norik.com>
Link: https://patch.msgid.link/20250812-adc-v2-2-0260833f13b8@nxp.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/imx93_adc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/imx93_adc.c b/drivers/iio/adc/imx93_adc.c
index 4ccf4819f1f13..75cf2f93d5edd 100644
--- a/drivers/iio/adc/imx93_adc.c
+++ b/drivers/iio/adc/imx93_adc.c
@@ -38,6 +38,7 @@
 #define IMX93_ADC_PCDR6		0x118
 #define IMX93_ADC_PCDR7		0x11c
 #define IMX93_ADC_CALSTAT	0x39C
+#define IMX93_ADC_CALCFG0	0x3A0
 
 /* ADC bit shift */
 #define IMX93_ADC_MCR_MODE_MASK			BIT(29)
@@ -58,6 +59,8 @@
 #define IMX93_ADC_IMR_ECH_MASK			BIT(0)
 #define IMX93_ADC_PCDR_CDATA_MASK		GENMASK(11, 0)
 
+#define IMX93_ADC_CALCFG0_LDFAIL_MASK		BIT(4)
+
 /* ADC status */
 #define IMX93_ADC_MSR_ADCSTATUS_IDLE			0
 #define IMX93_ADC_MSR_ADCSTATUS_POWER_DOWN		1
@@ -145,7 +148,7 @@ static void imx93_adc_config_ad_clk(struct imx93_adc *adc)
 
 static int imx93_adc_calibration(struct imx93_adc *adc)
 {
-	u32 mcr, msr;
+	u32 mcr, msr, calcfg;
 	int ret;
 
 	/* make sure ADC in power down mode */
@@ -158,6 +161,11 @@ static int imx93_adc_calibration(struct imx93_adc *adc)
 
 	imx93_adc_power_up(adc);
 
+	/* Enable loading of calibrated values even in fail condition */
+	calcfg = readl(adc->regs + IMX93_ADC_CALCFG0);
+	calcfg |= IMX93_ADC_CALCFG0_LDFAIL_MASK;
+	writel(calcfg, adc->regs + IMX93_ADC_CALCFG0);
+
 	/*
 	 * TODO: we use the default TSAMP/NRSMPL/AVGEN in MCR,
 	 * can add the setting of these bit if need in future.
@@ -180,9 +188,13 @@ static int imx93_adc_calibration(struct imx93_adc *adc)
 	/* check whether calbration is success or not */
 	msr = readl(adc->regs + IMX93_ADC_MSR);
 	if (msr & IMX93_ADC_MSR_CALFAIL_MASK) {
+		/*
+		 * Only give warning here, this means the noise of the
+		 * reference voltage do not meet the requirement:
+		 *     ADC reference voltage Noise < 1.8V * 1/2^ENOB
+		 * And the resault of ADC is not that accurate.
+		 */
 		dev_warn(adc->dev, "ADC calibration failed!\n");
-		imx93_adc_power_down(adc);
-		return -EAGAIN;
 	}
 
 	return 0;
-- 
2.51.0



