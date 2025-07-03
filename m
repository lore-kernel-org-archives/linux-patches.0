Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535332E7BBE;
	Thu,  3 Jul 2025 14:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554554; cv=none; b=oQNI1Z44MQbYIhCiqDFDDJSI1Sulzb0Gd9yDWnualZci5ildueib80066PFZENA6aAUXhJ2l1U3ydbV0noeGuXFP1zIsnVQnSS0XXlbwskpHxTqizITouptXkFkeFCPsGxqGmg8VulY+4butqfY5knY1tMgaKoR6048mAwIkLpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554554; c=relaxed/simple;
	bh=Z0IYY42aEhVQWAGKDidrLfnTo0y/P9hBeSizFwrZsxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfgvqqMBF7KXDscfMLxWEDFvbcy0birVpzlNRYlXnivVRYJCt185fjB7hobb6Pk9Um/lJSvbbHUgE6/ypE7NaSnrnGdFSTYNYp/UavN5pApp+2AV9Z6/zRXo+N/SOgwjBi9fekJvTliWgUqxBMf/Y6DbrQZ2Sdv7Bn9kAAdORAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBfxiBzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBfxiBzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BC3C4CEE3;
	Thu,  3 Jul 2025 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554554;
	bh=Z0IYY42aEhVQWAGKDidrLfnTo0y/P9hBeSizFwrZsxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBfxiBzSS3bDcTTjTYXQQXmSCiivMB8NqwDrzRpEkykXlzPpiW3XGtnUGU5CChhMX
	 xmCosR9DsSeKRelgKrj1giZCioxa6GJyA8MZuu+B4ckfoML7IeMJBMiGJiu3I27Z1G
	 VlJEc9OsohVs4yTiubalQuisTTTLNyvU9bFrjWO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/218] iio: dac: ad3552r-common: fix ad3541/2r ranges
Date: Thu,  3 Jul 2025 16:42:25 +0200
Message-ID: <20250703144004.089995663@linuxfoundation.org>
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

[ Upstream commit 1e758b613212b6964518a67939535910b5aee831 ]

Fix ad3541/2r voltage ranges to be as per ad3542r datasheet,
rev. C, table 38 (page 57).

The wrong ad354xr ranges was generating erroneous Vpp output.

In more details:
- fix wrong number of ranges, they are 5 ranges, not 6,
- remove non-existent 0-3V range,
- adjust order, since ad3552r_find_range() get a wrong index,
  producing a wrong Vpp as output.

Retested all the ranges on real hardware, EVALAD3542RFMCZ:

adi,output-range-microvolt (fdt):
<(000000) (2500000)>;   ok (Rfbx1, switch 10)
<(000000) (5000000)>;   ok (Rfbx1, switch 10)
<(000000) (10000000)>;  ok (Rfbx1, switch 10)
<(-5000000) (5000000)>; ok (Rfbx2, switch +/- 5)
<(-2500000) (7500000)>; ok (Rfbx2, switch -2.5/7.5)

Fixes: 8f2b54824b28 ("drivers:iio:dac: Add AD3552R driver support")
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250108-wip-bl-ad3552r-axi-v0-iio-testing-carlos-v2-1-2dac02f04638@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad3552r-common.c | 5 ++---
 drivers/iio/dac/ad3552r.h        | 9 ++++-----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/dac/ad3552r-common.c b/drivers/iio/dac/ad3552r-common.c
index 2dfeca3656d21..94869ad15c27e 100644
--- a/drivers/iio/dac/ad3552r-common.c
+++ b/drivers/iio/dac/ad3552r-common.c
@@ -22,11 +22,10 @@ EXPORT_SYMBOL_NS_GPL(ad3552r_ch_ranges, IIO_AD3552R);
 
 const s32 ad3542r_ch_ranges[AD3542R_MAX_RANGES][2] = {
 	[AD3542R_CH_OUTPUT_RANGE_0__2P5V]	= { 0, 2500 },
-	[AD3542R_CH_OUTPUT_RANGE_0__3V]		= { 0, 3000 },
 	[AD3542R_CH_OUTPUT_RANGE_0__5V]		= { 0, 5000 },
 	[AD3542R_CH_OUTPUT_RANGE_0__10V]	= { 0, 10000 },
-	[AD3542R_CH_OUTPUT_RANGE_NEG_2P5__7P5V]	= { -2500, 7500 },
-	[AD3542R_CH_OUTPUT_RANGE_NEG_5__5V]	= { -5000, 5000 }
+	[AD3542R_CH_OUTPUT_RANGE_NEG_5__5V]	= { -5000, 5000 },
+	[AD3542R_CH_OUTPUT_RANGE_NEG_2P5__7P5V]	= { -2500, 7500 }
 };
 EXPORT_SYMBOL_NS_GPL(ad3542r_ch_ranges, IIO_AD3552R);
 
diff --git a/drivers/iio/dac/ad3552r.h b/drivers/iio/dac/ad3552r.h
index 7511e3f1882cb..c20f64f80d5db 100644
--- a/drivers/iio/dac/ad3552r.h
+++ b/drivers/iio/dac/ad3552r.h
@@ -128,7 +128,8 @@
 #define AD3552R_LDAC_PULSE_US				100
 
 #define AD3552R_MAX_RANGES	5
-#define AD3542R_MAX_RANGES	6
+#define AD3542R_MAX_RANGES	5
+#define AD3552R_QUAD_SPI	2
 
 extern const s32 ad3552r_ch_ranges[AD3552R_MAX_RANGES][2];
 extern const s32 ad3542r_ch_ranges[AD3542R_MAX_RANGES][2];
@@ -185,16 +186,14 @@ enum ad3552r_ch_vref_select {
 enum ad3542r_ch_output_range {
 	/* Range from 0 V to 2.5 V. Requires Rfb1x connection */
 	AD3542R_CH_OUTPUT_RANGE_0__2P5V,
-	/* Range from 0 V to 3 V. Requires Rfb1x connection  */
-	AD3542R_CH_OUTPUT_RANGE_0__3V,
 	/* Range from 0 V to 5 V. Requires Rfb1x connection  */
 	AD3542R_CH_OUTPUT_RANGE_0__5V,
 	/* Range from 0 V to 10 V. Requires Rfb2x connection  */
 	AD3542R_CH_OUTPUT_RANGE_0__10V,
-	/* Range from -2.5 V to 7.5 V. Requires Rfb2x connection  */
-	AD3542R_CH_OUTPUT_RANGE_NEG_2P5__7P5V,
 	/* Range from -5 V to 5 V. Requires Rfb2x connection  */
 	AD3542R_CH_OUTPUT_RANGE_NEG_5__5V,
+	/* Range from -2.5 V to 7.5 V. Requires Rfb2x connection  */
+	AD3542R_CH_OUTPUT_RANGE_NEG_2P5__7P5V,
 };
 
 enum ad3552r_ch_output_range {
-- 
2.39.5



