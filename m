Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE5722145E;
	Thu, 12 Dec 2024 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022353; cv=none; b=SMJG7foyqMKC6kaidklnwjDVovlxQTjfbC6bga7mKglJy/Msj3VHf989+Svt/EZa3XP9rlu9Ma7te7yw4UE3dWufnNPJDE1eful57rLq1+j6ytzmKaBEZoKx4HMkH7tkSKzeb+XkeCi4029wQkFwcj1fTgYzx6c+JZn/oVJJUmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022353; c=relaxed/simple;
	bh=7d0BzE+aFSOukCsBV7zK+DwFEWMbHXQw6F2CjWEYt1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7A2HECS8kxjT3EvfgZlUJVVvKE0Rk7gR3jWoV1B7rmtrMh4fkyFCMjgqoLo442uUvBxkdQcWeWMqKs7HcV8DAyciOqQaJA/6REB4y50XGBa7hZiuxqsWoTonu0C5BzeQqpHqFSpYFKz1TomRQg1x1OHjcsjfhoO7nm14BXhFho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr2CSXeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr2CSXeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AFDC4CECE;
	Thu, 12 Dec 2024 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022352;
	bh=7d0BzE+aFSOukCsBV7zK+DwFEWMbHXQw6F2CjWEYt1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wr2CSXeZMR5uK+4E9XZ4f1uHP3u+gt6l9IjKEfmwUCnQBWID1/xG/XfLOdzvQSZn+
	 3Vnr3c9HfRPWXVDTz2Yp2vDanvcyAmcIzSCnww8xxQAg5+X1tXNhbmjhJGjWt3dzIg
	 +SAazsQ4Td4V85WAQj1GK8FstqLj89CAyxpNRkHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 216/565] mfd: intel_soc_pmic_bxtwc: Use IRQ domain for TMU device
Date: Thu, 12 Dec 2024 15:56:51 +0100
Message-ID: <20241212144320.032074558@linuxfoundation.org>
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

[ Upstream commit 9b79d59e6b2b515eb9a22bc469ef7b8f0904fc73 ]

While design wise the idea of converting the driver to use
the hierarchy of the IRQ chips is correct, the implementation
has (inherited) flaws. This was unveiled when platform_get_irq()
had started WARN() on IRQ 0 that is supposed to be a Linux
IRQ number (also known as vIRQ).

Rework the driver to respect IRQ domain when creating each MFD
device separately, as the domain is not the same for all of them.

Fixes: 957ae5098185 ("platform/x86: Add Whiskey Cove PMIC TMU support")
Fixes: 57129044f504 ("mfd: intel_soc_pmic_bxtwc: Use chained IRQs for second level IRQ chips")
Reported-by: Zhang Ning <zhangn1985@outlook.com>
Closes: https://lore.kernel.org/r/TY2PR01MB3322FEDCDC048B7D3794F922CDBA2@TY2PR01MB3322.jpnprd01.prod.outlook.com
Tested-by: Zhang Ning <zhangn1985@outlook.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241005193029.1929139-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_bxtwc.c     | 31 ++++++++++++++------------
 drivers/platform/x86/intel/bxtwc_tmu.c | 22 +++++-------------
 2 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/intel_soc_pmic_bxtwc.c b/drivers/mfd/intel_soc_pmic_bxtwc.c
index d2c13ef4bf33f..4c5a8ae7b6762 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -245,12 +245,6 @@ static struct mfd_cell bxt_wc_dev[] = {
 		.num_resources = ARRAY_SIZE(bcu_resources),
 		.resources = bcu_resources,
 	},
-	{
-		.name = "bxt_wcove_tmu",
-		.num_resources = ARRAY_SIZE(tmu_resources),
-		.resources = tmu_resources,
-	},
-
 	{
 		.name = "bxt_wcove_gpio",
 		.num_resources = ARRAY_SIZE(gpio_resources),
@@ -261,6 +255,14 @@ static struct mfd_cell bxt_wc_dev[] = {
 	},
 };
 
