Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC48A1662E7;
	Tue, 26 Aug 2025 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217766; cv=none; b=o7J0oNjpdhmk39aWvu6ngIgNGJmNMaEGRpAuCFJALm0ghNdGhlfpxF9uXDZonHr/jU+mNiN5NknCNHOV2nHDS25dn+BsbSG7YwPj6/OaBq9/xvgzxalsNQOwUAnotKiNhI61uQZQu4k0b98zC18boJ+cPM7Sny26FXNGhVSpUwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217766; c=relaxed/simple;
	bh=qWg82UlW2nXIdjK38SgAD2nHaH20QgwU3Cpoxepgx/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlK0B0py4V8Qnhy2wyaXqOaUP9EdT78VDa/SFhDPyPUEgAkzHNSgms8eR2IOJ7v3XbkHiQ43OqhQrO0i//ADCrL6hYV0gcSb34sMUDeaHEv7TYHs+ZsNY0XuoPwgx3eGZeILyPF/QEP1ycH6aR+26LREBZnnCOyQFP8KxnbXHdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKgzIV8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKgzIV8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29737C4CEF1;
	Tue, 26 Aug 2025 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217766;
	bh=qWg82UlW2nXIdjK38SgAD2nHaH20QgwU3Cpoxepgx/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKgzIV8tAdV5oMTXptsfB26inqUB+xrNSNxSBQYdlH1DQdfBja+rtKFrY6twe0+l/
	 /JiQp3tc8e5olsPqShRJrKulr5OjAZUMp/gAkFBfmJOOLQ9p3hKdMEip3ehNo2MeeK
	 2DKPOlgxnIQaxBuYjzF0DAvwWKRKp/ujQm2xbYh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/523] rcu: Protect ->defer_qs_iw_pending from data race
Date: Tue, 26 Aug 2025 13:07:55 +0200
Message-ID: <20250826110930.963877237@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 90c09d57caeca94e6f3f87c49e96a91edd40cbfd ]

On kernels built with CONFIG_IRQ_WORK=y, when rcu_read_unlock() is
invoked within an interrupts-disabled region of code [1], it will invoke
rcu_read_unlock_special(), which uses an irq-work handler to force the
system to notice when the RCU read-side critical section actually ends.
That end won't happen until interrupts are enabled at the soonest.

In some kernels, such as those booted with rcutree.use_softirq=y, the
irq-work handler is used unconditionally.

The per-CPU rcu_data structure's ->defer_qs_iw_pending field is
updated by the irq-work handler and is both read and updated by
rcu_read_unlock_special().  This resulted in the following KCSAN splat:

------------------------------------------------------------------------

BUG: KCSAN: data-race in rcu_preempt_deferred_qs_handler / rcu_read_unlock_special

read to 0xffff96b95f42d8d8 of 1 bytes by task 90 on cpu 8:
 rcu_read_unlock_special+0x175/0x260
 __rcu_read_unlock+0x92/0xa0
 rt_spin_unlock+0x9b/0xc0
 __local_bh_enable+0x10d/0x170
 __local_bh_enable_ip+0xfb/0x150
 rcu_do_batch+0x595/0xc40
 rcu_cpu_kthread+0x4e9/0x830
 smpboot_thread_fn+0x24d/0x3b0
 kthread+0x3bd/0x410
 ret_from_fork+0x35/0x40
 ret_from_fork_asm+0x1a/0x30

write to 0xffff96b95f42d8d8 of 1 bytes by task 88 on cpu 8:
 rcu_preempt_deferred_qs_handler+0x1e/0x30
 irq_work_single+0xaf/0x160
 run_irq_workd+0x91/0xc0
 smpboot_thread_fn+0x24d/0x3b0
 kthread+0x3bd/0x410
 ret_from_fork+0x35/0x40
 ret_from_fork_asm+0x1a/0x30

no locks held by irq_work/8/88.
irq event stamp: 200272
hardirqs last  enabled at (200272): [<ffffffffb0f56121>] finish_task_switch+0x131/0x320
hardirqs last disabled at (200271): [<ffffffffb25c7859>] __schedule+0x129/0xd70
softirqs last  enabled at (0): [<ffffffffb0ee093f>] copy_process+0x4df/0x1cc0
softirqs last disabled at (0): [<0000000000000000>] 0x0

------------------------------------------------------------------------

The problem is that irq-work handlers run with interrupts enabled, which
means that rcu_preempt_deferred_qs_handler() could be interrupted,
and that interrupt handler might contain an RCU read-side critical
section, which might invoke rcu_read_unlock_special().  In the strict
KCSAN mode of operation used by RCU, this constitutes a data race on
the ->defer_qs_iw_pending field.

This commit therefore disables interrupts across the portion of the
rcu_preempt_deferred_qs_handler() that updates the ->defer_qs_iw_pending
field.  This suffices because this handler is not a fast path.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c07a84197173..ed17deba8b18 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -585,10 +585,13 @@ static void rcu_preempt_deferred_qs(struct task_struct *t)
  */
 static void rcu_preempt_deferred_qs_handler(struct irq_work *iwp)
 {
+	unsigned long flags;
 	struct rcu_data *rdp;
 
 	rdp = container_of(iwp, struct rcu_data, defer_qs_iw);
+	local_irq_save(flags);
 	rdp->defer_qs_iw_pending = false;
+	local_irq_restore(flags);
 }
 
 /*
-- 
2.39.5



