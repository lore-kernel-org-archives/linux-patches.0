Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDBA265606;
	Tue, 21 Jul 2026 19:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663180; cv=none; b=f8xZJ6ydV+Wu19EELOM3gBWfpY7f+D7NNZEJiHE4sLbRagKUn9HQuLClitrWIP7Zo9XRSQ19NDVtXT8NHULTf4jkfLcQbv/qFSE7K9DOFZ+SnsUGcYbv1mbNjMHkLzibLzK3BGWnPQHL0Nsf/hoXcD8+BdMwcgweBy5H9i8S814=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663180; c=relaxed/simple;
	bh=FiDn2Za5Lt3/Z4deF6LJnuqTxDofJThXKoLSvmebn8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7sCssu4rHuJw8bX1jDeE4cnwQw5Xr1P6FjnMXghsIpZTHVzzzj9A2y8IAvIqQ2RSOvYIgfGm3SnLwm/oegFcv6vo/0wj8IYL7xiGkeOvBBINNB84himFelmj0P6OhQcK3IwtWjRlK/X8nqVy3yTX8FO3RPcqYguT+UU4v9jghA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha5W7yA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha5W7yA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F021F000E9;
	Tue, 21 Jul 2026 19:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663178;
	bh=KKiKiZ8id7uywJHqs/CRkk/B3HQDzjrYdxs8TNi6SAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ha5W7yA61E3f4uIR+nRq9XDK0q2IO/i4q6WJkJ21IKQPXW36goprF9DfjWD9XCYe/
	 86dKptDDEcBhJxmbY8TFX7HXURDNlgstUW+gUmwVT0+1QfMM6sbclWSXnDfJRfZ/z9
	 mRDmgV5kBWfUBC2PJBXPUFgSE2A6hyHh/e/v+A+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Bocharov <v@baodeep.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0724/1276] pinctrl: meson: restore non-sleeping GPIO access
Date: Tue, 21 Jul 2026 17:19:27 +0200
Message-ID: <20260721152502.290971779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b4b4638df0f261..e5a32a0532eeec 100644
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