+static const struct mfd_cell bxt_wc_tmu_dev[] = {
+	{
+		.name = "bxt_wcove_tmu",
+		.num_resources = ARRAY_SIZE(tmu_resources),
+		.resources = tmu_resources,
+	},
+};
+
 static struct mfd_cell bxt_wc_chgr_dev[] = {
 	{
 		.name = "bxt_wcove_usbc",
@@ -485,6 +487,15 @@ static int bxtwc_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to add IRQ chip\n");
 
+	ret = bxtwc_add_chained_devices(pmic, bxt_wc_tmu_dev, ARRAY_SIZE(bxt_wc_tmu_dev),
+					pmic->irq_chip_data,
+					BXTWC_TMU_LVL1_IRQ,
+					IRQF_ONESHOT,
+					&bxtwc_regmap_irq_chip_tmu,
+					&pmic->irq_chip_data_tmu);
+	if (ret)
+		return ret;
+
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
 					 BXTWC_PWRBTN_LVL1_IRQ,
 					 IRQF_ONESHOT,
@@ -493,14 +504,6 @@ static int bxtwc_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to add PWRBTN IRQ chip\n");
 
-	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
-					 BXTWC_TMU_LVL1_IRQ,
-					 IRQF_ONESHOT,
-					 &bxtwc_regmap_irq_chip_tmu,
-					 &pmic->irq_chip_data_tmu);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to add TMU IRQ chip\n");
-
 	/* Add chained IRQ handler for BCU IRQs */
 	ret = bxtwc_add_chained_irq_chip(pmic, pmic->irq_chip_data,
 					 BXTWC_BCU_LVL1_IRQ,
diff --git a/drivers/platform/x86/intel/bxtwc_tmu.c b/drivers/platform/x86/intel/bxtwc_tmu.c
index 7ccf583649e6b..3c9778366d930 100644
--- a/drivers/platform/x86/intel/bxtwc_tmu.c
+++ b/drivers/platform/x86/intel/bxtwc_tmu.c
@@ -48,9 +48,8 @@ static irqreturn_t bxt_wcove_tmu_irq_handler(int irq, void *data)
 static int bxt_wcove_tmu_probe(struct platform_device *pdev)
 {
 	struct intel_soc_pmic *pmic = dev_get_drvdata(pdev->dev.parent);
-	struct regmap_irq_chip_data *regmap_irq_chip;
 	struct wcove_tmu *wctmu;
-	int ret, virq, irq;
+	int ret;
 
 	wctmu = devm_kzalloc(&pdev->dev, sizeof(*wctmu), GFP_KERNEL);
 	if (!wctmu)
@@ -59,27 +58,18 @@ static int bxt_wcove_tmu_probe(struct platform_device *pdev)
 	wctmu->dev = &pdev->dev;
 	wctmu->regmap = pmic->regmap;
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	wctmu->irq = platform_get_irq(pdev, 0);
+	if (wctmu->irq < 0)
+		return wctmu->irq;
 
-	regmap_irq_chip = pmic->irq_chip_data_tmu;
-	virq = regmap_irq_get_virq(regmap_irq_chip, irq);
-	if (virq < 0) {
-		dev_err(&pdev->dev,
-			"failed to get virtual interrupt=%d\n", irq);
-		return virq;
-	}
-
-	ret = devm_request_threaded_irq(&pdev->dev, virq,
+	ret = devm_request_threaded_irq(&pdev->dev, wctmu->irq,
 					NULL, bxt_wcove_tmu_irq_handler,
 					IRQF_ONESHOT, "bxt_wcove_tmu", wctmu);
 	if (ret) {
 		dev_err(&pdev->dev, "request irq failed: %d,virq: %d\n",
-							ret, virq);
+			ret, wctmu->irq);
 		return ret;
 	}
-	wctmu->irq = virq;
 
 	/* Unmask TMU second level Wake & System alarm */
 	regmap_update_bits(wctmu->regmap, BXTWC_MTMUIRQ_REG,
-- 
2.43.0



