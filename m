Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9F1146A63;
	Wed,  5 Feb 2025 13:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763545; cv=none; b=TEUpMbWWaN5cDFoSQ9JuNU/lS33LhP9SfBdFntfpd7ABiUtoimtDaVaErBn5uKhtjqiwhmQiGGI7H0XPd5TYZtK+PKuI6Zl7gT2b2KL4n37GGYsU8ZkIv9F8/BUDHfABy8HDZTecuOklh8h+G9oerWY3PA4pO0ZoAAQ8yjdY5Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763545; c=relaxed/simple;
	bh=dsZTcUkTrZwDH/jR/Ae+cSWD78pclh7XL3Vuzk31lTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0o8tOUa21/XHKYRt/CR8gx2jDAObjYAt1vKXcp5TtiPxB7TrUMJfCejghsCTZo4IAbSTFPZOzhrzrzBet6PmeR3P8s0Utli0myDqWuNfTfwJuWMbVrN0tANrSdshGhst0u9HHc9hzYnYEOL+2Zp2Roh7eoHmuN/hQLPAM+kDK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBkwhEFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBkwhEFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AD0C4CED1;
	Wed,  5 Feb 2025 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763544;
	bh=dsZTcUkTrZwDH/jR/Ae+cSWD78pclh7XL3Vuzk31lTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBkwhEFDsSctzUS3ME6wJ33Zn7zcn8a1X93+0RuQqONb51s9FRk86KIGvl6TzWg02
	 VEJj+rImFSRD7DPj91PcbpnUgzd4RwJn7ml5h6lqj4V+hroQNUGT1uIy86sq8M/XfM
	 M4zQOXSJIDZlKbmU1jZ+f7oTx7VQPs3oMC1+Ru1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/590] sched/fair: Untangle NEXT_BUDDY and pick_next_task()
Date: Wed,  5 Feb 2025 14:36:23 +0100
Message-ID: <20250205134456.323437095@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2a77e4be12cb58bbf774e7c717c8bb80e128b7a4 ]

There are 3 sites using set_next_buddy() and only one is conditional
on NEXT_BUDDY, the other two sites are unconditional; to note:

  - yield_to_task()
  - cgroup dequeue / pick optimization

However, having NEXT_BUDDY control both the wakeup-preemption and the
picking side of things means its near useless.

Fixes: 147f3efaa241 ("sched/fair: Implement an EEVDF-like scheduling policy")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20241129101541.GA33464@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c     | 4 ++--
 kernel/sched/features.h | 9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 60be5f8bbe711..a21110b220b7b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5647,9 +5647,9 @@ static struct sched_entity *
 pick_next_entity(struct rq *rq, struct cfs_rq *cfs_rq)
 {
 	/*
-	 * Enabling NEXT_BUDDY will affect latency but not fairness.
+	 * Picking the ->next buddy will affect latency but not fairness.
 	 */
-	if (sched_feat(NEXT_BUDDY) &&
+	if (sched_feat(PICK_BUDDY) &&
 	    cfs_rq->next && entity_eligible(cfs_rq, cfs_rq->next)) {
 		/* ->next will never be delayed */
 		SCHED_WARN_ON(cfs_rq->next->sched_delayed);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 290874079f60d..050d7503064e3 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -31,6 +31,15 @@ SCHED_FEAT(PREEMPT_SHORT, true)
  */
 SCHED_FEAT(NEXT_BUDDY, false)
 
+/*
+ * Allow completely ignoring cfs_rq->next; which can be set from various
+ * places:
+ *   - NEXT_BUDDY (wakeup preemption)
+ *   - yield_to_task()
+ *   - cgroup dequeue / pick
+ */
+SCHED_FEAT(PICK_BUDDY, true)
+
 /*
  * Consider buddies to be cache hot, decreases the likeliness of a
  * cache buddy being migrated away, increases cache locality.
-- 
2.39.5



