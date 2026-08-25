Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F332E06E4;
	Tue, 25 Aug 2026 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665371; cv=none; b=dxrExMuiIep1UbB6NyS5i6fS7MAla/r8Ddeg9t44+IO4DqDPsC5RVPYfuDPtERt+ELkbCfn4cD1d7Y38cvnbRZS1akeQU5gA/Mfoqn26axoNnyFeiBAEtJXLndwLY/y8a/SRnkqPXj4i3wbTCs4oP+h6hz6eZoFyt+I8xFOSk0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665371; c=relaxed/simple;
	bh=Qn0pp4DXIxbRDXRV+j4MLg99A3dWrYygNaeQDQCRH0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaU2tVEtynzObDbYKzb6NsC6f4HsGco11b6G2AR582Em6VL02UErbc3hU6kI1Y0rDe+hYDONblQGkfQ81GfCNGOZ2tlLCXVQ1OYw4h3ek+Rv25qTMU956skel3Yu54wcPCzskCggGDOKCqNShZtsUNDDylza97gLgTkAVpfa9jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhcEacn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhcEacn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ED81F000E9;
	Tue, 25 Aug 2026 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665370;
	bh=D/ghgODgfgconBtUElfJjEoglWPM2nxyoewrDCGAGXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhcEacn2WXj8Qb+G6O+PV34AAeZS0QzfdBEmtBRD9sOW87ZUI0JoB7d2pEYPPZT8u
	 G+HFBoYIrXfJU9zI2qthoJ0UMlnVkFjA7rWXAf1UPMuZS27MsQQUJYjlr0sLJUqoAI
	 daPtfONwXUH85CcbN/2XAL3lcSoQwlJpHLI0DAPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	Kyle Zeng <kylebot@openai.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.18 77/94] futex/pi: Plug private futex exec() race
Date: Tue, 25 Aug 2026 15:26:13 +0200
Message-ID: <20260825132544.895078587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

commit c5f0bc9fd1cec4a00400cc727fcde03e0fde17cc upstream.

The check for private futexes whether the waiter's mm, which is stored in
the futex_key and copied into the pi_state, is the same as the owner's mm
is not sufficient for exec(). exec() has a gap where the mm check fails to
give the correct answer:

  exec()
  ...
    exec_release_mm()
      futex_exec_release()
        tsk::futex::exit_state = EXITING;
        cleanup_robust_list();
1)      tsk::futex::exit_state = OK;
    ...
    old_mm = tsk::mm;
2)  tsk::mm = ->mm;

Between #1 and #2 the check for the mm is wrong as that mm is about to be
swapped out and eventually freed.

Plug this gap by:

  1) Setting tsk::futex::exit_state to FUTEX_STATE_DEAD in
     futex_exec_release()

  2) Setting tsk::futex::exit_state to FUTEX_STATE_OK after
     the mm has been switched.

>>From a futex point of view the task is dead after it finished the robust
list cleanup up to the point where it sets the state to OK again.

Fixes: 80367ad01d93 ("futex: Add basic infrastructure for local task local hash")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c             |    8 +++++--
 include/linux/futex.h |    2 +
 kernel/futex/core.c   |   54 ++++++++++++++++++++++++++++++++++----------------
 kernel/futex/pi.c     |   22 ++++++++++++++------
 4 files changed, 61 insertions(+), 25 deletions(-)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
+#include <linux/futex.h>
 #include <linux/swap.h>
 #include <linux/string.h>
 #include <linux/init.h>
