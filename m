Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C671322094;
	Tue, 22 Jul 2025 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193155; cv=none; b=F6UOYwZsShrVSZyqIf+ZxXOmZY+jVz3MMx/hKnxVh9DdlTF4EHQJImCkAxanKqkO1LODtwVJzIQkKuukcFjachQNHdIKhmIK9YO+pSM9CeDQZuDN/9Yw3d4kJi6St72qrW4jByEg/J3GyYlb4Wa75iPSPcUh8N3d7Fx7vl9p9OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193155; c=relaxed/simple;
	bh=d2fTc8FnXJ4oKoizVmFoy+Peh7lEsbR+l4g63vOk/GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHPE+6xX8lUEv4p381BFiclv/GdL4R1j1Ckb5t6pG+3RjdRGK70Iylc57hbiJb825TaznTeXgXjzxk8SuSMicUb9lSNQ8wcsZJTniXedHi3ajtz4ukUAzYHCPfenEr07NiR9lA+n+t0VlecKo6Lse8f52Juxw0Gw6Oom16ZO47Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7nnIXIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7nnIXIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430B5C4CEEB;
	Tue, 22 Jul 2025 14:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193155;
	bh=d2fTc8FnXJ4oKoizVmFoy+Peh7lEsbR+l4g63vOk/GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7nnIXIMekZff3N0OCdKZRh3HeOc8o3KMyip6WYelk/9lnxChSIIQqtoIi9+RJZg3
	 q/y1g7gjqnJQcvC21O9DkZWtAvWNUFc+hgIpAsjpUQ8yegpnJe+hIsholhWwucKCa8
	 sOkJOEarss8Y6NvYegkBgW0fQ7Fmm+4CPootyuI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jiawei <zhongjiawei1@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/158] Revert "cgroup_freezer: cgroup_freezing: Check if not frozen"
Date: Tue, 22 Jul 2025 15:45:19 +0200
Message-ID: <20250722134345.764093869@linuxfoundation.org>
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

[ Upstream commit 14a67b42cb6f3ab66f41603c062c5056d32ea7dd ]

This reverts commit cff5f49d433fcd0063c8be7dd08fa5bf190c6c37.

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
reverting the commit cff5f49d433f ("cgroup_freezer: cgroup_freezing: Check
if not frozen") to resolve the issue.

The warning has been removed in the previous patch. This patch revert the
commit cff5f49d433f ("cgroup_freezer: cgroup_freezing: Check if not
frozen") to complete the fix.

Fixes: cff5f49d433f ("cgroup_freezer: cgroup_freezing: Check if not frozen")
Reported-by: Zhong Jiawei<zhongjiawei1@huawei.com>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/legacy_freezer.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
index 01c02d116e8e1..c37888b7d25af 100644
--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -66,15 +66,9 @@ static struct freezer *parent_freezer(struct freezer *freezer)
 bool cgroup_freezing(struct task_struct *task)
 {
 	bool ret;
-	unsigned int state;
 
 	rcu_read_lock();
-	/* Check if the cgroup is still FREEZING, but not FROZEN. The extra
-	 * !FROZEN check is required, because the FREEZING bit is not cleared
-	 * when the state FROZEN is reached.
-	 */
-	state = task_freezer(task)->state;
-	ret = (state & CGROUP_FREEZING) && !(state & CGROUP_FROZEN);
+	ret = task_freezer(task)->state & CGROUP_FREEZING;
 	rcu_read_unlock();
 
 	return ret;
-- 
2.39.5



