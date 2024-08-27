Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E641F1E520;
	Tue, 27 Aug 2024 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771218; cv=none; b=nhZ54Mq0PHTelxb6km9AHyKnUexlIkqrPpcZhXVAcFkn+eg08M0//zxfF260dxq+TS0puqYh5TVuFKbV+rzYfRg6Hp9IPnrMB/fxM4yJkJhVvdPfbDhTAU6Fh+iOkPbQ0NrL+GDMNmGzQ3qRVuWXVOZlzk1XPdfQ/kZSEX8TFDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771218; c=relaxed/simple;
	bh=07WZJ9mM0bs2qEmtSTHFWam8KCgTR73mlTaYSekXpXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVwZHmlR2ZyF2IWlAE+D9+73TJDwRn3c+2H0THcI6NLzTeX260nTd4KxDuLxLnv24JlW43dTsC+aJFzTifAIX+VDaclSBThTJvm5btrpHuLZANBws3s50ckJpcUHs7vtJxcL9I8l0l14KUCByHm6G6XaGQRomx9aC/pCpKSgDtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leMaR/fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leMaR/fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C20C4AF55;
	Tue, 27 Aug 2024 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771217;
	bh=07WZJ9mM0bs2qEmtSTHFWam8KCgTR73mlTaYSekXpXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leMaR/fl3ymws4gdTKds7U9DB6KVIMjdd3PaxCP8uh32YetvEAUyUfmJsufmX8ztx
	 VK7139wDf6eGtmjp2uBzQyW1NjjToz7c6mXu4HmcHxnT3tMqzmsMBCSMkBjyWY7we2
	 vcBcgUBQ2U/roTp6wycO+hfidDYRVQR8gluttWdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Andy Shevchenko <andy@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 122/273] gpio: mlxbf3: Support shutdown() function
Date: Tue, 27 Aug 2024 16:37:26 +0200
Message-ID: <20240827143838.050251028@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit aad41832326723627ad8ac9ee8a543b6dca4454d ]

During Linux graceful reboot, the GPIO interrupts are not disabled.
Since the drivers are not removed during graceful reboot,
the logic to call mlxbf3_gpio_irq_disable() is not triggered.
Interrupts that remain enabled can cause issues on subsequent boots.

For example, the mlxbf-gige driver contains PHY logic to bring up the link.
If the gpio-mlxbf3 driver loads first, the mlxbf-gige driver
will use a GPIO interrupt to bring up the link.
Otherwise, it will use polling.
The next time Linux boots and loads the drivers in this order, we encounter the issue:
- mlxbf-gige loads first and uses polling while the GPIO10
  interrupt is still enabled from the previous boot. So if
  the interrupt triggers, there is nothing to clear it.
- gpio-mlxbf3 loads.
- i2c-mlxbf loads. The interrupt doesn't trigger for I2C
  because it is shared with the GPIO interrupt line which
  was not cleared.

The solution is to add a shutdown function to the GPIO driver to clear and disable
all interrupts. Also clear the interrupt after disabling it in mlxbf3_gpio_irq_disable().

Fixes: 38a700efc510 ("gpio: mlxbf3: Add gpio driver support")
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240611171509.22151-1-asmaa@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mlxbf3.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpio/gpio-mlxbf3.c b/drivers/gpio/gpio-mlxbf3.c
index d5906d419b0ab..10ea71273c891 100644
--- a/drivers/gpio/gpio-mlxbf3.c
+++ b/drivers/gpio/gpio-mlxbf3.c
@@ -39,6 +39,8 @@
 #define MLXBF_GPIO_CAUSE_OR_EVTEN0        0x14
 #define MLXBF_GPIO_CAUSE_OR_CLRCAUSE      0x18
 
+#define MLXBF_GPIO_CLR_ALL_INTS           GENMASK(31, 0)
+
 struct mlxbf3_gpio_context {
 	struct gpio_chip gc;
 
@@ -82,6 +84,8 @@ static void mlxbf3_gpio_irq_disable(struct irq_data *irqd)
 	val = readl(gs->gpio_cause_io + MLXBF_GPIO_CAUSE_OR_EVTEN0);
 	val &= ~BIT(offset);
 	writel(val, gs->gpio_cause_io + MLXBF_GPIO_CAUSE_OR_EVTEN0);
+
+	writel(BIT(offset), gs->gpio_cause_io + MLXBF_GPIO_CAUSE_OR_CLRCAUSE);
 	raw_spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags);
 
 	gpiochip_disable_irq(gc, offset);
@@ -253,6 +257,15 @@ static int mlxbf3_gpio_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static void mlxbf3_gpio_shutdown(struct platform_device *pdev)
+{
+	struct mlxbf3_gpio_context *gs = platform_get_drvdata(pdev);
+
+	/* Disable and clear all interrupts */
+	writel(0, gs->gpio_cause_io + MLXBF_GPIO_CAUSE_OR_EVTEN0);
+	writel(MLXBF_GPIO_CLR_ALL_INTS, gs->gpio_cause_io + MLXBF_GPIO_CAUSE_OR_CLRCAUSE);
+}
+
 static const struct acpi_device_id mlxbf3_gpio_acpi_match[] = {
 	{ "MLNXBF33", 0 },
 	{}
@@ -265,6 +278,7 @@ static struct platform_driver mlxbf3_gpio_driver = {
 		.acpi_match_table = mlxbf3_gpio_acpi_match,
 	},
 	.probe    = mlxbf3_gpio_probe,
+	.shutdown = mlxbf3_gpio_shutdown,
 };
 module_platform_driver(mlxbf3_gpio_driver);
 
-- 
2.43.0



