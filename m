Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603D33D9044;
	Wed,  8 Apr 2026 18:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673552; cv=none; b=CrbP12zxbKLpAd/SIBCBdC7Hv/lveevUVJRfWZKSpb92aBvp+2GeXQk5bidmo4yePQj39ZLQ1XK/LWa+PWH0j6IFkBS4QLcF8CKAJ8Q6oDRpxcYG5LF9Zz5PRuLPWXVGRvi0pM9MEd0AxaM6djQ1Y3e4m3fFl7ls984klHLOHUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673552; c=relaxed/simple;
	bh=A9qYQjsXwsfwEHsM4pVdUDs7Eim7Hk/fcmqIMzQkYJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFtJC8qLqXJxglj0p3YDduWMsH2zpFJTLngxKZmC9LE1Ho0FiT3QoCzOJu8FWAvzv8OGinhfeyMf3N2F9A+TkEvAHqhJ24CPnGd/MZma1rHtXtySz7dByfGRwNj89QVyKK/llwXSSIq+0XM00I7us54Q8QvcU7aWH/PNgv/3vlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhGYlVfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhGYlVfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC498C2BC87;
	Wed,  8 Apr 2026 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673552;
	bh=A9qYQjsXwsfwEHsM4pVdUDs7Eim7Hk/fcmqIMzQkYJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhGYlVfCtv6cAuh0Gd1GRis9udxD7V0BC0jYUIwnChf4z2ScotdMZ4ncsxcPflGgm
	 DmSWVIQ4pQzJCz3dOOzIC26iKMRkcad9Yp7+oDaNfM7w/kO+WwBD9VpDQ8sMKezHG4
	 QcmWlpIjIiqLoHcOJQ98XVXegdR5GF6nMesHLTAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 276/277] sched_ext: Refactor do_enqueue_task() local and global DSQ paths
Date: Wed,  8 Apr 2026 20:04:21 +0200
Message-ID: <20260408175944.174648788@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 3546119f18647d7ddbba579737d8a222b430cb1c ]

The local and global DSQ enqueue paths in do_enqueue_task() share the same
slice refill logic. Factor out the common code into a shared enqueue label.
This makes adding new enqueue cases easier. No functional changes.

Reviewed-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 7e0ffb72de8a ("sched_ext: Fix stale direct dispatch state in ddsp_dsq_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1243,6 +1243,7 @@ static void do_enqueue_task(struct rq *r
 {
 	struct scx_sched *sch = scx_root;
 	struct task_struct **ddsp_taskp;
+	struct scx_dispatch_q *dsq;
 	unsigned long qseq;
 
 	WARN_ON_ONCE(!(p->scx.flags & SCX_TASK_QUEUED));
@@ -1310,8 +1311,17 @@ static void do_enqueue_task(struct rq *r
 direct:
 	direct_dispatch(sch, p, enq_flags);
 	return;
-
+local_norefill:
+	dispatch_enqueue(sch, &rq->scx.local_dsq, p, enq_flags);
+	return;
 local:
+	dsq = &rq->scx.local_dsq;
+	goto enqueue;
+global:
+	dsq = find_global_dsq(sch, p);
+	goto enqueue;
+
+enqueue:
 	/*
 	 * For task-ordering, slice refill must be treated as implying the end
 	 * of the current slice. Otherwise, the longer @p stays on the CPU, the
@@ -1319,14 +1329,7 @@ local:
 	 */
 	touch_core_sched(rq, p);
 	refill_task_slice_dfl(sch, p);
-local_norefill:
-	dispatch_enqueue(sch, &rq->scx.local_dsq, p, enq_flags);
-	return;
-
-global:
-	touch_core_sched(rq, p);	/* see the comment in local: */
-	refill_task_slice_dfl(sch, p);
-	dispatch_enqueue(sch, find_global_dsq(sch, p), p, enq_flags);
+	dispatch_enqueue(sch, dsq, p, enq_flags);
 }
 
 static bool task_runnable(const struct task_struct *p)


