Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598101E1A3B;
	Wed, 19 Feb 2025 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957468; cv=none; b=H8dP9bPv7IcxUDY4EQBr2jrU3QMCasgVtjTOFDvKTdyXWzrmir9y3dOFFIRWkd9mG8wcl/eqlj4AzF7Lm1vt8QIPdqkEswWWfgUBeBX04DnrehJkal9H5EWz7Z0xT47eKCzZk2unHI0nAez/vC5IHTqglpewfGtz0YDnSKZ5UO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957468; c=relaxed/simple;
	bh=cVaIVKPemQp15vEozkgVJjF+zLm3xmphku/siyuJe/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWv7exUU8gzftZoaWD5DNGADIQRJCxQsFXx5CEWBIejCHiO0m2OzZamB9qtTWcl3VIl6FtTcDxyJ+rzZnjGE3uEvhal3zidWVRAp44fgs3f3CcIq9JB2bNA5ZIT4+1PDeGd1tebG8PsQDtDAgTr+vTe6WYePwhFPGAymu6nk0vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWuZHqN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWuZHqN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4344C4CED1;
	Wed, 19 Feb 2025 09:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957468;
	bh=cVaIVKPemQp15vEozkgVJjF+zLm3xmphku/siyuJe/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWuZHqN66YCfzQSjjIivg/B2XYDYkp575MQNEtr/ZlzrTAc+mJCLCwCz9qPYlb7w/
	 uVK+hllP+SxYj43qAtkI3ZKJ+CQ/bS1GwGHTXkaJ42XqwMgUaFchNRVT+yMEV5hOZG
	 JYcJjWYeh6UpFv20gduSXuBRJh8ykuKX1qibk2+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 537/578] clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context
Date: Wed, 19 Feb 2025 09:29:01 +0100
Message-ID: <20250219082714.098560734@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 51afd4cc2d004..9e221a97d2274 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -348,10 +348,10 @@ void clocksource_verify_percpu(struct clocksource *cs)
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
@@ -359,6 +359,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 	testcpu = smp_processor_id();
 	pr_info("Checking clocksource %s synchronization from CPU %d to CPUs %*pbl.\n",
 		cs->name, testcpu, cpumask_pr_args(&cpus_chosen));
+	preempt_disable();
 	for_each_cpu(cpu, &cpus_chosen) {
 		if (cpu == testcpu)
 			continue;
@@ -378,6 +379,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 			cs_nsec_min = cs_nsec;
 	}
 	preempt_enable();
+	migrate_enable();
 	cpus_read_unlock();
 	if (!cpumask_empty(&cpus_ahead))
 		pr_warn("        CPUs %*pbl ahead of CPU %d for clocksource %s.\n",
-- 
2.39.5



