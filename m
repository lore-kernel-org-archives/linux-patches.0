Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E10E1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BE9C433C7;
	Fri, 21 Jul 2023 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956070;
	bh=Mvnek+0FLfL3cFQ/FgFjQoGSPyXpzhR70K/Umjwcl4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odU1kECi4bV6aKLIgblX+NQTAxBP1SYQrRQqrkSAzKuJbcLKh+qbbAqkC8fFIoN0D
	 NuNjofBvG7Kk52GCEvaaZZsyMUGSlWYgxE/IubYcwzai7GPMRtaTUUEROxJmVqWHG8
	 R5h7C52vZFwZBMgwJBJmn3uzQL+Ipl5l3cTrnGtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Visser <starquake@linuxeverywhere.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.4 122/292] pinctrl: amd: Unify debounce handling into amd_pinconf_set()
Date: Fri, 21 Jul 2023 18:03:51 +0200
Message-ID: <20230721160534.065871574@linuxfoundation.org>
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

commit 283c5ce7da0a676f46539094d40067ad17c4f294 upstream.

Debounce handling is done in two different entry points in the driver.
Unify this to make sure that it's always handled the same.

Tested-by: Jan Visser <starquake@linuxeverywhere.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230705133005.577-5-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -115,16 +115,12 @@ static void amd_gpio_set_value(struct gp
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 }
 
-static int amd_gpio_set_debounce(struct gpio_chip *gc, unsigned offset,
-		unsigned debounce)
+static int amd_gpio_set_debounce(struct amd_gpio *gpio_dev, unsigned int offset,
+				 unsigned int debounce)
 {
 	u32 time;
 	u32 pin_reg;
 	int ret = 0;
-	unsigned long flags;
-	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
-
-	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 
 	/* Use special handling for Pin0 debounce */
 	if (offset == 0) {
@@ -183,7 +179,6 @@ static int amd_gpio_set_debounce(struct
 		pin_reg &= ~(DB_CNTRl_MASK << DB_CNTRL_OFF);
 	}
 	writel(pin_reg, gpio_dev->base + offset * 4);
-	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 
 	return ret;
 }
@@ -782,9 +777,8 @@ static int amd_pinconf_set(struct pinctr
 
 		switch (param) {
 		case PIN_CONFIG_INPUT_DEBOUNCE:
-			pin_reg &= ~DB_TMR_OUT_MASK;
-			pin_reg |= arg & DB_TMR_OUT_MASK;
-			break;
+			ret = amd_gpio_set_debounce(gpio_dev, pin, arg);
+			goto out_unlock;
 
 		case PIN_CONFIG_BIAS_PULL_DOWN:
 			pin_reg &= ~BIT(PULL_DOWN_ENABLE_OFF);
@@ -811,6 +805,7 @@ static int amd_pinconf_set(struct pinctr
 
 		writel(pin_reg, gpio_dev->base + pin*4);
 	}
+out_unlock:
 	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 
 	return ret;
@@ -857,12 +852,6 @@ static int amd_gpio_set_config(struct gp
 {
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
 
-	if (pinconf_to_config_param(config) == PIN_CONFIG_INPUT_DEBOUNCE) {
-		u32 debounce = pinconf_to_config_argument(config);
-
-		return amd_gpio_set_debounce(gc, pin, debounce);
-	}
-
 	return amd_pinconf_set(gpio_dev->pctrl, pin, &config, 1);
 }
 


