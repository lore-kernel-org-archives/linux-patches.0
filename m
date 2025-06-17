Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00F9285053;
	Tue, 17 Jun 2025 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177897; cv=none; b=e/vU6+I/i34U3x1VbkkvFijFNdZaI4CHLAmXNU1nBP5meXSEAqJNhS84pOBmh+rGjPLmignXEdRbn3N3lDiO0PKy2rirfgXdTwm4VXNF4K3c4HzZSSnGUK71D7kD+H7vf83W4NWSAzEoIVRpYZpAav/owiWsX99GDVXLA7hJx1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177897; c=relaxed/simple;
	bh=e6ReRnzhLhlx54ILLiGj5E8/j6yO878j9LT6CpRn+ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7Oo+JNK754AFaMsop/A8BCttxNa+TfTxxth7gA26S6mlVrhyb5oVB2Q2UJJKa6fwOEmn/6HeWtK7trld2V4CB6rSVeRbzfAMCWGHruOly0gXLZYbGvTOAZoymh3mC81ZD8qjmwnYXjn9oELTnU86MHIIoS7uqe6geWLH2FUeyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IY8T3ome; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IY8T3ome"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6723CC4CEE3;
	Tue, 17 Jun 2025 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177896;
	bh=e6ReRnzhLhlx54ILLiGj5E8/j6yO878j9LT6CpRn+ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IY8T3omeOh/c0mIEU3Uz+SX6UNrJSi+fsv+AbDmvrHYauYWwLXcHXA6jFx2ctCzBd
	 uVLj4/eSjfXRx3qTIZ8BwGxTFzfdPqbeyvMPY60xohLHg8psGbE/j6ulz8+T/J3+ym
	 Fl2Pzez8pLcWb0FsXzcMyOCTn/U0g5rgK6OC7iAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 412/512] pinctrl: samsung: add dedicated SoC eint suspend/resume callbacks
Date: Tue, 17 Jun 2025 17:26:18 +0200
Message-ID: <20250617152436.269505359@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit 77ac6b742eba063a5b6600cda67834a7a212281a ]

Refactor the existing platform specific suspend/resume callback
so that each SoC variant has it's own callback containing the
SoC specific logic.

This allows exynosautov920 to have a dedicated function for using
eint_con_offset and eint_mask_offset. Also it is easily extendable
for gs101 which will need dedicated logic for handling the varying
register offset of fltcon0 via eint_fltcon_offset.

