Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED881D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1248C433C8;
	Tue, 25 Jul 2023 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282966;
	bh=yX3/uYzmUZOT0tkbMvdSUeFimfWCpqHlEaJtgUje21U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=al9G0/A/Zw11BewVTOO1dgZGUAr2PPQzAp/MDmwXzJnIml0T6TTI8fG03BKeqykB/
	 NHX/b8TRIw9i8y0OlyYr+s0icmmyRGqfe88Isxv3blPCKYJZ6+vzVaCjch8q2L84wd
	 OyBg+sdawQIiY8KauFufzOqyHSK/8+3u6ZjJjpbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Domenico Cerasuolo <cerasuolodomenico@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/183] sched/psi: Extract update_triggers side effect
Date: Tue, 25 Jul 2023 12:45:18 +0200
Message-ID: <20230725104511.210308491@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>

[ Upstream commit 4468fcae49f08e88fbbffe05b29496192df89991 ]

This change moves update_total flag out of update_triggers function,
currently called only in psi_poll_work.
In the next patch, update_triggers will be called also in psi_avgs_work,
but the total update information is specific to psi_poll_work.
Returning update_total value to the caller let us avoid differentiating
the implementation of update_triggers for different aggregators.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lore.kernel.org/r/20230330105418.77061-4-cerasuolodomenico@gmail.com
Stable-dep-of: aff037078eca ("sched/psi: use kernfs polling functions for PSI trigger polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index a3d0b5cf797ab..f3df6a8ff493c 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -430,11 +430,11 @@ static u64 window_update(struct psi_window *win, u64 now, u64 value)
 	return growth;
 }
 
-static u64 update_triggers(struct psi_group *group, u64 now)
+static u64 update_triggers(struct psi_group *group, u64 now, bool *update_total)
 {
 	struct psi_trigger *t;
-	bool update_total = false;
 	u64 *total = group->total[PSI_POLL];
+	*update_total = false;
 
 	/*
 	 * On subsequent updates, calculate growth deltas and let
@@ -462,7 +462,7 @@ static u64 update_triggers(struct psi_group *group, u64 now)
 			 * been through all of them. Also remember to extend the
 			 * polling time if we see new stall activity.
 			 */
-			update_total = true;
+			*update_total = true;
 
 			/* Calculate growth since last update */
 			growth = window_update(&t->win, now, total[t->state]);
@@ -485,10 +485,6 @@ static u64 update_triggers(struct psi_group *group, u64 now)
 		t->pending_event = false;
 	}
 
-	if (update_total)
-		memcpy(group->rtpoll_total, total,
-				sizeof(group->rtpoll_total));
-
 	return now + group->rtpoll_min_period;
 }
 
@@ -622,6 +618,7 @@ static void psi_rtpoll_work(struct psi_group *group)
 {
 	bool force_reschedule = false;
 	u32 changed_states;
+	bool update_total;
 	u64 now;
 
 	mutex_lock(&group->rtpoll_trigger_lock);
@@ -686,8 +683,12 @@ static void psi_rtpoll_work(struct psi_group *group)
 		goto out;
 	}
 
-	if (now >= group->rtpoll_next_update)
-		group->rtpoll_next_update = update_triggers(group, now);
+	if (now >= group->rtpoll_next_update) {
+		group->rtpoll_next_update = update_triggers(group, now, &update_total);
+		if (update_total)
+			memcpy(group->rtpoll_total, group->total[PSI_POLL],
+				   sizeof(group->rtpoll_total));
+	}
 
 	psi_schedule_rtpoll_work(group,
 		nsecs_to_jiffies(group->rtpoll_next_update - now) + 1,
-- 
2.39.2



