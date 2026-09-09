Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D2F583ACA;
	Wed,  9 Sep 2026 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963389; cv=none; b=DPnsbRYAW4wB0f1VpAh28ul8VTGEIsBZvPsdhUDA3ixVNtmMwdiQpqgd8O2OHXWCOS1kxrnYLgtL4JaS5Yp5KQ8U8cdEWmAXfHr7PEhNplUZEonWbkq/jcPmQ3Lt1NRMif1TYsWfF7SuIcwisJlW/FfX6pio9qnBrbaWtAbnEv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963389; c=relaxed/simple;
	bh=B+dzeZgVe2jPyTO9eKw2xbN8o1UniJTNg0troJpTlsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIOXt0QbB9tlSdW+IzdPqVQafYaGvdvprMqibDMasp2GnqdBjQpH/6EKuKhnZ3dp4QooJAMaKcNPbgCsdey3b7WQANz3sY+iKw4J7jMbUvoVoK51DKo21jDpNKrEq6xraTSnfY9MGGa95gl1J/WJ+UIYVf/7yiu1UWM/8thtn0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7f0rfJi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7f0rfJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177EC1F00A3A;
	Wed,  9 Sep 2026 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963388;
	bh=xyn2+AuEw9Yjp+PAjMlt0uA6bmbmeUKMsqIfEddpkDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7f0rfJizEDGts6G68kI/EDRatiuK0gHXXGI7NomXUf8M6ijNt4TS7mYQ6tM3P2Ar
	 Lx/dSA96t1eSejxP87dx8jFOuzRk811kjMskYQAXJKZ972aPd3SjEiIRM3rY3X1KIN
	 zQxZ0s7XepBZiZ7FD4iCb/3uR2El0e3BHtI8c/4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Kai <yaokai34@huawei.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 062/583] futex: Prevent rcuwait use-after-free during requeue PI
Date: Wed,  9 Sep 2026 15:35:47 +0200
Message-ID: <20260909134240.200896871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Yao Kai <yaokai34@huawei.com>

commit a3b8d46fe401cba3a5c46dea610e6eb3dc15370e upstream.

On PREEMPT_RT, FUTEX_CMP_REQUEUE_PI can trigger a KASAN report
(slab-out-of-bounds) in futex_requeue_pi_complete() invocation of
rcuwait_wake_up().

The futex_q used by futex_wait_requeue_pi() is allocated on the waiter's
stack. An early wakeup can race with a PI requeue as follows:

        waiter                          requeue task
        ------                          ------------
futex_wait_requeue_pi()
  futex_do_wait()
    schedule()
                                       futex_requeue
                                         futex_proxy_trylock_atomic()
                                           futex_requeue_pi_prepare()
                                            Q_REQUEUE_PI_NONE -> Q_REQUEUE_PI_IN_PROGRESS
* timeout/ signal wakes waiter *
  futex_requeue_pi_wakeup_sync()
   Q_REQUEUE_PI_IN_PROGRESS -> Q_REQUEUE_PI_WAIT
                                           requeue_pi_wake_futex
                                             futex_requeue_pi_complete()
                                               cmpxchg Q_REQUEUE_PI_WAIT -> Q_REQUEUE_PI_LOCKED
    rcuwait_wait_event()
      if (atomic_read(&q->requeue_state) != Q_REQUEUE_PI_WAIT)
       break /* no schedule() */

 /* q.pi_state->owner == current */
 futex_private_hash_put()
 /* return from syscall */
                                              rcuwait_wake_up(&q->requeue_wait)
                                                /* q is gone */

futex_requeue_pi_complete() publishes Q_REQUEUE_PI_LOCKED before
calling rcuwait_wake_up(). The waiter observes this state in
rcuwait_wait_event() before invoking schedule() in rcuwait_wait_event().
Here, the waiter is free leave the syscall before requeue task can
complete the wake.

To address this race skip rcuwait_wake_up() in the Q_REQUEUE_PI_LOCKED
case.
This state is only published by requeue_pi_wake_futex(), which saves
q->task before futex_requeue_pi_complete() and wakes the waiter via
wake_up_state().

This wake is intended to wake the waiter from its futex_do_wait() sleep.
If the waiter is still sleeping there, it can not get into the
Q_REQUEUE_PI_WAIT state (and require this removed wake).
Should the waiter be woken up from futex_do_wait() by other means (as in
this example) and sleep in futex_requeue_pi_wakeup_sync() then the
wake_up_state() from requeue_pi_wake_futex() will wake it, too.
Should the waiter task terminate before wake_up_state() had a chance to
wake the task then the task pointer does not become invalid because the
futex_hash_bucket::lock is held and the task pointer is RCU protected.

[bigeasy: Updated comment and commit message]

Fixes: 07d91ef510fb1 ("futex: Prevent requeue_pi() lock nesting issue on RT")
Signed-off-by: Yao Kai <yaokai34@huawei.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901135453.3121948-3-bigeasy@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/requeue.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/futex/requeue.c
+++ b/kernel/futex/requeue.c
@@ -154,8 +154,16 @@ static inline void futex_requeue_pi_comp
 	} while (!atomic_try_cmpxchg(&q->requeue_state, &old, new));
 
 #ifdef CONFIG_PREEMPT_RT
-	/* If the waiter interleaved with the requeue let it know */
-	if (unlikely(old == Q_REQUEUE_PI_WAIT))
+	/*
+	 * The waiter in futex_requeue_pi_wakeup_sync() can interleave with the
+	 * wake below: It will assign Q_REQUEUE_PI_IN_PROGRESS and here it will
+	 * be updated to Q_REQUEUE_PI_LOCKED (locked = 1). The rcuwait_wait_event()
+	 * will already read Q_REQUEUE_PI_LOCKED and skip the schedule() invocation,
+	 * leading to an access of futex_q::requeue_wait after the waiter returned.
+	 * In this case only we skip the wake here and rely on following wake in
+	 * requeue_pi_wake_futex() to perform the wake if needed.
+	 */
+	if (unlikely(old == Q_REQUEUE_PI_WAIT) && new != Q_REQUEUE_PI_LOCKED)
 		rcuwait_wake_up(&q->requeue_wait);
 #endif
 }


