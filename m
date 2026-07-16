Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6178D36A35E;
	Thu, 16 Jul 2026 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209059; cv=none; b=DfL8umVMTf4Ax/DL7KPtb3wNa0WxGcv/m7NBRHzIaZanrCGnUB6utbdvl4mvVGO5kTUIjaBSbRPcdHvcfWLZh24zqFujOrLFecpAiIhOZZkqXbTh8h31hjsIv5DX7RDq2SYPAniwjK5lZW/+tJ6w60N7/mgugQxZJ5ITWEB8NSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209059; c=relaxed/simple;
	bh=VuTWgv+CMlR15lTFoXAuwEtg+BnAHNFbnT2M3OWisjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kg1QsiIOnVopnQeeKR0rxgfcxFDgt4uu1PNJUQtf7112AIbLqItivFu26KFRQzpPubqE6UfoIMZHHOptc1m6bCAJrPXTYbpK5SjE1mDetTKyLxQM27ksD4lRJWdd9rnmkCVn0m8m3eTeQaClqp4wbjanLISxY3u60Ap7CQDC+0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ecj2c3Tn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ecj2c3Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0861F000E9;
	Thu, 16 Jul 2026 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209058;
	bh=t8qjsd/U1AIkq7nd+cFEUllxsjlZlCrOo/hiXBMmXvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ecj2c3TnZz/8ILx7mEv//9s8Y3Mr73sc/utFByZ+pUdTuok2m9xjnPBf7+AH1H19J
	 36jC0s6hxLABhOKPIaj+4Gm4E7sTOvnoBoL+ABHXgfbP8dJbXrfXCvqs8reguRTe2L
	 rlSKL9Rnou1WfX2Eg2ppHuxNnR1F4+40Y5BFly8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 042/518] iio: adc: nxp-sar-adc: Fix the delay calculation in nxp_sar_adc_wait_for()
Date: Thu, 16 Jul 2026 15:25:10 +0200
Message-ID: <20260716133048.701612382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit a9f41809bf1bd8e5c1bc4b6a1052adac58eb7ab6 upstream.

The original code was using ndelay() twice. In one case the delay
is calculated as 1/3 of ADC clock and in the other as 80 ADC clocks.
But according to the comments in all cases it should be a multiplier
of the ADC clock, and not a fraction of it. Inadvertently
nxp_sar_adc_wait_for() takes the wrong case and spread it over
the code make it wrong in all places. Fix this by modifying a helper
to correctly use the multiplier.

Fixes: 7e5c0f97c66a ("iio: adc: nxp-sar-adc: Avoid division by zero")
Fixes: 4434072a893e ("iio: adc: Add the NXP SAR ADC support for the s32g2/3 platforms")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260416090122.758990-1-andriy.shevchenko%40linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Stepan Ionichev <sozdayvek@gmail.com>
Acked-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/nxp-sar-adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/nxp-sar-adc.c
+++ b/drivers/iio/adc/nxp-sar-adc.c
@@ -198,13 +198,13 @@ static void nxp_sar_adc_irq_cfg(struct n
 		writel(0, NXP_SAR_ADC_IMR(info->regs));
 }
 
-static void nxp_sar_adc_wait_for(struct nxp_sar_adc *info, unsigned int cycles)
+static void nxp_sar_adc_wait_for(struct nxp_sar_adc *info, u64 cycles)
 {
 	u64 rate;
 
 	rate = clk_get_rate(info->clk);
 	if (rate)
-		ndelay(div64_u64(NSEC_PER_SEC, rate * cycles));
+		ndelay(div64_u64(NSEC_PER_SEC * cycles, rate));
 }
 
 static bool nxp_sar_adc_set_enabled(struct nxp_sar_adc *info, bool enable)


