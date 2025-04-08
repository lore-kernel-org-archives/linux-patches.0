Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D001426656B;
	Tue,  8 Apr 2025 12:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114268; cv=none; b=YI3Vt7k+N1c9hmseBO6Qq6z1oAGKEzClvV1URiM000RWjPIYqYuAlVRN7hQWKIUjGnj7k1dxJW9XA02ug66aWzcpC3f8r1OmgBBqQ6+uOfCkHeAvAwCbdG+NuknjPKGqWQF8UdTNVwdHnk+5ngVkBbJDs9rWW1ywkEbuFb3zxWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114268; c=relaxed/simple;
	bh=ctf++HOE+9nO4FD6mAU77nvT0yyDX/HoseqbOs83GHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNjcK77jNEE53v7uN/uIIE0cnuaWfx1QfkgeDts6G0zV3N9lKAr+GSxY1y2maHgSqtQ/Ot56pvOv/E+gimkQjwHAggkDORF3oitnqyPBpRJZvzcMsFlvpM82PWnyB5eZI2O00zN/QG3qvQ76vxsKmJ6AIDOdkbmd00fYh8kWZ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCw1gjgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCw1gjgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C6EC4CEE5;
	Tue,  8 Apr 2025 12:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114268;
	bh=ctf++HOE+9nO4FD6mAU77nvT0yyDX/HoseqbOs83GHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCw1gjgBsFRUb8TVVik3PzrqWQHgZZ/m/Qo/diZoILjC9+sP7XVyK2nOiqveUIqOG
	 MvDUn+CSfpksvKw6VZdwp8xNU5EkdDlK8D5dk0NuhyWCIiTiHJK1Bm9LdhCmQvgn1Y
	 1scRxr/8lwUXMOOOWA/VTF1VM/AfszQpCdKJa3Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zihan zhou <15645113830zzh@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 008/499] sched: Cancel the slice protection of the idle entity
Date: Tue,  8 Apr 2025 12:43:40 +0200
Message-ID: <20250408104851.462497006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: zihan zhou <15645113830zzh@gmail.com>

[ Upstream commit f553741ac8c0e467a3b873e305f34b902e50b86d ]

A wakeup non-idle entity should preempt idle entity at any time,
but because of the slice protection of the idle entity, the non-idle
entity has to wait, so just cancel it.

This patch is aimed at minimizing the impact of SCHED_IDLE on
SCHED_NORMAL. For example, a task with SCHED_IDLE policy that sleeps for
1s and then runs for 3 ms, running cyclictest on the same cpu, has a
maximum latency of 3 ms, which is caused by the slice protection of the
idle entity. It is unreasonable. With this patch, the cyclictest latency
under the same conditions is basically the same on the cpu with idle
processes and on empty cpu.

[peterz: add helpers]
Fixes: 63304558ba5d ("sched/eevdf: Curb wakeup-preemption")
Signed-off-by: zihan zhou <15645113830zzh@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20250208080850.16300-1-15645113830zzh@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 46 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4f850edf16401..9110f95adc8e3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -880,6 +880,26 @@ struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 	return __node_2_se(left);
 }
 
+/*
+ * HACK, stash a copy of deadline at the point of pick in vlag,
+ * which isn't used until dequeue.
+ */
+static inline void set_protect_slice(struct sched_entity *se)
+{
+	se->vlag = se->deadline;
+}
+
+static inline bool protect_slice(struct sched_entity *se)
+{
+	return se->vlag == se->deadline;
+}
+
+static inline void cancel_protect_slice(struct sched_entity *se)
+{
+	if (protect_slice(se))
+		se->vlag = se->deadline + 1;
+}
+
 /*
  * Earliest Eligible Virtual Deadline First
  *
@@ -916,11 +936,7 @@ static struct sched_entity *pick_eevdf(struct cfs_rq *cfs_rq)
 	if (curr && (!curr->on_rq || !entity_eligible(cfs_rq, curr)))
 		curr = NULL;
 
-	/*
-	 * Once selected, run a task until it either becomes non-eligible or
-	 * until it gets a new slice. See the HACK in set_next_entity().
-	 */
-	if (sched_feat(RUN_TO_PARITY) && curr && curr->vlag == curr->deadline)
+	if (sched_feat(RUN_TO_PARITY) && curr && protect_slice(curr))
 		return curr;
 
 	/* Pick the leftmost entity if it's eligible */
@@ -5517,11 +5533,8 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		update_stats_wait_end_fair(cfs_rq, se);
 		__dequeue_entity(cfs_rq, se);
 		update_load_avg(cfs_rq, se, UPDATE_TG);
-		/*
-		 * HACK, stash a copy of deadline at the point of pick in vlag,
-		 * which isn't used until dequeue.
-		 */
-		se->vlag = se->deadline;
+
+		set_protect_slice(se);
 	}
 
 	update_stats_curr_start(cfs_rq, se);
@@ -8767,8 +8780,15 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
 	 * in the inverse case).
 	 */
-	if (cse_is_idle && !pse_is_idle)
+	if (cse_is_idle && !pse_is_idle) {
+		/*
+		 * When non-idle entity preempt an idle entity,
+		 * don't give idle entity slice protection.
+		 */
+		cancel_protect_slice(se);
 		goto preempt;
+	}
+
 	if (cse_is_idle != pse_is_idle)
 		return;
 
@@ -8787,8 +8807,8 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 	 * Note that even if @p does not turn out to be the most eligible
 	 * task at this moment, current's slice protection will be lost.
 	 */
-	if (do_preempt_short(cfs_rq, pse, se) && se->vlag == se->deadline)
-		se->vlag = se->deadline + 1;
+	if (do_preempt_short(cfs_rq, pse, se))
+		cancel_protect_slice(se);
 
 	/*
 	 * If @p has become the most eligible task, force preemption.
-- 
2.39.5



