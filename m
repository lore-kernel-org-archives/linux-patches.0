Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A9D50AC0D;
	Wed, 30 Sep 2026 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787988; cv=none; b=NVJvSCJ/+oV/urgU/syiCKuLlyKwRQSWltUXp8NkUBvGMp5v07CEJcq1ozDZEpaGTGYyx1cvWo9F3EItlp95KTgYjddknp1XtU/CvHyczeYBu7oZqK+4LVu3wQSaOxd4RIX4+ZyLMdeR7yOSJE99L/Yr35xqBkMybs1wbYUq0Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787988; c=relaxed/simple;
	bh=B4tErSwcaa7RC1bvrZJT/WXwfG/NahajxYZFLl/+w9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzmLikXbyTrX96Y5Gr25mAc3Xc3bG5jP0P99ILiNgirktystJt/XrLT2BRsZYbRosTn+8WPP4gJ2Yl3q5IOWERRVcjjjCrYK5q/MgwhrLKReTOiuiFqdkkAaw4RxsCQ+YpzZtD/gQVBle1C301yvc2JcmN3JO2mVcStZODWEldk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4LjyGLz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4LjyGLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF4A1F000FF;
	Wed, 30 Sep 2026 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787987;
	bh=d2e+lmLNmHHks3cOw6XO4jvF0ExoLOL5j8tGGqhjoKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4LjyGLzs2zUEINfYa7axR0E4aZvmhonqcM7EZDanP5r+ziF+UHp346mJnsv1L7G5
	 QWWS0MXGG2q2p233UcWy+15+/9D/Hf3TUGL/YwNq5TVv3sSc7ihbIxNGcxYh1nc8eC
	 SmbOmQp+nM6XiaslJXFJRzvnSafSR7vmAixSlgWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 397/457] sched_ext: Derive SCX_RQ_IN_WAKEUP from the core enqueue flags
Date: Wed, 30 Sep 2026 17:28:22 +0200
Message-ID: <20260930152354.561461839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit df5cdc2c832ca4e8a6d774596b9005558761a403 upstream.

schedule_deferred_locked() skips scheduling a deferred action while
SCX_RQ_IN_WAKEUP is set and relies on the task_woken_scx() call that follows
a wakeup enqueue to run it. enqueue_task_scx() sets the flag from the merged
enqueue flags, which include the flags stashed for a remote activation.
move_remote_task_to_local_dsq() thus sets SCX_RQ_IN_WAKEUP on the
destination rq when the moved task was woken up, although no
task_woken_scx() follows that activation.

An IMMED insert into a busy destination requests a local reenqueue during
that enqueue. The request gets linked but not scheduled and stays pending
until an unrelated wakeup or preemption on that CPU runs the deferred
actions. The IMMED task sits behind the running task in the meantime. If
nothing runs them before the scheduler is disabled, the request outlives the
scheduler and points into its freed per-cpu area, which the next scheduler
dereferences from run_deferred().

Test the core enqueue flags for the wakeup bit. Only the core's wakeup path
is followed by task_woken_scx().

Fixes: 57ccf5ccdc56 ("sched_ext: Fix enqueue_task_scx() truncation of upper enqueue flags")
Cc: stable@vger.kernel.org # v7.1+
Reported-by: Andrea Righi <arighi@nvidia.com>
Link: https://lore.kernel.org/all/20260916145807.3250167-1-arighi@nvidia.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -2037,7 +2037,12 @@ static void enqueue_task_scx(struct rq *
 	int sticky_cpu = p->scx.sticky_cpu;
 	u64 enq_flags = core_enq_flags | rq->scx.extra_enq_flags;
 
-	if (enq_flags & ENQUEUE_WAKEUP)
+	/*
+	 * SCX_RQ_IN_WAKEUP promises a task_woken_scx() call once this enqueue
+	 * returns. Only the core's wakeup path delivers one. The flags stashed
+	 * for a remote activation may carry the wakeup bit without it.
+	 */
+	if (core_enq_flags & ENQUEUE_WAKEUP)
 		rq->scx.flags |= SCX_RQ_IN_WAKEUP;
 
 	/*


