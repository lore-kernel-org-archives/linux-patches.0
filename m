Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757F318C2C;
	Mon, 22 Sep 2025 19:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570402; cv=none; b=kC1mYm1bCk7B1JnUvdOD+LIMFhvHfeX4o6b//Hp5xBZC0yXRP8ZXzGlLkulWDdOtyf0hl3dd7l0DIa5ij/41ADaz+QxTMhIBRsqmkKfUC4DAbh3LwwegL+lU58jARVpAor99dqnWFS75xTPPGX2Sbz5bUhucgVLtvKpH69xS+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570402; c=relaxed/simple;
	bh=W8Z+wA/e05txjt30BPMO2CVc14CffzdbyM9GC4W6Z4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc3rslAzepbBhTo94jAL92tqEkt6g42SZaH7wxwtxw+mMlCsErgQPgXbs8QVpUmwGcBlkj6y+ofNUrAR6f8ZNh6syqRGJ1aFUZPvdhCmv1OorWlsWl45m1c8gb8q6SUW2VXGentIdWJF2dbToyeVnHd3eO9n/TLj75/i2HWHtmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSuv/nhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSuv/nhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0517EC4CEF0;
	Mon, 22 Sep 2025 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570402;
	bh=W8Z+wA/e05txjt30BPMO2CVc14CffzdbyM9GC4W6Z4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSuv/nhwkZJzQKIhrZ8j890xFiutPP3ExVJrM8mgn+tVx1+v4LFhcY8gnYQlGg9dP
	 hdpQBUR+trU4TWQ03G68Prja/2lkpL6kli8LK+fvZFMiCItfn8LA9yx2QqctFooUc7
	 d/ILtx/K8xWAhrpwKqS6n7O3feq7vzWcMOi5rasU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+baa2e0f4e02df602583e@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 135/149] io_uring/msg_ring: kill alloc_cache for io_kiocb allocations
Date: Mon, 22 Sep 2025 21:30:35 +0200
Message-ID: <20250922192416.272336806@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit df8922afc37aa2111ca79a216653a629146763ad ]

A recent commit:

fc582cd26e88 ("io_uring/msg_ring: ensure io_kiocb freeing is deferred for RCU")

fixed an issue with not deferring freeing of io_kiocb structs that
msg_ring allocates to after the current RCU grace period. But this only
covers requests that don't end up in the allocation cache. If a request
goes into the alloc cache, it can get reused before it is sane to do so.
A recent syzbot report would seem to indicate that there's something
there, however it may very well just be because of the KASAN poisoning
that the alloc_cache handles manually.

Rather than attempt to make the alloc_cache sane for that use case, just
drop the usage of the alloc_cache for msg_ring request payload data.

Fixes: 50cf5f3842af ("io_uring/msg_ring: add an alloc cache for io_kiocb entries")
Link: https://lore.kernel.org/io-uring/68cc2687.050a0220.139b6.0005.GAE@google.com/
Reported-by: syzbot+baa2e0f4e02df602583e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/io_uring_types.h |  3 ---
 io_uring/io_uring.c            |  4 ----
 io_uring/msg_ring.c            | 24 ++----------------------
 3 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a7efcec2e3d08..215ff20affa33 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -418,9 +418,6 @@ struct io_ring_ctx {
 	struct list_head		defer_list;
 	unsigned			nr_drained;
 
-	struct io_alloc_cache		msg_cache;
-	spinlock_t			msg_lock;
-
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index aa8787777f29a..eaa5410e5a70a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -290,7 +290,6 @@ static void io_free_alloc_caches(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->cmd_cache, io_cmd_cache_free);
-	io_alloc_cache_free(&ctx->msg_cache, kfree);
 	io_futex_cache_free(ctx);
 	io_rsrc_cache_free(ctx);
 }
@@ -337,9 +336,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ret |= io_alloc_cache_init(&ctx->cmd_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_cmd),
 			    sizeof(struct io_async_cmd));
-	spin_lock_init(&ctx->msg_lock);
-	ret |= io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_kiocb), 0);
 	ret |= io_futex_cache_init(ctx);
 	ret |= io_rsrc_cache_init(ctx);
 	if (ret)
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 4c2578f2efcb0..5e5b94236d720 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -11,7 +11,6 @@
 #include "io_uring.h"
 #include "rsrc.h"
 #include "filetable.h"
-#include "alloc_cache.h"
 #include "msg_ring.h"
 
 /* All valid masks for MSG_RING */
@@ -76,13 +75,7 @@ static void io_msg_tw_complete(struct io_kiocb *req, io_tw_token_t tw)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
-	if (spin_trylock(&ctx->msg_lock)) {
-		if (io_alloc_cache_put(&ctx->msg_cache, req))
-			req = NULL;
-		spin_unlock(&ctx->msg_lock);
-	}
-	if (req)
-		kfree_rcu(req, rcu_head);
+	kfree_rcu(req, rcu_head);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -104,26 +97,13 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return 0;
 }
 
-static struct io_kiocb *io_msg_get_kiocb(struct io_ring_ctx *ctx)
-{
-	struct io_kiocb *req = NULL;
-
-	if (spin_trylock(&ctx->msg_lock)) {
-		req = io_alloc_cache_get(&ctx->msg_cache);
-		spin_unlock(&ctx->msg_lock);
-		if (req)
-			return req;
-	}
-	return kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
-}
-
 static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
 			      struct io_msg *msg)
 {
 	struct io_kiocb *target;
 	u32 flags = 0;
 
-	target = io_msg_get_kiocb(target_ctx);
+	target = kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO)  ;
 	if (unlikely(!target))
 		return -ENOMEM;
 
-- 
2.51.0



