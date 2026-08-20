Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D385272E53;
	Thu, 20 Aug 2026 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243608; cv=none; b=hL6G3kTZPWvahrA0APmvI6JE7B80YVnH0tuo2w6C11XDmxu0sTaXLSfVOIR88aSiDDTAqqbchkIGJjIDL1oak8OZrq9NnuO7+QGgF5CIUNmAjtsOLVxpK5cYubho/F9C9n2G+t6yfD4VKRtvRDRa4tThb9ZRXzkd3HBwZurYAr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243608; c=relaxed/simple;
	bh=mRT70x+OO+HF2Qx+SjxSYjVMC+jyC1S2WhO2wHiv7mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0/Er7qx+wCpDH4s9cM3Er8NcgbSjI7XyDc2eO0eXUcax95aSt6k445B+Ju73EKvOAFzZrwpBqIjZz/JyNRs9yg00jOr+xroAsgfQh/U5BMapgNQnRSD+R7cFl7zPnWxSQ5VykgwaWe4hjBltoPwwQGM3p+nPWZA1FKVM3tsMx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYXInGxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYXInGxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E923C1F000E9;
	Thu, 20 Aug 2026 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243607;
	bh=FPVckJ8X7Ea13pQMcGa7lZteFLybNgZ1Al/gNofq/6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYXInGxZtrcc4fq6sUPG+iD6gxzAE1+/m1mtP2abyeGwBaUFrOQ/bNs+zWPurISCe
	 KMYRFDU0ImgTXLzWMa4zntqpEiJR5m2BimysGPZ0HGB+7pas0fNVzw2mGuDa9350/T
	 +jYYf77dqOh0aVgiVFTiMpYo80vPqlLy7nL0rTeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/272] gpio: tegra: do not call pinctrl for GPIO direction
Date: Thu, 20 Aug 2026 16:55:36 +0200
Message-ID: <20260820145235.873039504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit d3e91a95b2b0fc6336dbf3ec90d831a1654d2720 ]

tegra_gpio_direction_input() and tegra_gpio_direction_output() already
program the GPIO controller direction registers directly. The additional
pinctrl_gpio_direction_input/output() calls do not add a Tegra pinctrl
operation, because the Tegra pinmux ops provide GPIO request/free
handling but no gpio_set_direction hook.

The extra call still enters the pinctrl core and takes pctldev->mutex.
Shared GPIO users can call the direction path while holding their
per-line spinlock, so this otherwise redundant pinctrl direction call can
sleep in an atomic context.

This was found by our static analysis tool and then confirmed by manual
review of tegra_gpio_probe(), the Tegra GPIO direction callbacks and the
Tegra pinctrl ops. The reviewed path has a default non-sleeping
struct gpio_chip while the direction callback still enters the pinctrl
mutex path.

A directed runtime validation kept the same non-sleeping chip registration
and drove:

  gpio_shared_proxy_direction_output()
  gpiod_direction_output_raw_commit()
  tegra_gpio_direction_output()
  pinctrl_gpio_direction_output()

Lockdep reported a sleep-in-atomic warning with the shared GPIO spinlock
held and pinctrl_get_device_gpio_range() plus tegra_gpio_direction_output()
on the stack.

Do not mark the whole chip as can_sleep to paper over this: can_sleep
describes whether get()/set() may sleep, and Tegra value access is MMIO.
Remove the redundant pinctrl direction calls and keep pinctrl involvement
in the existing request/free path.

Fixes: 11da90541283 ("gpio: tegra: Fix offset of pinctrl calls")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260619152439.1239561-1-runyu.xiao@seu.edu.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tegra.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -174,18 +174,11 @@ static int tegra_gpio_direction_input(st
 				      unsigned int offset)
 {
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
-	int ret;
 
 	tegra_gpio_mask_write(tgi, GPIO_MSK_OE(tgi, offset), offset, 0);
 	tegra_gpio_enable(tgi, offset);
 
-	ret = pinctrl_gpio_direction_input(chip, offset);
-	if (ret < 0)
-		dev_err(tgi->dev,
-			"Failed to set pinctrl input direction of GPIO %d: %d",
-			 chip->base + offset, ret);
-
-	return ret;
+	return 0;
 }
 
 static int tegra_gpio_direction_output(struct gpio_chip *chip,
@@ -193,19 +186,12 @@ static int tegra_gpio_direction_output(s
 				       int value)
 {
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
-	int ret;
 
 	tegra_gpio_set(chip, offset, value);
 	tegra_gpio_mask_write(tgi, GPIO_MSK_OE(tgi, offset), offset, 1);
 	tegra_gpio_enable(tgi, offset);
 
-	ret = pinctrl_gpio_direction_output(chip, offset);
-	if (ret < 0)
-		dev_err(tgi->dev,
-			"Failed to set pinctrl output direction of GPIO %d: %d",
-			 chip->base + offset, ret);
-
-	return ret;
+	return 0;
 }
 
 static int tegra_gpio_get_direction(struct gpio_chip *chip,


