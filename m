Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2088B1607B7;
	Wed,  5 Feb 2025 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766921; cv=none; b=fmZmxC1SUYEXLmaijuBb8lkxzctIuOfhUsjS7F9K3KxZdbb87DTgcbOw0XgNgD++SwHwzGPAvKvh/fFoh3l3LvmlW0VrxguKcswqMghZP8tmGMyqmJpL8LqZM/aVFfkDkl8mVvlvK51FzEndWUbXjv5wb+uysNaKtQPBBBo2vZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766921; c=relaxed/simple;
	bh=7dbQlWREWL8Jb31fha/sPBhiTX7VezVAf593NrrP5EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLqbv/fz9hlGeCv+SwBWT1jXpFDyB1PHJRRfpIjy28KrlC98zphFCsTfo+QIa7GwA44U8WZcHdqCgs40Jcip/aXtHt0t0DlISpEDnVO+vaezMguJYCmMeRc0xs6b16IYPhE3tlNB7qSWe/Z7J1T/0pd9457hqcyIOREXVYO8aGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFg1qbuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFg1qbuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82281C4CED1;
	Wed,  5 Feb 2025 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766921;
	bh=7dbQlWREWL8Jb31fha/sPBhiTX7VezVAf593NrrP5EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFg1qbuwMuMUjuqkQYdJkRwyH5vzCFgWr2m2TNqarmLRndk++lBVM9GbjRXZ+6ek2
	 9Z7RLz6+VC6mI+EdP84V4VBci5tQjrv5Ii4IAfaW+dcIqibk2sKrA6FFXUj/J35+dA
	 KN1qqxEfTPLAiURzk7BwYoquYONk0183m0+T+4B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Hou Tao <houtao1@huawei.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 329/623] bpf: Cancel the running bpf_timer through kworker for PREEMPT_RT
Date: Wed,  5 Feb 2025 14:41:11 +0100
Message-ID: <20250205134508.809956317@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 58f038e6d209d2dd862fcf5de55407855856794d ]

During the update procedure, when overwrite element in a pre-allocated
htab, the freeing of old_element is protected by the bucket lock. The
reason why the bucket lock is necessary is that the old_element has
already been stashed in htab->extra_elems after alloc_htab_elem()
returns. If freeing the old_element after the bucket lock is unlocked,
the stashed element may be reused by concurrent update procedure and the
freeing of old_element will run concurrently with the reuse of the
old_element. However, the invocation of check_and_free_fields() may
acquire a spin-lock which violates the lockdep rule because its caller
has already held a raw-spin-lock (bucket lock). The following warning
will be reported when such race happens:

  BUG: scheduling while atomic: test_progs/676/0x00000003
  3 locks held by test_progs/676:
  #0: ffffffff864b0240 (rcu_read_lock_trace){....}-{0:0}, at: bpf_prog_test_run_syscall+0x2c0/0x830
  #1: ffff88810e961188 (&htab->lockdep_key){....}-{2:2}, at: htab_map_update_elem+0x306/0x1500
  #2: ffff8881f4eac1b8 (&base->softirq_expiry_lock){....}-{2:2}, at: hrtimer_cancel_wait_running+0xe9/0x1b0
  Modules linked in: bpf_testmod(O)
  Preemption disabled at:
  [<ffffffff817837a3>] htab_map_update_elem+0x293/0x1500
  CPU: 0 UID: 0 PID: 676 Comm: test_progs Tainted: G ... 6.12.0+ #11
  Tainted: [W]=WARN, [O]=OOT_MODULE
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)...
  Call Trace:
  <TASK>
  dump_stack_lvl+0x57/0x70
  dump_stack+0x10/0x20
  __schedule_bug+0x120/0x170
  __schedule+0x300c/0x4800
  schedule_rtlock+0x37/0x60
  rtlock_slowlock_locked+0x6d9/0x54c0
  rt_spin_lock+0x168/0x230
  hrtimer_cancel_wait_running+0xe9/0x1b0
  hrtimer_cancel+0x24/0x30
  bpf_timer_delete_work+0x1d/0x40
  bpf_timer_cancel_and_free+0x5e/0x80
  bpf_obj_free_fields+0x262/0x4a0
  check_and_free_fields+0x1d0/0x280
  htab_map_update_elem+0x7fc/0x1500
  bpf_prog_9f90bc20768e0cb9_overwrite_cb+0x3f/0x43
  bpf_prog_ea601c4649694dbd_overwrite_timer+0x5d/0x7e
  bpf_prog_test_run_syscall+0x322/0x830
  __sys_bpf+0x135d/0x3ca0
  __x64_sys_bpf+0x75/0xb0
  x64_sys_call+0x1b5/0xa10
  do_syscall_64+0x3b/0xc0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
  ...
  </TASK>

It seems feasible to break the reuse and refill of per-cpu extra_elems
into two independent parts: reuse the per-cpu extra_elems with bucket
lock being held and refill the old_element as per-cpu extra_elems after
the bucket lock is unlocked. However, it will make the concurrent
overwrite procedures on the same CPU return unexpected -E2BIG error when
the map is full.

Therefore, the patch fixes the lock problem by breaking the cancelling
of bpf_timer into two steps for PREEMPT_RT:
1) use hrtimer_try_to_cancel() and check its return value
2) if the timer is running, use hrtimer_cancel() through a kworker to
   cancel it again
Considering that the current implementation of hrtimer_cancel() will try
to acquire a being held softirq_expiry_lock when the current timer is
running, these steps above are reasonable. However, it also has
downside. When the timer is running, the cancelling of the timer is
delayed when releasing the last map uref. The delay is also fixable
(e.g., break the cancelling of bpf timer into two parts: one part in
locked scope, another one in unlocked scope), it can be revised later if
necessary.

It is a bit hard to decide the right fix tag. One reason is that the
problem depends on PREEMPT_RT which is enabled in v6.12. Considering the
softirq_expiry_lock lock exists since v5.4 and bpf_timer is introduced
in v5.15, the bpf_timer commit is used in the fixes tag and an extra
depends-on tag is added to state the dependency on PREEMPT_RT.

Fixes: b00628b1c7d5 ("bpf: Introduce bpf timers.")
Depends-on: v6.12+ with PREEMPT_RT enabled
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/bpf/20241106084527.4gPrMnHt@linutronix.de
Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@kernel.org>
Link: https://lore.kernel.org/r/20250117101816.2101857-5-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 751c150f9e1cd..46a1faf9ffd5d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1593,10 +1593,24 @@ void bpf_timer_cancel_and_free(void *val)
 	 * To avoid these issues, punt to workqueue context when we are in a
 	 * timer callback.
 	 */
-	if (this_cpu_read(hrtimer_running))
+	if (this_cpu_read(hrtimer_running)) {
 		queue_work(system_unbound_wq, &t->cb.delete_work);
-	else
+		return;
+	}
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		/* If the timer is running on other CPU, also use a kworker to
+		 * wait for the completion of the timer instead of trying to
+		 * acquire a sleepable lock in hrtimer_cancel() to wait for its
+		 * completion.
+		 */
+		if (hrtimer_try_to_cancel(&t->timer) >= 0)
+			kfree_rcu(t, cb.rcu);
+		else
+			queue_work(system_unbound_wq, &t->cb.delete_work);
+	} else {
 		bpf_timer_delete_work(&t->cb.delete_work);
+	}
 }
 
 /* This function is called by map_delete/update_elem for individual element and
-- 
2.39.5



