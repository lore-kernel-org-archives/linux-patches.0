Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830958;
	b=IZ27x5kLGnFpzL2GYCkmD9q+wVTxg4uo44Ei6oI/CI5bApuA0G6bfowSqal4+FNMaGXR
	 7sL2C4ajahgbTQxEB2bRGuBqLMtMmSWgJEXioM6K6DBp4jSDuzSy8TOydeI/2jCc7vwec
	 iOndypZBGIQx8+SZ2pfRRpY610cjr1tDQdSIx1QNlhgD3K+opvwX8X7iOrdNL8hn/FNB6
	 ycFk/rVHTq4hvTzZprIu46+P6NE1ugRC5Obaoj+pU807bWbkoUI0GXppbfz1ggF2BGsQX
	 ufdo7sfzL1RyLtF5AuPiseWzuvndHQ6Jzg/rT1Voji5XYaw0vb/62Uyr6b4rgPUP4Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yAxeC510uZb/jh1X5Cv3p0bTk4m+dfZCl5ns7/m7rEI=;
	b=dWabrjEDoh3/hPXLFI2xNGiZJwdexpJRu2FxyOJR4PH/HYb8Y60Lam19ah0anwTCZZbl
	 mWWfHlT9p1On2g9Dp9fkmW0STdMYrGfDJqoO56TX6GSXyWNY15QkcNAn7rHUjbaOVwyo9
	 vzvIvpBzJNWq71hRIw6+/nz2tc4wd7+hq/WfzZ5Ze4IujSfkA951s/Xqpj/94R/ot8sSb
	 46Jnc6GlccDfOTZHYokbolYPAourX6ouKjVL4Zb3X+ulpu5tGq0dAt2u1Y+lJtv5R7AF/
	 DR++MuuEfkVoOAg6kvWLLlZaJt17vFV18fphzSfZsblr1xC6aaLe2CHJXI6f/aAbOEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUwl1yde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3732B606A87A;
	Wed,  4 Nov 2026 22:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUwl1yde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37951F0093A;
	Wed,  4 Nov 2026 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830958;
	bh=yAxeC510uZb/jh1X5Cv3p0bTk4m+dfZCl5ns7/m7rEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUwl1ydeFC59XyFpGoyZsy2biV7ugbZ0pBw8HUwVLrIyVAE+pkWXbPosWqOoTa9y3
	 gCgJvPzZ/7EdYoyXkwIWi9N6H2mo94epJrChq/9ah8Ky/5MCdLhKrnuO7YgwPcy9gw
	 bZ9+W5yT+WMMTD+BZjHJhDcoKfhmU9/i7yndOHLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0385/1005] alpha: run the remote RTC access in a worker, not an IPI callback
Date: Wed,  4 Nov 2026 16:01:58 -0500
Message-ID: <20261104211054.875532043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit 6f45effbd74012f1715584ba51abaa3196a47c08 ]

On Marvel the CMOS clock is only reachable from the boot cpu, so
remote_read_time() and remote_set_time() bounce the access there with
smp_call_function_single(), whose callback runs in hard interrupt
context.

