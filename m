Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2AF1AB6C9;
	Tue,  3 Dec 2024 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241303; cv=none; b=Y/QpuktFqA34rAGJfqtQLvXFWiWWVZ+6cvpF1esaBXvVunzrDtI4f5Togr0tI1GL1mtGZmieG08l5khkM9BR5LuEYllle33dr8US5skFKFWBdx/seUG9ZF4Ksc1qEW8eXK1arx8zwftR33P7fZr1gXW07M6fPz+gZwKwPvMue6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241303; c=relaxed/simple;
	bh=/qc8Ye9K0eF6UK1GiAwa5Jd2W5/R6ew5DTx8mT66png=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPft7h8dm3/6HtFyW+OMA0RC0YthMpka46jVwrIKFLy9mLUyru4/t7IRdnc2pdDG2TwvDZjMvJnlv+HQwQbAmgkYfcsaY1cqh/m/n2QkajzzLg0TVKBs7+U54UM9JiMQ/o9A16pUZQARktKEeRywMAO/374Auwy7S7iNTEfmLdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voGPtClF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voGPtClF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE8DC4CECF;
	Tue,  3 Dec 2024 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241303;
	bh=/qc8Ye9K0eF6UK1GiAwa5Jd2W5/R6ew5DTx8mT66png=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=voGPtClFFxitZmtuKfkT14ZvYUBBFnLxMc6005X7IbvPQ7+2AvjCGDNyesnNhiVCz
	 gzwl/Rn2lb5RyB4mSQ292CyO8Ry6Zrizh0BwXVquUYddEA2XIVawGnkMm6byDNRKor
	 FharQu77K4JNPjhST8h85xVcPfcjZ12aRFN3jYdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 374/826] mfd: intel_soc_pmic_bxtwc: Use IRQ domain for PMIC devices
Date: Tue,  3 Dec 2024 15:41:41 +0100
Message-ID: <20241203144758.354536381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0350d783ab888cb1cb48ced36cc28b372723f1a4 ]

While design wise the idea of converting the driver to use
the hierarchy of the IRQ chips is correct, the implementation
has (inherited) flaws. This was unveiled when platform_get_irq()
had started WARN() on IRQ 0 that is supposed to be a Linux
IRQ number (also known as vIRQ).

Rework the driver to respect IRQ domain when creating each MFD
device separately, as the domain is not the same for all of them.

Fixes: 57129044f504 ("mfd: intel_soc_pmic_bxtwc: Use chained IRQs for second level IRQ chips")
Tested-by: Zhang Ning <zhangn1985@outlook.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241005193029.1929139-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_bxtwc.c | 54 +++++++++++++++++-------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/intel_soc_pmic_bxtwc.c b/drivers/mfd/intel_soc_pmic_bxtwc.c
index 628108dcf5454..fefbeb4164fde 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -230,21 +230,11 @@ static const struct resource tmu_resources[] = {
 };
 
 static struct mfd_cell bxt_wc_dev[] = {
-	{
-		.name = "bxt_wcove_gpadc",
-		.num_resources = ARRAY_SIZE(adc_resources),
-		.resources = adc_resources,
-	},
 	{
 		.name = "bxt_wcove_thermal",
 		.num_resources = ARRAY_SIZE(thermal_resources),
 		.resources = thermal_resources,
 	},
-	{
-		.name = "bxt_wcove_bcu",
-		.num_resources = ARRAY_SIZE(bcu_resources),
-		.resources = bcu_resources,
-	},
 	{
 		.name = "bxt_wcove_gpio",
 		.num_resources = ARRAY_SIZE(gpio_resources),
@@ -263,6 +253,22 @@ static const struct mfd_cell bxt_wc_tmu_dev[] = {
 	},
 };
 
+static const struct mfd_cell bxt_wc_bcu_dev[] = {
+	{
+		.name = "bxt_wcove_bcu",
+		.num_resources = ARRAY_SIZE(bcu_resources),
+		.resources = bcu_resources,
+	},
+};
+
+static const struct mfd_cell bxt_wc_adc_dev[] = {
+	{
+		.name = "bxt_wcove_gpadc",
+		.num_resources = ARRAY_SIZE(adc_resources),
+		.resources = adc_resources,
+	},
+};
+
 static struct mfd_cell bxt_wc_chgr_dev[] = {
 	{
 		.name = "bxt_wcove_usbc",
@@ -508,23 +514,23 @@ static int bxtwc_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to add PWRBTN IRQ chip\n");
 
-	/* Add chained IRQ handler for BCU IRQs */
-	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
-					 BXTWC_BCU_LVL1_IRQ,
-					 IRQF_ONESHOT,
-					 &bxtwc_regmap_irq_chip_bcu,
-					 &pmic->irq_chip_data_bcu);
+	ret = bxtwc_add_chained_devices(pmic, bxt_wc_bcu_dev, ARRAY_SIZE(bxt_wc_bcu_dev),
+					pmic->irq_chip_data,
+					BXTWC_BCU_LVL1_IRQ,
+					IRQF_ONESHOT,
+					&bxtwc_regmap_irq_chip_bcu,
+					&pmic->irq_chip_data_bcu);
 	if (ret)
-		return dev_err_probe(dev, ret, "Failed to add BUC IRQ chip\n");
+		return ret;
 
-	/* Add chained IRQ handler for ADC IRQs */
-	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
-					 BXTWC_ADC_LVL1_IRQ,
-					 IRQF_ONESHOT,
-					 &bxtwc_regmap_irq_chip_adc,
-					 &pmic->irq_chip_data_adc);
+	ret = bxtwc_add_chained_devices(pmic, bxt_wc_adc_dev, ARRAY_SIZE(bxt_wc_adc_dev),
+					pmic->irq_chip_data,
+					BXTWC_ADC_LVL1_IRQ,
+					IRQF_ONESHOT,
+					&bxtwc_regmap_irq_chip_adc,
+					&pmic->irq_chip_data_adc);
 	if (ret)
-		return dev_err_probe(dev, ret, "Failed to add ADC IRQ chip\n");
+		return ret;
 
 	ret = bxtwc_add_chained_devices(pmic, bxt_wc_chgr_dev, ARRAY_SIZE(bxt_wc_chgr_dev),
 					pmic->irq_chip_data,
-- 
2.43.0



