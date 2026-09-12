Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B2F371887;
	Sat, 12 Sep 2026 09:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205712; cv=none; b=MOxIiD0CRsCSi6Ew1pH7b1zRUI8VZlZ/a9sKlChSNyOy7/c7ZOZcqBSLF1R5hgE69PSH0nkiuqVTUKBy6D7AEvp5iZYiz8fGl9opqxYR7A8KuOnOiJrW9rxKE30Rc0fQD1AptOU6G74AccgPAXjql61GIyRni483HOUPKe4sSag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205712; c=relaxed/simple;
	bh=3dOQ3q6DamBAlKoNNURRPxTnYm0oPn+ktnXcJEisceY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyuIgmnyUmiMprd8UNqD1UDGGrGQA/c8uF2EKAtfSTlWAy8BP9vEECF7PiwYz63P14yeIQrtcGVdP/HeDbnoWtnqUMnaCjmV7o+pTzLrnc0/pq7LGTKhLlwD//bx9Hky1i7fIWBEwZhdtYqhW6TEC8JsHCpaD9N/S+Bu0Tomnpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ks7urZjH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ks7urZjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE5E1F00893;
	Sat, 12 Sep 2026 09:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205710;
	bh=tmgy8afmsAx7UrsLK0bqRa/qQgaTMKJ2BAIjzokMvzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ks7urZjHoNRwrbmXfmZVURrIsFP7g76QL5lW6zXXbpOeHDwVQs/ObeHZBPRgEmPcs
	 0sVNSRkkixvKas0cYQEtnqMVWq7SuTaaZZXUUMJml+I+hSnlxk8HnCja5ERppppcLW
	 quVOW+asP6gdWhFKtaIJr1eO/1/Tdwcjw7w5GEJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0058/1518] io_uring/waitid: honor task_work cancellation
Date: Sat, 12 Sep 2026 08:37:07 +0200
Message-ID: <20260912065624.759434733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 14572de82e5022899e5856008bc9cac97004a88c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 


