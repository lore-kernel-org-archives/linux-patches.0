Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC823B3BF2;
	Wed, 30 Sep 2026 19:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795585; cv=none; b=MJf57nOQe49YJIA6s+ZO8Uqj/fcR9rEBUt78XRQx7wZs71cIonNxDno2/N0P62FxJJGBLHDE+F1bRbVUqf+iWd4xn4ISRJlrv3MPgVpNlkHnJm9kLGWA1s0SZRWR+fZsmXjskCJK7dFe3ZZHjnOlkxA954tMf6BSVew8/nlWges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795585; c=relaxed/simple;
	bh=f+Ka91eooIy8xBKuC0jlldHh/PkH7RcRaTZNlw5vZc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQJo2B8Io0FS//vg5MfbcqLoaoHCL2DtSD48ooV080aA3iT8AK4YomQfVZUGVUNGidrdlnmfisziFkP0/dLah9GcVgDppAvhlqLykalxDzc70EE+jw7vvX2xbOVz+nYQ/7olQo/OQ+b/E2ORQWkMlxU+4+he/TTkpH7pkqsPUMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3PLUZ2p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3PLUZ2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E95F1F000FF;
	Wed, 30 Sep 2026 19:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795583;
	bh=nhnHpxNlnSeWp4lGUPhDYA4/8nuo/Y/zXunZj+xI5fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3PLUZ2p+N9izBNep23sQ70VyFfhuj8HhP3PN6oIP8T8/953s6YaS9r37XRj/Vzt7
	 PR4OzDPrdMKeRV5Gik29l5fanPLVhcvU5/3c6TMAmeukRqgWC9tYjOii4MWczwSE3v
	 R1MaIAJtY7R86ueE5KDjX3BVz9TQSASNnfwldM28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E6=9C=B1=E6=81=BA=E4=B9=BE?= <zhukaiqian@xiaomi.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Bradley Morgan <brads@mainlining.org>,
	=?UTF-8?q?=E5=88=98=E6=9C=AF=E9=AB=98?= <liushugao@xiaomi.com>
Subject: [PATCH 6.6 0610/1193] tick/broadcast: Plug clockevents replacement race
Date: Wed, 30 Sep 2026 17:21:34 +0200
Message-ID: <20260930152447.798030003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 113a9796effe3376d2ec5aabcca1fef4fef4cd62 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/clockevents.c    |   33 ++++++++++++++++++++-------------
 kernel/time/tick-broadcast.c |   36 ++++++++++++++++++++++--------------
 kernel/time/tick-internal.h  |    2 ++
 3 files changed, 44 insertions(+), 27 deletions(-)

--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -557,34 +557,41 @@ void clockevents_handle_noop(struct cloc
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
 		list_move(&old->list, &clockevents_released);
 	}
 
 	if (new) {
-		BUG_ON(!clockevent_state_detached(new));
+		WARN_ON(!clockevent_state_detached(new));
 		clockevents_shutdown(new);
 	}
 }
 
 /**
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
+/**
  * clockevents_suspend - suspend clock devices
  */
 void clockevents_suspend(void)
@@ -650,7 +657,7 @@ void tick_cleanup_dead_cpu(int cpu)
 		if (cpumask_test_cpu(cpu, dev->cpumask) &&
 		    cpumask_weight(dev->cpumask) == 1 &&
 		    !tick_is_broadcast_device(dev)) {
-			BUG_ON(!clockevent_state_detached(dev));
+			WARN_ON(!clockevent_state_detached(dev));
 			list_del(&dev->list);
 		}
 	}
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -162,23 +162,31 @@ static bool tick_set_oneshot_wakeup_devi
  */
 void tick_install_broadcast_device(struct clock_event_device *dev, int cpu)
 {
-	struct clock_event_device *cur = tick_broadcast_device.evtdev;
+	struct clock_event_device *cur;
 
-	if (tick_set_oneshot_wakeup_device(dev, cpu))
-		return;
+	scoped_guard(raw_spinlock_irqsave, &tick_broadcast_lock) {
 
-	if (!tick_check_broadcast_device(cur, dev))
-		return;
+		if (tick_set_oneshot_wakeup_device(dev, cpu))
+			return;
 
-	if (!try_module_get(dev->owner))
-		return;
+		cur = tick_broadcast_device.evtdev;
+		if (!tick_check_broadcast_device(cur, dev))
+			return;
 
-	clockevents_exchange_device(cur, dev);
+		if (!try_module_get(dev->owner))
+			return;
+
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
 
 	if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
 		return;
@@ -1209,7 +1217,7 @@ int tick_broadcast_oneshot_active(void)
  */
 bool tick_broadcast_oneshot_available(void)
 {
-	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+	struct clock_event_device *bc = READ_ONCE(tick_broadcast_device.evtdev);
 
 	return bc ? bc->features & CLOCK_EVT_FEAT_ONESHOT : false;
 }
@@ -1217,7 +1225,7 @@ bool tick_broadcast_oneshot_available(vo
 #else
 int __tick_broadcast_oneshot_control(enum tick_broadcast_state state)
 {
-	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+	struct clock_event_device *bc = READ_ONCE(tick_broadcast_device.evtdev);
 
 	if (!bc || (bc->features & CLOCK_EVT_FEAT_HRTIMER))
 		return -EBUSY;
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -48,6 +48,8 @@ static inline void clockevent_set_state(
 }
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
+extern void __clockevents_exchange_device(struct clock_event_device *old,
+					  struct clock_event_device *new);
 extern void clockevents_exchange_device(struct clock_event_device *old,
 					struct clock_event_device *new);
 extern void clockevents_switch_state(struct clock_event_device *dev,


