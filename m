Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51205205ACF;
	Thu, 12 Dec 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017308; cv=none; b=QzzBStwS6kqwJ7j4fR7JjSUMlM6NbI8tREKGkc5YtS0+sler0U+46NGkHagWxgUdfWlc40gv0XtYQihAzzDNVGeeLK6vreyalDs33A8n0VBGU3pgpy1eXdVXXIABsymWAySt48H5G4blfdT7/2oMS+jc7yI0qVkryVKzLDPh9z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017308; c=relaxed/simple;
	bh=XA7fvPy4ofHtdzx84EVuPTFyTcEyNuDLs5U9e3msgWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6jwwPnPOz0pqOBjjbtma2G6bBLLCaKuH9n1UN/A8VR2tmyl65ziN7uO6Fjkmyy/iOcooR+IO62hJvKeJ4TpcgYDcT8DvjT+Kk4KHDDhdXo6mkubqET/o3LBsx8gSPaGGTsiU375M8E9P5PQTRgL3eylTO9pzDrfS0BjMkfQNqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peV6Z/Ho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peV6Z/Ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6885C4CECE;
	Thu, 12 Dec 2024 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017308;
	bh=XA7fvPy4ofHtdzx84EVuPTFyTcEyNuDLs5U9e3msgWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peV6Z/Hor0/inyptqGSje9HSxFncU/tAjl1kR8hijxasJDtNlg/vFU2osm3d6mGxb
	 1s2NZ143M9LPl80H012CnAXhVTXp1Z/8dAEQlzryclMs9XYfJ3+/6OmnQ6Ohi72z6W
	 mScck7ykXDc5ENut5v72t2BqRmOZdGB058N/JbMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <julia.lawall@inria.fr>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 442/466] sched/core: Prevent wakeup of ksoftirqd during idle load balance
Date: Thu, 12 Dec 2024 16:00:11 +0100
Message-ID: <20241212144324.320035449@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit e932c4ab38f072ce5894b2851fea8bc5754bb8e5 ]

Scheduler raises a SCHED_SOFTIRQ to trigger a load balancing event on
from the IPI handler on the idle CPU. If the SMP function is invoked
from an idle CPU via flush_smp_call_function_queue() then the HARD-IRQ
flag is not set and raise_softirq_irqoff() needlessly wakes ksoftirqd
because soft interrupts are handled before ksoftirqd get on the CPU.

Adding a trace_printk() in nohz_csd_func() at the spot of raising
SCHED_SOFTIRQ and enabling trace events for sched_switch, sched_wakeup,
and softirq_entry (for SCHED_SOFTIRQ vector alone) helps observing the
current behavior:

       <idle>-0   [000] dN.1.:  nohz_csd_func: Raising SCHED_SOFTIRQ from nohz_csd_func
       <idle>-0   [000] dN.4.:  sched_wakeup: comm=ksoftirqd/0 pid=16 prio=120 target_cpu=000
       <idle>-0   [000] .Ns1.:  softirq_entry: vec=7 [action=SCHED]
       <idle>-0   [000] .Ns1.:  softirq_exit: vec=7  [action=SCHED]
       <idle>-0   [000] d..2.:  sched_switch: prev_comm=swapper/0 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=ksoftirqd/0 next_pid=16 next_prio=120
  ksoftirqd/0-16  [000] d..2.:  sched_switch: prev_comm=ksoftirqd/0 prev_pid=16 prev_prio=120 prev_state=S ==> next_comm=swapper/0 next_pid=0 next_prio=120
       ...

Use __raise_softirq_irqoff() to raise the softirq. The SMP function call
is always invoked on the requested CPU in an interrupt handler. It is
guaranteed that soft interrupts are handled at the end.

Following are the observations with the changes when enabling the same
set of events:

       <idle>-0       [000] dN.1.: nohz_csd_func: Raising SCHED_SOFTIRQ for nohz_idle_balance
       <idle>-0       [000] dN.1.: softirq_raise: vec=7 [action=SCHED]
       <idle>-0       [000] .Ns1.: softirq_entry: vec=7 [action=SCHED]

No unnecessary ksoftirqd wakeups are seen from idle task's context to
service the softirq.

Fixes: b2a02fc43a1f ("smp: Optimize send_call_function_single_ipi()")
Closes: https://lore.kernel.org/lkml/fcf823f-195e-6c9a-eac3-25f870cb35ac@inria.fr/ [1]
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20241119054432.6405-5-kprateek.nayak@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 33bc43b223cba..6cc12777bb11a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1244,7 +1244,7 @@ static void nohz_csd_func(void *info)
 	rq->idle_balance = idle_cpu(cpu);
 	if (rq->idle_balance) {
 		rq->nohz_idle_balance = flags;
-		raise_softirq_irqoff(SCHED_SOFTIRQ);
+		__raise_softirq_irqoff(SCHED_SOFTIRQ);
 	}
 }
 
-- 
2.43.0



