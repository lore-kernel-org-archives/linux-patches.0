Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA15F13C9C4;
	Wed,  5 Feb 2025 13:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763584; cv=none; b=Z9HrYwaa6hCWq2aI2Hw4kOs2mZEryMlGUdo75ycn2VY/xUnEqIzLBOK1r724YKLSqjZrWyIZbS/tNc09NihBz0S75QibgV1cJwcMAvVLzMjS0ilC5eKxhYdDzM9UzvJG3OOAxTLiVBXJ46OIUukVwjkaNMPkt6K/LrxG9uOqj34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763584; c=relaxed/simple;
	bh=XNkVD8zda0f8pj2VtTQge6sJPzeo6o8/tkBlMngbziw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKJVqgxNPqTdoHC9DM703NXSza3flDVPLhq+JK4pcjpxiMgpJALA2ZlR42sQbJi38LK04IFtIgeOkVceGrLTqZrNPMbl3zpLbJx7ua5hLhzYk2Jjn/8+Af+AUOow94rR9By9DxQvy1TLjO4CKMuEAqSEkR0lKWCP3p8wwDr5eIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+BuHpcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+BuHpcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A550C4CEDD;
	Wed,  5 Feb 2025 13:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763584;
	bh=XNkVD8zda0f8pj2VtTQge6sJPzeo6o8/tkBlMngbziw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+BuHpcILxnlFiaDfa0hstL2LFOLpgBSy9s29d+uB2PStqDjrFse/OhmbtsdepllF
	 9puJyk+KTtCQszKUfm2H0alDrDATFAZTjFCMwMJZl+dqr5SGxWhvfuIdXkGNnKdNhM
	 XyVW6yjCGZWdEiujWQbQYpesKh5l5gc/QZB1i0Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Metin Kaya <metin.kaya@arm.com>,
	Qais Yousef <qyousef@layalina.io>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/590] sched: Split out __schedule() deactivate task logic into a helper
Date: Wed,  5 Feb 2025 14:36:28 +0100
Message-ID: <20250205134456.518230907@linuxfoundation.org>
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

From: John Stultz <jstultz@google.com>

[ Upstream commit 7b3d61f6578ab06f130ecc13cd2f3010a6c295bb ]

As we're going to re-use the deactivation logic,
split it into a helper.

Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Metin Kaya <metin.kaya@arm.com>
Reviewed-by: Qais Yousef <qyousef@layalina.io>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Metin Kaya <metin.kaya@arm.com>
Link: https://lore.kernel.org/r/20241009235352.1614323-7-jstultz@google.com
Stable-dep-of: 7d9da040575b ("psi: Fix race when task wakes up before psi_sched_switch() adjusts flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 67 +++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d07dc87787dff..d794d9bb429fd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6507,6 +6507,45 @@ pick_next_task(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 #define SM_PREEMPT		1
 #define SM_RTLOCK_WAIT		2
 
+/*
+ * Helper function for __schedule()
+ *
+ * If a task does not have signals pending, deactivate it
+ * Otherwise marks the task's __state as RUNNING
+ */
+static bool try_to_block_task(struct rq *rq, struct task_struct *p,
+			      unsigned long task_state)
+{
+	int flags = DEQUEUE_NOCLOCK;
+
+	if (signal_pending_state(task_state, p)) {
+		WRITE_ONCE(p->__state, TASK_RUNNING);
+		return false;
+	}
+
+	p->sched_contributes_to_load =
+		(task_state & TASK_UNINTERRUPTIBLE) &&
+		!(task_state & TASK_NOLOAD) &&
+		!(task_state & TASK_FROZEN);
+
+	if (unlikely(is_special_task_state(task_state)))
+		flags |= DEQUEUE_SPECIAL;
+
+	/*
+	 * __schedule()			ttwu()
+	 *   prev_state = prev->state;    if (p->on_rq && ...)
+	 *   if (prev_state)		    goto out;
+	 *     p->on_rq = 0;		  smp_acquire__after_ctrl_dep();
+	 *				  p->state = TASK_WAKING
+	 *
+	 * Where __schedule() and ttwu() have matching control dependencies.
+	 *
+	 * After this, schedule() must not care about p->state any more.
+	 */
+	block_task(rq, p, flags);
+	return true;
+}
+
 /*
  * __schedule() is the main scheduler function.
  *
@@ -6615,33 +6654,7 @@ static void __sched notrace __schedule(int sched_mode)
 			goto picked;
 		}
 	} else if (!preempt && prev_state) {
-		if (signal_pending_state(prev_state, prev)) {
-			WRITE_ONCE(prev->__state, TASK_RUNNING);
-		} else {
-			int flags = DEQUEUE_NOCLOCK;
-
-			prev->sched_contributes_to_load =
-				(prev_state & TASK_UNINTERRUPTIBLE) &&
-				!(prev_state & TASK_NOLOAD) &&
-				!(prev_state & TASK_FROZEN);
-
-			if (unlikely(is_special_task_state(prev_state)))
-				flags |= DEQUEUE_SPECIAL;
-
-			/*
-			 * __schedule()			ttwu()
-			 *   prev_state = prev->state;    if (p->on_rq && ...)
-			 *   if (prev_state)		    goto out;
-			 *     p->on_rq = 0;		  smp_acquire__after_ctrl_dep();
-			 *				  p->state = TASK_WAKING
-			 *
-			 * Where __schedule() and ttwu() have matching control dependencies.
-			 *
-			 * After this, schedule() must not care about p->state any more.
-			 */
-			block_task(rq, prev, flags);
-			block = true;
-		}
+		block = try_to_block_task(rq, prev, prev_state);
 		switch_count = &prev->nvcsw;
 	}
 
-- 
2.39.5



