Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFCF38654F;
	Sat, 17 Oct 2026 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254099; cv=none; b=gaOTI9MUXEpbtdy55y8ud6nHnYB6UkWYqLx9FoX+ZGD71fFX3yzgrC6KRHZb+dN74GtFJiGdYyKO84IM4nobI+JQQiWgqhPuo4WEV3d7/fvvbRvDQtV7agiTUOFzNQioU5Nl86XhLlXRdxzWfcwdW5TxWxv1o0Zdx/6QkLIk7p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254099; c=relaxed/simple;
	bh=bCahez76MnYa1JPcVecP2eiV8mr2ypP9j2xNc10zK0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0Uu599wQPecfgYecYcO2Ay532d4C5CkFj83BsiVLzdpqsQTaczbLEbT1OjWoo8PhaZjuqJysomlApaTS9RxCOTkK7+4AFp0qCeKvvWoT+GP6CcadSMDvOR0OnidmJxOZUhjpjgfWi/mCLBP19Q3r7kMcQlz/4ZVSDner3IrR/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0zXj8cw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0zXj8cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B511F000C4;
	Sat, 17 Oct 2026 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254098;
	bh=vyu5e3D5bBxZscKS7aRnQryx2pq32X8b5MF9cbZmLL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0zXj8cw5hgpzO+et+Lhe6SlSATYskL7LSsqF51lMixnxvMZl00+4OWNWWUlqUv6G
	 6fwT3InQgVTI9XtMQ2Fv1HgyNX+l61vQxW1krtthO3QYpHtC/3PCa/gBYNGXcqv3Sa
	 iRNS0aeivTP7d1QW1IVgV7U+yrUt0oXmsJBVQ3jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Langlois <olivier@trillion01.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/869] io_uring/napi: clean up __io_napi_do_busy_loop
Date: Sat, 17 Oct 2026 17:52:54 +0200
Message-ID: <20261017160045.617169710@linuxfoundation.org>
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

[ Upstream commit 71afd926f292bb8f3ca86e6c3c40123037f109c6 ]

__io_napi_do_busy_loop now requires to have loop_end in its parameters.
This makes the code cleaner and also has the benefit of removing a
branch since the only caller not passing NULL for loop_end_arg is also
setting the value conditionally.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Link: https://lore.kernel.org/r/d5b9bb91b1a08fff50525e1c18d7b4709b9ca100.1728828877.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: df8599ee18c0 ("io_uring/napi: cap busy_poll_to 10 msec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 6d5fdd397f2f4..1de1543d80344 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -137,15 +137,12 @@ static bool io_napi_busy_loop_should_end(void *data,
 }
 
 static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
+				   bool (*loop_end)(void *, unsigned long),
 				   void *loop_end_arg)
 {
 	struct io_napi_entry *e;
-	bool (*loop_end)(void *, unsigned long) = NULL;
 	bool is_stale = false;
 
-	if (loop_end_arg)
-		loop_end = io_napi_busy_loop_should_end;
-
 	list_for_each_entry_rcu(e, &ctx->napi_list, list) {
 		napi_busy_loop_rcu(e->napi_id, loop_end, loop_end_arg,
 				   ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
@@ -161,18 +158,22 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 				       struct io_wait_queue *iowq)
 {
 	unsigned long start_time = busy_loop_current_time();
+	bool (*loop_end)(void *, unsigned long) = NULL;
 	void *loop_end_arg = NULL;
 	bool is_stale = false;
 
 	/* Singular lists use a different napi loop end check function and are
 	 * only executed once.
 	 */
-	if (list_is_singular(&ctx->napi_list))
+	if (list_is_singular(&ctx->napi_list)) {
+		loop_end = io_napi_busy_loop_should_end;
 		loop_end_arg = iowq;
+	}
 
 	scoped_guard(rcu) {
 		do {
-			is_stale = __io_napi_do_busy_loop(ctx, loop_end_arg);
+			is_stale = __io_napi_do_busy_loop(ctx, loop_end,
+							  loop_end_arg);
 		} while (!io_napi_busy_loop_should_end(iowq, start_time) &&
 			 !loop_end_arg);
 	}
@@ -308,7 +309,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 		return 0;
 
 	scoped_guard(rcu) {
-		is_stale = __io_napi_do_busy_loop(ctx, NULL);
+		is_stale = __io_napi_do_busy_loop(ctx, NULL, NULL);
 	}
 
 	io_napi_remove_stale(ctx, is_stale);
-- 
2.53.0



