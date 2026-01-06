Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DFE28C037;
	Tue,  6 Jan 2026 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721333; cv=none; b=hvfnCy3z+y1xzaZ598x5PNLGjXdAdRf0bAgaZmkm6AWR0ZP+AgEq3ZXlVASbElGdhlkOPzMoR4Br7qyOt2Lpe4XRAV3fElnAdqETuE/V2L6SnFUuF/y0HKhoHEpc7MiEzM8dAw6Ok1dgaFg3YFArP1g35iX+QeoXpxm7N2IVms0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721333; c=relaxed/simple;
	bh=VIhaUHDjrzMhqHDYGU2Ci8yBxUny/dkCQ9hae9+Ey/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNDuAfPaur9Moxa7rCr46+v9ZMKojbX6U9lNyyEZxharJNROVea1+koW4CIW0sqBCbtUUcEZk8HqGbGdlYq/p7h+GthNYehnI1SJNYFfe2/hm+yweGal0LF9BkbMzaqiov2ESqehs/rBXgURALF4kc0gDDzp+PE3ni2CIJs6q/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9Uch4wx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9Uch4wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079D5C16AAE;
	Tue,  6 Jan 2026 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721333;
	bh=VIhaUHDjrzMhqHDYGU2Ci8yBxUny/dkCQ9hae9+Ey/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9Uch4wxoGCWx3eN2/MZ1bnh5iV+Rk+F92E1Yt8XB8Lq39zqOQBxSGtjgQTEt00Q8
	 QaYT7bzgn47yDSgfnSENAgNThbC4s8Vb1AN0+XEA8U+a4TB8xO2xk0ldbGz1ZNPZT2
	 jCVwDTmTy/Pms4nD6erOK/RjbkJRk/SrZJRT625Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 506/567] sched_ext: Factor out local_dsq_post_enq() from dispatch_enqueue()
Date: Tue,  6 Jan 2026 18:04:48 +0100
Message-ID: <20260106170510.090865593@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 530b6637c79e728d58f1d9b66bd4acf4b735b86d ]

Factor out local_dsq_post_enq() which performs post-enqueue handling for
local DSQs - triggering resched_curr() if SCX_ENQ_PREEMPT is specified or if
the current CPU is idle. No functional change.

This will be used by the next patch to fix move_local_task_to_local_dsq().

Cc: stable@vger.kernel.org # v6.12+
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1676,6 +1676,22 @@ static void dsq_mod_nr(struct scx_dispat
 	WRITE_ONCE(dsq->nr, dsq->nr + delta);
 }
 
+static void local_dsq_post_enq(struct scx_dispatch_q *dsq, struct task_struct *p,
+			       u64 enq_flags)
+{
+	struct rq *rq = container_of(dsq, struct rq, scx.local_dsq);
+	bool preempt = false;
+
+	if ((enq_flags & SCX_ENQ_PREEMPT) && p != rq->curr &&
+	    rq->curr->sched_class == &ext_sched_class) {
+		rq->curr->scx.slice = 0;
+		preempt = true;
+	}
+
+	if (preempt || sched_class_above(&ext_sched_class, rq->curr->sched_class))
+		resched_curr(rq);
+}
+
 static void dispatch_enqueue(struct scx_dispatch_q *dsq, struct task_struct *p,
 			     u64 enq_flags)
 {
@@ -1773,22 +1789,10 @@ static void dispatch_enqueue(struct scx_
 	if (enq_flags & SCX_ENQ_CLEAR_OPSS)
 		atomic_long_set_release(&p->scx.ops_state, SCX_OPSS_NONE);
 
-	if (is_local) {
-		struct rq *rq = container_of(dsq, struct rq, scx.local_dsq);
-		bool preempt = false;
-
-		if ((enq_flags & SCX_ENQ_PREEMPT) && p != rq->curr &&
-		    rq->curr->sched_class == &ext_sched_class) {
-			rq->curr->scx.slice = 0;
-			preempt = true;
-		}
-
-		if (preempt || sched_class_above(&ext_sched_class,
-						 rq->curr->sched_class))
-			resched_curr(rq);
-	} else {
+	if (is_local)
+		local_dsq_post_enq(dsq, p, enq_flags);
+	else
 		raw_spin_unlock(&dsq->lock);
-	}
 }
 
 static void task_unlink_from_dsq(struct task_struct *p,


