Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060966;
	b=wZ/Mh9bpiv5v8K3zfWpPKMN+ifSz23B4dqxdwjJxECaWQc0QBY5hC3VjCzQbNIZR0sIu
	 XfYNxzAWlkCz4CwF2DbwP9gVix6n8PYAfMmtIWCW96v1TGbMa/j7qk4c9sARn0FNPgr7Q
	 Gfajw+bI8cY8rcZPsVVa6F4oM/yXIz8QZnUEBmTI3YQDMd5hGF2RcmN9XE0FXCnZyJAws
	 +qmKblOlETvLOXIKJEphXXcgdHBa78ye8koEgKWOEZnC5xVAp9R7HIKkWxti7tFlFp93q
	 U6JAJHrkEAvH/SUOPBrsfIBLt3p1Jf86fwXwCTeuBM3C914XXErCQpE1qTq2jVlKcbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nrpi1Cp8FxgeYTi5HkJRot+zurCFnoMb43thzUStgns=;
	b=aGMqbhT7j7Md7ziQpA+yyoGIcQWNz+lzAtugKbxgr8oEVBWJ5YY37sMS40t8O3lRESUe
	 dQrfjvg6+F5jLWad4jedR8nnk1mdBAmsD1UWLU82MnzNjopSkLogAKgvaKfmPjDmyZidy
	 8HAriICYgEtNECdtiXfDSivtUvp7Y83dQurzFgn9ov8ZXUGILWyZ9PrSD9rYf+EOwQQWx
	 NqCfS7rjT19vzFiZgT0QTzNgDRYzMWcSR7wZWIHEsajwXIrXy3zdH3sWnDSA3N5/OUsmu
	 9d0BHbZLclhfO5XgjF1CbqT++6yuUHvNg311drNnseokR9zEb64C+T/DiR6uSoldhqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+tXfEmz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF93606A330;
	Sat,  7 Nov 2026 14:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+tXfEmz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675ED1F0089F;
	Sat,  7 Nov 2026 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060965;
	bh=nrpi1Cp8FxgeYTi5HkJRot+zurCFnoMb43thzUStgns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+tXfEmzRDtv06tivHpwYzXafTWW468lAoHCO64IkXsdKpmaURIyenZ7XAxKFyHS0
	 C8q5K9z+3zOWzaB7F6AeCRvLm9D/wV3p8em3KLecp253JthTNYz5LRVoDLSSmtsb2V
	 7TY6fkVjzJMyob7E6OI/wWziPvJuD6Uz94JRVNq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0320/1536] alpha: run the remote RTC access in a worker, not an IPI callback
Date: Sat,  7 Nov 2026 08:38:56 -0500
Message-ID: <20261107135006.708471130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



