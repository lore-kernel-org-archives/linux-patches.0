Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8DE22301;
	Thu, 16 Jul 2026 13:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210299; cv=none; b=j9YdxAnDn6IbydDo0q0SXb2iQ2YVZlkZD6XDWMJ5Fs9XvBsbmrDu/yfVubbWTm6Nnx0c4xiBM2fMs9H2eI/QviPvOIOoeZe62kuZSDQHeZrNYTCwjS8IXzdDbnAbJsPzbxX293T30Fr/2qi2kuCsBtFp1m2TRX4XJ6M3Hj7uMMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210299; c=relaxed/simple;
	bh=B/0lWOhxMM74wN6dSFwQgYzUfpv03i+G3GEGvHpQdo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5Yufn/1zLHutw6wqupIDL4ELLvhmQcBxgppIVhVsl2OXlKovNmfrZTIJd2WVGel66CG2NcSyZRh6v5A0GdnlAAlLejacLZ8DTTKg2U9zpz3kG5AeF4XwHLBLrqcqI3+bc0WWH+YLzilyHh77EP/31/YVyMCufhS6l30SseOWA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePEPkWAh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePEPkWAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD811F000E9;
	Thu, 16 Jul 2026 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210298;
	bh=v7eBKfoEepEX6NvViTNzGMtdzmjWW1onNLBXSI4nnuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePEPkWAhhJu9p0bdWMQodt8Zszf49jCYItn+051wjeySZUM3FEid2ZJWLN2Itysi7
	 tm7B9LkZvRd1VPI3pN43hqLz8kPzLKkisGgM6dKusZY+YKiKmjiFVUu30JqVlcuv7N
	 f1j4vVZj1UopwCQgtNoTfea9AzitFnGNA8fFMGgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Berkant Koc <me@berkoc.com>,
	xlabai <xlabai@tencent.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	stable@kernel.org
Subject: [PATCH 7.1 513/518] fuse-uring: Avoid queue->stopped races and set/read that value under lock
Date: Thu, 16 Jul 2026 15:33:01 +0200
Message-ID: <20260716133059.062059348@linuxfoundation.org>
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

From: Bernd Schubert <bernd@bsbernd.com>

commit b70a3aca16934c196f92abb17b01c1647b9bb63c upstream.

There are several readers of queue->stopped that check the value
under lock, but fuse_uring_commit_fetch() did not and actually
the value was not set under the lock in fuse_uring_abort_end_requests()
either. Especially in fuse_uring_commit_fetch it is important
to check under a lock, because due to races 'struct fuse_req'
might be freed with fuse_request_end, but another thread/cpu
might already do teardown work.

Cc: stable@kernel.org # 6.14
Fixes: 4a9bfb9b6850fec ("fuse: {io-uring} Handle teardown of ring entries")
Reported-by: Berkant Koc <me@berkoc.com>
Reported-by: xlabai <xlabai@tencent.com>
Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -131,10 +131,9 @@ void fuse_uring_abort_end_requests(struc
 		if (!queue)
 			continue;
 
-		queue->stopped = true;
-
 		WARN_ON_ONCE(ring->fc->max_background != UINT_MAX);
 		spin_lock(&queue->lock);
+		queue->stopped = true;
 		spin_lock(&fc->bg_lock);
 		fuse_uring_flush_bg(queue);
 		spin_unlock(&fc->bg_lock);
@@ -467,7 +466,7 @@ static void fuse_uring_async_stop_queues
 				      FUSE_URING_TEARDOWN_INTERVAL);
 	} else {
 		wake_up_all(&ring->stop_waitq);
-		fuse_conn_put(ring->chan->conn);
+		fuse_conn_put(ring->fc);
 	}
 }
 
@@ -479,7 +478,7 @@ void fuse_uring_stop_queues(struct fuse_
 	fuse_uring_teardown_all_queues(ring);
 
 	if (atomic_read(&ring->queue_refs) > 0) {
-		fuse_conn_get(ring->chan->conn);
+		fuse_conn_get(ring->fc);
 		ring->teardown_time = jiffies;
 		INIT_DELAYED_WORK(&ring->async_teardown_work,
 				  fuse_uring_async_stop_queues);
@@ -900,10 +899,15 @@ static int fuse_uring_commit_fetch(struc
 		return err;
 	fpq = &queue->fpq;
 
-	if (!READ_ONCE(fc->connected) || READ_ONCE(queue->stopped))
+	if (!READ_ONCE(fc->connected))
 		return err;
 
 	spin_lock(&queue->lock);
+	if (unlikely(queue->stopped)) {
+		spin_unlock(&queue->lock);
+		return err;
+	}
+
 	/* Find a request based on the unique ID of the fuse request
 	 * This should get revised, as it needs a hash calculation and list
 	 * search. And full struct fuse_pqueue is needed (memory overhead).


