Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4041F63F5;
	Wed, 19 Feb 2025 08:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954816; cv=none; b=rxNlsdxxiub7VJLkR/rJY5cs+Mjh4UedLIbc5oO/jTgfWs8KQwI4qJfXPW/CILXj6zingPe6R1T42zuDtbZsNRBmNyz3KdqvrrGBz2HbfrayT08GrsVspdQmtj0snDqePSLp619Rnx0xiOCfn4iTa3dZ6fswNN6gPlc03FwuZ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954816; c=relaxed/simple;
	bh=lclQWHCZBJ3UybZgS1hPeZqj78qqV1ruaaW4A0RNCEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8/hECvb+kvhVbBBEz7i6P6A1++Q/kDr/fUtkyhyDfUE/ywwtrKONupXL1LAgsXUPXKKJSeXv1xpYpEL6uBVj/8ahB3YAgd0ze3B/XRSNQSvvZGlGhBsWn3rc3x8MZm/qhjRdtIBD09ojt4/UTl1FRC44eyDRJNVQGkLLTFDe8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVqIs4m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVqIs4m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CA9C4CEE6;
	Wed, 19 Feb 2025 08:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954816;
	bh=lclQWHCZBJ3UybZgS1hPeZqj78qqV1ruaaW4A0RNCEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVqIs4m8sSjcUfmSiWWmcfZhhnJDLMrzla1vJuVqZacRolL9Gn89CAlcNojP+sono
	 GIZepIdRM014b63GcGcCaWSrC8cv/+Lxy9mvfuK2DynfL0pa3S1n/kmjAcjltLHb7a
	 E+LFJlf/ymEEpnoyGAfpZznVqbGfj29P5b7Iiepk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/230] io_uring/waitid: dont abuse io_tw_state
Date: Wed, 19 Feb 2025 09:26:02 +0100
Message-ID: <20250219082603.473344414@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 06521ac0485effdcc9c792cb0b40ed8e6f2f5fb8 ]

struct io_tw_state is managed by core io_uring, and opcode handling code
must never try to cheat and create their own instances, it's plain
incorrect.

io_waitid_complete() attempts exactly that outside of the task work
context, and even though the ring is locked, there would be no one to
reap the requests from the defer completion list. It only works now
because luckily it's called before io_uring_try_cancel_uring_cmd(),
which flushes completions.

Fixes: f31ecf671ddc4 ("io_uring: add IORING_OP_WAITID support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/waitid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 6362ec20abc0c..2f7b5eeab845e 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -118,7 +118,6 @@ static int io_waitid_finish(struct io_kiocb *req, int ret)
 static void io_waitid_complete(struct io_kiocb *req, int ret)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	struct io_tw_state ts = {};
 
 	/* anyone completing better be holding a reference */
 	WARN_ON_ONCE(!(atomic_read(&iw->refs) & IO_WAITID_REF_MASK));
@@ -131,7 +130,6 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	io_req_task_complete(req, &ts);
 }
 
 static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
@@ -153,6 +151,7 @@ static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 	list_del_init(&iwa->wo.child_wait.entry);
 	spin_unlock_irq(&iw->head->lock);
 	io_waitid_complete(req, -ECANCELED);
+	io_req_queue_tw_complete(req, -ECANCELED);
 	return true;
 }
 
@@ -258,6 +257,7 @@ static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
 	}
 
 	io_waitid_complete(req, ret);
+	io_req_task_complete(req, ts);
 }
 
 static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
-- 
2.39.5



