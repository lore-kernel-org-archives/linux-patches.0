Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97C936166F;
	Wed,  8 Apr 2026 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673158; cv=none; b=qJIhsQ0vBVubIZSzUT6lisZqmmgq6eFdn2+mzGHMa9op95vszs68tQSAc8ASgolxUgjKF7tvH/d5os/DZKeV88TS7L8S4OXTbvgwJxt2AtomYpAkYoBOCoL/HIXM3BwM8oYwRcujG95Zlsg0lG04oJaZY7/NV/t9qEKBa54/teI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673158; c=relaxed/simple;
	bh=PXrrihrx3OBhFD0iCF7cU1k6qCuzf8psvfgyiZblD9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTOcdwNC9VGwtMDRv4Es6J0WM6VHnE24x1OTiTQWx39z0jjKk3XivY+uz8rr68nEBFyv79PBGruKZQrLP6NjBBQ0pswoU4PMi4uJXMXh3Z50lYNAps7E5ETxIY3a1DuF37tyTVj49kmKVn/3PjiGqqO0LZboyqVNcpi88XpM6Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWNs60e1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWNs60e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8D5C19421;
	Wed,  8 Apr 2026 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673157;
	bh=PXrrihrx3OBhFD0iCF7cU1k6qCuzf8psvfgyiZblD9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWNs60e1jsyOLatE9pYzqB9aykoIjoTFjYudSoq6AYsKK10EcpJbXShR8sHR7D0Xo
	 JNo7v0wd46zi4tGlLL8weP2yj5V8HwhxHaexm6GKmUIq7gIX+FO+DwMIHMYXfxxSLL
	 AL9PUDpqhz3Kx67I2iZJJjetlt+wAJKPSUZ/5ABc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/277] sched/fair: Fix zero_vruntime tracking fix
Date: Wed,  8 Apr 2026 20:01:49 +0200
Message-ID: <20260408175938.504453749@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1319ea57529e131822bab56bf417c8edc2db9ae8 ]

John reported that stress-ng-yield could make his machine unhappy and
managed to bisect it to commit b3d99f43c72b ("sched/fair: Fix
zero_vruntime tracking").

The combination of yield and that commit was specific enough to
hypothesize the following scenario:

Suppose we have 2 runnable tasks, both doing yield. Then one will be
eligible and one will not be, because the average position must be in
between these two entities.

Therefore, the runnable task will be eligible, and be promoted a full
slice (all the tasks do is yield after all). This causes it to jump over
the other task and now the other task is eligible and current is no
longer. So we schedule.

Since we are runnable, there is no {de,en}queue. All we have is the
__{en,de}queue_entity() from {put_prev,set_next}_task(). But per the
fingered commit, those two no longer move zero_vruntime.

All that moves zero_vruntime are tick and full {de,en}queue.

This means, that if the two tasks playing leapfrog can reach the
critical speed to reach the overflow point inside one tick's worth of
time, we're up a creek.

Additionally, when multiple cgroups are involved, there is no guarantee
the tick will in fact hit every cgroup in a timely manner. Statistically
speaking it will, but that same statistics does not rule out the
possibility of one cgroup not getting a tick for a significant amount of
time -- however unlikely.

Therefore, just like with the yield() case, force an update at the end
of every slice. This ensures the update is never more than a single
slice behind and the whole thing is within 2 lag bounds as per the
comment on entity_key().

Fixes: b3d99f43c72b ("sched/fair: Fix zero_vruntime tracking")
Reported-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260401132355.081530332@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 292141f4aaa54..d9777c81db0da 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -707,7 +707,7 @@ void update_zero_vruntime(struct cfs_rq *cfs_rq, s64 delta)
  * Called in:
  *  - place_entity()      -- before enqueue
  *  - update_entity_lag() -- before dequeue
- *  - entity_tick()
+ *  - update_deadline()   -- slice expiration
  *
  * This means it is one entry 'behind' but that puts it close enough to where
  * the bound on entity_key() is at most two lag bounds.
@@ -1121,6 +1121,7 @@ static bool update_deadline(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	 * EEVDF: vd_i = ve_i + r_i / w_i
 	 */
 	se->deadline = se->vruntime + calc_delta_fair(se->slice, se);
+	avg_vruntime(cfs_rq);
 
 	/*
 	 * The task has consumed its request, reschedule.
@@ -5635,11 +5636,6 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	update_load_avg(cfs_rq, curr, UPDATE_TG);
 	update_cfs_group(curr);
 
-	/*
-	 * Pulls along cfs_rq::zero_vruntime.
-	 */
-	avg_vruntime(cfs_rq);
-
 #ifdef CONFIG_SCHED_HRTICK
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother
@@ -9086,7 +9082,7 @@ static void yield_task_fair(struct rq *rq)
 	 */
 	if (entity_eligible(cfs_rq, se)) {
 		se->vruntime = se->deadline;
-		se->deadline += calc_delta_fair(se->slice, se);
+		update_deadline(cfs_rq, se);
 	}
 }
 
-- 
2.53.0



