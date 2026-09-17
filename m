Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F1D4B44D0;
	Thu, 17 Sep 2026 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659300; cv=none; b=eyc5xLgakTev+BIrcH31LS25Wm6vmzgnc5wqEl7CFDDuAGzC4kml/p9+ROC0WJdoZnClNlyxsnjWGxh99Sf9PR3w+ScETzpOsQvVGmzPcotCDHgcs7QWb6Rv3ZLGy6RZF5/YMcgQ0Nafo5F9Coh7yU65/1+uDX/ep0Jx54tMZpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659300; c=relaxed/simple;
	bh=Eqeu3+YugKY207xFGnWxp9Y94l3C05MYAELkcmiJfgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g00Q6maiapJk/MxuQjmVeDEkCs4ilLnnErrQvwN8P1fTm3hdRIUhvFtTaXxBz0U8Lt3lk/93I1Qd/+9CnpVtoRzTy0cB8hdUJTPbc5u/ezSI5FuPbKb2nOuQyvwcXEZSrgUwOA/cVTst8aHjw4UzFZ6R0UYBjI1oTa77PAONxq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLV9sji6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLV9sji6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D800B1F000FF;
	Thu, 17 Sep 2026 15:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659294;
	bh=Cqg/925vx6G+bHocNaqDzY/mCOLtl7TodVJdemUu2kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLV9sji6JIsYzgYh6QGUabK8R3Ij/+z3tBMXkTnxK+3OyLi7uNye56jeU9I9InIvc
	 Gqq0WNNevP4wIB0odXgIJTHGLFdMIpXUvcZhL/GliBR6YJJXSPkWRTZmRQnl2/bh3W
	 1tP3dAlxr+LSUmxdQeU3KHc7PT9iwOrEtHeF2WJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Shubhang Kaushik (Ampere)" <sh@gentwo.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 170/733] sched/core: Skip rq->avg_idle update without a valid idle_stamp
Date: Thu, 17 Sep 2026 16:07:58 +0100
Message-ID: <20260917151355.337887258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Shubhang Kaushik (Ampere) <sh@gentwo.org>

[ Upstream commit c6dcd97c8be75f052a1ca52cf79b03e7292962f1 ]

Commit 4b603f1551a73 ("sched: Update rq->avg_idle when a task is moved
to an idle CPU") moved rq->avg_idle accounting out of the wakeup path and
into put_prev_task_idle(), so that the idle interval is consumed whenever
the idle task is switched out.

The wakeup-side accounting that it replaced only updated rq->avg_idle
when rq->idle_stamp was non-zero. The new helper lost that validity
check and unconditionally computes:

	rq_clock(rq) - rq->idle_stamp

If rq->idle_stamp is zero, this uses rq_clock(rq) as the sample. That is
not a valid idle duration and can immediately drive rq->avg_idle to its
clamp.

This can happen when sched_balance_newidle() returns before setting
rq->idle_stamp, for example when this_rq->ttwu_pending is set. In that
case the rq can switch to the idle task with idle_stamp still zero and
leave idle again when the pending wakeup is processed.

Other paths can also switch to the idle task without setting
rq->idle_stamp via newidle_balance(), for example find_proxy_task() or
force-idling.

Restore the idle_stamp validity check in update_rq_avg_idle() and skip
the rq->avg_idle update when there is no measured idle interval.

Fixes: 4b603f1551a73 ("sched: Update rq->avg_idle when a task is moved to an idle CPU")
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260807-master-v3-1-c328354efed3@gentwo.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 87caa1290fad6..d0992ecda4c72 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3743,11 +3743,17 @@ static inline void ttwu_do_wakeup(struct task_struct *p)
 
 void update_rq_avg_idle(struct rq *rq)
 {
-	u64 delta = rq_clock(rq) - rq->idle_stamp;
-	u64 max = 2*rq->max_idle_balance_cost;
+	u64 idle_stamp = rq->idle_stamp;
+	u64 delta, max;
+
+	if (!idle_stamp)
+		return;
+
+	delta = rq_clock(rq) - idle_stamp;
 
 	update_avg(&rq->avg_idle, delta);
 
+	max = 2 * rq->max_idle_balance_cost;
 	if (rq->avg_idle > max)
 		rq->avg_idle = max;
 	rq->idle_stamp = 0;
-- 
2.53.0



