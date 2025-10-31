Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5003F9D2;
	Fri, 31 Oct 2025 14:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919378; cv=none; b=VXXpJ2dCGK/n1kAD80I1ePn8QaXLuho4U4GSsMnvUkQHFweWuHcyZMGkGpqs26Gkohq7b+/IOQQ1/1BH9OOGp5CgQb4nvjcZyZNFjEcyFR64/+2mU02jmwLaYaATDJEtETl8QqeSvjqq4t4+5nsnsz88K+pTsSPGQrBx2DYSNzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919378; c=relaxed/simple;
	bh=xxiTVPLCLXgORfeoe612MkR4sJWL8OIrkxNQb4QruUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vmjn0+sFAbJS8+TMAYkj+/HYatlUAlDrWDXTtdby/ENtek3IysyC7ZraLbbIPOWJbmhO1cjjvAYo1gzJYTzUmouvly+RS9xAhuE5B0q6AlMbl/UPwalejLRhsW8evj10KWsok+/KG1km5lois6FN8l3nhOOy7fVZVHAKbKYXiUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCbrK5Q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCbrK5Q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694B8C4CEE7;
	Fri, 31 Oct 2025 14:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919377;
	bh=xxiTVPLCLXgORfeoe612MkR4sJWL8OIrkxNQb4QruUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCbrK5Q/Y85IxcnRHnxIgJgmYooB4OmHAFkLHIl9aqOM860Gd30wUr86jBdZAiwPo
	 REApqpbGGxN1JmiaJ9U2FyCJc8MEVeUR0d1aHnwt0g0huhswauKHQpYa2G3bUnJcdw
	 SP5x1da26z9tLD8Ob9Akn/Z7XYwL7dJmW46G2KNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Michael Walle <mwalle@kernel.org>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.6 31/32] gpio: regmap: add the .fixed_direction_output configuration parameter
Date: Fri, 31 Oct 2025 15:01:25 +0100
Message-ID: <20251031140043.205716161@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 00aaae60faf554c27c95e93d47f200a93ff266ef ]

There are GPIO controllers such as the one present in the LX2160ARDB
QIXIS FPGA which have fixed-direction input and output GPIO lines mixed
together in a single register. This cannot be modeled using the
gpio-regmap as-is since there is no way to present the true direction of
a GPIO line.

In order to make this use case possible, add a new configuration
parameter - fixed_direction_output - into the gpio_regmap_config
structure. This will enable user drivers to provide a bitmap that
represents the fixed direction of the GPIO lines.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 2ba5772e530f ("gpio: idio-16: Define fixed direction of the GPIO lines")
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-regmap.c  |   26 ++++++++++++++++++++++++--
 include/linux/gpio/regmap.h |    5 +++++
 2 files changed, 29 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-regmap.c
+++ b/drivers/gpio/gpio-regmap.c
@@ -29,6 +29,7 @@ struct gpio_regmap {
 	unsigned int reg_clr_base;
 	unsigned int reg_dir_in_base;
 	unsigned int reg_dir_out_base;
+	unsigned long *fixed_direction_output;
 
 #ifdef CONFIG_REGMAP_IRQ
 	int regmap_irq_line;
@@ -122,6 +123,13 @@ static int gpio_regmap_get_direction(str
 	unsigned int base, val, reg, mask;
 	int invert, ret;
 
+	if (gpio->fixed_direction_output) {
+		if (test_bit(offset, gpio->fixed_direction_output))
+			return GPIO_LINE_DIRECTION_OUT;
+		else
+			return GPIO_LINE_DIRECTION_IN;
+	}
+
 	if (gpio->reg_dat_base && !gpio->reg_set_base)
 		return GPIO_LINE_DIRECTION_IN;
 	if (gpio->reg_set_base && !gpio->reg_dat_base)
@@ -280,9 +288,20 @@ struct gpio_regmap *gpio_regmap_register
 		chip->direction_output = gpio_regmap_direction_output;
 	}
 
+	if (config->fixed_direction_output) {
+		gpio->fixed_direction_output = bitmap_alloc(chip->ngpio,
+							    GFP_KERNEL);
+		if (!gpio->fixed_direction_output) {
+			ret = -ENOMEM;
+			goto err_free_gpio;
+		}
+		bitmap_copy(gpio->fixed_direction_output,
+			    config->fixed_direction_output, chip->ngpio);
+	}
+
 	ret = gpiochip_add_data(chip, gpio);
 	if (ret < 0)
-		goto err_free_gpio;
+		goto err_free_bitmap;
 
 #ifdef CONFIG_REGMAP_IRQ
 	if (config->regmap_irq_chip) {
@@ -291,7 +310,7 @@ struct gpio_regmap *gpio_regmap_register
 						 config->regmap_irq_line, config->regmap_irq_flags,
 						 0, config->regmap_irq_chip, &gpio->irq_chip_data);
 		if (ret)
-			goto err_free_gpio;
+			goto err_free_bitmap;
 
 		irq_domain = regmap_irq_get_domain(gpio->irq_chip_data);
 	} else
@@ -308,6 +327,8 @@ struct gpio_regmap *gpio_regmap_register
 
 err_remove_gpiochip:
 	gpiochip_remove(chip);
+err_free_bitmap:
+	bitmap_free(gpio->fixed_direction_output);
 err_free_gpio:
 	kfree(gpio);
 	return ERR_PTR(ret);
@@ -326,6 +347,7 @@ void gpio_regmap_unregister(struct gpio_
 #endif
 
 	gpiochip_remove(&gpio->gpio_chip);
+	bitmap_free(gpio->fixed_direction_output);
 	kfree(gpio);
 }
 EXPORT_SYMBOL_GPL(gpio_regmap_unregister);
--- a/include/linux/gpio/regmap.h
+++ b/include/linux/gpio/regmap.h
@@ -37,6 +37,10 @@ struct regmap;
  *			offset to a register/bitmask pair. If not
  *			given the default gpio_regmap_simple_xlate()
  *			is used.
+ * @fixed_direction_output:
+ *			(Optional) Bitmap representing the fixed direction of
+ *			the GPIO lines. Useful when there are GPIO lines with a
+ *			fixed direction mixed together in the same register.
  * @drvdata:		(Optional) Pointer to driver specific data which is
  *			not used by gpio-remap but is provided "as is" to the
  *			driver callback(s).
@@ -82,6 +86,7 @@ struct gpio_regmap_config {
 	int reg_stride;
 	int ngpio_per_reg;
 	struct irq_domain *irq_domain;
+	unsigned long *fixed_direction_output;
 
 #ifdef CONFIG_REGMAP_IRQ
 	struct regmap_irq_chip *regmap_irq_chip;


