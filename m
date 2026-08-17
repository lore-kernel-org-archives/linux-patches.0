Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A968315D5D;
	Mon, 17 Aug 2026 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974179; cv=none; b=td+91HgOlQGotRfQDEv6vzpDQ3eqNuaPhgA6QRPi/9zw2yO/MiMtFBJ3fJhyh0AtSrjorPYkwmYBLQNkdtvMQjAgLiD6CaIZMoAW9VEVCrjCLK6tmP622qmUDadlFWdCCoeDp6cOCy5IV9hdNaqllY1ll/e8bIIqnFMzlfPar+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974179; c=relaxed/simple;
	bh=XlgB5SqL1OQ/UrkK4lQKGKM2MDzxFKM071I8DMMrkVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjUwX707V8yr+C3J5oNWLyTr16jUcANb/C31sYulbMzWUXoIaQPZ0cgVvY8QOdow0bQYhpQ8rpH36MOWN9vEHlB5LBOJTwvDVo+oa/8zFYlmFqFZHNWzv2JHyNFlo/Q5zM3jWLXfzQNgfGTykopCraZGEYvIl4MLWn+TgRw2dBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geE6PzDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geE6PzDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6791F000E9;
	Mon, 17 Aug 2026 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974178;
	bh=BvXUvh1d0mCuwMRKdkPkDAKEADHYyJGbhoIiPxnm8HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geE6PzDXrlye0pwHyxhRgutWdPTpdSon3dMT5GRS+KhWfkd4WcBCMlVCerhd1MUZw
	 tAl1utqKlyC/6u/AcJKJxDa3XRM6LqCPWiyoOd74RCa50THlvkX867VO7NcaT5FYbY
	 DK8PhiMvdbr0qnNO8rEtlycbYR9RLzTVo/2raPOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 115/271] rqspinlock: Reset tail when preserving queue on deadlock
Date: Mon, 17 Aug 2026 15:30:40 +0200
Message-ID: <20260817132541.613911720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 7a3c0289c3c8eb4607dff448ae9ff9f902c813af ]

Currently, the destruction of the waiter queue is suppressed for
rqspinlock in cases where a deadlock is detected. Deadlock checks happen
relatively frequently (on entry for AA, within 1ms for ABBA), and waiter
threads may not be involved in locking scenarios involving deadlocks.
Thus, it is useful to not flush the queue and let other waiters take a
stab at acquiring the lock after we detect a deadlock and exit.

However, we need to follow the same logic as what we did previously for
the waitq_timeout label: reset the tail, and if we cannot, signal the
next waiter appropriately. In case of deadlocks, this signal would just
mark the MCS node as unlocked, and in case of timeouts, it would signal
RES_TIMEOUT_VAL. The difference thus is in the value propagated, which
decides whether the queue remains active or gets flushed.

Not doing the tail reset, and waiting for the next waiter can lead to
cases where we are the final waiter, and thus no next waiter arrives,
leading to intermittent stalls in this path. Once the next waiter does
join, we will be unblocked. In the theoretical case when the next waiter
never joins, we risk stalling indefinitely.

This can only happen for ABBA deadlocks, since entry into the wait queue
is guarded with AA checks. A precise sequence of executions leading up
to this scenario can be:

CPU 0 holds lock A.
CPU 1 holds lock B.
CPU 2 attempts lock B, becomes the pending waiter for B.
CPU 0 attempts lock B. B has locked+pending bits set, thus CPU 0 queues.
CPU 1 attempts lock A.
CPU 0 detects an ABBA deadlock.

Once deadlock detection happens for CPU 0, it will sit waiting for the
next waiter in the queue to populate node->next, which will experience
delays until such a waiter arrives.

Fix this by adjusting the logic for the check for deadlocks preceding
the waitq_timeout label. It would make sense to consolidate code for
both cases and use 'ret' to distinguish the value being propagated, but
that is left as an exercise for a future refactoring task to avoid diff
noise in this patch.

Fixes: 7bd6e5ce5be6 ("rqspinlock: Disable queue destruction for deadlocks")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://patch.msgid.link/20260802021759.1139457-1-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/rqspinlock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/rqspinlock.c b/kernel/bpf/rqspinlock.c
index e4e338cdb437c..2129defc4a9a7 100644
--- a/kernel/bpf/rqspinlock.c
+++ b/kernel/bpf/rqspinlock.c
@@ -572,9 +572,10 @@ int __lockfunc resilient_queued_spin_lock_slowpath(rqspinlock_t *lock, u32 val)
 
 	/* Disable queue destruction when we detect deadlocks. */
 	if (ret == -EDEADLK) {
-		if (!next)
+		if (!try_cmpxchg_tail(lock, tail, 0)) {
 			next = smp_cond_load_relaxed(&node->next, (VAL));
-		arch_mcs_spin_unlock_contended(&next->locked);
+			arch_mcs_spin_unlock_contended(&next->locked);
+		}
 		goto err_release_node;
 	}
 
-- 
2.53.0



