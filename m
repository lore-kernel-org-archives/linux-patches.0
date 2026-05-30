Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A21349CCF;
	Sat, 30 May 2026 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163380; cv=none; b=qFP5p8jtJMCG6oEW/DVpRkraN4rl/vFBWls61c0iUHZeW9wT8ZkxTrpAsZMLGE/E741hfap3GDyrri12Ro2iHhC4rfhI2WSoXOGkxsp/FuqtVukM7yicE6tnXOxzzMAvNIpwwpd59hWReJ/9zGlo/yvVzFf/rdx1J2DQ9T8DJ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163380; c=relaxed/simple;
	bh=rO598c8ZtJVx2zIQ2l/qDSXdsXaAvd6bqXYdIxoJtso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gh9LhFOkp87ypJsPVlVPESrrCfVoR4hdBRtmCx+GIdWtojEkhO8PhkAsezy6e6ry8Anuu3E9Iu/zn1IQtdOXNg27S/ZwHbYGbfUJKFOnkqwcG1hN2OEalGlVSLoUWWVuIROyKB8sFXY7bcK0NTkTnavbbCV/gz3YSXRk7fRFDhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TctVfBL/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TctVfBL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31CB1F00893;
	Sat, 30 May 2026 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163379;
	bh=f6IWJivzao6wNUUwmYxzvXs7IJ1AQbHwHhYtNBnaI0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TctVfBL/1KE6zVvIkjgdTwcDIWpoI8pWYKbVmZBvTx6HUzgR5R4vcdjZWwjrWHEtO
	 CVRfEu2b1gYFWUTGfY+IzH5L6vll/7O3EaI+GbK48KfymYZiRkVKPYIIU3eii9LfvX
	 hlnruaE71+mQItae+usRrWNvij9XtgTjpRil5WFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/776] io_uring/poll: fix backport of io_poll_add() changes
Date: Sat, 30 May 2026 17:59:15 +0200
Message-ID: <20260530160246.759511121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4f1dda7d68c22..cb54ebda0a8a7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -6144,26 +6144,22 @@ static int __io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
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
 
@@ -6194,7 +6190,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 		preq->result = ret2;
 
 	}
-	if (preq->result < 0)
+	if (ret2 < 0)
 		req_set_fail(preq);
 	io_req_complete(preq, preq->result);
 out:
-- 
2.53.0



