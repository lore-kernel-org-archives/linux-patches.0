Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E1240587A;
	Tue, 21 Jul 2026 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658374; cv=none; b=WQMUPObo1iBabfh/1VB2/lUgejyiExySABz5hxMMo8m12jybz68p8aOS0bd4TxlI4TfNJRJOqLxd39KLKgUmX6zLONJD7vwVnhlZtfcWa0PW7PWPMO+sp4DoV4oLVuS0+AKHaQGR1CIEPQIxS0b8khklygeIWbos0vk5aVw7mJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658374; c=relaxed/simple;
	bh=+Tb8AuJ8m/KUrMQIRUyE0fZPa5Xnn9RVcRyKyGtYqMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iW1SI6z0x2juwBLP0Yu5nIT6PcUZ95Xz+8CUYdlK/qiLc8IXZLlASzO6MArnshlO6q5G/GWIK9oVq7Bs+WrZH+fLti8obIIQ989yq0zGJp2Qjd/DERtv8/IXi9i9OckAQ/OZuJU9Sb6kmFOzC9UoHMpcMRia2jea1/GrnWLV9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgSM2Ucp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgSM2Ucp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8357F1F000E9;
	Tue, 21 Jul 2026 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658373;
	bh=tcr09htd8+QRd4d6oyESnLZJlgr5349JHcw9AvBZJ6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgSM2UcpzZTpv4rCSXLs7m29LRzxpFBnlUG60H9XXMH7WrnQ3Ah6Imygfm9w2pB50
	 mjWisWIX9dLsJpVJRiQ/DRVuuIyvJ6PRpdbHC6Evk510pDCn7VuQNLyj1lvPHgW03m
	 XoJeIRx4+wqP/K0aEQYZ2nfy3+HNzRL//7s69pEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1065/1611] gpio: dwapb: Defer clock gating until noirq
Date: Tue, 21 Jul 2026 17:19:41 +0200
Message-ID: <20260721152539.360985914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit d775b9451eb8f52021dea6483ad758fef81dbf1e ]

GPIO consumers such as gpio-keys can enable IRQ wake and adjust the wake
trigger type from their suspend callbacks. If the DWAPB controller suspends
first, masking interrupts and disabling its clocks in the normal suspend
phase prevents that late wake configuration from reliably reaching the
hardware. Systems with real DWAPB bus clocks then fail to wake from s2idle
through GPIO keys.

Save the register context in the normal suspend callback, but defer IRQ
masking and clock gating until suspend_noirq. At that point all consumers
have finished configuring wake IRQs, so keep the clocks enabled when wake
lines are armed and only gate them when no wake source is active.
Resume_noirq reenables clocks, if they were gated, before the normal resume
path restores registers.

Propagate wake requests to the parent irqchip while keeping the local wake
mask in sync with failures.

Fixes: 6437c7ba69c3 ("gpio: dwapb: Add wakeup source support")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Link: https://patch.msgid.link/20260702-gpio-dwapb-wakeup-v2-1-203f2f33429f@ultrarisc.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-dwapb.c | 79 +++++++++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 15cebc8b5d6635..0259c659733236 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -118,6 +118,7 @@ struct dwapb_gpio {
 	unsigned int		flags;
 	struct reset_control	*rst;
 	struct clk_bulk_data	clks[DWAPB_NR_CLOCKS];
+	bool			clocks_on_for_wake;
 	struct dwapb_gpio_port	ports[] __counted_by(nr_ports);
 };
 
@@ -365,11 +366,24 @@ static int dwapb_irq_set_wake(struct irq_data *d, unsigned int enable)
 	struct dwapb_gpio *gpio = to_dwapb_gpio(gc);
 	struct dwapb_context *ctx = gpio->ports[0].ctx;
 	irq_hw_number_t bit = irqd_to_hwirq(d);
+	u32 wake_en = ctx->wake_en;
 
 	if (enable)
-		ctx->wake_en |= BIT(bit);
+		wake_en |= BIT(bit);
 	else
