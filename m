Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCABB3AFAE2;
	Wed, 30 Sep 2026 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794022; cv=none; b=WpT0aiuWXS5RHwVYgrplG00w3yDUBHeDC9ad7F37b3S7wHEI+pU+J/3PQ5ptHyPXrDcPYbCziiaGnf/EPz59Nk0VR+sj9lVhWG8wHWzOdg1+/1tKudJ2ujPqW8Y90yK+N0mppPp7zM4zFmbfwlJVZ6BJffN5pshMr3Ynl/4bNco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794022; c=relaxed/simple;
	bh=O6+Y3jFqGm7ZjTWAccn7wOzWeF9e2iEKNKGopPecdU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAbc/t9SBH/89nUd4v3DoXuLLV1sdtsiW9225KTJI7iGpTH7JFILqKL/92voKfiJOGKzc8ks00oz++IA7mrj4SP/5wljiJlB5wsUzE4YhBa9mZkqQEADyYoBedEuUE9IXmigEg41Uy57qqoH9T2qU+yCcOznJIhTRhfSiRxfukw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NWU21Rp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NWU21Rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236081F000FF;
	Wed, 30 Sep 2026 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794020;
	bh=59jiseJLVKBU6G1Xt7ipE+1pvpTetrvqa5urfxSGVI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NWU21RpZ8fR7cJUDVil/33h0nyNfHnpx/tth37BsFg8b+91KeRvB1XHYPQAcjmBK
	 6zan+JRFAif65LAUArP8R30OCrqhnV8UlNgbcw5x1yupqnXMch/UWOmhnIGCIJfGAj
	 HYiUp1UbpCZQrymYi+Xes0t7eXomFEHT2197kbaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Abecassis <fabecassis@nvidia.com>,
	Andrea Righi <arighi@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0065/1193] sched/fair: Reject misfit pulls onto busy SMT siblings on asym-capacity
Date: Wed, 30 Sep 2026 17:12:29 +0200
Message-ID: <20260930152435.715835157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 43bc2f03e0c92..a1bdd45c62932 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8834,6 +8834,7 @@ struct lb_env {
 
 	int			dst_cpu;
 	struct rq		*dst_rq;
+	bool			dst_core_idle;
 
 	struct cpumask		*dst_grpmask;
 	int			new_dst_cpu;
@@ -10049,10 +10050,16 @@ static bool update_sd_pick_busiest(struct lb_env *env,
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
 
@@ -10626,6 +10633,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	unsigned long sum_util = 0;
 	int sg_status = 0;
 
+	env->dst_core_idle = !sched_smt_active() || is_core_idle(env->dst_cpu);
+
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
-- 
2.53.0



