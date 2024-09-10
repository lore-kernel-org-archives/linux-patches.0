Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3264218F2F0;
	Tue, 10 Sep 2024 10:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963846; cv=none; b=Z3gb9xSp0E/sCPrBvFnQXWYL2dUNUGXPNguZcfHdc3l9IeNlwBgCcT/T4f9cgSPVSNN4XU1ysOUl+WKcuT9efMP3NDBXu5imWyUcb0IZbdVXMor1nIhZdhs5ln4c1P9cutInPYVwamm8FJ9OH5gfPLbePi2SyH4aqrZ/NLzh6uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963846; c=relaxed/simple;
	bh=QBaaREHC8zWuvuOz4enQ5hOXgqUR6R0yUNjc+tuaB8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jw3jQyPR39d3NAxkVQ8xgE+K53td1mlED2M1zLw2mvVLzyryR3aYuQSzh8R1E7Bo1hKaJrgThS9slMj7m7mh/R1OXe7jnRnFRWNjJVRmaM2rBh71lvKGeZ0cGCMPfgLJS9aamhc7Qhbz7L1pEixrO5xK1lGzXyt+0jria0YhZWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7U3EqWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7U3EqWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C0C4CEC3;
	Tue, 10 Sep 2024 10:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963846;
	bh=QBaaREHC8zWuvuOz4enQ5hOXgqUR6R0yUNjc+tuaB8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7U3EqWKYepgqodG5UskVRdi7zs0qHc8jfUN3EwlUHnRNvAIxNBq1Fiq828jeB3q/
	 XFIAVDaoJq56GO8a+7dWNX+esqTRPPj+/ZUtbAhOAo4cQKCYe3bWT8mtA7mgNzf/Yj
	 tq7iSLzeIa3nfuazyxBLgmQwoMHI8Ku6LgzHY2oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/214] workqueue: Improve scalability of workqueue watchdog touch
Date: Tue, 10 Sep 2024 11:33:38 +0200
Message-ID: <20240910092606.605536099@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f7975a8f665f..73002260674f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5935,12 +5935,18 @@ static void wq_watchdog_timer_fn(struct timer_list *unused)
 
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



