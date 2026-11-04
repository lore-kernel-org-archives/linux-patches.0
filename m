Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826856;
	b=Zx4+CD0LCF5rmZqhVtcN0y064AKBdfiqIwcSmMc+xrQpRjkWH3NexvBiIzz41F+bW9OO
	 uuceoN+A6vWsoiaJWzOxCvGHCYMwjRYehRlXhy96vdThHoOBmeodHoz0b2+B63ZGJeYxq
	 NoBMDw5wLrUxBMqYdbqera5jt7CbkedIHP9P3whBCpWNw4r7vNFnGj6CoVnTqfwDUW/Pb
	 tgZzTE0r2oMO+CtCKXlaJ9XZ3dXK53xCOnf4rnir1S/dfiYmGMWQtlmtwuOJtDO+OLFCq
	 MTWpLvnFU5fbb4ILk7CeOwcfu7zvLJdvOaHes47G6YFHUhPhBDvmk1XteM4hFA0jr7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wA7cquLtU6fjVjO6uN5wBdgpuqCjv21rKx2ZSb4PKIU=;
	b=cj1XpQ0/2jSsv4ExhZZwzmj2eLU1t3nuxMQ4M5SebYFhV3ozvhkqt6zfPHHwFzsphkZ0
	 LekcKGZeK4ZD5wizo6t7gBmjYMbxvorPqpGyvOXQ612f3Mz79qlntBfyxoxLUFTYCIPd+
	 j5wJPEnNESVsQvwMjYeYwU4vTbzKEfd62+EBvMxGGQ2ZmWvSOES0P4dIkAsj42gnftbnd
	 oMtEPSJOBOI4yJkQldjfUWwtPl2dKUuuHopZnk8fDoyZEL1jWR+2l1177YhpFSVusY/u0
	 YGEA/FRXG25ElN25YtFnDaFCmc9ccXz+oy9XWUcc29LL67DDlBBGmA4GvZzpQ0lCpow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TA13qP+E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889C607030A;
	Wed,  4 Nov 2026 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TA13qP+E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C401F00A02;
	Wed,  4 Nov 2026 21:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826856;
	bh=wA7cquLtU6fjVjO6uN5wBdgpuqCjv21rKx2ZSb4PKIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TA13qP+EmuTKzn+glC2qgVITtOLOzyBNsunGDfTklt2Wj4R7p/OacTmSf/5ZNEPOZ
	 jsqI2C+xCgtlEjig9FSYbgUWwe8NiLK141NRd0adXG/UpHDeN+VdqebuyuhnsZ61l1
	 6fU0haR0uasPLf9n3/r3lrm1Xv0WXQRQYCVXkNg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 047/547] io_uring/timeout: use the right clock for ABS updates
Date: Wed,  4 Nov 2026 16:03:51 -0500
Message-ID: <20261104211039.649388386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit dad82eb1805d76c555224e4030319e3844642b64 ]

io_parse_user_time() converts an absolute time from the time namespace of
the caller to the host's view, for the clock given by the flags. The
flags of IORING_TIMEOUT_UPDATE and IORING_LINK_TIMEOUT_UPDATE can't name
a clock, the updated timer keeps running on the clock the timeout was
set up with. So the time is always converted as if it was
CLOCK_MONOTONIC.

In a time namespace with a monotonic offset, that moves the new expiry of
a CLOCK_REALTIME timeout by that offset, although the clock isn't
affected by time namespaces at all, and the one of a CLOCK_BOOTTIME
timeout by the difference between the two offsets.

Do the conversion when the timeout has been looked up and its clock is
known. The update is run by the submitter, its SQPOLL thread or one of
its io-wq workers, all of which share the time namespace.

Fixes: 9cc6bac1bebf ("io_uring/timeout: honour caller's time namespace for IORING_TIMEOUT_ABS")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-31-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 38ee4e966e8e7..2385adae72e01 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -458,6 +458,8 @@ static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 	io = req->async_data;
 	if (hrtimer_try_to_cancel(&io->timer) == -1)
 		return -EALREADY;
+	if (mode == HRTIMER_MODE_ABS)
+		ts = timens_ktime_to_host(io_timeout_get_clock(io), ts);
 	hrtimer_setup(&io->timer, io_link_timeout_fn, io_timeout_get_clock(io), mode);
 	hrtimer_start(&io->timer, ts, mode);
 	return 0;
@@ -479,6 +481,8 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 	/* for a multishot request this isn't a sequence, keep the repeats */
 	if (!(data->flags & IORING_TIMEOUT_MULTISHOT))
 		timeout->off = 0; /* noseq */
+	if (mode == HRTIMER_MODE_ABS)
+		time = timens_ktime_to_host(io_timeout_get_clock(data), time);
 	data->time = time;
 
 	list_add_tail(&timeout->list, &ctx->timeout_list);
@@ -511,7 +515,12 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 				  IORING_TIMEOUT_ABS |
 				  IORING_TIMEOUT_IMMEDIATE_ARG))
 			return -EINVAL;
-		ret = io_parse_user_time(&tr->time, READ_ONCE(sqe->addr2), tr->flags);
+		/*
+		 * The clock is that of the timeout to update, an absolute time
+		 * is converted to the host's view once that has been found.
+		 */
+		ret = io_parse_user_time(&tr->time, READ_ONCE(sqe->addr2),
+					 tr->flags & ~IORING_TIMEOUT_ABS);
 		if (ret)
 			return ret;
 	} else if (tr->flags) {
-- 
2.53.0



