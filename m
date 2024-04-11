Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F98E13F452;
	Thu, 11 Apr 2024 10:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830575; cv=none; b=dCiiSTJBMcPHGQSEhpKrPQB9xe5SmHnAqmsMY1PGebP2nvNjZO8dcvDSTXMcz6M12Y8Hlhh4/YOwpzuTQOd9QrY2KmlU6r7t23Hhwaqxm0mc6pLo9daYG9VgqliWTTxMs8yoOs8KgXgOuZE+19cNW1X6yvlU2regyIZ7uWTqF1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830575; c=relaxed/simple;
	bh=SSZfXG/whBuHE7HPLFzPNVkUPTcoGz32QSdzqwH1+HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqKBqfAyll3Y/aLsu/TVtdvoxHsq3NMci9s6PRVymZNymaK8lf+I6wypGZBlVLAejIBEBDlA05raKDoGBoEEiO1r3UXtJLe9P8JGr1mSb5VFagUNhORgqoRb19v6ITvgNfu3LciHZR5NDxBIerSOZ1yz+ZNcOy8MoNeRQ5VW0nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPNMWPiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPNMWPiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D39C433F1;
	Thu, 11 Apr 2024 10:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830575;
	bh=SSZfXG/whBuHE7HPLFzPNVkUPTcoGz32QSdzqwH1+HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPNMWPiMOG5Llztw67Zv0wJcJNbmPoLjrUULOyt70mnDq3VI6PKrImGSD8tQbPNqq
	 iVNvACY8/S8dwfwRuw/SlqA//7F0x/IUsvkapOA2Y8LkzhqfF7fgCJ1dMLlea9VkD8
	 w2UqVmwajM/GEyj9Y7N4pbqujdMYTudzGqBx9PU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Reitz <mreitz@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/215] fuse: drop fuse_conn parameter where possible
Date: Thu, 11 Apr 2024 11:54:15 +0200
Message-ID: <20240411095426.279231216@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Reitz <mreitz@redhat.com>

[ Upstream commit 8f622e9497bbbd5df4675edf782500cd9fe961ba ]

With the last commit, all functions that handle some existing fuse_req
no longer need to be given the associated fuse_conn, because they can
get it from the fuse_req object.

Signed-off-by: Max Reitz <mreitz@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: b1fe686a765e ("fuse: don't unhash root")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c       | 70 +++++++++++++++++++++++++--------------------
 fs/fuse/fuse_i.h    |  2 +-
 fs/fuse/virtio_fs.c |  8 ++----
 3 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 185cae8a7ce11..96fcb004190e2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -101,7 +101,7 @@ static void fuse_drop_waiting(struct fuse_conn *fc)
 	}
 }
 
-static void fuse_put_request(struct fuse_conn *fc, struct fuse_req *req);
+static void fuse_put_request(struct fuse_req *req);
 
 static struct fuse_req *fuse_get_req(struct fuse_conn *fc, bool for_background)
 {
@@ -144,7 +144,7 @@ static struct fuse_req *fuse_get_req(struct fuse_conn *fc, bool for_background)
 
 	if (unlikely(req->in.h.uid == ((uid_t)-1) ||
 		     req->in.h.gid == ((gid_t)-1))) {
-		fuse_put_request(fc, req);
+		fuse_put_request(req);
 		return ERR_PTR(-EOVERFLOW);
 	}
 	return req;
@@ -154,8 +154,10 @@ static struct fuse_req *fuse_get_req(struct fuse_conn *fc, bool for_background)
 	return ERR_PTR(err);
 }
 
