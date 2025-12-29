Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6527C22CBD9;
	Mon, 29 Dec 2025 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024871; cv=none; b=WcRLfW1Oumz7yQ1JvCw81qDEVsMvmkKmnGTE4PdZDttzMKEjtr9bodRo1kCj/SFfnRRSW/Zpkc/OZdiv/pp7IRT/pLyhwtub/sgGR7o7OB5V3bAGGQFEOg9DxD7Pq8Y2DLAdUWRRJ8H2BA25JfkNXoYewF/QFKZYh+UeoZJImCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024871; c=relaxed/simple;
	bh=cYpJyN535H96CV25xKpySJdMQexjYnYrLKAush3R+wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlJRgtiMI4b1Gv1Y1dwdHm2nXkEXGEYdhkJEtsmeEsONvkADbsp9lx9hXh/mefBvsfmg7VQkrAnPtImohBawk3XhcTW+xc5rnV2JWPRQXV2V/jgwNDiyE7M5mEI1EaaxoH6qmTZa+mgDEG0DSBUXlYwvCcuO8EgWH5sQ8Ia0ttc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iplBOuxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iplBOuxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC838C4CEF7;
	Mon, 29 Dec 2025 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024871;
	bh=cYpJyN535H96CV25xKpySJdMQexjYnYrLKAush3R+wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iplBOuxAPaKRsP06teZBSNdeHtohpU0Xf3IDp3t+fSLaRyfpCJbXGxP5GrOvuhh+n
	 j+udMO8NLGwxvxrhuj03kIRcqHpXxEQE2CJdD0vU4riuJw1KJgN5K+eg4jjF5FsE2/
	 BfIymST2l/IFRnlWLjIoySiO+oH85E0/pTe1jsDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Adam Li <adamli@os.amperecomputing.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Chris Mason <clm@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/430] sched/fair: Revert max_newidle_lb_cost bump
Date: Mon, 29 Dec 2025 17:06:56 +0100
Message-ID: <20251229160724.677753941@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d206fbad9328ddb68ebabd7cf7413392acd38081 ]

Many people reported regressions on their database workloads due to:

  155213a2aed4 ("sched/fair: Bump sd->max_newidle_lb_cost when newidle balance fails")

For instance Adam Li reported a 6% regression on SpecJBB.

Conversely this will regress schbench again; on my machine from 2.22
Mrps/s down to 2.04 Mrps/s.

Reported-by: Joseph Salisbury <joseph.salisbury@oracle.com>
Reported-by: Adam Li <adamli@os.amperecomputing.com>
Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://lkml.kernel.org/r/20250626144017.1510594-2-clm@fb.com
Link: https://lkml.kernel.org/r/006c9df2-b691-47f1-82e6-e233c3f91faf@oracle.com
Link: https://patch.msgid.link/20251107161739.406147760@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 71d3f4125b0e7..967ca52fb2311 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12174,14 +12174,8 @@ static inline bool update_newidle_cost(struct sched_domain *sd, u64 cost)
 		/*
 		 * Track max cost of a domain to make sure to not delay the
 		 * next wakeup on the CPU.
-		 *
-		 * sched_balance_newidle() bumps the cost whenever newidle
-		 * balance fails, and we don't want things to grow out of
-		 * control.  Use the sysctl_sched_migration_cost as the upper
-		 * limit, plus a litle extra to avoid off by ones.
 		 */
-		sd->max_newidle_lb_cost =
-			min(cost, sysctl_sched_migration_cost + 200);
+		sd->max_newidle_lb_cost = cost;
 		sd->last_decay_max_lb_cost = jiffies;
 	} else if (time_after(jiffies, sd->last_decay_max_lb_cost + HZ)) {
 		/*
@@ -12873,17 +12867,10 @@ static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
 
 			t1 = sched_clock_cpu(this_cpu);
 			domain_cost = t1 - t0;
+			update_newidle_cost(sd, domain_cost);
+
 			curr_cost += domain_cost;
 			t0 = t1;
-
-			/*
-			 * Failing newidle means it is not effective;
-			 * bump the cost so we end up doing less of it.
-			 */
-			if (!pulled_task)
-				domain_cost = (3 * sd->max_newidle_lb_cost) / 2;
-
-			update_newidle_cost(sd, domain_cost);
 		}
 
 		/*
-- 
2.51.0