-		ctx->wake_en &= ~BIT(bit);
+		wake_en &= ~BIT(bit);
+
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+	if (d->parent_data && !!ctx->wake_en != !!wake_en) {
+		int err;
+
+		err = irq_chip_set_wake_parent(d, enable);
+		if (err)
+			return err;
+	}
+#endif
+
+	ctx->wake_en = wake_en;
 
 	return 0;
 }
@@ -749,6 +763,8 @@ static int dwapb_gpio_suspend(struct device *dev)
 	int i;
 
 	scoped_guard(gpio_generic_lock_irqsave, gen_gc) {
+		gpio->clocks_on_for_wake = false;
+
 		for (i = 0; i < gpio->nr_ports; i++) {
 			unsigned int offset;
 			unsigned int idx = gpio->ports[i].idx;
@@ -770,11 +786,38 @@ static int dwapb_gpio_suspend(struct device *dev)
 				ctx->int_pol = dwapb_read(gpio, GPIO_INT_POLARITY);
 				ctx->int_type = dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
 				ctx->int_deb = dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int dwapb_gpio_suspend_noirq(struct device *dev)
+{
+	struct dwapb_gpio *gpio = dev_get_drvdata(dev);
+	struct gpio_generic_chip *gen_gc = &gpio->ports[0].chip;
+	bool wake_enabled = false;
+	int i;
+
+	scoped_guard(gpio_generic_lock_irqsave, gen_gc) {
+		for (i = 0; i < gpio->nr_ports; i++) {
+			unsigned int idx = gpio->ports[i].idx;
+			struct dwapb_context *ctx = gpio->ports[i].ctx;
 
-				/* Mask out interrupts */
+			if (idx == 0) {
+				wake_enabled = ctx->wake_en;
 				dwapb_write(gpio, GPIO_INTMASK, ~ctx->wake_en);
+				break;
 			}
 		}
+
+		gpio->clocks_on_for_wake = wake_enabled;
+	}
+
+	if (wake_enabled) {
+		device_set_wakeup_path(dev);
+		return 0;
 	}
 
 	clk_bulk_disable_unprepare(DWAPB_NR_CLOCKS, gpio->clks);
@@ -782,18 +825,27 @@ static int dwapb_gpio_suspend(struct device *dev)
 	return 0;
 }
 
-static int dwapb_gpio_resume(struct device *dev)
+static int dwapb_gpio_resume_noirq(struct device *dev)
 {
 	struct dwapb_gpio *gpio = dev_get_drvdata(dev);
-	struct gpio_chip *gc = &gpio->ports[0].chip.gc;
-	struct gpio_generic_chip *gen_gc = to_gpio_generic_chip(gc);
-	int i, err;
+	int err;
+
+	if (gpio->clocks_on_for_wake)
+		return 0;
 
 	err = clk_bulk_prepare_enable(DWAPB_NR_CLOCKS, gpio->clks);
-	if (err) {
+	if (err)
 		dev_err(gpio->dev, "Cannot reenable APB/Debounce clocks\n");
-		return err;
-	}
+
+	return err;
+}
+
+static int dwapb_gpio_resume(struct device *dev)
+{
+	struct dwapb_gpio *gpio = dev_get_drvdata(dev);
+	struct gpio_chip *gc = &gpio->ports[0].chip.gc;
+	struct gpio_generic_chip *gen_gc = to_gpio_generic_chip(gc);
+	int i;
 
 	guard(gpio_generic_lock_irqsave)(gen_gc);
 
@@ -827,8 +879,11 @@ static int dwapb_gpio_resume(struct device *dev)
 	return 0;
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(dwapb_gpio_pm_ops,
-				dwapb_gpio_suspend, dwapb_gpio_resume);
+static const struct dev_pm_ops dwapb_gpio_pm_ops = {
+	SYSTEM_SLEEP_PM_OPS(dwapb_gpio_suspend, dwapb_gpio_resume)
+	NOIRQ_SYSTEM_SLEEP_PM_OPS(dwapb_gpio_suspend_noirq,
+				  dwapb_gpio_resume_noirq)
+};
 
 static struct platform_driver dwapb_gpio_driver = {
 	.driver		= {
-- 
2.53.0



