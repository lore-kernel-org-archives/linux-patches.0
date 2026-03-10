Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A25382391;
	Tue, 10 Mar 2026 11:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140792; cv=none; b=Qe0Y+dtPnxepqmMk0DJARummiJsFBb93g5lJ0zGuYpHjH6FRoiBELbENH1rQGnRCpA6s2qm7odUj275QF/gbux+ez9cpHuSpOJLpTHKRg/XPK9UUnLfO5STuQR/6YuNqpLdc62rwRWkgm4eBaGHM2yNxib8Um6pbDg8ak623vM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140792; c=relaxed/simple;
	bh=LfhtLSkoQIXUMb0faskn0qzBv6pkLsH+d48xyDJI2cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBKppyutyjkJm6keqvr9wpt4F668y50bwAftCpi5WIecL/ZAgICiNOsM4KyL7m6SNwRM73ZWqAYoO4wc0M1w6vfHvge9Lq47YXT/Qo2uf8y2G2nbZlRImeiIVOdcrz4xBgFe3YJ+bKYfzVgxmkII7L2p0LnCk2KM4rWeiLnUT2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBb888os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBb888os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8D4C2BCAF;
	Tue, 10 Mar 2026 11:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140792;
	bh=LfhtLSkoQIXUMb0faskn0qzBv6pkLsH+d48xyDJI2cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBb888os6AWHLve2J6tynYCRUgK8DkIclzqx9JtYeWpeEo7piD6N1hwBEuKgN+suv
	 4vsab9AXX+iBWX0r1VB2Wj71HGavQR1pDBLrzzixDvIcYBhuXcVK+O5w1R+QC89uqB
	 xKQMNLzQYTKtJO3RgmslzIl8A2ecjJPIHdi3L+enh3Sn0O69hFqxSVfkT4QevFoam2
	 MDweRYd3lZjzE2IppeoLu73roE9vz5MLfqq05Lbw3ZKE2YWYfc+u344zJLSnzkqVG7
	 B87LKTUjlqGcR0itvP9ZNR/4na5Hvh/iaYnnqvzRND3ZBXRDd34g0Z2+Nfa18cgOM0
	 halAMzkvcGUMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wang Tao <wangtao554@huawei.com>,
	Zhang Qiao <zhangqiao22@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shubhang Kaushik <shubhang@os.amperecomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 028/311] sched/eevdf: Update se->vprot in reweight_entity()
Date: Tue, 10 Mar 2026 07:01:15 -0400
Message-ID: <4fd89e66b5f25c191e24f59764c7d7f15420e1e5.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Wang Tao <wangtao554@huawei.com>

[ Upstream commit ff38424030f98976150e42ca35f4b00e6ab8fa23 ]

In the EEVDF framework with Run-to-Parity protection, `se->vprot` is an
independent variable defining the virtual protection timestamp.

When `reweight_entity()` is called (e.g., via nice/renice), it performs
the following actions to preserve Lag consistency:
 1. Scales `se->vlag` based on the new weight.
 2. Calls `place_entity()`, which recalculates `se->vruntime` based on
    the new weight and scaled lag.

However, the current implementation fails to update `se->vprot`, leading
to mismatches between the task's actual runtime and its expected duration.

Fixes: 63304558ba5d ("sched/eevdf: Curb wakeup-preemption")
Suggested-by: Zhang Qiao <zhangqiao22@huawei.com>
Signed-off-by: Wang Tao <wangtao554@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Link: https://patch.msgid.link/20260120123113.3518950-1-wangtao554@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6f66d4f0540ea..c8a6dac54e220 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3816,6 +3816,8 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
 	bool curr = cfs_rq->curr == se;
+	bool rel_vprot = false;
+	u64 vprot;
 
 	if (se->on_rq) {
 		/* commit outstanding execution time */
@@ -3823,6 +3825,11 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		update_entity_lag(cfs_rq, se);
 		se->deadline -= se->vruntime;
 		se->rel_deadline = 1;
+		if (curr && protect_slice(se)) {
+			vprot = se->vprot - se->vruntime;
+			rel_vprot = true;
+		}
+
 		cfs_rq->nr_queued--;
 		if (!curr)
 			__dequeue_entity(cfs_rq, se);
@@ -3838,6 +3845,9 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 	if (se->rel_deadline)
 		se->deadline = div_s64(se->deadline * se->load.weight, weight);
 
+	if (rel_vprot)
+		vprot = div_s64(vprot * se->load.weight, weight);
+
 	update_load_set(&se->load, weight);
 
 	do {
@@ -3849,6 +3859,8 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 	enqueue_load_avg(cfs_rq, se);
 	if (se->on_rq) {
 		place_entity(cfs_rq, se, 0);
+		if (rel_vprot)
+			se->vprot = se->vruntime + vprot;
 		update_load_add(&cfs_rq->load, se->load.weight);
 		if (!curr)
 			__enqueue_entity(cfs_rq, se);
-- 
2.51.0

