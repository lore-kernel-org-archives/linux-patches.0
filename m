Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4922DF3C9;
	Tue, 17 Jun 2025 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174345; cv=none; b=R/fDftjzNZkjHTQIv5d86mOKh00Xk2W7lh5sETmozv3FRCKdhKxXJDdcpoWuOkjfpBYFJ872cQ3UbQkVOQwleYQ2hmfCFQii3ofdSTH6Vnj7u/2htPlX9PLnexKVT99xKgMHSoo9mk6PqHaHNVqUCMT9VEOPtRuZYSiChFtVj/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174345; c=relaxed/simple;
	bh=JJx/Mjz7AT7L4aIdZa2f5BA3hkTn46bGnf6why2TDtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI4vWmWi1iWAeIc58LQMQ0IzxYbM09CcFdNpzyzG0jw11Ahf1t7uGwr5HmJB3nfY+tHrzHE8cqGmmKU3O+ve206zc3+vJ5BUJ3oni1Za+7OIuamBAVonff3ZZFqnvFOkIem6ndI62VPzsL8CmuDvqetXzerCMIXX56w9M5Hb820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NaHzYgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NaHzYgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB87C4CEE3;
	Tue, 17 Jun 2025 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174345;
	bh=JJx/Mjz7AT7L4aIdZa2f5BA3hkTn46bGnf6why2TDtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NaHzYgijm/Ywa3yJtgWV/p79fKs1MW4beY6o+MMdCTebOzv9EMMkkWlIS5ngy/yx
	 onAhCtjK9WKLxyuzZoGd32eDz2ZuTonH0y/jpTjjd66rn5yAFPTO/uHRz8FC/tWHhr
	 2XnmVUJY1GJlRQ6oxlcd68c1bnTdfm8tIfbZNeIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/512] sched: Fix trace_sched_switch(.prev_state)
Date: Tue, 17 Jun 2025 17:19:30 +0200
Message-ID: <20250617152419.703616071@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

[ Upstream commit 8feb053d53194382fcfb68231296fdc220497ea6 ]

Gabriele noted that in case of signal_pending_state(), the tracepoint
sees a stale task-state.

Fixes: fa2c3254d7cf ("sched/tracing: Don't re-read p->state when emitting sched_switch event")
Reported-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e9bb1b4c58421..814abc7ad994a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6517,12 +6517,14 @@ pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
  * Otherwise marks the task's __state as RUNNING
  */
 static bool try_to_block_task(struct rq *rq, struct task_struct *p,
-			      unsigned long task_state)
+			      unsigned long *task_state_p)
 {
+	unsigned long task_state = *task_state_p;
 	int flags = DEQUEUE_NOCLOCK;
 
 	if (signal_pending_state(task_state, p)) {
 		WRITE_ONCE(p->__state, TASK_RUNNING);
+		*task_state_p = TASK_RUNNING;
 		return false;
 	}
 
@@ -6656,7 +6658,7 @@ static void __sched notrace __schedule(int sched_mode)
 			goto picked;
 		}
 	} else if (!preempt && prev_state) {
-		try_to_block_task(rq, prev, prev_state);
+		try_to_block_task(rq, prev, &prev_state);
 		switch_count = &prev->nvcsw;
 	}
 
-- 
2.39.5



