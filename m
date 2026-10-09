Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9074C9DEE;
	Fri,  9 Oct 2026 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555488; cv=none; b=KZ1e0QsU7UNlQxxBavFdE65/1dIV6LXJA8E1gK+2Mt7O5B16mgKyJzQPCHOl10hnMubkcHr9FKGEzOZp5+O7dICn2tZ+NXSxHYdZsqWqZZDgdSEn7ST5zRrjM4/We+TI7/dIzgfh0oaZY7oHuMmFH5qxbYuc457kNjjnL6Ic/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555488; c=relaxed/simple;
	bh=ZjvDzX2TuWeaUYq+sVl7GjVSIQ1v1FLPqtFPZsI25f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTjGHvMFmlsYNv2b2KUHGrh93WRRFzABQ0vvbYt3kcWVuhGN+NRZgn9UAyBrfpJhG7+6WjUs1M/RMGqWOex2GYnN6DiAEcbNCvIFX/NeI9pPJFahReWUgcv30KdliGqXpzEEZ6IZxM7QHuxUSpJUx5BnqzVfwa/mhGx7JAbt6Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOk/qPfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOk/qPfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68DA1F00898;
	Fri,  9 Oct 2026 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555485;
	bh=jP5ld3h2BgZ9cIik80PmSFHpj1wpME4bnNSMz6l1ZWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOk/qPfXVcEUIXJ9Iz0fiHGmlh0C2ttYJu+llHHivyq7x0ciWCaWqpuretQ8u0Ssn
	 XcyEOZrw6T9plOVmjqYK/YUtX+NXjmj2lcNYmogW1wcjYwsAANB1aUT0GyTI217the
	 PSZk6gPxIrHuCHII/XMPRWcigxaWvSfcR/tP2968=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 013/428] sched_ext: Wait for SCX_OPSS_DISPATCHING before reenqueueing a task
Date: Fri,  9 Oct 2026 16:05:50 +0200
Message-ID: <20261009140946.339028698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

[ Upstream commit 7de9a6fb44eae4f05e68c805d58b9c618815adfa ]

ebf1ccff79c4 ("sched_ext: Fix ops.dequeue() semantics") moved the final
ops_state store in scx_dispatch_enqueue() after the DSQ unlock so that the
custody update and ops.dequeue() precede it. A task can thus be found on a
DSQ while still SCX_OPSS_DISPATCHING.

The dequeue and core-sched pick paths wait for the state to clear in
ops_dequeue() but the reenqueue paths don't. A reenqueue in that window runs
ops.enqueue() and sets SCX_OPSS_QUEUED before the dispatch has completed.
The dispatcher's final store then overwrites it with SCX_OPSS_NONE and
finish_dispatch() drops every later dispatch of the task.

Wait for SCX_OPSS_DISPATCHING to clear before dequeueing a task for
reenqueue, the same way ops_dequeue() does.

Fixes: ebf1ccff79c4 ("sched_ext: Fix ops.dequeue() semantics")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
[ inlined scx_reenq_wait_dispatching() into the existing reenqueue functions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 476a584d0d4da..cd7cbd1c99a26 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -4294,6 +4294,14 @@ static u32 reenq_local(struct scx_sched *sch, struct rq *rq, u64 reenq_flags)
 		if (!local_task_should_reenq(p, &reenq_flags, &reason))
 			continue;
 
+		/*
+		 * The dispatcher stores the final ops_state after dropping the DSQ
+		 * lock, so @p can be found on a DSQ while still
+		 * %SCX_OPSS_DISPATCHING. Reenqueueing @p before that store lands
+		 * would have it clobber the new %SCX_OPSS_QUEUED.
+		 */
+		if (unlikely(atomic_long_read_acquire(&p->scx.ops_state) == SCX_OPSS_DISPATCHING))
+			wait_ops_state(p, SCX_OPSS_DISPATCHING);
 		dispatch_dequeue(rq, p);
 
 		if (WARN_ON_ONCE(p->scx.flags & SCX_TASK_REENQ_REASON_MASK))
@@ -4416,6 +4424,8 @@ static void reenq_user(struct rq *rq, struct scx_dispatch_q *dsq, u64 reenq_flag
 		}
 
 		/* @p is on @dsq, its rq and @dsq are locked */
+		if (unlikely(atomic_long_read_acquire(&p->scx.ops_state) == SCX_OPSS_DISPATCHING))
+			wait_ops_state(p, SCX_OPSS_DISPATCHING);
 		dispatch_dequeue_locked(p, dsq);
 		raw_spin_unlock(&dsq->lock);
 
-- 
2.53.0



