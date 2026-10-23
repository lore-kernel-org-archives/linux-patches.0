Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775026;
	b=5kXHXGvNaNVDfZjdAwC50gZeoBj3C1W2s6qFoETYIsXOTiaQ54/2Zi5+f6Y5oYiKrpBI
	 KcC+cEje6HwNxgHIM4+0g9YtN9cJCyttHK/UJYL84TLUolP7U0uzlCJOVEOjP1iBlEVFM
	 JE+ben1L3lu2vutYWUZD5PwP9+y6NUCGNHUvwPXKSxMaFOcT4zSqb65cqegbFITCFGHLF
	 j6Km6lcg858nkne2Vy/Y27r7E8a8xCbIJFPH1Z3cRBXCNoXChm0l5Ma1CZpqaq16Xn730
	 kg/v/vOoCD3eztWSaVKsg33YRnOXjung6GjvrzStzmInE8bQolu349jO6biPbtVMDkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S5Q5dv191sNM7lCplpLIPJhGbnac+3x9k+EP6DsAkcg=;
	b=DjiovdUtlT+nX8XvTvcofkIoIyOhJ6CZVvQZCJALFen0mei5JMol6rU1WDreSMHaOx8x
	 GxEEA2nQUxb3rtAZ9H3/05V50VTriZfIotCaGST9qgrlKsedeUI6nWC0LRWzjsqFfe0Pd
	 CF+Tun/MrDXQWIvjQj/W2YAPC7twc5JKM6IGuXWsisayL2Gm5srZ9vHjRBHlFqqpejdgh
	 ARoUHoQArySa2SgdX3Eju//mwzS6EoODJq7cEyIKMCfQHf3jpsaVNPewOK3/Cvgg/ZuMs
	 yi+NIAPqNXBm1f3QpuXBttXV2WRccwJB7YX5daQILtoEVifFMxU+d23ljMQH3sakvMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISkEnDYq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8875606A31A;
	Fri, 23 Oct 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ISkEnDYq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3981F01829;
	Fri, 23 Oct 2026 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775025;
	bh=S5Q5dv191sNM7lCplpLIPJhGbnac+3x9k+EP6DsAkcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISkEnDYqA9GqrOr8TT4LsXs4hbvjQwujK+rTab7OoHUWWnCR0NH+8IM8LH+vnXhhl
	 kafRqDZw8cMco8KPmO8VNlRfiNuAG7FxyzexhegY5symkPWrOgnv3I5QrtqUEIDJjY
	 qmqN1l+aepZaRuDf8gCfRvcCQqLB3bZo8/ZZHMmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Kai <yaokai34@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 236/242] workqueue: Fix unbound pool lifetime for pending pwqs
Date: Fri, 23 Oct 2026 18:41:18 +0200
Message-ID: <20261023163719.434943485@linuxfoundation.org>
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

From: Yao Kai <yaokai34@huawei.com>

[ Upstream commit cf9c8aaea0d47410df8708bec195889f3a85cd3c ]

KASAN reports a use-after-free of an unbound worker_pool in
node_activate_pending_pwq():

  BUG: KASAN: slab-use-after-free in _raw_spin_trylock+0x6d/0x120
  Read of size 4 at addr ffff8880089ce000 by task kworker/u22:0/318

  CPU: 1 UID: 0 PID: 318 Comm: kworker/u22:0 Not tainted 7.2.0 #1 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  Workqueue:  0x0 (flush-8:0)
  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xce/0x610
   kasan_report+0xce/0x100
   _raw_spin_trylock+0x6d/0x120
   pwq_dec_nr_in_flight+0x4b4/0xcb0
   process_one_work+0x921/0x11a0
   worker_thread+0x4d0/0xd20
   kthread+0x2de/0x3c0
   ret_from_fork+0x3aa/0x620
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  Allocated by task 311:
   alloc_pwq+0x439/0xca0
   apply_wqattrs_prepare+0x75e/0xd10
   apply_workqueue_attrs_locked+0x44/0xa0
   wq_nice_store+0x350/0x450

  Freed by task 0:
   kfree+0x127/0x3b0
   rcu_core+0x523/0x1780
   handle_softirqs+0x1b3/0x610

  Last potentially related work creation:
   put_unbound_pool+0x3f3/0x7d0
   pwq_release_workfn+0x494/0x8e0
   kthread_worker_fn+0x1ff/0x790

Canceling the last inactive work skips pwq_dec_nr_active(), so an empty
pwq can remain on pending_pwqs when its refcnt reaches zero.
pwq_release_workfn() currently puts the pool before removing that pwq.
If this drops the last pool reference, the pool can be RCU-freed while
the pwq remains reachable, and node_activate_pending_pwq() may trylock
the freed pool->lock.

Remove the pwq from pending_pwqs before putting the pool.

Fixes: 5797b1c18919 ("workqueue: Implement system-wide nr_active enforcement for unbound workqueues")
Cc: stable@vger.kernel.org
Signed-off-by: Yao Kai <yaokai34@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Replaced `!is_percpu_pool(pool)` with the existing `wq->flags & WQ_UNBOUND` check because the helper is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5229,12 +5229,6 @@ static void pwq_release_workfn(struct kt
 		mutex_unlock(&wq->mutex);
 	}
 
-	if (wq->flags & WQ_UNBOUND) {
-		mutex_lock(&wq_pool_mutex);
-		put_unbound_pool(pool);
-		mutex_unlock(&wq_pool_mutex);
-	}
-
 	if (!list_empty(&pwq->pending_node)) {
 		struct wq_node_nr_active *nna =
 			wq_node_nr_active(pwq->wq, pwq->pool->node);
@@ -5244,6 +5238,12 @@ static void pwq_release_workfn(struct kt
 		raw_spin_unlock_irq(&nna->lock);
 	}
 
+	if (wq->flags & WQ_UNBOUND) {
+		mutex_lock(&wq_pool_mutex);
+		put_unbound_pool(pool);
+		mutex_unlock(&wq_pool_mutex);
+	}
+
 	kfree_rcu(pwq, rcu);
 
 	/*


