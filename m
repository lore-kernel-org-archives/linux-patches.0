Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD82A1E8855;
	Wed, 19 Feb 2025 08:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955326; cv=none; b=OmJu3yKeRQxGQTlJ81o/XFGKU0yy/JdV00ddHmknydZhnrLFE9OORcTiUTeLrV1A8B2B6mNosF2IQMQ52Me8uvWCCX5bF1iMPZwSJt2nC10j/vvcRSGMSycAAoPPl53hwxOye94VwnzSIeSS5dSyLyr3dFci4vkdlfCLS1NY9bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955326; c=relaxed/simple;
	bh=lf8/MmaA/y/ZdV1LNHISSKEWyknWyRoheftqYiK+cf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ivxr0ml0MLTECMjACo2L7C6V/ZzE3BN2wxGE2ImP8gGWoSpHmUgXJEv+GfD5zxTNVL2SCy2GOyzj2SIj0ZzwML5O/0Silcly3D4XuhaRmsXF3NvCB1QoSBEqyQhhO5J85hb/41lqz7JbHffDU9idJsllGL0dICUw1gZ3DNGuhkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nM99JAHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nM99JAHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614FFC4CED1;
	Wed, 19 Feb 2025 08:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955325;
	bh=lf8/MmaA/y/ZdV1LNHISSKEWyknWyRoheftqYiK+cf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nM99JAHkHSZlU81t0BGTPZhZ/6+yjXoLVq4PpPF7TIByeesZhogaaEzcvOlGE8znm
	 /JMnjiw+mZsJgbWdvg4Osk8YYO/C7bS3s/iGShM0gJq7hzpvSOmyuAKfBaAsQF9nlb
	 j75K4u88zbLA++V5/TL1bzyh/lMsjf4uTvMkp0X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/230] clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context
Date: Wed, 19 Feb 2025 09:28:06 +0100
Message-ID: <20250219082608.313062915@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c4e6b5e6af88c..58fb7280cabbe 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -365,10 +365,10 @@ void clocksource_verify_percpu(struct clocksource *cs)
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
@@ -376,6 +376,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 	testcpu = smp_processor_id();
 	pr_info("Checking clocksource %s synchronization from CPU %d to CPUs %*pbl.\n",
 		cs->name, testcpu, cpumask_pr_args(&cpus_chosen));
+	preempt_disable();
 	for_each_cpu(cpu, &cpus_chosen) {
 		if (cpu == testcpu)
 			continue;
@@ -395,6 +396,7 @@ void clocksource_verify_percpu(struct clocksource *cs)
 			cs_nsec_min = cs_nsec;
 	}
 	preempt_enable();
+	migrate_enable();
 	cpus_read_unlock();
 	if (!cpumask_empty(&cpus_ahead))
 		pr_warn("        CPUs %*pbl ahead of CPU %d for clocksource %s.\n",
-- 
2.39.5



