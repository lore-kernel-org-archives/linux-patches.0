Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D727934D387;
	Fri, 31 Oct 2025 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919374; cv=none; b=t9/hiT5IpW4+kLqUtiZts1vJfeV8ku/ISLZQAjo3clGF/ds+CFdi9GIdIAPxOFboSzFiD92M2tiB2k2YZO/axPNvvV+3thfX8o4+f/Sdutkf9VVKTfsF/NVzL5Igd0g+fOZa31u4UGYlcTZ9LZHpAcS0sS+i7Orx+Il+d9NxRHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919374; c=relaxed/simple;
	bh=VGhcMCfOQjbLdcBCOH71AOtkwKq8S+do+bBv5nmT01g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHQhMtp/1aHt9HXyGGJ0huenFfqd8VBfJabpi6S3MugAwSMdT+c5lp380kMY/l6yw1vkALGwTXBPFQ2SR2fevjh4FLmEMgRcufYNlcnQlGusBN9yFcPVZrNYAGV8zsJxIb4TeNCriGSAxQ34ifCfIP/zvDcf3QndHxj6JvhTkGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBt/a7WR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBt/a7WR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601F5C4CEE7;
	Fri, 31 Oct 2025 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919374;
	bh=VGhcMCfOQjbLdcBCOH71AOtkwKq8S+do+bBv5nmT01g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBt/a7WRMoincmZ0oh4F7Ms4G+5oXkJ1qpqPMEF3Tf1/bv9DrVFiPNKMsosUU3Un+
	 wqRHVevdMpSXErlIIQJ1CHmLBQVNWjLWCQGvpf0ymFjEAeAmZ06SqkLnsxxPY8mmhq
	 b916zTikQ/JROoB7SfVDGz8Hw971gu5rJ+JxqZx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Lee Jones <lee@kernel.org>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.6 30/32] gpio: regmap: Allow to allocate regmap-irq device
Date: Fri, 31 Oct 2025 15:01:24 +0100
Message-ID: <20251031140043.181824580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>

[ Upstream commit 553b75d4bfe9264f631d459fe9996744e0672b0e ]

GPIO controller often have support for IRQ: allow to easily allocate
both gpio-regmap and regmap-irq in one operation.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
Link: https://lore.kernel.org/r/20250824-mdb-max7360-support-v14-5-435cfda2b1ea@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 2ba5772e530f ("gpio: idio-16: Define fixed direction of the GPIO lines")
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-regmap.c  |   29 +++++++++++++++++++++++++++--
 include/linux/gpio/regmap.h |   11 +++++++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-regmap.c
+++ b/drivers/gpio/gpio-regmap.c
@@ -30,6 +30,11 @@ struct gpio_regmap {
 	unsigned int reg_dir_in_base;
 	unsigned int reg_dir_out_base;
 
+#ifdef CONFIG_REGMAP_IRQ
+	int regmap_irq_line;
+	struct regmap_irq_chip_data *irq_chip_data;
+#endif
+
 	int (*reg_mask_xlate)(struct gpio_regmap *gpio, unsigned int base,
 			      unsigned int offset, unsigned int *reg,
 			      unsigned int *mask);
@@ -203,6 +208,7 @@ EXPORT_SYMBOL_GPL(gpio_regmap_get_drvdat
  */
 struct gpio_regmap *gpio_regmap_register(const struct gpio_regmap_config *config)
 {
+	struct irq_domain *irq_domain;
 	struct gpio_regmap *gpio;
 	struct gpio_chip *chip;
 	int ret;
@@ -278,8 +284,22 @@ struct gpio_regmap *gpio_regmap_register
 	if (ret < 0)
 		goto err_free_gpio;
 
-	if (config->irq_domain) {
-		ret = gpiochip_irqchip_add_domain(chip, config->irq_domain);
+#ifdef CONFIG_REGMAP_IRQ
+	if (config->regmap_irq_chip) {
+		gpio->regmap_irq_line = config->regmap_irq_line;
+		ret = regmap_add_irq_chip_fwnode(dev_fwnode(config->parent), config->regmap,
+						 config->regmap_irq_line, config->regmap_irq_flags,
+						 0, config->regmap_irq_chip, &gpio->irq_chip_data);
+		if (ret)
+			goto err_free_gpio;
+
+		irq_domain = regmap_irq_get_domain(gpio->irq_chip_data);
+	} else
+#endif
+	irq_domain = config->irq_domain;
+
+	if (irq_domain) {
+		ret = gpiochip_irqchip_add_domain(chip, irq_domain);
 		if (ret)
 			goto err_remove_gpiochip;
 	}
@@ -300,6 +320,11 @@ EXPORT_SYMBOL_GPL(gpio_regmap_register);
  */
 void gpio_regmap_unregister(struct gpio_regmap *gpio)
 {
+#ifdef CONFIG_REGMAP_IRQ
+	if (gpio->irq_chip_data)
+		regmap_del_irq_chip(gpio->regmap_irq_line, gpio->irq_chip_data);
+#endif
+
 	gpiochip_remove(&gpio->gpio_chip);
 	kfree(gpio);
 }
--- a/include/linux/gpio/regmap.h
+++ b/include/linux/gpio/regmap.h
@@ -40,6 +40,11 @@ struct regmap;
  * @drvdata:		(Optional) Pointer to driver specific data which is
  *			not used by gpio-remap but is provided "as is" to the
  *			driver callback(s).
+ * @regmap_irq_chip:	(Optional) Pointer on an regmap_irq_chip structure. If
+ *			set, a regmap-irq device will be created and the IRQ
+ *			domain will be set accordingly.
+ * @regmap_irq_line	(Optional) The IRQ the device uses to signal interrupts.
+ * @regmap_irq_flags	(Optional) The IRQF_ flags to use for the interrupt.
  *
  * The ->reg_mask_xlate translates a given base address and GPIO offset to
  * register and mask pair. The base address is one of the given register
@@ -78,6 +83,12 @@ struct gpio_regmap_config {
 	int ngpio_per_reg;
 	struct irq_domain *irq_domain;
 
+#ifdef CONFIG_REGMAP_IRQ
+	struct regmap_irq_chip *regmap_irq_chip;
+	int regmap_irq_line;
+	unsigned long regmap_irq_flags;
+#endif
+
 	int (*reg_mask_xlate)(struct gpio_regmap *gpio, unsigned int base,
 			      unsigned int offset, unsigned int *reg,
 			      unsigned int *mask);


