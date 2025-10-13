Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD19F30C373;
	Mon, 13 Oct 2025 15:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368907; cv=none; b=W5VnUJC/unkt7rRWfV0NikOH/7OJ69rcXRPOj5OIV66lAcgNFDFxt9aWSy+dfbbmj2pwB1ikhL3D1ipYLVKVWeLZTdnxvU/qepNuHf3PF+qP9hakYwpfelKTWnj0mC0h0LAgykcqV3jhwWjonb+nOEj5NBPTt3zjoxPDxTLTOII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368907; c=relaxed/simple;
	bh=6Cs1Hq6QHP5yql1kRWFg5af8qB0vqt51cl4sTBDVP0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ans0/7xKjk3Io1Khb4+xuC5N3Y3mori7I/9mA7fvwLITXwOcD9ylBrNMABWzDN5VfO3xhYnlvqqa+zLB1D9LyA0uj3rSsZZUIskFGHbWNdLdf6sj24zDF5nUYZvERukNy02YUYSHr2GGqBggsQDzaMpmkOQX7eTNW3IRQDu7GUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3Y2fnMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3Y2fnMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5AFC4CEE7;
	Mon, 13 Oct 2025 15:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368907;
	bh=6Cs1Hq6QHP5yql1kRWFg5af8qB0vqt51cl4sTBDVP0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3Y2fnMhvF953RBBtyZTtqxoP06oF8AQ+XxLnRKNjuj7A724UgTSm1oQgRtJ5QCuP
	 lcmna8mJzAioyj+6ltjPJzbwZDmsOC0K8LkG9en/kXR9uZNDdnyiVxz/3CkNEs5oMz
	 kKHz11Uf/ayrvQWREybLVjaM+fRHbgGrS9Qu+474=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 053/563] leds: flash: leds-qcom-flash: Update torch current clamp setting
Date: Mon, 13 Oct 2025 16:38:34 +0200
Message-ID: <20251013144413.213084487@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenglin Wu <fenglin.wu@oss.qualcomm.com>

[ Upstream commit 5974e8f6c3e47ab097c3dd8ece7324d1f88fe739 ]

There is a register to clamp the flash current per LED channel when
safety timer is disabled. It needs to be updated according to the
maximum torch LED current setting to ensure the torch current won't
be clamped unexpectedly.

