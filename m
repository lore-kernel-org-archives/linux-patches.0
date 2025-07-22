Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403692EBDCB;
	Tue, 22 Jul 2025 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193684; cv=none; b=Y1+AvCJEt8Kg1AqIc1ywNtfRMfo7gMf/tLXWLi/S3Rl2Qg0GZdPHp6FvZBy63uDPe7wagRhKWjKghzGlSKDXdL7oKmLWIVOafOy+fEGlQjILrKL+P+ZjyAyzrdQ2k8zvCsZ5qUlKzFIhSGKJQRPalWWZcyCJfwSDRY9KpVyphC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193684; c=relaxed/simple;
	bh=Y7Uh8X3/6O7+UBAT4/RPeoltPQ6p0P98pqLWrD8ZKe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ager9ePIootrCNm4kl1dK2B2PP51qMvDq4avJQh7gcAjGBIZgm/YxNVJmilplm+U3z0zeJORkZXDUy9afOtnVlPjQQWhD7gcLfaBnqgSZK92YZw9W71tH5jf+618AqiHj3CTPHBsJf5s2zJ/ikbkQ+iNGawhTPbX2KCbOrsTWyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HX998JG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HX998JG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEA0C4CEEB;
	Tue, 22 Jul 2025 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193684;
	bh=Y7Uh8X3/6O7+UBAT4/RPeoltPQ6p0P98pqLWrD8ZKe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HX998JG/n4Lxd79pOMjto/O+clJYLF9c3+QqbaBslY4D3ltAPPbnYJPKXwaS2Emt8
	 Xoawd93aAlZ3LfUPi+je+0gQ48N+FCyuK7ZOXDwqCzUiTqtRCgl8e4TctFYN0AFfSe
	 Yj94oW0xoPDh1LhC7PMC/r4DxUwmJHzhyK1o7DrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.15 166/187] sched: Change nr_uninterruptible type to unsigned long
Date: Tue, 22 Jul 2025 15:45:36 +0200
Message-ID: <20250722134351.955582392@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1147,7 +1147,7 @@ struct rq {
 	 * one CPU and if it got migrated afterwards it may decrease
 	 * it on another CPU. Always updated under the runqueue lock:
 	 */
-	unsigned int		nr_uninterruptible;
+	unsigned long 		nr_uninterruptible;
 
 	union {
 		struct task_struct __rcu *donor; /* Scheduler context */


