Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122AF186615;
	Tue, 10 Sep 2024 10:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963292; cv=none; b=Mqyom8JmCEtprU64+3ofqMS0s4CTiScjWjuctbv58T4slwjyMKdKq0L0NIsSeSoqCy4nB0ftbcqoRmbYTgZPftIvBX9optP5FsPWWeJXn7ad4+HMOpQpq3hNRwswP8MbI7/eqccoBmnRhV2Vfe8U1HQ9+xx2WIaXVDzKgPLSzmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963292; c=relaxed/simple;
	bh=9klHJAiXqqsYLVqqousCHzOfrjs6r3i/HzFRXsemJuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9MQi+0L3BLetPOjStjeWZj65A/tqWrh98T/Dl7j2mx60Lh8DVyIkI2oeiCntHr/cCoE0I4EtuUgzrKRMfJc6ejrNLbo4cbsEtpbPe+6HGPJd1HBuLjTDEAx+Eh233rEqlBANh6WeSgWUj6RdnVGsgQZu8Xac3kcxBWhplmTubQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0ujwJUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0ujwJUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2FAC4CECF;
	Tue, 10 Sep 2024 10:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963291;
	bh=9klHJAiXqqsYLVqqousCHzOfrjs6r3i/HzFRXsemJuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0ujwJUOEvyvmNtrhivuQFP0w1Bi1DHOeNKxO6y2XBbq0XIP8QipO2ZJQhuhDPOI8
	 ffk+Gjtf78hlgRMe35JUqGbtuvwr4crK8zC46WXoJyZbYWNmhWei/nnTp5JW41DRiM
	 BpJhJg3lWkaXNgclC1H3/X3UGeSN7BVVjcvbHuNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/192] workqueue: Improve scalability of workqueue watchdog touch
Date: Tue, 10 Sep 2024 11:33:08 +0200
Message-ID: <20240910092604.678233735@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 98f887f820c993e05a12e8aa816c80b8661d4c87 ]

On a ~2000 CPU powerpc system, hard lockups have been observed in the
workqueue code when stop_machine runs (in this case due to CPU hotplug).
This is due to lots of CPUs spinning in multi_cpu_stop, calling
touch_nmi_watchdog() which ends up calling wq_watchdog_touch().
wq_watchdog_touch() writes to the global variable wq_watchdog_touched,
and that can find itself in the same cacheline as other important
workqueue data, which slows down operations to the point of lockups.

In the case of the following abridged trace, worker_pool_idr was in
the hot line, causing the lockups to always appear at idr_find.

  watchdog: CPU 1125 self-detected hard LOCKUP @ idr_find
  Call Trace:
  get_work_pool
  __queue_work
  call_timer_fn
  run_timer_softirq
  __do_softirq
  do_softirq_own_stack
  irq_exit
  timer_interrupt
  decrementer_common_virt
  * interrupt: 900 (timer) at multi_cpu_stop
  multi_cpu_stop
  cpu_stopper_thread
  smpboot_thread_fn
  kthread

Fix this by having wq_watchdog_touch() only write to the line if the
last time a touch was recorded exceeds 1/4 of the watchdog threshold.

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4da8a5e702f8..93303148a434 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5891,12 +5891,18 @@ static void wq_watchdog_timer_fn(struct timer_list *unused)
 
 notrace void wq_watchdog_touch(int cpu)
 {
+	unsigned long thresh = READ_ONCE(wq_watchdog_thresh) * HZ;
+	unsigned long touch_ts = READ_ONCE(wq_watchdog_touched);
+	unsigned long now = jiffies;
+
 	if (cpu >= 0)
-		per_cpu(wq_watchdog_touched_cpu, cpu) = jiffies;
+		per_cpu(wq_watchdog_touched_cpu, cpu) = now;
 	else
 		WARN_ONCE(1, "%s should be called with valid CPU", __func__);
 
-	wq_watchdog_touched = jiffies;
+	/* Don't unnecessarily store to global cacheline */
+	if (time_after(now, touch_ts + thresh / 4))
+		WRITE_ONCE(wq_watchdog_touched, jiffies);
 }
 
 static void wq_watchdog_set_thresh(unsigned long thresh)
-- 
2.43.0