Fixes: 96a2e242a5dc ("leds: flash: Add driver to support flash LED module in QCOM PMICs")
Signed-off-by: Fenglin Wu <fenglin.wu@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250729-fix-torch-clamp-issue-v2-1-9b83816437a3@oss.qualcomm.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-qcom-flash.c | 62 ++++++++++++++++------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/leds/flash/leds-qcom-flash.c b/drivers/leds/flash/leds-qcom-flash.c
index 89cf5120f5d55..db7c2c743adc7 100644
--- a/drivers/leds/flash/leds-qcom-flash.c
+++ b/drivers/leds/flash/leds-qcom-flash.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2022, 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022, 2024-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/bitfield.h>
@@ -114,36 +114,39 @@ enum {
 	REG_THERM_THRSH1,
 	REG_THERM_THRSH2,
 	REG_THERM_THRSH3,
+	REG_TORCH_CLAMP,
 	REG_MAX_COUNT,
 };
 
 static const struct reg_field mvflash_3ch_regs[REG_MAX_COUNT] = {
-	REG_FIELD(0x08, 0, 7),			/* status1	*/
-	REG_FIELD(0x09, 0, 7),                  /* status2	*/
-	REG_FIELD(0x0a, 0, 7),                  /* status3	*/
-	REG_FIELD_ID(0x40, 0, 7, 3, 1),         /* chan_timer	*/
-	REG_FIELD_ID(0x43, 0, 6, 3, 1),         /* itarget	*/
-	REG_FIELD(0x46, 7, 7),                  /* module_en	*/
-	REG_FIELD(0x47, 0, 5),                  /* iresolution	*/
-	REG_FIELD_ID(0x49, 0, 2, 3, 1),         /* chan_strobe	*/
-	REG_FIELD(0x4c, 0, 2),                  /* chan_en	*/
-	REG_FIELD(0x56, 0, 2),			/* therm_thrsh1 */
-	REG_FIELD(0x57, 0, 2),			/* therm_thrsh2 */
-	REG_FIELD(0x58, 0, 2),			/* therm_thrsh3 */
+	[REG_STATUS1]		= REG_FIELD(0x08, 0, 7),
+	[REG_STATUS2]		= REG_FIELD(0x09, 0, 7),
+	[REG_STATUS3]		= REG_FIELD(0x0a, 0, 7),
+	[REG_CHAN_TIMER]	= REG_FIELD_ID(0x40, 0, 7, 3, 1),
+	[REG_ITARGET]		= REG_FIELD_ID(0x43, 0, 6, 3, 1),
+	[REG_MODULE_EN]		= REG_FIELD(0x46, 7, 7),
+	[REG_IRESOLUTION]	= REG_FIELD(0x47, 0, 5),
+	[REG_CHAN_STROBE]	= REG_FIELD_ID(0x49, 0, 2, 3, 1),
+	[REG_CHAN_EN]		= REG_FIELD(0x4c, 0, 2),
+	[REG_THERM_THRSH1]	= REG_FIELD(0x56, 0, 2),
+	[REG_THERM_THRSH2]	= REG_FIELD(0x57, 0, 2),
+	[REG_THERM_THRSH3]	= REG_FIELD(0x58, 0, 2),
+	[REG_TORCH_CLAMP]	= REG_FIELD(0xec, 0, 6),
 };
 
 static const struct reg_field mvflash_4ch_regs[REG_MAX_COUNT] = {
-	REG_FIELD(0x06, 0, 7),			/* status1	*/
-	REG_FIELD(0x07, 0, 6),			/* status2	*/
-	REG_FIELD(0x09, 0, 7),			/* status3	*/
-	REG_FIELD_ID(0x3e, 0, 7, 4, 1),		/* chan_timer	*/
-	REG_FIELD_ID(0x42, 0, 6, 4, 1),		/* itarget	*/
-	REG_FIELD(0x46, 7, 7),			/* module_en	*/
-	REG_FIELD(0x49, 0, 3),			/* iresolution	*/
-	REG_FIELD_ID(0x4a, 0, 6, 4, 1),		/* chan_strobe	*/
-	REG_FIELD(0x4e, 0, 3),			/* chan_en	*/
-	REG_FIELD(0x7a, 0, 2),			/* therm_thrsh1 */
-	REG_FIELD(0x78, 0, 2),			/* therm_thrsh2 */
+	[REG_STATUS1]		= REG_FIELD(0x06, 0, 7),
+	[REG_STATUS2]		= REG_FIELD(0x07, 0, 6),
+	[REG_STATUS3]		= REG_FIELD(0x09, 0, 7),
+	[REG_CHAN_TIMER]	= REG_FIELD_ID(0x3e, 0, 7, 4, 1),
+	[REG_ITARGET]		= REG_FIELD_ID(0x42, 0, 6, 4, 1),
+	[REG_MODULE_EN]		= REG_FIELD(0x46, 7, 7),
+	[REG_IRESOLUTION]	= REG_FIELD(0x49, 0, 3),
+	[REG_CHAN_STROBE]	= REG_FIELD_ID(0x4a, 0, 6, 4, 1),
+	[REG_CHAN_EN]		= REG_FIELD(0x4e, 0, 3),
+	[REG_THERM_THRSH1]	= REG_FIELD(0x7a, 0, 2),
+	[REG_THERM_THRSH2]	= REG_FIELD(0x78, 0, 2),
+	[REG_TORCH_CLAMP]	= REG_FIELD(0xed, 0, 6),
 };
 
 struct qcom_flash_data {
@@ -156,6 +159,7 @@ struct qcom_flash_data {
 	u8			max_channels;
 	u8			chan_en_bits;
 	u8			revision;
+	u8			torch_clamp;
 };
 
 struct qcom_flash_led {
@@ -702,6 +706,7 @@ static int qcom_flash_register_led_device(struct device *dev,
 	u32 current_ua, timeout_us;
 	u32 channels[4];
 	int i, rc, count;
+	u8 torch_clamp;
 
 	count = fwnode_property_count_u32(node, "led-sources");
 	if (count <= 0) {
@@ -751,6 +756,12 @@ static int qcom_flash_register_led_device(struct device *dev,
 	current_ua = min_t(u32, current_ua, TORCH_CURRENT_MAX_UA * led->chan_count);
 	led->max_torch_current_ma = current_ua / UA_PER_MA;
 
+	torch_clamp = (current_ua / led->chan_count) / TORCH_IRES_UA;
+	if (torch_clamp != 0)
+		torch_clamp--;
+
+	flash_data->torch_clamp = max_t(u8, flash_data->torch_clamp, torch_clamp);
+
 	if (fwnode_property_present(node, "flash-max-microamp")) {
 		flash->led_cdev.flags |= LED_DEV_CAP_FLASH;
 
@@ -917,8 +928,7 @@ static int qcom_flash_led_probe(struct platform_device *pdev)
 		flash_data->leds_count++;
 	}
 
-	return 0;
-
+	return regmap_field_write(flash_data->r_fields[REG_TORCH_CLAMP], flash_data->torch_clamp);
 release:
 	while (flash_data->v4l2_flash[flash_data->leds_count] && flash_data->leds_count)
 		v4l2_flash_release(flash_data->v4l2_flash[flash_data->leds_count--]);
-- 
2.51.0



