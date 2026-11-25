Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620867;
	b=u5wHNZul+LJLmrU3xDftRaMTyIl6wM6r+qh1sKG5Rvz7vtSDuXfh7WuZEkBHxWPjS3A4
	 zu0e2UoD5SHmIQw+fRj2LMJlhwnaCfINF+APk/+akKYJ1tZLskcdK+FX8oijCWCkVe8xp
	 QSfzDoQ07YJl2PGkABw0Xe9d9VFqLnZExiWmBpj3Nm94vThv9YYmDkC3R/EynzYkNZRqU
	 cbFls93OygSNR5JF4p0FKen0s0DYLsxJcYuwX8mAGXJpgsTOb2Zq1c5x8ajVmWbMfoheI
	 99C01wKSJfdfTE0aKWJDzI0PEuL53k68K94uOUEoAevrSmTRBsnnWSLNDETfO5TlSpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5OLNQd4GdVVAgNjoFVDKG8ZWiBpoHh5W6uzL5ijMlFc=;
	b=j+EJ4pnELiy9HxDNcRzW22J/6RJt32gKdckYgogNsjzdNNFsXLnwXrufKW46HBjfTJet
	 EcpM+pOEBCbsR+fEqAxXu/V3smPW6sOw+YI37beaxdC2YDmgP9mSmwo7LQsGiMxCzk1zJ
	 GF/mHjmHfn31lRi9pPdsdj+cC/odPev4g8Iw5J6CUq9nULtJeFUIUkzEIf79GTau1ibGe
	 t8QmBcUgpBKedMaW5TPHj34mvi4ZX0Ng+c2Pe7IdMQmTr86lUkBAvBrbdL3OFF/69thu/
	 nc7vNP6lPsVJMzIizeflIVlzmd8QmbcBvwrWbEmXuEMEkQDzi4sMX8OkUu1g+yk7sEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sElCpANs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295CA606A32C;
	Wed, 25 Nov 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sElCpANs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6461F000E1;
	Wed, 25 Nov 2026 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620867;
	bh=5OLNQd4GdVVAgNjoFVDKG8ZWiBpoHh5W6uzL5ijMlFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sElCpANsFEWnHewtf4diHbldPmIhuhp7DYy/wQmM8YC17xZ9WrJJiqB1/nfG5qMZN
	 1zEEQlk6sNlGG9XjvpxbbUpux/RcehcOxLgPN2fQWZV3XU9596qHzk99WteW9wKddC
	 VsZsdH3urjAQXR72xcR6FoEr97oUpbhGqMppCLDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/990] io_uring/timeout: dont rearm a multishot timeout on cancel
Date: Wed, 25 Nov 2026 15:23:34 +0100
Message-ID: <20261125143823.193049204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Yongkang <teel4res@gmail.com>

Commit 97d4a585db2b91d855f957be0a9f126068c5be93 upstream.

io_timeout_complete() does not check tw.cancel. When it runs from
io_cancel_local_task_work(), a multishot timeout that has not reached
its count still posts an IORING_CQE_F_MORE completion and rearms its
timer. With a zero interval the timer expires again right away and
queues new task work, so the drain keeps running it until posting a
CQE fails.

Normally the CQ fills up quickly and the request then completes. But
if userspace moves the CQ head far ahead of the tail, for example to
cq.tail + 0x7fffffff, posting keeps succeeding and ring teardown is
delayed for a long time.

Don't post another CQE or rearm the timer when tw.cancel is set, so
the request completes through io_req_task_complete(), like the poll and
linked timeout task work does when cancelled.

Fixes: ea97f6c8558e ("io_uring: add support for multishot timeouts")
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/20261116044519.281756-1-teel4res@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/timeout.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 2637c8bb61a08..36c8f3dae27a5 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -76,7 +76,8 @@ static void io_timeout_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!io_timeout_finish(timeout, data)) {
-		if (io_req_post_cqe(req, -ETIME, IORING_CQE_F_MORE)) {
+		if (!tw.cancel &&
+		    io_req_post_cqe(req, -ETIME, IORING_CQE_F_MORE)) {
 			/* re-arm timer */
 			raw_spin_lock_irq(&ctx->timeout_lock);
 			list_add(&timeout->list, ctx->timeout_list.prev);
-- 
2.53.0



