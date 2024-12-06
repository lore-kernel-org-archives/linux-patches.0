Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2275353A7;
	Fri,  6 Dec 2024 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497351; cv=none; b=O3R4EAHmg8G81suRs1Fk238A/bxARiw3HZ/yvOc4fbVTcMsOLdit386rNwlrVWHdexoZP1dSEv8Bko9ThhvY3FRdVPz39HLyp0caovDSBz+e5ZU+RMIV44c+gmo4hoD6OXDib6RUyVnBqZpjkOv/n4VHA8k7BMOzrVsaU1yfXtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497351; c=relaxed/simple;
	bh=yqgNNKYZfudK8QUVyHE49+WuS6i4gSkWJkBiP2VJW/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p07QyeQRyUscXfsEbL9YSRGDdbjG5o+7reSoDfyRlSSy8Zd39haj8FjXj1DFJkL82jaZAEljqi3UytJMs3I+aIGvCAgzhDN3PI74uO5T7L9mmkCqE2eFU7TU75HcJXEjiVuNeAScq+gaRcdl/bsGGfuG5BCsYYbqq+6Y8FVMRZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boz3g5QQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boz3g5QQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9050BC4CED1;
	Fri,  6 Dec 2024 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497351;
	bh=yqgNNKYZfudK8QUVyHE49+WuS6i4gSkWJkBiP2VJW/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boz3g5QQG0f34/ZOzt8jfDTMvhUE8r0PBgE56IzrAEIQAruVcL5gweVukSA2vpUoU
	 bWuIOiQuMl50fFFCsaIk37x2VB6mdeDynNqIfuGORqtBHcV7Qkd6xZzFZ0gNnvVQuf
	 maPw64HTHYlZdoMnDX+aaoNrhaAXDVKdHELs0lHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 267/676] mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device
Date: Fri,  6 Dec 2024 15:31:26 +0100
Message-ID: <20241206143703.764225416@linuxfoundation.org>
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
index 8dac0d41f64f3..6ea98321bbf20 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -241,16 +241,6 @@ static struct mfd_cell bxt_wc_dev[] = {
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
@@ -272,6 +262,19 @@ static struct mfd_cell bxt_wc_dev[] = {
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
@@ -426,6 +429,26 @@ static int bxtwc_add_chained_irq_chip(struct intel_soc_pmic *pmic,
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
@@ -501,14 +524,14 @@ static int bxtwc_probe(struct platform_device *pdev)
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
index 87d4abde0ea27..e08244f555f03 100644
--- a/drivers/usb/typec/tcpm/wcove.c
+++ b/drivers/usb/typec/tcpm/wcove.c
@@ -621,10 +621,6 @@ static int wcove_typec_probe(struct platform_device *pdev)
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



