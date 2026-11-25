Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619010;
	b=P+Rfa3MMdHeJtteGj76KIsbk4ZNHEk+5BdSvPlMUmz/T4oF1Y6GesFon6ff6ZopUuB/l
	 X5pUQ5MKPcGLFn3Bhy8sa/QRJBL1f60NiA74zseCo2KWprdh9WeMVIRy3eFobZyyPXOSf
	 axhVL/Gymf3oKgqiQGUMEfecm4OtzAFPesXedCuGG48oAQcHPmNpFkesHH+7rSzMEuk8q
	 rLUvQkmul8nArl23IhABiiwE83vtQWlU0Xp+EJpSQmvNXiNwaKkSXKg347h1a3gcjjxMA
	 xwhU4F2WXIENJJA2s85HDkYiRqBAlrvpf6ZQIw36mRxMFbdPToEeNQSGv4GA9Im3ymw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=srIootTGKgAwNECZfD7IlQYTL99/Vg9ovZ5Nu7zphWI=;
	b=KVA37w5GHxBtkzUOjsL3HRyF3FhZvRepr8MTeN3lHTkpQTC178ukVCeeOFbr39lDYAcE
	 kcEriwAs1kO8GaMDxmCV3iQFrE4ju5+9uWc1k1+QklR+AlD22J72yX9xLfVYkKfP+mU+o
	 L9W8y6LgvbSmI/RhlZzaYgzDh91OfG2ShZkicj6q2syLlMtk8qvJNhK1f6kEEB9TYXzkY
	 +n6UX6CCKDsw8fUpFlUQ6AGIScvPoNMRRtWv36RmNNPXMsurdXaLAg/h2HCE/ur9piubU
	 64e2K/7fEJzbgtVcVnITGYxCw3ApRqLWBA1Fkes2uYfoO1w3SDttvy8JtQ27pFdB5qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJxwN2iM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAA9606A31E;
	Wed, 25 Nov 2026 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJxwN2iM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B69F1F000C4;
	Wed, 25 Nov 2026 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619010;
	bh=srIootTGKgAwNECZfD7IlQYTL99/Vg9ovZ5Nu7zphWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJxwN2iMUzkGM9Vd9UCTOb2D4nR7aKVsb6UX/GOVGIF35XbsMvyp9Uvf5YFxYuCI0
	 7VatjU8NN8TCvQD8BXSXZ7NcglXkRJilvdpy3VeeheH+ftgDJ1kst+8dd38mPpvfrE
	 ntIktUz8V8NDDD6eFnetseS3KkMrx32NgMmtTiyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagmeet Randhawa <jagmeet.randhawa@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0405/1005] drm/xe/guc: Fix race around q->guc->suspend_pending access
Date: Wed, 25 Nov 2026 15:29:03 +0100
Message-ID: <20261125143831.239450170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagmeet Randhawa <jagmeet.randhawa@intel.com>

[ Upstream commit a869bd4d65bc131082568743418b3876c46c3b7b ]

q->guc->suspend_pending is accessed without any common lock.
__suspend_fence_signal(), called from guc_exec_queue_kill() and the
suspend-timeout ban path, clears the flag asynchronously. Meanwhile
handle_sched_done(), guc_exec_queue_stop() and
__guc_exec_queue_process_msg_suspend() check the flag and then call
suspend_fence_signal(), which asserts that it is still set.

As the check and suspend_fence_signal() are not atomic, the clear can
land in between and trip the xe_gt_assert(q->guc->suspend_pending).

Rather than serializing those clears, drop them. Signalling the suspend
fence from kill or from the suspend-timeout ban completes a suspend while
the queue may still be executing on the hardware, so neither is a valid
place to do it. Split the wake up out of __suspend_fence_signal() into
suspend_wait_wake() and use that in guc_exec_queue_kill(), so a waiter
still observes the killed state immediately rather than waiting out the
full timeout - guc_exec_queue_wait_suspend_done() already breaks on
exec_queue_killed(). The suspend-timeout ban needs no wake at all, as the
waiter that timed out is its caller.

suspend_pending now stays set on a killed or banned queue until it is
torn down, so relax the !suspend_pending assert in
__guc_exec_queue_resume() to permit that state.

handle_sched_done() and guc_exec_queue_stop() can still race with each
other, so take the per-queue msg_lock, which already covers the set on
the suspend path, across their check-then-act. In handle_sched_done() the
flag is snapshotted under the lock and deregister_exec_queue() is kept
outside it. __guc_exec_queue_process_msg_suspend() is left unlocked: it
runs on the scheduler message worker, which guc_exec_queue_stop() parks
via xe_sched_submission_stop() before touching the flag.

