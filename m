Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BAC4E3258;
	Wed, 30 Sep 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783826; cv=none; b=Cefi6p9rKdz0BY5Ir1Vib4VzKmzakMcpzhabyuSGZhUe6Qa24wgQfsJbWYfDxebt3CmReqVK5Pz5Rilmw6cjamT4o3ZspbNK+oGkeZJPC+YmYd0Tg+Pdx/2b5tiS4seonB0f7W1rmSKxlWxMZY1kQRii5w84TimKQcxjVNZI28w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783826; c=relaxed/simple;
	bh=kI0PPfOCnVTtRKcctaqG0G5kDfkE/Kbid+ihgrtE6D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzBc9ib4CwI4u/2pWkTCC5ZShDOSu81rB1ORux7Cd0qvSTLDcQckXLCctAXF58EcBtVGmQnlry6OfaDAuIlk+rxhKzji7y+Uw1mJCoq2Rbm8N9ujBmwg0NyFZHbk/S3pDWt0bYDhh9tJjI16gvQFCGf1BWz6lNQa3fzY8XDlTQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljBIDS7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljBIDS7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C169B1F00898;
	Wed, 30 Sep 2026 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783821;
	bh=kHOHVfbAtMIAV8Q+zpgmQNsvvEw5uHeAuqbYs3uO1js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljBIDS7l3wmdLI+uwXrN0TGX+SMkrr5KcMy5FLIA4ICXLuuq+MJ871mmXdkxxfO9M
	 /hinT6aVxWpteVAfs4KmebCl2og91XKP3ffIwKH+w55jT3mx1fzI66zQDHWbBkCvJV
	 /IzNnFepyLSaIlDmXZgSr9ILUKm1TGq5j9s4xG60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 533/595] hrtimers: Add missing hrtimer_init() trace points
Date: Wed, 30 Sep 2026 17:27:06 +0200
Message-ID: <20260930152359.172046709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit fbf920f255315974808ce91d934fe50198294d51 ]

hrtimer_init*_on_stack() is not covered by tracing when
CONFIG_DEBUG_OBJECTS_TIMERS=y.

Rework the functions similar to hrtimer_init() and hrtimer_init_sleeper()
so that the hrtimer_init() tracepoint is unconditionally available.

The rework makes hrtimer_init_sleeper() unused. Delete it.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/74528e8abf2bb96e8bee85ffacbf14e15cf89f0d.1730386209.git.namcao@linutronix.de
Stable-dep-of: cfa165cbfbed ("net/sched: act_gate: budget the per-entry list in get_fill_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hrtimer.h | 19 +-----------
 kernel/time/hrtimer.c   | 65 +++++++++++++++++++++++------------------
 2 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index b86bd4fe22e0a..2623294e25fbd 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -372,32 +372,15 @@ static inline void hrtimer_cancel_wait_running(struct hrtimer *timer)
 /* Initialize timers: */
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
-extern void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, clockid_t clock_id,
-				 enum hrtimer_mode mode);
-
-#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_clock,
 				  enum hrtimer_mode mode);
 extern void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
 					  clockid_t clock_id,
 					  enum hrtimer_mode mode);
 
+#ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void destroy_hrtimer_on_stack(struct hrtimer *timer);
 #else
-static inline void hrtimer_init_on_stack(struct hrtimer *timer,
-					 clockid_t which_clock,
-					 enum hrtimer_mode mode)
-{
-	hrtimer_init(timer, which_clock, mode);
-}
-
-static inline void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
-						 clockid_t clock_id,
-						 enum hrtimer_mode mode)
-{
-	hrtimer_init_sleeper(sl, clock_id, mode);
-}
-
 static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
 #endif
 
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index cf928eb8f2f8d..51cea4af249ee 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -404,6 +404,11 @@ static inline void debug_hrtimer_init(struct hrtimer *timer)
 	debug_object_init(timer, &hrtimer_debug_descr);
 }
 
+static inline void debug_hrtimer_init_on_stack(struct hrtimer *timer)
+{
+	debug_object_init_on_stack(timer, &hrtimer_debug_descr);
+}
+
 static inline void debug_hrtimer_activate(struct hrtimer *timer,
 					  enum hrtimer_mode mode)
 {
@@ -415,28 +420,6 @@ static inline void debug_hrtimer_deactivate(struct hrtimer *timer)
 	debug_object_deactivate(timer, &hrtimer_debug_descr);
 }
 
