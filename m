Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D25C293C44;
	Tue, 26 Aug 2025 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207012; cv=none; b=LkQyaBb3/czXejZkoR3xA1MMXeOSZARfb+0EEQ/MY+39RWpn/htMiJ7tHsQxWKyN5ycUe7GgY5adCpcCotuiEqAB+Y38K4haqb9/nWEZ9yt9Z75RRBPmzcr/bny88aRbQSrHRdDMda2A9wzD1aCvplSebGi7/SLsz7vkwms/Upg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207012; c=relaxed/simple;
	bh=Pa+WcXJzJEEuBD5jkGYKFaGeGBwqq+l3pWSQbFrHn6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S9kLgWmxz2OC+2+3JXScV0JyNRDsjUk3+7/PusmdmTbBSuNLpXNgH++rmjcuHl/8oO8x1fWigpPHEwwKPN9AkcBGnLQMsjZs05mLhfgC7qjfL9PnuLUC3R6bJkZZypxJ0u+xUGNMXWr8FSkrGMvMSRL2tnpGBql5CC6LzguCUcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONFY2wNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONFY2wNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1949C4CEF1;
	Tue, 26 Aug 2025 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207012;
	bh=Pa+WcXJzJEEuBD5jkGYKFaGeGBwqq+l3pWSQbFrHn6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONFY2wNuflkunIw+unuac5fLajs5b7eTzOR7d1E+9QczIVCtH53HnizUq4R2bLO38
	 Far42XzaQPtE0PYTh+oJhGWhHUnK9JMisqXv/hExbUApakpvgCifLK5+90RPvDjinK
	 PiK1L/Y6Vjz3QVy3c3LuSWdPCc1bfEs6yNV6+MUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 009/457] iio: adc: ad7173: fix num_slots
Date: Tue, 26 Aug 2025 13:04:53 +0200
Message-ID: <20250826110937.541103421@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 92c247216918fcaa64244248ee38a0f1d342278c upstream.

Fix the num_slots value for most chips in the ad7173 driver. The correct
value is the number of CHANNELx registers on the chip.

In commit 4310e15b3140 ("iio: adc: ad7173: don't make copy of
ad_sigma_delta_info struct"), we refactored struct ad_sigma_delta_info
to be static const data instead of being dynamically populated during
driver probe. However, there was an existing bug in commit 76a1e6a42802
("iio: adc: ad7173: add AD7173 driver") where num_slots was incorrectly
set to the number of CONFIGx registers instead of the number of
CHANNELx registers. This bug was partially propagated to the refactored
code in that the 16-channel chips were only given 8 slots instead of
16 although we did managed to fix the 8-channel chips and one of the
4-channel chips in that commit. However, we botched two of the 4-channel
chips and ended up incorrectly giving them 8 slots during the
refactoring.

This patch fixes that mistake on the 4-channel chips and also
corrects the 16-channel chips to have 16 slots.

Fixes: 4310e15b3140 ("iio: adc: ad7173: don't make copy of ad_sigma_delta_info struct")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250706-iio-adc-ad7173-fix-num_slots-on-most-chips-v3-1-d1f5453198a7@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -772,10 +772,26 @@ static const struct ad_sigma_delta_info
 	.num_slots = 8,
 };
 
+static const struct ad_sigma_delta_info ad7173_sigma_delta_info_16_slots = {
+	.set_channel = ad7173_set_channel,
+	.append_status = ad7173_append_status,
+	.disable_all = ad7173_disable_all,
+	.disable_one = ad7173_disable_one,
+	.set_mode = ad7173_set_mode,
+	.has_registers = true,
+	.has_named_irqs = true,
+	.addr_shift = 0,
+	.read_mask = BIT(6),
+	.status_ch_mask = GENMASK(3, 0),
+	.data_reg = AD7173_REG_DATA,
+	.num_resetclks = 64,
+	.num_slots = 16,
+};
+
 static const struct ad7173_device_info ad4111_device_info = {
 	.name = "ad4111",
 	.id = AD4111_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_16_slots,
 	.num_voltage_in_div = 8,
 	.num_channels = 16,
 	.num_configs = 8,
@@ -797,7 +813,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad4112_device_info = {
 	.name = "ad4112",
 	.id = AD4112_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_16_slots,
 	.num_voltage_in_div = 8,
 	.num_channels = 16,
 	.num_configs = 8,
@@ -818,7 +834,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad4113_device_info = {
 	.name = "ad4113",
 	.id = AD4113_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_16_slots,
 	.num_voltage_in_div = 8,
 	.num_channels = 16,
 	.num_configs = 8,
@@ -837,7 +853,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad4114_device_info = {
 	.name = "ad4114",
 	.id = AD4114_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_16_slots,
 	.num_voltage_in_div = 16,
 	.num_channels = 16,
 	.num_configs = 8,
@@ -856,7 +872,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad4115_device_info = {
 	.name = "ad4115",
 	.id = AD4115_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_16_slots,
 	.num_voltage_in_div = 16,
 	.num_channels = 16,
 	.num_configs = 8,
@@ -875,7 +891,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad4116_device_info = {
 	.name = "ad4116",
 	.id = AD4116_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_16_slots,
 	.num_voltage_in_div = 11,
 	.num_channels = 16,
 	.num_configs = 8,
@@ -894,7 +910,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad7172_2_device_info = {
 	.name = "ad7172-2",
 	.id = AD7172_2_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_4_slots,
 	.num_voltage_in = 5,
 	.num_channels = 4,
 	.num_configs = 4,
@@ -927,7 +943,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad7173_8_device_info = {
 	.name = "ad7173-8",
 	.id = AD7173_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_16_slots,
 	.num_voltage_in = 17,
 	.num_channels = 16,
 	.num_configs = 8,
@@ -944,7 +960,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad7175_2_device_info = {
 	.name = "ad7175-2",
 	.id = AD7175_2_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_4_slots,
 	.num_voltage_in = 5,
 	.num_channels = 4,
 	.num_configs = 4,
@@ -961,7 +977,7 @@ static const struct ad7173_device_info a
 static const struct ad7173_device_info ad7175_8_device_info = {
 	.name = "ad7175-8",
 	.id = AD7175_8_ID,
-	.sd_info = &ad7173_sigma_delta_info_8_slots,
+	.sd_info = &ad7173_sigma_delta_info_16_slots,
 	.num_voltage_in = 17,
 	.num_channels = 16,
 	.num_configs = 8,


