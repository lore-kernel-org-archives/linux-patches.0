Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE2353A7;
	Fri,  6 Dec 2024 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497354; cv=none; b=TaEd9yTJsdRKCA68UQHBv4zxCT/FIbd3iiOGJVcJchuN3NuFCK8l/n25un2DBJAH0hUoNkQl+N0NM+bQ39DyE1wFdyHEgaFlBiYcjb6xxgIA4GIxtFJMnpvccLLP0macWLzAOdEBextrT1B5r6yRZYhToXdF5Qi+dZ5cFfe28GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497354; c=relaxed/simple;
	bh=NuIxTLIkNWKaAQPjQdDaX+45jCTwpxt5jYVyo86Hyw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puZPXakppHKYdFMuESI5ucHWEKW+iWm0FhYMMQbfTUQHtKKZlku9cJ2TntXYfEEKVXKTPWcTdpSObGWvpQ/jNcc1zuVOzGJ1f5PMhMaG6gno6Q3p+mrV4w6l36Yx2Rs6l6UpRGWgDfwn1hAnttAIPh9vGniH8VllTrzByrc8Jc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqKGRxIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqKGRxIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0157EC4CED1;
	Fri,  6 Dec 2024 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497354;
	bh=NuIxTLIkNWKaAQPjQdDaX+45jCTwpxt5jYVyo86Hyw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqKGRxIx+RTd9seVlQ/GkNomuE+bZtw1B8HgxYasHJctvW3eSOSFGYYH7vfIzSRfo
	 6eEg7dIw1bChh7T414YqOoAGdDOp5XolwdM8IQsDFgEPo+MfV+iMtYuqcba+3dRFq1
	 Sue8sUzkiKJknK+Hf3Uva0YIWzSsaWmbMzYgBQIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/676] mfd: intel_soc_pmic_bxtwc: Use IRQ domain for TMU device
Date: Fri,  6 Dec 2024 15:31:27 +0100
Message-ID: <20241206143703.808784252@linuxfoundation.org>
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
index 6ea98321bbf20..5fc9d3aa61428 100644
--- a/drivers/mfd/intel_soc_pmic_bxtwc.c
+++ b/drivers/mfd/intel_soc_pmic_bxtwc.c
@@ -246,12 +246,6 @@ static struct mfd_cell bxt_wc_dev[] = {
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
@@ -262,6 +256,14 @@ static struct mfd_cell bxt_wc_dev[] = {
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
@@ -490,6 +492,15 @@ static int bxtwc_probe(struct platform_device *pdev)
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
@@ -498,14 +509,6 @@ static int bxtwc_probe(struct platform_device *pdev)
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
index d0e2a3c293b0b..9ac801b929b93 100644
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



