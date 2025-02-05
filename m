Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6C0189905;
	Wed,  5 Feb 2025 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766733; cv=none; b=Bjhvjenv0FdaX6Zynz21RvrBfU7+Zd3A77rv53ZhOqHWma4WcE9L0q/n4QM4WwoNIOvTQ+zCG+/SL03c3qbnCT4Xlu0MGPN9ELzQlfuNNvTHp6D2m3wBROglcb+R6RnThobjduyVSqQOGVkDsOp5ftGGg2Ckpga7TqUrV2/o70U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766733; c=relaxed/simple;
	bh=ocFLWootuOE8TVmAKRc9wIl5vInxRS3ywVwirji5SkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtJSmYbwEaalpInktHL3jxwE9/yTC34Zi29F9/xrhVsr1erSuedEHPvVB+KcKLj6dnPQQuReQJGCdo2QxmcYCl2YpiJyu/ZyduqvrA26WrpHDpaPFzWKpXjXdX4mQHCKEfsyQJ91HAhRxKIWfAKWA4ayrVP90WCfYoA1GL7/bvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Hm8rrX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Hm8rrX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51B3C4CED1;
	Wed,  5 Feb 2025 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766733;
	bh=ocFLWootuOE8TVmAKRc9wIl5vInxRS3ywVwirji5SkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Hm8rrX8RqRE/jnGzAGyaiflZclSZl3YBzeFoCuhb01bvoNjyolY7cCrjyxautfcB
	 KjAPUGyyb8SbVS0+LA+vM8dAOiGVYt34B2T9qwhoKWuvF7r8WBqzA/dTVpCYW2y0lF
	 JHigCjWrAJFZzpwGSWt7Ajx1ZU5NZ9xTaMMfHR1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 302/623] pinctrl: amd: Take suspend type into consideration which pins are non-wake
Date: Wed,  5 Feb 2025 14:40:44 +0100
Message-ID: <20250205134507.781940553@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

[ Upstream commit f31f33dbb3bab572bad9fe7b849ab0dcbe6fd279 ]

Some laptops have pins which are a wake source for S0i3/S3 but which
aren't a wake source for S4/S5 and which cause issues when left unmasked
during hibernation (S4).

For example HP EliteBook 855 G7 has pin #24 that causes instant wakeup
(hibernation failure) if left unmasked (it is a wake source only for
S0i3/S3).
GPIO pin #24 on this platform is likely dedicated to WWAN XMM7360
modem since this pin triggers wake notify to WWAN modem's parent PCIe
port.

Fix this by considering a pin a wake source only if it is marked as one
for the current suspend type (S0i3/S3 vs S4/S5).

Since Z-wake pins only make sense at runtime these were excluded from
both of suspend categories, so pins with only the Z-wake flag set are
effectively treated as non-wake pins.

Fixes: 2fff0b5e1a6b ("pinctrl: amd: Mask non-wake source pins with interrupt enabled at suspend")
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/d4b2d076366fdd08a0c1cd9b7ecd91dc95e07269.1736184752.git.mail@maciej.szmigiero.name
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 27 +++++++++++++++++++++------
 drivers/pinctrl/pinctrl-amd.h |  7 +++----
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index fff6d4209ad57..a03feb5a60dda 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -908,12 +908,13 @@ static bool amd_gpio_should_save(struct amd_gpio *gpio_dev, unsigned int pin)
 	return false;
 }
 
-static int amd_gpio_suspend(struct device *dev)
+static int amd_gpio_suspend_hibernate_common(struct device *dev, bool is_suspend)
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
 	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
 	unsigned long flags;
 	int i;
+	u32 wake_mask = is_suspend ? WAKE_SOURCE_SUSPEND : WAKE_SOURCE_HIBERNATE;
 
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
@@ -925,11 +926,11 @@ static int amd_gpio_suspend(struct device *dev)
 		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin * 4) & ~PIN_IRQ_PENDING;
 
 		/* mask any interrupts not intended to be a wake source */
-		if (!(gpio_dev->saved_regs[i] & WAKE_SOURCE)) {
+		if (!(gpio_dev->saved_regs[i] & wake_mask)) {
 			writel(gpio_dev->saved_regs[i] & ~BIT(INTERRUPT_MASK_OFF),
 			       gpio_dev->base + pin * 4);
-			pm_pr_dbg("Disabling GPIO #%d interrupt for suspend.\n",
-				  pin);
+			pm_pr_dbg("Disabling GPIO #%d interrupt for %s.\n",
+				  pin, is_suspend ? "suspend" : "hibernate");
 		}
 
 		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
@@ -938,6 +939,16 @@ static int amd_gpio_suspend(struct device *dev)
 	return 0;
 }
 
+static int amd_gpio_suspend(struct device *dev)
+{
+	return amd_gpio_suspend_hibernate_common(dev, true);
+}
+
+static int amd_gpio_hibernate(struct device *dev)
+{
+	return amd_gpio_suspend_hibernate_common(dev, false);
+}
+
 static int amd_gpio_resume(struct device *dev)
 {
 	struct amd_gpio *gpio_dev = dev_get_drvdata(dev);
@@ -961,8 +972,12 @@ static int amd_gpio_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops amd_gpio_pm_ops = {
-	SET_LATE_SYSTEM_SLEEP_PM_OPS(amd_gpio_suspend,
-				     amd_gpio_resume)
+	.suspend_late = amd_gpio_suspend,
+	.resume_early = amd_gpio_resume,
+	.freeze_late = amd_gpio_hibernate,
+	.thaw_early = amd_gpio_resume,
+	.poweroff_late = amd_gpio_hibernate,
+	.restore_early = amd_gpio_resume,
 };
 #endif
 
diff --git a/drivers/pinctrl/pinctrl-amd.h b/drivers/pinctrl/pinctrl-amd.h
index 667be49c3f48d..3a1e5bffaf6e5 100644
--- a/drivers/pinctrl/pinctrl-amd.h
+++ b/drivers/pinctrl/pinctrl-amd.h
@@ -80,10 +80,9 @@
 #define FUNCTION_MASK		GENMASK(1, 0)
 #define FUNCTION_INVALID	GENMASK(7, 0)
 
-#define WAKE_SOURCE	(BIT(WAKE_CNTRL_OFF_S0I3) | \
-			 BIT(WAKE_CNTRL_OFF_S3)   | \
-			 BIT(WAKE_CNTRL_OFF_S4)   | \
-			 BIT(WAKECNTRL_Z_OFF))
+#define WAKE_SOURCE_SUSPEND  (BIT(WAKE_CNTRL_OFF_S0I3) | \
+			      BIT(WAKE_CNTRL_OFF_S3))
+#define WAKE_SOURCE_HIBERNATE BIT(WAKE_CNTRL_OFF_S4)
 
 struct amd_function {
 	const char *name;
-- 
2.39.5



