Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A9526B0A5;
	Thu, 13 Feb 2025 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459831; cv=none; b=HEZrjb609MboaOzJSezTZy7uvPiJGoxmkU7HHgQer1cpD75aYRNKnS+2EVcqseKTBmnu08ZRfii/hEYUjgiGtR5QNPVZcnBsMfIIrSKPE7LcppvS0iQXYJXw148zSHmF3vBnIgukp/a+qvLyzFAJPcyhIZOsHsR1NQWGXUECxCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459831; c=relaxed/simple;
	bh=Ok8f85eZ7my79NANxCM461VWb9aCWp5RdBSMifZ9HV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TobnaxlnGtcNJ7eeeUc2njbKXXKYsLa9Tk17pgKoYOLvvm68aOy+CUFRr93eRDwT6hMNGeZW9VtUPuuinv/Ne2RjY71+/rZz9FfkWM55cukjdpLKN7vNDBQZzXrwIakhbEz5I2xjELYMlVv3lce6NcDXg6cenbu0R7iFFm0uj8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Awaxi9cl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Awaxi9cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239F6C4CED1;
	Thu, 13 Feb 2025 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459831;
	bh=Ok8f85eZ7my79NANxCM461VWb9aCWp5RdBSMifZ9HV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Awaxi9clSdj649YeIo5AsHTbPzx6NqVzjo2QAeii6jOGRMeOSrcn93HUAaBvEKwyi
	 lKZLewcezJOBzCp9FsiEFd3LUDhIxEaVUo+wMVbumznUcurFXPB1t5F/wUsBVTkQ1U
	 +NBXtCGI2sfOL96c5AJM/t1yJFre1JeDkbf6KqfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.13 345/443] iio: dac: ad3552r-common: fix ad3541/2r ranges
Date: Thu, 13 Feb 2025 15:28:30 +0100
Message-ID: <20250213142453.935414231@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

commit 1e758b613212b6964518a67939535910b5aee831 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3552r-common.c |    5 ++---
 drivers/iio/dac/ad3552r.h        |    8 +++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/iio/dac/ad3552r-common.c
+++ b/drivers/iio/dac/ad3552r-common.c
@@ -22,11 +22,10 @@ EXPORT_SYMBOL_NS_GPL(ad3552r_ch_ranges,
 
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
 EXPORT_SYMBOL_NS_GPL(ad3542r_ch_ranges, "IIO_AD3552R");
 
--- a/drivers/iio/dac/ad3552r.h
+++ b/drivers/iio/dac/ad3552r.h
@@ -131,7 +131,7 @@
 #define AD3552R_CH1_ACTIVE				BIT(1)
 
 #define AD3552R_MAX_RANGES	5
-#define AD3542R_MAX_RANGES	6
+#define AD3542R_MAX_RANGES	5
 #define AD3552R_QUAD_SPI	2
 
 extern const s32 ad3552r_ch_ranges[AD3552R_MAX_RANGES][2];
@@ -189,16 +189,14 @@ enum ad3552r_ch_vref_select {
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


