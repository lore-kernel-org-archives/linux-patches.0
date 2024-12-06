Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032AB13AA5F;
	Fri,  6 Dec 2024 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497363; cv=none; b=M6KtzSrg6FVeYPIUDyMGcszufXWW5217ACthravMUQdgUmanByAzRWKrjscMecWiT+qRVJ9fA1hNtcTAf3uVbcjaYS+ibuv59gS3BM/uIK5m7g4tqa+Tbf6eHGD7M0jImRwV6HWqTZoA+nahj142KNLy6OxdZIyuUn1jlwoLG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497363; c=relaxed/simple;
	bh=Ap2e3goMt1sydTDDNdO7lZNabMKW8ASW2nX5q8j+AeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KScqNSy7IUDokONJNcgJL3/hgzVN4NcSX00v66mCPjbMhlEFEiUqFukNUYqvbPrCX0Yo6Afb/jHgqmJgnk8JRiwu40e0InMIrvffYHNCeV33PelTjs2Hc+PjECM/Btt2/B3AQtMPlz5iTRMaji70mTtMkNy4WVcBo2Wag65qH7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiPtEgzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiPtEgzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DB5C4CED1;
	Fri,  6 Dec 2024 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497362;
	bh=Ap2e3goMt1sydTDDNdO7lZNabMKW8ASW2nX5q8j+AeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiPtEgzl8tX5CS/OiHIjPz4Lgkd+Qus6oHyGtED/6Me+FTfMiryZovlIdIEp2k4NH
	 GoxcacEFs2FCXFDUz0bOQfW3mDeUd4oWGxmSavBYYTTUygMLDl2xKsuF4+5HMO1Yxd
	 5YOkP8/lVDgPbcjlbbKdfmIKm3AT3V7hn2ZzGkNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/676] mfd: intel_soc_pmic_bxtwc: Use IRQ domain for PMIC devices
Date: Fri,  6 Dec 2024 15:31:28 +0100
Message-ID: <20241206143703.847116335@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5fc9d3aa61428..3aa7857271dad 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -231,21 +231,11 @@ static const struct resource tmu_resources[] = {
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
@@ -264,6 +254,22 @@ static const struct mfd_cell bxt_wc_tmu_dev[] = {
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
@@ -509,23 +515,23 @@ static int bxtwc_probe(struct platform_device *pdev)
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



