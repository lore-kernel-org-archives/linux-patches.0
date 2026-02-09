Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BFD37A496;
	Mon,  9 Feb 2026 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647235; cv=none; b=qElNaPyPSBWkQ5/eCMUl0jjbExnQjjo2YYyT1DzRXSLtw0dzhN0iZDXXEm2N+hNyypNLeZb9ogH/NYAtFFXllc5hTNG/7hT/BcTJrbT3tLReL3d/zLeq56a5Tu4iSNUMmUbQNLgz/y5nA1xdIqGWGCTKd2vBIegK5Hp8B7JXpj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647235; c=relaxed/simple;
	bh=TtM1BxRkj9sVukwLvRPHRjdown23kdbA2awTzAeNzek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2IZPTxQG0wLlbqvsoXHWgy9m4iEMSZrCJs9hJ6J+Mc3LgwoMg6nRJAerHdgQlpmWkYACxLBL38yA0xNNTMGT4UxkWToTZv6QY9z3AX3TlvPYpavFzpHpFAvCq4Sxey7FaHMeLXM23ZfnDt0qW+woN+XaQfMi9tY2l6XJfu0rjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fq4a28/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq4a28/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49613C116C6;
	Mon,  9 Feb 2026 14:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647235;
	bh=TtM1BxRkj9sVukwLvRPHRjdown23kdbA2awTzAeNzek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fq4a28/X3X5MbDbTPOzl2WR69aOxG7S4YkPcfxby+ISv4sBM1WH+inURQ+mNH1wXd
	 h+NJvnjxuOhh3KFKKkm7Dg9zeVPcskCCPXRWawblf3TtSvAJPj9oBBaqrzZTJ5rFzn
	 ZvDFyJB2f2m3zRF0M285GDu57U29gjJ7orhw8OQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Mohini Narkhede <mohini.narkhede@intel.com>
Subject: [PATCH 6.18 039/175] sched/fair: Skip sched_balance_running cmpxchg when balance is not due
Date: Mon,  9 Feb 2026 15:21:52 +0100
Message-ID: <20260209142321.882529723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

commit 3324b2180c17b21c31c16966cc85ca41a7c93703 upstream.

The NUMA sched domain sets the SD_SERIALIZE flag by default, allowing
only one NUMA load balancing operation to run system-wide at a time.

Currently, each sched group leader directly under NUMA domain attempts
to acquire the global sched_balance_running flag via cmpxchg() before
checking whether load balancing is due or whether it is the designated
load balancer for that NUMA domain. On systems with a large number
of cores, this causes significant cache contention on the shared
sched_balance_running flag.

This patch reduces unnecessary cmpxchg() operations by first checking
that the balancer is the designated leader for a NUMA domain from
should_we_balance(), and the balance interval has expired before
trying to acquire sched_balance_running to load balance a NUMA
domain.

