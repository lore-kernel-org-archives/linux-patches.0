Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178181DFD9D;
	Wed,  6 Nov 2024 12:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897613; cv=none; b=s2DnqqWEWZe3KMgqja2gbZtJa6GUsug2bHP/n+aifF8CQhxDPndaSF1Q1DgQG5SLFke68ux0XPNnU1wDYvFxxz1ONQI1mMAdrZUfPw0gGrof0tbYGfs1gmcTSZ0Cl7mmaEnjlNfum03w0W343aq1wDZZjTujQ8GAJ+yWGdoOcu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897613; c=relaxed/simple;
	bh=6Wh8L+RyguHEJKcEcvD3LegmXRDYoPcwZeozAiydFj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDpkdnlYmBwFrKK1HedQFtDumAKB6t0C8tgry1DGFDk6s0tNpcCAbW0Hv20Bdmwh7sZY3lL+kZrGqDs/8p9oxdxNtspfsrfXVjTWqx24btDtOjKrYrQqlnnN50OLoALYhAR/bn1E0z/CnCFMyaI9YVvUrptGzTUn7P0YLeuet/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxJiGoEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxJiGoEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E7FC4CECD;
	Wed,  6 Nov 2024 12:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897613;
	bh=6Wh8L+RyguHEJKcEcvD3LegmXRDYoPcwZeozAiydFj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxJiGoENwgIXwb8PeK/+GU0E5zovwi6R4IZ1Ulg0EQxEGxLbzRwbL2f3UpHaOeX7B
	 GuimV+A7koy3YZ7Flvl8NCU5EAB5zFFcXR0KlY/opuEFyos0Z26wZXuIElHLpR6nJ0
	 7kF0sLaWL9p5GYBdc3M0Lc5dBJndRNDRXM5BxXHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/151] rcu-tasks: Pull sampling of ->percpu_dequeue_lim out of loop
Date: Wed,  6 Nov 2024 13:04:24 +0100
Message-ID: <20241106120310.942011913@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit e62d8ae4620865411d1b2347980aa28ccf891a3d ]

The rcu_tasks_need_gpcb() samples ->percpu_dequeue_lim as part of the
condition clause of a "for" loop, which is a bit confusing.  This commit
therefore hoists this sampling out of the loop, using the result loaded
in the condition clause.

So why does this work in the face of a concurrent switch from single-CPU
queueing to per-CPU queueing?

o	The call_rcu_tasks_generic() that makes the change has already
	enqueued its callback, which means that all of the other CPU's
	callback queues are empty.

o	For the call_rcu_tasks_generic() that first notices
	the switch to per-CPU queues, the smp_store_release()
	used to update ->percpu_enqueue_lim pairs with the
	raw_spin_trylock_rcu_node()'s full barrier that is
	between the READ_ONCE(rtp->percpu_enqueue_shift) and the
	rcu_segcblist_enqueue() that enqueues the callback.

o	Because this CPU's queue is empty (unless it happens to
	be the original single queue, in which case there is no
	need for synchronization), this call_rcu_tasks_generic()
	will do an irq_work_queue() to schedule a handler for the
	needed rcuwait_wake_up() call.	This call will be ordered
	after the first call_rcu_tasks_generic() function's change to
	->percpu_dequeue_lim.

o	This rcuwait_wake_up() will either happen before or after the
	set_current_state() in rcuwait_wait_event().  If it happens
	before, the "condition" argument's call to rcu_tasks_need_gpcb()
	will be ordered after the original change, and all callbacks on
	all CPUs will be visible.  Otherwise, if it happens after, then
	the grace-period kthread's state will be set back to running,
	which will result in a later call to rcuwait_wait_event() and
	thus to rcu_tasks_need_gpcb(), which will again see the change.

So it all works out.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Stable-dep-of: fd70e9f1d85f ("rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index df81506cf2bde..90425d0ec09cf 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -432,6 +432,7 @@ static void rcu_barrier_tasks_generic(struct rcu_tasks *rtp)
 static int rcu_tasks_need_gpcb(struct rcu_tasks *rtp)
 {
 	int cpu;
+	int dequeue_limit;
 	unsigned long flags;
 	bool gpdone = poll_state_synchronize_rcu(rtp->percpu_dequeue_gpseq);
 	long n;
@@ -439,7 +440,8 @@ static int rcu_tasks_need_gpcb(struct rcu_tasks *rtp)
 	long ncbsnz = 0;
 	int needgpcb = 0;
 
-	for (cpu = 0; cpu < smp_load_acquire(&rtp->percpu_dequeue_lim); cpu++) {
+	dequeue_limit = smp_load_acquire(&rtp->percpu_dequeue_lim);
+	for (cpu = 0; cpu < dequeue_limit; cpu++) {
 		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rtp->rtpcpu, cpu);
 
 		/* Advance and accelerate any new callbacks. */
-- 
2.43.0



