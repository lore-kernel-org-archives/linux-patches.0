Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAF61FBCAD;
	Wed,  6 Nov 2024 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897694; cv=none; b=tzNnZpBqT2dFH56hll7HcaPGoxgA5GezcaHL1BJZcU+6YWeF4fFbg5poemUmsc/5n9XAL8B7MnqC6ou2bxZl7kNW7mp3Z1NmW0AxK6a6AWwmVn7KC89bljifcSyGemMUGDQhgWMiqAq2soYHZ6oJvSa9WZ3KhapCalxupJ2SKKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897694; c=relaxed/simple;
	bh=a57WO3XFVYipOE1xMoxmC7np56AjB+c03WJ+zoPp8V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtkjVe3yCRciGmlYJcN9vn5FfgyU6EkMG5EN3s/Rfixoi2tdTGA6lVt5mb1kT1rdeJikKhS1seRZEwPeOb2wyaB0xIIHXKTFIDgGNUp4762CXVLfQDNcf33bGTkq+FhbXAJNOcd+KtqPIfS7TDUk4x6ct/+H+GbbI3BsnYkZJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bgb83CL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bgb83CL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C880C4CECD;
	Wed,  6 Nov 2024 12:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897693;
	bh=a57WO3XFVYipOE1xMoxmC7np56AjB+c03WJ+zoPp8V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bgb83CL1vPtQFaWlnyPfOuxDwfX3lZYqravCl6axzTYQ2Gmne+TDuSddRtcMeedtP
	 /0Kcn0+O1+yUFRWEP/Pumq1dFkh1FhjAcaYx/1ZUR0U9D6LXyqTK+51hMUmhWUxe99
	 nPg7TKwmcp4CGdg356gVUrekWdkt/0cTduzbfVfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 139/151] io_uring: always lock __io_cqring_overflow_flush
Date: Wed,  6 Nov 2024 13:05:27 +0100
Message-ID: <20241106120312.678485996@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 8d09a88ef9d3cb7d21d45c39b7b7c31298d23998 upstream.

Conditional locking is never great, in case of
__io_cqring_overflow_flush(), which is a slow path, it's not justified.
Don't handle IOPOLL separately, always grab uring_lock for overflow
flushing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/162947df299aa12693ac4b305dacedab32ec7976.1712708261.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -667,6 +667,8 @@ static void io_cqring_overflow_kill(stru
 	struct io_overflow_cqe *ocqe;
 	LIST_HEAD(list);
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	spin_lock(&ctx->completion_lock);
 	list_splice_init(&ctx->cq_overflow_list, &list);
 	clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
@@ -683,6 +685,8 @@ static void __io_cqring_overflow_flush(s
 {
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (__io_cqring_events(ctx) == ctx->cq_entries)
 		return;
 
@@ -727,12 +731,9 @@ static void __io_cqring_overflow_flush(s
 
 static void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 {
-	/* iopoll syncs against uring_lock, not completion_lock */
-	if (ctx->flags & IORING_SETUP_IOPOLL)
-		mutex_lock(&ctx->uring_lock);
+	mutex_lock(&ctx->uring_lock);
 	__io_cqring_overflow_flush(ctx);
-	if (ctx->flags & IORING_SETUP_IOPOLL)
-		mutex_unlock(&ctx->uring_lock);
+	mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_cqring_overflow_flush(struct io_ring_ctx *ctx)
@@ -1611,6 +1612,8 @@ static int io_iopoll_check(struct io_rin
 	unsigned int nr_events = 0;
 	unsigned long check_cq;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
 


