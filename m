Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE202367A0;
	Tue, 17 Jun 2025 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177891; cv=none; b=TYnwNzXDyn6Tg7JvjnqY5ShM9RJErOu+mNZlxUuOjrsQjedfCL70Z9NNht6DGqykxwgpCqAlQ9sW8DqN/SjU3IlJ5nJoRMrHiX24ZH5SwRUrIN4+z5D0S1f4XLlpT3lWUA8UZMcxNAM/ew+8nDtCDNUC33UFRxLYgPH3uIyVwG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177891; c=relaxed/simple;
	bh=bAcoTVt5VHZkCOR3pAP/T7KPd2+wtn/LIri2U0RzVYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfKk7rLB743FDAWo515+sZyLZEMtXh+ojeOteYd3aJfPrrxM997B6IvGEX2+1aHck/pMvuT9td7Wiespt9bIVIXhncq41284KqDTWYu/4Hj+YED6j7/GSdLfUpMyWrWWueSgSbigrbgNNyKs8ZW0f+1Ts5JP7rx7phoSMEzU+nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g02SMDsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g02SMDsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C881C4CEE3;
	Tue, 17 Jun 2025 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177890;
	bh=bAcoTVt5VHZkCOR3pAP/T7KPd2+wtn/LIri2U0RzVYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g02SMDsawT7ZFlVd1gj2z8CBGLQHp8NwmjahvryezRMUZrBW75TDkMngX2d5Felg4
	 5RAO4YOCxFJR5ED93U3kOMThs0bmujMRwB72KGoi7nMiMQNd6Y8FJZg74vkHVlFM5x
	 4QWztvm/MSyJFSTHtjPjc6mRMcRNGa3sjCaAdLdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 411/512] pinctrl: samsung: refactor drvdata suspend & resume callbacks
Date: Tue, 17 Jun 2025 17:26:17 +0200
Message-ID: <20250617152436.229447380@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit 3ade961e97f3b05dcdd9a4fabfe179c9e75571e0 ]

This enables the clk_enable() and clk_disable() logic to be removed
from each callback, but otherwise should have no functional impact.

It is a prepatory patch so that the callbacks can become SoC
specific.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250402-pinctrl-fltcon-suspend-v6-1-78ce0d4eb30c@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: bdbe0a0f7100 ("pinctrl: samsung: add gs101 specific eint suspend/resume callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c  | 89 ++++++-----------------
 drivers/pinctrl/samsung/pinctrl-exynos.h  |  4 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c | 21 ++++--
 drivers/pinctrl/samsung/pinctrl-samsung.h |  8 +-
 4 files changed, 42 insertions(+), 80 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index ac6dc22b37c98..62c8d8d907545 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -761,19 +761,11 @@ __init int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 	return 0;
 }
 
