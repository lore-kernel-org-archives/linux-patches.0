Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208178;
	b=mJQNustAoM6OX+2S9GJEn+lSkzyV20KcSeY9g/kMtA7N/eoUlbQ1qRgGEwBIx3c/JB2k
	 MCZQ0Wy8BG1rHsItbdQ0fzfmm4TULgtHUFSgMfBGnWk4xEz9BFNN+6PAvTHaRDSLle3+i
	 86jLLz3sMWYqZkGcrdSDdG2uQ8cCeakEECptvNY+KrdWC7w49Jz0+irgicxjbqMqz7f1E
	 siq1gDviXn8KdehbC610jYhgt+3odhLCvYLG7CYz2vpQ7Y1TbSRvlgYkRgK50VFH0qcz9
	 OhHFUgdF3+T9GVuyizZwBZXt71FfaDuC/QL6g0Ift/awwAajb/9dmSrxI6l2dUaNH7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ytp/ja7k27BKe/aUdRX8U5kK/eGNwsW9Uw6QMXa0E8M=;
	b=nmblOCZD6TsTdRuyM2Nst5RNZSkq/ee+LxqvPANfShv5WOYU2ArT3nBOwCqqWniDxcPU
	 KCjpBf/XtT8jtQ8fUZIDwXMldKy5SmlQJTQp1Az1Z5MQZugepK3ON26wcpCApWF1bLjY1
	 Fl3c9/QcM50z6D7XQs/zA3ww5pHAMfQbCu2GOmFAbVMMoDWsVifFpiPHCuzxtxhK9mXlS
	 iJ2zhU5sIw6LGCyzsX1qqT5oL2YuZkvBZleyHWatV9YT5y1xof1L2CwJCNjI+i1SQ3Hrl
	 j1Z0JesTGI8E2w580+W5OEqibkF1EZSY2sTeZRWsUyq8u+g0aXKwkk7ItuIt5N/cxIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKbNN+8R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3D8606A31A;
	Wed, 28 Oct 2026 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKbNN+8R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295D31F031EA;
	Wed, 28 Oct 2026 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208177;
	bh=ytp/ja7k27BKe/aUdRX8U5kK/eGNwsW9Uw6QMXa0E8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKbNN+8RaMKP51/OGRVuH3mL+Tok7gIBJtWcNm6ps43l/TfwXnNQWZEvPxGmAjs2O
	 WpvQEqVN6Q/0dd2F+YCwZA7Atk0yDffhJs/aIVB482AmVHNwqvsijn7DVYmPyCVry9
	 uWsKd5pT8LeT0BvL4ozK5DIvTNhpjrNGZPoEIEqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E6=9C=B1=E6=81=BA=E4=B9=BE?= <zhukaiqian@xiaomi.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Bradley Morgan <brads@mainlining.org>,
	=?UTF-8?q?=E5=88=98=E6=9C=AF=E9=AB=98?= <liushugao@xiaomi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/516] tick/broadcast: Plug clockevents replacement race
Date: Wed, 28 Oct 2026 17:53:00 +0100
Message-ID: <20261028170004.195292624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 113a9796effe3376d2ec5aabcca1fef4fef4cd62 ]

朱恺乾 reported and decoded the following race condition when a broadcast
device is replaced:

CPUA					CPUB
 __tick_broadcast_oneshot_control()
   bc = tick_broadcast_device.evtdev;
					tick_install_broadcast_device(dev)
        				clockevents_exchange_device(cur, dev)
					   shutdown(cur);
					   detach(cur);
					   cur->handler = noop;
					   tick_broadcast_device.evtdev = dev;

  tick_broadcast_set_event(bc, next_event); <- FAIL: arms a detached device.

If the original broadcast device has a restricted interrupt affinity mask
and the last CPU in that mask goes offline then the BUG() in
tick_cleanup_dead_cpu() triggers because the clockevent device is not in
detached state.

The reason for this is that tick_install_broadcast_device() is not
serialized vs. tick broadcast operations.

The obvious cure is to serialize tick_install_broadcast_device() with
tick_broadcast_lock against a concurrent tick broadcast operation.

That requires to split clockevents_exchange_device() into two parts, one
which does the exchange, shutdown and detach operation and the other which
drops the module reference count. This is required because the module
reference cannot be dropped while holding tick_broadcast_lock.

Let clockevents_exchange_device() do both operations as before, but let the
broadcast device code take the two step approach and do the device
exchange under tick_broadcast_lock and drop the module reference count
after releasing it.

