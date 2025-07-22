Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1886B2B9A5;
	Tue, 22 Jul 2025 13:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192532; cv=none; b=TMTW4ZofihRRAsrUhQrYEC63DNyS0dvKHOck2FoMXSsw7mCdLrtxRrFYfdUjyJBQApY3URCU7I0/Cl1OyHQwmPNspqoLZsxiLtbe9+PleX4LtueE9t0/HaqNEhh9L0/yVgkB4oQRrZqLbvzByJE8UtgJ9HgSFyFKkCspvdx0Cj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192532; c=relaxed/simple;
	bh=7PLJ/71VOH4HdcfaGpQSiDdc+3PLbCDFVh7aWM4yqCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJpMBXj7VqEw/6SuZBzS6lQQSove1GYJWQ6PwU0mzTKjfMRE3/yd39t7yBOf2W7vWDmR7JF8YG4C9vYwcdALjirjShS1n0SbURt7JPC8dvE6wXvk4tXqrK6YlbtaPgejE21l0Qk/TYfxew3UNJ6lTPEIXrePTVZfWIsmginA97s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6yOu7B2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6yOu7B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40290C4CEEB;
	Tue, 22 Jul 2025 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192531;
	bh=7PLJ/71VOH4HdcfaGpQSiDdc+3PLbCDFVh7aWM4yqCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6yOu7B2mJYRf+7NYm1yvnhCryOd/+PyYrrIvUnu1HosY5CsoKq65Ieg8dPbh6gXA
	 wIpXGHbgXNpHYdvly807VKnuh5rONEcs+GzHCOz3i/9ggfiO2itOOimTtFhCBysoEM
	 7+Q8wamYr6W+S8PhOhY2Kq90EBav7avJF6g0lqiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 093/111] sched: Change nr_uninterruptible type to unsigned long
Date: Tue, 22 Jul 2025 15:45:08 +0200
Message-ID: <20250722134336.886220260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>

commit 36569780b0d64de283f9d6c2195fd1a43e221ee8 upstream.

The commit e6fe3f422be1 ("sched: Make multiple runqueue task counters
32-bit") changed nr_uninterruptible to an unsigned int. But the
nr_uninterruptible values for each of the CPU runqueues can grow to
large numbers, sometimes exceeding INT_MAX. This is valid, if, over
time, a large number of tasks are migrated off of one CPU after going
into an uninterruptible state. Only the sum of all nr_interruptible
values across all CPUs yields the correct result, as explained in a
comment in kernel/sched/loadavg.c.

Change the type of nr_uninterruptible back to unsigned long to prevent
overflows, and thus the miscalculation of load average.

Fixes: e6fe3f422be1 ("sched: Make multiple runqueue task counters 32-bit")

Signed-off-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250709173328.606794-1-aruna.ramakrishna@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/loadavg.c |    2 +-
 kernel/sched/sched.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched/loadavg.c
+++ b/kernel/sched/loadavg.c
@@ -80,7 +80,7 @@ long calc_load_fold_active(struct rq *th
 	long nr_active, delta = 0;
 
 	nr_active = this_rq->nr_running - adjust;
-	nr_active += (int)this_rq->nr_uninterruptible;
+	nr_active += (long)this_rq->nr_uninterruptible;
 
 	if (nr_active != this_rq->calc_load_active) {
 		delta = nr_active - this_rq->calc_load_active;
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1011,7 +1011,7 @@ struct rq {
 	 * one CPU and if it got migrated afterwards it may decrease
 	 * it on another CPU. Always updated under the runqueue lock:
 	 */
-	unsigned int		nr_uninterruptible;
+	unsigned long 		nr_uninterruptible;
 
 	struct task_struct __rcu	*curr;
 	struct task_struct	*idle;


