Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2536015E8B;
	Mon, 30 Dec 2024 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573915; cv=none; b=uq4d+GKo9MWbN3++QGWQ6XJ8edDPmt/I8+rU0xpWKFl1ExxCU0J1o0OltpMyXZPtaklQX953BjjnPXlxkVxu89KH/MNpYsag1PmYdrU3depoGiOmWAnRkrui5QC3uq6q/4lFCN1zj+XXm9bj9bM/9abRyb+vWARcLYJwTmDtylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573915; c=relaxed/simple;
	bh=jZZ2gs7nlt0ZFtc4fD/5elvz/l9sQdK7S/gffSnjf0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2YDfcqyk30rICUK7p8SqRopKTkJ+zvcLVbU5InI1iqDsrRCyiGHaoKHJC38K+uxd+flUtoUu1PWwMr7ks6fCAKVJod4VhIZ+DDQMrOei+S+V0iCROiBivLLX5G8iw2Z/L2dUEHV2O4Q+qwNKq5l/fNaFyXfu1Wy3xmCJMRjrMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyYOaCc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyYOaCc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89062C4CED0;
	Mon, 30 Dec 2024 15:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573915;
	bh=jZZ2gs7nlt0ZFtc4fD/5elvz/l9sQdK7S/gffSnjf0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyYOaCc4fEjOnnI6UTMDHrxkiALDoNmpJ3lLE46JYGtXhC7ceg0MNJQ33tQibhhhG
	 m2iyxw8RqxkWOKP3/9V/teh8/Qk3SQBI1hhke4huICtTIgUdlVn1qvI4x/MikMHXd5
	 wmHatLXwR/xH9F9HlpO86HX+ApPyZdvM4OdGsAho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 72/86] freezer, sched: Report frozen tasks as D instead of R
Date: Mon, 30 Dec 2024 16:43:20 +0100
Message-ID: <20241230154214.448045423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit f718faf3940e95d5d34af9041f279f598396ab7d ]

Before commit:

  f5d39b020809 ("freezer,sched: Rewrite core freezer logic")

the frozen task stat was reported as 'D' in cgroup v1.

However, after rewriting the core freezer logic, the frozen task stat is
reported as 'R'. This is confusing, especially when a task with stat of
'S' is frozen.

This bug can be reproduced with these steps:

	$ cd /sys/fs/cgroup/freezer/
	$ mkdir test
	$ sleep 1000 &
	[1] 739         // task whose stat is 'S'
	$ echo 739 > test/cgroup.procs
	$ echo FROZEN > test/freezer.state
	$ ps -aux | grep 739
	root     739  0.1  0.0   8376  1812 pts/0    R    10:56   0:00 sleep 1000

As shown above, a task whose stat is 'S' was changed to 'R' when it was
frozen.

To solve this regression, simply maintain the same reported state as
before the rewrite.

[ mingo: Enhanced the changelog and comments ]

Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Koutný <mkoutny@suse.com>
Link: https://lore.kernel.org/r/20241217004818.3200515-1-chenridong@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4809f27b5201..d4f9d82c69e0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1683,8 +1683,9 @@ static inline unsigned int __task_state_index(unsigned int tsk_state,
 	 * We're lying here, but rather than expose a completely new task state
 	 * to userspace, we can make this appear as if the task has gone through
 	 * a regular rt_mutex_lock() call.
+	 * Report frozen tasks as uninterruptible.
 	 */
-	if (tsk_state & TASK_RTLOCK_WAIT)
+	if ((tsk_state & TASK_RTLOCK_WAIT) || (tsk_state & TASK_FROZEN))
 		state = TASK_UNINTERRUPTIBLE;
 
 	return fls(state);
-- 
2.39.5