Reviewed-by: André Draszik <andre.draszik@linaro.org>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250402-pinctrl-fltcon-suspend-v6-2-78ce0d4eb30c@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: bdbe0a0f7100 ("pinctrl: samsung: add gs101 specific eint suspend/resume callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pinctrl/samsung/pinctrl-exynos-arm64.c    |  28 ++--
 drivers/pinctrl/samsung/pinctrl-exynos.c      | 152 ++++++++++--------
 drivers/pinctrl/samsung/pinctrl-exynos.h      |   2 +
 3 files changed, 97 insertions(+), 85 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c b/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
index 23b4bc1e5da81..ce61a85c7784a 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
@@ -809,8 +809,8 @@ static const struct samsung_pin_ctrl exynosautov920_pin_ctrl[] = {
 		.pin_banks	= exynosautov920_pin_banks0,
 		.nr_banks	= ARRAY_SIZE(exynosautov920_pin_banks0),
 		.eint_wkup_init	= exynos_eint_wkup_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= exynosautov920_pinctrl_suspend,
+		.resume		= exynosautov920_pinctrl_resume,
 		.retention_data	= &exynosautov920_retention_data,
 	}, {
 		/* pin-controller instance 1 AUD data */
@@ -821,43 +821,43 @@ static const struct samsung_pin_ctrl exynosautov920_pin_ctrl[] = {
 		.pin_banks	= exynosautov920_pin_banks2,
 		.nr_banks	= ARRAY_SIZE(exynosautov920_pin_banks2),
 		.eint_gpio_init	= exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= exynosautov920_pinctrl_suspend,
+		.resume		= exynosautov920_pinctrl_resume,
 	}, {
 		/* pin-controller instance 3 HSI1 data */
 		.pin_banks	= exynosautov920_pin_banks3,
 		.nr_banks	= ARRAY_SIZE(exynosautov920_pin_banks3),
 		.eint_gpio_init	= exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= exynosautov920_pinctrl_suspend,
+		.resume		= exynosautov920_pinctrl_resume,
 	}, {
 		/* pin-controller instance 4 HSI2 data */
 		.pin_banks	= exynosautov920_pin_banks4,
 		.nr_banks	= ARRAY_SIZE(exynosautov920_pin_banks4),
 		.eint_gpio_init	= exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= exynosautov920_pinctrl_suspend,
+		.resume		= exynosautov920_pinctrl_resume,
 	}, {
 		/* pin-controller instance 5 HSI2UFS data */
 		.pin_banks	= exynosautov920_pin_banks5,
 		.nr_banks	= ARRAY_SIZE(exynosautov920_pin_banks5),
 		.eint_gpio_init	= exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= exynosautov920_pinctrl_suspend,
+		.resume		= exynosautov920_pinctrl_resume,
 	}, {
 		/* pin-controller instance 6 PERIC0 data */
 		.pin_banks	= exynosautov920_pin_banks6,
 		.nr_banks	= ARRAY_SIZE(exynosautov920_pin_banks6),
 		.eint_gpio_init	= exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= exynosautov920_pinctrl_suspend,
+		.resume		= exynosautov920_pinctrl_resume,
 	}, {
 		/* pin-controller instance 7 PERIC1 data */
 		.pin_banks	= exynosautov920_pin_banks7,
 		.nr_banks	= ARRAY_SIZE(exynosautov920_pin_banks7),
 		.eint_gpio_init	= exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= exynosautov920_pinctrl_suspend,
+		.resume		= exynosautov920_pinctrl_resume,
 	},
 };
 
diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index 62c8d8d907545..af4fb1cde8de9 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -761,105 +761,115 @@ __init int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 	return 0;
 }
 
-static void exynos_pinctrl_suspend_bank(struct samsung_pin_bank *bank)
+static void exynos_set_wakeup(struct samsung_pin_bank *bank)
 {
-	struct exynos_eint_gpio_save *save = bank->soc_priv;
-	const void __iomem *regs = bank->eint_base;
+	struct exynos_irq_chip *irq_chip;
 
-	save->eint_con = readl(regs + EXYNOS_GPIO_ECON_OFFSET
-						+ bank->eint_offset);
-	save->eint_fltcon0 = readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
-						+ 2 * bank->eint_offset);
-	save->eint_fltcon1 = readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
-						+ 2 * bank->eint_offset + 4);
-	save->eint_mask = readl(regs + bank->irq_chip->eint_mask
-						+ bank->eint_offset);
-
-	pr_debug("%s: save     con %#010x\n", bank->name, save->eint_con);
-	pr_debug("%s: save fltcon0 %#010x\n", bank->name, save->eint_fltcon0);
-	pr_debug("%s: save fltcon1 %#010x\n", bank->name, save->eint_fltcon1);
-	pr_debug("%s: save    mask %#010x\n", bank->name, save->eint_mask);
+	if (bank->irq_chip) {
+		irq_chip = bank->irq_chip;
+		irq_chip->set_eint_wakeup_mask(bank->drvdata, irq_chip);
+	}
 }
 
