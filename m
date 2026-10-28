Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207804;
	b=tL9Q4+6EoRPgPvrAvmY9vRQoOas9HFkkFwXwxMhwIj26Ir3EokS+NALpMenQkPXkig6V
	 RKj21yY+V8moQ3nJzi142QobW7jPfXQyzGkmta8nAWqP3htHFWumu012FQtO+zaJ/L3vp
	 v43sS28ekvxlmI2nGk0m0RBWi/YxzsvLyo+UVN75avHK9Iyrxd+ohnznV8Y7ao4y5pzmJ
	 RJYERSH0a+7nluSCJNyq4pThtdo11sgB/hM+7JmqORZHvvekP8vpWivpm2S8k3Mq+akWR
	 A6xOw/nI1VV1Bn0EwV1n+lfiUm6edw5QRMSVS6UE7jx9Q1nXgBwqG/tE2udkbZCXN4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X/ByYQiSYLONY2QSsIsUEEDsKQWrsi0RzM0WEpcXV58=;
	b=ETAVN8R6dMhWjN4ty69XaHaM278GbARjG1H1tPA+thn2qje6wKkBAnKTK+C/RN96IsaX
	 U/McabuUFWGe0IrFuo50N6Dda4DaZa0uC11OJTvHUgwGlCwnWbgpekvB4Na/+InQok64H
	 PPjcba5dWwr2xOV5nEvLmmm8nNgTU0mQHRIx4WC5Gu9OK9kAxcxS45Lx3v1VVozkeoUhU
	 S9QS6jklrHnxT9hvaUvzDjez/xrT8mi7ewFK9v8ALMIyEHrqMDPNtY+k8uVImQVy9pvm4
	 ww66SNNg/TH/TxLsC3xS5HDNqpJQTmpywZtquFZWRNorZaHDyZzVR/vAyBbO+LhKwng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkAp8ICZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D801606A31A;
	Wed, 28 Oct 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NkAp8ICZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C84F1F01825;
	Wed, 28 Oct 2026 17:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207804;
	bh=X/ByYQiSYLONY2QSsIsUEEDsKQWrsi0RzM0WEpcXV58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkAp8ICZIpZEwjPjgQcAt/ShaoZp+jZq8HZSPL7Ztf9u/soImCw7D2nGG6jEf2OlL
	 T3vbioltKUBjgMoXfPy8lqPDyf0sTaeGmvhuDaGKPEd12MsTbmCKOZ3LGeKhR7mlR5
	 7AGk0FoQlCJSz+jWqmnx0rNEjdQNT+1kTvDPcL+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Kai <yaokai34@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/247] workqueue: Fix unbound pool lifetime for pending pwqs
Date: Wed, 28 Oct 2026 17:59:09 +0100
Message-ID: <20261028165950.869318641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 14a3d1775c2ff..f6dde83c9466f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5123,12 +5123,6 @@ static void pwq_release_workfn(struct kthread_work *work)
 		mutex_unlock(&wq->mutex);
 	}
 
-	if (!is_percpu_pool(pool)) {
-		mutex_lock(&wq_pool_mutex);
-		put_unbound_pool(pool);
-		mutex_unlock(&wq_pool_mutex);
-	}
-
 	if (!list_empty(&pwq->pending_node)) {
 		struct wq_node_nr_active *nna =
 			wq_node_nr_active(pwq->wq, pwq->pool->node);
@@ -5138,6 +5132,12 @@ static void pwq_release_workfn(struct kthread_work *work)
 		raw_spin_unlock_irq(&nna->lock);
 	}
 
+	if (!is_percpu_pool(pool)) {
+		mutex_lock(&wq_pool_mutex);
+		put_unbound_pool(pool);
+		mutex_unlock(&wq_pool_mutex);
+	}
+
 	kfree_rcu(pwq, rcu);
 
 	/*
-- 
2.53.0



