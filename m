Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B04F4D0CED;
	Fri,  9 Oct 2026 14:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555463; cv=none; b=IbP70YPQec8eh45YHYw1xhIKgkztZsiR3z0rxtxudM/bu45Fq+TnNlRL5rh2+68uwoX0BJ8VybVlC1RqUgc1TwROkYjwFuWOy++jeYb0gbjpyK5pG5eOGzUmyl6I3YzsAWgGJigDupsWj/mlQnCVd/yMJsNq590VkoPojiI1yxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555463; c=relaxed/simple;
	bh=gGSshWksxcnSWnmEzSxmUSaVH7rKf131/XIsQcBE1iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDmdgicbKAwptynWO7VYgRtB/WIsQ2yhzIh3JH43RaehiGH9loKRdC9WyBuStubrAcGpnCt2v5kZcpAWw0OM60NIiegCRljV9ccpAaEg4MKu0je+n6+Kuwdaxafpp3pC6INZS8G87DsVLyuYoOoAEWSrpcI6NnrIVZVgML9ikNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGTUfBCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGTUfBCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33C61F000FF;
	Fri,  9 Oct 2026 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555460;
	bh=LYV8XuAQJEA1p36K5mWohrt4F3ZB4Se0EujPFlMmTEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGTUfBCPhpcJpc94P0HtI1Eq5/P934WgzHjx3XJFjJkpTfI/h8wTzQ5etWrC75ayW
	 MU6al5MaIl0R6y4POE2IG8tGeGXodi0D0EeFy6Pn5a9Q5PifBsbHKeVswpy7qLaO70
	 wSpl89hOo9Bxvcp5ps3T7UlqSALRVUa33OOUGevg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.2 009/428] sched/cache: Skip kernel threads for cache aware scheduling to rubustify the code
Date: Fri,  9 Oct 2026 16:05:46 +0200
Message-ID: <20261009140946.241439939@linuxfoundation.org>
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

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit 65efcccddc83d6a19e8a2e2a6117811e39e589bf ]

Kernel thread should not be covered by cache aware scheduling as
it borrows the statistics from the user space thread. Filter the
kernel thread in account_mm_sched().

In theory a kernel thread does not have any valid
cache group, so !grp should gate the kernel thread.
Add the PF_KTHREAD check explicitly here for safety
reasons, to guard against future modifications and
to pair with task_tick_cache().

Fixes: df0d98475954 ("sched/cache: Introduce infrastructure for cache-aware load balancing")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@kernel.org> # 7.2.x
Link: https://patch.msgid.link/058f0c6ea7b991c177a17de347fa3157f25489a7.1790035273.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b8d9c6c63dbe..b6cace1d0e322 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1868,8 +1868,14 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	/*
 	 * init_task, kthreads and user thread created
 	 * by user_mode_thread() don't have a cache group.
-	 */
-	if (!grp || !grp->pcpu_sched)
+	 * In theory a kernel thread does not have any valid
+	 * cache group, because sched_cache_fork() is not
+	 * invoked for a kernel thread - !grp should gate the
+	 * kernel thread. Use the PF_KTHREAD check explicitly
+	 * here for safety reasons, to guard against future
+	 * modifications and to pair with task_tick_cache().
+	 */
+	if (p->flags & PF_KTHREAD || !grp || !grp->pcpu_sched)
 		return;
 
 	pcpu_sched = per_cpu_ptr(grp->pcpu_sched, cpu_of(rq));
-- 
2.53.0



