Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713F5160874;
	Mon, 29 Jan 2024 17:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548337; cv=none; b=f6TSe4gAwJZO9SXlGouOTP14NXZ1ToYOoL8YusZEf9O/4yZhuTse7GZXhKyhQap1b8/nSXEjqL5vRtaUwFLcOorgMUdqW8oYaROQkaga4DIlGUYzFbBRuKvDZsrwIn1ewGPho3XBpKriEvN5DIPzXfywLLzWRjiJ1NDN3Xn8MZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548337; c=relaxed/simple;
	bh=bicDTt5IRCg1YzurvHjqrBqCGF85xq8KYFfMxNKhG9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ+8mJGmQM29PbMAw+eOhsab+/kT/KmPl54BjhFR+zxb/lD4la5KMgX9I6RX/3BpzloR5OSe+tgxTYlnsJZM4ZmPe0F7U3vhVw9fqcj91ubvylJdXbKFso9qH/KOi4c4+s5V8pRv9QccmmaWfs5KhN6McQLixwlfN2khbms4UCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWQP9ubB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWQP9ubB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE5C433C7;
	Mon, 29 Jan 2024 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548337;
	bh=bicDTt5IRCg1YzurvHjqrBqCGF85xq8KYFfMxNKhG9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWQP9ubBA8He0DSkkfOAELcLLkZSF7l+Z+Uq/stTtznw+IhEX+Gflq5iEACfRaEXJ
	 pNQdhePslCbBM/083JjGKG+dHGj2NxkYtZPyEz7KUCty1LEgr5Ux+UveVxX61EGEcG
	 t22f5ErlcsYP0C/TWiqt18x8KMEBU22kNRTDYBTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 315/346] futex: Prevent the reuse of stale pi_state
Date: Mon, 29 Jan 2024 09:05:46 -0800
Message-ID: <20240129170025.738516998@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit e626cb02ee8399fd42c415e542d031d185783903 ]

Jiri Slaby reported a futex state inconsistency resulting in -EINVAL during
a lock operation for a PI futex. It requires that the a lock process is
interrupted by a timeout or signal:

  T1 Owns the futex in user space.

  T2 Tries to acquire the futex in kernel (futex_lock_pi()). Allocates a
     pi_state and attaches itself to it.

  T2 Times out and removes its rt_waiter from the rt_mutex. Drops the
     rtmutex lock and tries to acquire the hash bucket lock to remove
     the futex_q. The lock is contended and T2 schedules out.

  T1 Unlocks the futex (futex_unlock_pi()). Finds a futex_q but no
     rt_waiter. Unlocks the futex (do_uncontended) and makes it available
     to user space.

  T3 Acquires the futex in user space.

  T4 Tries to acquire the futex in kernel (futex_lock_pi()). Finds the
     existing futex_q of T2 and tries to attach itself to the existing
     pi_state.  This (attach_to_pi_state()) fails with -EINVAL because uval
     contains the TID of T3 but pi_state points to T1.

It's incorrect to unlock the futex and make it available for user space to
acquire as long as there is still an existing state attached to it in the
kernel.

T1 cannot hand over the futex to T2 because T2 already gave up and started
to clean up and is blocked on the hash bucket lock, so T2's futex_q with
the pi_state pointing to T1 is still queued.

T2 observes the futex_q, but ignores it as there is no waiter on the
corresponding rt_mutex and takes the uncontended path which allows the
subsequent caller of futex_lock_pi() (T4) to observe that stale state.

To prevent this the unlock path must dequeue all futex_q entries which
point to the same pi_state when there is no waiter on the rt mutex. This
requires obviously to make the dequeue conditional in the locking path to
prevent a double dequeue. With that it's guaranteed that user space cannot
observe an uncontended futex which has kernel state attached.

Fixes: fbeb558b0dd0d ("futex/pi: Fix recursive rt_mutex waiter state")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20240118115451.0TkD_ZhB@linutronix.de
Closes: https://lore.kernel.org/all/4611bcf2-44d0-4c34-9b84-17406f881003@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/core.c | 15 ++++++++++++---
 kernel/futex/pi.c   | 11 ++++++++---
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index dad981a865b8..52d0bf67e715 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -626,12 +626,21 @@ int futex_unqueue(struct futex_q *q)
 }
 
 /*
- * PI futexes can not be requeued and must remove themselves from the
- * hash bucket. The hash bucket lock (i.e. lock_ptr) is held.
+ * PI futexes can not be requeued and must remove themselves from the hash
+ * bucket. The hash bucket lock (i.e. lock_ptr) is held.
  */
 void futex_unqueue_pi(struct futex_q *q)
 {
-	__futex_unqueue(q);
+	/*
+	 * If the lock was not acquired (due to timeout or signal) then the
+	 * rt_waiter is removed before futex_q is. If this is observed by
+	 * an unlocker after dropping the rtmutex wait lock and before
+	 * acquiring the hash bucket lock, then the unlocker dequeues the
+	 * futex_q from the hash bucket list to guarantee consistent state
+	 * vs. userspace. Therefore the dequeue here must be conditional.
+	 */
+	if (!plist_node_empty(&q->list))
+		__futex_unqueue(q);
 
 	BUG_ON(!q->pi_state);
 	put_pi_state(q->pi_state);
diff --git a/kernel/futex/pi.c b/kernel/futex/pi.c
index 90e5197f4e56..5722467f2737 100644
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -1135,6 +1135,7 @@ int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 
 	hb = futex_hash(&key);
 	spin_lock(&hb->lock);
+retry_hb:
 
 	/*
 	 * Check waiters first. We do not trust user space values at
@@ -1177,12 +1178,17 @@ int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 		/*
 		 * Futex vs rt_mutex waiter state -- if there are no rt_mutex
 		 * waiters even though futex thinks there are, then the waiter
-		 * is leaving and the uncontended path is safe to take.
+		 * is leaving. The entry needs to be removed from the list so a
+		 * new futex_lock_pi() is not using this stale PI-state while
+		 * the futex is available in user space again.
+		 * There can be more than one task on its way out so it needs
+		 * to retry.
 		 */
 		rt_waiter = rt_mutex_top_waiter(&pi_state->pi_mutex);
 		if (!rt_waiter) {
+			__futex_unqueue(top_waiter);
 			raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
-			goto do_uncontended;
+			goto retry_hb;
 		}
 
 		get_pi_state(pi_state);
@@ -1217,7 +1223,6 @@ int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 		return ret;
 	}
 
-do_uncontended:
 	/*
 	 * We have no kernel internal state, i.e. no waiters in the
 	 * kernel. Waiters which are about to queue themselves are stuck
-- 
2.43.0



