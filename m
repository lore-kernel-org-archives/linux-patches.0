Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943111C3C00;
	Wed, 19 Feb 2025 09:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957589; cv=none; b=M6YyIgHG2MrWKIj+yJx6nxqY47Q//QHTsy3Ho1idR5IIQicmGRE4EP4EaoC8ptf42Godocfg0y+fOtXKt4DdnrYjpaoWr1UhxTCDWiTChaqtersuO2HBt4rnIl2QEFlxBNwoXF9ExxFjFqBdeKDAyufjK7avS1B7n1xnBizmlGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957589; c=relaxed/simple;
	bh=8+PeJ7lzdeQgiF4ymU/6+ulba8a27YWdCyM8+QxxzF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ3MCc5orB9A4TR+BrsjFb3O/HQdpQ6h/6o3BJ/okbrS4HWBpS0f06ccOVkxU8pCMjXPYgyzRKK88XHOUGzXBdcYy1K2S/17OwwVRWzAB6RaGYgNOvnVdoYViHSpGaknmPFjKkyeQul6YB4f49SaSS28N7o6T8adjxFO3HubyJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrdHD6RM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrdHD6RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4BEC4CED1;
	Wed, 19 Feb 2025 09:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957589;
	bh=8+PeJ7lzdeQgiF4ymU/6+ulba8a27YWdCyM8+QxxzF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrdHD6RMBBpltr1B9/U/+aZGk1akP6HrIHRZtyn9NOTcYks6oppAL+c80pqmB8o7x
	 NLj+hyyFVbjv4SWfWmi1g+ER7xGcPwe+57VKeo6NsNChg6HH8VW6zfAHxqFUz6IHJ8
	 GDbXcrbknaeFl1d7Hq3XcmE3uivjFxdAYT98AYSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Kelley <mhkelley@outlook.com>
Subject: [PATCH 6.1 578/578] x86/i8253: Disable PIT timer 0 when not in use
Date: Wed, 19 Feb 2025 09:29:42 +0100
Message-ID: <20250219082715.689060267@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit 70e6b7d9ae3c63df90a7bba7700e8d5c300c3c60 upstream.

Leaving the PIT interrupt running can cause noticeable steal time for
virtual guests. The VMM generally has a timer which toggles the IRQ input
to the PIC and I/O APIC, which takes CPU time away from the guest. Even
on real hardware, running the counter may use power needlessly (albeit
not much).

Make sure it's turned off if it isn't going to be used.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Michael Kelley <mhkelley@outlook.com>
Link: https://lore.kernel.org/all/20240802135555.564941-1-dwmw2@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/i8253.c     |   11 +++++++++--
 drivers/clocksource/i8253.c |   13 +++++++++----
 include/linux/i8253.h       |    1 +
 3 files changed, 19 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -8,6 +8,7 @@
 #include <linux/timex.h>
 #include <linux/i8253.h>
 
+#include <asm/hypervisor.h>
 #include <asm/apic.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
@@ -39,9 +40,15 @@ static bool __init use_pit(void)
 
 bool __init pit_timer_init(void)
 {
-	if (!use_pit())
+	if (!use_pit()) {
+		/*
+		 * Don't just ignore the PIT. Ensure it's stopped, because
+		 * VMMs otherwise steal CPU time just to pointlessly waggle
+		 * the (masked) IRQ.
+		 */
+		clockevent_i8253_disable();
 		return false;
-
+	}
 	clockevent_i8253_init(true);
 	global_clock_event = &i8253_clockevent;
 	return true;
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -108,11 +108,8 @@ int __init clocksource_i8253_init(void)
 #endif
 
 #ifdef CONFIG_CLKEVT_I8253
-static int pit_shutdown(struct clock_event_device *evt)
+void clockevent_i8253_disable(void)
 {
-	if (!clockevent_state_oneshot(evt) && !clockevent_state_periodic(evt))
-		return 0;
-
 	raw_spin_lock(&i8253_lock);
 
 	outb_p(0x30, PIT_MODE);
@@ -123,6 +120,14 @@ static int pit_shutdown(struct clock_eve
 	}
 
 	raw_spin_unlock(&i8253_lock);
+}
+
+static int pit_shutdown(struct clock_event_device *evt)
+{
+	if (!clockevent_state_oneshot(evt) && !clockevent_state_periodic(evt))
+		return 0;
+
+	clockevent_i8253_disable();
 	return 0;
 }
 
--- a/include/linux/i8253.h
+++ b/include/linux/i8253.h
@@ -24,6 +24,7 @@ extern raw_spinlock_t i8253_lock;
 extern bool i8253_clear_counter_on_shutdown;
 extern struct clock_event_device i8253_clockevent;
 extern void clockevent_i8253_init(bool oneshot);
+extern void clockevent_i8253_disable(void);
 
 extern void setup_pit_timer(void);
 


