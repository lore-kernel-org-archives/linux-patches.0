Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AFF748A;
	Thu, 12 Dec 2024 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017295; cv=none; b=C6qRYV3JBIVNMifoXZ6mf+Aoor/otsZUCCwr20ngrDc4keXweLWtY0y65alRohpu4zX9P3J9eVD2x0FvMyDm9YU44EKOB81CG1X735zh9xuhiRmoJbhqris//rvSpLIL1fJmRprtap5/iU+6moiSdyCMCY8B+Vql/Ai2f3i8olM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017295; c=relaxed/simple;
	bh=bS6MDndiC+oVXKDLoNw6R4ERuytx4rQam+SlscLwHMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl3Ctv4LnwlpQL05lbPV9t68wqshi9wPDuVeUX0MpnF8DvjTOsNztRHgJX0l30Qz8RQuGa/8FGYBqRt6ibgBA5b3YI6pshFYIowL5Z8LUtPjJFy2bS9f5k2sdHM7tyIZ7KOfonZ2+U2+1pGxNn2pOdQA79rMmQk3ZNLWCN3VPjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBa6G4wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBa6G4wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3F9C4CED4;
	Thu, 12 Dec 2024 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017295;
	bh=bS6MDndiC+oVXKDLoNw6R4ERuytx4rQam+SlscLwHMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBa6G4wb2Ijz9Z3TYe7f5uX6QSxyXkOwKbrdQ3uVF2C8qga29VL8PMXUlRAur0gew
	 E+IEfkfbU7jUAZt7rYlUpKya/O47nQ/qkNZeFBCjFsBTQEgeOHn1UAv7aO29meXiyj
	 /mFCBWBiQYJg+y2rnsocnSG6dWRQNXl2I7+iOFao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Don <joshdon@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Madadi Vineeth Reddy <vineethr@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 6.12 439/466] sched: fix warning in sched_setaffinity
Date: Thu, 12 Dec 2024 16:00:08 +0100
Message-ID: <20241212144324.204301372@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Josh Don <joshdon@google.com>

[ Upstream commit 70ee7947a29029736a1a06c73a48ff37674a851b ]

Commit 8f9ea86fdf99b added some logic to sched_setaffinity that included
a WARN when a per-task affinity assignment races with a cpuset update.

Specifically, we can have a race where a cpuset update results in the
task affinity no longer being a subset of the cpuset. That's fine; we
have a fallback to instead use the cpuset mask. However, we have a WARN
set up that will trigger if the cpuset mask has no overlap at all with
the requested task affinity. This shouldn't be a warning condition; its
trivial to create this condition.

Reproduced the warning by the following setup:

- $PID inside a cpuset cgroup
- another thread repeatedly switching the cpuset cpus from 1-2 to just 1
- another thread repeatedly setting the $PID affinity (via taskset) to 2

Fixes: 8f9ea86fdf99b ("sched: Always preserve the user requested cpumask")
Signed-off-by: Josh Don <joshdon@google.com>
Acked-and-tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Tested-by: Madadi Vineeth Reddy <vineethr@linux.ibm.com>
Link: https://lkml.kernel.org/r/20241111182738.1832953-1-joshdon@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/syscalls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 24f9f90b6574e..1784ed1fb3fe5 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -1238,7 +1238,7 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
 			bool empty = !cpumask_and(new_mask, new_mask,
 						  ctx->user_mask);
 
-			if (WARN_ON_ONCE(empty))
+			if (empty)
 				cpumask_copy(new_mask, cpus_allowed);
 		}
 		__set_cpus_allowed_ptr(p, ctx);
-- 
2.43.0