On a 2-socket Granite Rapids system with sub-NUMA clustering enabled,
running an OLTP workload, 7.8% of total CPU cycles were previously spent
in sched_balance_domain() contending on sched_balance_running before
this change.

         : 104              static __always_inline int arch_atomic_cmpxchg(atomic_t *v, int old, int new)
         : 105              {
         : 106              return arch_cmpxchg(&v->counter, old, new);
    0.00 :   ffffffff81326e6c:       xor    %eax,%eax
    0.00 :   ffffffff81326e6e:       mov    $0x1,%ecx
    0.00 :   ffffffff81326e73:       lock cmpxchg %ecx,0x2394195(%rip)        # ffffffff836bb010 <sched_balance_running>
         : 110              sched_balance_domains():
         : 12234            if (atomic_cmpxchg_acquire(&sched_balance_running, 0, 1))
   99.39 :   ffffffff81326e7b:       test   %eax,%eax
    0.00 :   ffffffff81326e7d:       jne    ffffffff81326e99 <sched_balance_domains+0x209>
         : 12238            if (time_after_eq(jiffies, sd->last_balance + interval)) {
    0.00 :   ffffffff81326e7f:       mov    0x14e2b3a(%rip),%rax        # ffffffff828099c0 <jiffies_64>
    0.00 :   ffffffff81326e86:       sub    0x48(%r14),%rax
    0.00 :   ffffffff81326e8a:       cmp    %rdx,%rax

After applying this fix, sched_balance_domain() is gone from the profile
and there is a 5% throughput improvement.

[peterz: made it so that redo retains the 'lock' and split out the
         CPU_NEWLY_IDLE change to a separate patch]
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.ibm.com>
Tested-by: Mohini Narkhede <mohini.narkhede@intel.com>
Tested-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Link: https://patch.msgid.link/6fed119b723c71552943bfe5798c93851b30a361.1762800251.git.tim.c.chen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   54 ++++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11693,6 +11693,21 @@ static void update_lb_imbalance_stat(str
 }
 
 /*
+ * This flag serializes load-balancing passes over large domains
+ * (above the NODE topology level) - only one load-balancing instance
+ * may run at a time, to reduce overhead on very large systems with
+ * lots of CPUs and large NUMA distances.
+ *
+ * - Note that load-balancing passes triggered while another one
+ *   is executing are skipped and not re-tried.
+ *
+ * - Also note that this does not serialize rebalance_domains()
+ *   execution, as non-SD_SERIALIZE domains will still be
+ *   load-balanced in parallel.
+ */
+static atomic_t sched_balance_running = ATOMIC_INIT(0);
+
+/*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
  */
@@ -11717,6 +11732,7 @@ static int sched_balance_rq(int this_cpu
 		.fbq_type	= all,
 		.tasks		= LIST_HEAD_INIT(env.tasks),
 	};
+	bool need_unlock = false;
 
 	cpumask_and(cpus, sched_domain_span(sd), cpu_active_mask);
 
@@ -11728,6 +11744,14 @@ redo:
 		goto out_balanced;
 	}
 
+	if (!need_unlock && (sd->flags & SD_SERIALIZE) && idle != CPU_NEWLY_IDLE) {
+		int zero = 0;
+		if (!atomic_try_cmpxchg_acquire(&sched_balance_running, &zero, 1))
+			goto out_balanced;
+
+		need_unlock = true;
+	}
+
 	group = sched_balance_find_src_group(&env);
 	if (!group) {
 		schedstat_inc(sd->lb_nobusyg[idle]);
@@ -11968,6 +11992,9 @@ out_one_pinned:
 	    sd->balance_interval < sd->max_interval)
 		sd->balance_interval *= 2;
 out:
+	if (need_unlock)
+		atomic_set_release(&sched_balance_running, 0);
+
 	return ld_moved;
 }
 
@@ -12093,21 +12120,6 @@ out_unlock:
 }
 
 /*
- * This flag serializes load-balancing passes over large domains
- * (above the NODE topology level) - only one load-balancing instance
- * may run at a time, to reduce overhead on very large systems with
- * lots of CPUs and large NUMA distances.
- *
- * - Note that load-balancing passes triggered while another one
- *   is executing are skipped and not re-tried.
- *
- * - Also note that this does not serialize rebalance_domains()
- *   execution, as non-SD_SERIALIZE domains will still be
- *   load-balanced in parallel.
- */
-static atomic_t sched_balance_running = ATOMIC_INIT(0);
-
-/*
  * Scale the max sched_balance_rq interval with the number of CPUs in the system.
  * This trades load-balance latency on larger machines for less cross talk.
  */
@@ -12175,7 +12187,7 @@ static void sched_balance_domains(struct
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
-	int need_serialize, need_decay = 0;
+	int need_decay = 0;
 	u64 max_cost = 0;
 
 	rcu_read_lock();
@@ -12199,13 +12211,6 @@ static void sched_balance_domains(struct
 		}
 
 		interval = get_sd_balance_interval(sd, busy);
-
-		need_serialize = sd->flags & SD_SERIALIZE;
-		if (need_serialize) {
-			if (atomic_cmpxchg_acquire(&sched_balance_running, 0, 1))
-				goto out;
-		}
-
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
 			if (sched_balance_rq(cpu, rq, sd, idle, &continue_balancing)) {
 				/*
@@ -12219,9 +12224,6 @@ static void sched_balance_domains(struct
 			sd->last_balance = jiffies;
 			interval = get_sd_balance_interval(sd, busy);
 		}
-		if (need_serialize)
-			atomic_set_release(&sched_balance_running, 0);
-out:
 		if (time_after(next_balance, sd->last_balance + interval)) {
 			next_balance = sd->last_balance + interval;
 			update_next_balance = 1;


