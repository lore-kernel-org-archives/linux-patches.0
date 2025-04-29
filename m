Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976CC248866;
	Tue, 29 Apr 2025 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945945; cv=none; b=spS+0h/X2FGTP9O0TRVv6X6y6eKX/OePNLHkaIjg+VjVJSgRakDBNJdu7OCTtu95GiMlYWJp/cqzhCwXA1pipwZDwqtmj1ghixqSlsdywJQ6gCHgL2GOFr9tgdCzwpjDIyW3TgSXiJtqDwkwOeTTEG8B85vYjrJm6aSSY7fE4OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945945; c=relaxed/simple;
	bh=z9bDdnp9gZxTNNJquiDaxb4iKmUmOw7sowIRA4JPP5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLUGcSFl4T2aPImspBYnpxruuVMWK0kS09tHsnz6/mhJTlynQHZfMOXqFYyuhvaMxlIKRB1rVAfWTUkVbbA57Yty3mAHtqx67t2D0RQtSYn42IYYD41wg5BCVyyWJy92iXCCdaNfWt9l/wVIQLXAJmOSxj71lsYm+Fn6Cff8lVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eraz9dk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eraz9dk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A889C4CEE3;
	Tue, 29 Apr 2025 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945945;
	bh=z9bDdnp9gZxTNNJquiDaxb4iKmUmOw7sowIRA4JPP5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eraz9dk2bTHJXTVgLRP+9mcqhY54MCLZFEL5L7LLSti4J7aqBZSCc3GbwSLNu7Ghu
	 T7fwqpABtLoHFFgkQgj0uY55PDRI+rHA/bzOd6TpQon3qpxWu3acsJl/nrm8QMjRNz
	 zAwvy5lVwXBKq/bPB6ElYwTrBrkwFW4m8FIsf7EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 102/311] sched/eevdf: Fix se->slice being set to U64_MAX and resulting crash
Date: Tue, 29 Apr 2025 18:38:59 +0200
Message-ID: <20250429161125.215831187@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit bbce3de72be56e4b5f68924b7da9630cc89aa1a8 ]

There is a code path in dequeue_entities() that can set the slice of a
sched_entity to U64_MAX, which sometimes results in a crash.

The offending case is when dequeue_entities() is called to dequeue a
delayed group entity, and then the entity's parent's dequeue is delayed.
In that case:

1. In the if (entity_is_task(se)) else block at the beginning of
   dequeue_entities(), slice is set to
   cfs_rq_min_slice(group_cfs_rq(se)). If the entity was delayed, then
   it has no queued tasks, so cfs_rq_min_slice() returns U64_MAX.
2. The first for_each_sched_entity() loop dequeues the entity.
3. If the entity was its parent's only child, then the next iteration
   tries to dequeue the parent.
4. If the parent's dequeue needs to be delayed, then it breaks from the
   first for_each_sched_entity() loop _without updating slice_.
5. The second for_each_sched_entity() loop sets the parent's ->slice to
   the saved slice, which is still U64_MAX.

This throws off subsequent calculations with potentially catastrophic
results. A manifestation we saw in production was:

6. In update_entity_lag(), se->slice is used to calculate limit, which
   ends up as a huge negative number.
7. limit is used in se->vlag = clamp(vlag, -limit, limit). Because limit
   is negative, vlag > limit, so se->vlag is set to the same huge
   negative number.
8. In place_entity(), se->vlag is scaled, which overflows and results in
   another huge (positive or negative) number.
9. The adjusted lag is subtracted from se->vruntime, which increases or
   decreases se->vruntime by a huge number.
10. pick_eevdf() calls entity_eligible()/vruntime_eligible(), which
    incorrectly returns false because the vruntime is so far from the
    other vruntimes on the queue, causing the
    (vruntime - cfs_rq->min_vruntime) * load calulation to overflow.
11. Nothing appears to be eligible, so pick_eevdf() returns NULL.
12. pick_next_entity() tries to dereference the return value of
    pick_eevdf() and crashes.

Dumping the cfs_rq states from the core dumps with drgn showed tell-tale
huge vruntime ranges and bogus vlag values, and I also traced se->slice
being set to U64_MAX on live systems (which was usually "benign" since
the rest of the runqueue needed to be in a particular state to crash).

Fix it in dequeue_entities() by always setting slice from the first
non-empty cfs_rq.

Fixes: aef6987d8954 ("sched/eevdf: Propagate min_slice up the cgroup hierarchy")
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/f0c2d1072be229e1bdddc73c0703919a8b00c652.1745570998.git.osandov@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 89c7260103e18..3d9b68a347b76 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7083,9 +7083,6 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 		h_nr_idle = task_has_idle_policy(p);
 		if (task_sleep || task_delayed || !se->sched_delayed)
 			h_nr_runnable = 1;
-	} else {
-		cfs_rq = group_cfs_rq(se);
-		slice = cfs_rq_min_slice(cfs_rq);
 	}
 
 	for_each_sched_entity(se) {
@@ -7095,6 +7092,7 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 			if (p && &p->se == se)
 				return -1;
 
+			slice = cfs_rq_min_slice(cfs_rq);
 			break;
 		}
 
-- 
2.39.5



