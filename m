Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCF015E8B;
	Mon, 30 Dec 2024 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574394; cv=none; b=WxKo240xBFrrV3MU1hICD7iEgWUkwsgK9QKRpfrBiBOGZiMIu2up25Yw2X+v7ABVGX+J3Tsg+C5LdEZ2ZeF5rY6nQeORhJlGoZZM95zKEjNGvbMjJ0Dfm5nKg32Eujs/55y3FPsLrrDo8P0ufqMlL4qWnwapfl8As1kEIo3lI1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574394; c=relaxed/simple;
	bh=Y+gnOPEkTlAyfzcQ4cwhK8rijzl4GF1XDggJUOg10Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bGPUek2CGaobcCLuchaQZdkw2mu5F1v19Ot0VNxWN7hsTiw43Ug5mXpNzmoEHZSN71pbDDQXunH4gVl+nbO48MNZ3Bpw8hRSIJT3Hp/ugc2ev6/mR8FufeHZUmuxuyQg9R5DfPeybP4QaxZz6OoRILrGJYWmGqzLQ9BNY54gowI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWIYXbyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWIYXbyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F333C4CED2;
	Mon, 30 Dec 2024 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574394;
	bh=Y+gnOPEkTlAyfzcQ4cwhK8rijzl4GF1XDggJUOg10Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWIYXbyQfb0OairUjbYddlokmctA4CdCmFALEuCNXHRTjCXvCA1NcEkSb91jYZXpU
	 DJhHji3qBiBH9uoId7/HbjZdIdPYEmYlYMvPWSAd80BSONAIkr9MXAUnQ+1fF+BmQ5
	 2f8Fl0qPba+tizsGAgTtHqCcC1twHp2URNeMrcpw=
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
Subject: [PATCH 6.12 082/114] freezer, sched: Report frozen tasks as D instead of R
Date: Mon, 30 Dec 2024 16:43:19 +0100
Message-ID: <20241230154221.249066273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c14446c6164d..02eaf84c8626 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1633,8 +1633,9 @@ static inline unsigned int __task_state_index(unsigned int tsk_state,
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



