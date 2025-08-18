Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F7C2C235C;
	Mon, 18 Aug 2025 13:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524644; cv=none; b=cYSJZoNmm3JC24ypRm0XlAOSb068MA2a5LW7IXNitnPlZdHbcZEdfqZNS1UFHk2uoOzQ8WsdrvdPE1WfRiVZYQGvUiyRRnk7du4dNuSIkp4T0eymBzjI/L5+CdGuWiwoV1f8ZrR/JVhNsjID5kEKf2cAiNSJdtEhU4EVEbsKNdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524644; c=relaxed/simple;
	bh=JDbW1xYnynbXiHlabYc0lJqHwJTe+41JyXUyK6lAMVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtR2dI5D+ZZLvjqeC3nhaqdemqgxdkNm8bbSxpajjsy5SR51SIVzNSBHy5923rhoG97nTNAqpiBBXRTGCXfiqtyBYxPQqlSHUBsbbri/PsLdWuOwR+JlUxAzgkhfECcSCVAkyqcpGiN7t4OQOOMTtZLmRucWmSMXdk5286EVs50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEgENcTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEgENcTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D190C113D0;
	Mon, 18 Aug 2025 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524643;
	bh=JDbW1xYnynbXiHlabYc0lJqHwJTe+41JyXUyK6lAMVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEgENcTbGtE3J/xms8uTml9jguQFIT6BkkEeF6jk+hepL/vUekD4MI7/vH3D4Y/0j
	 WG/K/3ywIDRLBCQre1TBYci5lH6zMaIZbH5uwVmNt/zZQZ/YrpxVBOb+OiM6R775wl
	 tbUUP9/aIagfCauGdN2aNjQ7TrBcw1jEhNO4gOL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.16 019/570] leds: flash: leds-qcom-flash: Fix registry access after re-bind
Date: Mon, 18 Aug 2025 14:40:06 +0200
Message-ID: <20250818124506.539606224@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit fab15f57360b1e6620a1d0d6b0fbee896e6c1f07 upstream.

Driver in probe() updates each of 'reg_field' with 'reg_base':

	for (i = 0; i < REG_MAX_COUNT; i++)
		regs[i].reg += reg_base;

'reg_field' array (under variable 'regs' above) is statically allocated,
thus each re-bind would add another 'reg_base' leading to bogus
register addresses.  Constify the local 'reg_field' array and duplicate
it in probe to solve this.

Fixes: 96a2e242a5dc ("leds: flash: Add driver to support flash LED module in QCOM PMICs")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Fenglin Wu <fenglin.wu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250529063335.8785-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/flash/leds-qcom-flash.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/leds/flash/leds-qcom-flash.c
+++ b/drivers/leds/flash/leds-qcom-flash.c
@@ -117,7 +117,7 @@ enum {
 	REG_MAX_COUNT,
 };
 
-static struct reg_field mvflash_3ch_regs[REG_MAX_COUNT] = {
+static const struct reg_field mvflash_3ch_regs[REG_MAX_COUNT] = {
 	REG_FIELD(0x08, 0, 7),			/* status1	*/
 	REG_FIELD(0x09, 0, 7),                  /* status2	*/
 	REG_FIELD(0x0a, 0, 7),                  /* status3	*/
@@ -132,7 +132,7 @@ static struct reg_field mvflash_3ch_regs
 	REG_FIELD(0x58, 0, 2),			/* therm_thrsh3 */
 };
 
-static struct reg_field mvflash_4ch_regs[REG_MAX_COUNT] = {
+static const struct reg_field mvflash_4ch_regs[REG_MAX_COUNT] = {
 	REG_FIELD(0x06, 0, 7),			/* status1	*/
 	REG_FIELD(0x07, 0, 6),			/* status2	*/
 	REG_FIELD(0x09, 0, 7),			/* status3	*/
@@ -854,11 +854,17 @@ static int qcom_flash_led_probe(struct p
 	if (val == FLASH_SUBTYPE_3CH_PM8150_VAL || val == FLASH_SUBTYPE_3CH_PMI8998_VAL) {
 		flash_data->hw_type = QCOM_MVFLASH_3CH;
 		flash_data->max_channels = 3;
-		regs = mvflash_3ch_regs;
+		regs = devm_kmemdup(dev, mvflash_3ch_regs, sizeof(mvflash_3ch_regs),
+				    GFP_KERNEL);
+		if (!regs)
+			return -ENOMEM;
 	} else if (val == FLASH_SUBTYPE_4CH_VAL) {
 		flash_data->hw_type = QCOM_MVFLASH_4CH;
 		flash_data->max_channels = 4;
-		regs = mvflash_4ch_regs;
+		regs = devm_kmemdup(dev, mvflash_4ch_regs, sizeof(mvflash_4ch_regs),
+				    GFP_KERNEL);
+		if (!regs)
+			return -ENOMEM;
 
 		rc = regmap_read(regmap, reg_base + FLASH_REVISION_REG, &val);
 		if (rc < 0) {
@@ -880,6 +886,7 @@ static int qcom_flash_led_probe(struct p
 		dev_err(dev, "Failed to allocate regmap field, rc=%d\n", rc);
 		return rc;
 	}
+	devm_kfree(dev, regs); /* devm_regmap_field_bulk_alloc() makes copies */
 
 	platform_set_drvdata(pdev, flash_data);
 	mutex_init(&flash_data->lock);


