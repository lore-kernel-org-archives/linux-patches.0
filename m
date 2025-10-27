Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312F632ABF6;
	Mon, 27 Oct 2025 19:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593092; cv=none; b=uEmx2QvMpCV2/GO5cG6S+kC5onMlrcqfpA51mu5hAHuZku54zp1tUpXohoFQkv3aJfvvk3leK5AarA7WEAoiPb6y72qSOK3PfVjP94tUwDuWY+XThILGDOWChlIQSWfzJKh1hD3wHUxg6osVczJjFjlw/uGR8IfzWmmykSjDWoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593092; c=relaxed/simple;
	bh=Ak3EeL3oRmeJY4w8QsiZoDqPdJ9xBxZ64rCSUQOCOLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJ4/3QSeY6Ob9RKYefMJRgAyOkz/5Gbw8YoopbaFdDRZAbYITfDvsEx7Ay4u8FYKSFmZCRtLuRacSWbsBiRBKV6GMszjEQPx+4yPe4Cc2B+R1dNpjl1o1a0bmy7ZfEIttp4yfadfXm++SRcpb9acqugXLrw27rI5T7lqGlPSHgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFpbWlXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFpbWlXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73753C113D0;
	Mon, 27 Oct 2025 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593089;
	bh=Ak3EeL3oRmeJY4w8QsiZoDqPdJ9xBxZ64rCSUQOCOLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFpbWlXVVW6JjH+F+1GT+zY7iuCm/qgsjZ4RJag6e8SZ/3/ZXf8gi29QKXRms3ouj
	 lpLpopCit8RIBaxA5zn9lqaG6Wob3HKlhuskp4P+dQL7KTjuyhZ1SGycnJ4B9rmS1+
	 0jjmLDoqa3xGp9A6+0TrCfRF3LfaHY4hqhv4QT0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <matt@readmodwrite.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.17 001/184] sched/fair: Block delayed tasks on throttled hierarchy during dequeue
Date: Mon, 27 Oct 2025 19:34:43 +0100
Message-ID: <20251027183514.979610064@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/sched/fair.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8ce56a8d507f..f0a4d9d7424d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6969,6 +6969,7 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 	int h_nr_runnable = 0;
 	struct cfs_rq *cfs_rq;
 	u64 slice = 0;
+	int ret = 0;
 
 	if (entity_is_task(se)) {
 		p = task_of(se);
@@ -6998,7 +6999,7 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 
 		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
-			return 0;
+			goto out;
 
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
@@ -7039,7 +7040,7 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 
 		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
-			return 0;
+			goto out;
 	}
 
 	sub_nr_running(rq, h_nr_queued);
@@ -7048,6 +7049,8 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 	if (unlikely(!was_sched_idle && sched_idle_rq(rq)))
 		rq->next_balance = jiffies;
 
+	ret = 1;
+out:
 	if (p && task_delayed) {
 		WARN_ON_ONCE(!task_sleep);
 		WARN_ON_ONCE(p->on_rq != 1);
@@ -7063,7 +7066,7 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 		__block_task(rq, p);
 	}
 
-	return 1;
+	return ret;
 }
 
 /*

base-commit: 6c7871823908a4330e145d635371582f76ce1407
-- 
2.34.1