-static void exynosauto_pinctrl_suspend_bank(struct samsung_pin_bank *bank)
+void exynos_pinctrl_suspend(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
 	const void __iomem *regs = bank->eint_base;
 
-	save->eint_con = readl(regs + bank->pctl_offset + bank->eint_con_offset);
-	save->eint_mask = readl(regs + bank->pctl_offset + bank->eint_mask_offset);
-
-	pr_debug("%s: save     con %#010x\n", bank->name, save->eint_con);
-	pr_debug("%s: save    mask %#010x\n", bank->name, save->eint_mask);
+	if (bank->eint_type == EINT_TYPE_GPIO) {
+		save->eint_con = readl(regs + EXYNOS_GPIO_ECON_OFFSET
+				       + bank->eint_offset);
+		save->eint_fltcon0 = readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
+					   + 2 * bank->eint_offset);
+		save->eint_fltcon1 = readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
+					   + 2 * bank->eint_offset + 4);
+		save->eint_mask = readl(regs + bank->irq_chip->eint_mask
+					+ bank->eint_offset);
+
+		pr_debug("%s: save     con %#010x\n",
+			 bank->name, save->eint_con);
+		pr_debug("%s: save fltcon0 %#010x\n",
+			 bank->name, save->eint_fltcon0);
+		pr_debug("%s: save fltcon1 %#010x\n",
+			 bank->name, save->eint_fltcon1);
+		pr_debug("%s: save    mask %#010x\n",
+			 bank->name, save->eint_mask);
+	} else if (bank->eint_type == EINT_TYPE_WKUP) {
+		exynos_set_wakeup(bank);
+	}
 }
 
-void exynos_pinctrl_suspend(struct samsung_pin_bank *bank)
+void exynosautov920_pinctrl_suspend(struct samsung_pin_bank *bank)
 {
-	struct exynos_irq_chip *irq_chip = NULL;
+	struct exynos_eint_gpio_save *save = bank->soc_priv;
+	const void __iomem *regs = bank->eint_base;
 
 	if (bank->eint_type == EINT_TYPE_GPIO) {
-		if (bank->eint_con_offset)
-			exynosauto_pinctrl_suspend_bank(bank);
-		else
-			exynos_pinctrl_suspend_bank(bank);
+		save->eint_con = readl(regs + bank->pctl_offset +
+				       bank->eint_con_offset);
+		save->eint_mask = readl(regs + bank->pctl_offset +
+					bank->eint_mask_offset);
+		pr_debug("%s: save     con %#010x\n",
+			 bank->name, save->eint_con);
+		pr_debug("%s: save    mask %#010x\n",
+			 bank->name, save->eint_mask);
 	} else if (bank->eint_type == EINT_TYPE_WKUP) {
-		if (!irq_chip) {
-			irq_chip = bank->irq_chip;
-			irq_chip->set_eint_wakeup_mask(bank->drvdata, irq_chip);
-		}
+		exynos_set_wakeup(bank);
 	}
 }
 
-static void exynos_pinctrl_resume_bank(struct samsung_pin_bank *bank)
+void exynos_pinctrl_resume(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
 	void __iomem *regs = bank->eint_base;
 
-	pr_debug("%s:     con %#010x => %#010x\n", bank->name,
-			readl(regs + EXYNOS_GPIO_ECON_OFFSET
-			+ bank->eint_offset), save->eint_con);
-	pr_debug("%s: fltcon0 %#010x => %#010x\n", bank->name,
-			readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
-			+ 2 * bank->eint_offset), save->eint_fltcon0);
-	pr_debug("%s: fltcon1 %#010x => %#010x\n", bank->name,
-			readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
-			+ 2 * bank->eint_offset + 4), save->eint_fltcon1);
-	pr_debug("%s:    mask %#010x => %#010x\n", bank->name,
-			readl(regs + bank->irq_chip->eint_mask
-			+ bank->eint_offset), save->eint_mask);
-
-	writel(save->eint_con, regs + EXYNOS_GPIO_ECON_OFFSET
-						+ bank->eint_offset);
-	writel(save->eint_fltcon0, regs + EXYNOS_GPIO_EFLTCON_OFFSET
-						+ 2 * bank->eint_offset);
-	writel(save->eint_fltcon1, regs + EXYNOS_GPIO_EFLTCON_OFFSET
-						+ 2 * bank->eint_offset + 4);
-	writel(save->eint_mask, regs + bank->irq_chip->eint_mask
-						+ bank->eint_offset);
+	if (bank->eint_type == EINT_TYPE_GPIO) {
+		pr_debug("%s:     con %#010x => %#010x\n", bank->name,
+			 readl(regs + EXYNOS_GPIO_ECON_OFFSET
+			       + bank->eint_offset), save->eint_con);
+		pr_debug("%s: fltcon0 %#010x => %#010x\n", bank->name,
+			 readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
+			       + 2 * bank->eint_offset), save->eint_fltcon0);
+		pr_debug("%s: fltcon1 %#010x => %#010x\n", bank->name,
+			 readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
+			       + 2 * bank->eint_offset + 4),
+			 save->eint_fltcon1);
+		pr_debug("%s:    mask %#010x => %#010x\n", bank->name,
+			 readl(regs + bank->irq_chip->eint_mask
+			       + bank->eint_offset), save->eint_mask);
+
+		writel(save->eint_con, regs + EXYNOS_GPIO_ECON_OFFSET
+		       + bank->eint_offset);
+		writel(save->eint_fltcon0, regs + EXYNOS_GPIO_EFLTCON_OFFSET
+		       + 2 * bank->eint_offset);
+		writel(save->eint_fltcon1, regs + EXYNOS_GPIO_EFLTCON_OFFSET
+		       + 2 * bank->eint_offset + 4);
+		writel(save->eint_mask, regs + bank->irq_chip->eint_mask
+		       + bank->eint_offset);
+	}
 }
 
