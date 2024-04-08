Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957AA2DF73;
	Mon,  8 Apr 2024 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583754; cv=none; b=Pp1CD+I5cBwlQbZHERwtzHd7LSg5galCRCF7aMmGgIJU2x8TIML0CxNfqNoJDiVZqUWh2NdrKOwokmnteYs63+P+8CdAEGk6hQNE99LbUlq6VOCS0DCROBGyP/QI+V/ZHIbioEe05V8xBsfMxtQ/CIWSvyFJkq/hTwEqLjc0qO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583754; c=relaxed/simple;
	bh=kYIaQBP/CFhsKOq0W4yDU3qgIoZCdz+0pCKL1lKMdUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCtbSL8ua0PwwC4Xxypr3urz2tdqne24opbsRiBOyk+14rNUokc1sM+UA2WOiliH9y6kSJFtqKtsx6VWuxJaaf2UtPtV6xGdlGOMXWYlaa73wJqExeGci/WwpZ6bk9+WwBGsq2y3lVxak9wwI0qETeeOTfSKP4t8TCxg9izH2bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMpZiH0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMpZiH0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB7CC433F1;
	Mon,  8 Apr 2024 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583754;
	bh=kYIaQBP/CFhsKOq0W4yDU3qgIoZCdz+0pCKL1lKMdUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMpZiH0RHUXS1KycMyDOugcdKDUzYuvSowobs5FCBFuznI+YKa8NUwgNHhxLwbBIL
	 LGmfzI7DHBduaG1vOCcgCJiuDkqSxyEBjIwK+AeHwAfxbDDYSCxXPK+dxc33mhQqSy
	 /4DQeyNGsjXxQREQwSrpvU7zXt4tT8GtMGAuUgis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Karlsson <rasmus.karlsson@pajlada.com>,
	Iskren Chernev <me@iskren.info>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 212/252] io_uring: use private workqueue for exit work
Date: Mon,  8 Apr 2024 14:58:31 +0200
Message-ID: <20240408125313.232345218@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

commit 73eaa2b583493b680c6f426531d6736c39643bfb upstream.

Rather than use the system unbound event workqueue, use an io_uring
specific one. This avoids dependencies with the tty, which also uses
the system_unbound_wq, and issues flushes of said workqueue from inside
its poll handling.

Cc: stable@vger.kernel.org
Reported-by: Rasmus Karlsson <rasmus.karlsson@pajlada.com>
Tested-by: Rasmus Karlsson <rasmus.karlsson@pajlada.com>
Tested-by: Iskren Chernev <me@iskren.info>
Link: https://github.com/axboe/liburing/issues/1113
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -148,6 +148,7 @@ static bool io_uring_try_cancel_requests
 static void io_queue_sqe(struct io_kiocb *req);
 
 struct kmem_cache *req_cachep;
+static struct workqueue_struct *iou_wq __ro_after_init;
 
 static int __read_mostly sysctl_io_uring_disabled;
 static int __read_mostly sysctl_io_uring_group = -1;
@@ -3180,7 +3181,7 @@ static __cold void io_ring_ctx_wait_and_
 	 * noise and overhead, there's no discernable change in runtime
 	 * over using system_wq.
 	 */
-	queue_work(system_unbound_wq, &ctx->exit_work);
+	queue_work(iou_wq, &ctx->exit_work);
 }
 
 static int io_uring_release(struct inode *inode, struct file *file)
@@ -4664,6 +4665,8 @@ static int __init io_uring_init(void)
 				offsetof(struct io_kiocb, cmd.data),
 				sizeof_field(struct io_kiocb, cmd.data), NULL);
 
+	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
+
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
 #endif


