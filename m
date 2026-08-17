Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE982475F7;
	Mon, 17 Aug 2026 13:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974716; cv=none; b=Kc0Df0BdGSxPRDyVyvkrTOfkqQeu4E6KD/X12Cu/LdPcVxGRKoRBY9J2arayTVRjsZCBophquNQN2SHQ0VAnrqt59davFlBTWxyyzOPtau3yQ5ezhJY6reK8ncNhc6hV+UH+0REYLgPZ5cQcsqbGAa28IQfbiTG2BKfo6pkr0iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974716; c=relaxed/simple;
	bh=chTHALZWmsUr07dJLUOxM5p6DCugi1Bdv7o9Dce0tV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3xPUNT87nwnHeUUumcZaMsTDZyc8IQUxfnSAIoPDhKDaa6CvxHZfn7k7Iy+Ktb9Wn5wA3aF/jTXBnvIsTT+37/IQFcpL0hAWmAz5QeHiLJx2XB74IodxNBoEjJ+MOCN1BHGnt7V2J9Vv0kXasQ7BbZa84ngqNS8HwybKoi4gHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aptp+J0R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aptp+J0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD001F00A3D;
	Mon, 17 Aug 2026 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974709;
	bh=6vG6/jZ8ik+PwVos2CABwc2t0ovPbav+S10Kdmp53MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aptp+J0RJi+x48DvG1ptnqU5SUVeRJTAKRucYsp+FaNQaQty92zC/Nj2KsPirEyhZ
	 2pJUG4vEwX+Inpem5FTjlEzVtNTpRnf6Vk/vctwds0uXydUKe/8TULUkwzR52OaBeY
	 ueZxo8wMQbHqkPdK8kwqymPtB+mHWhmObnhQSqT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shubhang Kaushik <shubhang@os.amperecomputing.com>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/250] sched/fair: Revert 6d71a9c61604 ("sched/fair: Fix EEVDF entity placement bug causing scheduling lag")
Date: Mon, 17 Aug 2026 15:29:25 +0200
Message-ID: <20260817132536.646100983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

[ Upstream commit 101f3498b4bdfef97152a444847948de1543f692 ]

Zicheng Qu reported that, because avg_vruntime() always includes
cfs_rq->curr, when ->on_rq, place_entity() doesn't work right.

Specifically, the lag scaling in place_entity() relies on
avg_vruntime() being the state *before* placement of the new entity.
However in this case avg_vruntime() will actually already include the
entity, which breaks things.