alpha_rtc_read_time() calls mc146818_get_time() with a 10 ms timeout.
That waits out the RTC update cycle in mc146818_avoid_UIP(), which drops
rtc_lock and udelay()s 100 us at a time until the update completes or
the timeout expires:

	for (i = 0; UIP_RECHECK_LOOPS_MS(i) < timeout; i++) {
		spin_lock_irqsave(&rtc_lock, flags);
		...
		if (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP) {
			spin_unlock_irqrestore(&rtc_lock, flags);
			udelay(UIP_RECHECK_DELAY);
			continue;
		}

So a clock read from a non-boot cpu can spin for up to 10 ms in hard
interrupt context on the boot cpu, while the cpu that sent the request
spins in smp_call_function_single() waiting for it to finish.

mc146818_set_time() does not poll, but it takes rtc_lock too, and
rtc_lock is a spinlock_t.  Only raw spinlocks may be taken in hard
interrupt context, so lockdep reports the write path as soon as a
non-boot cpu sets the clock:

  [ BUG: Invalid wait context ]
  -----------------------------
  swapper/0/0 is trying to lock:
  fffffc0003690470 (rtc_lock){....}-{3:3}, at: mc146818_set_time+0x74/0x450
  other info that might help us debug this:
  context-{2:2}
  no locks held by swapper/0/0.
  stack backtrace:
  CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc1 #1 NONE
  Trace:
  [<fffffc000102ebb0>] dump_stack+0x28/0x44
  [<fffffc000110efcc>] __lock_acquire+0xb0c/0x1060
  [<fffffc000110f5f0>] lock_acquire.part.0+0xd0/0x300
  [...]
  [<fffffc0001b0d834>] mc146818_set_time+0x74/0x450
  [<fffffc0001f090cc>] _raw_spin_lock_irqsave+0x7c/0xc0
  [<fffffc0001042f90>] do_remote_set+0x90/0xc0
  [<fffffc000119c1a4>] __flush_smp_call_function_queue+0x314/0x5c0
  [<fffffc000119c474>] generic_smp_call_function_single_interrupt+0x24/0x40
  [<fffffc000103d984>] handle_ipi+0xa4/0x230
  [<fffffc0001037044>] do_entInt+0x1a4/0x2e0

The rtc class ops are always called from process context, so there is no
reason to run the access from an interrupt at all.  Use work_on_cpu() to
run it in a worker on the boot cpu.  Alpha does not support cpu hotplug,
so the boot cpu cannot go offline while the work is pending.

Tested on an AlphaServer ES47 (Marvel/EV7): hwclock read and write
pinned to a non-boot cpu, twenty times, with no splat.

Signed-off-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260810202835.3592833-1-mattst88@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/rtc.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/alpha/kernel/rtc.c b/arch/alpha/kernel/rtc.c
index cfdf90bc8b3f8..9e7d714ef6f85 100644
--- a/arch/alpha/kernel/rtc.c
+++ b/arch/alpha/kernel/rtc.c
@@ -15,6 +15,7 @@
 #include <linux/bcd.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
+#include <linux/workqueue.h>
 
 #include "proto.h"
 
@@ -142,54 +143,40 @@ static const struct rtc_class_ops alpha_rtc_ops = {
 };
 
 /*
- * Similarly, except do the actual CMOS access on the boot cpu only.
- * This requires marshalling the data across an interprocessor call.
+ * Similarly, except do the actual CMOS access on the boot cpu only.  The
+ * access polls for the RTC update cycle and takes rtc_lock, so run it in a
+ * worker on that cpu rather than from an interprocessor interrupt.
  */
 
 #if defined(CONFIG_SMP) && \
     (defined(CONFIG_ALPHA_GENERIC) || defined(CONFIG_ALPHA_MARVEL))
 # define HAVE_REMOTE_RTC 1
 
-union remote_data {
-	struct rtc_time *tm;
-	long retval;
-};
-
-static void
+static long
 do_remote_read(void *data)
 {
-	union remote_data *x = data;
-	x->retval = alpha_rtc_read_time(NULL, x->tm);
+	return alpha_rtc_read_time(NULL, data);
 }
 
 static int
 remote_read_time(struct device *dev, struct rtc_time *tm)
 {
-	union remote_data x;
-	if (smp_processor_id() != boot_cpuid) {
-		x.tm = tm;
-		smp_call_function_single(boot_cpuid, do_remote_read, &x, 1);
-		return x.retval;
-	}
+	if (smp_processor_id() != boot_cpuid)
+		return work_on_cpu(boot_cpuid, do_remote_read, tm);
 	return alpha_rtc_read_time(NULL, tm);
 }
 
-static void
+static long
 do_remote_set(void *data)
 {
-	union remote_data *x = data;
-	x->retval = alpha_rtc_set_time(NULL, x->tm);
+	return alpha_rtc_set_time(NULL, data);
 }
 
 static int
 remote_set_time(struct device *dev, struct rtc_time *tm)
 {
-	union remote_data x;
-	if (smp_processor_id() != boot_cpuid) {
-		x.tm = tm;
-		smp_call_function_single(boot_cpuid, do_remote_set, &x, 1);
-		return x.retval;
-	}
+	if (smp_processor_id() != boot_cpuid)
+		return work_on_cpu(boot_cpuid, do_remote_set, tm);
 	return alpha_rtc_set_time(NULL, tm);
 }
 
-- 
2.53.0



