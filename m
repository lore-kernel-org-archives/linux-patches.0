Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A871C5F18;
	Wed, 19 Feb 2025 08:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953962; cv=none; b=k+YBrS0K3R/ZhH9c/W1YiIMWzEazsomvtpCablvwZiNKeFePW8xk1JqdCHGtYjz87OCi6uvD86/C7PI0e1cS9qgFRTPWtiWtLCMbEbk8jhKKJMRKhY6aV+q6bWpEJ3dYbIZGNi7+Pm0atfyRQWcPCzB5+UYTk2V/jBmWQKFtDk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953962; c=relaxed/simple;
	bh=WzmaeuO78ER2juCe6IaSdGlPIJ3hUDmbAe3xcf8QkjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcLC5228iT4mXlYevdbn8/GYZCQAGs+rtkvqlt5X0bkQfyj/qTp3tv+mA0RZKhylveWVrI0WcW42avGw5gvhLrPjHNAKLtpBvWibn80DSzn7gGdr8wHHP9XSr+wk6x7LEuaS4wgSFFB4wrYR9IoK6iDB117mC/z1YYAhdwUMWME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2K9GOi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2K9GOi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56822C4CEE6;
	Wed, 19 Feb 2025 08:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953959;
	bh=WzmaeuO78ER2juCe6IaSdGlPIJ3hUDmbAe3xcf8QkjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2K9GOi+QsvH5y2movBimlsy0Vj+VYesWoANsYVbom+OJXkCiLDF7jiu6x/+H2HEJ
	 fUjwwPKlqv7GJqpnDEQ2652A4LtCxDgJm6IuqJ8OkUWtwDhXCS1M0gSLlOLpJ22sBA
	 lxBykOyiXwSrzGdd+/+HgGhs7SbxfAQGlr4n+fck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 052/274] io_uring/waitid: dont abuse io_tw_state
Date: Wed, 19 Feb 2025 09:25:06 +0100
Message-ID: <20250219082611.556668060@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index daef5dd644f04..eddd2dffc88b6 100644
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



