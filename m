Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C5131062C;
	Mon, 13 Oct 2025 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368041; cv=none; b=qlisdKfP5RAVtNmrHkb/YvqS6l7fG5wlczXCN/ELh9wgDL+EhURl8ruwXjwDDcJ50WMhr2JHaUzv8S5CndOhkfBTWAtITy9ZaHTACGLx3r21vrZ6UQx7KCx7oaWVipxiby1CjBBF3ENE11tpG+1tK9EinU1LiIvPw4yg4i1UaP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368041; c=relaxed/simple;
	bh=2+BgIlFwcYxTFJAKxjZ35M9ugDhbgu8q4mW067En/rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNLcfAkX6LIC7bFLZot/aZFnz0VwCrDwEJy+Pq0N7MpdjNPmaneoEGL8WLgo5lK5MLYGndy0qCE/ba2lt+S4sxJxvNeVk5xl9SVXy+PLB5o2mCV3vap2UPPK56ELAY9dSSrvy9VVALP2JOKBjNBLCwPWWOpkq7cydJ9lYFq78Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWGjzqSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWGjzqSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006A4C4CEE7;
	Mon, 13 Oct 2025 15:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368041;
	bh=2+BgIlFwcYxTFJAKxjZ35M9ugDhbgu8q4mW067En/rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWGjzqSRA30TGm0HzUyqD7AeOyV2PerRycSGilkqs8bcVACRxyTNUEI+f7y/fUWFA
	 wpM18FLcyXyI2WqlS07YzXAzCqeiQQs+szGInI1kHGnrMAmq1+xlA1ZHH9izwA3ztX
	 eA1R1xwPpgT1QaWyL6HnT/SPgdcEkfcWHK8h8bqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/262] leds: flash: leds-qcom-flash: Update torch current clamp setting
Date: Mon, 13 Oct 2025 16:42:45 +0200
Message-ID: <20251013144326.966190986@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 07a83bb2dfdf6..bb00097b1ae59 100644
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
 
@@ -918,8 +929,7 @@ static int qcom_flash_led_probe(struct platform_device *pdev)
 		flash_data->leds_count++;
 	}
 
-	return 0;
-
+	return regmap_field_write(flash_data->r_fields[REG_TORCH_CLAMP], flash_data->torch_clamp);
 release:
 	fwnode_handle_put(child);
 	while (flash_data->v4l2_flash[flash_data->leds_count] && flash_data->leds_count)
-- 
2.51.0



