Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4221408035;
	Fri,  4 Sep 2026 05:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500068; cv=none; b=nXQYEG6lkPY1xV89SvTPRzthwzsTRIlHbD13w6zFdQ9UmGt6z95IDvAoRIEK4qmS+75utk1kcdFdT+bjeb4lkwaq6THkcmIRMwBdUA9CKvk9zp1GM0rAgtQpXUAVtIkdZnrF8zQUzlVZygK5q+OXd9Hl/Xu1ZXkHkqgIeTwQI3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500068; c=relaxed/simple;
	bh=XArY7gqeoUTmjxtENGcDGyGG4VOFVUgYNCaO/JQ7tJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+5ngao6AIszuZ4IfCeJ6LkxONKRDSXaX8vUzsnYQg2nYkP0kgBZsoY2Tfcy1TqmSfXq8/77xv24SFFb/FrueKQfinuMT/PFZzmGkR/IzZrIXgUsyhuZV0nPusJQZJWma1PBmwV2dJfYhhYwLspMWlTwoNqPn7IVsywAHTxhPn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDXyoFmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDXyoFmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572D51F00A3D;
	Fri,  4 Sep 2026 05:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500066;
	bh=7Embin01mGy/DooOfhpW65BR+cQr20ZWNtPhrgbdUfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDXyoFmX5K2+MkBXt4ItoI/ZdVteKhYU+C5KqQoey3+Jm1tyAnkfHD7FZpVSPGOOi
	 BxAw+n9yubnkPgZngIKR2bnxQLU3hzv8HjMVuxAKPcEsbZ/Z6B11DDGoQ++hUKpHfq
	 Dw6mMKkEqtmGvZJ8U8NmHSQF+/KVN4h7RZVB3ps4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 586/713] io_uring/waitid: honor task_work cancellation
Date: Fri,  4 Sep 2026 06:59:14 +0200
Message-ID: <20260904045816.954542014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

commit 14572de82e5022899e5856008bc9cac97004a88c upstream.

io_waitid_cb() may run through the fallback task_work path when
task_work_add() can no longer queue work to the originating task. The
fallback runs from a kworker and io_uring marks such task work as
canceled through tw.cancel.

io_waitid_cb() currently ignores tw.cancel and calls __do_wait().
waitid is task-context dependent: __do_wait() performs child lookup
relative to current, and the retry path also uses
current->signal->wait_chldexit. If the callback runs from the fallback
kworker, current is therefore not the task that submitted the request.

Honor tw.cancel before entering __do_wait(). Complete the request with
-ECANCELED and skip the siginfo copy, since canceled task work may run
without the submitting task's userspace execution context.

Keep the existing siginfo handling for normal waitid completion and
explicit cancellation.

Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
Link: https://patch.msgid.link/20260818103336.1922818-2-sh_def@163.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -125,7 +125,7 @@ static void io_waitid_remove_wq(struct i
 	}
 }
 
-static void io_waitid_complete(struct io_kiocb *req, int ret)
+static void io_waitid_complete(struct io_kiocb *req, int ret, bool copy_si)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 
@@ -137,7 +137,10 @@ static void io_waitid_complete(struct io
 	hlist_del_init(&req->hash_node);
 	io_waitid_remove_wq(req);
 
-	ret = io_waitid_finish(req, ret);
+	if (copy_si)
+		ret = io_waitid_finish(req, ret);
+	else
+		io_waitid_free(req);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
@@ -159,7 +162,7 @@ static bool __io_waitid_cancel(struct io
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return false;
 
-	io_waitid_complete(req, -ECANCELED);
+	io_waitid_complete(req, -ECANCELED, true);
 	io_req_queue_tw_complete(req, -ECANCELED);
 	return true;
 }
@@ -202,6 +205,11 @@ static void io_waitid_cb(struct io_tw_re
 	int ret;
 
 	io_tw_lock(ctx, tw);
+	if (unlikely(tw.cancel)) {
+		io_waitid_complete(req, -ECANCELED, false);
+		io_req_task_complete(tw_req, tw);
+		return;
+	}
 
 	ret = __do_wait(&iwa->wo);
 
@@ -229,7 +237,7 @@ static void io_waitid_cb(struct io_tw_re
 		}
 	}
 
-	io_waitid_complete(req, ret);
+	io_waitid_complete(req, ret, true);
 	io_req_task_complete(tw_req, tw);
 }
 


