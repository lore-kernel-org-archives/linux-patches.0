Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DB234C9A7;
	Fri, 21 Nov 2025 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732238; cv=none; b=STE/LPvqW255Tg6F0kqaNeD1TSgDVlcVaxrIN7JwMq/gJmRzomTbwel0XIYRi6lcRc3VDgiiwP4XYD42dPJuNLMBnkg/rCP/xHzDi7WXR5TuBF9eHixPSApw8vGVd5Z7x4aN6RM9r7a621xNlqjBFxviPIUYqJdG4BUSg3ttF5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732238; c=relaxed/simple;
	bh=W6zl6cs3l6Z8Ced2xkvcMQOTKl+M7Z2yrCBw4KElxk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmwHeGVOXu0LUlZztKCh9cjB0EaLkGlgyT4dtWrYV3i217E/HCioCohQl8Opp+N0pqdAQVQZlSawSxgqCOvqACs5lV1iy1KZVDry3WcKLiRGzX9PnExrDs572cdt2CdWmBYUws+ClyoVa44fqJR4xKcXqCea53dTM4Y1qYEHjyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7RU2J/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7RU2J/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F592C4CEFB;
	Fri, 21 Nov 2025 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732238;
	bh=W6zl6cs3l6Z8Ced2xkvcMQOTKl+M7Z2yrCBw4KElxk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7RU2J/Gu0G5Vrt66WDvAAL7/WMyFOXddCq6vg0fN07PO7oKwL6WSkm2+eHiCC40E
	 q++T85IbenR1stBsKcB1U5rV500zFtwiFxVShQI68R31n2rN0Bbl2GgpZTihTybf7T
	 0x/iAYG7FIRtvYuRFIvzx5nA3+XXuBiaP6qBijaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ingo Molnar <mingo@kernel.org>,
	Hongyan Xia <hongyan.xia2@arm.com>,
	John Stultz <jstultz@google.com>
Subject: [PATCH 6.6 051/529] sched/pelt: Avoid underestimation of task utilization
Date: Fri, 21 Nov 2025 14:05:50 +0100
Message-ID: <20251121130232.828187990@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

commit 50181c0cff31281b9f1071575ffba8a102375ece upstream.

Lukasz Luba reported that a thread's util_est can significantly decrease as
a result of sharing the CPU with other threads.

The use case can be easily reproduced with a periodic task TA that runs 1ms
and sleeps 100us. When the task is alone on the CPU, its max utilization and
its util_est is around 888. If another similar task starts to run on the
same CPU, TA will have to share the CPU runtime and its maximum utilization
will decrease around half the CPU capacity (512) then TA's util_est will
follow this new maximum trend which is only the result of sharing the CPU
with others tasks.

Such situation can be detected with runnable_avg wich is close or
equal to util_avg when TA is alone, but increases above util_avg when TA
shares the CPU with other threads and wait on the runqueue.

[ We prefer an util_est that overestimate rather than under estimate
  because in 1st case we will not provide enough performance to the
  task which will remain under-provisioned, whereas in the other case we
  will create some idle time which will enable to reduce contention and
  as a result reduces the util_est so the overestimate will be transient
  whereas the underestimate will remain. ]

[ mingo: Refined the changelog, added comments from the LKML discussion. ]

Reported-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/lkml/CAKfTPtDd-HhF-YiNTtL9i5k0PfJbF819Yxu4YquzfXgwi7voyw@mail.gmail.com/#t
Link: https://lore.kernel.org/r/20231122140119.472110-1-vincent.guittot@linaro.org
Cc: Hongyan Xia <hongyan.xia2@arm.com>
Cc: John Stultz <jstultz@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4836,6 +4836,11 @@ static inline unsigned long task_util(st
 	return READ_ONCE(p->se.avg.util_avg);
 }
 
+static inline unsigned long task_runnable(struct task_struct *p)
+{
+	return READ_ONCE(p->se.avg.runnable_avg);
+}
+
 static inline unsigned long _task_util_est(struct task_struct *p)
 {
 	struct util_est ue = READ_ONCE(p->se.avg.util_est);
@@ -4955,6 +4960,14 @@ static inline void util_est_update(struc
 		return;
 
 	/*
+	 * To avoid underestimate of task utilization, skip updates of EWMA if
+	 * we cannot grant that thread got all CPU time it wanted.
+	 */
+	if ((ue.enqueued + UTIL_EST_MARGIN) < task_runnable(p))
+		goto done;
+
+
+	/*
 	 * Update Task's estimated utilization
 	 *
 	 * When *p completes an activation we can consolidate another sample