-static void exynos_pinctrl_suspend_bank(
-				struct samsung_pinctrl_drv_data *drvdata,
-				struct samsung_pin_bank *bank)
+static void exynos_pinctrl_suspend_bank(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
 	const void __iomem *regs = bank->eint_base;
 
-	if (clk_enable(bank->drvdata->pclk)) {
-		dev_err(bank->gpio_chip.parent,
-			"unable to enable clock for saving state\n");
-		return;
-	}
-
 	save->eint_con = readl(regs + EXYNOS_GPIO_ECON_OFFSET
 						+ bank->eint_offset);
 	save->eint_fltcon0 = readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
@@ -783,71 +775,46 @@ static void exynos_pinctrl_suspend_bank(
 	save->eint_mask = readl(regs + bank->irq_chip->eint_mask
 						+ bank->eint_offset);
 
-	clk_disable(bank->drvdata->pclk);
-
 	pr_debug("%s: save     con %#010x\n", bank->name, save->eint_con);
 	pr_debug("%s: save fltcon0 %#010x\n", bank->name, save->eint_fltcon0);
 	pr_debug("%s: save fltcon1 %#010x\n", bank->name, save->eint_fltcon1);
 	pr_debug("%s: save    mask %#010x\n", bank->name, save->eint_mask);
 }
 
-static void exynosauto_pinctrl_suspend_bank(struct samsung_pinctrl_drv_data *drvdata,
-					    struct samsung_pin_bank *bank)
+static void exynosauto_pinctrl_suspend_bank(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
 	const void __iomem *regs = bank->eint_base;
 
-	if (clk_enable(bank->drvdata->pclk)) {
-		dev_err(bank->gpio_chip.parent,
-			"unable to enable clock for saving state\n");
-		return;
-	}
-
 	save->eint_con = readl(regs + bank->pctl_offset + bank->eint_con_offset);
 	save->eint_mask = readl(regs + bank->pctl_offset + bank->eint_mask_offset);
 
-	clk_disable(bank->drvdata->pclk);
-
 	pr_debug("%s: save     con %#010x\n", bank->name, save->eint_con);
 	pr_debug("%s: save    mask %#010x\n", bank->name, save->eint_mask);
 }
 
-void exynos_pinctrl_suspend(struct samsung_pinctrl_drv_data *drvdata)
+void exynos_pinctrl_suspend(struct samsung_pin_bank *bank)
 {
-	struct samsung_pin_bank *bank = drvdata->pin_banks;
 	struct exynos_irq_chip *irq_chip = NULL;
-	int i;
 
-	for (i = 0; i < drvdata->nr_banks; ++i, ++bank) {
-		if (bank->eint_type == EINT_TYPE_GPIO) {
-			if (bank->eint_con_offset)
-				exynosauto_pinctrl_suspend_bank(drvdata, bank);
-			else
-				exynos_pinctrl_suspend_bank(drvdata, bank);
-		}
-		else if (bank->eint_type == EINT_TYPE_WKUP) {
-			if (!irq_chip) {
-				irq_chip = bank->irq_chip;
-				irq_chip->set_eint_wakeup_mask(drvdata,
-							       irq_chip);
-			}
+	if (bank->eint_type == EINT_TYPE_GPIO) {
+		if (bank->eint_con_offset)
+			exynosauto_pinctrl_suspend_bank(bank);
+		else
+			exynos_pinctrl_suspend_bank(bank);
+	} else if (bank->eint_type == EINT_TYPE_WKUP) {
+		if (!irq_chip) {
+			irq_chip = bank->irq_chip;
+			irq_chip->set_eint_wakeup_mask(bank->drvdata, irq_chip);
 		}
 	}
 }
 
-static void exynos_pinctrl_resume_bank(
-				struct samsung_pinctrl_drv_data *drvdata,
-				struct samsung_pin_bank *bank)
+static void exynos_pinctrl_resume_bank(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
 	void __iomem *regs = bank->eint_base;
 
-	if (clk_enable(bank->drvdata->pclk)) {
-		dev_err(bank->gpio_chip.parent,
-			"unable to enable clock for restoring state\n");
-		return;
-	}
-
 	pr_debug("%s:     con %#010x => %#010x\n", bank->name,
 			readl(regs + EXYNOS_GPIO_ECON_OFFSET
 			+ bank->eint_offset), save->eint_con);
@@ -869,22 +836,13 @@ static void exynos_pinctrl_resume_bank(
 						+ 2 * bank->eint_offset + 4);
 	writel(save->eint_mask, regs + bank->irq_chip->eint_mask
 						+ bank->eint_offset);
-
-	clk_disable(bank->drvdata->pclk);
 }
 
-static void exynosauto_pinctrl_resume_bank(struct samsung_pinctrl_drv_data *drvdata,
-					   struct samsung_pin_bank *bank)
+static void exynosauto_pinctrl_resume_bank(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
 	void __iomem *regs = bank->eint_base;
 
-	if (clk_enable(bank->drvdata->pclk)) {
-		dev_err(bank->gpio_chip.parent,
-			"unable to enable clock for restoring state\n");
-		return;
-	}
-
 	pr_debug("%s:     con %#010x => %#010x\n", bank->name,
 		 readl(regs + bank->pctl_offset + bank->eint_con_offset), save->eint_con);
 	pr_debug("%s:    mask %#010x => %#010x\n", bank->name,
@@ -893,21 +851,16 @@ static void exynosauto_pinctrl_resume_bank(struct samsung_pinctrl_drv_data *drvd
 	writel(save->eint_con, regs + bank->pctl_offset + bank->eint_con_offset);
 	writel(save->eint_mask, regs + bank->pctl_offset + bank->eint_mask_offset);
 
-	clk_disable(bank->drvdata->pclk);
 }
 
-void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
+void exynos_pinctrl_resume(struct samsung_pin_bank *bank)
 {
-	struct samsung_pin_bank *bank = drvdata->pin_banks;
-	int i;
-
-	for (i = 0; i < drvdata->nr_banks; ++i, ++bank)
-		if (bank->eint_type == EINT_TYPE_GPIO) {
-			if (bank->eint_con_offset)
-				exynosauto_pinctrl_resume_bank(drvdata, bank);
-			else
-				exynos_pinctrl_resume_bank(drvdata, bank);
-		}
+	if (bank->eint_type == EINT_TYPE_GPIO) {
+		if (bank->eint_con_offset)
+			exynosauto_pinctrl_resume_bank(bank);
+		else
+			exynos_pinctrl_resume_bank(bank);
+	}
 }
 
 static void exynos_retention_enable(struct samsung_pinctrl_drv_data *drvdata)
diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.h b/drivers/pinctrl/samsung/pinctrl-exynos.h
index 97a43fa4dfc56..ce39ab52102e7 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.h
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.h
@@ -211,8 +211,8 @@ struct exynos_muxed_weint_data {
 
 int exynos_eint_gpio_init(struct samsung_pinctrl_drv_data *d);
 int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d);
-void exynos_pinctrl_suspend(struct samsung_pinctrl_drv_data *drvdata);
-void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata);
+void exynos_pinctrl_suspend(struct samsung_pin_bank *bank);
+void exynos_pinctrl_resume(struct samsung_pin_bank *bank);
 struct samsung_retention_ctrl *
 exynos_retention_init(struct samsung_pinctrl_drv_data *drvdata,
 		      const struct samsung_retention_data *data);
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index 63ac89a802d30..210534586c0c0 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -1333,6 +1333,7 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 static int __maybe_unused samsung_pinctrl_suspend(struct device *dev)
 {
 	struct samsung_pinctrl_drv_data *drvdata = dev_get_drvdata(dev);
+	struct samsung_pin_bank *bank;
 	int i;
 
 	i = clk_enable(drvdata->pclk);
@@ -1343,7 +1344,7 @@ static int __maybe_unused samsung_pinctrl_suspend(struct device *dev)
 	}
 
 	for (i = 0; i < drvdata->nr_banks; i++) {
-		struct samsung_pin_bank *bank = &drvdata->pin_banks[i];
+		bank = &drvdata->pin_banks[i];
 		const void __iomem *reg = bank->pctl_base + bank->pctl_offset;
 		const u8 *offs = bank->type->reg_offset;
 		const u8 *widths = bank->type->fld_width;
@@ -1371,10 +1372,14 @@ static int __maybe_unused samsung_pinctrl_suspend(struct device *dev)
 		}
 	}
 
+	for (i = 0; i < drvdata->nr_banks; i++) {
+		bank = &drvdata->pin_banks[i];
+		if (drvdata->suspend)
+			drvdata->suspend(bank);
+	}
+
 	clk_disable(drvdata->pclk);
 
-	if (drvdata->suspend)
-		drvdata->suspend(drvdata);
 	if (drvdata->retention_ctrl && drvdata->retention_ctrl->enable)
 		drvdata->retention_ctrl->enable(drvdata);
 
@@ -1392,6 +1397,7 @@ static int __maybe_unused samsung_pinctrl_suspend(struct device *dev)
 static int __maybe_unused samsung_pinctrl_resume(struct device *dev)
 {
 	struct samsung_pinctrl_drv_data *drvdata = dev_get_drvdata(dev);
+	struct samsung_pin_bank *bank;
 	int ret;
 	int i;
 
@@ -1406,11 +1412,14 @@ static int __maybe_unused samsung_pinctrl_resume(struct device *dev)
 		return ret;
 	}
 
-	if (drvdata->resume)
-		drvdata->resume(drvdata);
+	for (i = 0; i < drvdata->nr_banks; i++) {
+		bank = &drvdata->pin_banks[i];
+		if (drvdata->resume)
+			drvdata->resume(bank);
+	}
 
 	for (i = 0; i < drvdata->nr_banks; i++) {
-		struct samsung_pin_bank *bank = &drvdata->pin_banks[i];
+		bank = &drvdata->pin_banks[i];
 		void __iomem *reg = bank->pctl_base + bank->pctl_offset;
 		const u8 *offs = bank->type->reg_offset;
 		const u8 *widths = bank->type->fld_width;
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index 14c3b6b965851..7ffd2e193e425 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -285,8 +285,8 @@ struct samsung_pin_ctrl {
 	int		(*eint_gpio_init)(struct samsung_pinctrl_drv_data *);
 	int		(*eint_wkup_init)(struct samsung_pinctrl_drv_data *);
 	void		(*pud_value_init)(struct samsung_pinctrl_drv_data *drvdata);
-	void		(*suspend)(struct samsung_pinctrl_drv_data *);
-	void		(*resume)(struct samsung_pinctrl_drv_data *);
+	void		(*suspend)(struct samsung_pin_bank *bank);
+	void		(*resume)(struct samsung_pin_bank *bank);
 };
 
 /**
@@ -335,8 +335,8 @@ struct samsung_pinctrl_drv_data {
 
 	struct samsung_retention_ctrl	*retention_ctrl;
 
-	void (*suspend)(struct samsung_pinctrl_drv_data *);
-	void (*resume)(struct samsung_pinctrl_drv_data *);
+	void (*suspend)(struct samsung_pin_bank *bank);
+	void (*resume)(struct samsung_pin_bank *bank);
 };
 
 /**
-- 
2.39.5



