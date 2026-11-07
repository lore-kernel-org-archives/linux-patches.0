Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061354;
	b=uBIPfNn9mzeDSd6/2flhHMTHgSiix8bb0KeS/H7ID2ksE+LhnSAlmxPOO0R6S4APGG53
	 qxWs+lpfIjm1LxPvN7caRJMRd0eO/QGI5agTNkI71tp9mcj+BwRu4ys87HDw9pXWyXfy5
	 9JhcI1nW49u2eSohgHIpNCrDYN6e/XUHHqbLWCd1umUJjdROANvUhrYCbNb1bSIfgCLJ3
	 pemnPS/VUUNnsYQH+ggBfwoNnF+FHz2RN9OUGC8Hx3vV04sXqHSblEyuCFLf3SUns27dk
	 5R5aBdl11dObBXkJg3dambgaOrbLzFzdGpC98qLO4RRIai3hVCoztYAPshKbo57LLrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=216aNOqJ97QUl3mCpOloAf3oMskJLFhrwxVE4Ac3hHQ=;
	b=jRZvpKzoGKthRgYGIr4v1cQKNEWu+XbitZ3zLFczms1uHzGh75OFChDOhBpCPHZ1laMP
	 JfTODKfteh/HBFBkqlDWi7jYKyBexlL+l16Nugj6mV+2bpDXJ47i22iBDOZl15j4oS6b6
	 1WyXugH7zKAT6PjxXI8ePL+KNx6P2TJDNWUKE7r5hJLMsbnZyv812Po4AoAswHfNw09i9
	 wlRM1pRzKcPt66IdcqBr7y3ZvFJWOOxB/t8gUACBl8DgUcYtvXlnlS8rNr08u95T2+yh9
	 SI7thI3H7Zlx5c09ZSYdcjM/DbhnfZ2JfNIWR+5kq7fvF2OzleOyctZkYR7MyM7Yoxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GW9QAth2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF28606A326;
	Sat,  7 Nov 2026 14:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GW9QAth2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA5E1F0089F;
	Sat,  7 Nov 2026 14:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061354;
	bh=216aNOqJ97QUl3mCpOloAf3oMskJLFhrwxVE4Ac3hHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GW9QAth2jqP+/9t7awMyoDw3ts6PMRImoblsHtJdyQe0/hCVOx0VVXmbSVn+qmCQn
	 BS2AS8yMAJm6X+d/B4Ri/KlLojxqfVqo/wdptH5xD/1uZBpT09jn94OeNSYbEapvda
	 X00IEC9EXYmR5YASfk5PMiDNkHGMZ/WQojLnLRyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Kyle Zeng <kylebot@openai.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0481/1536] futex: Sanitize and document task_struct::futex::state transitions
Date: Sat,  7 Nov 2026 08:41:37 -0500
Message-ID: <20261107135011.001587649@linuxfoundation.org>
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
[ sashal: Adapted to the older field names tsk->futex_state and futex_exit_mutex instead of tsk->futex.state and futex::exit_mutex, with context adjusted for the missing private-mm check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/core.c |   8 ++--
 kernel/futex/pi.c   | 100 +++++++++++++++++++++++++++++++-------------
 2 files changed, 73 insertions(+), 35 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index fa6ea7e235b13..c2e3a30fc86ed 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1142,11 +1142,9 @@ static void futex_cleanup_begin(struct task_struct *tsk)
 
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
index 258faa26e6f9d..7c015d928bd84 100644
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -193,6 +193,48 @@ void put_pi_state(struct futex_pi_state *pi_state)
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
@@ -318,18 +360,10 @@ static int attach_to_pi_state(u32 __user *uaddr, u32 uval,
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
@@ -426,7 +460,7 @@ static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
 		return -EAGAIN;
 	p = find_get_task_by_vpid(pid);
 	if (!p)
-		return handle_exit_race(uaddr, uval, NULL);
+		return handle_exit_race(uaddr, uval);
 
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		put_task_struct(p);
@@ -434,33 +468,39 @@ static int attach_to_pi_owner(u32 __user *uaddr, u32 uval, union futex_key *key,
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
 		/*
-		 * The task is on the way out. When the futex state is
-		 * FUTEX_STATE_DEAD, we know that the task has finished
-		 * the cleanup:
+		 * The task is on the way out. When state is FUTEX_STATE_EXITING
+		 * the cleanup is in progress. To avoid a live lock when the
+		 * waiter preempted the owner, store the task pointer in
+		 * @exiting and keep the reference on the task. The calling code
+		 * will drop all locks, block on @p::futex_exit_mutex and wait
+		 * for the owner to finish the cleanup. Once the owner released
+		 * the mutex the waiter drops the reference count and
+		 * re-evaluates the situation.
 		 */
-		int ret = handle_exit_race(uaddr, uval, p);
+		if (p->futex_state == FUTEX_STATE_EXITING) {
+			raw_spin_unlock_irq(&p->pi_lock);
+			*exiting = p;
+			return -EBUSY;
+		}
+
+		int ret = handle_exit_race(uaddr, uval);
 
 		raw_spin_unlock_irq(&p->pi_lock);
-		/*
-		 * If the owner task is between FUTEX_STATE_EXITING and
-		 * FUTEX_STATE_DEAD then store the task pointer and keep
-		 * the reference on the task struct. The calling code will
-		 * drop all locks, wait for the task to reach
-		 * FUTEX_STATE_DEAD and then drop the refcount. This is
-		 * required to prevent a live lock when the current task
-		 * preempted the exiting task between the two states.
-		 */
-		if (ret == -EBUSY)
-			*exiting = p;
-		else
-			put_task_struct(p);
+		put_task_struct(p);
 		return ret;
 	}
 
-- 
2.53.0



