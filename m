Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8139E12D1F1;
	Tue, 30 Apr 2024 11:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475698; cv=none; b=ZMfw3S0TKHiVnnE9JLPqZUyPFetXgKm0vwdXC9MaChCGy/7Kr30Hc8/7Ndv8tahCadLNhXWdHMaVgp6eIpxqZDxRv7FkBck1UwdF1F9wjtm2oQKbgeVb2JDRNZlcsCypkcEJ6hxokGthE9kbsgw/aqg5I10D0nxO13MFJCgreoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475698; c=relaxed/simple;
	bh=hBkv6cwPcHVq1zkXCloFPVLtOYt0/Z/HgVUX4lWuv/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+OoNR4x91PKyKg9XhaQK+i8a20Umhp9gjnN0rjEsgdOOBDE3Pk6Y+8P1q2gnKj/nEStjn9Yd/MueUEX8TCJjT5qFtZiP9Sl46ihMmSUzNrZMgyRblqUoCWUJTtDkeKwPxPtqo0uZy0Dk81XYk+NA+P9EMpPJl+s4UCah94ku+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4Vf5mFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4Vf5mFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5824C2BBFC;
	Tue, 30 Apr 2024 11:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475698;
	bh=hBkv6cwPcHVq1zkXCloFPVLtOYt0/Z/HgVUX4lWuv/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4Vf5mFOIr5+y2njvctotaUP4icZkiRBiWH4N9v+d4YUejfTqa8Z2wylTKbXDWm0N
	 QpPmJ6/v94rqTZiosUz6KPbI13l0zGvWrxyR/9eGJjK8G2r6SMR3A4JfxgZYXhs46Y
	 qAznobgFk8tnKIWmyOtiozo7N5n8nrienTUkXsec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/186] sched/eevdf: Fix miscalculation in reweight_entity() when se is not curr
Date: Tue, 30 Apr 2024 12:40:29 +0200
Message-ID: <20240430103103.169105667@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit afae8002b4fd3560c8f5f1567f3c3202c30a70fa ]

reweight_eevdf() only keeps V unchanged inside itself. When se !=
cfs_rq->curr, it would be dequeued from rb tree first. So that V is
changed and the result is wrong. Pass the original V to reweight_eevdf()
to fix this issue.

Fixes: eab03c23c2a1 ("sched/eevdf: Fix vruntime adjustment on reweight")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
[peterz: flip if() condition for clarity]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Abel Wu <wuyun.abel@bytedance.com>
Link: https://lkml.kernel.org/r/20240306022133.81008-3-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 71e7cf6f77f65..a5466eb6a1f15 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3626,11 +3626,10 @@ static inline void
 dequeue_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) { }
 #endif
 
-static void reweight_eevdf(struct cfs_rq *cfs_rq, struct sched_entity *se,
+static void reweight_eevdf(struct sched_entity *se, u64 avruntime,
 			   unsigned long weight)
 {
 	unsigned long old_weight = se->load.weight;
-	u64 avruntime = avg_vruntime(cfs_rq);
 	s64 vlag, vslice;
 
 	/*
@@ -3737,24 +3736,26 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
 	bool curr = cfs_rq->curr == se;
+	u64 avruntime;
 
 	if (se->on_rq) {
 		/* commit outstanding execution time */
 		update_curr(cfs_rq);
+		avruntime = avg_vruntime(cfs_rq);
 		if (!curr)
 			__dequeue_entity(cfs_rq, se);
 		update_load_sub(&cfs_rq->load, se->load.weight);
 	}
 	dequeue_load_avg(cfs_rq, se);
 
-	if (!se->on_rq) {
+	if (se->on_rq) {
+		reweight_eevdf(se, avruntime, weight);
+	} else {
 		/*
 		 * Because we keep se->vlag = V - v_i, while: lag_i = w_i*(V - v_i),
 		 * we need to scale se->vlag when w_i changes.
 		 */
 		se->vlag = div_s64(se->vlag * se->load.weight, weight);
-	} else {
-		reweight_eevdf(cfs_rq, se, weight);
 	}
 
 	update_load_set(&se->load, weight);
-- 
2.43.0



