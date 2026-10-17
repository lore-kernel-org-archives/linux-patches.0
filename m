Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1981038AC99;
	Sat, 17 Oct 2026 16:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254096; cv=none; b=dIUgaBcdjsSJ9HFwW144IAAnrSkiSypvUBta2T4ZTlxXNBs9zLkPz/5bKwriWoDBOASx+ral1E5ui4et1DeDT+dkaWOeffG3IxaT77N6GPMu/rYV5ufZiNroHx0Hb/1IlTKFMVeUCqzm9PRRpmBCd/78r8wGpElEEiZf4AHuh6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254096; c=relaxed/simple;
	bh=+T6Uv2wo61XzVjM7eYOHsOTGTC6auLwzHRmh/yEY4gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWBkLA5hKbBwnTz91cmsAdny2mwpqDdQjXEu3o0DatAncPkTKfJNnN6ThwUD7voEbYJEMqsZn8J97e4GhAcsLie5H4rtMUZolKFoNS/2RG9NQ5EmJeZoFtFjgQS+S+ZgCLt9EvaT8+yWZlzXAk88Ap9pLImKwsNYPs545wIIM1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaUFWCXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaUFWCXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6288F1F000C4;
	Sat, 17 Oct 2026 16:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254095;
	bh=QWrAOgCXHuPZjIOaCqEDSC2gAC/mAEiJBorZiIsxVJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaUFWCXAFvI5b/IP1PKQYjgnCuTpp3GD31KMnGB6HyDYdd+vWmvZC+eOnNqbT6leX
	 Cl42gGf5LRf7vltvAFW2EDJDLs8cJum5dvaw7UBQ+CAMjwxDf9w/P3YPPOJH3u8Ho1
	 1yrSWfGSh5a052T6FuNg4JPHB/QPPN6Y9bnynCCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Langlois <olivier@trillion01.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/869] io_uring/napi: Use lock guards
Date: Sat, 17 Oct 2026 17:52:53 +0200
Message-ID: <20261017160045.591007653@linuxfoundation.org>
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

From: Olivier Langlois <olivier@trillion01.com>

[ Upstream commit db1e1adf6f993b1c2cef605d86eff709a8db5052 ]

Convert napi locks to use the shiny new Scope-Based Resource Management
machinery.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Link: https://lore.kernel.org/r/2680ca47ee183cfdb89d1a40c84d349edeb620ab.1728828877.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: df8599ee18c0 ("io_uring/napi: cap busy_poll_to 10 msec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 5e2299e7ff8ee..6d5fdd397f2f4 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -49,14 +49,13 @@ int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 
 	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
 
-	rcu_read_lock();
-	e = io_napi_hash_find(hash_list, napi_id);
-	if (e) {
-		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
-		rcu_read_unlock();
-		return -EEXIST;
+	scoped_guard(rcu) {
+		e = io_napi_hash_find(hash_list, napi_id);
+		if (e) {
+			WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
+			return -EEXIST;
+		}
 	}
-	rcu_read_unlock();
 
 	e = kmalloc(sizeof(*e), GFP_NOWAIT);
 	if (!e)
@@ -65,6 +64,10 @@ int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 	e->napi_id = napi_id;
 	e->timeout = jiffies + NAPI_TIMEOUT;
 
+	/*
+	 * guard(spinlock) is not used to manually unlock it before calling
+	 * kfree()
+	 */
 	spin_lock(&ctx->napi_lock);
 	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
 		spin_unlock(&ctx->napi_lock);
@@ -82,7 +85,7 @@ static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 {
 	struct io_napi_entry *e;
 
-	spin_lock(&ctx->napi_lock);
+	guard(spinlock)(&ctx->napi_lock);
 	/*
 	 * list_for_each_entry_safe() is not required as long as:
 	 * 1. list_del_rcu() does not reset the deleted node next pointer
@@ -96,7 +99,6 @@ static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
 			kfree_rcu(e, rcu);
 		}
 	}
-	spin_unlock(&ctx->napi_lock);
 }
 
 static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is_stale)
@@ -168,11 +170,12 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 	if (list_is_singular(&ctx->napi_list))
 		loop_end_arg = iowq;
 
-	rcu_read_lock();
-	do {
-		is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
-	} while (!io_napi_busy_loop_should_end(iowq, start_time) && !loop_end_arg);
-	rcu_read_unlock();
+	scoped_guard(rcu) {
+		do {
+			is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
+		} while (!io_napi_busy_loop_should_end(iowq, start_time) &&
+			 !loop_end_arg);
+	}
 
 	io_napi_remove_stale(ctx, is_stale);
 }
@@ -203,13 +206,12 @@ void io_napi_free(struct io_ring_ctx *ctx)
 {
 	struct io_napi_entry *e;
 
-	spin_lock(&ctx->napi_lock);
+	guard(spinlock)(&ctx->napi_lock);
 	list_for_each_entry(e, &ctx->napi_list, list) {
 		hash_del_rcu(&e->node);
 		kfree_rcu(e, rcu);
 	}
 	INIT_LIST_HEAD_RCU(&ctx->napi_list);
-	spin_unlock(&ctx->napi_lock);
 }
 
 /*
@@ -305,9 +307,9 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 	if (list_empty_careful(&ctx->napi_list))
 		return 0;
 
-	rcu_read_lock();
-	is_stale = __io_napi_do_busy_loop(ctx, NULL);
-	rcu_read_unlock();
+	scoped_guard(rcu) {
+		is_stale = __io_napi_do_busy_loop(ctx, NULL);
+	}
 
 	io_napi_remove_stale(ctx, is_stale);
 	return 1;
-- 
2.53.0