-static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
-			   enum hrtimer_mode mode);
-
-void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
-			   enum hrtimer_mode mode)
-{
-	debug_object_init_on_stack(timer, &hrtimer_debug_descr);
-	__hrtimer_init(timer, clock_id, mode);
-}
-EXPORT_SYMBOL_GPL(hrtimer_init_on_stack);
-
-static void __hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
-				   clockid_t clock_id, enum hrtimer_mode mode);
-
-void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
-				   clockid_t clock_id, enum hrtimer_mode mode)
-{
-	debug_object_init_on_stack(&sl->timer, &hrtimer_debug_descr);
-	__hrtimer_init_sleeper(sl, clock_id, mode);
-}
-EXPORT_SYMBOL_GPL(hrtimer_init_sleeper_on_stack);
-
 void destroy_hrtimer_on_stack(struct hrtimer *timer)
 {
 	debug_object_free(timer, &hrtimer_debug_descr);
@@ -446,6 +429,7 @@ EXPORT_SYMBOL_GPL(destroy_hrtimer_on_stack);
 #else
 
 static inline void debug_hrtimer_init(struct hrtimer *timer) { }
+static inline void debug_hrtimer_init_on_stack(struct hrtimer *timer) { }
 static inline void debug_hrtimer_activate(struct hrtimer *timer,
 					  enum hrtimer_mode mode) { }
 static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
@@ -459,6 +443,13 @@ debug_init(struct hrtimer *timer, clockid_t clockid,
 	trace_hrtimer_init(timer, clockid, mode);
 }
 
+static inline void debug_init_on_stack(struct hrtimer *timer, clockid_t clockid,
+				       enum hrtimer_mode mode)
+{
+	debug_hrtimer_init_on_stack(timer);
+	trace_hrtimer_init(timer, clockid, mode);
+}
+
 static inline void debug_activate(struct hrtimer *timer,
 				  enum hrtimer_mode mode)
 {
@@ -1497,6 +1488,23 @@ void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
+/**
+ * hrtimer_init_on_stack - initialize a timer in stack memory
+ * @timer:	The timer to be initialized
+ * @clock_id:	The clock to be used
+ * @mode:       The timer mode
+ *
+ * Similar to hrtimer_init(), except that this one must be used if struct hrtimer is in stack
+ * memory.
+ */
+void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
+			   enum hrtimer_mode mode)
+{
+	debug_init_on_stack(timer, clock_id, mode);
+	__hrtimer_init(timer, clock_id, mode);
+}
+EXPORT_SYMBOL_GPL(hrtimer_init_on_stack);
+
 /*
  * A timer is active, when it is enqueued into the rbtree or the
  * callback function is running or it's in the state of being migrated
@@ -1859,7 +1867,7 @@ void hrtimer_sleeper_start_expires(struct hrtimer_sleeper *sl,
 	 * Make the enqueue delivery mode check work on RT. If the sleeper
 	 * was initialized for hard interrupt delivery, force the mode bit.
 	 * This is a special case for hrtimer_sleepers because
-	 * hrtimer_init_sleeper() determines the delivery mode on RT so the
+	 * __hrtimer_init_sleeper() determines the delivery mode on RT so the
 	 * fiddling with this decision is avoided at the call sites.
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && sl->timer.is_hard)
@@ -1902,19 +1910,18 @@ static void __hrtimer_init_sleeper(struct hrtimer_sleeper *sl,
 }
 
 /**
- * hrtimer_init_sleeper - initialize sleeper to the given clock
+ * hrtimer_init_sleeper_on_stack - initialize a sleeper in stack memory
  * @sl:		sleeper to be initialized
  * @clock_id:	the clock to be used
  * @mode:	timer mode abs/rel
  */
-void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, clockid_t clock_id,
-			  enum hrtimer_mode mode)
+void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
+				   clockid_t clock_id, enum hrtimer_mode mode)
 {
-	debug_init(&sl->timer, clock_id, mode);
+	debug_init_on_stack(&sl->timer, clock_id, mode);
 	__hrtimer_init_sleeper(sl, clock_id, mode);
-
 }
-EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
+EXPORT_SYMBOL_GPL(hrtimer_init_sleeper_on_stack);
 
 int nanosleep_copyout(struct restart_block *restart, struct timespec64 *ts)
 {
-- 
2.53.0



