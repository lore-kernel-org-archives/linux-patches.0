Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851AD51CF6E;
	Wed, 30 Sep 2026 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793822; cv=none; b=JEZZ5We+nFwN97urttIxlorbgNaZy0aUZooNpRPqDnKzTxQvSzMDwyXF4ISa0/XRinzJf3ds5cMh3khbI+8G/5xrB1+45f+hc8urjERmRa92emZgyDPXJThcLabUosd+90sPzJte/yPTkRx7vBSKfdu0Pt8Iq56lnaSPDD+VukY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793822; c=relaxed/simple;
	bh=kZ3iBR6n+f8D9buwOzZ+fPonTpOOAJxMs1+Rkp3nz4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEhYJV10BMa++AFfmKMYYZtiUYHQTdO0nBztDg9TbEcte7a25COpYYdbDBCW8DOjC7HgDETZQ5xxV3AHVEGBM2nzc5lHRe5Dn/lHrG54N75q7XjilQZ8NyDR4Vq6wp3H8brQQM/KYdQ/OaexXOEVtfpiEF1WIdlue/jD1vyQIuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGik3obF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGik3obF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BAC1F000FF;
	Wed, 30 Sep 2026 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793821;
	bh=7mjumrNQRxt9/hrh/R3Ev8OtYptCV6QlPaoekcmpQeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGik3obF7wt4dLdAYIiYUk7ketyIGjYIPmUEbOplwK2X4d7Nd17CSjW5XUmDWBJZS
	 N+1SYTSoAHtSjKSVE3uf7DHVNT0crpGd/9trRbaof+Hn5/AIF9D/BEys+wZ1qjXOVC
	 RXL4NWMOGzOks5AS+W0if8iw0iWpmYbTmJL8m4Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/395] sched_ext: Derive SCX_RQ_IN_WAKEUP from the core enqueue flags
Date: Wed, 30 Sep 2026 17:30:52 +0200
Message-ID: <20260930152349.164627586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit df5cdc2c832ca4e8a6d774596b9005558761a403 ]

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
[ Retargeted the patch to kernel/sched/ext.c with its older extra_enq_flags context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1382,7 +1382,12 @@ static void enqueue_task_scx(struct rq *
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
 
 	if (sticky_cpu >= 0)


