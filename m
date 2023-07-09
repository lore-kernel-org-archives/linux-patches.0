Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC92522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F0BC433C9;
	Sun,  9 Jul 2023 11:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901546;
	bh=6puezOkIxjxIRVM3GplGySItoLZHRfgSWLtaahwdUB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAZuM9O8KG+Gd0nsRvLvMLnQwTk3ugH7TjdbwffmJ6TbxNyMX3KClOoMyMAwCuRkO
	 dYrv6cjQzkD+soDSbxrSDk5+QuI13PwaB0aOC5sru9K1W1u6hMVQnj4W6QBUabzCbt
	 fnUR5+ewH/+C9NPzFm34WCZTaWQ6cySVUmbYaxWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 058/431] rcu: Make rcu_cpu_starting() rely on interrupts being disabled
Date: Sun,  9 Jul 2023 13:10:06 +0200
Message-ID: <20230709111452.484396873@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 15d44dfa40305da1648de4bf001e91cc63148725 ]

Currently, rcu_cpu_starting() is written so that it might be invoked
with interrupts enabled.  However, it is always called when interrupts
are disabled, either by rcu_init(), notify_cpu_starting(), or from a
call point prior to the call to notify_cpu_starting().

But why bother requiring that interrupts be disabled?  The purpose is
to allow the rcu_data structure's ->beenonline flag to be set after all
early processing has completed for the incoming CPU, thus allowing this
flag to be used to determine when workqueues have been set up for the
incoming CPU, while still allowing this flag to be used as a diagnostic
within rcu_core().

This commit therefore makes rcu_cpu_starting() rely on interrupts being
disabled.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 401b0de3ae4f ("rcu-tasks: Stop rcu_tasks_invoke_cbs() from using never-onlined CPUs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a565dc5c54440..954a91fec912c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4364,15 +4364,16 @@ int rcutree_offline_cpu(unsigned int cpu)
  * Note that this function is special in that it is invoked directly
  * from the incoming CPU rather than from the cpuhp_step mechanism.
  * This is because this function must be invoked at a precise location.
+ * This incoming CPU must not have enabled interrupts yet.
  */
 void rcu_cpu_starting(unsigned int cpu)
 {
-	unsigned long flags;
 	unsigned long mask;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 	bool newcpu;
 
+	lockdep_assert_irqs_disabled();
 	rdp = per_cpu_ptr(&rcu_data, cpu);
 	if (rdp->cpu_started)
 		return;
@@ -4380,7 +4381,6 @@ void rcu_cpu_starting(unsigned int cpu)
 
 	rnp = rdp->mynode;
 	mask = rdp->grpmask;
-	local_irq_save(flags);
 	arch_spin_lock(&rcu_state.ofl_lock);
 	rcu_dynticks_eqs_online();
 	raw_spin_lock(&rcu_state.barrier_lock);
@@ -4399,17 +4399,16 @@ void rcu_cpu_starting(unsigned int cpu)
 	/* An incoming CPU should never be blocking a grace period. */
 	if (WARN_ON_ONCE(rnp->qsmask & mask)) { /* RCU waiting on incoming CPU? */
 		/* rcu_report_qs_rnp() *really* wants some flags to restore */
-		unsigned long flags2;
+		unsigned long flags;
 
-		local_irq_save(flags2);
+		local_irq_save(flags);
 		rcu_disable_urgency_upon_qs(rdp);
 		/* Report QS -after- changing ->qsmaskinitnext! */
-		rcu_report_qs_rnp(mask, rnp, rnp->gp_seq, flags2);
+		rcu_report_qs_rnp(mask, rnp, rnp->gp_seq, flags);
 	} else {
 		raw_spin_unlock_rcu_node(rnp);
 	}
 	arch_spin_unlock(&rcu_state.ofl_lock);
-	local_irq_restore(flags);
 	smp_mb(); /* Ensure RCU read-side usage follows above initialization. */
 }
 
-- 
2.39.2



