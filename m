Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863D125D918;
	Tue, 11 Mar 2025 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706152; cv=none; b=ZTvpG24/DHbBss9D4ErrveLSPrF7Hhc+H//Qz56DY6LuTvpcC2gk4p518mLwvciosQfp6uj2r/CDfS/dp/xZ9d5aipEhbm2S98kAAKU2NbW30OC5oZkxDfRNr314YiTrjlF4oGpcS+uoswbi3c+I+ZdCQRREdAhP4wSDaR1Nfy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706152; c=relaxed/simple;
	bh=WYMeEcf3oSQU0QXv4BL+8pEmlkp/AYMZ1dhFQ5dvWdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juFD5dphoy+qLwmEq9iMs34aBvmVQ0rUCvQsAzpdABkFAx4f6sfWrWpjZTksP5VLtIDFLcdDs0m05jOkxftOl4q9dLW1HFqoXQJc3eybZ77+KJqOFVmQ0nRKwqS3dGQrFmwlS7+joYJXWfaBeBg+65EHLpZ/PjAa+ds1FCCpr+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElapTaGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElapTaGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E70C4CEE9;
	Tue, 11 Mar 2025 15:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706152;
	bh=WYMeEcf3oSQU0QXv4BL+8pEmlkp/AYMZ1dhFQ5dvWdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElapTaGFC/UJDaI9uFBrLHmuYe1aqpd9QLqp7bzXz8jexlqGGwewCuAepT89i5cx7
	 dw9qFZLz5jMfIIMKVA7jdyBePzJMfvFrrAFgNYGwFYXUz5gpscDeW1leXfXe2KoX+J
	 Rlwv9PLakMIzIls6xvKsyaIe3JpOhJfFXz66L0yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.4 280/328] HID: appleir: Fix potential NULL dereference at raw event handle
Date: Tue, 11 Mar 2025 16:00:50 +0100
Message-ID: <20250311145726.043207715@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

commit 2ff5baa9b5275e3acafdf7f2089f74cccb2f38d1 upstream.

Syzkaller reports a NULL pointer dereference issue in input_event().

BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: null-ptr-deref in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: null-ptr-deref in is_event_supported drivers/input/input.c:67 [inline]
BUG: KASAN: null-ptr-deref in input_event+0x42/0xa0 drivers/input/input.c:395
Read of size 8 at addr 0000000000000028 by task syz-executor199/2949

CPU: 0 UID: 0 PID: 2949 Comm: syz-executor199 Not tainted 6.13.0-rc4-syzkaller-00076-gf097a36ef88d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 kasan_report+0xd9/0x110 mm/kasan/report.c:602
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 is_event_supported drivers/input/input.c:67 [inline]
 input_event+0x42/0xa0 drivers/input/input.c:395
 input_report_key include/linux/input.h:439 [inline]
 key_down drivers/hid/hid-appleir.c:159 [inline]
 appleir_raw_event+0x3e5/0x5e0 drivers/hid/hid-appleir.c:232
 __hid_input_report.constprop.0+0x312/0x440 drivers/hid/hid-core.c:2111
 hid_ctrl+0x49f/0x550 drivers/hid/usbhid/hid-core.c:484
 __usb_hcd_giveback_urb+0x389/0x6e0 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x396/0x450 drivers/usb/core/hcd.c:1734
 dummy_timer+0x17f7/0x3960 drivers/usb/gadget/udc/dummy_hcd.c:1993
 __run_hrtimer kernel/time/hrtimer.c:1739 [inline]
 __hrtimer_run_queues+0x20a/0xae0 kernel/time/hrtimer.c:1803
 hrtimer_run_softirq+0x17d/0x350 kernel/time/hrtimer.c:1820
 handle_softirqs+0x206/0x8d0 kernel/softirq.c:561
 __do_softirq kernel/softirq.c:595 [inline]
 invoke_softirq kernel/softirq.c:435 [inline]
 __irq_exit_rcu+0xfa/0x160 kernel/softirq.c:662
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0x90/0xb0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
 __mod_timer+0x8f6/0xdc0 kernel/time/timer.c:1185
 add_timer+0x62/0x90 kernel/time/timer.c:1295
 schedule_timeout+0x11f/0x280 kernel/time/sleep_timeout.c:98
 usbhid_wait_io+0x1c7/0x380 drivers/hid/usbhid/hid-core.c:645
 usbhid_init_reports+0x19f/0x390 drivers/hid/usbhid/hid-core.c:784
 hiddev_ioctl+0x1133/0x15b0 drivers/hid/usbhid/hiddev.c:794
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __x64_sys_ioctl+0x190/0x200 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

This happens due to the malformed report items sent by the emulated device
which results in a report, that has no fields, being added to the report list.
Due to this appleir_input_configured() is never called, hidinput_connect()
fails which results in the HID_CLAIMED_INPUT flag is not being set. However,
it  does not make appleir_probe() fail and lets the event callback to be
called without the associated input device.

Thus, add a check for the HID_CLAIMED_INPUT flag and leave the event hook
early if the driver didn't claim any input_dev for some reason. Moreover,
some other hid drivers accessing input_dev in their event callbacks do have
similar checks, too.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 9a4a5574ce42 ("HID: appleir: add support for Apple ir devices")
Cc: stable@vger.kernel.org
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-appleir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-appleir.c
+++ b/drivers/hid/hid-appleir.c
@@ -188,7 +188,7 @@ static int appleir_raw_event(struct hid_
 	static const u8 flatbattery[] = { 0x25, 0x87, 0xe0 };
 	unsigned long flags;
 
-	if (len != 5)
+	if (len != 5 || !(hid->claimed & HID_CLAIMED_INPUT))
 		goto out;
 
 	if (!memcmp(data, keydown, sizeof(keydown))) {


