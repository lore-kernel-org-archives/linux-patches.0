Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD42315FCFC;
	Mon, 27 May 2024 19:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837807; cv=none; b=gzkWxiSm7qqpVrTm+XTjPD09rmmBjf9TTkiM1IbIdC4+pql8XMBumCRXnpTyQ7SkugFeXHJ8Ad9qezpLbnnwBU25JppHH/T+PJs8Jx4Jb6EHjCbGAy8tWoSDxEwicAk//MS0C3hGLBmbWnUTFXNVb/AukmomNU7j9rXdHaTStgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837807; c=relaxed/simple;
	bh=sKHV4IklCwvMivi0fqvX9x/JX4UFro3TSPx3oNF1atY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBRHF6WJQ+kfp6PVqaLkLvRNJVIWI424h+T2zXulyripOLZd0VJ/609mPoi7df5sqF1k5oHjy0u8Mz3RNi4PRvl1e7GqSwtBbOqHZr1FHv/FagdWjTOfjmfqNyPSY4UwT5ddiOu9lRVYRiLXDBDffEq86kD8fefLvyAS6arWeNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yknoSjHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yknoSjHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E210C2BBFC;
	Mon, 27 May 2024 19:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837806;
	bh=sKHV4IklCwvMivi0fqvX9x/JX4UFro3TSPx3oNF1atY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yknoSjHMQg8KSIDFScNIFp8sXD50c7tqc+cFVxeJo98hfuaBhl6gGmrpC+M0ZXry0
	 CFEd3bWO60wXz2rg7VzV65YrXB/yA+vlqPiXm1Re0KHXoUHF1XPisFC0R3ckPTjGph
	 X07DyrKiMkQivkHikLwshfBHbKyyHwfxc6iKjl4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 152/493] io_uring/net: remove dependency on REQ_F_PARTIAL_IO for sr->done_io
Date: Mon, 27 May 2024 20:52:34 +0200
Message-ID: <20240527185635.405192773@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 9817ad85899fb695f875610fb743cb18cf087582 ]

Ensure that prep handlers always initialize sr->done_io before any
potential failure conditions, and with that, we now it's always been
set even for the failure case.

With that, we don't need to use the REQ_F_PARTIAL_IO flag to gate on that.
Additionally, we should not overwrite req->cqe.res unless sr->done_io is
actually positive.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ef42b85a5609 ("io_uring/net: fix sendzc lazy wake polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 46ea09e1e3829..d193b87d0a03b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -359,6 +359,8 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
+	sr->done_io = 0;
+
 	if (req->opcode == IORING_OP_SEND) {
 		if (READ_ONCE(sqe->__pad3[0]))
 			return -EINVAL;
@@ -381,7 +383,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	sr->done_io = 0;
 	return 0;
 }
 
@@ -603,6 +604,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
+	sr->done_io = 0;
+
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
 
@@ -639,7 +642,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	sr->done_io = 0;
 	sr->nr_multishot_loops = 0;
 	return 0;
 }
@@ -1019,6 +1021,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
+	zc->done_io = 0;
+
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
@@ -1071,8 +1075,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
-	zc->done_io = 0;
-
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
@@ -1318,7 +1320,7 @@ void io_sendrecv_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
-	if (req->flags & REQ_F_PARTIAL_IO)
+	if (sr->done_io)
 		req->cqe.res = sr->done_io;
 
 	if ((req->flags & REQ_F_NEED_CLEANUP) &&
-- 
2.43.0



