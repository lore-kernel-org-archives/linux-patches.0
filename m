Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B93D3D1B;
	Thu, 17 Sep 2026 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667451; cv=none; b=uhmI7vIl1Ug05q4iZEgc6BPjcAImHVroS9qsTNMxev5zmgS7uk0BzPy37QOT/yXTlaqF6AsMMgIGipj0y1Bg7ea38XG5E/2aDYGOD2SOdTDwuYf7HXdhBhH8Z6GEv/GMG2kXYRflnw4H28CjvKB1yVsEEmzwRk9/pefQ17qNSf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667451; c=relaxed/simple;
	bh=kBbafnsGATfYcPa2656k68pfUGVmrvU4O6TQq4qzcQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Skb4TT2L5EoBINFGUOxNtN/SBU2XQ5BPP7VJDraYeqrUPLiDu/a2Dx0OTwGfFNqnTENcCJT79UGck2F0pzJGqNuO5fN4EF5/VzAYNAKyUNh2nOnYcb1ZN0ufCOboym5scbYWcBA1GRZO3ihXq8+Ks2ng7eyB/JHn10B/ivKTSkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioyw3+rw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioyw3+rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705511F000FF;
	Thu, 17 Sep 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667450;
	bh=XC6XkxzQa8e0KxOgczBTQR0TpA0ZAxrKw//JzhbMmJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ioyw3+rwku405i4YcpgYnoa/sKBP1bcK1+KqhCcsJzUskpweiwq6zKKt1h3UHcoAa
	 Cw0KHt08JB4yKYY5mN+wF7ShCXzEq2TbPlb1ug+zOhGj24b4hCps7Gvb5/gjPstBUb
	 aiR3r2Fy3Xwyl1RzU7ZxfxLBCRunoUn9upBw3Y6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Abecassis <fabecassis@nvidia.com>,
	Andrea Righi <arighi@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0098/1102] sched/fair: Reject misfit pulls onto busy SMT siblings on asym-capacity
Date: Thu, 17 Sep 2026 16:00:41 +0100
Message-ID: <20260917151541.953937096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit bf6aa722198d3c06e4236e8c5a480f30a64e1513 ]

When SD_ASYM_CPUCAPACITY load balancing considers pulling a misfit task,
capacity_of(dst_cpu) can overstate available compute if the SMT sibling is
busy: the core does not deliver its full nominal capacity.

If SMT is active and dst_cpu is not on a fully idle core, skip this
destination so we do not migrate a misfit expecting a capacity upgrade we
cannot actually provide.

Reported-by: Felix Abecassis <fabecassis@nvidia.com>
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://patch.msgid.link/20260509180955.1840064-5-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 616ad9f86b228..011786704297c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9340,6 +9340,7 @@ struct lb_env {
 
 	int			dst_cpu;
 	struct rq		*dst_rq;
+	bool			dst_core_idle;
 
 	struct cpumask		*dst_grpmask;
 	int			new_dst_cpu;
@@ -10530,10 +10531,16 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * We can use max_capacity here as reduction in capacity on some
 	 * CPUs in the group should either be possible to resolve
 	 * internally or be covered by avg_load imbalance (eventually).
+	 *
+	 * When SMT is active, only pull a misfit to dst_cpu if it is on a
+	 * fully idle core; otherwise the effective capacity of the core is
+	 * reduced and we may not actually provide more capacity than the
+	 * source.
 	 */
 	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
 	    (sgs->group_type == group_misfit_task) &&
-	    (!capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
+	    (!env->dst_core_idle ||
+	     !capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
 	     sds->local_stat.group_type != group_has_spare))
 		return false;
 
@@ -11099,6 +11106,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	unsigned long sum_util = 0;
 	bool sg_overloaded = 0, sg_overutilized = 0;
 
+	env->dst_core_idle = !sched_smt_active() || is_core_idle(env->dst_cpu);
+
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
-- 
2.53.0



