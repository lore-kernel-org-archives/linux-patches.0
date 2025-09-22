Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474702820D1;
	Mon, 22 Sep 2025 19:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569993; cv=none; b=OLrHnn4Z7/SP4TF3kLxE4WzOD4r4l63wox6Tz1gZ1osGgtxUGPZEo+4nHQS3NsaawoIo7He8/xXhhjQbwYO5zmAnXkX+Tf0NyoP6ssfVAaLBenMAv4WG5QBprZoEU55wFzlj4tJpplBgffo3ebqIgM0UixDKfc+c9bjSbqXE7oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569993; c=relaxed/simple;
	bh=JUkRALgoD7g31otr6fCeyYF8/SzRspztPgbzyekBliU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wu7yXB1iy76s604ZBrK42zub9nikgfvrWwAIdegiQqIQdKIMIrO3EStEe171JMO38aC/8caUIS8skfdBKX31+qlKUUKTnoGBye0WJdq1TI+G6NWG0mUpzFidd0MVddFdw1YtBg1CTfRgu0HISHwCy3SiJUnwOECi0VIaGlkiobM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVJ7c59a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVJ7c59a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39CCC4CEF0;
	Mon, 22 Sep 2025 19:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569993;
	bh=JUkRALgoD7g31otr6fCeyYF8/SzRspztPgbzyekBliU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVJ7c59agkGvppwpTrlBcSLCByCXM23/JB5ou7Z5C3966ww3ln2BrAwCPDlvE0tyq
	 ORXHkLrjXDxHCNf8B6ws9glZ1BZG7JeasYMWnJ3alnfqk10+mUJOe5opPRwIFVeTkE
	 U3N6ytAo9aM2fokbG/KyG8nDDOf/IFRPBsU7l4Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+baa2e0f4e02df602583e@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 069/105] io_uring/msg_ring: kill alloc_cache for io_kiocb allocations
Date: Mon, 22 Sep 2025 21:29:52 +0200
Message-ID: <20250922192410.714652718@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit df8922afc37aa2111ca79a216653a629146763ad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 ---
 io_uring/io_uring.c            |    5 -----
 io_uring/msg_ring.c            |   24 ++----------------------
 3 files changed, 2 insertions(+), 30 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -400,9 +400,6 @@ struct io_ring_ctx {
 	struct callback_head		poll_wq_task_work;
 	struct list_head		defer_list;
 
-	struct io_alloc_cache		msg_cache;
-	spinlock_t			msg_lock;
-
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -316,9 +316,6 @@ static __cold struct io_ring_ctx *io_rin
 			    sizeof(struct io_async_rw));
 	ret |= io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct uring_cache));
-	spin_lock_init(&ctx->msg_lock);
-	ret |= io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_kiocb));
 	ret |= io_futex_cache_init(ctx);
 	if (ret)
 		goto free_ref;
@@ -358,7 +355,6 @@ err:
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
-	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
@@ -2743,7 +2739,6 @@ static __cold void io_ring_ctx_free(stru
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
-	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -11,7 +11,6 @@
 #include "io_uring.h"
 #include "rsrc.h"
 #include "filetable.h"
-#include "alloc_cache.h"
 #include "msg_ring.h"
 
 /* All valid masks for MSG_RING */
@@ -76,13 +75,7 @@ static void io_msg_tw_complete(struct io
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
 
@@ -104,19 +97,6 @@ static int io_msg_remote_post(struct io_
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
 static int io_msg_data_remote(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -124,7 +104,7 @@ static int io_msg_data_remote(struct io_
 	struct io_kiocb *target;
 	u32 flags = 0;
 
-	target = io_msg_get_kiocb(req->ctx);
+	target = kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
 	if (unlikely(!target))
 		return -ENOMEM;
 


