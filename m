Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE4B296FB0;
	Mon, 12 May 2025 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073203; cv=none; b=UBK+VzlbBdwD8vDvHIXoYN4Yp5ZFY48VtC6xrhwqi+/36sFVDcB4UMiTHQSfLCvcXPI4I8wFPBM5LevAZjHz2p2ke4zJhQrdjsfTAKnOGB4nQwc3xBaKLWaA5ZnkiqZE1dzCOvDYqJXwoU7xUzPGvdRgqiNHwPUYsX0ye/7J1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073203; c=relaxed/simple;
	bh=SU4FiphJE/y3+VaGhXN8BN1auITdiV8Y5oTLiGDiWFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDOR2hBVjF5o7hU/XTojLr2bg9Rz4jw7s04/7a1fCBvIbuzGO59mVK8ODqd5H5SFpG+aAR0lyiTZHDBO3+8sNA8YdKYANivnv44wSgIeWR6WE0TpZ9QQoWOMVDyQh6XCKBa7cX3AhALGFBKW/ElN7GcKKzy/E0TDBNuptF8rlR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqRBpK4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqRBpK4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FF7C4CEE7;
	Mon, 12 May 2025 18:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073202;
	bh=SU4FiphJE/y3+VaGhXN8BN1auITdiV8Y5oTLiGDiWFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqRBpK4U3BMQEU6WI9TCMcQL+Se28SlZMvOm2betypHUTeAL2GH0ergivjQf0O1Gk
	 16ZwoIyj3gJY6O/ttnWdD8ZYr+nWelu8QpjBDRS/8F/T0SOfCcV2e8eiMb/fefZAkC
	 lGQAAKAmF7BkG3nja/+sV+hqjD3TfJmniHm8M5Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.12 161/184] sched/eevdf: Fix se->slice being set to U64_MAX and resulting crash
Date: Mon, 12 May 2025 19:46:02 +0200
Message-ID: <20250512172048.371001804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Omar Sandoval <osandov@fb.com>

commit bbce3de72be56e4b5f68924b7da9630cc89aa1a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7182,9 +7182,6 @@ static int dequeue_entities(struct rq *r
 		idle_h_nr_running = task_has_idle_policy(p);
 		if (!task_sleep && !task_delayed)
 			h_nr_delayed = !!se->sched_delayed;
-	} else {
-		cfs_rq = group_cfs_rq(se);
-		slice = cfs_rq_min_slice(cfs_rq);
 	}
 
 	for_each_sched_entity(se) {
@@ -7194,6 +7191,7 @@ static int dequeue_entities(struct rq *r
 			if (p && &p->se == se)
 				return -1;
 
+			slice = cfs_rq_min_slice(cfs_rq);
 			break;
 		}
 


