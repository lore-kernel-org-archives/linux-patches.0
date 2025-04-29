Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F7125335F;
	Tue, 29 Apr 2025 17:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949296; cv=none; b=mhlyLkF99zeTYomg5ihyEnZJxCBy3KN3JA6QwnedcZc50UjHqm/BdqZkt5cflPmVjbj3Iafw0/ASsiIZb9Jfxt/Us1SRi+EN6+BpNbddm1KlEu7eCC/bqOK1Y5oM5tPcAKY/ZonsJTzRpyvrL7wsXc2qz4ty2I8BXBzKXTDm5q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949296; c=relaxed/simple;
	bh=Upe9tVPwks4hZKZIzzljHUw+/o+YEVaSCXx4ia6ZdXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaaq1vLk12fft8pwABVzQEKGrsa0FUUH0FxQZ4xrLCoBFrAc6BgEL10McIcHc1fVSAnnsewow/RGA8UucH8IQjz8h6OHD/D3I3hyG0q06LCm3yyy3uGQfHStIBHfOQa0lX1RJ7qALHrAds15d4y7dq1sv3u4GreJagQ15Esb734=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOD4wplz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOD4wplz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBB7C4CEE3;
	Tue, 29 Apr 2025 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949296;
	bh=Upe9tVPwks4hZKZIzzljHUw+/o+YEVaSCXx4ia6ZdXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOD4wplzkLfxzaGDWsFN2UTt82dMsuDtV8RQCyvPhx1NWL6E5AlHuQSZIYbccuv2r
	 MP7CZgQZP5L1kEwKviUyMhswbGUpuIJNLTaYYU83MyX0HpPzVnuLh3yPG052NIHH+i
	 Kw4IGRP96cJXLn7KnDxVap+NEXe9AHaaUkTWO+Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/373] gpio: tegra186: Force one interrupt per bank
Date: Tue, 29 Apr 2025 18:42:30 +0200
Message-ID: <20250429161134.358837825@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit ca038748068f454d20ad1bb120cbe36599f81db6 ]

Newer chips support up to 8 interrupts per bank, which can be useful to
balance the load and decrease latency. However, it also required a very
complicated interrupt routing to be set up. To keep things simple for
now, ensure that a single interrupt per bank is enforced, even if all
possible interrupts are described in device tree.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Stable-dep-of: 8323f3a69de6 ("gpio: tegra186: fix resource handling in ACPI probe path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tegra186.c | 68 ++++++++++++++++++++++++++++++++----
 1 file changed, 62 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-tegra186.c b/drivers/gpio/gpio-tegra186.c
index 00762de3d4096..52e08bc2f0530 100644
--- a/drivers/gpio/gpio-tegra186.c
+++ b/drivers/gpio/gpio-tegra186.c
@@ -81,6 +81,8 @@ struct tegra_gpio {
 	unsigned int *irq;
 
 	const struct tegra_gpio_soc *soc;
+	unsigned int num_irqs_per_bank;
+	unsigned int num_banks;
 
 	void __iomem *secure;
 	void __iomem *base;
@@ -600,6 +602,28 @@ static void tegra186_gpio_init_route_mapping(struct tegra_gpio *gpio)
 	}
 }
 
+static unsigned int tegra186_gpio_irqs_per_bank(struct tegra_gpio *gpio)
+{
+	struct device *dev = gpio->gpio.parent;
+
+	if (gpio->num_irq > gpio->num_banks) {
+		if (gpio->num_irq % gpio->num_banks != 0)
+			goto error;
+	}
+
+	if (gpio->num_irq < gpio->num_banks)
+		goto error;
+
+	gpio->num_irqs_per_bank = gpio->num_irq / gpio->num_banks;
+
+	return 0;
+
+error:
+	dev_err(dev, "invalid number of interrupts (%u) for %u banks\n",
+		gpio->num_irq, gpio->num_banks);
+	return -EINVAL;
+}
+
 static int tegra186_gpio_probe(struct platform_device *pdev)
 {
 	unsigned int i, j, offset;
@@ -614,7 +638,17 @@ static int tegra186_gpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	gpio->soc = device_get_match_data(&pdev->dev);
+	gpio->gpio.label = gpio->soc->name;
+	gpio->gpio.parent = &pdev->dev;
+
+	/* count the number of banks in the controller */
+	for (i = 0; i < gpio->soc->num_ports; i++)
+		if (gpio->soc->ports[i].bank > gpio->num_banks)
+			gpio->num_banks = gpio->soc->ports[i].bank;
+
+	gpio->num_banks++;
 
+	/* get register apertures */
 	gpio->secure = devm_platform_ioremap_resource_byname(pdev, "security");
 	if (IS_ERR(gpio->secure)) {
 		gpio->secure = devm_platform_ioremap_resource(pdev, 0);
@@ -635,6 +669,10 @@ static int tegra186_gpio_probe(struct platform_device *pdev)
 
 	gpio->num_irq = err;
 
+	err = tegra186_gpio_irqs_per_bank(gpio);
+	if (err < 0)
+		return err;
+
 	gpio->irq = devm_kcalloc(&pdev->dev, gpio->num_irq, sizeof(*gpio->irq),
 				 GFP_KERNEL);
 	if (!gpio->irq)
@@ -648,9 +686,6 @@ static int tegra186_gpio_probe(struct platform_device *pdev)
 		gpio->irq[i] = err;
 	}
 
-	gpio->gpio.label = gpio->soc->name;
-	gpio->gpio.parent = &pdev->dev;
-
 	gpio->gpio.request = gpiochip_generic_request;
 	gpio->gpio.free = gpiochip_generic_free;
 	gpio->gpio.get_direction = tegra186_gpio_get_direction;
@@ -714,7 +749,30 @@ static int tegra186_gpio_probe(struct platform_device *pdev)
 	irq->parent_handler = tegra186_gpio_irq;
 	irq->parent_handler_data = gpio;
 	irq->num_parents = gpio->num_irq;
-	irq->parents = gpio->irq;
+
+	/*
+	 * To simplify things, use a single interrupt per bank for now. Some
+	 * chips support up to 8 interrupts per bank, which can be useful to
+	 * distribute the load and decrease the processing latency for GPIOs
+	 * but it also requires a more complicated interrupt routing than we
+	 * currently program.
+	 */
+	if (gpio->num_irqs_per_bank > 1) {
+		irq->parents = devm_kcalloc(&pdev->dev, gpio->num_banks,
+					    sizeof(*irq->parents), GFP_KERNEL);
+		if (!irq->parents)
+			return -ENOMEM;
+
+		for (i = 0; i < gpio->num_banks; i++)
+			irq->parents[i] = gpio->irq[i * gpio->num_irqs_per_bank];
+
+		irq->num_parents = gpio->num_banks;
+	} else {
+		irq->num_parents = gpio->num_irq;
+		irq->parents = gpio->irq;
+	}
+
+	tegra186_gpio_init_route_mapping(gpio);
 
 	np = of_find_matching_node(NULL, tegra186_pmc_of_match);
 	if (np) {
@@ -725,8 +783,6 @@ static int tegra186_gpio_probe(struct platform_device *pdev)
 			return -EPROBE_DEFER;
 	}
 
-	tegra186_gpio_init_route_mapping(gpio);
-
 	irq->map = devm_kcalloc(&pdev->dev, gpio->gpio.ngpio,
 				sizeof(*irq->map), GFP_KERNEL);
 	if (!irq->map)
-- 
2.39.5



