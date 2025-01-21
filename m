Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B67CE571;
	Tue, 21 Jan 2025 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482514; cv=none; b=VclRejXs1gKfW6EiKw+U16bMD1aRLDj3a+WGwFMNv4ARLtJ4EXYKlOTN9NZWNsW8rpxAOuC9BZNkQmqRtWZv84pGBfnMrJZ0J06+w9ME+4jNRqhrdHIOZDvbGJuNTVDGg2hnkPBlk7IDW+BYzKzSpAtjhZms7qe6aCnf2FQZvms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482514; c=relaxed/simple;
	bh=GrExYwrFJBnBgbGShjjqvMP1rJw7JucgOhu4vdE9ZPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFMw/fAoy/rJ4RHO4CeP9tLarurBdHuEInNsp6TS/ixK+Np5DOlYVgXTwvNI91QTwh4a7SpmDUA/sR8FyGVlvMCvdnHuPzwcrNg75SCRpMjiSdJXx9b1A+lcy4H5Ci6e4SSfPkKUDRJegopbhJa10SHB2d9ka46rtYDJktoIaEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkUkHjsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkUkHjsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33019C4CEDF;
	Tue, 21 Jan 2025 18:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482513;
	bh=GrExYwrFJBnBgbGShjjqvMP1rJw7JucgOhu4vdE9ZPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkUkHjsksJXL50lR2WHKr8pvaUqN0g6+3pKygytNXaqhzFmn5cyj40Ddq+1HgBZSg
	 krmzmqmE1idSmHt1rK+Pfvp5rtDzBy59P2z90VDayOMPNeqH6GUfkHNS4pqmaSRbxH
	 CXnXA8MaciD1TfVqmz+Ki/06LOBwuOJuv9//BUGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Huang <henry.hj@antgroup.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/122] sched_ext: keep running prev when prev->scx.slice != 0
Date: Tue, 21 Jan 2025 18:51:51 +0100
Message-ID: <20250121174535.422548733@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Huang <henry.hj@antgroup.com>

[ Upstream commit 30dd3b13f9de612ef7328ccffcf1a07d0d40ab51 ]

When %SCX_OPS_ENQ_LAST is set and prev->scx.slice != 0,
@prev will be dispacthed into the local DSQ in put_prev_task_scx().
However, pick_task_scx() is executed before put_prev_task_scx(),
so it will not pick @prev.
Set %SCX_RQ_BAL_KEEP in balance_one() to ensure that pick_task_scx()
can pick @prev.

Signed-off-by: Henry Huang <henry.hj@antgroup.com>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index f928a67a07d29..4c4681cb9337b 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2630,6 +2630,7 @@ static int balance_one(struct rq *rq, struct task_struct *prev)
 {
 	struct scx_dsp_ctx *dspc = this_cpu_ptr(scx_dsp_ctx);
 	bool prev_on_scx = prev->sched_class == &ext_sched_class;
+	bool prev_on_rq = prev->scx.flags & SCX_TASK_QUEUED;
 	int nr_loops = SCX_DSP_MAX_LOOPS;
 
 	lockdep_assert_rq_held(rq);
@@ -2662,8 +2663,7 @@ static int balance_one(struct rq *rq, struct task_struct *prev)
 		 * See scx_ops_disable_workfn() for the explanation on the
 		 * bypassing test.
 		 */
-		if ((prev->scx.flags & SCX_TASK_QUEUED) &&
-		    prev->scx.slice && !scx_rq_bypassing(rq)) {
+		if (prev_on_rq && prev->scx.slice && !scx_rq_bypassing(rq)) {
 			rq->scx.flags |= SCX_RQ_BAL_KEEP;
 			goto has_tasks;
 		}
@@ -2696,6 +2696,10 @@ static int balance_one(struct rq *rq, struct task_struct *prev)
 
 		flush_dispatch_buf(rq);
 
+		if (prev_on_rq && prev->scx.slice) {
+			rq->scx.flags |= SCX_RQ_BAL_KEEP;
+			goto has_tasks;
+		}
 		if (rq->scx.local_dsq.nr)
 			goto has_tasks;
 		if (consume_global_dsq(rq))
@@ -2721,8 +2725,7 @@ static int balance_one(struct rq *rq, struct task_struct *prev)
 	 * Didn't find another task to run. Keep running @prev unless
 	 * %SCX_OPS_ENQ_LAST is in effect.
 	 */
-	if ((prev->scx.flags & SCX_TASK_QUEUED) &&
-	    (!static_branch_unlikely(&scx_ops_enq_last) ||
+	if (prev_on_rq && (!static_branch_unlikely(&scx_ops_enq_last) ||
 	     scx_rq_bypassing(rq))) {
 		rq->scx.flags |= SCX_RQ_BAL_KEEP;
 		goto has_tasks;
-- 
2.39.5



