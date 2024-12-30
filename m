Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC14D2594B6;
	Mon, 30 Dec 2024 15:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573631; cv=none; b=RuLMpZQdXhbv/LgTZk046Kq4VsYRaLUAfOMuuHnrsrFKilIlT1GZZw/i5aRkdpoR0Sfu10GUmxmfR89bQLvOATyEj5WjT8Mr/3xqvsBLiJhtr3klKWp7mWRKDFKMwsJaAd/as/vnhcwQQVX7Edu+rOgdcupr7ygn0Sk9vrVzR/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573631; c=relaxed/simple;
	bh=p+vn2ZW1YHX88tHsYjRO0d+6l6h6fjfs8wg/xzhLL54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6ZvUftngEGl+G9baJQ01jMHCNGmiEYbTBEVL7E/6HIowcVchcUK+y3cqxBm5a+j/5mQKfH+EqEa0zF+SYRpvH5jHzBf8/wWBDDbZnCmDRZtONBzHdJqSxdCg/4ePf+E0NIZ971rp0R9t1H+VqG9EtbhnIhZEDO6Zp7DwbZaG8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDoNw8GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDoNw8GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D094C4CED0;
	Mon, 30 Dec 2024 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573631;
	bh=p+vn2ZW1YHX88tHsYjRO0d+6l6h6fjfs8wg/xzhLL54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDoNw8GHZODjDf8Ld68sNdIk5XGej8zchphYUp5RIWwwkNXjYQ8tQGXgXgTjMdZGF
	 Q/39rgmJSIwKzxRGspwCbIJauo2Y0jTak65MpOflrZAwcWsIqwrBGZGb2kTUA2WXj8
	 EdZtOaSptQSDBz6dskwFU+j6qDnRnoPvTeC9u7/I=
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
Subject: [PATCH 6.1 48/60] freezer, sched: Report frozen tasks as D instead of R
Date: Mon, 30 Dec 2024 16:42:58 +0100
Message-ID: <20241230154209.096803343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 205a00806835..e87a68b136da 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1670,8 +1670,9 @@ static inline unsigned int __task_state_index(unsigned int tsk_state,
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



