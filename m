Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB152D9792;
	Sat, 12 Sep 2026 19:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239855; cv=none; b=Dx9hAhsXfYdHUP8NTPvc/4waDDdnRCpEJGNrIyL1+wkvXOStGfAKSgLLRoZNQLn7rMQ0uSDNkW7E33ujImA8ydMfEzUvxTnGGSKR+FBk48TflYBdgpXHUscTFon/WFopMSEj+cXUuE7E2+CMzdqLKLotlXFlzGBP17+31G/V6Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239855; c=relaxed/simple;
	bh=KhqJ2eCKrd2sCnvJC40SGS0JYgwJnrt9FChrm1PMm+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9g1JRIyu9w5JovyazWWEIyHWrTvTACYUwB19+MveJkum0FkVLtWGZUFpjYPVa65L927xylbBmSThOiEaNJPU1hx3c0WIAsDHAEIMN8HHdzoPP0fJAlOCTkenVLAqmsYBs851zFpe3wqDZyWSIdMksAO0wfZJ0CASf3gFRBaUDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbOsj3Y6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbOsj3Y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22FA1F000FF;
	Sat, 12 Sep 2026 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239853;
	bh=agV9Hypx820ot9lWxGYv8fMFftva96BMcku37a/cF8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbOsj3Y6Y2T+/rbt7R3roOxm1TCfDs0j785fr/bvsTK9dLDUahNWKGfKYWiKEDMUX
	 OLrEcbTnMWGnd0epWEZN00vAkpU+vvOY2OqBRjeQMwV79dNxSAKmycFevxqzFm5uyy
	 wg6hh/JwAdaU6KZSoiPBqD0D+UOsktu6CBlcIMXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Christian Loehle <christian.loehle@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 748/935] sched/fair: Check CPU capacity before comparing group types during load balance
Date: Sat, 12 Sep 2026 09:02:58 +0200
Message-ID: <20260912065543.987811329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 50b101f6e586b4417d060a976fd831cd87e86e2b ]

update_sd_pick_busiest() may incorrectly select a fully_busy group as the
busiest group when its per-CPU capacity exceeds that of the destination
CPU. This happens because the type of busiest group is initialized to
group_has_spare and allows the fully_busy group to win the type comparison.

update_sd_pick_busiest() should not choose a candidate scheduling group
with at most one runnable task if its per-CPU capacity is greater than that
of the destination CPU. Such a check already exists, but it is done too
late: after the type comparison, preventing a subsequent fully_busy group
of equal per-CPU capacity from being correctly selected.

Move this check to occur before comparing group types.

Fixes: 0b0695f2b34a ("sched/fair: Rework load_balance()")
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Andrea Righi <arighi@nvidia.com>
Link: https://patch.msgid.link/20260720-rneri-fix-cas-clusters-v6-3-bb500bf4afd4@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f2a58e54268ea..15ea6bded7607 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9026,6 +9026,17 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	     sds->local_stat.group_type != group_has_spare))
 		return false;
 
+	/*
+	 * Candidate sg has no more than one task per CPU and has higher
+	 * per-CPU capacity. Migrating tasks to less capable CPUs may harm
+	 * throughput. Maximize throughput, power/energy consequences are not
+	 * considered.
+	 */
+	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
+	    (sgs->group_type <= group_fully_busy) &&
+	    (capacity_greater(sg->sgc->min_capacity, capacity_of(env->dst_cpu))))
+		return false;
+
 	if (sgs->group_type > busiest->group_type)
 		return true;
 
@@ -9098,17 +9109,6 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 		break;
 	}
 
-	/*
-	 * Candidate sg has no more than one task per CPU and has higher
-	 * per-CPU capacity. Migrating tasks to less capable CPUs may harm
-	 * throughput. Maximize throughput, power/energy consequences are not
-	 * considered.
-	 */
-	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
-	    (sgs->group_type <= group_fully_busy) &&
-	    (capacity_greater(sg->sgc->min_capacity, capacity_of(env->dst_cpu))))
-		return false;
-
 	return true;
 }
 
-- 
2.53.0



