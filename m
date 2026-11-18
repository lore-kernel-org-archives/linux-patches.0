Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034540;
	b=U1ueqTzC28ASEJ50Li/8YgjL8sI3zSdGS0BdDOIm804kPdSZ08cC/aEzzPDBwwm2WG0/
	 BnBly7E3ohXi5e7wSJ9XHtbQ2jnWn5eiTIpClRc2n76dJ1Z8EFbaCKamndkMDd4Zdg+Hb
	 zgU6Ceu/PMF6rJJoyi+f9Yp35a+mS4RnAy0lLL6i3ChSWCc6gqsouePsIy34NDdUiQ5Sv
	 VtIafSLrbSCypQ3PMaeL8jcatylQ8T2C/XkzFzUdRwl7WdJVr5of6sWyOur98383I48DH
	 KUbc1e2rsT9bNeCTNB1xr4OslTtMyXDk5yUH8fPVt7O8WlHMG7rJ6dowgxxF9bW0f0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KYon4tTnz8nXKkMid6KH99gZO02tr5Met0Bu2ZMHFQM=;
	b=ffnobGJ3vxxHGX6jRnAHMUZePI/HSKNJFzDwrDLRo82sG6lQoZMRd+3FIpQJvAvoAWsz
	 H27nYtq+4TyNGHZWCuZbFmRAr1OpNvjG233p+UZA1PwGgMycL7Z6AI5LhnE97LykWHsJf
	 v8LPfQPDtmoJfQaeXhHLiL+MoF6ypn07QPLPU94HaQZg//37utFweSYHUyVo2EYCrEUJe
	 Aho6AEH1/fI09i44u0YPPOKZWhbojI00563eFEI0tt2RSob2SlcLnV7T4oHrbJBKQRpXA
	 Pcdia6bjvsSMI27dwkKDX0EsCkuEOo7kVpsoQd9yFMVQNf+9Rm0YVxNqHHjFz/oOHHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xaxUqhBx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67667606A337;
	Wed, 18 Nov 2026 20:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xaxUqhBx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EB71F000C4;
	Wed, 18 Nov 2026 20:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034540;
	bh=KYon4tTnz8nXKkMid6KH99gZO02tr5Met0Bu2ZMHFQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xaxUqhBxilS8SXT9pRIIF4PaDFSV82BPCdu3oPjmuKeZrAwkanlyqDl6rRIRMM8Yi
	 68DdzEq/tG/FUcmw2ywr3k3YTKfmUsA3SM7Db0IXsASpXnzoEwy8Pv0eNUHhN66Yfn
	 ztlpHznOqKqjqvkgK0mn0W6kT0VplQ2O7WOyKYsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Kyle Zeng <kylebot@openai.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0406/3318] futex: Sanitize and document task_struct::futex::state transitions
Date: Wed, 18 Nov 2026 15:17:08 +0100
Message-ID: <20261118150328.636053842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit f9ece060cc43eae8a1f148737d193ba0d07b8f88 ]

The futex state is used to prevent a waiter from attaching to the lock
owner while the owner runs the futex cleanup in exit() or exec().

Only the state transition from FUTEX_STATE_OK to FUTEX_STATE_EXITING must
be done with the task's pi_lock held, the transition away from
FUTEX_STATE_EXITING has no serialization requirements on the writer side,
but it's completely non obvious why. It's magically protected by
exit_pi_state(), which operates under tsk::pi_lock, as that's the state
which has to be correct when the waiter observes the new state.

OTOH, taking the pi_lock in futex_cleanup_end() is not a performance issue
because at that point the lock should be uncontended in the vast majority
of cases.

Aside of that the handling of FUTEX_STATE_EXITING in attach_to_pi_owner()
and handle_exit_race() is confusing at best.