-static void exynosauto_pinctrl_resume_bank(struct samsung_pin_bank *bank)
+void exynosautov920_pinctrl_resume(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
 	void __iomem *regs = bank->eint_base;
 
-	pr_debug("%s:     con %#010x => %#010x\n", bank->name,
-		 readl(regs + bank->pctl_offset + bank->eint_con_offset), save->eint_con);
-	pr_debug("%s:    mask %#010x => %#010x\n", bank->name,
-		 readl(regs + bank->pctl_offset + bank->eint_mask_offset), save->eint_mask);
-
-	writel(save->eint_con, regs + bank->pctl_offset + bank->eint_con_offset);
-	writel(save->eint_mask, regs + bank->pctl_offset + bank->eint_mask_offset);
-
-}
-
-void exynos_pinctrl_resume(struct samsung_pin_bank *bank)
-{
 	if (bank->eint_type == EINT_TYPE_GPIO) {
-		if (bank->eint_con_offset)
-			exynosauto_pinctrl_resume_bank(bank);
-		else
-			exynos_pinctrl_resume_bank(bank);
+		/* exynosautov920 has eint_con_offset for all but one bank */
+		if (!bank->eint_con_offset)
+			exynos_pinctrl_resume(bank);
+
+		pr_debug("%s:     con %#010x => %#010x\n", bank->name,
+			 readl(regs + bank->pctl_offset + bank->eint_con_offset),
+			 save->eint_con);
+		pr_debug("%s:    mask %#010x => %#010x\n", bank->name,
+			 readl(regs + bank->pctl_offset +
+			       bank->eint_mask_offset), save->eint_mask);
+
+		writel(save->eint_con,
+		       regs + bank->pctl_offset + bank->eint_con_offset);
+		writel(save->eint_mask,
+		       regs + bank->pctl_offset + bank->eint_mask_offset);
 	}
 }
 
diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.h b/drivers/pinctrl/samsung/pinctrl-exynos.h
index ce39ab52102e7..837b737c6f0a7 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.h
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.h
@@ -211,6 +211,8 @@ struct exynos_muxed_weint_data {
 
 int exynos_eint_gpio_init(struct samsung_pinctrl_drv_data *d);
 int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d);
+void exynosautov920_pinctrl_resume(struct samsung_pin_bank *bank);
+void exynosautov920_pinctrl_suspend(struct samsung_pin_bank *bank);
 void exynos_pinctrl_suspend(struct samsung_pin_bank *bank);
 void exynos_pinctrl_resume(struct samsung_pin_bank *bank);
 struct samsung_retention_ctrl *
-- 
2.39.5



