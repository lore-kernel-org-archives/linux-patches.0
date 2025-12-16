Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D92338F26;
	Tue, 16 Dec 2025 12:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888419; cv=none; b=fYqNG2lcZt2divsXdbhVJ1kz4cOVhRvq7tQt5XGV1myWSjR90+kANZNnXdWpMYPaZ0LfiFGHU+xsCdM4AONt0atZFoz3ANzF8lhtbWtOpIH5yisbHy/TrZvt04eIRNbBRKX/EtV/CU8KyNjizB4b5YDOdTg4jQKG9pjkZIXH9xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888419; c=relaxed/simple;
	bh=B/4D/G5LN+ufiP4zG4OncUmjhqP/ec7mIQNPvPd9YUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsAx/8WIrJKolWLoZ/LVx6nZr9aSRKFjoUvYLHU7TvWo1MmXyKxt3RsVJK6UnV7cvR6tWv1X8UeZ6SBbrYVstT/Tz7QjdnAeJ8U1z1kdrXOksN+27kvPJVXsq4Oz6ulDzJGlTXIAIJwifFUqnPn5208FgBSydq5XEKzT15dKiOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XikO7Ci8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XikO7Ci8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EACC4CEF1;
	Tue, 16 Dec 2025 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888419;
	bh=B/4D/G5LN+ufiP4zG4OncUmjhqP/ec7mIQNPvPd9YUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XikO7Ci8cM+YLEguEa6heFykUrn/m+VQ0NV8JNtjJv95KzMrOuijEXsmyEXgU66JW
	 IIX9XEK+vjDWFglnmdSPxfyTam8XQotb+PW6v5rEysIMsrJiGhQOLl2q827ZGqftoH
	 xN73M4MISDN022r49i4LubrcMB8ayDfynjqZ9icQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritesh Oedayrajsingh Varma <ritesh@superluminal.eu>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 496/614] rqspinlock: Enclose lock/unlock within lock entry acquisitions
Date: Tue, 16 Dec 2025 12:14:23 +0100
Message-ID: <20251216111419.340663795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit beb7021a6003d9c6a463fffca0d6311efb8e0e66 ]

Ritesh reported that timeouts occurred frequently for rqspinlock despite
reentrancy on the same lock on the same CPU in [0]. This patch closes
one of the races leading to this behavior, and reduces the frequency of
timeouts.

We currently have a tiny window between the fast-path cmpxchg and the
grabbing of the lock entry where an NMI could land, attempt the same
lock that was just acquired, and end up timing out. This is not ideal.
Instead, move the lock entry acquisition from the fast path to before
the cmpxchg, and remove the grabbing of the lock entry in the slow path,
assuming it was already taken by the fast path. The TAS fallback is
invoked directly without being preceded by the typical fast path,
therefore we must continue to grab the deadlock detection entry in that
case.

Case on lock leading to missed AA:

cmpxchg lock A
<NMI>
... rqspinlock acquisition of A
... timeout
</NMI>
grab_held_lock_entry(A)

There is a similar case when unlocking the lock. If the NMI lands
between the WRITE_ONCE and smp_store_release, it is possible that we end
up in a situation where the NMI fails to diagnose the AA condition,
leading to a timeout.

Case on unlock leading to missed AA:

WRITE_ONCE(rqh->locks[rqh->cnt - 1], NULL)
<NMI>
... rqspinlock acquisition of A
... timeout
</NMI>
smp_store_release(A->locked, 0)

The patch changes the order on unlock to smp_store_release() succeeded
by WRITE_ONCE() of NULL. This avoids the missed AA detection described
above, but may lead to a false positive if the NMI lands between these
two statements, which is acceptable (and preferred over a timeout).

The original intention of the reverse order on unlock was to prevent the
following possible misdiagnosis of an ABBA scenario:

grab entry A
lock A
grab entry B
lock B
unlock B
   smp_store_release(B->locked, 0)
							grab entry B
							lock B
							grab entry A
							lock A
							! <detect ABBA>
   WRITE_ONCE(rqh->locks[rqh->cnt - 1], NULL)

If the store release were is after the WRITE_ONCE, the other CPU would
not observe B in the table of the CPU unlocking the lock B.  However,
since the threads are obviously participating in an ABBA deadlock, it
is no longer appealing to use the order above since it may lead to a
250 ms timeout due to missed AA detection.

  [0]: https://lore.kernel.org/bpf/CAH6OuBTjG+N=+GGwcpOUbeDN563oz4iVcU3rbse68egp9wj9_A@mail.gmail.com

Fixes: 0d80e7f951be ("rqspinlock: Choose trylock fallback for NMI waiters")
Reported-by: Ritesh Oedayrajsingh Varma <ritesh@superluminal.eu>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20251128232802.1031906-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/rqspinlock.h | 60 +++++++++++++++++---------------
 kernel/bpf/rqspinlock.c          | 15 ++++----
 2 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/include/asm-generic/rqspinlock.h b/include/asm-generic/rqspinlock.h
index 6d4244d643df3..0f2dcbbfee2f0 100644
--- a/include/asm-generic/rqspinlock.h
+++ b/include/asm-generic/rqspinlock.h
@@ -129,8 +129,8 @@ static __always_inline void release_held_lock_entry(void)
 	 * <error> for lock B
 	 * release_held_lock_entry
 	 *
-	 * try_cmpxchg_acquire for lock A
 	 * grab_held_lock_entry
+	 * try_cmpxchg_acquire for lock A
 	 *
 	 * Lack of any ordering means reordering may occur such that dec, inc
 	 * are done before entry is overwritten. This permits a remote lock
@@ -139,13 +139,8 @@ static __always_inline void release_held_lock_entry(void)
 	 * CPU holds a lock it is attempting to acquire, leading to false ABBA
 	 * diagnosis).
 	 *
