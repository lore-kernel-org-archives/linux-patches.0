Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C363128CC;
	Thu, 16 Jul 2026 14:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211555; cv=none; b=gQ6pDrrO3wV8bC35dBwirvs6xvZ7zbdFiVU6sF+Zt1+aS153NxldOD2UjFsvezsmANZH3uFjwoBQ6+I9iGO95PQLx7TpdB+VRfYrg422D1h4KsdzS3vkoE3H3MvKodvmDExMuT8JGcoczlL/g9IruO5ctXa9El5IxUSH6xey3ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211555; c=relaxed/simple;
	bh=2UD00SVpjcXnKKWFvascZzrNxhfdmblTQkBehBwqz2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWKEMKFJX+Gu3n9AWqWWJ8DJi0INdLzFNmniynZQ/f8Q2p6JJ51udrKkHlbvPieFoxUb0GNOhLTApiIYliGn9m4Vh5mimEFQEkskOwKSZJUKCVOwg6Kb/8mZfrEVHW7DklSdnyRA/hhOfbeBP/tCdIWHr8PcQIeX/t17uoNJ0wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxVw3QyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxVw3QyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A461F000E9;
	Thu, 16 Jul 2026 14:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211553;
	bh=9vNV0WrByJ1QACZtv9CXrdoHWf2FD/4VzE6jGJYrdmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxVw3QyFmIQpiOszV+sum2Kx0a505q4PmNbC1AHfV2ol5IDy1v4K4MCxjLedj9Yu4
	 +PCs5jCGtWEkUk8R7HqqLvpQRETpsK2fpChos6DxtV8n5PwVjpnx4MkU/NIR0zvoED
	 uBvqwz6gNBOFNeen94QZPhrsVhyMFoSZH4vV64Nk=
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
Subject: [PATCH 6.18 473/480] fuse-uring: Avoid queue->stopped races and set/read that value under lock
Date: Thu, 16 Jul 2026 15:33:40 +0200
Message-ID: <20260716133055.053423787@linuxfoundation.org>
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
@@ -462,7 +461,7 @@ static void fuse_uring_async_stop_queues
 				      FUSE_URING_TEARDOWN_INTERVAL);
 	} else {
 		wake_up_all(&ring->stop_waitq);
-		fuse_conn_put(ring->chan->conn);
+		fuse_conn_put(ring->fc);
 	}
 }
 
@@ -483,7 +482,7 @@ void fuse_uring_stop_queues(struct fuse_
 	}
 
 	if (atomic_read(&ring->queue_refs) > 0) {
-		fuse_conn_get(ring->chan->conn);
+		fuse_conn_get(ring->fc);
 		ring->teardown_time = jiffies;
 		INIT_DELAYED_WORK(&ring->async_teardown_work,
 				  fuse_uring_async_stop_queues);
@@ -903,10 +902,15 @@ static int fuse_uring_commit_fetch(struc
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