Also, Zicheng Qu argues that avg_vruntime should be invariant under
reweight. IOW commit 6d71a9c61604 ("sched/fair: Fix EEVDF entity
placement bug causing scheduling lag") was wrong!

The issue reported in 6d71a9c61604 could possibly be explained by
rounding artifacts -- notably the extreme weight '2' is outside of the
range of avg_vruntime/sum_w_vruntime, since that uses
scale_load_down(). By scaling vruntime by the real weight, but
accounting it in vruntime with a factor 1024 more, the average moves
significantly. However, that is now cured.

Tested by reverting 66951e4860d3 ("sched/fair: Fix update_cfs_group()
vs DELAY_DEQUEUE") and tracing vruntime and vlag figures again.

Reported-by: Zicheng Qu <quzicheng@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Link: https://patch.msgid.link/20260219080625.066102672%40infradead.org
(cherry picked from commit 101f3498b4bdfef97152a444847948de1543f692)
[jstultz: Resolved minor collision in the revert against 6.18-stable]
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 148 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 124 insertions(+), 24 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ac5f08cd01a83..aed035aaece1d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -764,17 +764,22 @@ static inline u64 cfs_rq_max_slice(struct cfs_rq *cfs_rq);
  *
  *   -r_max < lag < max(r_max, q)
  */
-static void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static s64 entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 avruntime)
 {
 	u64 max_slice = cfs_rq_max_slice(cfs_rq) + TICK_NSEC;
 	s64 vlag, limit;
 
-	WARN_ON_ONCE(!se->on_rq);
-
-	vlag = avg_vruntime(cfs_rq) - se->vruntime;
+	vlag = avruntime - se->vruntime;
 	limit = calc_delta_fair(max_slice, se);
 
-	se->vlag = clamp(vlag, -limit, limit);
+	return clamp(vlag, -limit, limit);
+}
+
+static void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	WARN_ON_ONCE(!se->on_rq);
+
+	se->vlag = entity_lag(cfs_rq, se, avg_vruntime(cfs_rq));
 }
 
 /*
@@ -3838,23 +3843,125 @@ dequeue_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se)
 					  cfs_rq->avg.load_avg * PELT_MIN_DIVIDER);
 }
 
-static void place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags);
+static void
+rescale_entity(struct sched_entity *se, unsigned long weight, bool rel_vprot)
+{
+	unsigned long old_weight = se->load.weight;
+
+	/*
+	 * VRUNTIME
+	 * --------
+	 *
+	 * COROLLARY #1: The virtual runtime of the entity needs to be
+	 * adjusted if re-weight at !0-lag point.
+	 *
+	 * Proof: For contradiction assume this is not true, so we can
+	 * re-weight without changing vruntime at !0-lag point.
+	 *
+	 *             Weight	VRuntime   Avg-VRuntime
+	 *     before    w          v            V
+	 *      after    w'         v'           V'
+	 *
+	 * Since lag needs to be preserved through re-weight:
+	 *
+	 *	lag = (V - v)*w = (V'- v')*w', where v = v'
+	 *	==>	V' = (V - v)*w/w' + v		(1)
+	 *
+	 * Let W be the total weight of the entities before reweight,
+	 * since V' is the new weighted average of entities:
+	 *
+	 *	V' = (WV + w'v - wv) / (W + w' - w)	(2)
+	 *
+	 * by using (1) & (2) we obtain:
+	 *
+	 *	(WV + w'v - wv) / (W + w' - w) = (V - v)*w/w' + v
+	 *	==> (WV-Wv+Wv+w'v-wv)/(W+w'-w) = (V - v)*w/w' + v
+	 *	==> (WV - Wv)/(W + w' - w) + v = (V - v)*w/w' + v
+	 *	==>	(V - v)*W/(W + w' - w) = (V - v)*w/w' (3)
+	 *
+	 * Since we are doing at !0-lag point which means V != v, we
+	 * can simplify (3):
+	 *
+	 *	==>	W / (W + w' - w) = w / w'
+	 *	==>	Ww' = Ww + ww' - ww
+	 *	==>	W * (w' - w) = w * (w' - w)
+	 *	==>	W = w	(re-weight indicates w' != w)
+	 *
+	 * So the cfs_rq contains only one entity, hence vruntime of
+	 * the entity @v should always equal to the cfs_rq's weighted
+	 * average vruntime @V, which means we will always re-weight
+	 * at 0-lag point, thus breach assumption. Proof completed.
+	 *
+	 *
+	 * COROLLARY #2: Re-weight does NOT affect weighted average
+	 * vruntime of all the entities.
+	 *
+	 * Proof: According to corollary #1, Eq. (1) should be:
+	 *
+	 *	(V - v)*w = (V' - v')*w'
+	 *	==>    v' = V' - (V - v)*w/w'		(4)
+	 *
+	 * According to the weighted average formula, we have:
+	 *
+	 *	V' = (WV - wv + w'v') / (W - w + w')
+	 *	   = (WV - wv + w'(V' - (V - v)w/w')) / (W - w + w')
+	 *	   = (WV - wv + w'V' - Vw + wv) / (W - w + w')
+	 *	   = (WV + w'V' - Vw) / (W - w + w')
+	 *
+	 *	==>  V'*(W - w + w') = WV + w'V' - Vw
+	 *	==>	V' * (W - w) = (W - w) * V	(5)
+	 *
+	 * If the entity is the only one in the cfs_rq, then reweight
+	 * always occurs at 0-lag point, so V won't change. Or else
+	 * there are other entities, hence W != w, then Eq. (5) turns
+	 * into V' = V. So V won't change in either case, proof done.
+	 *
+	 *
+	 * So according to corollary #1 & #2, the effect of re-weight
+	 * on vruntime should be:
+	 *
+	 *	v' = V' - (V - v) * w / w'		(4)
+	 *	   = V  - (V - v) * w / w'
+	 *	   = V  - vl * w / w'
+	 *	   = V  - vl'
+	 */
+	se->vlag = div64_long(se->vlag * old_weight, weight);
+
+	/*
+	 * DEADLINE
+	 * --------
+	 *
+	 * When the weight changes, the virtual time slope changes and
+	 * we should adjust the relative virtual deadline accordingly.
+	 *
+	 *	d' = v' + (d - v)*w/w'
+	 *	   = V' - (V - v)*w/w' + (d - v)*w/w'
+	 *	   = V  - (V - v)*w/w' + (d - v)*w/w'
+	 *	   = V  + (d - V)*w/w'
+	 */
+	if (se->rel_deadline)
+		se->deadline = div64_long(se->deadline * old_weight, weight);
+
+	if (rel_vprot)
+		se->vprot = div64_long(se->vprot * old_weight, weight);
+}
 
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
 	bool curr = cfs_rq->curr == se;
 	bool rel_vprot = false;
