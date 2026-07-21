Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886CE44AB91;
	Tue, 21 Jul 2026 21:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669737; cv=none; b=NnwIAt5pLmITKtejB55KuIzV/w4O2j0byXmvV4e3ma7YTSmn9VFxzqieL1CCx2tQvL1UO4zwA1O7FJHcTGI//kf2lr9bHencrQ6O+55OPwfk9PDsFWp+nleSzOCevQg1rw+8thhru460HyQ+CpshoQwOGsZNxpJbQYzr5aD/xUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669737; c=relaxed/simple;
	bh=hl61Q6tY08VGxhSDbEDifQFlFQ2Dn8TMa3/lSwxK9bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNxtgPqtv1wKijyUQYeWA/KoKk6GS8v+MqXobugxwezO5WMztcBAvy7NiaUqimXNuKnO9cq0uD+lnc70hcB/Lm45bcowg/VbFkIKBmTdq3bJrL28rDxwJ5fnhZFVd4rCPFE8dhPvpq5ZdUMSAzo+hfyDYKtqfNWGnGOTLJ2Y3FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0yEreWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0yEreWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CCD1F000E9;
	Tue, 21 Jul 2026 21:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669735;
	bh=oc3vEdLs7uE2BP11yvZc7N31oomCDjHH2a+vtQgB2GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0yEreWLilsuOQH4UVNpg9Z5YWevxfkYaUYLIEciLiRqQZ1wjrDhsbz3aRksvGmai
	 k3vG6b2L17TSuEh7eOHUvPKpti4BTXV3hf6WLUSyQ6gURLPv+UwW6SMvmwB87qbsOK
	 65jhYsf5uKISPyO+Lr85aMo+miUADW/hTGpvJ6TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Bocharov <v@baodeep.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0668/1067] pinctrl: meson: restore non-sleeping GPIO access
Date: Tue, 21 Jul 2026 17:21:09 +0200
Message-ID: <20260721152439.539617969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Viacheslav Bocharov <v@baodeep.com>

[ Upstream commit 9777530157e7b82fd994327ff878c4245dadc931 ]

Commit 28f240683871 ("pinctrl: meson: mark the GPIO controller as
sleeping") set gpio_chip.can_sleep = true to work around
gpio-shared-proxy holding a spinlock across a sleeping pinctrl config
path. That locking bug is now fixed in the shared-proxy itself ("gpio:
shared-proxy: always serialize with a sleeping mutex"), so the
controller-wide workaround is no longer needed; the meson GPIO
controller does not sleep.

meson_gpio_get/set/direction_* access MMIO through regmap. The
regmap_mmio bus uses fast I/O (spinlock) locking, so these value
callbacks do not contain sleeping operations. Since gpio_chip.can_sleep
describes the get/set value path, restore can_sleep = false.

Marking the controller sleeping also broke atomic value consumers such
as w1-gpio (1-Wire bitbang): w1_io.c runs its read time slot under
local_irq_save() and uses the non-cansleep gpiod_set_value() /
gpiod_get_value(), which with can_sleep=true trigger WARN_ON(can_sleep)
in gpiolib on every transferred bit (from w1_gpio_write_bit() /
w1_gpio_read_bit() via w1_reset_bus() and w1_search()). The printk and
stack dump inside the IRQs-off, microsecond-scale time slot destroy the
bit timing, so reset/presence detection and ROM search fail: the bus
master registers but w1_master_slave_count stays at 0 and no devices
are found. Verified on an Amlogic A113X board (DS18B20 on GPIOA_14):
with can_sleep restored to false the warnings are gone and the sensor
is detected and read again.

This must not be applied or backported without the shared-proxy locking
fix above; otherwise the original Khadas VIM3 splat returns on boards
that genuinely share a meson GPIO.

Fixes: 28f240683871 ("pinctrl: meson: mark the GPIO controller as sleeping")
Link: https://lore.kernel.org/all/20260105150509.56537-1-bartosz.golaszewski@oss.qualcomm.com/
Signed-off-by: Viacheslav Bocharov <v@baodeep.com>
Acked-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260625115718.1678991-3-v@baodeep.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson.c b/drivers/pinctrl/meson/pinctrl-meson.c
index 1555d26df6cdbb..1f05f7f1a9aee2 100644
--- a/drivers/pinctrl/meson/pinctrl-meson.c
+++ b/drivers/pinctrl/meson/pinctrl-meson.c
@@ -619,7 +619,7 @@ static int meson_gpiolib_register(struct meson_pinctrl *pc)
 	pc->chip.set = meson_gpio_set;
 	pc->chip.base = -1;
 	pc->chip.ngpio = pc->data->num_pins;
-	pc->chip.can_sleep = true;
+	pc->chip.can_sleep = false;
 
 	ret = gpiochip_add_data(&pc->chip, pc);
 	if (ret) {
-- 
2.53.0



