Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE622DFA7;
	Tue, 26 Aug 2025 13:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215525; cv=none; b=Ww/9i3/Svguv0gMpCqDuY4Z7H1gTSJ+jo0rrh70MU5hxHCBZQOlBBUyc9hsT3qkSHvfTy6pBdTChnz7Fu9pH2hUhBYw5X/+5gs94p0UojrjmSOLhVO+AM19gl+L9IgnsynuX/LojJE+ZmVcwPZxCUgbhztRUvI6A+8EXyEkeoNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215525; c=relaxed/simple;
	bh=4w6i0IV2r2qRlIkkLLdIQkK0gdmDaoUPEx7nPohOQQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vv8BDvbBSqfiVDgDqBaLiqNAIeJsyDnMTIy6VWFVG4f0+bd7k52KQ/w5doGSUcUHwvKsV1USwwP2R+FO0mlBQ5I+SNd8qgT3abENJz7vnz0Gv45QMRpxcFl3ek67HIdzIGlmRMb/YQ0pCM5f5BH18oHu8s2dP8YgBdPcDcV+W/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjirgJY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjirgJY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886E9C4CEF1;
	Tue, 26 Aug 2025 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215524;
	bh=4w6i0IV2r2qRlIkkLLdIQkK0gdmDaoUPEx7nPohOQQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjirgJY8smxGIs5y+8gOMOz6xfihpqTt0A7vf03hA8MBAieqlUWiMcSI6liZ/msbQ
	 3EskYAah/7dVkOoZ90oy6UGLriR8zRv/C0/3YOaT4CKuvFoNVKrqRMDBhRb1CMSM1O
	 WY+80IMxGTLVqLGEEac+IC0O9o583//G0EpZQziE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 059/644] sched: Change nr_uninterruptible type to unsigned long
Date: Tue, 26 Aug 2025 13:02:30 +0200
Message-ID: <20250826110947.965320144@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -81,7 +81,7 @@ long calc_load_fold_active(struct rq *th
 	long nr_active, delta = 0;
 
 	nr_active = this_rq->nr_running - adjust;
-	nr_active += (int)this_rq->nr_uninterruptible;
+	nr_active += (long)this_rq->nr_uninterruptible;
 
 	if (nr_active != this_rq->calc_load_active) {
 		delta = nr_active - this_rq->calc_load_active;
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -971,7 +971,7 @@ struct rq {
 	 * one CPU and if it got migrated afterwards it may decrease
 	 * it on another CPU. Always updated under the runqueue lock:
 	 */
-	unsigned int		nr_uninterruptible;
+	unsigned long 		nr_uninterruptible;
 
 	struct task_struct __rcu	*curr;
 	struct task_struct	*idle;


