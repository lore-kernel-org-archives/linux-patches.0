Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7EE424668;
	Thu, 16 Jul 2026 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211581; cv=none; b=kCvq7dpnvtI9qtrLxT6aw83DKBq6h5z5l4AxAnZldrspa77+o7lNORNYHD0JnphmDrwehXKLFBcJMzA/x1L88AY3XhR4fXYUQlxzIt8RSzEEMNEGQBHyl0z+iFT1mmgjaw2G3/1KwJwWmIE/jBgr6JvSCiTct0YCIP/uIY0g4Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211581; c=relaxed/simple;
	bh=8sjIYZ63bvdpG6mCpPvo2Fg5TENX3bwUJgHzA2lKFyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edaXlXTEEMpiOUQVFbQHqQI9A47vLbVOWmKkuwJXh6cgW/hyj0JKz6jZxhxXU4IZTzlz76Pj3XJuW1elqDlXm007w+J3nItcD/WFohWFUlzDV5VrYu9jkGqd2Zs0e4hkzZWEgag4ySmNP9DaMmcbmW5VtAkLzFA2fIgAwJ4ioXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGyA959y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGyA959y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742971F000E9;
	Thu, 16 Jul 2026 14:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211579;
	bh=CX7bNGpHLxfqU6WatBUoUWOD6uFf+oIDzIxkIw1Lia0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGyA959yBO4qO7z+idvYduk5BSRW7fOiCYHNdbs9pqmQYdIWYKTvuSAgTPkZy4zOS
	 9mW/sRpXtjoEuHuUW8AE8CPeo20zp7hUp2c8/XKkQHaLjRQ4gq8zqqFYRPGSSOb7au
	 eha7CrrXSq6TkLTUDRYZekHHoXPo2rBvqMJ5s8X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 466/480] fuse: fix io-uring background queue dispatch on request completion
Date: Thu, 16 Jul 2026 15:33:33 +0200
Message-ID: <20260716133054.903563461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -59,6 +59,7 @@ unsigned int fuse_req_hash(u64 unique);
 struct fuse_req *fuse_request_find(struct fuse_pqueue *fpq, u64 unique);
 
 void fuse_dev_end_requests(struct list_head *head);
+void fuse_request_bg_finish(struct fuse_conn *fc, struct fuse_req *req);
 
 void fuse_copy_init(struct fuse_copy_state *cs, bool write,
 			   struct iov_iter *iter);


