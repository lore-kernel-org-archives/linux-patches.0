Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C626465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEB7C340EC;
	Tue, 22 Mar 2022 21:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985744;
	bh=0WpgQobUTiVwtxV7NFf+Y6SWIqqNGRsmY/UVDIUiHD8=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=FKNNtWmWsjsos854FKoq8mDUk0ZwAPy16h2NL5sRpeUeI6Yy70TfY0sKD/2K8R5w/
	 4FlyX6wTlQnRu5N5Kyix/JGOBq+e1nLSwBLRIYYE+W7egLF5Rpi6OkBkiohcUdNuji
	 I6HU/DTJP0l7HrnR5vOvf+LMowiPJo97ZBXOHh8k=
Date: Tue, 22 Mar 2022 14:49:04 -0700
To: xhao@linux.alibaba.com,rientjes@google.com,sj@kernel.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 208/227] mm/damon/dbgfs-test: fix is_target_id() change
Message-Id: <20220322214904.ADEB7C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs-test: fix is_target_id() change

DAMON kunit tests for DAMON debugfs interface fails because it still
assumes setting empty monitoring operations makes DAMON debugfs interface
believe the target of the context don't have pid.  This commit fixes the
kunit test fails by explicitly setting the context's monitoring operations
with the operations for the physical address space, which let debugfs
knows the target will not have pid.

Link: https://lkml.kernel.org/r/20220215184603.1479-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs-test.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/dbgfs-test.h~mm-damon-dbgfs-test-fix-is_target_id-change
+++ a/mm/damon/dbgfs-test.h
@@ -74,7 +74,7 @@ static void damon_dbgfs_test_set_targets
 	char buf[64];
 
 	/* Make DAMON consider target has no pid */
-	ctx->ops = (struct damon_operations){};
+	damon_select_ops(ctx, DAMON_OPS_PADDR);
 
 	dbgfs_set_targets(ctx, 0, NULL);
 	sprint_target_ids(ctx, buf, 64);
@@ -111,6 +111,8 @@ static void damon_dbgfs_test_set_init_re
 	int i, rc;
 	char buf[256];
 
+	damon_select_ops(ctx, DAMON_OPS_PADDR);
+
 	dbgfs_set_targets(ctx, 3, NULL);
 
 	/* Put valid inputs and check the results */
_
