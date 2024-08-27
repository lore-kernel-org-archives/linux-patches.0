Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA501E520;
	Tue, 27 Aug 2024 15:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771305; cv=none; b=fEmVI4c3lMsimTAa3MMwGE4MWOBh26KozE1FZ0dHQiQKDvB7fVfkQTl+Ox4o1fDSBl6hNP/ZPi5sEJ0wu+OyjoSiEubcWk+5VvYT91muXNe+uLzwaOypJUSdeG+0zvgnp7VAF1QdJNWKEO9kNDDOY6GAzNpwKT/r0N0u5wqGdkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771305; c=relaxed/simple;
	bh=vYtCjiz820ZLc63TBCbkpY6/WXJMYtOr5GAoFpIcyXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+vv1xl2VsvgRWpMgUtXQ4JFlqlXyw/nCsZgX+AY4YgxdL4Xtqy8lzK3NNoGbPSyI2HMb77x/Cd3YPr7cV7n8x+3vyoOp0pQPNtAIa5FgfoYKiE+XuVQIQBuuY3GwqgvRPNduhjLW2UkYByjghnEjxkmEVYuwM9GYKyBpRnHffQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CF8Y+Pmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CF8Y+Pmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C8DC61074;
	Tue, 27 Aug 2024 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771305;
	bh=vYtCjiz820ZLc63TBCbkpY6/WXJMYtOr5GAoFpIcyXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CF8Y+Pmwr+mBTQbfNv1I+R9/AAbqxSzxdWRcsqIpELcKW6mabB8u74WZrdElcvonY
	 6MxwYBw2Vdgkdn8TuUp1sB0nt1wWpagmwfWVxwDHZ8UJbeiGJRxRcTia5j93HdvJca
	 c20kH5IqMMiCULimDNoJoHAkcA5UK2QA5OHw83Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Langlois <olivier@trillion01.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 131/273] io_uring/napi: check napi_enabled in io_napi_add() before proceeding
Date: Tue, 27 Aug 2024 16:37:35 +0200
Message-ID: <20240827143838.388989958@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Langlois <olivier@trillion01.com>

[ Upstream commit 84f2eecf95018386c145ada19bb45b03bdb80d9e ]

doing so avoids the overhead of adding napi ids to all the rings that do
not enable napi.

if no id is added to napi_list because napi is disabled,
__io_napi_busy_loop() will not be called.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Fixes: b4ccc4dd1330 ("io_uring/napi: enable even with a timeout of 0")
Link: https://lore.kernel.org/r/bd989ccef5fda14f5fd9888faf4fefcf66bd0369.1723400131.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 2 +-
 io_uring/napi.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 6bdb267e9c33c..ab5d68d4440c4 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -311,7 +311,7 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 {
 	iowq->napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
 
-	if (!(ctx->flags & IORING_SETUP_SQPOLL) && ctx->napi_enabled)
+	if (!(ctx->flags & IORING_SETUP_SQPOLL))
 		io_napi_blocking_busy_loop(ctx, iowq);
 }
 
diff --git a/io_uring/napi.h b/io_uring/napi.h
index babbee36cd3eb..341d010cf66bc 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -55,7 +55,7 @@ static inline void io_napi_add(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct socket *sock;
 
-	if (!READ_ONCE(ctx->napi_busy_poll_dt))
+	if (!READ_ONCE(ctx->napi_enabled))
 		return;
 
 	sock = sock_from_file(req->file);
-- 
2.43.0



