Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6CC2C08B6;
	Tue, 22 Jul 2025 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192171; cv=none; b=MtY/UvlDu7lSXznFWvxeYIHT3X1cGPx6RfmY1SX5r4MgBaPZNu5PLYzigHg5obRVVcqhW3sRNyLH9GSBeh1cWM1Sotp6p2LZZu54VeiRSx7mU+/tnwwe3eD2/q/TBLK+Bu7YEMwfas0Ks2HHGXSAg3fIRdEolzY2nCipoya6M/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192171; c=relaxed/simple;
	bh=WT66ci4pYwSkHE+1/ilodnXFowgp9wk4u+ESdKM3nW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJkS8npgaXMHReYOV/Kd1o8UMVbJ7sngq9AmNE5N5x46kSMUBNXUC7nV+KMKzrFfgr68Q0+PUzAR1KG0BFULlgeHDgFZKOAKcbqMY68n0MOBQh38jMaY6yS41EQ4fRXXTmlbzb/ydEkpAbfqjM9oXZj641oqznoMeUJNsASAXgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1I4rGveD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1I4rGveD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BD1C4CEEB;
	Tue, 22 Jul 2025 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192171;
	bh=WT66ci4pYwSkHE+1/ilodnXFowgp9wk4u+ESdKM3nW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1I4rGveDLVwZTy9MF9FXSccUpb0M6CxFYQI82LWPji2zg9lXRF9hsOmFv0AlMeTgF
	 pDjBBZMLCO7SMHRqxHpLhF+Z28ZbIOikTauEfG+A44QAxkNw3DCeJCXAuhETsrbdF1
	 8W15YMkgX+ciVTyoLv/8FDvF7rtLnAiaqJpb6my8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jiawei <zhongjiawei1@huawei.com>,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 65/79] Revert "cgroup_freezer: cgroup_freezing: Check if not frozen"
Date: Tue, 22 Jul 2025 15:45:01 +0200
Message-ID: <20250722134330.759974328@linuxfoundation.org>
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
index a3e13e6d5ee40..bee2f9ea5e4ae 100644
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



