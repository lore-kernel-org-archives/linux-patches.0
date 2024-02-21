Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B00E80623;
	Wed, 21 Feb 2024 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524677; cv=none; b=Oq3iTPkEdxbCjTv7OL+EtJDQWgRmmnCNTV8q+7/urhvHYiN/EdkdClDGWJ7ZIwdIove9RATt2VWY4EHENMGZmu4PwKV0T0Ea+20VkqnXPI7C7NfIlFxYSXm0BbAYd5j8ZEBpjDqtY6TQqt0yH20sZejjFy25r7GOjr9O+Ly6tk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524677; c=relaxed/simple;
	bh=9Haq2BMRrdrE/CVLF8y+nbFQ18gPSw/f39JeJhw5SSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6sA5SXTTHZYGXoXAtiYxmcWRgO4FV6jo+t+EakekH8Km+16AigL7CSHTtm+miahjDaNNROfJBH0/qnb69D/m7M9Aqbex5vENipcz2UxTEsFg9nlPJ1PzxEX6CAvc4Mp8xXt6EeF9ItWCIk3VbphMDu1ohK/uVjsnEaXg8/8GWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4P8c734; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4P8c734"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7CDC433F1;
	Wed, 21 Feb 2024 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524677;
	bh=9Haq2BMRrdrE/CVLF8y+nbFQ18gPSw/f39JeJhw5SSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4P8c734EHu16HKDYbDhgSKsZelYDJELA/BCwowOfHnNZAHzTSROUYF2IlFH6j5dY
	 gR5Vp3TVvN5ud1qruq7qmebIFrbiafXlgz9Hr8m01jiDos/CGjvZ12S+kiIGp6SX5b
	 ZsQVzrN4UuepJ+zbV/vfrWeheNoUh+tkN1g7/GIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 278/379] hrtimer: Report offline hrtimer enqueue
Date: Wed, 21 Feb 2024 14:07:37 +0100
Message-ID: <20240221130003.128909454@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

commit dad6a09f3148257ac1773cd90934d721d68ab595 upstream.

The hrtimers migration on CPU-down hotplug process has been moved
earlier, before the CPU actually goes to die. This leaves a small window
of opportunity to queue an hrtimer in a blind spot, leaving it ignored.

For example a practical case has been reported with RCU waking up a
SCHED_FIFO task right before the CPUHP_AP_IDLE_DEAD stage, queuing that
way a sched/rt timer to the local offline CPU.

Make sure such situations never go unnoticed and warn when that happens.

Fixes: 5c0930ccaad5 ("hrtimers: Push pending hrtimers away from outgoing CPU earlier")
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240129235646.3171983-4-boqun.feng@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hrtimer.h |    4 +++-
 kernel/time/hrtimer.c   |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -197,6 +197,7 @@ enum  hrtimer_base_type {
  * @max_hang_time:	Maximum time spent in hrtimer_interrupt
  * @softirq_expiry_lock: Lock which is taken while softirq based hrtimer are
  *			 expired
+ * @online:		CPU is online from an hrtimers point of view
  * @timer_waiters:	A hrtimer_cancel() invocation waits for the timer
  *			callback to finish.
  * @expires_next:	absolute time of the next event, is required for remote
@@ -219,7 +220,8 @@ struct hrtimer_cpu_base {
 	unsigned int			hres_active		: 1,
 					in_hrtirq		: 1,
 					hang_detected		: 1,
-					softirq_activated       : 1;
+					softirq_activated       : 1,
+					online			: 1;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	unsigned int			nr_events;
 	unsigned short			nr_retries;
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -980,6 +980,7 @@ static int enqueue_hrtimer(struct hrtime
 			   enum hrtimer_mode mode)
 {
 	debug_activate(timer, mode);
+	WARN_ON_ONCE(!base->cpu_base->online);
 
 	base->cpu_base->active_bases |= 1 << base->index;
 
@@ -2078,6 +2079,7 @@ int hrtimers_prepare_cpu(unsigned int cp
 	cpu_base->softirq_next_timer = NULL;
 	cpu_base->expires_next = KTIME_MAX;
 	cpu_base->softirq_expires_next = KTIME_MAX;
+	cpu_base->online = 1;
 	hrtimer_cpu_base_init_expiry_lock(cpu_base);
 	return 0;
 }
@@ -2145,6 +2147,7 @@ int hrtimers_cpu_dying(unsigned int dyin
 	smp_call_function_single(ncpu, retrigger_next_event, NULL, 0);
 
 	raw_spin_unlock(&new_base->lock);
+	old_base->online = 0;
 	raw_spin_unlock(&old_base->lock);
 
 	return 0;


