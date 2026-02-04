Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E72F2BE7C0;
	Wed,  4 Feb 2026 15:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219195; cv=none; b=Cs7OuRbHsoTm2jkRYhSuiZqP/3IVQrL1D/0H2Vm+34NrFgtfFvROxImYRArpUMSKG/dy3735FaCPugEjNqPRcMzb8IECg6edZmJOsKQ73egdoOFR4DFSbfisx2g0q7NZimQwcTxrEe+ygjNt3tNpyF5FxVJysAx/WleNuR//rAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219195; c=relaxed/simple;
	bh=Kot8Y0JpYrn5doUgO5WreQNJnN5CM7Mn+gmYooUaL+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArhhpAadIkFHX70L5P6wfLQOGwr/3bNw4/FWkhcj51jMmp5enM/EUE/NyHUw2bm38BL0+EpY6QLY74QwA5bpXVl8RmuAkty+ArjJJdKo2OTmzFO7m5IbuNQe2BpQYVi26l3+lWAVWuwLUDw9uwcd/eFzxezjbge0707HMhYvP0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxZ+BF3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxZ+BF3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4A6C4CEF7;
	Wed,  4 Feb 2026 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219195;
	bh=Kot8Y0JpYrn5doUgO5WreQNJnN5CM7Mn+gmYooUaL+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxZ+BF3zoY2c8KGOOwBaIfuPwcYsNKK1edMMGd03oLR8h99lwhqRkX6Ji/P4Rjhea
	 EduadnLaziRqr+ppmihRau58UDYUwB/El6axTJ09TFrWC+nRmBfuRQTGgDht6HVz3q
	 u3l489KWCb3WlmtweN3xK7Em9OO+Q3BrahASZ2Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 061/122] pinctrl: meson: mark the GPIO controller as sleeping
Date: Wed,  4 Feb 2026 15:40:43 +0100
Message-ID: <20260204143854.051521838@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 28f24068387169722b508bba6b5257cb68b86e74 upstream.

The GPIO controller is configured as non-sleeping but it uses generic
pinctrl helpers which use a mutex for synchronization.

This can cause the following lockdep splat with shared GPIOs enabled on
boards which have multiple devices using the same GPIO:

BUG: sleeping function called from invalid context at
kernel/locking/mutex.c:591
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 142, name:
kworker/u25:3
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
irq event stamp: 46379
hardirqs last  enabled at (46379): [<ffff8000813acb24>]
_raw_spin_unlock_irqrestore+0x74/0x78
hardirqs last disabled at (46378): [<ffff8000813abf38>]
_raw_spin_lock_irqsave+0x84/0x88
softirqs last  enabled at (46330): [<ffff8000800c71b4>]
handle_softirqs+0x4c4/0x4dc
softirqs last disabled at (46295): [<ffff800080010674>]
__do_softirq+0x14/0x20
CPU: 1 UID: 0 PID: 142 Comm: kworker/u25:3 Tainted: G C
6.19.0-rc4-next-20260105+ #11963 PREEMPT
Tainted: [C]=CRAP
Hardware name: Khadas VIM3 (DT)
Workqueue: events_unbound deferred_probe_work_func
Call trace:
  show_stack+0x18/0x24 (C)
  dump_stack_lvl+0x90/0xd0
  dump_stack+0x18/0x24
  __might_resched+0x144/0x248
  __might_sleep+0x48/0x98
  __mutex_lock+0x5c/0x894
  mutex_lock_nested+0x24/0x30
  pinctrl_get_device_gpio_range+0x44/0x128
  pinctrl_gpio_set_config+0x40/0xdc
  gpiochip_generic_config+0x28/0x3c
  gpio_do_set_config+0xa8/0x194
  gpiod_set_config+0x34/0xfc
  gpio_shared_proxy_set_config+0x6c/0xfc [gpio_shared_proxy]
  gpio_do_set_config+0xa8/0x194
  gpiod_set_transitory+0x4c/0xf0
  gpiod_configure_flags+0xa4/0x480
  gpiod_find_and_request+0x1a0/0x574
  gpiod_get_index+0x58/0x84
  devm_gpiod_get_index+0x20/0xb4
  devm_gpiod_get+0x18/0x24
  mmc_pwrseq_emmc_probe+0x40/0xb8
  platform_probe+0x5c/0xac
  really_probe+0xbc/0x298
  __driver_probe_device+0x78/0x12c
  driver_probe_device+0xdc/0x164
  __device_attach_driver+0xb8/0x138
  bus_for_each_drv+0x80/0xdc
  __device_attach+0xa8/0x1b0

Fixes: 6ac730951104 ("pinctrl: add driver for Amlogic Meson SoCs")
Cc: stable@vger.kernel.org
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/all/00107523-7737-4b92-a785-14ce4e93b8cb@samsung.com/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/meson/pinctrl-meson.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/meson/pinctrl-meson.c
+++ b/drivers/pinctrl/meson/pinctrl-meson.c
@@ -619,7 +619,7 @@ static int meson_gpiolib_register(struct
 	pc->chip.set = meson_gpio_set;
 	pc->chip.base = -1;
 	pc->chip.ngpio = pc->data->num_pins;
-	pc->chip.can_sleep = false;
+	pc->chip.can_sleep = true;
 
 	ret = gpiochip_add_data(&pc->chip, pc);
 	if (ret) {


