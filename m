Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B745B4F4CF5;
	Thu, 17 Sep 2026 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661275; cv=none; b=o59z4rUDVctTpVY2MZKmNquUA+IsAbGi/bwMMnTslnJvYwv4nrTRxA5zfVhbGshFv1PxaKrjaV20giPoVrc7h6P8YGSPTTQuSnW+7qShpdPFNm41+IVVaHA0u1YMmng6MZ8CggXXVBrwbasJ7nS0ib32MZUqO3tVNC9Krsrs9Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661275; c=relaxed/simple;
	bh=Q7ItusjTZiSIFmpTzf+jL8DoqQoDH2xQtDUK8fV1Q10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrMy3Dt4Gd+bjaYsaJc6djC/pqAljUSN7sEDg80jEtdGvvrnLyq5Pi56a4+2nQVTaBbfMFvPOT2TpfeJhOagvoQFnIHvmMVCgWSCm012Yy/g/Xh+7MyKS3Vm+QXrEQQjlxHr7CSm/SDVB/0d3cPX4rQjCqeA5rQdWIGg6XQ+rt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjKx04Ui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjKx04Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191B51F000FF;
	Thu, 17 Sep 2026 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661273;
	bh=7nl34vNX83gzxl9iD68LnQRVrqf6WRtYvxYh79/JCZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjKx04UiwBf8zZtYYNiX88dk/0SCtESudbzGEeoh6Q3HzBxkVgJFeUg08Cmvo3cjM
	 tDcbjWlpfsnmW+nUzbUGCNcqAz/smdXjlbkxmXD41jo8pms7rFU30PjWR0CGmDozmq
	 Zc8B7pzO/vrQU5ZPxtJEg7Wlvp96enh5lfyBBLGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Abecassis <fabecassis@nvidia.com>,
	Andrea Righi <arighi@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0141/1250] sched/fair: Reject misfit pulls onto busy SMT siblings on asym-capacity
Date: Thu, 17 Sep 2026 15:58:56 +0100
Message-ID: <20260917151555.877157639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 4f02f823d1042..2aeb12a6ce2d0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9498,6 +9498,7 @@ struct lb_env {
 
 	int			dst_cpu;
 	struct rq		*dst_rq;
+	bool			dst_core_idle;
 
 	struct cpumask		*dst_grpmask;
 	int			new_dst_cpu;
@@ -10741,10 +10742,16 @@ static bool update_sd_pick_busiest(struct lb_env *env,
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
 
@@ -11311,6 +11318,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	unsigned long sum_util = 0;
 	bool sg_overloaded = 0, sg_overutilized = 0;
 
+	env->dst_core_idle = !sched_smt_active() || is_core_idle(env->dst_cpu);
+
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
-- 
2.53.0



