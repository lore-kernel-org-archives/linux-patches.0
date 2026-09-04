Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898AA38E8DD;
	Fri,  4 Sep 2026 05:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499534; cv=none; b=dnbGjagfB8PmGAtCWjU9+Qpi4C5ilLb/uO6qG8VtwH4Nx537p++KWaktnnDZEmYCjiYWr58i5lj7s7AAtM3ai5qmVBVId5sCnrUmGwjPKwH7dBvOSBvPe5XqW1FJdp9ERsqRW9qra60maaqfN2ikTxz8LDeY5VVTQ/akfO1EtuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499534; c=relaxed/simple;
	bh=XAHv8hW6IVa/0kFa5PFcd3Ah02LM4sT9INQShFLoMrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMvgc6D+qM2QnbhTsNxDA+DnjDiIGQV7F1hBpzXJKzjTQL0nkU/mFzVCuS+E6YJMZgsxIC0mcUtGmAOWrbF4Qzt4jwH4PAkEeu5AMcRNVSWINo+MWmlJUB0NrL2SCGcF3G/M3R+6EmccdvPNjW6/xvcrqJ1oP6I9pEcIexBKof0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyZTP1pn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyZTP1pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A111F00A3D;
	Fri,  4 Sep 2026 05:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499533;
	bh=J95O6uSuXd+90r3echqbxLy6WyY/HV1rRdrDbki3ERU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UyZTP1pnWbGygWXpRY6eeRKyHcCd7U3O9DQNRZm6dcgmlnq8nEoONpI9Ts7/fbqWo
	 fuTMUijI8oBMbG89VHOy8KelI6h9ljG2BVKpPEUN802VBEwaP++mjkkMaT27lqByPb
	 EsA/l3ye2iuYZXbA+W3VclYgCZNo8MpGdULuW7vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.2 407/713] sched/core: Handle pick_task() releasing the rq lock
Date: Fri,  4 Sep 2026 06:56:15 +0200
Message-ID: <20260904045812.945277783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit c10b216a072ff5c57bc880a05f87eb519aecc529 upstream.

Core scheduling's pick_next_task() breaks when a ->pick_task()
implementation can release the rq lock. The selection state derived on entry
is only valid while the lock is held continuously. Once a pick can drop the
lock, an interleaving selection can invalidate all of it: the single-CPU
fast path can commit an uncookied pick although the core went cookied during
the release, and forceidle committed by the interleaving selection skews the
restarted pass's accounting.

Fix it by restarting the whole selection when a pick returns RETRY_TASK
after releasing the lock: a single restart point above the state derivation
replaces the per-loop restart labels, so a retry picks up state committed by
interleaving selections and accounts and resets forceidle like a fresh
selection would.

need_sync and fi_before latch across retries. Clock validity can't be
re-derived - there is no program-ordered way to tell whether the own and
core rq clocks are still updated after the lock was released, as other
lockers' pin cycles may or may not have invalidated them. When restarting,
clear core_clock_updated so that the sibling loop re-updates the core rq,
and update the own rq clock if invalidated.

Fixes: 4c95380701f5 ("sched/ext: Fold balance_scx() into pick_task_scx()")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6223,7 +6223,7 @@ pick_next_task(struct rq *rq, struct rq_
 	unsigned long cookie;
 	int i, cpu, occ = 0;
 	struct rq *rq_i;
-	bool need_sync;
+	bool need_sync = false;
 
 	if (!sched_core_enabled(rq))
 		return __pick_next_task(rq, rf);
@@ -6266,7 +6266,9 @@ pick_next_task(struct rq *rq, struct rq_
 	prev_balance(rq, rf);
 
 	smt_mask = cpu_smt_mask(cpu);
-	need_sync = !!rq->core->core_cookie;
+
+restart:
+	need_sync |= !!rq->core->core_cookie;
 
 	/* reset state */
 	rq->core->core_cookie = 0UL;
@@ -6301,10 +6303,15 @@ pick_next_task(struct rq *rq, struct rq_
 	 * and there are no cookied tasks running on siblings.
 	 */
 	if (!need_sync) {
-restart_single:
 		next = pick_task(rq, rf);
-		if (unlikely(next == RETRY_TASK))
-			goto restart_single;
+		if (unlikely(next == RETRY_TASK)) {
+			/* rq lock may have been dropped, clocks invalidated */
+			core_clock_updated = false;
+			if (!(rq->clock_update_flags & RQCF_UPDATED))
+				update_rq_clock(rq);
+			goto restart;
+		}
+
 		if (!next->core_cookie) {
 			rq->core_pick = NULL;
 			rq->core_dl_server = NULL;
@@ -6324,7 +6331,6 @@ restart_single:
 	 *
 	 * Tie-break prio towards the current CPU
 	 */
-restart_multi:
 	max = NULL;
 	for_each_cpu_wrap(i, smt_mask, cpu) {
 		rq_i = cpu_rq(i);
@@ -6338,8 +6344,13 @@ restart_multi:
 			update_rq_clock(rq_i);
 
 		p = pick_task(rq_i, rf);
-		if (unlikely(p == RETRY_TASK))
-			goto restart_multi;
+		if (unlikely(p == RETRY_TASK)) {
+			/* rq lock may have been dropped, clocks invalidated */
+			core_clock_updated = false;
+			if (!(rq->clock_update_flags & RQCF_UPDATED))
+				update_rq_clock(rq);
+			goto restart;
+		}
 
 		rq_i->core_pick = p;
 		rq_i->core_dl_server = rq_i->dl_server;


