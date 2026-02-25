Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA42B2D839C;
	Wed, 25 Feb 2026 06:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002700; cv=none; b=SiWnKfkquD5nf7ROPb/uoqTx+SqWyARjnftuxKIjDJoCOCoLIWdXmhlvl1KHRuxQBiafioXwSImXZivq/2CeWVhr2xMyinkbVtKDMkZDLuUohPx6zWHeM04MNXkrpwT2BD4Wt55SWANKCrihdwnH1f/pR/iUKlYRc/gsMLW4nWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002700; c=relaxed/simple;
	bh=1guSb50ERy9+YY/DGIiMXrm2FmcZ1FK7HhaThzEkWAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN7ljFNLPnWZ020SEUn4+H18C3mE77BO0YG1ZTSic+q4CWO4nh8FzBPmfCuKd+9RIyjFaF29nzMgeFUZnVNIEDqdAN+wunUt6oY7wIhRYzp4SKst4ySL+uwFu5m2gPM7OlCMLsye61E4XZEi/w674y/KP4IuMp971T0kwJzqKzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnWMvzcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnWMvzcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B9DC116D0;
	Wed, 25 Feb 2026 06:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002700;
	bh=1guSb50ERy9+YY/DGIiMXrm2FmcZ1FK7HhaThzEkWAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnWMvzcQybIL9RX1J8hhbtr5iDK3QJ04ig23ixvbKRdojlDobh07IdQLZKAVf33Mm
	 Al9e6Mztel6n6P2qSV50/A2XCZipPGPgllWy8DZjQzG/bP+uyu9kai4IQX+uyRGRUC
	 cWdC2BfzK0Ec3K1A+RoLp6UqdXquj2q43+wDKRqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 498/641] io_uring: delay sqarray static branch disablement
Date: Tue, 24 Feb 2026 17:23:44 -0800
Message-ID: <20260225012400.586455113@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index d8a35a49dd1ac..65af47b9135b8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -148,7 +148,7 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags);
 static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
-static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
+static __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(io_key_has_sqarray, HZ);
 
 struct kmem_cache *req_cachep;
 static struct workqueue_struct *iou_wq __ro_after_init;
@@ -2390,7 +2390,7 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	unsigned mask = ctx->sq_entries - 1;
 	unsigned head = ctx->cached_sq_head++ & mask;
 
-	if (static_branch_unlikely(&io_key_has_sqarray) &&
+	if (static_branch_unlikely(&io_key_has_sqarray.key) &&
 	    (!(ctx->flags & IORING_SETUP_NO_SQARRAY))) {
 		head = READ_ONCE(ctx->sq_array[head]);
 		if (unlikely(head >= ctx->sq_entries)) {
@@ -2869,7 +2869,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_rings_free(ctx);
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		static_branch_dec(&io_key_has_sqarray);
+		static_branch_slow_dec_deferred(&io_key_has_sqarray);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -3817,7 +3817,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->clock_offset = 0;
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		static_branch_inc(&io_key_has_sqarray);
+		static_branch_deferred_inc(&io_key_has_sqarray);
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
-- 
2.51.0



