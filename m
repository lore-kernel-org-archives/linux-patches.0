Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D175FF10;
	Tue, 13 Feb 2024 17:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845959; cv=none; b=QvpKn/+avel0p+qUiHWLX51i7obI3dUBJZIHssephnv6bsju8BCCDBzuXKtIHsHH+7WwsaJeWSRe5TKP2Ic09xa5gLcqdLqnVat+BiGLJcHCJTqbXmmWJJsl+CLv1bLcWQ6gYQnZneSPADM0yotPwYnrE49W9iTHfraGkzGwtCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845959; c=relaxed/simple;
	bh=KGQZu0r29pM2je2TAF0x1vVFhnQWsEvdTKJHl3Upx8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keD8o1GvG92bQXJNqZiT+fftJ5NKNl5DPaKKjTJ/7Niq6/JV1OgNVtC8B0k+C7rTWQlYD99BA3KmHiY4cYCx0ltFgmKdVwlWbVZ71cLsJx2h3vkBeD10QGzgL+ndxEQZW/6Srr98eGxaRkDfK5jVjVKEJp4kPLhLETiX4isFPyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2h5wIe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2h5wIe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A79C433C7;
	Tue, 13 Feb 2024 17:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845959;
	bh=KGQZu0r29pM2je2TAF0x1vVFhnQWsEvdTKJHl3Upx8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2h5wIe7BejQuC/2OKo7R04Cn7CJLi2g0IivmHvRS9ozv1OTQTyomDgmvEnOHGH8x
	 NCftlLIFu6NLWLvGpsiAdGB++O/AfigbxCkLMb7SpH438q5CeRWwOux5GXBLYE/soR
	 ny057H38rGPw/fe9Bodk3TNuXpHmi8EHUHq53ukI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 106/124] io_uring/poll: move poll execution helpers higher up
Date: Tue, 13 Feb 2024 18:22:08 +0100
Message-ID: <20240213171856.825513741@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit e84b01a880f635e3084a361afba41f95ff500d12 upstream.

In preparation for calling __io_poll_execute() higher up, move the
functions to avoid forward declarations.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,26 @@ enum {
 	IOU_POLL_REISSUE = 3,
 };
 
+static void __io_poll_execute(struct io_kiocb *req, int mask)
+{
+	unsigned flags = 0;
+
+	io_req_set_res(req, mask, 0);
+	req->io_task_work.func = io_poll_task_func;
+
+	trace_io_uring_task_add(req, mask);
+
+	if (!(req->flags & REQ_F_POLL_NO_LAZY))
+		flags = IOU_F_TWQ_LAZY_WAKE;
+	__io_req_task_work_add(req, flags);
+}
+
+static inline void io_poll_execute(struct io_kiocb *req, int res)
+{
+	if (io_poll_get_ownership(req))
+		__io_poll_execute(req, res);
+}
+
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -364,26 +384,6 @@ void io_poll_task_func(struct io_kiocb *
 	}
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask)
-{
-	unsigned flags = 0;
-
-	io_req_set_res(req, mask, 0);
-	req->io_task_work.func = io_poll_task_func;
-
-	trace_io_uring_task_add(req, mask);
-
-	if (!(req->flags & REQ_F_POLL_NO_LAZY))
-		flags = IOU_F_TWQ_LAZY_WAKE;
-	__io_req_task_work_add(req, flags);
-}
-
-static inline void io_poll_execute(struct io_kiocb *req, int res)
-{
-	if (io_poll_get_ownership(req))
-		__io_poll_execute(req, res);
-}
-
 static void io_poll_cancel_req(struct io_kiocb *req)
 {
 	io_poll_mark_cancelled(req);


