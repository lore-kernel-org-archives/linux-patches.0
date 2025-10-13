Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA0B26F2B6;
	Mon, 13 Oct 2025 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369521; cv=none; b=YVBy5NPFGl8Nsd/zHa+qWKg7UvR+jT5nE3i7Akdrn1fsqFXYFYhYx+nq/FnQZGyds2nW13jiTtVgEOWLfr3eYnswBlwN/yJ2ltYmpWEnWHhs/51OWqavXNPES2tbEiXMt7aOBe1Imps4emUqEROPEi+k64HpV2Pbs6JRU55j+9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369521; c=relaxed/simple;
	bh=rwpcsC6Yw9WzCUVV8hDCs/FOZWXgZfzYjkBpanKpldA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb3SeXf5tlCBeeppq7X+sw4gxzO9A2sfIbDmZZ8KZappGZCFfxaS7QFWI09tfkAT27XYKPnVjppYbMMEiwxz5QhiBqt9AHhfkgVdq6RLb1tldAhzHOZdqxC71PyS3jO2dZTnuj6Xyi9mu/KK+s+NEukoC63aGsIUC5EYUhoRg0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVBGbO7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVBGbO7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869D4C4CEFE;
	Mon, 13 Oct 2025 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369520;
	bh=rwpcsC6Yw9WzCUVV8hDCs/FOZWXgZfzYjkBpanKpldA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVBGbO7fftKoLDP+k4LGle88y6s5e0g92xJ9B/gbxWHu6USMzoFTLDuUsMtN8dqCB
	 4Fe47ouGEZ+jPQ5enfX1b3Y3KuYwZ9V+BRM6MowtBRJu8M+4YlDT5NLh+Mr/xRw4lH
	 fDQEcw9r1lH4wOgfyTYxP09RDt3MjwAzi5o3gFDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 268/563] wifi: rtw88: Use led->brightness_set_blocking for PCI too
Date: Mon, 13 Oct 2025 16:42:09 +0200
Message-ID: <20251013144420.985687416@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit fce6fee0817b8899e0ee38ab6b98f0d7e939ceed ]

Commit 26a8bf978ae9 ("wifi: rtw88: Lock rtwdev->mutex before setting
the LED") made rtw_led_set() sleep, but that's not allowed. Fix it by
using the brightness_set_blocking member of struct led_classdev for
PCI devices too. This one is allowed to sleep.

bad: scheduling from the idle thread!
nix kernel: CPU: 7 UID: 0 PID: 0 Comm: swapper/7 Tainted: G        W  O        6.16.0 #1-NixOS PREEMPT(voluntary)
nix kernel: Tainted: [W]=WARN, [O]=OOT_MODULE
nix kernel: Hardware name: [REDACTED]
nix kernel: Call Trace:
nix kernel:  <IRQ>
nix kernel:  dump_stack_lvl+0x63/0x90
nix kernel:  dequeue_task_idle+0x2d/0x50
nix kernel:  __schedule+0x191/0x1310
nix kernel:  ? xas_load+0x11/0xd0
nix kernel:  schedule+0x2b/0xe0
nix kernel:  schedule_preempt_disabled+0x19/0x30
nix kernel:  __mutex_lock.constprop.0+0x3fd/0x7d0
nix kernel:  rtw_led_set+0x27/0x60 [rtw_core]
nix kernel:  led_blink_set_nosleep+0x56/0xb0
nix kernel:  led_trigger_blink+0x49/0x80
nix kernel:  ? __pfx_tpt_trig_timer+0x10/0x10 [mac80211]
nix kernel:  call_timer_fn+0x2f/0x140
nix kernel:  ? __pfx_tpt_trig_timer+0x10/0x10 [mac80211]
nix kernel:  __run_timers+0x21a/0x2b0
nix kernel:  run_timer_softirq+0x8e/0x100
nix kernel:  handle_softirqs+0xea/0x2c0
nix kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
nix kernel:  __irq_exit_rcu+0xdc/0x100
nix kernel:  sysvec_apic_timer_interrupt+0x7c/0x90
nix kernel:  </IRQ>
nix kernel:  <TASK>
nix kernel:  asm_sysvec_apic_timer_interrupt+0x1a/0x20
nix kernel: RIP: 0010:cpuidle_enter_state+0xcc/0x450
nix kernel: Code: 00 e8 08 7c 2e ff e8 d3 ee ff ff 49 89 c6 0f 1f 44 00 00 31 ff e8 c4 d1 2c ff 80 7d d7 00 0f 85 5d 02 00 00 fb 0f 1f 44 00 00 <45> 85 ff 0f 88 a0 01 00 00 49 63 f7 4c 89 f2 48 8d 0>
nix kernel: RSP: 0018:ffffd579801c7e68 EFLAGS: 00000246
nix kernel: RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
nix kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
nix kernel: RBP: ffffd579801c7ea0 R08: 0000000000000000 R09: 0000000000000000
nix kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff8eab0462a400
nix kernel: R13: ffffffff9a7d7a20 R14: 00000003aebe751d R15: 0000000000000003
nix kernel:  ? cpuidle_enter_state+0xbc/0x450
nix kernel:  cpuidle_enter+0x32/0x50
nix kernel:  do_idle+0x1b1/0x210
nix kernel:  cpu_startup_entry+0x2d/0x30
nix kernel:  start_secondary+0x118/0x140
nix kernel:  common_startup_64+0x13e/0x141
nix kernel:  </TASK>

Fixes: 26a8bf978ae9 ("wifi: rtw88: Lock rtwdev->mutex before setting the LED")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/ad8a49ef-4f2d-4a61-8292-952db9c4eb65@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/led.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/led.c b/drivers/net/wireless/realtek/rtw88/led.c
index 7f9ace351a5b7..4cc62e49d1679 100644
--- a/drivers/net/wireless/realtek/rtw88/led.c
+++ b/drivers/net/wireless/realtek/rtw88/led.c
@@ -6,8 +6,8 @@
 #include "debug.h"
 #include "led.h"
 
-static void rtw_led_set(struct led_classdev *led,
-			enum led_brightness brightness)
+static int rtw_led_set(struct led_classdev *led,
+		       enum led_brightness brightness)
 {
 	struct rtw_dev *rtwdev = container_of(led, struct rtw_dev, led_cdev);
 
@@ -16,12 +16,6 @@ static void rtw_led_set(struct led_classdev *led,
 	rtwdev->chip->ops->led_set(led, brightness);
 
 	mutex_unlock(&rtwdev->mutex);
-}
-
-static int rtw_led_set_blocking(struct led_classdev *led,
-				enum led_brightness brightness)
-{
-	rtw_led_set(led, brightness);
 
 	return 0;
 }
@@ -46,10 +40,7 @@ void rtw_led_init(struct rtw_dev *rtwdev)
 	if (!rtwdev->chip->ops->led_set)
 		return;
 
-	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE)
-		led->brightness_set = rtw_led_set;
-	else
-		led->brightness_set_blocking = rtw_led_set_blocking;
+	led->brightness_set_blocking = rtw_led_set;
 
 	snprintf(rtwdev->led_name, sizeof(rtwdev->led_name),
 		 "rtw88-%s", dev_name(rtwdev->dev));
-- 
2.51.0