@@ -851,6 +852,7 @@ static int exec_mmap(struct mm_struct *m
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
+	/* Clean up futexes and release the mm */
 	exec_mm_release(tsk, old_mm);
 
 	ret = down_write_killable(&tsk->signal->exec_update_lock);
@@ -899,9 +901,11 @@ static int exec_mmap(struct mm_struct *m
 		setmax_mm_hiwater_rss(&tsk->signal->maxrss, old_mm);
 		mm_update_next_owner(old_mm);
 		mmput(old_mm);
-		return 0;
+	} else {
+		mmdrop_lazy_tlb(active_mm);
 	}
-	mmdrop_lazy_tlb(active_mm);
+
+	futex_exec_done(tsk);
 	return 0;
 }
 
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -77,6 +77,7 @@ static inline void futex_init_task(struc
 void futex_exit_recursive(struct task_struct *tsk);
 void futex_exit_release(struct task_struct *tsk);
 void futex_exec_release(struct task_struct *tsk);
+void futex_exec_done(struct task_struct *tsk);
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
@@ -98,6 +99,7 @@ static inline void futex_init_task(struc
 static inline void futex_exit_recursive(struct task_struct *tsk) { }
 static inline void futex_exit_release(struct task_struct *tsk) { }
 static inline void futex_exec_release(struct task_struct *tsk) { }
+static inline void futex_exec_done(struct task_struct *tsk) { }
 static inline long do_futex(u32 __user *uaddr, int op, u32 val,
 			    ktime_t *timeout, u32 __user *uaddr2,
 			    u32 val2, u32 val3)
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1496,10 +1496,10 @@ static void futex_cleanup_begin(struct t
 	raw_spin_unlock_irq(&tsk->pi_lock);
 }
 
-static void futex_cleanup_end(struct task_struct *tsk, int state)
+static void futex_cleanup_end(struct task_struct *tsk)
 {
 	scoped_guard(raw_spinlock_irq, &tsk->pi_lock)
-		tsk->futex_state = state;
+		tsk->futex_state = FUTEX_STATE_DEAD;
 
 	/*
 	 * Drop the exit protection. This unblocks waiters which observed
@@ -1508,29 +1508,49 @@ static void futex_cleanup_end(struct tas
 	mutex_unlock(&tsk->futex_exit_mutex);
 }
 
-void futex_exec_release(struct task_struct *tsk)
+void futex_exit_release(struct task_struct *tsk)
 {
-	/*
-	 * The state handling is done for consistency, but in the case of
-	 * exec() there is no way to prevent further damage as the PID stays
-	 * the same. But for the unlikely and arguably buggy case that a
-	 * futex is held on exec(), this provides at least as much state
-	 * consistency protection which is possible.
-	 */
 	futex_cleanup_begin(tsk);
 	futex_cleanup(tsk);
+	futex_cleanup_end(tsk);
+}
+
+void futex_exec_release(struct task_struct *tsk)
+{
 	/*
-	 * Reset the state to FUTEX_STATE_OK. The task is alive and about
-	 * exec a new binary.
+	 * exec() makes it interesting for futexes because the TID of the task
+	 * stays the same, but from a futex perspective the task has to be
+	 * treated like an exiting task. This is especially important for the
+	 * sanity check for private futexes in attach_to_pi_owner() which
+	 * compares the owner's mm with the waiter's mm.
+	 *
+	 * That check would give the wrong answer if futex_cleanup_end() would
+	 * set the state to FUTEX_STATE_OK as long as the task still has the old
+	 * mm.
+	 *
+	 * After the task has switched to the new mm it sets it to
+	 * FUTEX_STATE_OK again in futex_exec_done().
 	 */
-	futex_cleanup_end(tsk, FUTEX_STATE_OK);
+	futex_exit_release(tsk);
 }
 
-void futex_exit_release(struct task_struct *tsk)
+/*
+ * exec() has switched to the new mm. Futex operations are safe again.
+ */
+void futex_exec_done(struct task_struct *tsk)
 {
-	futex_cleanup_begin(tsk);
-	futex_cleanup(tsk);
-	futex_cleanup_end(tsk, FUTEX_STATE_DEAD);
+	/*
+	 * This store does not have to take tsk::futex::exit_mutex because the
+	 * phase where waiters block on it during state FUTEX_STATE_EXITING has
+	 * been finished when futex_cleanup_end() set the state to
+	 * FUTEX_STATE_DEAD.
+	 *
+	 * This transitions back from FUTEX_STATE_DEAD to FUTEX_STATE_OK. The
+	 * ordering guarantee required here is that the previous store to
+	 * tsk::mm in the calling code cannot be reordered against this store.
+	 */
+	guard(raw_spinlock_irq)(&tsk->pi_lock);
+	tsk->futex_state = FUTEX_STATE_OK;
 }
 
 static void futex_hash_bucket_init(struct futex_hash_bucket *fhb,
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -200,15 +200,25 @@ void put_pi_state(struct futex_pi_state
  *
  * - FUTEX_STATE_OK when the task is alive and waiters can be attached
  *
- * - FUTEX_STATE_EXITING when the task cleans up the robust list and pi
+ * - FUTEX_STATE_EXITING when the task cleans up the robust list and PI
  *   state. Concurrent waiters cannot attach anymore and have to wait until the
- *   cleanup is finished to re-evaluate the potential changes of robust list and
- *   pi state cleanups.
+ *   cleanup is finished to re-evaluate the potential changes caused by the
+ *   robust list and PI state cleanups.
  *
- * - FUTEX_STATE_DEAD when the task has cleaned up the robust list and
- *   is about to fully exit.
+ * - FUTEX_STATE_DEAD when the task has cleaned up the robust list. This state
+ *   is set independent of exit() or exec(). In the exit() case the task is
+ *   gone. In the exec() case this ensures that nothing can attach to the task
+ *   after cleaning up the robust list and PI state before it has switched to
+ *   the new mm. From a futex point of view the task is dead until it sets the
+ *   state to FUTEX_STATE_OK again after switching to the new mm.
  *
- * exec() switches back to FUTEX_STATE_OK after the cleanup.
+ * The valid state transitions for exit():
+ *
+ *   FUTEX_STATE_OK -> FUTEX_STATE_EXITING -> FUTEX_STATE_DEAD
+ *
+ * The valid state transitions for exec():
+ *
+ *   FUTEX_STATE_OK -> FUTEX_STATE_EXITING -> FUTEX_STATE_DEAD -> FUTEX_STATE_OK
  *
  * The state has two related locks:
  *


