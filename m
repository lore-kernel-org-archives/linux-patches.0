Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79032392836;
	Sat, 17 Oct 2026 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257765; cv=none; b=CzVEU0Mg5E9V6idPNwWng4OATy46pWu+N/U9awXNMaXmmnuq85bc/5eUW1tsN16knWzFuSN4dgPAPDlmObV8U8OvKIF5FAho60PQ6ckNGJ4FLs7wix+LGqvm8/0+Kvq+E3JETVI0cv0OIjipk5pIXp1v4FpZOUlnW+0DfcCsyus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257765; c=relaxed/simple;
	bh=bm+kc3+TkrO965sa2xmbontuZhPQ86P4ubmJF1GFnlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lx4wRHNGQUtKbsrnJ9TLmx0qp8WEzqZo2IFsbBBnPNC5q4BBfECpI4pmfwoPPGgj//fOl8xsW4yiRTUMeBPLHRsQw65T814/91EV5XHE2ufLEkfBVOqKsjkRhK+LPoWzJQAGWeTDS8UEDBVU9wOwE2fdydU7Kcq2pa/xBAJhhbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQzlP2zO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQzlP2zO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD9A1F000C4;
	Sat, 17 Oct 2026 17:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257764;
	bh=N0LvLdRUgwjLkP3d+WEAt9VMj/NX/CfvW+Cli14xeaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQzlP2zOZhn1MCYwLww17rm8KSSPt+zxbyFpehv1izVqwpTrwRsFXrN6nEa8aO8Jj
	 JLAuY2WbwrBnImG9dRiFKm3I8M+WvMU/fczHsjQCMy5hm6AoJJfbfApPMI/unWMXSO
	 MKnQhPhv5o487FNV09wYoxHhJQUABdQkqT/OCM/s=
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
Subject: [PATCH 6.6 0621/1674] sched: fix warning in sched_setaffinity
Date: Sat, 17 Oct 2026 17:48:13 +0200
Message-ID: <20261017160447.017048748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 797b81dcf69ab..ed3fcf41bb0f4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8346,7 +8346,7 @@ __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
 			bool empty = !cpumask_and(new_mask, new_mask,
 						  ctx->user_mask);
 
-			if (WARN_ON_ONCE(empty))
+			if (empty)
 				cpumask_copy(new_mask, cpus_allowed);
 		}
 		__set_cpus_allowed_ptr(p, ctx);
-- 
2.53.0



