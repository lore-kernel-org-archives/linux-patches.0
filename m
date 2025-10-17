Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE863208;
	Fri, 17 Oct 2025 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714811; cv=none; b=P5HjeTZ3sdIT03+s4KubAf6vgcSA2WfxhAfhwO1LYYkAa8cEjpfn+0e2Ojs1YRUVe3cQTSGZqPsUjSTgCdYYqDd+zkDgJOPWHmmbccavZle31kqrgPw4+njnzzv6sQnNJspZzfe0m3+V1Jyz69E/b6oWNuMW5Vv7i839qKrYz5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714811; c=relaxed/simple;
	bh=wehrLgD8sP54/zBNoz7FHq47fIOfp8ZhH8gY7QvWX3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUiepeh0tiDMTbDnNrxKQB2sz6vTHjPPLKfxchYimi/XDmVGhZa1i8vh/9YiF1HxAuPy1Czx7iB7QxdhPmScim9uLaNdQmEzLYMn4E42cytKC3f7KGxzI/YiKsE8mPBJcjRFEZ8unSx/nKyr8H8xvRkCgKJDsAUn3/Z1znowxOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0vYVcAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0vYVcAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F7BC4CEFE;
	Fri, 17 Oct 2025 15:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714811;
	bh=wehrLgD8sP54/zBNoz7FHq47fIOfp8ZhH8gY7QvWX3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0vYVcAlAASIGBHBF5Rhhe1dnfa272AdCA4ipEz4zQv88Y1A4BSx+vxLHOE95t/z8
	 HY3WJgNsXdsLUMtI9SDG+E/bVtwvwTjPYjVtxnB/affNXrMts89INS8Brv3jP4HNie
	 GL7M5eW0u94o2HhUffl5nnnGD78fi60IjHA/Pe8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <matt@readmodwrite.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.12 273/277] sched/fair: Block delayed tasks on throttled hierarchy during dequeue
Date: Fri, 17 Oct 2025 16:54:40 +0200
Message-ID: <20251017145157.126995883@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

Dequeuing a fair task on a throttled hierarchy returns early on
encountering a throttled cfs_rq since the throttle path has already
dequeued the hierarchy above and has adjusted the h_nr_* accounting till
the root cfs_rq.

dequeue_entities() crucially misses calling __block_task() for delayed
tasks being dequeued on the throttled hierarchies, but this was mostly
harmless until commit b7ca5743a260 ("sched/core: Tweak
wait_task_inactive() to force dequeue sched_delayed tasks") since all
existing cases would re-enqueue the task if task_on_rq_queued() returned
true and the task would eventually be blocked at pick after the
hierarchy was unthrottled.

wait_task_inactive() is special as it expects the delayed task on
throttled hierarchy to reach the blocked state on dequeue but since
__block_task() is never called, task_on_rq_queued() continues to return
true. Furthermore, since the task is now off the hierarchy, the pick
never reaches it to fully block the task even after unthrottle leading
to wait_task_inactive() looping endlessly.

Remedy this by calling __block_task() if a delayed task is being
dequeued on a throttled hierarchy.

This fix is only required for stabled kernels implementing delay dequeue
(>= v6.12) before v6.18 since upstream commit e1fad12dcb66 ("sched/fair:
Switch to task based throttle model") indirectly fixes this by removing
the early return conditions in dequeue_entities() as part of the per-task
throttle feature.

Cc: stable@vger.kernel.org
Reported-by: Matt Fleming <matt@readmodwrite.com>
Closes: https://lore.kernel.org/all/20250925133310.1843863-1-matt@readmodwrite.com/
Fixes: b7ca5743a260 ("sched/core: Tweak wait_task_inactive() to force dequeue sched_delayed tasks")
Tested-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7187,6 +7187,7 @@ static int dequeue_entities(struct rq *r
 	int h_nr_delayed = 0;
 	struct cfs_rq *cfs_rq;
 	u64 slice = 0;
+	int ret = 0;
 
 	if (entity_is_task(se)) {
 		p = task_of(se);
@@ -7218,7 +7219,7 @@ static int dequeue_entities(struct rq *r
 
 		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
-			return 0;
+			goto out;
 
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
@@ -7261,7 +7262,7 @@ static int dequeue_entities(struct rq *r
 
 		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
-			return 0;
+			goto out;
 	}
 
 	sub_nr_running(rq, h_nr_queued);
@@ -7273,6 +7274,8 @@ static int dequeue_entities(struct rq *r
 	if (unlikely(!was_sched_idle && sched_idle_rq(rq)))
 		rq->next_balance = jiffies;
 
+	ret = 1;
+out:
 	if (p && task_delayed) {
 		SCHED_WARN_ON(!task_sleep);
 		SCHED_WARN_ON(p->on_rq != 1);
@@ -7288,7 +7291,7 @@ static int dequeue_entities(struct rq *r
 		__block_task(rq, p);
 	}
 
-	return 1;
+	return ret;
 }
 
 /*


