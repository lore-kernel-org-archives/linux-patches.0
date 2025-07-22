Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338A97BAEC;
	Tue, 22 Jul 2025 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192175; cv=none; b=ZCrQlcml/HXkK/uAyizoH7WE7JOJr+ty1EIJ5UNxtewILiccCVannDeFQeZNxIw4sIYPHfzDttqFai1WIWjvugy58VTPXbNLjhXC3O0SvQboQpdk8VwNDI6j6BfUVh3dI2vTeCZfNeTXYgBAoVIzj63DN65EbkXlxoQmR/xNPWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192175; c=relaxed/simple;
	bh=nQ4kMvPGRivjdfAgT33LZqvhVZU3Mu0+kA30dHN12h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkvUxkPkqZsLV6ZP+5BxApL+uJNm/am48gS9s+S+SpQZVQItXokE6oOs86ttRSbWZtyCy/UTzQanaKHMHDua4CdSR65dh8WOQhqhvzzO4kD4bTsZ1+VtUfg6axakE4pBjGwDgxsumIMwR68Wkmuif3Zb10s56YFcvR9RT4aP6Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAzECyCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAzECyCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9667AC4CEF5;
	Tue, 22 Jul 2025 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192175;
	bh=nQ4kMvPGRivjdfAgT33LZqvhVZU3Mu0+kA30dHN12h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAzECyCgVJt8szmJKM4QKsXaqVcS9Ypm/1nv39kj+H+lrm94A0UsnxZu9BpbsrEFt
	 e11QiMpYGI5JPrvLA5jfpnBlHuj2Rddyj3qj2xiZu+A6G7RoCDnttsPuwJtLGUrnJo
	 LxsC2VkL2OzY8Xi/fb8uc5AQ8Zv/zjj7FO0eMhbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 66/79] sched: Change nr_uninterruptible type to unsigned long
Date: Tue, 22 Jul 2025 15:45:02 +0200
Message-ID: <20250722134330.796407838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1003,7 +1003,7 @@ struct rq {
 	 * one CPU and if it got migrated afterwards it may decrease
 	 * it on another CPU. Always updated under the runqueue lock:
 	 */
-	unsigned int		nr_uninterruptible;
+	unsigned long 		nr_uninterruptible;
 
 	struct task_struct __rcu	*curr;
 	struct task_struct	*idle;