Fixes: f8381cba04ba ("[PATCH] tick-management: broadcast functionality")
Reported-by: 朱恺乾 <zhukaiqian@xiaomi.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Tested-by: 刘术高 <liushugao@xiaomi.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/87cymdsu0r.ffs@tglx
[ replaced scoped_guard() with a nested guard() block for GNU89 compatibility. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clockevents.c    | 33 ++++++++++++++++++++-------------
 kernel/time/tick-broadcast.c | 34 ++++++++++++++++++++++------------
 kernel/time/tick-internal.h  |  2 ++
 3 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index f5490222e134a..49861ae3fc785 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -558,34 +558,41 @@ void clockevents_handle_noop(struct clock_event_device *dev)
 {
 }
 
-/**
- * clockevents_exchange_device - release and request clock devices
- * @old:	device to release (can be NULL)
- * @new:	device to request (can be NULL)
- *
- * Called from various tick functions with clockevents_lock held and
- * interrupts disabled.
- */
-void clockevents_exchange_device(struct clock_event_device *old,
-				 struct clock_event_device *new)
+void __clockevents_exchange_device(struct clock_event_device *old,
+				   struct clock_event_device *new)
 {
 	/*
 	 * Caller releases a clock event device. We queue it into the
 	 * released list and do a notify add later.
 	 */
 	if (old) {
-		module_put(old->owner);
 		clockevents_switch_state(old, CLOCK_EVT_STATE_DETACHED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
 	}
 
 	if (new) {
-		BUG_ON(!clockevent_state_detached(new));
+		WARN_ON(!clockevent_state_detached(new));
 		clockevents_shutdown(new);
 	}
 }
 
+/**
+ * clockevents_exchange_device - release and request clock devices
+ * @old:	device to release (can be NULL)
+ * @new:	device to request (can be NULL)
+ *
+ * Called from various tick functions with clockevents_lock held and
+ * interrupts disabled.
+ */
+void clockevents_exchange_device(struct clock_event_device *old,
+				 struct clock_event_device *new)
+{
+	__clockevents_exchange_device(old, new);
+	if (old)
+		module_put(old->owner);
+}
+
 /**
  * clockevents_suspend - suspend clock devices
  */
@@ -651,7 +658,7 @@ void tick_cleanup_dead_cpu(int cpu)
 		if (cpumask_test_cpu(cpu, dev->cpumask) &&
 		    cpumask_weight(dev->cpumask) == 1 &&
 		    !tick_is_broadcast_device(dev)) {
-			BUG_ON(!clockevent_state_detached(dev));
+			WARN_ON(!clockevent_state_detached(dev));
 			list_del(&dev->list);
 		}
 	}
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index dc3838c00d6c7..35351b7fe486b 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -93,20 +93,30 @@ static bool tick_check_broadcast_device(struct clock_event_device *curdev,
  */
 void tick_install_broadcast_device(struct clock_event_device *dev)
 {
-	struct clock_event_device *cur = tick_broadcast_device.evtdev;
+	struct clock_event_device *cur;
 
-	if (!tick_check_broadcast_device(cur, dev))
-		return;
+	{
+		guard(raw_spinlock_irqsave)(&tick_broadcast_lock);
 
-	if (!try_module_get(dev->owner))
-		return;
+		cur = tick_broadcast_device.evtdev;
+		if (!tick_check_broadcast_device(cur, dev))
+			return;
+
+		if (!try_module_get(dev->owner))
+			return;
 
-	clockevents_exchange_device(cur, dev);
+		__clockevents_exchange_device(cur, dev);
+		if (cur)
+			cur->event_handler = clockevents_handle_noop;
+		WRITE_ONCE(tick_broadcast_device.evtdev, dev);
+		if (!cpumask_empty(tick_broadcast_mask))
+			tick_broadcast_start_periodic(dev);
+	}
+
+	/* Module release must be outside of the lock */
 	if (cur)
-		cur->event_handler = clockevents_handle_noop;
-	tick_broadcast_device.evtdev = dev;
-	if (!cpumask_empty(tick_broadcast_mask))
-		tick_broadcast_start_periodic(dev);
+		module_put(cur->owner);
+
 	/*
 	 * Inform all cpus about this. We might be in a situation
 	 * where we did not switch to oneshot mode because the per cpu
@@ -1009,7 +1019,7 @@ int tick_broadcast_oneshot_active(void)
  */
 bool tick_broadcast_oneshot_available(void)
 {
-	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+	struct clock_event_device *bc = READ_ONCE(tick_broadcast_device.evtdev);
 
 	return bc ? bc->features & CLOCK_EVT_FEAT_ONESHOT : false;
 }
@@ -1017,7 +1027,7 @@ bool tick_broadcast_oneshot_available(void)
 #else
 int __tick_broadcast_oneshot_control(enum tick_broadcast_state state)
 {
-	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+	struct clock_event_device *bc = READ_ONCE(tick_broadcast_device.evtdev);
 
 	if (!bc || (bc->features & CLOCK_EVT_FEAT_HRTIMER))
 		return -EBUSY;
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index e61c1244e7d46..0204523af663d 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -48,6 +48,8 @@ static inline void clockevent_set_state(struct clock_event_device *dev,
 }
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
+extern void __clockevents_exchange_device(struct clock_event_device *old,
+					  struct clock_event_device *new);
 extern void clockevents_exchange_device(struct clock_event_device *old,
 					struct clock_event_device *new);
 extern void clockevents_switch_state(struct clock_event_device *dev,
-- 
2.53.0



