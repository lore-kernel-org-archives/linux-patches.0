Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E3241A8F;
	Sat, 30 May 2026 18:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165902; cv=none; b=b3zEZL8b+dYyC7GjquZ4M3VXLw8vRwU/YQR9D/ZTCH0hj31poNi4nnlfNldxcXSTv91lIRrRnefENkShwOTc533Su8u0UoIGaK2LCZDaT1BWBlvC6dcwH+wbtVoU12D0PeGUC3rVT6QQJNLl08lDQ+38RpeaLTn/uh/i9g+gCsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165902; c=relaxed/simple;
	bh=UessfMRR6tarAFvodIUce5qK30Of1ySHFTBVbHdhFp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QngNmdDnJG6tYziS+xoIQqZYG14aKN4mYanvgBC3tdTamO5WQRlHqKnMvH+6/LiiY72C8ywKhFKAbuS5xDC06A8ax14odS2Eajzu4VGIwWuzb/uizgWdwUyDakOvH69LLjSczX9MtI6a2EjkqGgjSS1HLG6usTjjqJkWo4VfSaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uvxk3Ts+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uvxk3Ts+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3681F00893;
	Sat, 30 May 2026 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165901;
	bh=6LhGS8cbHBQhF1Bf4x8vcwHYPYW/oyJYFN3d0UxY9qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uvxk3Ts+7SqBQKBQS4E4boviJCN+tupHjxgZOdppr0RIVV/aI0UtFlyH2hTI7gtyA
	 /FX+bjl4mYkABjvMQn/G4MQO2aOSfH2/0IPxjftWP7IzzkADY+ORmIWVdqanh83oae
	 4BMM2vYgQ3BAePHgnXeCZdbVMLQ1NCFsdADfmYsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/589] io_uring/poll: fix backport of io_poll_add() changes
Date: Sat, 30 May 2026 18:01:03 +0200
Message-ID: <20260530160229.672069390@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

The 5.15/5.10 backport of 84230ad2d2af had a few issues, due to the
older poll base. Notably return value handling __io_arm_poll_handler()
and in return __io_poll_add() as well. Fix them up.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 349ef5d2e7bf ("io_uring/poll: correctly handle io_poll_add() return value on update")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7cb4eeefd3cf4..2ca09e2dbd3d4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5997,26 +5997,22 @@ static int __io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	if (!ret && ipt.error)
 		req_set_fail(req);
 	ret = ret ?: ipt.error;
-	if (ret > 0) {
+	if (ret)
 		__io_req_complete(req, issue_flags, ret, 0);
-		return ret;
-	}
-	return 0;
+	return ret;
 }
 
 static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 {
-	int ret;
-
-	ret = __io_poll_add(req, issue_flags);
-	return ret < 0 ? ret : 0;
+	__io_poll_add(req, issue_flags);
+	return 0;
 }
 
 static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
-	int ret2, ret = 0;
+	int ret2 = -ECANCELED, ret = 0;
 
 	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 
@@ -6047,7 +6043,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 		preq->result = ret2;
 
 	}
-	if (preq->result < 0)
+	if (ret2 < 0)
 		req_set_fail(preq);
 	io_req_complete(preq, preq->result);
 out:
-- 
2.53.0



