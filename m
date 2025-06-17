Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BEC2E9730;
	Tue, 17 Jun 2025 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174653; cv=none; b=LolqxuStF9JAF4VY1IqwWUnKBsLjGDDjWiR5Y7syyeyik0MuWyojyEZ5QSkEu7x018RXj1+YEoMQaW9WecRSATWKOlNMRsRG1AZRh4FLUh+6ZtV6dP9zaTXdn5N0EniTRplW6XuQ4L8+jjd44kTU3UeiOz7rkwuYgqAm7yJIS/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174653; c=relaxed/simple;
	bh=LAD5+HNQXSpr2dYl8Kt6xR25lEG4b59VaQY3P51zu7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9jaKlhK6VTX9QYVyAvbdLgeob6YcFC5ZPAFROQdonL3wmmt3BDxMlMe2fStqJ3wff5ei8GBZI6uUW6Hocsj1n5/Y7KQagKuTEOYD7Oi8kHACGwCDJKQrX1fcggH4U64g+ZLCFoOa0d376YiExiWrDTIrl+wDKtZrIXQbAm7Yks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geHNiaKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geHNiaKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F55FC4CEE3;
	Tue, 17 Jun 2025 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174653;
	bh=LAD5+HNQXSpr2dYl8Kt6xR25lEG4b59VaQY3P51zu7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geHNiaKqZZtniNY1xHwRHLM5meugz7SWAJR/0kTNeJ3CqqvYywL/3R+l0FcH3Q2HY
	 WmH3zYFcxiyd1CPSuuPBYxbAJCf76H14eVrWQekV3oDHJli7Eyvdy99XYWzV2Hq5mR
	 L4HDzEOVsMpmVCc8mdUx/u6aol6TxYkhuEEo5AVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 005/780] sched: Fix trace_sched_switch(.prev_state)
Date: Tue, 17 Jun 2025 17:15:13 +0200
Message-ID: <20250617152451.716777039@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c81cf642dba05..36b34e6884587 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6571,12 +6571,14 @@ pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
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
 
@@ -6713,7 +6715,7 @@ static void __sched notrace __schedule(int sched_mode)
 			goto picked;
 		}
 	} else if (!preempt && prev_state) {
-		try_to_block_task(rq, prev, prev_state);
+		try_to_block_task(rq, prev, &prev_state);
 		switch_count = &prev->nvcsw;
 	}
 
-- 
2.39.5



