Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA2B2FC870;
	Tue, 26 Aug 2025 13:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214421; cv=none; b=jV0+wsHDxmQ10YCaUYotnNeq7thia5seJkwSBVGTlYL8gSB4lH0wLdtBHyD3hzcshjeVxGPtmQFY1V5ow6bDNL4gd4uHLa9zrgqloHhvKfNIODDUV/A74s6ttEJW0OeEkw6F48E+y8S35/hwKCnSSDjK4zAheq0Exl+Cl/ojO+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214421; c=relaxed/simple;
	bh=htOjEuGLbMaDw4T2lm6MK5sj9ZCQTwtG27PU92v6bYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa0CI6V368dLIxC9vPDFRk9Z/W3wrD7r9rldlmx7qyMW5RnscuUGceZXVDjShxpDPrkNhpaAAI/9SgHjAss64xLheW8/CkkxwSvWpD6iryd1nTpGDwRpq1VKXJTciMq/hthnkVZWFTQs2m+jKYHYUrdCK6ndUd6P8z3ujuzcXVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svQSWqJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svQSWqJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E51C113D0;
	Tue, 26 Aug 2025 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214421;
	bh=htOjEuGLbMaDw4T2lm6MK5sj9ZCQTwtG27PU92v6bYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svQSWqJZckBDgP5ARoqOQmKEn6QTRf+b7E2OlCpM3Xqwqqkpm1Prr4Mbt3695SYNd
	 KCDj85GCeV8ZBVRHvr/v7/0y7/LUsKKqoq/ZBrCG92T6/laP4fbgsobSW+oFhTeUb2
	 7/LJeZYtHMWJbRbEtVJyr+6iiSVYHJQ8dou1QVA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/482] sched/fair: Bump sd->max_newidle_lb_cost when newidle balance fails
Date: Tue, 26 Aug 2025 13:06:25 +0200
Message-ID: <20250826110934.079809499@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Chris Mason <clm@fb.com>

[ Upstream commit 155213a2aed42c85361bf4f5c817f5cb68951c3b ]

schbench (https://github.com/masoncl/schbench.git) is showing a
regression from previous production kernels that bisected down to:

sched/fair: Remove sysctl_sched_migration_cost condition (c5b0a7eefc)

The schbench command line was:

schbench -L -m 4 -M auto -t 256 -n 0 -r 0 -s 0

This creates 4 message threads pinned to CPUs 0-3, and 256x4 worker
threads spread across the rest of the CPUs.  Neither the worker threads
or the message threads do any work, they just wake each other up and go
back to sleep as soon as possible.

The end result is the first 4 CPUs are pegged waking up those 1024
workers, and the rest of the CPUs are constantly banging in and out of
idle.  If I take a v6.9 Linus kernel and revert that one commit,
performance goes from 3.4M RPS to 5.4M RPS.

schedstat shows there are ~100x  more new idle balance operations, and
profiling shows the worker threads are spending ~20% of their CPU time
on new idle balance.  schedstats also shows that almost all of these new
idle balance attemps are failing to find busy groups.

The fix used here is to crank up the cost of the newidle balance whenever it
fails.  Since we don't want sd->max_newidle_lb_cost to grow out of
control, this also changes update_newidle_cost() to use
sysctl_sched_migration_cost as the upper limit on max_newidle_lb_cost.

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20250626144017.1510594-2-clm@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d30e0936cfec..2deb896883d3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10941,8 +10941,14 @@ static inline bool update_newidle_cost(struct sched_domain *sd, u64 cost)
 		/*
 		 * Track max cost of a domain to make sure to not delay the
 		 * next wakeup on the CPU.
+		 *
+		 * sched_balance_newidle() bumps the cost whenever newidle
+		 * balance fails, and we don't want things to grow out of
+		 * control.  Use the sysctl_sched_migration_cost as the upper
+		 * limit, plus a litle extra to avoid off by ones.
 		 */
-		sd->max_newidle_lb_cost = cost;
+		sd->max_newidle_lb_cost =
+			min(cost, sysctl_sched_migration_cost + 200);
 		sd->last_decay_max_lb_cost = jiffies;
 	} else if (time_after(jiffies, sd->last_decay_max_lb_cost + HZ)) {
 		/*
@@ -11624,10 +11630,17 @@ static int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
 
 			t1 = sched_clock_cpu(this_cpu);
 			domain_cost = t1 - t0;
-			update_newidle_cost(sd, domain_cost);
-
 			curr_cost += domain_cost;
 			t0 = t1;
+
+			/*
+			 * Failing newidle means it is not effective;
+			 * bump the cost so we end up doing less of it.
+			 */
+			if (!pulled_task)
+				domain_cost = (3 * sd->max_newidle_lb_cost) / 2;
+
+			update_newidle_cost(sd, domain_cost);
 		}
 
 		/*
-- 
2.39.5



