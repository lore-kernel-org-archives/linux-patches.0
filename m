Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B361184549;
	Tue, 10 Sep 2024 10:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964573; cv=none; b=KjQ5vctCVX0ZwZK+uE2Wu6cj7RB7e+01aw/PLvgN/9a7lNNQ3Ql+nL7UBJbkwQGCcqMXJYVvksb21OUv9oa8QbtVDFDYFJ42liPosN4ePJOn4+h33FPOHwtUgzbCtB/eqx9KHcPJr0nO9EYz5XWJehLj39MUXQX7ouklpgvG29s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964573; c=relaxed/simple;
	bh=PopzS1501iec4yNi+IdJDqkjQtuAhyQCeseIhgz5oeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLwrKWfbSre/Z/eNx+EjshsUx5J2VI9P5O4zvK04gd6PxrHR6CJTZy8GC2HT+txpR334hfFuNq4fIrMnS+8hyxGnIUiSkUQBSgl3WEG86lzr2fNqWOsv9SNdpF+mF4cIOx6TIIBeY7VvccwxeeXTzvUSds92jE4ghHzP3p1A2Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7rr+YfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7rr+YfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D99C4CEC3;
	Tue, 10 Sep 2024 10:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964572;
	bh=PopzS1501iec4yNi+IdJDqkjQtuAhyQCeseIhgz5oeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7rr+YfQhEJsk5zCCeDWdnssuo7Fo7y2shtp/ksigweyPl94SyPkN2MBWPrqPH89y
	 LmtKJBvoQeGnbk5QYbISMYhUfelMuQ1RFAKntm2RA7LmfqAtNwNxjcGuMgdHsWV7xH
	 ZxLhKyNDxQCqLf7TPxh9NNYk8NZWVyFG2ihFt+C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/269] workqueue: Improve scalability of workqueue watchdog touch
Date: Tue, 10 Sep 2024 11:33:35 +0200
Message-ID: <20240910092616.059325913@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index a1665c2e04b4..7fa1c7c9151a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6456,12 +6456,18 @@ static void wq_watchdog_timer_fn(struct timer_list *unused)
 
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



