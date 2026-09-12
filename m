Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAEC35C6B2;
	Sat, 12 Sep 2026 09:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205691; cv=none; b=HN5kLKmZgSeRsgnA8veiZRUM0SudwTBqze8XhP/ohKRZL74CdXZV5SyHgoZTk4Pxhx+li8/reGBRxdnIRbUJ7lmllf34FXSWVYpMe5hjMmSMXvbc0/5huDKiEDgKFQ2pvd1lr9aWtsa4oV+uKpzZolG0TbeP7G3ASX+EQaazyx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205691; c=relaxed/simple;
	bh=9N1cnNSMgB6pxtBfuxw3hafos+5AQUQsRqxcOCm/63A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkczvZdeChmv1b1EFpqQ4aDMc8yToLso/gAotC5f22frO2ErCwo/pJVw3ySh9s5bxz2ibw3jSyVBIpRzDYNzrDLNjpi5+CVyPuEnxxxiwNM+qMin5zwKvqmSVnMUXnvxiQq7XDrv88XS+3Jfxk03MgPdIUZOB6IkFCC9u1fzhrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVZfuKUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVZfuKUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE661F00893;
	Sat, 12 Sep 2026 09:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205690;
	bh=JzDez5dxedmnV7Vq+XChmBz/gvi+19vwwJpceuysH0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVZfuKUjHBXkJdK68eLcSw2KKsnh3O9RovJptEgarijl3rJQ9mw/+63HwYZQQ0EF5
	 ZU/onBiApMj+N1YRLuARaa8r5jV5IGTXAvTFc/XgN7NU3N+k4PKOau51rn6tQyGDzb
	 YncH3as/I5iE7pxAGMQ3ziuiYmWsFLWzm+NDrUo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0054/1518] io_uring: only call io_should_terminate_tw() once for ctx
Date: Sat, 12 Sep 2026 08:37:03 +0200
Message-ID: <20260912065624.666568243@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 4531d165ee39edb315b42a4a43e29339fa068e51 ]

io_fallback_req_func() calls io_should_terminate_tw() on each req's ctx.
But since the reqs all come from the ctx's fallback_llist, req->ctx will
be ctx for all of the reqs. Therefore, compute ts.cancel as
io_should_terminate_tw(ctx) just once, outside the loop.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 14572de82e50 ("io_uring/waitid: honor task_work cancellation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -292,10 +292,9 @@ static __cold void io_fallback_req_func(
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.node) {
-		ts.cancel = io_should_terminate_tw(req->ctx);
+	ts.cancel = io_should_terminate_tw(ctx);
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, ts);
-	}
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);


