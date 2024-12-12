Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AEA20A5EE;
	Thu, 12 Dec 2024 17:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025202; cv=none; b=s9KG8ltd5aNtbeorcVivOksfUe6ArgG/Ix5FK8ofIc+QsFB5L6BkNMVm8l75Jqw8bTaDEwShacdru6IzvpVVT+SCvrxHOZZIgNW108YpQdz6AY36h5kZXSzmcR68B3lEpBn+snfKvb83p/OPtExO+3byHd98WEADo1F86meei+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025202; c=relaxed/simple;
	bh=cJtN8mtFM4ocfHDEWBF5agXKTjqSInINH4a/BgArXXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eel+XrDbrgAr8dygNCu/xkhVTQ7UNcmI/MmINYf3vaCwxOy5CphbQH/Z7+x6PZh3hgm3wOq/AKYlkRGf7VGaPUQDps0jGOGn6rVNIO5dUMOvy3HK6h9dQIlgCxEaDqXQj2JAa2/bctSssJoKp27eJ3G80NkWKOabcMN9G2E2kVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hwnxqq31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hwnxqq31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3CBC4CED3;
	Thu, 12 Dec 2024 17:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025202;
	bh=cJtN8mtFM4ocfHDEWBF5agXKTjqSInINH4a/BgArXXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hwnxqq312D48Rlox+HCAw1JjH+PE44ze+CxA81KGOOCmLBWDmBTQFaMabFF9khLua
	 JGciyxSFpZNZoE13jf+tn/tZ/IIqN7r9v4SdM00JImMw3NicYUNV77KQaalnDtzngX
	 h+Ic7/arCTglMLBYMZo/uL3Z8gu0NsDAGIOvlWpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/321] mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device
Date: Thu, 12 Dec 2024 16:00:09 +0100
Message-ID: <20241212144233.584257226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 686fb77712a4bc94b76a0c5ae74c60118b7a0d79 ]

While design wise the idea of converting the driver to use
the hierarchy of the IRQ chips is correct, the implementation
has (inherited) flaws. This was unveiled when platform_get_irq()
had started WARN() on IRQ 0 that is supposed to be a Linux
IRQ number (also known as vIRQ).

Rework the driver to respect IRQ domain when creating each MFD
device separately, as the domain is not the same for all of them.

Fixes: 9c6235c86332 ("mfd: intel_soc_pmic_bxtwc: Add bxt_wcove_usbc device")
Fixes: d2061f9cc32d ("usb: typec: add driver for Intel Whiskey Cove PMIC USB Type-C PHY")
Fixes: 57129044f504 ("mfd: intel_soc_pmic_bxtwc: Use chained IRQs for second level IRQ chips")
Reported-by: Zhang Ning <zhangn1985@outlook.com>
Closes: https://lore.kernel.org/r/TY2PR01MB3322FEDCDC048B7D3794F922CDBA2@TY2PR01MB3322.jpnprd01.prod.outlook.com
Tested-by: Zhang Ning <zhangn1985@outlook.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20241005193029.1929139-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_bxtwc.c | 57 +++++++++++++++++++++---------
 drivers/usb/typec/tcpm/wcove.c     |  4 ---
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/intel_soc_pmic_bxtwc.c b/drivers/mfd/intel_soc_pmic_bxtwc.c
index 072ed3226a83f..9b5edc1b47d89 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -236,16 +236,6 @@ static struct mfd_cell bxt_wc_dev[] = {
 		.num_resources = ARRAY_SIZE(thermal_resources),
 		.resources = thermal_resources,
 	},
-	{
-		.name = "bxt_wcove_usbc",
-		.num_resources = ARRAY_SIZE(usbc_resources),
-		.resources = usbc_resources,
-	},
-	{
-		.name = "bxt_wcove_ext_charger",
-		.num_resources = ARRAY_SIZE(charger_resources),
-		.resources = charger_resources,
-	},
 	{
 		.name = "bxt_wcove_bcu",
 		.num_resources = ARRAY_SIZE(bcu_resources),
@@ -267,6 +257,19 @@ static struct mfd_cell bxt_wc_dev[] = {
 	},
 };
 
+static struct mfd_cell bxt_wc_chgr_dev[] = {
+	{
+		.name = "bxt_wcove_usbc",
+		.num_resources = ARRAY_SIZE(usbc_resources),
+		.resources = usbc_resources,
+	},
+	{
+		.name = "bxt_wcove_ext_charger",
+		.num_resources = ARRAY_SIZE(charger_resources),
+		.resources = charger_resources,
+	},
+};
+
 static int regmap_ipc_byte_reg_read(void *context, unsigned int reg,
 				    unsigned int *val)
 {
@@ -422,6 +425,26 @@ static int bxtwc_add_chained_irq_chip(struct intel_soc_pmic *pmic,
 					0, chip, data);
 }
 
+static int bxtwc_add_chained_devices(struct intel_soc_pmic *pmic,
+				     const struct mfd_cell *cells, int n_devs,
+				     struct regmap_irq_chip_data *pdata,
+				     int pirq, int irq_flags,
+				     const struct regmap_irq_chip *chip,
+				     struct regmap_irq_chip_data **data)
+{
+	struct device *dev = pmic->dev;
+	struct irq_domain *domain;
+	int ret;
+
+	ret = bxtwc_add_chained_irq_chip(pmic, pdata, pirq, irq_flags, chip, data);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to add %s IRQ chip\n", chip->name);
+
+	domain = regmap_irq_get_domain(*data);
+
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, cells, n_devs, NULL, 0, domain);
+}
+
 static int bxtwc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -496,14 +519,14 @@ static int bxtwc_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to add ADC IRQ chip\n");
 
-	/* Add chained IRQ handler for CHGR IRQs */
-	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
-					 BXTWC_CHGR_LVL1_IRQ,
-					 IRQF_ONESHOT,
-					 &bxtwc_regmap_irq_chip_chgr,
-					 &pmic->irq_chip_data_chgr);
+	ret = bxtwc_add_chained_devices(pmic, bxt_wc_chgr_dev, ARRAY_SIZE(bxt_wc_chgr_dev),
+					pmic->irq_chip_data,
+					BXTWC_CHGR_LVL1_IRQ,
+					IRQF_ONESHOT,
+					&bxtwc_regmap_irq_chip_chgr,
+					&pmic->irq_chip_data_chgr);
 	if (ret)
-		return dev_err_probe(dev, ret, "Failed to add CHGR IRQ chip\n");
+		return ret;
 
 	/* Add chained IRQ handler for CRIT IRQs */
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
diff --git a/drivers/usb/typec/tcpm/wcove.c b/drivers/usb/typec/tcpm/wcove.c
index 7e9c279bf49df..22fe8d60fe368 100644
--- a/drivers/usb/typec/tcpm/wcove.c
+++ b/drivers/usb/typec/tcpm/wcove.c
@@ -620,10 +620,6 @@ static int wcove_typec_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	irq = regmap_irq_get_virq(pmic->irq_chip_data_chgr, irq);
-	if (irq < 0)
-		return irq;
-
 	ret = guid_parse(WCOVE_DSM_UUID, &wcove->guid);
 	if (ret)
 		return ret;
-- 
2.43.0



