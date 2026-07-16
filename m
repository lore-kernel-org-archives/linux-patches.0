Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD6231E85C;
	Thu, 16 Jul 2026 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210275; cv=none; b=riJtilT6dZUvZrTnNN0oRkYOzOl+cSRMrqnxeMDGBYLXlzfJAAZsdHOuZ/S0d0uL/m2CmWScwE8S5sPPAOnWa8uJSpVtuwxE2fsQ/8Bp5E75EfFUIi7zFKRC+pi4Sq4SQvQZvD/X3+YFQzA1PF8aC7wBHLesaD0aONbqUgRhx9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210275; c=relaxed/simple;
	bh=wrqceAGB7fu3b+Xeud57rtnZ4zRhXgE1xB5Y6kC02zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx3jCYSleHFgUHm7PLtnnp+OqsfvAdOoWhL6Zfdn5igkBpm1DVmPS8GFurvFJiWWLsshs/Qg+AeHyiZgZZTh8IlkNSWAsP1rzPXoDwHPAOxoZB9dc9duXicDfja/6Kh8PtXzmtMxiNpRV6moDiAqz3IpoEV4sFOV/47FF4bEL6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNxF2aAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNxF2aAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22D31F000E9;
	Thu, 16 Jul 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210274;
	bh=/1EM1oEu7yobIB+lOFJmIQEyLiPftK/7nt3SnAX/Xds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNxF2aAgsqzIr1dzUmz7HqK+0PZ2mXmq2y3cWKsuFG9QGixYoe2rl6hpTY52gO+SF
	 U0Pqh+jempuH14jS5pPCAsFJFpj1sUdYHTHQ8ViiQ07jNg6kBt0EZDVHqbFqJA138h
	 ECIANuaVo+U17WCwQLkrqmg9mRAuPFxymWVmgejE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 505/518] fuse: fix io-uring background queue dispatch on request completion
Date: Thu, 16 Jul 2026 15:32:53 +0200
Message-ID: <20260716133058.891596729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit 31da059891bd3be9c6e59280b8e1777ead90db34 upstream.

When a background request completes via the io_uring path, the
background queue gets flushed to dispatch pending background requests,
but this is done before the connection-level background counters
(fc->num_background, fc->active_background) are properly accounted,
which may reduce effective queue depth to one.

The connection-level counters are decremented in fuse_request_end(), but
flush_bg_queue() flushes the /dev/fuse path queue (fc->bg_queue), not
the io_uring per-queue bg one, which means pending uring background
requests on the queue are never dispatched in this path.

Fix this by accounting the connection-level background counters first
before flushing the queue's background queue. Since
fuse_request_bg_finish() clears FR_BACKGROUND, fuse_request_end() will
skip the background cleanup branch entirely, which avoids any
double-decrements; it will call the wake_up(&req->waitq) branch but this
is effectively a no-op as background requests have no waiters on
req->waitq.

Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Fixes: 857b0263f30e ("fuse: Allow to queue bg requests through io-uring")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c        |   41 ++++++++++++++++++++++++-----------------
 fs/fuse/dev_uring.c  |    1 +
 fs/fuse/fuse_dev_i.h |    1 +
 3 files changed, 26 insertions(+), 17 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -447,6 +447,29 @@ static void flush_bg_queue(struct fuse_c
 	}
 }
 
+void fuse_request_bg_finish(struct fuse_conn *fc, struct fuse_req *req)
+{
+	lockdep_assert_held(&fc->bg_lock);
+
+	clear_bit(FR_BACKGROUND, &req->flags);
+	if (fc->num_background == fc->max_background) {
+		fc->blocked = 0;
+		wake_up(&fc->blocked_waitq);
+	} else if (!fc->blocked) {
+		/*
+		 * Wake up next waiter, if any.  It's okay to use
+		 * waitqueue_active(), as we've already synced up
+		 * fc->blocked with waiters with the wake_up() call
+		 * above.
+		 */
+		if (waitqueue_active(&fc->blocked_waitq))
+			wake_up(&fc->blocked_waitq);
+	}
+
+	fc->num_background--;
+	fc->active_background--;
+}
+
 /*
  * This function is called when a request is finished.  Either a reply
  * has arrived or it was aborted (and not yet sent) or some error
@@ -479,23 +502,7 @@ void fuse_request_end(struct fuse_req *r
 	WARN_ON(test_bit(FR_SENT, &req->flags));
 	if (test_bit(FR_BACKGROUND, &req->flags)) {
 		spin_lock(&fc->bg_lock);
-		clear_bit(FR_BACKGROUND, &req->flags);
-		if (fc->num_background == fc->max_background) {
-			fc->blocked = 0;
-			wake_up(&fc->blocked_waitq);
-		} else if (!fc->blocked) {
-			/*
-			 * Wake up next waiter, if any.  It's okay to use
-			 * waitqueue_active(), as we've already synced up
-			 * fc->blocked with waiters with the wake_up() call
-			 * above.
-			 */
-			if (waitqueue_active(&fc->blocked_waitq))
-				wake_up(&fc->blocked_waitq);
-		}
-
-		fc->num_background--;
-		fc->active_background--;
+		fuse_request_bg_finish(fc, req);
 		flush_bg_queue(fc);
 		spin_unlock(&fc->bg_lock);
 	} else {
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -90,6 +90,7 @@ static void fuse_uring_req_end(struct fu
 	if (test_bit(FR_BACKGROUND, &req->flags)) {
 		queue->active_background--;
 		spin_lock(&fc->bg_lock);
+		fuse_request_bg_finish(fc, req);
 		fuse_uring_flush_bg(queue);
 		spin_unlock(&fc->bg_lock);
 	}
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -77,6 +77,7 @@ unsigned int fuse_req_hash(u64 unique);
 struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
 
 void fuse_dev_end_requests(struct list_head *head);
+void fuse_request_bg_finish(struct fuse_conn *fc, struct fuse_req *req);
 
 void fuse_copy_init(struct fuse_copy_state *cs, bool write,
 			   struct iov_iter *iter);