Protect the store in futex_cleanup_end() with tsk::pi_lock, handle
FUTEX_STATE_EXITING in attach_to_pi_owner() explicitly and document how
this is supposed to work.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
[ sashal: Adapted to flat futex_state/futex_exit_mutex task fields, dropped the unrelated mm-check hunk, and declared ret at the top of the block to avoid a declaration-after-statement warning. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/core.c |   8 ++--
 kernel/futex/pi.c   | 102 +++++++++++++++++++++++++++++++-------------
 2 files changed, 75 insertions(+), 35 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 8fb54800ce0ad..a3846009d2a55 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1126,11 +1126,9 @@ static void futex_cleanup_begin(struct task_struct *tsk)
 
 static void futex_cleanup_end(struct task_struct *tsk, int state)
 {
-	/*
-	 * Lockless store. The only side effect is that an observer might
-	 * take another loop until it becomes visible.
-	 */
-	tsk->futex_state = state;
+	scoped_guard(raw_spinlock_irq, &tsk->pi_lock)
+		tsk->futex_state = state;
+
 	/*
 	 * Drop the exit protection. This unblocks waiters which observed
 	 * FUTEX_STATE_EXITING to reevaluate the state.
diff --git a/kernel/futex/pi.c b/kernel/futex/pi.c
index 9496084b6dcd8..0f694b1a49cfc 100644
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -192,6 +192,48 @@ void put_pi_state(struct futex_pi_state *pi_state)
  *     pi_mutex->wait_lock
  *       p->pi_lock
  *
+ * Futex kernel state:
+ *
+ * The kernel tracks the task state in p::futex_state to protect against exit()
+ * and exec(). The states are:
+ *
+ * - FUTEX_STATE_OK when the task is alive and waiters can be attached
+ *
+ * - FUTEX_STATE_EXITING when the task cleans up the robust list and pi
+ *   state. Concurrent waiters cannot attach anymore and have to wait until the
+ *   cleanup is finished to re-evaluate the potential changes of robust list and
+ *   pi state cleanups.
+ *
+ * - FUTEX_STATE_DEAD when the task has cleaned up the robust list and
+ *   is about to fully exit.
+ *
+ * exec() switches back to FUTEX_STATE_OK after the cleanup.
+ *
+ * The state has two related locks:
+ *
+ * 1) p::pi_lock
+ *
+ *    p::pi_lock has to be taken by the waiter when evaluating the state to
+ *    protect against a concurrent exit/exec cleanup by the owner. If the state
+ *    is OK then the waiter can be attached to the owner while still holding
+ *    pi_lock.
+ *
+ *    The cleanup code has to hold it for all state transitions to ensure that
+ *    the stores to the state cannot be reordered against previous stores on
+ *    which the waiter correctness depends on.
+ *
+ * 2) p::futex_exit_mutex
+ *
+ *    The mutex is acquired when the cleanup starts and released at the end. It
+ *    obviously is not serializing the owner's cleanup against itself. It is
+ *    used to avoid a live lock caused by a waiter preempting the owner's
+ *    cleanup. Such a waiter would busy loop forever waiting for the owner to
+ *    finish the cleanup.
+ *
+ *    To prevent this, waiters have to drop all locks when observing
+ *    FUTEX_STATE_EXITING and block on the mutex. When the owner releases the
+ *    mutex after finishing the cleanup the waiters make progress and
+ *    re-evaluate the situation.
  */
 
 /*
@@ -317,18 +359,10 @@ static int attach_to_pi_state(u32 __user *uaddr, u32 uval,
 	return ret;
 }
 
-static int handle_exit_race(u32 __user *uaddr, u32 uval,
-			    struct task_struct *tsk)
+static int handle_exit_race(u32 __user *uaddr, u32 uval)
 {
 	u32 uval2;
 
-	/*
-	 * If the futex exit state is not yet FUTEX_STATE_DEAD, tell the
-	 * caller that the alleged owner is busy.
-	 */
-	if (tsk && tsk->futex_state != FUTEX_STATE_DEAD)
-		return -EBUSY;
-
 	/*
 	 * Reread the user space value to handle the following situation:
 	 *
@@ -425,7 +459,7 @@ static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
 		return -EAGAIN;
 	p = find_get_task_by_vpid(pid);
 	if (!p)
-		return handle_exit_race(uaddr, uval, NULL);
+		return handle_exit_race(uaddr, uval);
 
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		put_task_struct(p);
@@ -433,33 +467,41 @@ static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
 	}
 
 	/*
-	 * We need to look at the task state to figure out, whether the
-	 * task is exiting. To protect against the change of the task state
-	 * in futex_exit_release(), we do this protected by p->pi_lock:
+	 * We need to look at the task state to figure out whether the task is
+	 * exiting. To protect against the change of the task state from
+	 * FUTEX_STATE_OK to FUTEX_STATE_EXISTING in futex_cleanup_begin() it is
+	 * required to do this protected by p->pi_lock, which prevents the owner
+	 * from concurrently starting the exit cleanup.
+	 *
+	 * If the state is FUTEX_STATE_OK pi_lock must be held until the waiter
+	 * is attached to protect against a concurrent exit()/exec().
 	 */
 	raw_spin_lock_irq(&p->pi_lock);
+
+	/* Validate that the task is ready for futex operations. */
 	if (unlikely(p->futex_state != FUTEX_STATE_OK)) {
-		/*
-		 * The task is on the way out. When the futex state is
-		 * FUTEX_STATE_DEAD, we know that the task has finished
-		 * the cleanup:
-		 */
-		int ret = handle_exit_race(uaddr, uval, p);
+		int ret;
 
-		raw_spin_unlock_irq(&p->pi_lock);
 		/*
-		 * If the owner task is between FUTEX_STATE_EXITING and
-		 * FUTEX_STATE_DEAD then store the task pointer and keep
-		 * the reference on the task struct. The calling code will
-		 * drop all locks, wait for the task to reach
-		 * FUTEX_STATE_DEAD and then drop the refcount. This is
-		 * required to prevent a live lock when the current task
-		 * preempted the exiting task between the two states.
+		 * The task is on the way out. When state is FUTEX_STATE_EXITING
+		 * the cleanup is in progress. To avoid a live lock when the
+		 * waiter preempted the owner, store the task pointer in
+		 * @exiting and keep the reference on the task. The calling code
+		 * will drop all locks, block on @p::futex_exit_mutex and wait
+		 * for the owner to finish the cleanup. Once the owner released
+		 * the mutex the waiter drops the reference count and
+		 * re-evaluates the situation.
 		 */
-		if (ret == -EBUSY)
+		if (p->futex_state == FUTEX_STATE_EXITING) {
+			raw_spin_unlock_irq(&p->pi_lock);
 			*exiting = p;
-		else
-			put_task_struct(p);
+			return -EBUSY;
+		}
+
+		ret = handle_exit_race(uaddr, uval);
+
+		raw_spin_unlock_irq(&p->pi_lock);
+		put_task_struct(p);
 		return ret;
 	}
 
-- 
2.53.0



