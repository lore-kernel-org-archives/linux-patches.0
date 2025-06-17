Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A5F20CCFB;
	Tue, 17 Jun 2025 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178082; cv=none; b=GYlG7AR0sp7yB3LNQFHLe205Nktlie2e6+h/uJkQmdstHSG8jWV0ET5XCW0v4y/e7gflOkEgK3o3lAv1UL2HPXZDVX1tQC8xz/V3+I5hRC+WjYC6PoX0+zDhQ36PMRMcfSSNRPxAs+DpIu5guFQSOOxLMGv7y2LN20DzHp30zjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178082; c=relaxed/simple;
	bh=Zjq5N6F9BhD2Efm3sqwlTwwRxd37+A75eUNaWkjY/d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N3RxPfrnzjNxuiSVq14dV0r0n4HNew8fshVjo7bhAgoM6xE0DHYWFgrWvtXhKIEnHOqC1JEncfevAwnV0UR1WA6iI+29Wvc3H4xY+vJsqfg/JTARJYsMkO6D4aoUwNFj+inzAZpOewbv7CTt3qzB5hh8oN5Kknlh1Mdsiai0de0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUUsep3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUUsep3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4262C4CEE3;
	Tue, 17 Jun 2025 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178082;
	bh=Zjq5N6F9BhD2Efm3sqwlTwwRxd37+A75eUNaWkjY/d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUUsep3grlZxec1NUaHeJFetz0TmP2SsZN2Ydo8XsNd1nFJkyOEr5lBKvp0bCfW7z
	 AddBRUzNzNE3MEFCjsykukXjRGgh1e9asjgeKloBsfuppQ+02vAIOyEQs/Dtv82G3W
	 eQ5b/0cFekEn+O3KboApUxmc8R4Os8pVxD2MzI8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 413/512] pinctrl: samsung: add gs101 specific eint suspend/resume callbacks
Date: Tue, 17 Jun 2025 17:26:19 +0200
Message-ID: <20250617152436.317161676@linuxfoundation.org>
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

[ Upstream commit bdbe0a0f71003b997d6a2dbe4bc7b5b0438207c7 ]

gs101 differs to other SoCs in that fltcon1 register doesn't
always exist. Additionally the offset of fltcon0 is not fixed
and needs to use the newly added eint_fltcon_offset variable.

Fixes: 4a8be01a1a7a ("pinctrl: samsung: Add gs101 SoC pinctrl configuration")
Cc: stable@vger.kernel.org  # depends on the previous three patches
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250402-pinctrl-fltcon-suspend-v6-3-78ce0d4eb30c@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pinctrl/samsung/pinctrl-exynos-arm64.c    | 24 +++----
 drivers/pinctrl/samsung/pinctrl-exynos.c      | 71 +++++++++++++++++++
 drivers/pinctrl/samsung/pinctrl-exynos.h      |  2 +
 3 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c b/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
index ce61a85c7784a..a2ac1702d0dfa 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos-arm64.c
@@ -1024,15 +1024,15 @@ static const struct samsung_pin_ctrl gs101_pin_ctrl[] __initconst = {
 		.pin_banks	= gs101_pin_alive,
 		.nr_banks	= ARRAY_SIZE(gs101_pin_alive),
 		.eint_wkup_init = exynos_eint_wkup_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= gs101_pinctrl_suspend,
+		.resume		= gs101_pinctrl_resume,
 	}, {
 		/* pin banks of gs101 pin-controller (FAR_ALIVE) */
 		.pin_banks	= gs101_pin_far_alive,
 		.nr_banks	= ARRAY_SIZE(gs101_pin_far_alive),
 		.eint_wkup_init = exynos_eint_wkup_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= gs101_pinctrl_suspend,
+		.resume		= gs101_pinctrl_resume,
 	}, {
 		/* pin banks of gs101 pin-controller (GSACORE) */
 		.pin_banks	= gs101_pin_gsacore,
@@ -1046,29 +1046,29 @@ static const struct samsung_pin_ctrl gs101_pin_ctrl[] __initconst = {
 		.pin_banks	= gs101_pin_peric0,
 		.nr_banks	= ARRAY_SIZE(gs101_pin_peric0),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= gs101_pinctrl_suspend,
+		.resume		= gs101_pinctrl_resume,
 	}, {
 		/* pin banks of gs101 pin-controller (PERIC1) */
 		.pin_banks	= gs101_pin_peric1,
 		.nr_banks	= ARRAY_SIZE(gs101_pin_peric1),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume	= exynos_pinctrl_resume,
+		.suspend	= gs101_pinctrl_suspend,
+		.resume		= gs101_pinctrl_resume,
 	}, {
 		/* pin banks of gs101 pin-controller (HSI1) */
 		.pin_banks	= gs101_pin_hsi1,
 		.nr_banks	= ARRAY_SIZE(gs101_pin_hsi1),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= gs101_pinctrl_suspend,
+		.resume		= gs101_pinctrl_resume,
 	}, {
 		/* pin banks of gs101 pin-controller (HSI2) */
 		.pin_banks	= gs101_pin_hsi2,
 		.nr_banks	= ARRAY_SIZE(gs101_pin_hsi2),
 		.eint_gpio_init = exynos_eint_gpio_init,
-		.suspend	= exynos_pinctrl_suspend,
-		.resume		= exynos_pinctrl_resume,
+		.suspend	= gs101_pinctrl_suspend,
+		.resume		= gs101_pinctrl_resume,
 	},
 };
 
diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index af4fb1cde8de9..7887fd4166511 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -799,6 +799,41 @@ void exynos_pinctrl_suspend(struct samsung_pin_bank *bank)
 	}
 }
 
+void gs101_pinctrl_suspend(struct samsung_pin_bank *bank)
+{
+	struct exynos_eint_gpio_save *save = bank->soc_priv;
+	const void __iomem *regs = bank->eint_base;
+
+	if (bank->eint_type == EINT_TYPE_GPIO) {
+		save->eint_con = readl(regs + EXYNOS_GPIO_ECON_OFFSET
+				       + bank->eint_offset);
+
+		save->eint_fltcon0 = readl(regs + EXYNOS_GPIO_EFLTCON_OFFSET
+					   + bank->eint_fltcon_offset);
+
+		/* fltcon1 register only exists for pins 4-7 */
+		if (bank->nr_pins > 4)
+			save->eint_fltcon1 = readl(regs +
+						EXYNOS_GPIO_EFLTCON_OFFSET
+						+ bank->eint_fltcon_offset + 4);
+
+		save->eint_mask = readl(regs + bank->irq_chip->eint_mask
+					+ bank->eint_offset);
+
+		pr_debug("%s: save     con %#010x\n",
+			 bank->name, save->eint_con);
+		pr_debug("%s: save fltcon0 %#010x\n",
+			 bank->name, save->eint_fltcon0);
+		if (bank->nr_pins > 4)
+			pr_debug("%s: save fltcon1 %#010x\n",
+				 bank->name, save->eint_fltcon1);
+		pr_debug("%s: save    mask %#010x\n",
+			 bank->name, save->eint_mask);
+	} else if (bank->eint_type == EINT_TYPE_WKUP) {
+		exynos_set_wakeup(bank);
+	}
+}
+
 void exynosautov920_pinctrl_suspend(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
@@ -818,6 +853,42 @@ void exynosautov920_pinctrl_suspend(struct samsung_pin_bank *bank)
 	}
 }
 
+void gs101_pinctrl_resume(struct samsung_pin_bank *bank)
+{
+	struct exynos_eint_gpio_save *save = bank->soc_priv;
+
+	void __iomem *regs = bank->eint_base;
+	void __iomem *eint_fltcfg0 = regs + EXYNOS_GPIO_EFLTCON_OFFSET
+		     + bank->eint_fltcon_offset;
+
+	if (bank->eint_type == EINT_TYPE_GPIO) {
+		pr_debug("%s:     con %#010x => %#010x\n", bank->name,
+			 readl(regs + EXYNOS_GPIO_ECON_OFFSET
+			       + bank->eint_offset), save->eint_con);
+
+		pr_debug("%s: fltcon0 %#010x => %#010x\n", bank->name,
+			 readl(eint_fltcfg0), save->eint_fltcon0);
+
+		/* fltcon1 register only exists for pins 4-7 */
+		if (bank->nr_pins > 4)
+			pr_debug("%s: fltcon1 %#010x => %#010x\n", bank->name,
+				 readl(eint_fltcfg0 + 4), save->eint_fltcon1);
+
+		pr_debug("%s:    mask %#010x => %#010x\n", bank->name,
+			 readl(regs + bank->irq_chip->eint_mask
+			       + bank->eint_offset), save->eint_mask);
+
+		writel(save->eint_con, regs + EXYNOS_GPIO_ECON_OFFSET
+		       + bank->eint_offset);
+		writel(save->eint_fltcon0, eint_fltcfg0);
+
+		if (bank->nr_pins > 4)
+			writel(save->eint_fltcon1, eint_fltcfg0 + 4);
+		writel(save->eint_mask, regs + bank->irq_chip->eint_mask
+		       + bank->eint_offset);
+	}
+}
+
 void exynos_pinctrl_resume(struct samsung_pin_bank *bank)
 {
 	struct exynos_eint_gpio_save *save = bank->soc_priv;
diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.h b/drivers/pinctrl/samsung/pinctrl-exynos.h
index 837b737c6f0a7..c70b8ead56b4b 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.h
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.h
@@ -215,6 +215,8 @@ void exynosautov920_pinctrl_resume(struct samsung_pin_bank *bank);
 void exynosautov920_pinctrl_suspend(struct samsung_pin_bank *bank);
 void exynos_pinctrl_suspend(struct samsung_pin_bank *bank);
 void exynos_pinctrl_resume(struct samsung_pin_bank *bank);
+void gs101_pinctrl_suspend(struct samsung_pin_bank *bank);
+void gs101_pinctrl_resume(struct samsung_pin_bank *bank);
 struct samsung_retention_ctrl *
 exynos_retention_init(struct samsung_pinctrl_drv_data *drvdata,
 		      const struct samsung_retention_data *data);
-- 
2.39.5



