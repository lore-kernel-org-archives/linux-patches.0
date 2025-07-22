Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8BA2EA739;
	Tue, 22 Jul 2025 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193738; cv=none; b=XhBhcAAqDUugkQVZ73qkYyDNybmxtlhOWrBEuZ8fnC44L5C9Rb8cylLwIm2Lfs+L1lbLPKv3/sgDDPa46ssVhQ5rnHxy8GGkE+BsYDnJtHk3EiNUHP5RzklEWg8HSUp8pLL/RQM65xqIc8MMw5Cs6DZFfsmtjRIx32NV61Ijg1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193738; c=relaxed/simple;
	bh=e6CjX2c7bSjxb8D2qfHaPYquCltjelwW8dqyndRsbMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGdeUi/4/j4pFhNnUEHhqGPjALAtcjONsjZUzw/Rh8aWdZ+wCsmCtCCeD1qkNmOF+vObU14ZsqSA0pWHQ/33dBy9VNFoqDmND+rShRe8V32Cdmblk956BzQCzNEUOBKZyQKvudt+XlDKOMgd6kTEFwDgTgP7iq61ccG2qFp2r+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cISrMAvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cISrMAvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A7FC4CEEB;
	Tue, 22 Jul 2025 14:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193737;
	bh=e6CjX2c7bSjxb8D2qfHaPYquCltjelwW8dqyndRsbMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cISrMAvRNcF/AqiDRqMB8a3HD1BeT7x0g+ovW8ihxuM6z+Qvzk4EGUhT5mVi1MadJ
	 MLWv0ebz9oKDfGJrT0dqKyvoCruwI/azCG4GDFcvS46++LXkwyFGWBC7YSIhxsVlag
	 hGWRQcINTX/qPYTD3+yufHLyku0svTtvM/BOXji8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jiawei <zhongjiawei1@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.15 183/187] sched,freezer: Remove unnecessary warning in __thaw_task
Date: Tue, 22 Jul 2025 15:45:53 +0200
Message-ID: <20250722134352.585987270@linuxfoundation.org>
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


