Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A764F4026;
	Tue, 13 Oct 2026 11:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892744; cv=none; b=d7XyOn+Vq1GerrfSvIL3oc1DE0mdwb39pLzYbZ0do53BkxRG8/VZ1YjKF8YkfJdptSjbV7Wc+dqqyr9xUzICGt/wCUVUGKHdBc13LXboCrLkX6d4RmPdDGqBxOF9EY0jwhQTZLYtUeaUbVvSUGg1gOdy2pMtKxuit3YnJcdXBvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892744; c=relaxed/simple;
	bh=m4UxjaMgTGrjtRSa76CCtkhK7I+yfELe4ZRUZE885Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKaiNHYXerufBpxxAK06gSLjpjrFZCFOC7nWWdQ4Lebw2zZ8+qqcFsWwq5Q/u2FEkbfuiOnHXJfDFQwiZlC8veYZtZY0zb93CRB1kfOi/XuwjIPLKn5ISRto3njxyHZkxQeb0fGyOYVu7suer1z/as20V7wa7SjVVxLWnJl8zFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G76TzO/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G76TzO/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3621F000FF;
	Tue, 13 Oct 2026 11:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892742;
	bh=FTWY1aJmDkLcZFIEt56+JL+FUvTAdGObTuEeOy/IFwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G76TzO/gYdqSkQh81nGCRIYcoD7ts49JzT0PcTf7/A0WrHlautiGWVUvdX8sJ/T3W
	 DV6CaVhRzu5cxchvRNlKtB43N9Ae48qEPxvpwDt5fUzpI5T2xZWMWI73VlgnLbzW1P
	 oV3bcs8v8JwCsk9jazTV9TZe4ECoy8ftqdmWHe64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Kuba Piecuch <jpiecuch@google.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 276/281] sched_ext: Call ops.dequeue() when a task arrives on a remote local DSQ
Date: Tue, 13 Oct 2026 13:39:52 +0200
Message-ID: <20261013112901.836733664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Kuba Piecuch <jpiecuch@google.com>

commit af701b8d3238b9eb7cd450b0491300452c700bf5 upstream.

When a task in the BPF scheduler's custody is moved to another CPU's
local DSQ, ops.dequeue() is only called once the task is picked for
execution, from set_next_task_scx() with SCX_DEQ_CORE_SCHED_EXEC, even
though no core-sched pick took place. It should instead be called
without flags when the task is inserted into the destination DSQ, as it
is for same-rq dispatches.

move_remote_task_to_local_dsq() sets p->scx.sticky_cpu across the
migration so that deactivate_task() on the source rq doesn't end custody.
Since commit b75aaea24c9f ("sched_ext: Properly mark SCX-internal
migrations via sticky_cpu"), enqueue_task_scx() only clears it after
inserting the task, so task_leave_custody() still sees the migration in
progress and skips the custody exit.

Clear p->scx.sticky_cpu as soon as enqueue_task_scx() has read it, as
was done before that commit. The source side is unaffected.

Fixes: ebf1ccff79c4 ("sched_ext: Fix ops.dequeue() semantics")
Cc: stable@vger.kernel.org # 7.1.x: 18d62044cda7: sched_ext: Preserve rq tracking across local DSQ dispatch
Cc: stable@vger.kernel.org # 7.1.x
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Assisted-by: Claude:claude-opus-5.5
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
(cherry picked from commit af701b8d3238b9eb7cd450b0491300452c700bf5)
[ jpiecuch: resolved context conflict, 7.2.y still names the function
  do_enqueue_task() rather than scx_do_enqueue_task() ]
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -2051,6 +2051,13 @@ static void enqueue_task_scx(struct rq *
 	u64 enq_flags = core_enq_flags | rq->scx.extra_enq_flags;
 
 	/*
+	 * An SCX-internal migration ends on arrival. Clear sticky_cpu so @p can
+	 * leave custody when inserted into the destination DSQ.
+	 */
+	if (sticky_cpu >= 0)
+		p->scx.sticky_cpu = -1;
+
+	/*
 	 * SCX_RQ_IN_WAKEUP promises a task_woken_scx() call once this enqueue
 	 * returns. Only the core's wakeup path delivers one. The flags stashed
 	 * for a remote activation may carry the wakeup bit without it.
@@ -2088,9 +2095,6 @@ static void enqueue_task_scx(struct rq *
 		dl_server_start(&rq->ext_server);
 
 	do_enqueue_task(rq, p, enq_flags, sticky_cpu);
-
-	if (sticky_cpu >= 0)
-		p->scx.sticky_cpu = -1;
 out:
 	rq->scx.flags &= ~SCX_RQ_IN_WAKEUP;
 


