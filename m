Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A13D1C82F4;
	Wed, 19 Feb 2025 08:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954418; cv=none; b=ne+yPhlA0iNboVOTgU/BSLY/m12tIj5qGQDqvU2QGhw4F1bFj6xLAZvUSoVZp7M3R+gQ3VpzhU5cKE9YNM2QXYdAtHNNFBTBC0xLpI3GfppfWA3168ZvyJBgEllINw2M9rZThljhrYFKXVXVVC2DzhA29B9C832f2xBdZx/kuew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954418; c=relaxed/simple;
	bh=p534Dg/GgL3gteCIM8xwVRPKYBfi/k5Bvfv86xcO9GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPENXa5cSKq9MfOhBOR9SqhPldx1hYvncG32bgZycMRY/1PfhAzxKyEbSjzB4GSPjvstNvzJOiI1zu8hHBCLX9wctRROZGpVKRKNphQHqr1iJ40hN9eyaAW5Hiu4fkeJWx7oKiuOueXztxRAcUuxPhBxSIu2UyytarFcRu4JrMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix6imb6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix6imb6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C017AC4CEE8;
	Wed, 19 Feb 2025 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954418;
	bh=p534Dg/GgL3gteCIM8xwVRPKYBfi/k5Bvfv86xcO9GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ix6imb6UsqNuB4fABLZ9JH0lqeQjH1R5AZY85PTU8NZWD1c19b05FBue0fFtX6MO9
	 my8pXhETq00r6jUt9DaB+0Gj+KaiADFw96JknbYwE/y2L/lTC9Ax/PvN5bGLnhHpPd
	 N969PSM8Q9ZQTyFyEvMkfx0f4pVo+ktI3Pq8z1mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 198/274] clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context
Date: Wed, 19 Feb 2025 09:27:32 +0100
Message-ID: <20250219082617.331756652@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 77d9566d3aa68..2a7802ec480cc 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -373,10 +373,10 @@ void clocksource_verify_percpu(struct clocksource *cs)
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
@@ -384,6 +384,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 	testcpu = smp_processor_id();
 	pr_info("Checking clocksource %s synchronization from CPU %d to CPUs %*pbl.\n",
 		cs->name, testcpu, cpumask_pr_args(&cpus_chosen));
+	preempt_disable();
 	for_each_cpu(cpu, &cpus_chosen) {
 		if (cpu == testcpu)
 			continue;
@@ -403,6 +404,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 			cs_nsec_min = cs_nsec;
 	}
 	preempt_enable();
+	migrate_enable();
 	cpus_read_unlock();
 	if (!cpumask_empty(&cpus_ahead))
 		pr_warn("        CPUs %*pbl ahead of CPU %d for clocksource %s.\n",
-- 
2.39.5



