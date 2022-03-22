Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECA46465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2F3C340EC;
	Tue, 22 Mar 2022 21:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985741;
	bh=DRr0rWYhaEq6qsecV5yL2psCKpJTreoqVr9aKJ7yFXQ=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=Mcboy7eVMW1p1tbUmogolhgHFfkDxNs6flSV4BFJUSBUv1SQSVcrkBnnG6xDunAH2
	 hC8mGvtrVGmgWbTG63EGCIECHTjj4R7Aw1jeJuC+6bwA8wtvniCVIy3pyXofvFY97J
	 KAHaapVZ9qWsUoEdktNFRWYVMyYjjBYotOz7V+is=
Date: Tue, 22 Mar 2022 14:49:01 -0700
To: xhao@linux.alibaba.com,rientjes@google.com,sj@kernel.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 207/227] mm/damon/dbgfs: use operations id for knowing if the target has pid
Message-Id: <20220322214901.AB2F3C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: use operations id for knowing if the target has pid

DAMON debugfs interface depends on monitoring operations for virtual
address spaces because it knows if the target has pid or not by seeing if
the context is configured to use one of the virtual address space
monitoring operation functions.  We can replace that check with 'enum
damon_ops_id' now, to make it independent.  This commit makes the change.

Link: https://lkml.kernel.org/r/20220215184603.1479-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-use-operations-id-for-knowing-if-the-target-has-pid
+++ a/mm/damon/dbgfs.c
@@ -277,7 +277,7 @@ out:
 
 static inline bool target_has_pid(const struct damon_ctx *ctx)
 {
-	return ctx->ops.target_valid == damon_va_target_valid;
+	return ctx->ops.id == DAMON_OPS_VADDR;
 }
 
 static ssize_t sprint_target_ids(struct damon_ctx *ctx, char *buf, ssize_t len)
@@ -741,8 +741,8 @@ static struct damon_ctx *dbgfs_new_ctx(v
 	if (!ctx)
 		return NULL;
 
-	if (damon_select_ops(ctx, DAMON_OPS_VADDR) && damon_select_ops(ctx,
-				DAMON_OPS_PADDR)) {
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR) &&
+			damon_select_ops(ctx, DAMON_OPS_PADDR)) {
 		damon_destroy_ctx(ctx);
 		return NULL;
 	}
_
