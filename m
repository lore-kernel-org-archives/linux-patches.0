Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210270;
	b=UI45Yn627zL8PcdJVwRV1CiGunEi73zSoeV1koGyOwAJDnJsvtjbwOPgDVgeyTFegYc/
	 /vnVkUmeKaqTB3Ypz3agJ/A8T1k7XN9KyI7w8rt/1cOo6riYYcS1ZHFcYi1/FibQ5Jap8
	 2zKKzfyYgWWMHNUbOwwZJ5AayIMSOqkV04rzr/Sb4bDHMjsvM0ERpFhInUHhZqJTM7yTY
	 uGwbBucTtqw4A0giVXwryFIfsM9Os2YgkSstyD5Jvb+9CMdVG3C28C9ckQ/iErn5duRDx
	 huNSgAkuv4CJlWQWJFZTbj28rv5BLtYQj25/d2xGBzWYjDecawI3fTFGh+7QvqMCzKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CFihkSyPGxVPdepv2ibLLurO8vOr6Sit6comv3qQ1B8=;
	b=PGPu2CBnpr5a6IhswJ8yYdEeGJaUvbOPbPGmiJahJPVCy8EoPCZ+JHTHTi5+Abd3KQcs
	 6Rn2KKuNrCyXRozdRSblFi8R/sFVb05s4QNZlg1WhCy2TMvrVHU5V3zRDsdnj4gS67izc
	 YsHiKPjpltgUy3Fva1TyckOkqUshpiDJ0bQTyMtskZnNb1C/LNNrwJ6BktwmIVfj7zqLm
	 2Xh004b2r3BYxPmjpjrF2ESzZRHac9RkdQabTB6LoAYxZ4zuAxHGvMFdKvqD85b2zBXAn
	 f6TXcYmBxdDzbwlbnum+sjK/tZV37k0xzory1MhtEm77E/9C5uwZn31lKS/3EHNPu8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZ1Isp1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F472606A31A;
	Wed, 28 Oct 2026 17:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZ1Isp1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B24B1F01825;
	Wed, 28 Oct 2026 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210269;
	bh=CFihkSyPGxVPdepv2ibLLurO8vOr6Sit6comv3qQ1B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZ1Isp1tbjez62/VL1cLQqOQ68jNhrmK9hiJJOLJNbrH/GJDoK26I01GrjfO+c/cu
	 gUKfycUQdR0amtov/WmILQ1+K0Yf2Z3mOzsuRoU1e/9JGWhc5E52gdhZ0OWKn+KYQN
	 cbY9MQGp9TCvkwHTBd+I5n4Xfs2abB4vPcTSUz1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 135/168] io_uring/cancel: dont forget that the work was running
Date: Wed, 28 Oct 2026 18:01:11 +0100
Message-ID: <20261028165946.279620346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 8aa0e5db4845fb5ac11abe40d7b1cac0656c3ee3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |   13 ++++++++++++-
 io_uring/cancel.h |    2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -114,6 +114,8 @@ int io_try_cancel(struct io_uring_task *
 	 */
 	if (!ret)
 		return 0;
+	if (ret == -EALREADY)
+		cd->running = true;
 
 	ret = io_poll_cancel(ctx, cd, issue_flags);
 	if (ret != -ENOENT)
@@ -162,6 +164,7 @@ static int __io_async_cancel(struct io_c
 	struct io_tctx_node *node;
 	int ret, nr = 0;
 
+	cd->running = false;
 	do {
 		ret = io_try_cancel(tctx, cd, issue_flags);
 		if (ret == -ENOENT)
@@ -185,7 +188,15 @@ static int __io_async_cancel(struct io_c
 		}
 	}
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
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -9,6 +9,8 @@ struct io_cancel_data {
 	u8 opcode;
 	u32 flags;
 	int seq;
+	/* io_try_cancel() has found it being run by io-wq, and flagged it */
+	bool running;
 };
 
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);


