Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E1A432E94;
	Thu, 30 Jul 2026 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423448; cv=none; b=s0xkOTH47WzaZOsp+NJtw0UXNPzNUJwYJlCgUEfq3rDBhdUrLsD2UQRhwTx7GOA0rqqAxNf0P9LrcW1QFoscUHRDAaqnaXDy0kUEHRnIANdeBLEX0Ojje2Hr29mp5ttMMRDwfbXeeBZO6QCchmebEAFg60GbCGeqwIaw8q8GRYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423448; c=relaxed/simple;
	bh=IGb9ZxivJrNEvzq9RNxRKhp5+iR9niVityCY/qUVg2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd9CDbFX1WHkREVJrly8ERZo9NESy/uIbGU7NdKLPOmWGilhe2AON2fImLylWlHiIXnYLEdORbAPK8mV2GKpH+nRugmYDW2bNw3uO24NYebPamnC9Ku6nTvUT85PiPoR3ObPfADWVQdJhkTCSEahsqK43BVK/Xq6dRsqUiH+C3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXYNe1Z0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXYNe1Z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D261F000E9;
	Thu, 30 Jul 2026 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423447;
	bh=XbE+fc+eSypvRMhy/EP4tbixg8YNqF5c8/vHzC/XmLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXYNe1Z0VSas9PUrKnyWnIPh+3boUvnt+9PRmQ99vy+pJFc/q+qRTsFE0DvENanrE
	 mFS0QQoPyOgKqij7P+Q/RFore4JMvg71uzNuz4qXVZ7uLUV31fleXhk8dcBaLb2UvR
	 BfuNDxG+rtAbVKWLc8vI7IbSqI9qkheDj0gFWo6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/675] sched_ext: Dont warn on core-sched forced idle in put_prev_task_scx()
Date: Thu, 30 Jul 2026 16:06:17 +0200
Message-ID: <20260730141446.119965510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit b7d9c359e5cf867f7eb23df3bb1c6b9e58af24da ]

put_prev_task_scx() warns when a runnable task drops to a lower sched_class
without SCX_OPS_ENQ_LAST, on the assumption that balance_one() would have
kept it running. Core scheduling breaks that: a forced-idle SMT sibling
reschedules through the core_pick fast path in pick_next_task(), which skips
pick_task_scx() and thus balance_one(), so a runnable task can drop to idle
with ENQ_LAST unset.

Gate the warning on sched_cpu_cookie_match(): a cookie mismatch means core
scheduling forced the idle, while a match (or core scheduling off) still
catches a genuine missing-ENQ_LAST drop.

Fixes: 7c65ae81ea86 ("sched_ext: Don't call put_prev_task_scx() before picking the next task")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index d399494364c0a3..83baf270888882 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2395,9 +2395,14 @@ static void put_prev_task_scx(struct rq *rq, struct task_struct *p,
 		 * sched_class, %SCX_OPS_ENQ_LAST must be set. Tell
 		 * ops.enqueue() that @p is the only one available for this cpu,
 		 * which should trigger an explicit follow-up scheduling event.
+		 *
+		 * Core scheduling can force this CPU idle while @p stays
+		 * runnable. @p's cookie then won't match the core's, so skip
+		 * the warning in that case.
 		 */
 		if (next && sched_class_above(&ext_sched_class, next->sched_class)) {
-			WARN_ON_ONCE(!(sch->ops.flags & SCX_OPS_ENQ_LAST));
+			WARN_ON_ONCE(sched_cpu_cookie_match(rq, p) &&
+				     !(sch->ops.flags & SCX_OPS_ENQ_LAST));
 			do_enqueue_task(rq, p, SCX_ENQ_LAST, -1);
 		} else {
 			do_enqueue_task(rq, p, 0, -1);
-- 
2.53.0



