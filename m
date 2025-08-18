Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C0F335BB3;
	Mon, 18 Aug 2025 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523669; cv=none; b=dvBfayyEXfJOILwANw25kQIPwHVImaYJvJJslZEXQkxmSYapt9hhqzdmgvL0jz9Lhxw/Ugr/fzBtFTM15Bq6zgtmUxlwa7voaRQNgA+WAyOFIi8k8QRc94sIKTldjvCBVoOXDzJ0W58aEpjcA5Ofwd18JeqWFr99lHXvyLd2gYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523669; c=relaxed/simple;
	bh=4B1lTsiTmLxBrYvxs69u1QDStprWNUAPUPmMM0I5daA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qq4HTQEeEAG8DUqJjVCAxTdo+sjhJmL9oAl9u0PfO/zvyA9A3Qk1+D7g1he02JVgg/+WxM1BMwi+SJ3sVeihAIJF2+FRjTkgV7SV5ZXfQZhlcjfFVKw4mvUvrziVM6gvxosva0IOvZ63rHp9D292c8/4lfP2myb8tPQMr+Kh9vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KF3dIEt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KF3dIEt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0834C4CEEB;
	Mon, 18 Aug 2025 13:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523669;
	bh=4B1lTsiTmLxBrYvxs69u1QDStprWNUAPUPmMM0I5daA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KF3dIEt0k5xaX/5IoFhCrHAvHWiFpa2gA8BK5X9CPI6+p3xEV/LF87ot6xX5ZKx6y
	 41Nu+RYm6jyQNZn+gfE+BjNQzcpkmFigcwOrRcvFHk9UWC9TlEIA+Fy4yGAUs6M8hn
	 EK07qmHPJwWIIXaTxSqnsZivY2fiZd7naXw5m6E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 242/515] sched/fair: Bump sd->max_newidle_lb_cost when newidle balance fails
Date: Mon, 18 Aug 2025 14:43:48 +0200
Message-ID: <20250818124507.702364864@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 138d9f4658d5..23264fe111e5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12170,8 +12170,14 @@ static inline bool update_newidle_cost(struct sched_domain *sd, u64 cost)
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
@@ -12863,10 +12869,17 @@ static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
 
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



