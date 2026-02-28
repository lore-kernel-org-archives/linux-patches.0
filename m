Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7199C359A96
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302461; cv=none; b=BJquNo1HQLUki7eNtila9pXF6zvZvWwPfDMVFZHqSOyKR9TwLI1Cfp/FgtgOs2OJUn5jbNA840f/cM1Ky9nX3hFNamdsGPtf5rYRT4y6jRq0VB5qNXZDKCAtP/wjKBkJMHVTL8r1pTF2p1H0DaHi6GfDEKYlaA4q9boEYI/fs9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302461; c=relaxed/simple;
	bh=/KAWWZqUY4xROpcd5fHZLq1VGsl7ahQ43+tnsH7hYE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZfFUOyzWel3AXI6yj3U04P1IFEPd5TwFN2kxGLY6z35YnRg9Om4jPQFATZId43E9jEgQEH4jgH6sx65a/DCZ6F8wCftXsoQ+/2G+BunWcScYiJewgDIhnii9SI4SdXwnDeFYrvYfcoqzS1NUw5fPLMipa8NbF7N4EfDyekrL1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0dbS7Ne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0dbS7Ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8703C116D0;
	Sat, 28 Feb 2026 18:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302461;
	bh=/KAWWZqUY4xROpcd5fHZLq1VGsl7ahQ43+tnsH7hYE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0dbS7NescZnvNktg2vY3Jn/djW5tjsaaTKoEsvDDhuqeNW2H7ohWA8Iual4fJ3SA
	 dJoLSUNd4hV+uY0xGeUVmRzUZYmjwdQpMgrbk4R0/LLjS07UwVhpua5RHxrNbc7Qsj
	 bK13rL0rK7XnOOncsoFt7Wbi0LCLzX1ESFCkBZZ4MS3Zqqb0U/Jp4wCzhGQ5AJZOy5
	 z7LRdg3UEzoY/W14ma+i8ontpWMAHiiccxURzvt0wAM3JE4HmFJgGj/8xzpL0sKWCS
	 d7OAcQBAUZSJs+/lnfw/xSTPt6yGrwemQb9IsmhJ5IZi4oAKtkMDwuAR0VqLNEpiLk
	 fASdV9i4QL2AQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/232] io_uring/cancel: abstract out request match helper
Date: Sat, 28 Feb 2026 13:10:56 -0500
Message-ID: <20260228181127.1592657-203-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit aa5cd116f3c25c05e4724d7b5e24dc9ed9020a12 ]

We have different match code in a variety of spots. Start the cleanup of
this by abstracting out a helper that can be used to check if a given
request matches the cancelation criteria outlined in io_cancel_data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 22dbb0987bd1 ("io_uring/cancel: de-unionize file and user_data in struct io_cancel_data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 17 +++++++++++++----
 io_uring/cancel.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index b4f5dfacc0c31..88586911b516b 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -27,11 +27,11 @@ struct io_cancel {
 #define CANCEL_FLAGS	(IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_FD | \
 			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED)
 
-static bool io_cancel_cb(struct io_wq_work *work, void *data)
+/*
+ * Returns true if the request matches the criteria outlined by 'cd'.
+ */
+bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 {
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_cancel_data *cd = data;
-
 	if (req->ctx != cd->ctx)
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ANY) {
@@ -48,9 +48,18 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 			return false;
 		req->work.cancel_seq = cd->seq;
 	}
+
 	return true;
 }
 
+static bool io_cancel_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_cancel_data *cd = data;
+
+	return io_cancel_req_match(req, cd);
+}
+
 static int io_async_cancel_one(struct io_uring_task *tctx,
 			       struct io_cancel_data *cd)
 {
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 6a59ee484d0cc..496ce4dac78ed 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -21,3 +21,4 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 void init_hash_table(struct io_hash_table *table, unsigned size);
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
+bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
-- 
2.51.0

