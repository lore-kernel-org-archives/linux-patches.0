Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE82EF64C;
	Thu,  3 Jul 2025 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554436; cv=none; b=d79HTyzDSQ0UbUr5Wi9BQ19P9znEdxhUcjegoGWlFQqJQbSJ/bsPx7qrhLU2FfsaE9CYiiyRNYeTUsNVyPTIm8WI35efTYONKvUpWsCjuPUi8WS8mnkF7gmzyyd71wf0CWG8OjtvD+EFc2k6mkhP28ISAn+iY+UtUiWhrPihi+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554436; c=relaxed/simple;
	bh=mnF4vinGGcNxWAs7UXV8JkUen41YPjBruYmShuw0FKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtSAMAKDojyauUxQP68VHo6KQV+d/gPyQTfFCqolBVOJ1q7AcT1JdkcyQELFEpQiP6cFOTSHJ+7PDF0p+H/QcROUqGnzotnSA5Dwk7sDtcPOyNSWStoryFA3APY7rxWs2nnFuilSINS3yQGe57ZVVN75hf+IHJVNIGqnk0wj3XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL2y2GlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL2y2GlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48096C4CEED;
	Thu,  3 Jul 2025 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554436;
	bh=mnF4vinGGcNxWAs7UXV8JkUen41YPjBruYmShuw0FKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL2y2GlQ7dButEcziGGymuoTJP/kAXFLfCuNVHYABNTBRK4WBJDCODeVrxnGn++vO
	 naP5OJ3whNobg8K5s6diB7cHMWXlLrQWa9rYUhrnI9CwXiIugDz/qDBiFShOPdT4wa
	 Ge9TVZCYldT765LUVaAoqHuHMn0PEJFP2Xmma1os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 186/218] io_uring/net: only consider msg_inq if larger than 1
Date: Thu,  3 Jul 2025 16:42:14 +0200
Message-ID: <20250703144003.625878908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 2c7f023219966777be0687e15b57689894304cd3 upstream.

Currently retry and general validity of msg_inq is gated on it being
larger than zero, but it's entirely possible for this to be slightly
inaccurate. In particular, if FIN is received, it'll return 1.

Just use larger than 1 as the check. This covers both the FIN case, and
at the same time, it doesn't make much sense to retry a recv immediately
if there's even just a single 1 byte of valid data in the socket.

Leave the SOCK_NONEMPTY flagging when larger than 0 still, as an app may
use that for the final receive.

Cc: stable@vger.kernel.org
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Fixes: 7c71a0af81ba ("io_uring/net: improve recv bundles")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -865,7 +865,7 @@ static inline bool io_recv_finish(struct
 		 * If more is available AND it was a full transfer, retry and
 		 * append to this one
 		 */
-		if (!sr->retry && kmsg->msg.msg_inq > 0 && this_ret > 0 &&
+		if (!sr->retry && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
 		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
@@ -1111,7 +1111,7 @@ static int io_recv_buf_select(struct io_
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
-		if (kmsg->msg.msg_inq > 0)
+		if (kmsg->msg.msg_inq > 1)
 			arg.max_len = min_not_zero(sr->len, kmsg->msg.msg_inq);
 
 		ret = io_buffers_peek(req, &arg);


