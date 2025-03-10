Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352CC1C4A24;
	Mon, 10 Mar 2025 18:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629745; cv=none; b=EFZpZx1wg8AyYyFauFUAer5OAGDSPaLVvOLJNK8naZoCuEfKMA1TcAC1DrE5POl3G2ZTfvFx2p/8gX/eqw5rsEYJgN+1vSsCaWnLGW8Wkyc8RYqv9ell7hrMPVChq6cxPsyrk7zobMx8/VezDausGqdMPBycL9iUDGfntXxhTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629745; c=relaxed/simple;
	bh=g5d9NLG7k54W7ZHSwsCz6RsYLm1Tgnplb1/PGmJUqVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAZ1dfpBalHU6kJ7rHWTXWq34iQ1jS0rPm6OoW/dFFPpOq0WnLEVpSxCCCcj1PjhyWPMrtq6DfaTk8b3LF++4zcCW8JgqUNyv7nmjX3VtinKJCrZV5Hjl3oTZyYzyygfyrS7ttHiEiZ5eptthM/rPjQCFZFjIbqJ8UmdPvuamrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhqck++Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhqck++Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A81C4CEE5;
	Mon, 10 Mar 2025 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629744;
	bh=g5d9NLG7k54W7ZHSwsCz6RsYLm1Tgnplb1/PGmJUqVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhqck++Q4vKiiL/HwM06wNiRHZP7IdRwqXgFiyIAdLCWhL79q54UGtMBybO7pZQT+
	 kbeolNM1Uh09mCOirDC3XFxOaCXeemyvM7zONtP2g/cPb5XKwFz65mOwiWC4+cU88+
	 x/Ne5WO5XldG4fbu/sJN4LhsZrDdw+DKhN7dA3Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/620] clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context
Date: Mon, 10 Mar 2025 18:03:57 +0100
Message-ID: <20250310170601.029807331@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 6bb05a33337b2c842373857b63de5c9bf1ae2a09 ]

The following bug report happened with a PREEMPT_RT kernel:

  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2012, name: kwatchdog
  preempt_count: 1, expected: 0
  RCU nest depth: 0, expected: 0
  get_random_u32+0x4f/0x110
  clocksource_verify_choose_cpus+0xab/0x1a0
  clocksource_verify_percpu.part.0+0x6b/0x330
  clocksource_watchdog_kthread+0x193/0x1a0

It is due to the fact that clocksource_verify_choose_cpus() is invoked with
preemption disabled.  This function invokes get_random_u32() to obtain
random numbers for choosing CPUs.  The batched_entropy_32 local lock and/or
the base_crng.lock spinlock in driver/char/random.c will be acquired during
the call. In PREEMPT_RT kernel, they are both sleeping locks and so cannot
be acquired in atomic context.

Fix this problem by using migrate_disable() to allow smp_processor_id() to
be reliably used without introducing atomic context. preempt_disable() is
then called after clocksource_verify_choose_cpus() but before the
clocksource measurement is being run to avoid introducing unexpected
latency.

Fixes: 7560c02bdffb ("clocksource: Check per-CPU clock synchronization when marked unstable")
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/all/20250131173323.891943-2-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 8d9b11555f7ef..32efc87c41f20 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -342,10 +342,10 @@ void clocksource_verify_percpu(struct clocksource *cs)
 	cpumask_clear(&cpus_ahead);
 	cpumask_clear(&cpus_behind);
 	cpus_read_lock();
-	preempt_disable();
+	migrate_disable();
 	clocksource_verify_choose_cpus();
 	if (cpumask_empty(&cpus_chosen)) {
-		preempt_enable();
+		migrate_enable();
 		cpus_read_unlock();
 		pr_warn("Not enough CPUs to check clocksource '%s'.\n", cs->name);
 		return;
@@ -353,6 +353,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 	testcpu = smp_processor_id();
 	pr_info("Checking clocksource %s synchronization from CPU %d to CPUs %*pbl.\n",
 		cs->name, testcpu, cpumask_pr_args(&cpus_chosen));
+	preempt_disable();
 	for_each_cpu(cpu, &cpus_chosen) {
 		if (cpu == testcpu)
 			continue;
@@ -372,6 +373,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 			cs_nsec_min = cs_nsec;
 	}
 	preempt_enable();
+	migrate_enable();
 	cpus_read_unlock();
 	if (!cpumask_empty(&cpus_ahead))
 		pr_warn("        CPUs %*pbl ahead of CPU %d for clocksource %s.\n",
-- 
2.39.5



