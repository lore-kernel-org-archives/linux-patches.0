Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132F91FFC69;
	Thu, 13 Feb 2025 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458562; cv=none; b=ZiKNLnXMsqsCT+UeDOQQWHiaoC0p1/2tEBNHH/rNRaME7zK8DM1WFVdzopEJY0AMV5k+aK1ekOzEgCeVa1inEtrReGzMp8QstJT0pHrLmC3aNqCV9iPE9SDJo4Hx5hfa3yiGpq4xtD4yW0+L/CV1OFSfNnE8JFsaaof7CfWy1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458562; c=relaxed/simple;
	bh=PGRfBd7iFfTMDeKuXUs4FkeJfo8L++rGANFsaefOhrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9/Ep+ywjGgAf6RdoBnJThrciu7mO/1v6NhwqA8uvCjyqnReFphYS/FODeDBVjOul8bwrLC89AW4afWNFmOVcKHZ3MHD/+r+tkiStpiL4Flh2hHv1rqH1WR6h1qDasbqsLLk2ckFRQvVAoxqV6AdGs926O+kkgcToe0Y1tIijJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQfPIVto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQfPIVto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9B9C4CED1;
	Thu, 13 Feb 2025 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458561;
	bh=PGRfBd7iFfTMDeKuXUs4FkeJfo8L++rGANFsaefOhrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQfPIVtocsCyd0UtZ9mJe/Xd9wYYPjDJwB5zCFiuakx13UCIFBXBnw+quoCllZQEv
	 F60c3RzxAcZfMxWzOtyn7TXP0Gzvc7hZY2UQm2pYPqn0fQ8U6kKezNW2xyPk9pnTUG
	 MDwYUEFXgthwG27dw1rQW6qYUBeT8/4+nKLo8+iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 014/443] sched/deadline: Check bandwidth overflow earlier for hotplug
Date: Thu, 13 Feb 2025 15:22:59 +0100
Message-ID: <20250213142441.173316206@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 53916d5fd3c0b658de3463439dd2b7ce765072cb ]

Currently we check for bandwidth overflow potentially due to hotplug
operations at the end of sched_cpu_deactivate(), after the cpu going
offline has already been removed from scheduling, active_mask, etc.
This can create issues for DEADLINE tasks, as there is a substantial
race window between the start of sched_cpu_deactivate() and the moment
we possibly decide to roll-back the operation if dl_bw_deactivate()
returns failure in cpuset_cpu_inactive(). An example is a throttled
task that sees its replenishment timer firing while the cpu it was
previously running on is considered offline, but before
dl_bw_deactivate() had a chance to say no and roll-back happened.

Fix this by directly calling dl_bw_deactivate() first thing in
sched_cpu_deactivate() and do the required calculation in the former
function considering the cpu passed as an argument as offline already.

By doing so we also simplify sched_cpu_deactivate(), as there is no need
anymore for any kind of roll-back if we fail early.

Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Tested-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/Zzc1DfPhbvqDDIJR@jlelli-thinkpadt14gen4.remote.csb
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c     | 22 +++++++---------------
 kernel/sched/deadline.c | 12 ++++++++++--
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 141bbe97d7e5f..a4fc6d357e08a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8182,19 +8182,14 @@ static void cpuset_cpu_active(void)
 	cpuset_update_active_cpus();
 }
 
-static int cpuset_cpu_inactive(unsigned int cpu)
+static void cpuset_cpu_inactive(unsigned int cpu)
 {
 	if (!cpuhp_tasks_frozen) {
-		int ret = dl_bw_deactivate(cpu);
-
-		if (ret)
-			return ret;
 		cpuset_update_active_cpus();
 	} else {
 		num_cpus_frozen++;
 		partition_sched_domains(1, NULL, NULL);
 	}
-	return 0;
 }
 
 static inline void sched_smt_present_inc(int cpu)
@@ -8256,6 +8251,11 @@ int sched_cpu_deactivate(unsigned int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	int ret;
 
+	ret = dl_bw_deactivate(cpu);
+
+	if (ret)
+		return ret;
+
 	/*
 	 * Remove CPU from nohz.idle_cpus_mask to prevent participating in
 	 * load balancing when not active
@@ -8301,15 +8301,7 @@ int sched_cpu_deactivate(unsigned int cpu)
 		return 0;
 
 	sched_update_numa(cpu, false);
-	ret = cpuset_cpu_inactive(cpu);
-	if (ret) {
-		sched_smt_present_inc(cpu);
-		sched_set_rq_online(rq, cpu);
-		balance_push_set(cpu, false);
-		set_cpu_active(cpu, true);
-		sched_update_numa(cpu, true);
-		return ret;
-	}
+	cpuset_cpu_inactive(cpu);
 	sched_domains_numa_masks_clear(cpu);
 	return 0;
 }
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b078014273d9e..b6781ddea7650 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3488,6 +3488,13 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 		}
 		break;
 	case dl_bw_req_deactivate:
+		/*
+		 * cpu is not off yet, but we need to do the math by
+		 * considering it off already (i.e., what would happen if we
+		 * turn cpu off?).
+		 */
+		cap -= arch_scale_cpu_capacity(cpu);
+
 		/*
 		 * cpu is going offline and NORMAL tasks will be moved away
 		 * from it. We can thus discount dl_server bandwidth
@@ -3505,9 +3512,10 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 		if (dl_b->total_bw - fair_server_bw > 0) {
 			/*
 			 * Leaving at least one CPU for DEADLINE tasks seems a
-			 * wise thing to do.
+			 * wise thing to do. As said above, cpu is not offline
+			 * yet, so account for that.
 			 */
-			if (dl_bw_cpus(cpu))
+			if (dl_bw_cpus(cpu) - 1)
 				overflow = __dl_overflow(dl_b, cap, fair_server_bw, 0);
 			else
 				overflow = 1;
-- 
2.39.5



