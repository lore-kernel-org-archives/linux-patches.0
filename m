Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A7725EF9C;
	Wed, 25 Feb 2026 01:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983506; cv=none; b=lTIrokO3SiNLZJMUBkvJm55y6rTBSd4liFT54duADFMU+z5Qx5juY3lq9J2sj4JxSTLEkd8GK0EOHQb4swKJIvxsOvFJ8as8H/YB7HTH8BNif/nkuCbJBfnbJcmYnrcadZ/UvpI5ZdGo9mreNH0W2XkugMWajICGzwPHmxKj0co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983506; c=relaxed/simple;
	bh=jL45FUOoFl/pQMaqFxPJOkJyw48fCkAo1y6NkXwW1rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dhcg032LSSP2vDf+f2ec1Wiw2581qUxZNRhhmgjQqne3NRHD6C/N/XNhENpWcAQFjD6aEYj8a3MvdUEg3L07dcGYqeRT0MhSkrPkPGD2j0fePttEzEPcVVMFhBK5EwlMRoIhwFnLxecP5G2+jR7qPd2PoksldIBWornxty3R7qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzpTP9Q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzpTP9Q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7253C116D0;
	Wed, 25 Feb 2026 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983506;
	bh=jL45FUOoFl/pQMaqFxPJOkJyw48fCkAo1y6NkXwW1rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzpTP9Q06aigZv+XY+u+DkAjG6f5obrUjHU96Oxbh/WnYgy6al8KL34ZqkpEjGGrU
	 E1YEROk2w8AvQdqrFwBsE45Wb0XPGgS9yd0354K4Ohwem/sfXV1Xyu/Tf2dQa4Ga8N
	 fncC0Cyzl+HatzSPJueqVwsHOUoy6V3ZZtBO2pvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 613/781] io_uring: delay sqarray static branch disablement
Date: Tue, 24 Feb 2026 17:22:02 -0800
Message-ID: <20260225012414.834868991@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 56112578c71213a10c995a56835bddb5e9ab1ed0 ]

io_key_has_sqarray static branch can be easily switched on/off by the
user every time patching the kernel. That can be very disruptive as it
might require heavy synchronisation across all CPUs. Use deferred static
keys, which can rate-limit it by deferring, batching and potentially
effectively eliminating dec+inc pairs.

Fixes: 9b296c625ac1d ("io_uring: static_key for !IORING_SETUP_NO_SQARRAY")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8aa671ba43474..63efd60829f37 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -138,7 +138,7 @@
 static void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags);
 static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
-static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
+static __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(io_key_has_sqarray, HZ);
 
 struct kmem_cache *req_cachep;
 static struct workqueue_struct *iou_wq __ro_after_init;
@@ -2375,7 +2375,7 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	unsigned mask = ctx->sq_entries - 1;
 	unsigned head = ctx->cached_sq_head++ & mask;
 
-	if (static_branch_unlikely(&io_key_has_sqarray) &&
+	if (static_branch_unlikely(&io_key_has_sqarray.key) &&
 	    (!(ctx->flags & IORING_SETUP_NO_SQARRAY))) {
 		head = READ_ONCE(ctx->sq_array[head]);
 		if (unlikely(head >= ctx->sq_entries)) {
@@ -2867,7 +2867,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_rings_free(ctx);
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		static_branch_dec(&io_key_has_sqarray);
+		static_branch_slow_dec_deferred(&io_key_has_sqarray);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -3600,7 +3600,7 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	ctx->clock_offset = 0;
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		static_branch_inc(&io_key_has_sqarray);
+		static_branch_deferred_inc(&io_key_has_sqarray);
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
-- 
2.51.0



