Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF18226545;
	Thu, 12 Dec 2024 16:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022349; cv=none; b=ehVHr3n+XU9peTXtiokVi3FMaNVXTTPYWv3txqwIG+4V57+A8kVY31iYhD6kCnB3ba1U0vRtpgKOopxz76eq084xUZURU20VJ2H6nljbTqr/Fl3ZoH2Pj5gZPVOMYgIjO7h4z8uplDK8yZoh2ORq6ZeFeceTbjFgShvc5GFsP28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022349; c=relaxed/simple;
	bh=/7kOipKMMRcnVsj25rxbf5gSLaGfW9BtUc5I/h5iz+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhlZpILcAZnzb3m/d1MbX64vmG4Wb8tdw6xReb9aeUmEd/B7jBx1/NoUFnCXkGiR/S+PkzA7j4ynPWkni9ZiF02Gb4CYmKQRioa/Ecb775pG/uLped6NjCLuVX5w2gBFxtCWUinI74B7x2Qy2yxVKgCtgjoFe9zmL86GRJSX9tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByFHZT9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByFHZT9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AA2C4CECE;
	Thu, 12 Dec 2024 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022349;
	bh=/7kOipKMMRcnVsj25rxbf5gSLaGfW9BtUc5I/h5iz+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByFHZT9JdGhgiPW4K+TcM3OzckwZClvnWumSpA8pozUMjlxKqe4vjEwxqVGo8sOG1
	 FII2YlQX4d12eMlQK/XbbvoaOdvMINmzmQU3ATIqEiEH0FDsSYPVzosrE3Bk9YHQVY
	 dfLtYJ3wXTaNcbjkw/+X4ucZ2vYE26MVC44ULtDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/565] mfd: intel_soc_pmic_bxtwc: Use IRQ domain for USB Type-C device
Date: Thu, 12 Dec 2024 15:56:50 +0100
Message-ID: <20241212144319.993226444@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8e699844f23ba..d2c13ef4bf33f 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -240,16 +240,6 @@ static struct mfd_cell bxt_wc_dev[] = {
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
@@ -271,6 +261,19 @@ static struct mfd_cell bxt_wc_dev[] = {
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
@@ -418,6 +421,26 @@ static int bxtwc_add_chained_irq_chip(struct intel_soc_pmic *pmic,
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
index 20917d85d6f4c..5d34466a0abf2 100644
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