-	u64 vprot;
+	u64 avruntime = 0;
 
 	if (se->on_rq) {
 		/* commit outstanding execution time */
 		update_curr(cfs_rq);
-		update_entity_lag(cfs_rq, se);
-		se->deadline -= se->vruntime;
+		avruntime = avg_vruntime(cfs_rq);
+		se->vlag = entity_lag(cfs_rq, se, avruntime);
+		se->deadline -= avruntime;
 		se->rel_deadline = 1;
 		if (curr && protect_slice(se)) {
-			vprot = se->vprot - se->vruntime;
+			se->vprot -= avruntime;
 			rel_vprot = true;
 		}
 
@@ -3865,30 +3972,23 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 	}
 	dequeue_load_avg(cfs_rq, se);
 
-	/*
-	 * Because we keep se->vlag = V - v_i, while: lag_i = w_i*(V - v_i),
-	 * we need to scale se->vlag when w_i changes.
-	 */
-	se->vlag = div_s64(se->vlag * se->load.weight, weight);
-	if (se->rel_deadline)
-		se->deadline = div_s64(se->deadline * se->load.weight, weight);
-
-	if (rel_vprot)
-		vprot = div_s64(vprot * se->load.weight, weight);
+	rescale_entity(se, weight, rel_vprot);
 
 	update_load_set(&se->load, weight);
 
 	do {
 		u32 divider = get_pelt_divider(&se->avg);
-
 		se->avg.load_avg = div_u64(se_weight(se) * se->avg.load_sum, divider);
 	} while (0);
 
 	enqueue_load_avg(cfs_rq, se);
 	if (se->on_rq) {
-		place_entity(cfs_rq, se, 0);
 		if (rel_vprot)
-			se->vprot = se->vruntime + vprot;
+			se->vprot += avruntime;
+		se->deadline += avruntime;
+		se->rel_deadline = 0;
+		se->vruntime = avruntime - se->vlag;
+
 		update_load_add(&cfs_rq->load, se->load.weight);
 		if (!curr)
 			__enqueue_entity(cfs_rq, se);
@@ -5288,7 +5388,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	se->vruntime = vruntime - lag;
 
-	if (se->rel_deadline) {
+	if (sched_feat(PLACE_REL_DEADLINE) && se->rel_deadline) {
 		se->deadline += se->vruntime;
 		se->rel_deadline = 0;
 		return;
-- 
2.53.0



