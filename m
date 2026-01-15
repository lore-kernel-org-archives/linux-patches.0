Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC45A42049;
	Thu, 15 Jan 2026 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495972; cv=none; b=T/TgIQkEaC7CjpRXH6bNNtSCc0oU+ev69eO75PVjuomzwHYzRprVPqH2pSNN7Erk+4vdlf+MIcoC4EKrMz/dQzoNhiHF+JAI9ADumH5i/QPVvMhdKhElptURuvWAXMBvtQpGt/pO9axQtnkHgXg5KKHnEZrxUu62cYAcX43244A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495972; c=relaxed/simple;
	bh=sh6bdMKyY0b/UxU/rslorPILYYCebwhPZH7/i35hTkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBRZOswIf8EoxScEOHN537lOravznTO9kye1c1QhUyNpvQ9egkqLXEIFO2wgwXH1uwBzgzUOZ1wIwDmw4eC0ekMFQ1Ae6XrgdZKrG7q18uJuMSI0XbsGes/90GHK2Su+0viemB3PF+8fZBWluZtcKRj++wsixKkUPLOqzVUZ06s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AZYsd9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AZYsd9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A898C116D0;
	Thu, 15 Jan 2026 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495971;
	bh=sh6bdMKyY0b/UxU/rslorPILYYCebwhPZH7/i35hTkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AZYsd9sAfCvOxDxwcDB37qYNC2+fXQurwdAYl/Fbvp7kM3nv+Udsr9lm0Rmfhyv0
	 XTpGU2zK2loktC57GeiBsB85aLTaey83gmu15osILms3Kk+8SfxTXz6Y4pHeNHrXEU
	 hSO4syDfTZFp2aehgtC3fL0FOgUOxUZ0fOQv4ZsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 031/181] gpio: rockchip: mark the GPIO controller as sleeping
Date: Thu, 15 Jan 2026 17:46:08 +0100
Message-ID: <20260115164203.451978119@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

commit 20cf2aed89ac6d78a0122e31c875228e15247194 upstream.

The GPIO controller is configured as non-sleeping but it uses generic
pinctrl helpers which use a mutex for synchronization.

This can cause the following lockdep splat with shared GPIOs enabled on
boards which have multiple devices using the same GPIO:

BUG: sleeping function called from invalid context at
kernel/locking/mutex.c:591
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 12, name:
kworker/u16:0
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
6 locks held by kworker/u16:0/12:
  #0: ffff0001f0018d48 ((wq_completion)events_unbound#2){+.+.}-{0:0},
at: process_one_work+0x18c/0x604
  #1: ffff8000842dbdf0 (deferred_probe_work){+.+.}-{0:0}, at:
process_one_work+0x1b4/0x604
  #2: ffff0001f18498f8 (&dev->mutex){....}-{4:4}, at:
__device_attach+0x38/0x1b0
  #3: ffff0001f75f1e90 (&gdev->srcu){.+.?}-{0:0}, at:
gpiod_direction_output_raw_commit+0x0/0x360
  #4: ffff0001f46e3db8 (&shared_desc->spinlock){....}-{3:3}, at:
gpio_shared_proxy_direction_output+0xd0/0x144 [gpio_shared_proxy]
  #5: ffff0001f180ee90 (&gdev->srcu){.+.?}-{0:0}, at:
gpiod_direction_output_raw_commit+0x0/0x360
irq event stamp: 81450
hardirqs last  enabled at (81449): [<ffff8000813acba4>]
_raw_spin_unlock_irqrestore+0x74/0x78
hardirqs last disabled at (81450): [<ffff8000813abfb8>]
_raw_spin_lock_irqsave+0x84/0x88
softirqs last  enabled at (79616): [<ffff8000811455fc>]
__alloc_skb+0x17c/0x1e8
softirqs last disabled at (79614): [<ffff8000811455fc>]
__alloc_skb+0x17c/0x1e8
CPU: 2 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted
6.19.0-rc4-next-20260105+ #11975 PREEMPT
Hardware name: Hardkernel ODROID-M1 (DT)
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
  pinctrl_gpio_direction+0x3c/0xe0
  pinctrl_gpio_direction_output+0x14/0x20
  rockchip_gpio_direction_output+0xb8/0x19c
  gpiochip_direction_output+0x38/0x94
  gpiod_direction_output_raw_commit+0x1d8/0x360
  gpiod_direction_output_nonotify+0x7c/0x230
  gpiod_direction_output+0x34/0xf8
  gpio_shared_proxy_direction_output+0xec/0x144 [gpio_shared_proxy]
  gpiochip_direction_output+0x38/0x94
  gpiod_direction_output_raw_commit+0x1d8/0x360
  gpiod_direction_output_nonotify+0x7c/0x230
  gpiod_configure_flags+0xbc/0x480
  gpiod_find_and_request+0x1a0/0x574
  gpiod_get_index+0x58/0x84
  devm_gpiod_get_index+0x20/0xb4
  devm_gpiod_get_optional+0x18/0x30
  rockchip_pcie_probe+0x98/0x380
  platform_probe+0x5c/0xac
  really_probe+0xbc/0x298

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Cc: stable@vger.kernel.org
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/all/d035fc29-3b03-4cd6-b8ec-001f93540bc6@samsung.com/
Acked-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20260106090011.21603-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-rockchip.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -593,6 +593,7 @@ static int rockchip_gpiolib_register(str
 	gc->ngpio = bank->nr_pins;
 	gc->label = bank->name;
 	gc->parent = bank->dev;
+	gc->can_sleep = true;
 
 	ret = gpiochip_add_data(gc, bank);
 	if (ret) {


