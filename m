Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EA4413249;
	Wed,  4 Feb 2026 15:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218125; cv=none; b=GjVxCaxGonraA0v6kso/TWxjT/r9DKpaZyQ4prgCQQbx6TKpJ4lioCgCHOShySbT9ppyjJOASBIP0Uk8EfE7DKls1H9GVq/EKHrGGS/IF1JBYGooQYFUaGnG7gi4dekvTCYkKIlfK9y2HWnt9Yx5dJ81sGRFG5F/uWJKP9czFxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218125; c=relaxed/simple;
	bh=k4KmYauBPxdzD8lr9oiLJmZhgVGj0mjbSaF92AIpbp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVZjabb29T0iLRFmkvlIhLr0mTorSBbfaWLREpKG85L7NZ8ibRSQvSQkNlMHYBEWLkFqvF6n4PVj5EziqWU+mh6SSKbRe0PVJcRJxrvL7z3M2Vl5XYCuEJtH2dSHUTn/OpUumGjSYQy30YVXpJFT+3ZOQCbi8Ziub2VIfKWqe8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wXcW+Jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wXcW+Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C94FC4CEF7;
	Wed,  4 Feb 2026 15:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218125;
	bh=k4KmYauBPxdzD8lr9oiLJmZhgVGj0mjbSaF92AIpbp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wXcW+JzKAcG7or7OBew+fyuZ04tLJONvdwrMSM31rPPEjGbG3B1DmY+8L59zb9HM
	 fJAjCfwX/xhOzw4DDl8sEEAW/+eGcN9nOkAskWfGeUTm6y1U8vdi0j7mu9g/eEvafw
	 rAQlI3GLi8l6OylSYeKdJreTk/n5rBZpfsaE+8o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 219/280] gpio: rockchip: Stop calling pinctrl for set_direction
Date: Wed,  4 Feb 2026 15:39:53 +0100
Message-ID: <20260204143917.487486356@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 7ca497be00163610afb663867db24ac408752f13 upstream.

Marking the whole controller as sleeping due to the pinctrl calls in the
.direction_{input,output} callbacks has the unfortunate side effect that
legitimate invocations of .get and .set, which cannot themselves sleep,
in atomic context now spew WARN()s from gpiolib.

However, as Heiko points out, the driver doing this is a bit silly to
begin with, as the pinctrl .gpio_set_direction hook doesn't even care
about the direction, the hook is only used to claim the mux. And sure
enough, the .gpio_request_enable hook exists to serve this very purpose,
so switch to that and remove the problematic business entirely.

Cc: stable@vger.kernel.org
Fixes: 20cf2aed89ac ("gpio: rockchip: mark the GPIO controller as sleeping")
Suggested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/bddc0469f25843ca5ae0cf578ab3671435ae98a7.1769429546.git.robin.murphy@arm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
[ Backport past pinctrl API change for the deleted calls ]
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-rockchip.c       |    8 --------
 drivers/pinctrl/pinctrl-rockchip.c |    9 ++++-----
 2 files changed, 4 insertions(+), 13 deletions(-)

--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -19,7 +19,6 @@
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/pinconf-generic.h>
 #include <linux/regmap.h>
 
@@ -157,12 +156,6 @@ static int rockchip_gpio_set_direction(s
 	unsigned long flags;
 	u32 data = input ? 0 : 1;
 
-
-	if (input)
-		pinctrl_gpio_direction_input(bank->pin_base + offset);
-	else
-		pinctrl_gpio_direction_output(bank->pin_base + offset);
-
 	raw_spin_lock_irqsave(&bank->slock, flags);
 	rockchip_gpio_writel_bit(bank, offset, data, bank->gpio_regs->port_ddr);
 	raw_spin_unlock_irqrestore(&bank->slock, flags);
@@ -584,7 +577,6 @@ static int rockchip_gpiolib_register(str
 	gc->ngpio = bank->nr_pins;
 	gc->label = bank->name;
 	gc->parent = bank->dev;
-	gc->can_sleep = true;
 
 	ret = gpiochip_add_data(gc, bank);
 	if (ret) {
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2750,10 +2750,9 @@ static int rockchip_pmx_set(struct pinct
 	return 0;
 }
 
-static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
-					   struct pinctrl_gpio_range *range,
-					   unsigned offset,
-					   bool input)
+static int rockchip_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
+					    struct pinctrl_gpio_range *range,
+					    unsigned int offset)
 {
 	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	struct rockchip_pin_bank *bank;
@@ -2767,7 +2766,7 @@ static const struct pinmux_ops rockchip_
 	.get_function_name	= rockchip_pmx_get_func_name,
 	.get_function_groups	= rockchip_pmx_get_groups,
 	.set_mux		= rockchip_pmx_set,
-	.gpio_set_direction	= rockchip_pmx_gpio_set_direction,
+	.gpio_request_enable	= rockchip_pmx_gpio_request_enable,
 };
 
 /*


