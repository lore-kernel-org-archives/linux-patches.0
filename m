Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9E72C9A;
	Tue, 22 Jul 2025 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193119; cv=none; b=PgB8Me5hR7yHQcpC28E2NvX9cB4ZJD1qQp2+FxwEH2E55c43OCDt/O95t4iMxQ9KxGG/S75H6oYb3xT1v/osIYSCWx5GCy5cjVeB3YKBuTBQG3FUYkkzBGVX6iAMyVsKdEvxzLbzCXHWXBueSkM0SaubKYjMWyYjZbqXnM2/ZHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193119; c=relaxed/simple;
	bh=xvcux7fOw99zzWHLKmIyY0DfopVQhPHuWM5hB76zzMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibCaGtzmh1qnA9qzueudaOpFQVW4tnQMdQ8TUHpJwWOrA3XpUfqQV7d7sV5NaC9J3kFYyJ8zTWVVapU8NU4msoxaEsgTRDSYk+u9GA5oXPExdS3QdgvRXHH/u6E2/tNrtG6zuoxSlrW7+lsBFby4jnLq9GmrwO2ZtYAwUZwlj8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlaATYTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlaATYTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A009BC4CEEB;
	Tue, 22 Jul 2025 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193119;
	bh=xvcux7fOw99zzWHLKmIyY0DfopVQhPHuWM5hB76zzMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlaATYTKf0YIRmOPJK8kBCmHLHlU29qsovyMyBX+2I7zaVzeQ8VpT/2ZyOX0nZLB9
	 LGO8AKWU2xn4KAotlFGaGhyz6faZ2tmLvFqzTVuTXPv4hg49DQ5hcYg/9LjJ9X2SFB
	 Vy95us1Xy5JAw8Ngah9p8Lzj3AO0SBgCJZ+d1OUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jiawei <zhongjiawei1@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 155/158] sched,freezer: Remove unnecessary warning in __thaw_task
Date: Tue, 22 Jul 2025 15:45:39 +0200
Message-ID: <20250722134346.497129620@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

commit 9beb8c5e77dc10e3889ff5f967eeffba78617a88 upstream.

Commit cff5f49d433f ("cgroup_freezer: cgroup_freezing: Check if not
frozen") modified the cgroup_freezing() logic to verify that the FROZEN
flag is not set, affecting the return value of the freezing() function,
in order to address a warning in __thaw_task.

A race condition exists that may allow tasks to escape being frozen. The
following scenario demonstrates this issue:

CPU 0 (get_signal path)		CPU 1 (freezer.state reader)
try_to_freeze			read freezer.state
__refrigerator			freezer_read
				update_if_frozen
WRITE_ONCE(current->__state, TASK_FROZEN);
				...
				/* Task is now marked frozen */
				/* frozen(task) == true */
				/* Assuming other tasks are frozen */
				freezer->state |= CGROUP_FROZEN;
/* freezing(current) returns false */
/* because cgroup is frozen (not freezing) */
break out
__set_current_state(TASK_RUNNING);
/* Bug: Task resumes running when it should remain frozen */

The existing !frozen(p) check in __thaw_task makes the
WARN_ON_ONCE(freezing(p)) warning redundant. Removing this warning enables
reverting commit cff5f49d433f ("cgroup_freezer: cgroup_freezing: Check if
not frozen") to resolve the issue.

This patch removes the warning from __thaw_task. A subsequent patch will
revert commit cff5f49d433f ("cgroup_freezer: cgroup_freezing: Check if
not frozen") to complete the fix.

Reported-by: Zhong Jiawei<zhongjiawei1@huawei.com>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/freezer.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -201,18 +201,9 @@ static int __restore_freezer_state(struc
 
 void __thaw_task(struct task_struct *p)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&freezer_lock, flags);
-	if (WARN_ON_ONCE(freezing(p)))
-		goto unlock;
-
-	if (!frozen(p) || task_call_func(p, __restore_freezer_state, NULL))
-		goto unlock;
-
-	wake_up_state(p, TASK_FROZEN);
-unlock:
-	spin_unlock_irqrestore(&freezer_lock, flags);
+	guard(spinlock_irqsave)(&freezer_lock);
+	if (frozen(p) && !task_call_func(p, __restore_freezer_state, NULL))
+		wake_up_state(p, TASK_FROZEN);
 }
 
 /**