-static void fuse_put_request(struct fuse_conn *fc, struct fuse_req *req)
+static void fuse_put_request(struct fuse_req *req)
 {
+	struct fuse_conn *fc = req->fc;
+
 	if (refcount_dec_and_test(&req->count)) {
 		if (test_bit(FR_BACKGROUND, &req->flags)) {
 			/*
@@ -274,8 +276,9 @@ static void flush_bg_queue(struct fuse_conn *fc)
  * the 'end' callback is called if given, else the reference to the
  * request is released
  */
-void fuse_request_end(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_request_end(struct fuse_req *req)
 {
+	struct fuse_conn *fc = req->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 
 	if (test_and_set_bit(FR_FINISHED, &req->flags))
@@ -326,12 +329,14 @@ void fuse_request_end(struct fuse_conn *fc, struct fuse_req *req)
 	if (test_bit(FR_ASYNC, &req->flags))
 		req->args->end(fc, req->args, req->out.h.error);
 put_request:
-	fuse_put_request(fc, req);
+	fuse_put_request(req);
 }
 EXPORT_SYMBOL_GPL(fuse_request_end);
 
-static int queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
+static int queue_interrupt(struct fuse_req *req)
 {
+	struct fuse_iqueue *fiq = &req->fc->iq;
+
 	spin_lock(&fiq->lock);
 	/* Check for we've sent request to interrupt this req */
 	if (unlikely(!test_bit(FR_INTERRUPTED, &req->flags))) {
@@ -358,8 +363,9 @@ static int queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 	return 0;
 }
 
-static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
+static void request_wait_answer(struct fuse_req *req)
 {
+	struct fuse_conn *fc = req->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 	int err;
 
@@ -374,7 +380,7 @@ static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
 		/* matches barrier in fuse_dev_do_read() */
 		smp_mb__after_atomic();
 		if (test_bit(FR_SENT, &req->flags))
-			queue_interrupt(fiq, req);
+			queue_interrupt(req);
 	}
 
 	if (!test_bit(FR_FORCE, &req->flags)) {
@@ -403,9 +409,9 @@ static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
 	wait_event(req->waitq, test_bit(FR_FINISHED, &req->flags));
 }
 
-static void __fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
+static void __fuse_request_send(struct fuse_req *req)
 {
-	struct fuse_iqueue *fiq = &fc->iq;
+	struct fuse_iqueue *fiq = &req->fc->iq;
 
 	BUG_ON(test_bit(FR_BACKGROUND, &req->flags));
 	spin_lock(&fiq->lock);
@@ -419,7 +425,7 @@ static void __fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 		__fuse_get_request(req);
 		queue_request_and_unlock(fiq, req);
 
-		request_wait_answer(fc, req);
+		request_wait_answer(req);
 		/* Pairs with smp_wmb() in fuse_request_end() */
 		smp_rmb();
 	}
@@ -458,8 +464,10 @@ static void fuse_adjust_compat(struct fuse_conn *fc, struct fuse_args *args)
 	}
 }
 
-static void fuse_force_creds(struct fuse_conn *fc, struct fuse_req *req)
+static void fuse_force_creds(struct fuse_req *req)
 {
+	struct fuse_conn *fc = req->fc;
+
 	req->in.h.uid = from_kuid_munged(fc->user_ns, current_fsuid());
 	req->in.h.gid = from_kgid_munged(fc->user_ns, current_fsgid());
 	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
@@ -484,7 +492,7 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 		req = fuse_request_alloc(fc, GFP_KERNEL | __GFP_NOFAIL);
 
 		if (!args->nocreds)
-			fuse_force_creds(fc, req);
+			fuse_force_creds(req);
 
 		__set_bit(FR_WAITING, &req->flags);
 		__set_bit(FR_FORCE, &req->flags);
@@ -501,20 +509,20 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 
 	if (!args->noreply)
 		__set_bit(FR_ISREPLY, &req->flags);
-	__fuse_request_send(fc, req);
+	__fuse_request_send(req);
 	ret = req->out.h.error;
 	if (!ret && args->out_argvar) {
 		BUG_ON(args->out_numargs == 0);
 		ret = args->out_args[args->out_numargs - 1].size;
 	}
-	fuse_put_request(fc, req);
+	fuse_put_request(req);
 
 	return ret;
 }
 
-static bool fuse_request_queue_background(struct fuse_conn *fc,
-					  struct fuse_req *req)
+static bool fuse_request_queue_background(struct fuse_req *req)
 {
+	struct fuse_conn *fc = req->fc;
 	bool queued = false;
 
 	WARN_ON(!test_bit(FR_BACKGROUND, &req->flags));
@@ -561,8 +569,8 @@ int fuse_simple_background(struct fuse_conn *fc, struct fuse_args *args,
 
 	fuse_args_to_req(req, args);
 
-	if (!fuse_request_queue_background(fc, req)) {
-		fuse_put_request(fc, req);
+	if (!fuse_request_queue_background(req)) {
+		fuse_put_request(req);
 		return -ENOTCONN;
 	}
 
@@ -592,7 +600,7 @@ static int fuse_simple_notify_reply(struct fuse_conn *fc,
 	} else {
 		err = -ENODEV;
 		spin_unlock(&fiq->lock);
-		fuse_put_request(fc, req);
+		fuse_put_request(req);
 	}
 
 	return err;
@@ -1277,7 +1285,7 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 		/* SETXATTR is special, since it may contain too large data */
 		if (args->opcode == FUSE_SETXATTR)
 			req->out.h.error = -E2BIG;
-		fuse_request_end(fc, req);
+		fuse_request_end(req);
 		goto restart;
 	}
 	spin_lock(&fpq->lock);
@@ -1320,8 +1328,8 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	/* matches barrier in request_wait_answer() */
 	smp_mb__after_atomic();
 	if (test_bit(FR_INTERRUPTED, &req->flags))
-		queue_interrupt(fiq, req);
-	fuse_put_request(fc, req);
+		queue_interrupt(req);
+	fuse_put_request(req);
 
 	return reqsize;
 
@@ -1329,7 +1337,7 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	if (!test_bit(FR_PRIVATE, &req->flags))
 		list_del_init(&req->list);
 	spin_unlock(&fpq->lock);
-	fuse_request_end(fc, req);
+	fuse_request_end(req);
 	return err;
 
  err_unlock:
@@ -1911,9 +1919,9 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 		else if (oh.error == -ENOSYS)
 			fc->no_interrupt = 1;
 		else if (oh.error == -EAGAIN)
-			err = queue_interrupt(&fc->iq, req);
+			err = queue_interrupt(req);
 
-		fuse_put_request(fc, req);
+		fuse_put_request(req);
 
 		goto copy_finish;
 	}
@@ -1943,7 +1951,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 		list_del_init(&req->list);
 	spin_unlock(&fpq->lock);
 
-	fuse_request_end(fc, req);
+	fuse_request_end(req);
 out:
 	return err ? err : nbytes;
 
@@ -2079,7 +2087,7 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 }
 
 /* Abort all requests on the given list (pending or processing) */
-static void end_requests(struct fuse_conn *fc, struct list_head *head)
+static void end_requests(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct fuse_req *req;
@@ -2087,7 +2095,7 @@ static void end_requests(struct fuse_conn *fc, struct list_head *head)
 		req->out.h.error = -ECONNABORTED;
 		clear_bit(FR_SENT, &req->flags);
 		list_del_init(&req->list);
-		fuse_request_end(fc, req);
+		fuse_request_end(req);
 	}
 }
 
@@ -2182,7 +2190,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 		wake_up_all(&fc->blocked_waitq);
 		spin_unlock(&fc->lock);
 
-		end_requests(fc, &to_end);
+		end_requests(&to_end);
 	} else {
 		spin_unlock(&fc->lock);
 	}
@@ -2212,7 +2220,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 			list_splice_init(&fpq->processing[i], &to_end);
 		spin_unlock(&fpq->lock);
 
-		end_requests(fc, &to_end);
+		end_requests(&to_end);
 
 		/* Are we the last open device? */
 		if (atomic_dec_and_test(&fc->dev_count)) {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 7138b780c9abd..b7bd2e623c3f3 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -941,7 +941,7 @@ int fuse_simple_background(struct fuse_conn *fc, struct fuse_args *args,
 /**
  * End a finished request
  */
-void fuse_request_end(struct fuse_conn *fc, struct fuse_req *req);
+void fuse_request_end(struct fuse_req *req);
 
 /* Abort all requests */
 void fuse_abort_conn(struct fuse_conn *fc);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index fadf6fb90fe22..8865ab961abfe 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -268,7 +268,6 @@ static void virtio_fs_request_dispatch_work(struct work_struct *work)
 	struct fuse_req *req;
 	struct virtio_fs_vq *fsvq = container_of(work, struct virtio_fs_vq,
 						 dispatch_work.work);
-	struct fuse_conn *fc = fsvq->fud->fc;
 	int ret;
 
 	pr_debug("virtio-fs: worker %s called.\n", __func__);
@@ -283,7 +282,7 @@ static void virtio_fs_request_dispatch_work(struct work_struct *work)
 
 		list_del_init(&req->list);
 		spin_unlock(&fsvq->lock);
-		fuse_request_end(fc, req);
+		fuse_request_end(req);
 	}
 
 	/* Dispatch pending requests */
@@ -314,7 +313,7 @@ static void virtio_fs_request_dispatch_work(struct work_struct *work)
 			spin_unlock(&fsvq->lock);
 			pr_err("virtio-fs: virtio_fs_enqueue_req() failed %d\n",
 			       ret);
-			fuse_request_end(fc, req);
+			fuse_request_end(req);
 		}
 	}
 }
@@ -453,7 +452,6 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 				       struct virtio_fs_vq *fsvq)
 {
 	struct fuse_pqueue *fpq = &fsvq->fud->pq;
-	struct fuse_conn *fc = fsvq->fud->fc;
 	struct fuse_args *args;
 	struct fuse_args_pages *ap;
 	unsigned int len, i, thislen;
@@ -486,7 +484,7 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 	clear_bit(FR_SENT, &req->flags);
 	spin_unlock(&fpq->lock);
 
-	fuse_request_end(fc, req);
+	fuse_request_end(req);
 	spin_lock(&fsvq->lock);
 	dec_in_flight_req(fsvq);
 	spin_unlock(&fsvq->lock);
-- 
2.43.0



