Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826828;
	b=AB8vbGIdiVeXtbARWppPzXr8WF8O56iLj/H+Pc0/XTTWZCT72FKW4LpiEZGGZp81Dl0x
	 ZyZ15lUUr56IYDgbB6ekSicRjZaAX7UFfkTN4yQInJjZUcJ00WYKdVgyiZfMxAxbEbXGC
	 v9TrGRbibmPe9Y1jCg2UF6OfJxAttJMmj/2r4SPcbSuDKLaKsxNwT8HPig3eRoYCVF+vE
	 9XNx/W98bsduVLUB7F/VaNK2Gz2ltYmt/zASjY6XFdzM88CPokVG7LIMAxk1srh7hp0jn
	 GWKCSLqyZmq3F1iO+4bDZZTv7lJwsVrZLpLKT5xfMJWC8yJqnklZuW72eOoOctcZr8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OymlbgGlp3CMCSls5u6tNj5eeq42dArBD8LpFi0mNlg=;
	b=HDB69J50pN3WLRmF00rNJMK539hCEsY0apgXuv4doeUT0igTzmtvNNZZ0M4OvxbAfBn2
	 u4wyxAlFtTUOCtzG5ftp0yuIzACKX1+AI1CSmKvTO1JXmpgo2cZX19pK9NHrIL0uflNn0
	 wWa1hcHoLsO1oTjdok6B3Nddz0/U6VmItjtIKR7ol7V0+7Q8AdVhaDAGIN4NLt7l+nsch
	 R8k90dXwOcUVO1lPP4qRvZwyXUZoOAHs0+d/5eygxVVZX2K6v2xaxGm87x1tjTMhAqF63
	 KwNoMPDXk24VtbGrvPA1WX8K9ShhKfypV5yq+6rk6YP/51Y0Lk2dRWb7dZvvTPdqVgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/nxYgwn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2263F6071ADF;
	Wed,  4 Nov 2026 21:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/nxYgwn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5BE1F00919;
	Wed,  4 Nov 2026 21:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826827;
	bh=OymlbgGlp3CMCSls5u6tNj5eeq42dArBD8LpFi0mNlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/nxYgwnUC9FIfyzG0kfed1KqwupFQEgZSB0WkTL685p0KJ0Dw8E1d3mYkIkaNywG
	 qNWL6GuhCSaIRxl6tHlWpqPz89qLq+e2v7kPEvUiCW8muF2ELsHwtw8Jp83Rhvg7t7
	 EJ8Dc1fAZadxtbDUp1GDTigPW+gAEMBi/4Npvtog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 032/547] io_uring/cancel: dont forget that the work was running
Date: Wed,  4 Nov 2026 16:03:36 -0500
Message-ID: <20261104211039.258109321@linuxfoundation.org>
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

[ Upstream commit 8aa0e5db4845fb5ac11abe40d7b1cac0656c3ee3 ]

If the request to be cancelled is being run by io-wq,
io_async_cancel_one() flags the work, signals the worker and returns
-EALREADY. Since commit ccbf726171b7 ("io_uring: perform poll removal even
if async work removal is successful") io_try_cancel() goes on regardless,
as poll may be armed for the request. If it isn't, and nothing else turns
up, the result is the -ENOENT of the last search.

__io_async_cancel() makes up for that. On -ENOENT it tries the io-wq of
every task that uses the ring, and that of the caller is one of them. So
the work is found a second time, and the result is -EALREADY after all.

Unless the worker is done with it by then. If the work is flagged before
io_wq_submit_work() looks at IO_WQ_WORK_CANCEL, all the worker does is to
queue the request to be failed by task work. Then it isn't anywhere to be
found until the task work has run, and

 - IORING_REGISTER_SYNC_CANCEL returns -ENOENT,
 - IORING_OP_ASYNC_CANCEL completes with -ENOENT,

for a request that they have just cancelled, and that completes with
-ECANCELED.

With a read of an empty pipe, IOSQE_ASYNC, and a sync cancel right behind
it, 1 to 3 of 1,000,000 calls return -ENOENT, and 50 to 110 with
IORING_SETUP_DEFER_TASKRUN (4 CPUs, KVM). Nothing is written to the pipe,
and all of these reads end with -ECANCELED.

Remember that the work was found. IORING_OP_ASYNC_CANCEL completes with
-EALREADY, as it does if the worker is a bit slower. For
IORING_REGISTER_SYNC_CANCEL it means to try again, which ends with 0.

The result of a linked timeout, which calls io_try_cancel() by itself,
and the number that is returned for IORING_ASYNC_CANCEL_ALL and _ANY don't
change.

Fixes: ccbf726171b7 ("io_uring: perform poll removal even if async work removal is successful")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-16-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 13 ++++++++++++-
 io_uring/cancel.h |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 03b1f1f3fad16..e9988a9dbb144 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -117,6 +117,8 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 	 */
 	if (!ret)
 		return 0;
+	if (ret == -EALREADY)
+		cd->running = true;
 
 	ret = io_poll_cancel(ctx, cd, issue_flags);
 	if (ret != -ENOENT)
@@ -180,6 +182,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 	struct io_tctx_node *node;
 	int ret, nr = 0;
 
+	cd->running = false;
 	do {
 		ret = io_try_cancel(tctx, cd, issue_flags);
 		if (ret == -ENOENT)
@@ -204,7 +207,15 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 	}
 	mutex_unlock(&ctx->tctx_lock);
 	io_ring_submit_unlock(ctx, issue_flags);
-	return all ? nr : ret;
+	if (all)
+		return nr;
+	/*
+	 * The worker may be done with the work that was found running, and
+	 * flagged, above. That isn't the same as not having found it.
+	 */
+	if (ret == -ENOENT && cd->running)
+		ret = -EALREADY;
+	return ret;
 }
 
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 1b201a0943030..e03a6fb0b7f95 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -11,6 +11,8 @@ struct io_cancel_data {
 	u8 opcode;
 	u32 flags;
 	int seq;
+	/* io_try_cancel() has found it being run by io-wq, and flagged it */
+	bool running;
 };
 
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.53.0



