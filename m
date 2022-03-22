Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF24B6465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FD9C340EC;
	Tue, 22 Mar 2022 21:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985738;
	bh=e18K+wm4UBcrwGriRTqtVE5w6iKB6Kmcvk6mybDaurQ=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=BQsMkZSvlGwTxyAu1inbWaexq1ztJIrBQo2LUGStVUKdqc9Lcww3Hu2WssrrHTb1q
	 gzyCM9HJi7e3GvxOHwlagKr4j9K02l0MnaLzO4RCiUcOHbEpEQAEbajrVSfJVvtAL7
	 n4nEVdwSjKLENh92pziyVeCVg9zj9bDorg2V73g4=
Date: Tue, 22 Mar 2022 14:48:58 -0700
To: xhao@linux.alibaba.com,rientjes@google.com,sj@kernel.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 206/227] mm/damon/dbgfs: use damon_select_ops() instead of damon_{v,p}a_set_operations()
Message-Id: <20220322214858.B6FD9C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: use damon_select_ops() instead of damon_{v,p}a_set_operations()

This commit makes DAMON debugfs interface to select the registered
monitoring operations for the physical address space or virtual address
spaces depending on user requests instead of setting it on its own.  Note
that DAMON debugfs interface is still dependent to DAMON_VADDR with this
change, because it is also using its symbol, 'damon_va_target_valid'.

Link: https://lkml.kernel.org/r/20220215184603.1479-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-use-damon_select_ops-instead-of-damon_vpa_set_operations
+++ a/mm/damon/dbgfs.c
@@ -474,12 +474,18 @@ static ssize_t dbgfs_target_ids_write(st
 
 	/* remove previously set targets */
 	dbgfs_set_targets(ctx, 0, NULL);
+	if (!nr_targets) {
+		ret = count;
+		goto unlock_out;
+	}
 
 	/* Configure the context for the address space type */
 	if (id_is_pid)
-		damon_va_set_operations(ctx);
+		ret = damon_select_ops(ctx, DAMON_OPS_VADDR);
 	else
-		damon_pa_set_operations(ctx);
+		ret = damon_select_ops(ctx, DAMON_OPS_PADDR);
+	if (ret)
+		goto unlock_out;
 
 	ret = dbgfs_set_targets(ctx, nr_targets, target_pids);
 	if (!ret)
@@ -735,7 +741,11 @@ static struct damon_ctx *dbgfs_new_ctx(v
 	if (!ctx)
 		return NULL;
 
-	damon_va_set_operations(ctx);
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR) && damon_select_ops(ctx,
+				DAMON_OPS_PADDR)) {
+		damon_destroy_ctx(ctx);
+		return NULL;
+	}
 	ctx->callback.before_terminate = dbgfs_before_terminate;
 	return ctx;
 }
_
