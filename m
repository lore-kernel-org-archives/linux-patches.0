Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095BD420E7C;
	Sat, 12 Sep 2026 08:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202492; cv=none; b=cmEgPS3NYFfUOoqLCy6aewaZLipNhghTg5qqrHCzSof5ICCIf/rDofXM+ZeXJUNElnmQyrK1e1kPIXir4Cnluo9yLNcQ5Tt718LoG0I1lMxRE1DRdIklGztYNQttgGzJiuzrPT8s19cOVnKGxhsRbIkV74zGf7MKf3IaFeeD5Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202492; c=relaxed/simple;
	bh=itYPl20BDduGyOrywd2K5dku7mKJOMMBzSKh9eqAHsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEo8PkxDeU5ofSlCrPCJwNmcJN9GZQVAdqbbTAl4spJyMFFJ/SvrX7jfud3fluEYSt2pyeaE9JMDEknBz8DaEixU0WxFqy/ifUnqx+5ANxotyB2R8VIZAOPKomCQ2j9BLyh1lXyoCPmM92NUNcEXc1PH1qtiCXl0yErB49R8nWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2fy1/Ov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2fy1/Ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDBE1F00893;
	Sat, 12 Sep 2026 08:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202490;
	bh=j+QJnluI3y2jQKVMEujK/KzPryCtsFxiiyabfTOUZYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2fy1/OvIZ79gdVFMGhDDxQV9NxTVMqATKzZcIRzNRnGJJedPeb8jU25tW2fbPb8/
	 Y16oV70W3e36bmjDWf1AFosoashPepW35CYxDBckq2RANfZkheWvktTEwnIAlnO1vH
	 WCzrr4hlKj/GAoC3PDDpOgUCIN9u1Mxv2iUHtics=
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
Subject: [PATCH 7.2 1214/1815] sched/fair: Check CPU capacity before comparing group types during load balance
Date: Sat, 12 Sep 2026 08:49:24 +0200
Message-ID: <20260912065717.504460726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 648fd3a39fd1f..4c7bb4b7018e2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11948,6 +11948,17 @@ static bool update_sd_pick_busiest(struct lb_env *env,
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
 
@@ -12054,17 +12065,6 @@ static bool update_sd_pick_busiest(struct lb_env *env,
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



