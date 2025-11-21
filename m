Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C82F33438C;
	Fri, 21 Nov 2025 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732524; cv=none; b=J8S86ZhvKFqv0djDSowK3+N/hW58w+PODQpD385ywLblBqZLOYGBXCMXpY5CsN2kayfnvbBY7ZNUuNKUWiOYEa6eUAWblz1f+yKhp3gCdHoRQGG1EouBED6vAus62r5vQN6n2HK2dhB3XDABFZKKc7Ov3p2M2pXp135/hQTybS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732524; c=relaxed/simple;
	bh=KzGhdosTjwwetdLss8WEtbMH3/6iMctpHTjRhVNVano=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDCcg2BWhiLgk/pNenMtGi1/JhkjiVCTwvJ29YawV1/mHrAzAJsVsSvQvgVw8CYREoV1TJgw2Ze6ig2f0Dce7a0tgIWYdfPEb3vbFOvl0SuNv1ag5K8vJ2PhiadEidGo+o2SzRvuQsIZm6g6GYB53MWgdmBAXdLZzS0oFFoB910=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHpp4wJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHpp4wJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A29C4CEF1;
	Fri, 21 Nov 2025 13:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732524;
	bh=KzGhdosTjwwetdLss8WEtbMH3/6iMctpHTjRhVNVano=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHpp4wJc1cJmqur3vhzWZ4ZRdh8L8tyGebSTGOqnKRY+76iwiOyL6lvaH+wngjZ9/
	 IRE0jEbPJZWA9sT3fztk/FZoI09FxVWn83dz9D/iacaQ3kqXJKbN3pXXqI4WRFwpX/
	 KIvCh/sXqEurg9qKGEw+Kr0NhaRrsARBewEX6TOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Primoz Fiser <primoz.fiser@norik.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/529] iio: adc: imx93_adc: load calibrated values even calibration failed
Date: Fri, 21 Nov 2025 14:07:30 +0100
Message-ID: <20251121130236.392077459@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 512d7b95b08e6..2303ae19c602e 100644
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



