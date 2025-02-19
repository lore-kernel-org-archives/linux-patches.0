Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7CA1DE2BE;
	Wed, 19 Feb 2025 08:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955385; cv=none; b=m/vTcS+OaSpnCZ2mP6L+acKJBeYx9LpwWW8fJbUwKiUJBDVo2IufBDBIRCBiHrtDYC+C1LzkxORdrUxN5+67R0NDclJegwCcrhfxf5c98pBXCjLjPGJWzum6YkRjXXxZN8hZwWoeSUp1lo5ij/3JaixjWHLFWSgoj/rpfBNO5PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955385; c=relaxed/simple;
	bh=z4canbL1ccqsuvByLkRhTKXn0wz7D9F/HLO7C0DutrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8UXgXAKQb5VJ/SciGxS+3o5VBNvibByMvZFtqgvPR2pZOu5MyBprEAIFCnkn21LCAlws2MJVkMT23Epuofek0/5Bd5x84+KmNMmf7T6TfVHTaLufrm2T71fedm6rdao9hMv0SDtEiswXWrn0IL/IB157D0664E2awJn5vzb/ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFx2oMBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFx2oMBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B667C4CED1;
	Wed, 19 Feb 2025 08:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955384;
	bh=z4canbL1ccqsuvByLkRhTKXn0wz7D9F/HLO7C0DutrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFx2oMBljmNpKeF9wUI7C8yLqO3oDrMfstr7Q5Zd9zdHOS17FVwabqdk4354DKX7I
	 Gk7aHrDRmKUs0+yBQRyF8Hdhw7SBzrnYtMJGh1c6oxMZcXxdVri9zhOJglx1EClxaq
	 iaw6zB5HqCJkLYAk1vn8ivuytv11tRMfRGOg5Pkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.12 219/230] sched/deadline: Check bandwidth overflow earlier for hotplug
Date: Wed, 19 Feb 2025 09:28:56 +0100
Message-ID: <20250219082610.258219409@linuxfoundation.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

commit 53916d5fd3c0b658de3463439dd2b7ce765072cb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c     |   22 +++++++---------------
 kernel/sched/deadline.c |   12 ++++++++++--
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8091,19 +8091,14 @@ static void cpuset_cpu_active(void)
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
@@ -8165,6 +8160,11 @@ int sched_cpu_deactivate(unsigned int cp
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
@@ -8210,15 +8210,7 @@ int sched_cpu_deactivate(unsigned int cp
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
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3511,6 +3511,13 @@ static int dl_bw_manage(enum dl_bw_reque
 		break;
 	case dl_bw_req_deactivate:
 		/*
+		 * cpu is not off yet, but we need to do the math by
+		 * considering it off already (i.e., what would happen if we
+		 * turn cpu off?).
+		 */
+		cap -= arch_scale_cpu_capacity(cpu);
+
+		/*
 		 * cpu is going offline and NORMAL tasks will be moved away
 		 * from it. We can thus discount dl_server bandwidth
 		 * contribution as it won't need to be servicing tasks after
@@ -3527,9 +3534,10 @@ static int dl_bw_manage(enum dl_bw_reque
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


