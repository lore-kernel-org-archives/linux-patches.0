Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774904;
	b=Lvl80W1luf05ZSwdSxsKluGwpcld2p1gK1OT9GpAn3RheFsU+gso2MZcX+kaitl/CrRk
	 RkOK61o5Z4Qnjl1xJqDzlUxUMP/CTcFcXURaET0vLSz632lB2R4DyQNvjGyHjmjvKGwSR
	 Q1AqXaYgU34hr5ED8TxRN7elXzeanFYTUNIgLxAZHCxboyN7a5ML2vjUMpLbwAiZEQFaE
	 yu7aTGJv++6ovrO6P71rDfHxglhi4Cl0rdpUmVYfXbvEytMbo6GRF2cPa6ibrKfGVxUn3
	 0VcgYxEgRdWvGKy7AB/sqbc30fByMPcIWMabcU612JEBhC6BpiL0nM6dCzvqlNQ9MmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=czzT1LooFdGUB+VQOpnJRSwBUwl1vyoDB4bzFT1ZWK0=;
	b=MZ76pj02LGqSgkoFXV87qty05RFusdvEjmgMOZMtVzVWFsy3ZMvcZbtlxjSnIcdfoly6
	 x6VB6w86hwB6L5g3W903ueSNHGYAI245YGo9s/8YCF4UvOJgiN4F+NN96M+rQu4FOOy8Q
	 +hoDxXB+3BxhxWuNYDTuEQeItBaxHTCeYsmLbMUpPIitkeNCEQ7rYYsZsB70tBWxry/1a
	 41W17F1VuhXrgQfEiKKS54HoUOhThTRYsgPL5UVfWCADbamwwqpGDjn0RBQNqZhKiInLF
	 RZ3J60YSJ6whrA/o30St9EnskDfkuJqJXGxefkZWtjX46BrwtTeDAgzTL8o+/rtrj1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfZq941W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7852C606A31A;
	Fri, 23 Oct 2026 17:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfZq941W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62051F01825;
	Fri, 23 Oct 2026 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774904;
	bh=czzT1LooFdGUB+VQOpnJRSwBUwl1vyoDB4bzFT1ZWK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfZq941W5/34lIP8/IosNh7NbXJpwg8d0/XznTlIwRxRnm/sc+eiCI/0wcMZR/X8A
	 UtMSr/Zme74qFVjQo79+iIPozPjOSK4SLNJchGNduwJkLFTgjsdBFJtHoP0OIsWvL9
	 5J2wjoHYtx8jk77JPSdPUn12jizAZ/OlBO6SScAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	syzbot+1bd20115328f8254ed62@syzkaller.appspotmail.com
Subject: [PATCH 7.2 197/242] workqueue: Annotate cb_lock nesting when draining a dead BH pool
Date: Fri, 23 Oct 2026 18:40:39 +0200
Message-ID: <20261023163718.450716968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 6eca8f94d84106d3754b9df27f46a14572af9e7f upstream.

On PREEMPT_RT, bh_worker() wraps work item execution in pool->cb_lock to
provide a handshake for canceling BH work items. When a CPU goes down,
drain_dead_softirq_workfn() runs the dead pool's bh_worker() nested inside
the local pool's bh_worker(), acquiring the cb_locks of two different pools
without a nesting annotation. lockdep reports possible recursive locking:

  ============================================
  WARNING: possible recursive locking detected
  --------------------------------------------
  ktimers/0/16 is trying to acquire lock:
  ffff8880b873a990 (&pool->cb_lock){+...}-{3:3}, at: bh_worker+0x7d/0x880

  but task is already holding lock:
  ffff8880b863a990 (&pool->cb_lock){+...}-{3:3}, at: bh_worker+0x7d/0x880

  Call Trace:
   bh_worker+0x7d/0x880 kernel/workqueue.c:3688
   drain_dead_softirq_workfn+0x95/0x220 kernel/workqueue.c:3763
   process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
   bh_worker+0x46a/0x880 kernel/workqueue.c:3708
   tasklet_action+0xc/0x70 kernel/softirq.c:965

The nesting can't deadlock. A pool's bh_worker() runs nested only while the
pool's CPU is dead, entered from a live pool's bh_worker() on the draining
CPU, so the ordering is always live to dead. CPU hotplug operations are
serialized and the drain is synchronous, so the nesting depth never exceeds
two. Annotate the inner acquisition with SINGLE_DEPTH_NESTING.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: syzbot+1bd20115328f8254ed62@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1bd20115328f8254ed62
Fixes: ad7c7f4b9c6c ("workqueue: Provide a handshake for canceling BH workers")
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3141,7 +3141,16 @@ restart:
 #ifdef CONFIG_PREEMPT_RT
 static void worker_lock_callback(struct worker_pool *pool)
 {
-	spin_lock(&pool->cb_lock);
+	/*
+	 * SINGLE_DEPTH_NESTING is for a dead pool's bh_worker() running from
+	 * drain_dead_softirq_workfn() inside a live pool's bh_worker(). The
+	 * unlocked read is stable: the flag is only set while @pool's CPU is
+	 * dead, inside a serialized hotplug operation. data_race() as the value
+	 * only affects the lockdep annotation and the read can be elided when
+	 * lockdep is disabled.
+	 */
+	spin_lock_nested(&pool->cb_lock,
+			 data_race(pool->flags) & POOL_BH_DRAINING ? SINGLE_DEPTH_NESTING : 0);
 }
 
 static void worker_unlock_callback(struct worker_pool *pool)


