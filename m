Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4906F38F658;
	Sat, 17 Oct 2026 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252624; cv=none; b=FxaL50OCmfmMiZKvVw/9M+0UxJTTxgtxXAZeKjjJy2GIBFZMgZ/6cuR8VfEIBpgJywACKpI6OJiXWGi/vVFEUSggROewjz2NebNr88xyd7WGNMbVO4ZIhWIeFUvPy/biQivCCHLAmpYZSEXQlbfNAUpJ5IfvbUOzvrRdLt4Mp/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252624; c=relaxed/simple;
	bh=7lkQMLQ7HvFsh1KRMuvnzUir6z2QzJBb11TMfpsoIMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBGqb09yelzw0NXlhO9dzpXtcylJo14jDhjYzTqYk8H8xeXUd5tFCPLJvhRism0gnIpB7zZ0PuGT8oEFxE8HOkwbmDfZW+yOK5OcpD0t4BQCibgf7ti027csh27Fxr4TNkOmrjWAujKSEs9ornBpTqhIrbcUoglk1zHGOmvq7/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+diYYUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+diYYUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9338F1F000C4;
	Sat, 17 Oct 2026 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252623;
	bh=+sLcg6iFYRzYcHugwhnlz+HAqHmcVLCnq5XhuPh57P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+diYYUU8j9ZbbWf9pDyLRizwPgyQZvj/oxoaFUB1oGHu0EeJFZGIh045ahnsvYpq
	 HPRjy8b0u8MLWsPOk9vQsLTjpEoGetNZyBwQBhk7uiAVukRbzOotbpf8legl3ISfle
	 ukp/QxvnQaAKkk6hs4eOsQkkge1M8+bv7aq5aJ7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 41/52] mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset
Date: Sat, 17 Oct 2026 17:54:42 +0200
Message-ID: <20261017155106.166643921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 69714a74c19f5ae8b21e25558d62d893d48a3f18 ]

damos_walk() request is canceled after damon_ctx->kdamond is reset.  This
can make weird situations where damon_is_running() returns false but the
DAMON context has the damos_walk() request linked.  There was a similar
situation for damon_call() requests handling [1], which _was_ able to
cause a racy use-after-free bug.  Unlike the case of damon_call(), because
damos_walk() is always synchronously handled and allows only single
request at time, there is no such problematic race cases.  But, keeping it
as is could stem another subtle race condition bug in future.

Avoid that by cancelling the requests before the ->kdamond reset.  Note
that this change also makes all damon_ctx dependent resource cleanups
consistently done before the damon_ctx->kdamond reset.

Link: https://lkml.kernel.org/r/20260117175256.82826-4-sj@kernel.org
Link: https://lore.kernel.org/20251230014532.47563-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 016d38c127d61..c77d17cb7a68b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2838,14 +2838,13 @@ static int kdamond_fn(void *data)
 	ctx->call_controls_obsolete = true;
 	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
+	damos_walk_cancel(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
-	damos_walk_cancel(ctx);
-
 	mutex_lock(&damon_lock);
 	nr_running_ctxs--;
 	if (!nr_running_ctxs && running_exclusive_ctxs)
-- 
2.53.0



