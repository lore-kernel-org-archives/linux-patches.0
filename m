Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630FD221F1F;
	Tue, 17 Jun 2025 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174529; cv=none; b=D/NTctEOi6GWUlPsGHM+zOAO7mwh1KNLGCFiylg2DugK5qobYNfYyAUWR0Xh6GdKtjBDDMsg5vLdzNbyW4djew5e9YzebUyWTO3ttweJGYx+VeesqN1zS8tL3qt3i0+1arhPMQ4oGhtGfBdEhAyG1dEUlnaK9490Z4dT5JFIRp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174529; c=relaxed/simple;
	bh=n1ddIwVP5OQGyNOs/B4Ho+vXcNoEIRxeVdCOxRD6olc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah7d+lW2MLmoZOEjHahGszFVVAi7/EQw1SHP794IYePWIlH3dP9wnIIAZbrp7+A+GrKSgIjHdyYEL7ERPdegN/xzenbt4K85/mn33JKAl68hyNSjjBMtl756gMfVKVyU40RygRoFcZvIgtTlwpgcD/c+Vr0rhwp3ugHEQ+eWAcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWhoUqJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWhoUqJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E8FC4CEE3;
	Tue, 17 Jun 2025 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174529;
	bh=n1ddIwVP5OQGyNOs/B4Ho+vXcNoEIRxeVdCOxRD6olc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWhoUqJ9fvPkK15pW0gRfHdamJMLCJBuMj3duD+wlSdkioQIWMjvjXf7FVZ4sPl8i
	 OYeCPT2E+LfBbirfj+wVsYqVJOXOjqyXxF2kufd1rGJU0azagRPSqTbograNz0lUQ/
	 qTrDpiwTRGtZXq6525KN7M1mDWsFx4XhD6wujEZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yongliang Gao <leonylgao@tencent.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/512] rcu/cpu_stall_cputime: fix the hardirq count for x86 architecture
Date: Tue, 17 Jun 2025 17:19:56 +0200
Message-ID: <20250617152420.780669857@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Yongliang Gao <leonylgao@tencent.com>

[ Upstream commit da6b85598af30e9fec34d82882d7e1e39f3da769 ]

When counting the number of hardirqs in the x86 architecture,
it is essential to add arch_irq_stat_cpu to ensure accuracy.

For example, a CPU loop within the rcu_read_lock function.

Before:
[   70.910184] rcu: INFO: rcu_preempt self-detected stall on CPU
[   70.910436] rcu:     3-....: (4999 ticks this GP) idle=***
[   70.910711] rcu:              hardirqs   softirqs   csw/system
[   70.910870] rcu:      number:        0        657            0
[   70.911024] rcu:     cputime:        0          0         2498   ==> 2498(ms)
[   70.911278] rcu:     (t=5001 jiffies g=3677 q=29 ncpus=8)

After:
[   68.046132] rcu: INFO: rcu_preempt self-detected stall on CPU
[   68.046354] rcu:     2-....: (4999 ticks this GP) idle=***
[   68.046628] rcu:              hardirqs   softirqs   csw/system
[   68.046793] rcu:      number:     2498        663            0
[   68.046951] rcu:     cputime:        0          0         2496   ==> 2496(ms)
[   68.047244] rcu:     (t=5000 jiffies g=3825 q=4 ncpus=8)

Fixes: be42f00b73a0 ("rcu: Add RCU stall diagnosis information")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501090842.SfI6QPGS-lkp@intel.com/
Signed-off-by: Yongliang Gao <leonylgao@tencent.com>
Reviewed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Link: https://lore.kernel.org/r/20250216084109.3109837-1-leonylgao@gmail.com
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c       | 10 +++++++---
 kernel/rcu/tree.h       |  2 +-
 kernel/rcu/tree_stall.h |  4 ++--
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4ed8632195217..cefa831c8cb32 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -802,6 +802,10 @@ static int rcu_watching_snap_save(struct rcu_data *rdp)
 	return 0;
 }
 
+#ifndef arch_irq_stat_cpu
+#define arch_irq_stat_cpu(cpu) 0
+#endif
+
 /*
  * Returns positive if the specified CPU has passed through a quiescent state
  * by virtue of being in or having passed through an dynticks idle state since
@@ -937,9 +941,9 @@ static int rcu_watching_snap_recheck(struct rcu_data *rdp)
 			rsrp->cputime_irq     = kcpustat_field(kcsp, CPUTIME_IRQ, cpu);
 			rsrp->cputime_softirq = kcpustat_field(kcsp, CPUTIME_SOFTIRQ, cpu);
 			rsrp->cputime_system  = kcpustat_field(kcsp, CPUTIME_SYSTEM, cpu);
-			rsrp->nr_hardirqs = kstat_cpu_irqs_sum(rdp->cpu);
-			rsrp->nr_softirqs = kstat_cpu_softirqs_sum(rdp->cpu);
-			rsrp->nr_csw = nr_context_switches_cpu(rdp->cpu);
+			rsrp->nr_hardirqs = kstat_cpu_irqs_sum(cpu) + arch_irq_stat_cpu(cpu);
+			rsrp->nr_softirqs = kstat_cpu_softirqs_sum(cpu);
+			rsrp->nr_csw = nr_context_switches_cpu(cpu);
 			rsrp->jiffies = jiffies;
 			rsrp->gp_seq = rdp->gp_seq;
 		}
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index a9a811d9d7a37..1bba2225e7448 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -168,7 +168,7 @@ struct rcu_snap_record {
 	u64		cputime_irq;	/* Accumulated cputime of hard irqs */
 	u64		cputime_softirq;/* Accumulated cputime of soft irqs */
 	u64		cputime_system; /* Accumulated cputime of kernel tasks */
-	unsigned long	nr_hardirqs;	/* Accumulated number of hard irqs */
+	u64		nr_hardirqs;	/* Accumulated number of hard irqs */
 	unsigned int	nr_softirqs;	/* Accumulated number of soft irqs */
 	unsigned long long nr_csw;	/* Accumulated number of task switches */
 	unsigned long   jiffies;	/* Track jiffies value */
diff --git a/kernel/rcu/tree_stall.h b/kernel/rcu/tree_stall.h
index 4432db6d0b99b..4d524a2212a8d 100644
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -457,8 +457,8 @@ static void print_cpu_stat_info(int cpu)
 	rsr.cputime_system  = kcpustat_field(kcsp, CPUTIME_SYSTEM, cpu);
 
 	pr_err("\t         hardirqs   softirqs   csw/system\n");
-	pr_err("\t number: %8ld %10d %12lld\n",
-		kstat_cpu_irqs_sum(cpu) - rsrp->nr_hardirqs,
+	pr_err("\t number: %8lld %10d %12lld\n",
+		kstat_cpu_irqs_sum(cpu) + arch_irq_stat_cpu(cpu) - rsrp->nr_hardirqs,
 		kstat_cpu_softirqs_sum(cpu) - rsrp->nr_softirqs,
 		nr_context_switches_cpu(cpu) - rsrp->nr_csw);
 	pr_err("\tcputime: %8lld %10lld %12lld   ==> %d(ms)\n",
-- 
2.39.5



