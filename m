Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C26384CED;
	Sat, 17 Oct 2026 16:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254093; cv=none; b=RBf6+aVz3fBlS9oEkQnAIXElOOZ75na1dtWg4HPCFaG8sgHFQ3FllK9JX6DPgiEqTECj/THzOKhfNk/8za/ZdzD0wI/PstwN+K1OyuCEh11viYPdyq51ErppSpTJhvNL8iTp+q4bIBIIn0Y/OnPk7FCkEMWGivUGPoe0qS8w4mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254093; c=relaxed/simple;
	bh=uNVLry0Z0f/LJaXbzfxbcaKVqR4DejZcgLpF9sfiJmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6M14puevoq4en6RXSDLkWClHGG0JZvg1XOHrZPoiLLVJNt/AqUn3iyolkHsbrbqbvTlJh3tY9lhUU0Ka/wLOyVGmuOOBAONy9Z2Lxb5+N4j/Vd+4orbvU9hWsK1WeoNxERBbBMSDJXewB2Iur8+5+diFGnXm4yE/DCWlStijfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptWM/wKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptWM/wKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC081F000C4;
	Sat, 17 Oct 2026 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254091;
	bh=ib3nJf+c9h+ufMg/ewLH3/GwGJt2KuHhoPv5Vt1y87c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptWM/wKB8Jdt3Ws3KiebDnrMX8uaDa1PFvGYqygKB0hIWB4vJxWwwizimgvkxBqsD
	 LWmpbWy5NPEiqy8MtT4Cu/AtEd3ytsdKk3zYFqMgThOZ5Qq2n+dXtdjNo3jzFznAW5
	 VtpOe2Xoj9HnYQe5lEy518hL0m6ppejERMDCf188=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Langlois <olivier@trillion01.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/869] io_uring/napi: improve __io_napi_add
Date: Sat, 17 Oct 2026 17:52:52 +0200
Message-ID: <20261017160045.565098952@linuxfoundation.org>
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

[ Upstream commit a5e26f49fef9485bc4ae24666d984a6de11e058c ]

1. move the sock->sk pointer validity test outside the function to
   avoid the function call overhead and to make the function more
   more reusable
2. change its name to __io_napi_add_id to be more precise about it is
   doing
3. return an error code to report errors

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Link: https://lore.kernel.org/r/d637fa3b437d753c0f4e44ff6a7b5bf2c2611270.1728828877.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: df8599ee18c0 ("io_uring/napi: cap busy_poll_to 10 msec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 19 ++++++-------------
 io_uring/napi.h |  6 +++---
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 921de9de8d753..5e2299e7ff8ee 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -38,22 +38,14 @@ static inline ktime_t net_to_ktime(unsigned long t)
 	return ns_to_ktime(t << 10);
 }
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
+int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id)
 {
 	struct hlist_head *hash_list;
-	unsigned int napi_id;
-	struct sock *sk;
 	struct io_napi_entry *e;
 
-	sk = sock->sk;
-	if (!sk)
-		return;
-
-	napi_id = READ_ONCE(sk->sk_napi_id);
-
 	/* Non-NAPI IDs can be rejected. */
 	if (napi_id < MIN_NAPI_ID)
-		return;
+		return -EINVAL;
 
 	hash_list = &ctx->napi_ht[hash_min(napi_id, HASH_BITS(ctx->napi_ht))];
 
@@ -62,13 +54,13 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	if (e) {
 		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
 		rcu_read_unlock();
-		return;
+		return -EEXIST;
 	}
 	rcu_read_unlock();
 
 	e = kmalloc(sizeof(*e), GFP_NOWAIT);
 	if (!e)
-		return;
+		return -ENOMEM;
 
 	e->napi_id = napi_id;
 	e->timeout = jiffies + NAPI_TIMEOUT;
@@ -77,12 +69,13 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	if (unlikely(io_napi_hash_find(hash_list, napi_id))) {
 		spin_unlock(&ctx->napi_lock);
 		kfree(e);
-		return;
+		return -EEXIST;
 	}
 
 	hlist_add_tail_rcu(&e->node, hash_list);
 	list_add_tail_rcu(&e->list, &ctx->napi_list);
 	spin_unlock(&ctx->napi_lock);
+	return 0;
 }
 
 static void __io_napi_remove_stale(struct io_ring_ctx *ctx)
diff --git a/io_uring/napi.h b/io_uring/napi.h
index fd275ef0456d1..4ae622f37b302 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -15,7 +15,7 @@ void io_napi_free(struct io_ring_ctx *ctx);
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
+int __io_napi_add_id(struct io_ring_ctx *ctx, unsigned int napi_id);
 
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq);
 int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
@@ -48,8 +48,8 @@ static inline void io_napi_add(struct io_kiocb *req)
 		return;
 
 	sock = sock_from_file(req->file);
-	if (sock)
-		__io_napi_add(ctx, sock);
+	if (sock && sock->sk)
+		__io_napi_add_id(ctx, READ_ONCE(sock->sk->sk_napi_id));
 }
 
 #else
-- 
2.53.0



