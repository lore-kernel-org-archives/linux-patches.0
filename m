Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318BB1F9A86;
	Wed,  6 Nov 2024 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897280; cv=none; b=kOFg76NpNMruMQ/7ntrEGtCzEf6Rbvtvu0R77jCBbsV9ITPA2Tf32l9wuAITM0dDzwI/6f4uFmg9Tq895k8m1z6Fj8Gk3yERu4cOkiKach1bCP0YeWS46VWibSsyC76v+lytNY2mCsy/kUKI9v5ak9av5dZIOrUp2rhJot1k1zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897280; c=relaxed/simple;
	bh=ECruLPH+vgsi1dNZHVSx69mXL7yTe/5l3AbNLxhpDwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNGIFC6SYG9iux+ytoGkDV6+3OSybXHioxtlTmQ1Feyb/J0bi62eE5ocWolOUkPcOPeynP5ZEvti+69OpNs83bY25yk2lgir6Fv4cDotDzGiBQALwxGoHG2TY+HJ19V5eGt3jcycRDurreZ36MCyUNF9+6S/KVwrfQIW6iEP8Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGY8hdcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGY8hdcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59F8C4CECD;
	Wed,  6 Nov 2024 12:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897280;
	bh=ECruLPH+vgsi1dNZHVSx69mXL7yTe/5l3AbNLxhpDwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGY8hdcJiTEOfuq+aWRdFCdqNxP28HuSoC9+sXgXWLhCr80a362vuB4UquRsAlqpa
	 8YHuGqY0MUPmsVbEoFx6aO1X+ojaoGr5/GWfRQVPbByzaWkPIUobHCtCPDRFjlbsA2
	 2YvMZFVWb9ySrS16RbMd8tkbTYJHOY3yY3JeYy3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 114/126] io_uring: always lock __io_cqring_overflow_flush
Date: Wed,  6 Nov 2024 13:05:15 +0100
Message-ID: <20241106120309.139145097@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 8d09a88ef9d3cb7d21d45c39b7b7c31298d23998 upstream.

Conditional locking is never great, in case of
__io_cqring_overflow_flush(), which is a slow path, it's not justified.
Don't handle IOPOLL separately, always grab uring_lock for overflow
flushing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/162947df299aa12693ac4b305dacedab32ec7976.1712708261.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -593,6 +593,8 @@ static bool __io_cqring_overflow_flush(s
 	bool all_flushed;
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
 		return false;
 
@@ -647,12 +649,9 @@ static bool io_cqring_overflow_flush(str
 	bool ret = true;
 
 	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
-		/* iopoll syncs against uring_lock, not completion_lock */
-		if (ctx->flags & IORING_SETUP_IOPOLL)
-			mutex_lock(&ctx->uring_lock);
+		mutex_lock(&ctx->uring_lock);
 		ret = __io_cqring_overflow_flush(ctx, false);
-		if (ctx->flags & IORING_SETUP_IOPOLL)
-			mutex_unlock(&ctx->uring_lock);
+		mutex_unlock(&ctx->uring_lock);
 	}
 
 	return ret;
@@ -1405,6 +1404,8 @@ static int io_iopoll_check(struct io_rin
 	int ret = 0;
 	unsigned long check_cq;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
 


