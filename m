Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525CC248BA0;
	Wed, 15 Jan 2025 10:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937779; cv=none; b=a1wCkeJioS6pHWmD5VpZ8e7po7KeECphQ81FqkKRmKJzdmTrbjujp03qkU4I9mjuLnj2kZW/gJjNBmteSqebX5pqsBdgxA0yfRRQ2XSbyDoeju6jifhE78gaZDIzFBj8w0GwzFXK8ONPiIaPx+YI9GO8NrJgyEOM4dHv0k49p80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937779; c=relaxed/simple;
	bh=nrpqoAZJ47Z3KFNjTP6eiSmgCsanAdb0+JM+bfzIxKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iU61YbVkzLma5RA0pejGZkRqrhMQIR0dAYbypZSBbAE1uwLhMb8x3NLWLeqqJDaX0L0jtESCNn/lgGLsb6bbxCJkCtp2TOA+i0RoXKxOCOsrZTI1NEtncrA1LUqp5ueIXH4g0/jUTTiPeswx/KGRwqt+vhNc/2uEfyuZhnq99rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Az+BEjOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Az+BEjOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E15C4CEE1;
	Wed, 15 Jan 2025 10:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937779;
	bh=nrpqoAZJ47Z3KFNjTP6eiSmgCsanAdb0+JM+bfzIxKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Az+BEjOFtu/I+VlGSNfSQVsjFBgRC9on+xj0UdOjvaEqxrMtWwqN8htS9ysM/rxjv
	 uC9+22C+rv3Kht8YUZBbi8IXqrRaZJ7JCUGcw4tVUAAy0+z7HfXC2PI+ZAgjspw6xw
	 fPkA0VrReu0YzsOg1O4g5wmje2fvafW6BFNdaZZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 79/92] io_uring/eventfd: ensure io_eventfd_signal() defers another RCU period
Date: Wed, 15 Jan 2025 11:37:37 +0100
Message-ID: <20250115103550.714223886@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit c9a40292a44e78f71258b8522655bffaf5753bdb upstream.

io_eventfd_do_signal() is invoked from an RCU callback, but when
dropping the reference to the io_ev_fd, it calls io_eventfd_free()
directly if the refcount drops to zero. This isn't correct, as any
potential freeing of the io_ev_fd should be deferred another RCU grace
period.

Just call io_eventfd_put() rather than open-code the dec-and-test and
free, which will correctly defer it another RCU grace period.

Fixes: 21a091b970cd ("io_uring: signal registered eventfd to process deferred task work")
Reported-by: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -479,6 +479,13 @@ static __cold void io_queue_deferred(str
 	}
 }
 
+static void io_eventfd_free(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
+}
 
 static void io_eventfd_ops(struct rcu_head *rcu)
 {
@@ -492,10 +499,8 @@ static void io_eventfd_ops(struct rcu_he
 	 * ordering in a race but if references are 0 we know we have to free
 	 * it regardless.
 	 */
-	if (atomic_dec_and_test(&ev_fd->refs)) {
-		eventfd_ctx_put(ev_fd->cq_ev_fd);
-		kfree(ev_fd);
-	}
+	if (atomic_dec_and_test(&ev_fd->refs))
+		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
 static void io_eventfd_signal(struct io_ring_ctx *ctx)


