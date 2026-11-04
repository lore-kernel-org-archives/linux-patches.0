Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827016;
	b=tV+37eHk30ZihycIS0cTCM4r/EPl8WR0w8u5w6QPrF/GpGEDe+Hj84YvDTEX6J9A6O/S
	 ixU22FWMOD4dA4C+yJOKx6z8P7vtmwHZ/5GWWDPXQ0YVl0zfP9/7g1ZssKayNdTVj+SuG
	 gg0AN94G44eGjyZJou4BSq70wsb5DwwIB0BdjxkGdpuoJbQip78D5mLBM6CyMeGvtuSbh
	 5blupWI4g8B6cY9N/1OfprkbvTc6ts5iiKAKNwjVrBPw9EpUsot4VPC0PPzOJ3uF5xNgj
	 z98eUae/0f99vL2pxwKChESNpx6PG4OboUqoHF3HbmW8JgrBc40CXzk8TGKCO/wzoGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+eWZU0+kc7ZiwXosBEAiwUS1BsuH9bWz9C7dCnZjGGE=;
	b=0LfxoJeoKtmTettFT7Sx3BfPI9FzdUe4rh+Kfn0M7VoiWbj8RnDATVIBDn1X1TqTqqRq
	 uryMznh9TO1NxfRwu0NPWPb4lfGayjzm8g9LGUWmFRuZHZZiuce/+dgcCjIs/+/xnVRJi
	 3blCr/mfUgKkRoQvDgaupeOxzCkIK4rNtCEuu64jqpHIGdpcXZnMghv0U8oXVmhf088C5
	 sLFqQLYSKpGV5GBfT3kvZrfLP+vPskQ0Ju39ldLlN7p16nL2Q5vvXcF++q1ItsmLIClBY
	 ntuE/Omjr6xDGg3vw0InZpkj8u/AaLTFIOpSTy3LJxvZDM0DaAHULk9MzhksDF0oFxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BiXAPsh9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B956070AA5;
	Wed,  4 Nov 2026 21:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BiXAPsh9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181701F0093A;
	Wed,  4 Nov 2026 21:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827016;
	bh=+eWZU0+kc7ZiwXosBEAiwUS1BsuH9bWz9C7dCnZjGGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BiXAPsh9KPX7b83c3Yk3gzIEdMtBjCp/WC+lWFZku+SZGx8mfCo4WWVq3snr0Fn2D
	 aO3e9ikYpb1xxHwXfalyTGQ4R0mGMxLGrpnVuzu6VA5JhnOdGM32rJudGCMCy2Ei9U
	 lU9IdUl5hNK+DKAKWFjwjGXmndKWxkGrhkZfhMXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 7.3 145/547] sched_ext: Fix use-after-free of a local reenq node left on an inactive cpu
Date: Wed,  4 Nov 2026 16:05:29 -0500
Message-ID: <20261104211042.287808063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 43e1ef14a47257ebf7e3bb3ab9a6df9c6f817c5f upstream.

A local DSQ reenq is queued on the rq through a per-sched node and run from
deferred work. When the reenq is requested from dispatch, the work is a
balance callback queued once dispatch is done. A cpu going down installs
balance push early in its teardown, and queue_balance_callback() refuses new
callbacks from then on. ops.dispatch() keeps running on that cpu until the
rq goes offline after an RCU grace period, so a reenq it requests in that
window may never run. The IMMED handling in dispatch_one() requests one the
same way.

A reenq requested from elsewhere for a cpu that is already offline goes
through irq_work_queue_on(), which warns, and its work doesn't run until the
cpu comes back.

Either way the node stays on the rq's list. When the scheduler is freed,
scx_sched_free_rcu_work() warns and frees the pcpu with the node still
linked, and the list is walked again once the cpu comes back.

An inactive cpu's local DSQ holds only tasks that are bound to it or are
being moved off, so the reenq is pointless. Ignore reenqs of an inactive
cpu's local DSQ.

The test is lockless. The hotplug thread of a cpu going down runs on that
cpu, and it marks the cpu inactive before it installs balance push. A
dispatch on the cpu runs to completion before that thread can run there, so
a dispatch that saw the cpu active has queued its callback by then. Requests
from outside dispatch run from the wakeup path or through irq_work, which
balance push doesn't affect. The grace period after the cpu goes inactive
waits for any requester that saw it active, so that irq_work is queued while
the cpu is online.

Fixes: 238eba8c210d ("sched_ext: Use schedule_deferred_locked() in schedule_dsq_reenq()")
Fixes: 76edc2761ab8 ("sched_ext: Use irq_work_queue_on() in schedule_deferred()")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Tested-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -1103,6 +1103,18 @@ void schedule_dsq_reenq(struct scx_sched
 		rq = container_of(dsq, struct rq, scx.local_dsq);
 
 		/*
+		 * An inactive cpu's local DSQ holds only tasks that are bound
+		 * to it or are being moved off, so a reenq of it is pointless.
+		 * Once balance push is installed, queue_balance_callback() also
+		 * drops the callback that would run a reenq requested from
+		 * dispatch, and irq_work_queue_on() can't reach an offline cpu.
+		 * The reenq's node would then stay on this rq's list after
+		 * @sch's pcpu is freed.
+		 */
+		if (unlikely(!cpu_active(cpu_of(rq))))
+			return;
+
+		/*
 		 * A sub-sched lacking baseline access on the target cid has no
 		 * business triggering IPIs. The lockless test is fine: slipping
 		 * through right after a revoke is harmless and a wrong denial
@@ -10020,7 +10032,8 @@ __bpf_kfunc struct task_struct *scx_bpf_
  * - Local DSQs (%SCX_DSQ_LOCAL or %SCX_DSQ_LOCAL_ON | $cpu)
  * - User DSQs
  *
- * Re-enqueues are performed asynchronously. Can be called from anywhere.
+ * Re-enqueues are performed asynchronously. Can be called from anywhere. A
+ * re-enqueue of an inactive cpu's local DSQ is ignored.
  *
  * %SCX_DSQ_LOCAL resolves to the local DSQ of the rq the current scheduler
  * operation is locked to - e.g. the rq being dispatched for in ops.dispatch() -


