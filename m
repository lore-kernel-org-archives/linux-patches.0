Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8952F387583;
	Tue, 10 Mar 2026 11:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141657; cv=none; b=TkgOltLan8I4Jjm/p72+rYvnZAPFWNWp9/jDwouh4eH8Dv1vBTxPUZlhSojZE61h8VF+jesFTRdgg/P4TiIbZ17yskjZtBdmkCaU2HXvIzkQkNSSFnu7AVPBi5grJU8JFrAzOLXCdvWHclKu1xuAxuXK9k2KacT9q+ppf3/qg9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141657; c=relaxed/simple;
	bh=0QD55OI1flOZ9fILNOdIUG7CAOe93hFyScjtpO1kgg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRpaeGsBTQwjh7SheUqizRcy4zhHfrpcXncFO4rnsyG9Zh4VfPJyjw/tHVwW0d+BtFBaXSBgsiNqg2hWrQm/dR5Q8Tn0FMWyElVCwE6u5N7om/05l2ex6jDNSN2zFy52G/X5CFE2hSsr9sIzj08WIUyxqPqPBXrKxohw/NZw9IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJZ/l2UZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJZ/l2UZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781D8C2BCB0;
	Tue, 10 Mar 2026 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141657;
	bh=0QD55OI1flOZ9fILNOdIUG7CAOe93hFyScjtpO1kgg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJZ/l2UZMi3OYwEdHj93SlXRF/Heo2FP4S+TCDnlTYv6ky7UPL9q+O4sexAoo0plV
	 5EQYWQmOcbTFZsLtMU5zkU7E6RNnI5DXnjFwHaWuhVmyyKoopVh70D2gw6cSjMvHKl
	 7XVaWpampQ0FKtfIIbxPcH7T9CA/2PUKVP5Nq5tq4jDiZycGWEIIy35EoCeKsCD0tv
	 7HUXHcuwtP1VzJUb7fFXWAOf9Z10wLqFtdjOJwb8QsTl8cpsefuJxOjUEix4BCTbGK
	 tCj0lrLKbWrpz5VoeTIJtI1+kzoV667znNHwwKigHk3HYf1EYP96jL/TfE++AZDG/I
	 C+NvBbk5sXWfg==
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
Subject: [PATCH 6.18 024/314] sched/eevdf: Update se->vprot in reweight_entity()
Date: Tue, 10 Mar 2026 07:14:43 -0400
Message-ID: <2a8045e80d3425ba67de28ebb8f9dd49b28a9779.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 1644ad90acdca..8587218ee9073 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3805,6 +3805,8 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
 	bool curr = cfs_rq->curr == se;
+	bool rel_vprot = false;
+	u64 vprot;
 
 	if (se->on_rq) {
 		/* commit outstanding execution time */
@@ -3812,6 +3814,11 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
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
@@ -3827,6 +3834,9 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 	if (se->rel_deadline)
 		se->deadline = div_s64(se->deadline * se->load.weight, weight);
 
+	if (rel_vprot)
+		vprot = div_s64(vprot * se->load.weight, weight);
+
 	update_load_set(&se->load, weight);
 
 	do {
@@ -3838,6 +3848,8 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
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

