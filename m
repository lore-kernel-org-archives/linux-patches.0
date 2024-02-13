Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F86F60255;
	Tue, 13 Feb 2024 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845571; cv=none; b=KdWp1sRqhvxtd8iIrHcLs1jP6lHfvioHKszOMsQW3Bc1cs3uJD9WWu/lrXRHWy0g7m4j5E8+kp+ROje8kb8/iUBZALXpl8ERPvqxAuqQvEPDDMyVSc18gi7XzyKErzI9B0prWtzC6LNGIGEGcDCd7Y9jliQHhOpS0FVraKnSSZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845571; c=relaxed/simple;
	bh=wppaoq5T6wC8Wivccm6jAJNe8xuQoC9w4P2SOwAjC6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDx9AVhWA7lm8auIaQapO1ef1Xpz5c3672E36QNdjGyfa2ijtXSyYbM53JUek6/kfgKsW6KG1nl0VOtI2+O3rFJ2tieQNlctmWueTuAF4WcWhX+tnmIUbR6PR9bNBtPUbAGM2eDp8wDAMRhByPlNsmhpwZAyiV8z20heSyC66nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYzw9tVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYzw9tVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7709CC43394;
	Tue, 13 Feb 2024 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845571;
	bh=wppaoq5T6wC8Wivccm6jAJNe8xuQoC9w4P2SOwAjC6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYzw9tVyUI+KkPmJjLFwgfrzVkFTWIGBUNEfv3QEqzeFBR8e3LBAX34WNM2+gcIT0
	 mpAr48LVYhcwknKNlilOCLikoL8jVDHN1jTUQ4ioinrhKYYP4LLlochHL9FYyDDP9k
	 AKiYO1b/FDMxaJ2BLmtDY+r13Dg+XfMsk8uhkg5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 118/121] io_uring/poll: move poll execution helpers higher up
Date: Tue, 13 Feb 2024 18:22:07 +0100
Message-ID: <20240213171856.431566077@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit e84b01a880f635e3084a361afba41f95ff500d12 upstream.

In preparation for calling __io_poll_execute() higher up, move the
functions to avoid forward declarations.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,21 @@ enum {
 	IOU_POLL_REISSUE = 3,
 };
 
+static void __io_poll_execute(struct io_kiocb *req, int mask)
+{
+	io_req_set_res(req, mask, 0);
+	req->io_task_work.func = io_poll_task_func;
+
+	trace_io_uring_task_add(req, mask);
+	io_req_task_work_add(req);
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
@@ -364,21 +379,6 @@ void io_poll_task_func(struct io_kiocb *
 	}
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask)
-{
-	io_req_set_res(req, mask, 0);
-	req->io_task_work.func = io_poll_task_func;
-
-	trace_io_uring_task_add(req, mask);
-	io_req_task_work_add(req);
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


