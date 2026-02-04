Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC2F421EFB;
	Wed,  4 Feb 2026 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218535; cv=none; b=pUR/goO1Nrg1KLVVQUgFsfQOm9ItCNYlP7sUSIh+iNI1g5k3vY6vhmORM8s3QsXZVyClkpD36EGMEysK+FBLIIeilqW3CPQB22g4mVDpmqltPAC89F8a/gHIzuzqUjBhbeg6O8qsU3obhEjqS31aMbt//P4a5nXcM1bcvLmRepk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218535; c=relaxed/simple;
	bh=4Qd9XWTPnhfXz4LNinZy70SKUiJwXABqZMlfbjNEewo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIg+8Zr92fQLNjVgkyqH14tvQ1thVWJJqxSWlvAkSlouHj9M7zg4ZgEML1V+7Sdbrio6K1i8N8n/8p00cqc/g0wJ+ycP2H5l/8ht/+4BPnX8zPHPsEuzdlaeAVfi5DqiTK9HqNtlZLQRnyvWGuKXgezjAZ+nVunTtzs6uOlRFLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoiNkBDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoiNkBDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43431C4CEF7;
	Wed,  4 Feb 2026 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218535;
	bh=4Qd9XWTPnhfXz4LNinZy70SKUiJwXABqZMlfbjNEewo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoiNkBDldcT75pFOkJtIzbF4wwjXnwI/yDO8zfQ2XzSnb6oh29OcaexR4UmUBcF2z
	 qV+1tC2QS6k+f+InBbDJ9qo7IV9gQQR+ofP7GIYLz6YwODZszkvH0nEwLnaS7n5cW6
	 AeCEZUld891oZLL0r85nFb6VB8g0m4Bg0u4IxF24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 42/72] gpio: rockchip: Stop calling pinctrl for set_direction
Date: Wed,  4 Feb 2026 15:40:45 +0100
Message-ID: <20260204143847.153630105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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
@@ -18,7 +18,6 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/pinconf-generic.h>
 #include <linux/platform_device.h>
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
@@ -2749,10 +2749,9 @@ static int rockchip_pmx_set(struct pinct
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
@@ -2766,7 +2765,7 @@ static const struct pinmux_ops rockchip_
 	.get_function_name	= rockchip_pmx_get_func_name,
 	.get_function_groups	= rockchip_pmx_get_groups,
 	.set_mux		= rockchip_pmx_set,
-	.gpio_set_direction	= rockchip_pmx_gpio_set_direction,
+	.gpio_request_enable	= rockchip_pmx_gpio_request_enable,
 };
 
 /*


