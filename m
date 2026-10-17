Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA938AC99;
	Sat, 17 Oct 2026 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254327; cv=none; b=ekweE3mVNva1+Qw5m56VNHZaYKTS8ESVGpxBN3U6hCn5Px8h38n2ax5NvQRICiYCPN+Hw5Bme56BidPnAiy65RHDm/7XY0L9Ols68vJV3w8ooGEGaXU+jBMSCnRmuT4SiUFPFGRlUAvIPkn3CWuDvNiC7zkr1UASVM1XT0vXiFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254327; c=relaxed/simple;
	bh=p0o3KWrfwT80LkRmT1G5Pg03O4Ixnj+9w0FvoCAlnLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nurt8nEutKXWiNIyqUYSIGtIX5G03Yjno51wCZ29Tts8X3J45pPas5QZp5F9lETALxlBTE/3alr4Dis3uMZa1IZ1dLL4rnTUDKqAkvxV+xWPUWtEfbYpT2BhsQR6NX6x+Ra4hjUE2Jb3jh+/yr+oqR6IDWU5bcNomxtR8qbz7e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9ByZY/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9ByZY/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CE01F000C4;
	Sat, 17 Oct 2026 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254326;
	bh=vgCI5wdiqnuCaANQhc3CY9zX5luGbCRIrbkBPprDAis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9ByZY/0O58eA5pGg+0JmwUnaZSsXPTWapu6MXRkPVy1+9NajGc6ObaAa4rbwncPa
	 gqfFWeFxdieJ28KkGGAr+0H3NTS4q6S3ZobT3s7f2LtOseH3PDkaYRTQuC0ORZGxPA
	 IQjefJJQtrWo1nqWyhuPdVrIwubdXcL9wfbcgkb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 409/869] sched_ext: Dont warn on core-sched forced idle in put_prev_task_scx()
Date: Sat, 17 Oct 2026 17:54:10 +0200
Message-ID: <20261017160047.620700151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 39dc9d3cfc079..876adf5568ed1 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3085,9 +3085,14 @@ static void put_prev_task_scx(struct rq *rq, struct task_struct *p,
 		 * sched_class, %SCX_OPS_ENQ_LAST must be set. Tell
 		 * ops.enqueue() that @p is the only one available for this cpu,
 		 * which should trigger an explicit follow-up scheduling event.
+		 *
+		 * Core scheduling can force this CPU idle while @p stays
+		 * runnable. @p's cookie then won't match the core's, so skip
+		 * the warning in that case.
 		 */
 		if (sched_class_above(&ext_sched_class, next->sched_class)) {
-			WARN_ON_ONCE(!static_branch_unlikely(&scx_ops_enq_last));
+			WARN_ON_ONCE(sched_cpu_cookie_match(rq, p) &&
+				     !static_branch_unlikely(&scx_ops_enq_last));
 			do_enqueue_task(rq, p, SCX_ENQ_LAST, -1);
 		} else {
 			do_enqueue_task(rq, p, 0, -1);
-- 
2.53.0



