Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8EB1FB40
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D41C433C9;
	Fri, 21 Jul 2023 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956059;
	bh=TEX6HUfV86tTPLtWaO610ZY6mQiUHIezW58BwXc8wcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnLGFcxVwRdUDA6JF/pZVujK4yU7++HXObOcwn2HkBz/m5AJUj7cJWZzzwrmWKER6
	 dmBfLAHGrwrv4hzYjxgeoS3PG37OGgVjq4CUMi+2vIqma2dN9gi7rUnTGBpOderLoo
	 +MDCzrJOSh5y8mA1LG2SQFqku/uCGZ8etZhZBijQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.4 118/292] pinctrl: amd: Revert "pinctrl: amd: disable and mask interrupts on probe"
Date: Fri, 21 Jul 2023 18:03:47 +0200
Message-ID: <20230721160533.900043738@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 65f6c7c91cb2ebacbf155e0f881f81e79f90d138 upstream.

commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on probe")
was well intentioned to mask a firmware issue on a surface laptop, but it
has a few problems:
1. It had a bug in the loop handling for iteration 63 that lead to other
   problems with GPIO0 handling.
2. It disables interrupts that are used internally by the SOC but masked
   by default.
3. It masked a real firmware problem in some chromebooks that should have
   been caught during development but wasn't.

There has been a lot of other development around s2idle; particularly
around handling of the spurious wakeups.  If there is still a problem on
the original reported surface laptop it should be avoided by adding a quirk
to gpiolib-acpi for that system instead.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230421120625.3366-5-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -877,34 +877,6 @@ static const struct pinconf_ops amd_pinc
 	.pin_config_group_set = amd_pinconf_group_set,
 };
 
-static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
-{
-	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
-	unsigned long flags;
-	u32 pin_reg, mask;
-	int i;
-
-	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
-		BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
-		BIT(WAKE_CNTRL_OFF_S4);
-
-	for (i = 0; i < desc->npins; i++) {
-		int pin = desc->pins[i].number;
-		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
-
-		if (!pd)
-			continue;
-
-		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
-
-		pin_reg = readl(gpio_dev->base + pin * 4);
-		pin_reg &= ~mask;
-		writel(pin_reg, gpio_dev->base + pin * 4);
-
-		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-	}
-}
-
 #ifdef CONFIG_PM_SLEEP
 static bool amd_gpio_should_save(struct amd_gpio *gpio_dev, unsigned int pin)
 {
@@ -1142,9 +1114,6 @@ static int amd_gpio_probe(struct platfor
 		return PTR_ERR(gpio_dev->pctrl);
 	}
 
-	/* Disable and mask interrupts */
-	amd_gpio_irq_init(gpio_dev);
-
 	girq = &gpio_dev->gc.irq;
 	gpio_irq_chip_set_chip(girq, &amd_gpio_irqchip);
 	/* This will let us handle the parent IRQ in the driver */


