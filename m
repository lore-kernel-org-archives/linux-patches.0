Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C4253FD4B;
	Mon, 31 Aug 2026 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183953; cv=none; b=GJh0YZheJ6Ff3sU4vy0J72JlqGV/2Isb6Qt4Nu78WxqZ0mNB8//w9UxZOjOZH8ZE50wQ+B8tVjTytZIlFBqjlo2YyTzLHPpnQj3cAfaV7CIAWsyp/DN73I5wq75eRxIANALIMTqr3nvET46z2w3zGuP30SqoWUKNwD+GgDWE1JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183953; c=relaxed/simple;
	bh=NM+a7DJx7sebBFHAqm2cNfhtnHtFJAXWv6UoAk+yFu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QztWAQ9D+kuPhAsZrP1whkmq4wgB+BhlqjV5jYhIfRjT0iI68zhIgguahz5K21FuF9GcuNc7NckrhDga2r60u7fkqg+S9oOep5VJJaCkbnOkYHATBVkCSRyQBC5hr1G5ypYcfK4piaz7DdYX75wl+0ed7rBb55yBo+29hr8IL5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCz4tZ+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCz4tZ+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884B81F00A3E;
	Mon, 31 Aug 2026 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183951;
	bh=WqDihK1oU4t1PNlc0BgaDCyWciDsUqSUog77RRtDQ0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCz4tZ+dDbcCCcm2QBlcL9RkgdEdCgWM2X+PmOiI8t5v5UQhrw5A9kJswe9flF4Db
	 Cr6kVCGpgiaPfqv7pIndw5dU1CDKvGk5cBRqCfvzf9CJaoqxjwr80/pAhhko+IMvRz
	 8LHYWBOyV+HRJ9yW5QSqaPciGk30MP9rEj/I4I7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 21/83] io_uring: simplify IORING_SETUP_DEFER_TASKRUN && !SQPOLL check
Date: Mon, 31 Aug 2026 15:33:57 +0200
Message-ID: <20260831133400.309820751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

[ Upstream commit 7cb3a68376da0bc0afab8157223cb479c97de9ff ]

io_uring_sanitise_params() already rejects flags that include both
IORING_SETUP_SQPOLL and IORING_SETUP_DEFER_TASKRUN. So it's unnecessary
to check IORING_SETUP_SQPOLL in io_uring_create() when
IORING_SETUP_DEFER_TASKRUN has already been checked. Drop the
!(ctx->flags & IORING_SETUP_SQPOLL) check for the task_complete case.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: cd305ee3633a ("io_uring: defer eventfd signaling when queued from a wakeup handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3867,8 +3867,7 @@ static __cold int io_uring_create(unsign
 		static_branch_deferred_inc(&io_key_has_sqarray);
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
-	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
-	    !(ctx->flags & IORING_SETUP_SQPOLL))
+	    !(ctx->flags & IORING_SETUP_IOPOLL))
 		ctx->task_complete = true;
 
 	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL))


