Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50E11C4EFB;
	Tue, 27 Aug 2024 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769951; cv=none; b=daMztNTqLxdSwTYJAlK2Pjl3UcsvY4XIAPkHogxkmZbQeqDqw6Ce7oma/vs6EnjXu5JUJVGvwJKxSkBA8NGNqJSnHjwbGeuLGXwi4voEkvyTBAiQ/3kb5t3tn+G55GyT/bSwOn+dYATJyJne7kqiCSHYeWt9qjYtHKqv2FQBghA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769951; c=relaxed/simple;
	bh=tjxwFVIq5zMf+JUpx5m3iqoPUm7path8TkQzNzKTHNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU4geEfEkq5EfOdMvqEjZw494u7dkHvwJjOgC2d0F15ijmEOl+wyAcK++vQm0/P46EYLJkgKjM0+rlVwmpkG1Sb1tF+1mB/4ErAdmvZ2+Qa975Wr0W0fcuND+zDa42HRz8J3ng40mXBqMYl6M5Wy1MXvY4KWHOroKlZf+1rnQeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VU623D3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VU623D3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCF0C61063;
	Tue, 27 Aug 2024 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769950;
	bh=tjxwFVIq5zMf+JUpx5m3iqoPUm7path8TkQzNzKTHNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VU623D3Rho6c0V8HVe9UxvqD29uSIxcZ6A9IM91FvV+bQb+49xT9/xrAln94heQ2S
	 txrQJhNAnfAci7QWHrat01kYkquYfqpsrTAxcg6cFmM5nXb94NoFB9/cX90UkLsOhr
	 7BH92Er8hpIjvKnLNUhfDvtjrsaaYeqReiXH6N4w=
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
Subject: [PATCH 6.6 081/341] gpio: mlxbf3: Support shutdown() function
Date: Tue, 27 Aug 2024 16:35:12 +0200
Message-ID: <20240827143846.492786196@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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