v2: Document that sched->msg_lock also protects
    guc->suspend_pending, which indicates a suspend message is in
    flight, in addition to the sched->msgs list (Niranjana)

v3: Drop __suspend_fence_signal() from guc_exec_queue_kill() and
    guc_exec_queue_suspend_timeout_ban() rather than serializing them
    with msg_lock, keeping only the wake up in kill and guarding the
    !suspend_pending assert in resume (Matthew, Niranjana)

Signed-off-by: Jagmeet Randhawa <jagmeet.randhawa@intel.com>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260902201222.30022-1-jagmeet.randhawa@intel.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Stable-dep-of: eb1f465e9119 ("drm/xe/guc: Do not attribute a TDR disable to a pending suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gpu_scheduler_types.h  |  5 +-
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h |  5 +-
 drivers/gpu/drm/xe/xe_guc_submit.c           | 58 ++++++++++++++------
 3 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gpu_scheduler_types.h b/drivers/gpu/drm/xe/xe_gpu_scheduler_types.h
index 63d9bf92583c5..78ef2e8ded4f3 100644
--- a/drivers/gpu/drm/xe/xe_gpu_scheduler_types.h
+++ b/drivers/gpu/drm/xe/xe_gpu_scheduler_types.h
@@ -47,7 +47,10 @@ struct xe_gpu_scheduler {
 	const struct xe_sched_backend_ops	*ops;
 	/** @msgs: list of messages to be processed in @work_process_msg */
 	struct list_head			msgs;
-	/** @msg_lock: Message lock */
+	/**
+	 * @msg_lock: Protects @msgs and guc->suspend_pending (indicates a
+	 * suspend message is in flight) of exec queues on this scheduler.
+	 */
 	spinlock_t				msg_lock;
 	/** @work_process_msg: processes messages */
 	struct work_struct		work_process_msg;
diff --git a/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h b/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
index acdc24d1a6bd2..64ea57cceb6ff 100644
--- a/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_exec_queue_types.h
@@ -52,7 +52,10 @@ struct xe_guc_exec_queue {
 	u16 id;
 	/** @suspend_wait: wait queue used to wait on pending suspends */
 	wait_queue_head_t suspend_wait;
-	/** @suspend_pending: a suspend of the exec_queue is pending */
+	/**
+	 * @suspend_pending: a suspend of the exec_queue is pending.
+	 * Protected by @sched.msg_lock.
+	 */
 	bool suspend_pending;
 	/**
 	 * @suspend_count: Reference count of active suspend requests. The
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index bdaec10c6d197..e80291cdf0edc 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1854,16 +1854,11 @@ static void __guc_exec_queue_process_msg_set_sched_props(struct xe_sched_msg *ms
 	kfree(msg);
 }
 
-static void __suspend_fence_signal(struct xe_exec_queue *q)
+static void suspend_wait_wake(struct xe_exec_queue *q)
 {
 	struct xe_guc *guc = exec_queue_to_guc(q);
 	struct xe_device *xe = guc_to_xe(guc);
 
-	if (!q->guc->suspend_pending)
-		return;
-
-	WRITE_ONCE(q->guc->suspend_pending, false);
-
 	/*
 	 * We use a GuC shared wait queue for VFs because the VF resfix start
 	 * interrupt must be able to wake all instances of suspend_wait. This
@@ -1876,6 +1871,15 @@ static void __suspend_fence_signal(struct xe_exec_queue *q)
 		wake_up(&q->guc->suspend_wait);
 }
 
+static void __suspend_fence_signal(struct xe_exec_queue *q)
+{
+	if (!q->guc->suspend_pending)
+		return;
+
+	WRITE_ONCE(q->guc->suspend_pending, false);
+	suspend_wait_wake(q);
+}
+
 static void suspend_fence_signal(struct xe_exec_queue *q)
 {
 	struct xe_guc *guc = exec_queue_to_guc(q);
@@ -2096,7 +2100,13 @@ static void guc_exec_queue_kill(struct xe_exec_queue *q)
 {
 	trace_xe_exec_queue_kill(q);
 	set_exec_queue_killed(q);
-	__suspend_fence_signal(q);
+	/*
+	 * Do not signal the suspend fence here, the queue may still be running
+	 * on the hardware. Only wake any suspend waiter so it observes the
+	 * killed state instead of waiting out the full timeout, suspend_pending
+	 * stays set until the queue is torn down.
+	 */
+	suspend_wait_wake(q);
 	xe_guc_exec_queue_trigger_cleanup(q);
 }
 
@@ -2278,7 +2288,12 @@ static bool __guc_exec_queue_resume(struct xe_exec_queue *q)
 	bool last;
 
 	xe_sched_msg_lock(sched);
-	xe_gt_assert(guc_to_gt(guc), !ge->suspend_pending);
+	/*
+	 * A killed, banned or wedged queue keeps suspend_pending set until it
+	 * is torn down, so only assert the flag is clear otherwise.
+	 */
+	xe_gt_assert(guc_to_gt(guc), !ge->suspend_pending ||
+		     exec_queue_killed_or_banned_or_wedged(q));
 	xe_gt_assert(guc_to_gt(guc), ge->suspend_count > 0);
 	last = (--ge->suspend_count == 0);
 	if (last) {
@@ -2348,8 +2363,10 @@ static void guc_exec_queue_suspend_timeout_ban(struct xe_exec_queue *q)
 	/*
 	 * The GuC failed to respond to the suspend within the timeout. This is
 	 * not recoverable for this context, so ban it and tear it down via
-	 * cleanup rather than leave it suspended forever. __suspend_fence_signal
-	 * clears suspend_pending and wakes any waiter.
+	 * cleanup rather than leave it suspended forever. The suspend fence is
+	 * not signalled here, the queue may still be running on the hardware,
+	 * so suspend_pending stays set until teardown. The waiter that timed
+	 * out is the caller, so no wake up is needed either.
 	 *
 	 * @q is the primary here; it owns the group's GuC context, so a failure
 	 * to suspend it wedges the whole group. Ban and tear down the entire
@@ -2357,11 +2374,9 @@ static void guc_exec_queue_suspend_timeout_ban(struct xe_exec_queue *q)
 	 */
 	if (xe_exec_queue_is_multi_queue(q)) {
 		set_exec_queue_group_banned(q);
-		__suspend_fence_signal(q);
 		xe_guc_exec_queue_group_trigger_cleanup(q);
 	} else {
 		set_exec_queue_banned(q);
-		__suspend_fence_signal(q);
 		xe_guc_exec_queue_trigger_cleanup(q);
 	}
 }
@@ -2384,9 +2399,9 @@ static int guc_exec_queue_wait_suspend_done(struct xe_exec_queue *q, bool blocki
 	int ret;
 
 	/*
-	 * Likely don't need to check exec_queue_killed() as we clear
-	 * suspend_pending upon kill but to be paranoid but races in which
-	 * suspend_pending is set after kill also check kill here.
+	 * A kill does not clear suspend_pending, the queue may still be running
+	 * on the hardware, so exec_queue_killed() is what ends the wait in that
+	 * case and the queue is torn down asynchronously.
 	 */
 #define WAIT_COND \
 	(!READ_ONCE(q->guc->suspend_pending) ||	exec_queue_killed(q) || \
@@ -2579,10 +2594,12 @@ static void guc_exec_queue_stop(struct xe_guc *guc, struct xe_exec_queue *q)
 		if (exec_queue_destroyed(q))
 			do_destroy = true;
 	}
+	xe_sched_msg_lock(sched);
 	if (q->guc->suspend_pending) {
 		set_exec_queue_suspended(q);
 		suspend_fence_signal(q);
 	}
+	xe_sched_msg_unlock(sched);
 	atomic_and(EXEC_QUEUE_STATE_WEDGED | EXEC_QUEUE_STATE_BANNED |
 		   EXEC_QUEUE_STATE_KILLED | EXEC_QUEUE_STATE_DESTROYED |
 		   EXEC_QUEUE_STATE_SUSPENDED,
@@ -3106,13 +3123,20 @@ static void handle_sched_done(struct xe_guc *guc, struct xe_exec_queue *q,
 		smp_wmb();
 		wake_up_all(&guc->ct.wq);
 	} else {
+		bool was_pending;
+
 		xe_gt_assert(guc_to_gt(guc), runnable_state == 0);
 		xe_gt_assert(guc_to_gt(guc), exec_queue_pending_disable(q));
 
-		if (q->guc->suspend_pending) {
+		xe_sched_msg_lock(&q->guc->sched);
+		was_pending = q->guc->suspend_pending;
+		if (was_pending) {
 			clear_exec_queue_pending_disable(q);
 			suspend_fence_signal(q);
-		} else {
+		}
+		xe_sched_msg_unlock(&q->guc->sched);
+
+		if (!was_pending) {
 			if (exec_queue_banned(q)) {
 				smp_wmb();
 				wake_up_all(&guc->ct.wq);
-- 
2.53.0



