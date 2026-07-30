Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E1A2D9EE4;
	Thu, 30 Jul 2026 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421213; cv=none; b=m7IyYLvxqJP8qIREd5c4BTbsr+tIGWlaJDs66nmDq1dDA1ux0qhkWmEFdrV+24Or26xrNy9a5ZgGhSbR6JPbqPDRdsA8F9fI9oFXaqyIp5Jm7zX3YX+tdOhHG8hek2y7kcjcD4zEO3H4rvVqoD4zopHzclcky66MkOPpup3r+Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421213; c=relaxed/simple;
	bh=63SzKYcpmBKDrA1b8wGxSk5F3ZHr8I4f8fdWK+yKs0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HK3j5pF77KoGwBXK+2oQKvcJZR3B4M4Jhb60bwaW7gOeIFs5MZL2DjTlkQ5Uu0v7zF5zT89ODTBCJyUUPCaR2DkKxK+rVGJD0ID6chJZCYbdb0vBLg8UP2m39H+CuSF60thvdJrSfIsUTKEt+SobNaypDC4hSLOUtUVDLvzC9Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnlsbBU2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnlsbBU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9F21F00A3A;
	Thu, 30 Jul 2026 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421211;
	bh=DNVcOt9DA91NQA83gnT977DyrLTiswy/cliN3ZXAtp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnlsbBU2b6+7BZdgCN4QoFyYHqDfbOcfzLgKWDqNXhV7tEH7ATnURQLgRCMJyvDar
	 /5s7UFa1kiX7i8GRPH4KfgJnMvNfpPPu7CL5dpKKlg5d1m616Ir/dYVLaBAUEsUqrz
	 yVT2WD4LGXeptW8kM6Iu7miQzBSv4M1nY/L1ClM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 028/744] sched_ext: Dont warn on core-sched forced idle in put_prev_task_scx()
Date: Thu, 30 Jul 2026 16:05:01 +0200
Message-ID: <20260730141444.882893253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0e13139a7f27b9..5f1accb092e30b 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3097,9 +3097,14 @@ static void put_prev_task_scx(struct rq *rq, struct task_struct *p,
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



