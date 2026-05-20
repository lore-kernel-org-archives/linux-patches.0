Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322D63D88FC;
	Wed, 20 May 2026 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297586; cv=none; b=N69ZLXey+5krPDMIEVmGbegQOKXJgDvLviVI1vTAvaTZAi6Pn+gTESjR//O3PSyE+4EMczoQokPlpLq7XKfHlJdYm9f2pX6GJKsjK2tNi32hy8qccOw0DpS+A2eaaaO9sXPs5vZWlKyZYT0amX3R/yBg5Z9AVsDKSLDQZmrwlCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297586; c=relaxed/simple;
	bh=FKUC+IVSbnSfhaszYq4DRFLDYk5+sVEi4HXL+afKeFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k63ZuY5vF7ekImpIMDoT6EofUrQa46m2nZAcBJaa2mjEshyJaP5uGOGlNaaLoEDgurmTlKTrDG0Nct1AMzhOmxMyp0WDvN56+Yu2C1jGXWkJmvwK/5X3ZYw0jopQJV8znXydhXwLruI7E2ia2bZc2gEbkwdtS49+4cAMu5c6iKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OH+mSSMy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OH+mSSMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E781F00898;
	Wed, 20 May 2026 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297585;
	bh=MukBoIqBiwLkRIwr+vl4Pu9ZOqlBYpDH/XF2I13QZX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OH+mSSMydZT6ok3Q6lBLzpxRDdbakkzKedXuMKDgYMHV2NbkTr+Lzv8Ix0hg3ZgpK
	 ftnFJf12wx3PM/Lp5iGO1u/QZCCTt3JQtQd2c+QlFAaKt70wUOIiDPrMdRJfbve1em
	 2AK7OX3a/UhfDRAJAgqNcbc9mcRBJjjR65GmfFnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/957] sched/topology: Compute sd_weight considering cpuset partitions
Date: Wed, 20 May 2026 18:08:48 +0200
Message-ID: <20260520162135.536833932@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 8e8e23dea43e64ddafbd1246644c3219209be113 ]

The "sd_weight" used for calculating the load balancing interval, and
its limits, considers the span weight of the entire topology level
without accounting for cpuset partitions.

For example, consider a large system of 128CPUs divided into 8 * 16CPUs
partition which is typical when deploying virtual machines:

  [                      PKG Domain: 128CPUs                      ]

  [Partition0: 16CPUs][Partition1: 16CPUs] ... [Partition7: 16CPUs]

Although each partition only contains 16CPUs, the load balancing
interval is set to a minimum of 128 jiffies considering the span of the
entire domain with 128CPUs which can lead to longer imbalances within
the partition although balancing within is cheaper with 16CPUs.

Compute the "sd_weight" after computing the "sd_span" considering the
cpu_map covered by the partition, and set the load balancing interval,
and its limits accordingly.

For the above example, the balancing intervals for the partitions PKG
domain changes as follows:

                  before   after
balance_interval   128      16
min_interval       128      16
max_interval       256      32

Intervals are now proportional to the CPUs in the partitioned domain as
was intended by the original formula.

Fixes: cb83b629bae03 ("sched/numa: Rewrite the CONFIG_NUMA sched domain support")
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://patch.msgid.link/20260312044434.1974-2-kprateek.nayak@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index c7a4d2fff5718..35478aa2536fc 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1631,13 +1631,17 @@ sd_init(struct sched_domain_topology_level *tl,
 	int sd_id, sd_weight, sd_flags = 0;
 	struct cpumask *sd_span;
 
-	sd_weight = cpumask_weight(tl->mask(tl, cpu));
+	sd_span = sched_domain_span(sd);
+	cpumask_and(sd_span, cpu_map, tl->mask(tl, cpu));
+	sd_weight = cpumask_weight(sd_span);
+	sd_id = cpumask_first(sd_span);
 
 	if (tl->sd_flags)
 		sd_flags = (*tl->sd_flags)();
 	if (WARN_ONCE(sd_flags & ~TOPOLOGY_SD_FLAGS,
-			"wrong sd_flags in topology description\n"))
+		      "wrong sd_flags in topology description\n"))
 		sd_flags &= TOPOLOGY_SD_FLAGS;
+	sd_flags |= asym_cpu_capacity_classify(sd_span, cpu_map);
 
 	*sd = (struct sched_domain){
 		.min_interval		= sd_weight,
@@ -1674,12 +1678,6 @@ sd_init(struct sched_domain_topology_level *tl,
 		.name			= tl->name,
 	};
 
-	sd_span = sched_domain_span(sd);
-	cpumask_and(sd_span, cpu_map, tl->mask(tl, cpu));
-	sd_id = cpumask_first(sd_span);
-
-	sd->flags |= asym_cpu_capacity_classify(sd_span, cpu_map);
-
 	WARN_ONCE((sd->flags & (SD_SHARE_CPUCAPACITY | SD_ASYM_CPUCAPACITY)) ==
 		  (SD_SHARE_CPUCAPACITY | SD_ASYM_CPUCAPACITY),
 		  "CPU capacity asymmetry not supported on SMT\n");
-- 
2.53.0