-	 * In case of unlock, we will always do a release on the lock word after
-	 * releasing the entry, ensuring that other CPUs cannot hold the lock
-	 * (and make conclusions about deadlocks) until the entry has been
-	 * cleared on the local CPU, preventing any anomalies. Reordering is
-	 * still possible there, but a remote CPU cannot observe a lock in our
-	 * table which it is already holding, since visibility entails our
-	 * release store for the said lock has not retired.
+	 * The case of unlock is treated differently due to NMI reentrancy, see
+	 * comments in res_spin_unlock.
 	 *
 	 * In theory we don't have a problem if the dec and WRITE_ONCE above get
 	 * reordered with each other, we either notice an empty NULL entry on
@@ -175,10 +170,22 @@ static __always_inline int res_spin_lock(rqspinlock_t *lock)
 {
 	int val = 0;
 
-	if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL))) {
-		grab_held_lock_entry(lock);
+	/*
+	 * Grab the deadlock detection entry before doing the cmpxchg, so that
+	 * reentrancy due to NMIs between the succeeding cmpxchg and creation of
+	 * held lock entry can correctly detect an acquisition attempt in the
+	 * interrupted context.
+	 *
+	 * cmpxchg lock A
+	 * <NMI>
+	 * res_spin_lock(A) --> missed AA, leads to timeout
+	 * </NMI>
+	 * grab_held_lock_entry(A)
+	 */
+	grab_held_lock_entry(lock);
+
+	if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
 		return 0;
-	}
 	return resilient_queued_spin_lock_slowpath(lock, val);
 }
 
@@ -192,28 +199,25 @@ static __always_inline void res_spin_unlock(rqspinlock_t *lock)
 {
 	struct rqspinlock_held *rqh = this_cpu_ptr(&rqspinlock_held_locks);
 
-	if (unlikely(rqh->cnt > RES_NR_HELD))
-		goto unlock;
-	WRITE_ONCE(rqh->locks[rqh->cnt - 1], NULL);
-unlock:
 	/*
-	 * Release barrier, ensures correct ordering. See release_held_lock_entry
-	 * for details.  Perform release store instead of queued_spin_unlock,
-	 * since we use this function for test-and-set fallback as well. When we
-	 * have CONFIG_QUEUED_SPINLOCKS=n, we clear the full 4-byte lockword.
+	 * Release barrier, ensures correct ordering. Perform release store
+	 * instead of queued_spin_unlock, since we use this function for the TAS
+	 * fallback as well. When we have CONFIG_QUEUED_SPINLOCKS=n, we clear
+	 * the full 4-byte lockword.
 	 *
-	 * Like release_held_lock_entry, we can do the release before the dec.
-	 * We simply care about not seeing the 'lock' in our table from a remote
-	 * CPU once the lock has been released, which doesn't rely on the dec.
+	 * Perform the smp_store_release before clearing the lock entry so that
+	 * NMIs landing in the unlock path can correctly detect AA issues. The
+	 * opposite order shown below may lead to missed AA checks:
 	 *
-	 * Unlike smp_wmb(), release is not a two way fence, hence it is
-	 * possible for a inc to move up and reorder with our clearing of the
-	 * entry. This isn't a problem however, as for a misdiagnosis of ABBA,
-	 * the remote CPU needs to hold this lock, which won't be released until
-	 * the store below is done, which would ensure the entry is overwritten
-	 * to NULL, etc.
+	 * WRITE_ONCE(rqh->locks[rqh->cnt - 1], NULL)
+	 * <NMI>
+	 * res_spin_lock(A) --> missed AA, leads to timeout
+	 * </NMI>
+	 * smp_store_release(A->locked, 0)
 	 */
 	smp_store_release(&lock->locked, 0);
+	if (likely(rqh->cnt <= RES_NR_HELD))
+		WRITE_ONCE(rqh->locks[rqh->cnt - 1], NULL);
 	this_cpu_dec(rqspinlock_held_locks.cnt);
 }
 
diff --git a/kernel/bpf/rqspinlock.c b/kernel/bpf/rqspinlock.c
index 21be48108e962..f4c534fa4e87b 100644
--- a/kernel/bpf/rqspinlock.c
+++ b/kernel/bpf/rqspinlock.c
@@ -275,6 +275,10 @@ int __lockfunc resilient_tas_spin_lock(rqspinlock_t *lock)
 	int val, ret = 0;
 
 	RES_INIT_TIMEOUT(ts);
+	/*
+	 * The fast path is not invoked for the TAS fallback, so we must grab
+	 * the deadlock detection entry here.
+	 */
 	grab_held_lock_entry(lock);
 
 	/*
@@ -397,10 +401,7 @@ int __lockfunc resilient_queued_spin_lock_slowpath(rqspinlock_t *lock, u32 val)
 		goto queue;
 	}
 
-	/*
-	 * Grab an entry in the held locks array, to enable deadlock detection.
-	 */
-	grab_held_lock_entry(lock);
+	/* Deadlock detection entry already held after failing fast path. */
 
 	/*
 	 * We're pending, wait for the owner to go away.
@@ -448,11 +449,7 @@ int __lockfunc resilient_queued_spin_lock_slowpath(rqspinlock_t *lock, u32 val)
 	 */
 queue:
 	lockevent_inc(lock_slowpath);
-	/*
-	 * Grab deadlock detection entry for the queue path.
-	 */
-	grab_held_lock_entry(lock);
-
+	/* Deadlock detection entry already held after failing fast path. */
 	node = this_cpu_ptr(&rqnodes[0].mcs);
 	idx = node->count++;
 	tail = encode_tail(smp_processor_id(), idx);
-- 
2.51.0



