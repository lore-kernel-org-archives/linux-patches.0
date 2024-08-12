Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75BF2C1A5;
	Mon, 12 Aug 2024 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479357; cv=none; b=ccsYlO4xanXhmqWbhQae//py8cdvEkfj3iyh3x+5iJECrdQwwPjc700n78rHad+9eG1IvDRc3qQ1G84uH0FfEkEmo+W+66uPz23UJUHeQ7GKZ1JsO2+sSx6AQxwIblrz2baxaQIuQqnFwiGhPBfZvIfcRZpOlnzvGLNF7G/7AbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479357; c=relaxed/simple;
	bh=m9Dds/PvDkvq3AE9k0Vr8fjfVbYR7sdUY48OoQ7G17g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3SqOC2eJIHADPkQIW3uZ/ljFZYmbxSuBaAk7r/sZrPjnTScitVWeHmwTDQ/O4bezJDgAUHdq7UEzXpPGgstkrD1CuiZyXIIm+YxWpgnbU9YiRrydpAqFyZC0ksyzhpT1eMtkTdPgRXmW4PRj8ZgLdZtm+vo5xK31z2SxsNNj8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3Yt3CVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3Yt3CVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E097C32782;
	Mon, 12 Aug 2024 16:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479356;
	bh=m9Dds/PvDkvq3AE9k0Vr8fjfVbYR7sdUY48OoQ7G17g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3Yt3CVEv6UieDf5mie0M2dV/qsP7bGoqhmE/k2DvncI9cCioicQ/v9rylKgYLRlq
	 cB43VCOb60kDhARTW3aanE1GC7u52s6/sBVlCaG2IgzWbeDrQhRTrtLTvBhDh64Bn7
	 CJnV7/PoAvq0krr3xvR72m3yOw8mEi7pGvqegh2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/189] rcu: Fix rcu_barrier() VS post CPUHP_TEARDOWN_CPU invocation
Date: Mon, 12 Aug 2024 18:01:26 +0200
Message-ID: <20240812160133.306186703@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 55d4669ef1b76823083caecfab12a8bd2ccdcf64 ]

When rcu_barrier() calls rcu_rdp_cpu_online() and observes a CPU off
rnp->qsmaskinitnext, it means that all accesses from the offline CPU
preceding the CPUHP_TEARDOWN_CPU are visible to RCU barrier, including
callbacks expiration and counter updates.

However interrupts can still fire after stop_machine() re-enables
interrupts and before rcutree_report_cpu_dead(). The related accesses
happening between CPUHP_TEARDOWN_CPU and rnp->qsmaskinitnext clearing
are _NOT_ guaranteed to be seen by rcu_barrier() without proper
ordering, especially when callbacks are invoked there to the end, making
rcutree_migrate_callback() bypass barrier_lock.

The following theoretical race example can make rcu_barrier() hang:

CPU 0                                               CPU 1
-----                                               -----
//cpu_down()
smpboot_park_threads()
//ksoftirqd is parked now
<IRQ>
rcu_sched_clock_irq()
   invoke_rcu_core()
do_softirq()
   rcu_core()
      rcu_do_batch()
         // callback storm
         // rcu_do_batch() returns
         // before completing all
         // of them
   // do_softirq also returns early because of
   // timeout. It defers to ksoftirqd but
   // it's parked
</IRQ>
stop_machine()
   take_cpu_down()
                                                    rcu_barrier()
                                                        spin_lock(barrier_lock)
                                                        // observes rcu_segcblist_n_cbs(&rdp->cblist) != 0
<IRQ>
do_softirq()
   rcu_core()
      rcu_do_batch()
         //completes all pending callbacks
         //smp_mb() implied _after_ callback number dec
</IRQ>

rcutree_report_cpu_dead()
   rnp->qsmaskinitnext &= ~rdp->grpmask;

rcutree_migrate_callback()
   // no callback, early return without locking
   // barrier_lock
                                                        //observes !rcu_rdp_cpu_online(rdp)
                                                        rcu_barrier_entrain()
                                                           rcu_segcblist_entrain()
                                                              // Observe rcu_segcblist_n_cbs(rsclp) == 0
                                                              // because no barrier between reading
                                                              // rnp->qsmaskinitnext and rsclp->len
                                                              rcu_segcblist_add_len()
                                                                 smp_mb__before_atomic()
                                                                 // will now observe the 0 count and empty
                                                                 // list, but too late, we enqueue regardless
                                                                 WRITE_ONCE(rsclp->len, rsclp->len + v);
                                                        // ignored barrier callback
                                                        // rcu barrier stall...

This could be solved with a read memory barrier, enforcing the message
passing between rnp->qsmaskinitnext and rsclp->len, matching the full
memory barrier after rsclp->len addition in rcu_segcblist_add_len()
performed at the end of rcu_do_batch().

However the rcu_barrier() is complicated enough and probably doesn't
need too many more subtleties. CPU down is a slowpath and the
barrier_lock seldom contended. Solve the issue with unconditionally
locking the barrier_lock on rcutree_migrate_callbacks(). This makes sure
that either rcu_barrier() sees the empty queue or its entrained
callback will be migrated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8cf6a6fef7965..583cc29080764 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4595,11 +4595,15 @@ void rcutree_migrate_callbacks(int cpu)
 	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
 	bool needwake;
 
-	if (rcu_rdp_is_offloaded(rdp) ||
-	    rcu_segcblist_empty(&rdp->cblist))
-		return;  /* No callbacks to migrate. */
+	if (rcu_rdp_is_offloaded(rdp))
+		return;
 
 	raw_spin_lock_irqsave(&rcu_state.barrier_lock, flags);
+	if (rcu_segcblist_empty(&rdp->cblist)) {
+		raw_spin_unlock_irqrestore(&rcu_state.barrier_lock, flags);
+		return;  /* No callbacks to migrate. */
+	}
+
 	WARN_ON_ONCE(rcu_rdp_cpu_online(rdp));
 	rcu_barrier_entrain(rdp);
 	my_rdp = this_cpu_ptr(&rcu_data);
-- 
2.43.0



