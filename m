Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61016A35A;
	Mon,  8 Apr 2024 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583702; cv=none; b=GaRPPUam6pSivtUl0JxzhgXvKTC2OYXgZwZKFpDQ6lYUSTzE5dMC2ACKH7PNw/94GOReoykzUbG178C78EmkwY/pbRBiY3STigKSkPDuRTiZPp93fN0uz87bC1hZqbRbLi7qoHS7bdo9sZMg0n38V6ijK93a+IaICH1z8O0Y8gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583702; c=relaxed/simple;
	bh=lmewIyPsIK4EfW8XAJNHI4nHGHGWIHZNWUXhUa+AL14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOpRu8avvetky6iVYQekcIjgMeh556iVpWL+A22ZQHhM9Rp2uTMJGNJWdySRj6g4QLiyox6DqpRkc07wGwvNDrXiVF00p/cnZuwf/isJ1mPUC7wBwHbWjGeXfiNjDLHr32r+Uvwmtv5R4DJ2QfZ05rg4c7LR0Qn3yk4qq4ym+HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNH6g6FO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNH6g6FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365BBC433F1;
	Mon,  8 Apr 2024 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583701;
	bh=lmewIyPsIK4EfW8XAJNHI4nHGHGWIHZNWUXhUa+AL14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNH6g6FOwMe6rUPcn3zjs2QJjr6d1BY6hBe26UvD+A5Y5wbwvpitxGuK/mE2PtOeC
	 8JEU+eLN197QlweyIw8Hu44pnBJ/dO4vh/xqky3nHuEbqI87LYmGdY0/Ee2qOSSlSG
	 wPTB04XXTAwNH1bSfk17BhVo/20ATQfdhAkVkdK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Karlsson <rasmus.karlsson@pajlada.com>,
	Iskren Chernev <me@iskren.info>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.8 210/273] io_uring: use private workqueue for exit work
Date: Mon,  8 Apr 2024 14:58:05 +0200
Message-ID: <20240408125315.880074381@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,6 +152,7 @@ static bool io_uring_try_cancel_requests
 static void io_queue_sqe(struct io_kiocb *req);
 
 struct kmem_cache *req_cachep;
+static struct workqueue_struct *iou_wq __ro_after_init;
 
 static int __read_mostly sysctl_io_uring_disabled;
 static int __read_mostly sysctl_io_uring_group = -1;
@@ -3139,7 +3140,7 @@ static __cold void io_ring_ctx_wait_and_
 	 * noise and overhead, there's no discernable change in runtime
 	 * over using system_wq.
 	 */
-	queue_work(system_unbound_wq, &ctx->exit_work);
+	queue_work(iou_wq, &ctx->exit_work);
 }
 
 static int io_uring_release(struct inode *inode, struct file *file)
@@ -4164,6 +4165,8 @@ static int __init io_uring_init(void)
 					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT,
 					  NULL);
 
+	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
+
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
 #endif


