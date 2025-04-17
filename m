Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F152561D5;
	Thu, 17 Apr 2025 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913703; cv=none; b=KbaSYkjd95R6y8kUVl2UG/tQEKuIPEQjucs1DNS9lhw311xV9i+/pPGbux4g1TdLdz5RohhDjOCgINbDbqNibZcHXvH475fA+kcSOoBtW6ixcAFoiMaYghb+0BF6ghAWU0wRIAp289hGT59oU3sU30/gvX6Nd0P1kRdkIfgEUD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913703; c=relaxed/simple;
	bh=+Yv6VnNLaAe1yIQG6k9EJCilisKZoXQcsAwYHBr6jlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCeFGhB4JWz698ZjiiicyJziri0mDs0SE7szLkf1AmH/u3OTw5BBIN5nfnUN0M0Bdxp2lCfgEpPLKuzJ9fhAbdB0/66JLsB5f61+NUXJdlTmy4L0ziYa8UcC25oRiZe7UOvuDQjwbNQnTKDLOrAm289+zfA5wE8q53w5NFkllAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4lGhlCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4lGhlCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28B4C4CEE4;
	Thu, 17 Apr 2025 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913703;
	bh=+Yv6VnNLaAe1yIQG6k9EJCilisKZoXQcsAwYHBr6jlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4lGhlCWabl0Kk0KvVkUwXzrJNEYsStf0x/GXwzEUL3dJnvNB/n2baUTgHYLwjKX1
	 fzdwIOrZdGbnLZtiv/6tb0jpGy5YnPq+ZiUg4xAdkfC5AxiYYA1Sbplc/Mq7kUQLMV
	 K9U2Zenc+wapyS6cz9RgD99mwqBkbC00r55gjMtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.14 396/449] fuse: {io-uring} Fix a possible req cancellation race
Date: Thu, 17 Apr 2025 19:51:24 +0200
Message-ID: <20250417175134.204808332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bschubert@ddn.com>

commit 09098e62e4be8f0755e58d6078aaf27cbd9a3a8d upstream.

task-A (application) might be in request_wait_answer and
try to remove the request when it has FR_PENDING set.

task-B (a fuse-server io-uring task) might handle this
request with FUSE_IO_URING_CMD_COMMIT_AND_FETCH, when
fetching the next request and accessed the req from
the pending list in fuse_uring_ent_assign_req().
That code path was not protected by fiq->lock and so
might race with task-A.

For scaling reasons we better don't use fiq->lock, but
add a handler to remove canceled requests from the queue.

This also removes usage of fiq->lock from
fuse_uring_add_req_to_ring_ent() altogether, as it was
there just to protect against this race and incomplete.

Also added is a comment why FR_PENDING is not cleared.

Fixes: c090c8abae4b ("fuse: Add io-uring sqe commit and fetch support")
Cc: <stable@vger.kernel.org> # v6.14
Reported-by: Joanne Koong <joannelkoong@gmail.com>
Closes: https://lore.kernel.org/all/CAJnrk1ZgHNb78dz-yfNTpxmW7wtT88A=m-zF0ZoLXKLUHRjNTw@mail.gmail.com/
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c         | 34 +++++++++++++++++++++++++---------
 fs/fuse/dev_uring.c   | 15 +++++++++++----
 fs/fuse/dev_uring_i.h |  6 ++++++
 fs/fuse/fuse_dev_i.h  |  1 +
 fs/fuse/fuse_i.h      |  3 +++
 5 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 2c3a4d09e500..2645cd8accfd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -407,6 +407,24 @@ static int queue_interrupt(struct fuse_req *req)
 	return 0;
 }
 
+bool fuse_remove_pending_req(struct fuse_req *req, spinlock_t *lock)
+{
+	spin_lock(lock);
+	if (test_bit(FR_PENDING, &req->flags)) {
+		/*
+		 * FR_PENDING does not get cleared as the request will end
+		 * up in destruction anyway.
+		 */
+		list_del(&req->list);
+		spin_unlock(lock);
+		__fuse_put_request(req);
+		req->out.h.error = -EINTR;
+		return true;
+	}
+	spin_unlock(lock);
+	return false;
+}
+
 static void request_wait_answer(struct fuse_req *req)
 {
 	struct fuse_conn *fc = req->fm->fc;
@@ -428,22 +446,20 @@ static void request_wait_answer(struct fuse_req *req)
 	}
 
 	if (!test_bit(FR_FORCE, &req->flags)) {
+		bool removed;
+
 		/* Only fatal signals may interrupt this */
 		err = wait_event_killable(req->waitq,
 					test_bit(FR_FINISHED, &req->flags));
 		if (!err)
 			return;
 
-		spin_lock(&fiq->lock);
-		/* Request is not yet in userspace, bail out */
-		if (test_bit(FR_PENDING, &req->flags)) {
-			list_del(&req->list);
-			spin_unlock(&fiq->lock);
-			__fuse_put_request(req);
-			req->out.h.error = -EINTR;
+		if (test_bit(FR_URING, &req->flags))
+			removed = fuse_uring_remove_pending_req(req);
+		else
+			removed = fuse_remove_pending_req(req, &fiq->lock);
+		if (removed)
 			return;
-		}
-		spin_unlock(&fiq->lock);
 	}
 
 	/*
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index ebd2931b4f2a..add7273c8dc4 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -726,8 +726,6 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
 					   struct fuse_req *req)
 {
 	struct fuse_ring_queue *queue = ent->queue;
-	struct fuse_conn *fc = req->fm->fc;
-	struct fuse_iqueue *fiq = &fc->iq;
 
 	lockdep_assert_held(&queue->lock);
 
@@ -737,9 +735,7 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
 			ent->state);
 	}
 
-	spin_lock(&fiq->lock);
 	clear_bit(FR_PENDING, &req->flags);
-	spin_unlock(&fiq->lock);
 	ent->fuse_req = req;
 	ent->state = FRRS_FUSE_REQ;
 	list_move(&ent->list, &queue->ent_w_req_queue);
@@ -1238,6 +1234,8 @@ void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 	if (unlikely(queue->stopped))
 		goto err_unlock;
 
+	set_bit(FR_URING, &req->flags);
+	req->ring_queue = queue;
 	ent = list_first_entry_or_null(&queue->ent_avail_queue,
 				       struct fuse_ring_ent, list);
 	if (ent)
@@ -1276,6 +1274,8 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
 		return false;
 	}
 
+	set_bit(FR_URING, &req->flags);
+	req->ring_queue = queue;
 	list_add_tail(&req->list, &queue->fuse_req_bg_queue);
 
 	ent = list_first_entry_or_null(&queue->ent_avail_queue,
@@ -1306,6 +1306,13 @@ bool fuse_uring_queue_bq_req(struct fuse_req *req)
 	return true;
 }
 
+bool fuse_uring_remove_pending_req(struct fuse_req *req)
+{
+	struct fuse_ring_queue *queue = req->ring_queue;
+
+	return fuse_remove_pending_req(req, &queue->lock);
+}
+
 static const struct fuse_iqueue_ops fuse_io_uring_ops = {
 	/* should be send over io-uring as enhancement */
 	.send_forget = fuse_dev_queue_forget,
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 2102b3d0c1ae..e5b39a92b7ca 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -142,6 +142,7 @@ void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req);
 bool fuse_uring_queue_bq_req(struct fuse_req *req);
+bool fuse_uring_remove_pending_req(struct fuse_req *req);
 
 static inline void fuse_uring_abort(struct fuse_conn *fc)
 {
@@ -200,6 +201,11 @@ static inline bool fuse_uring_ready(struct fuse_conn *fc)
 	return false;
 }
 
+static inline bool fuse_uring_remove_pending_req(struct fuse_req *req)
+{
+	return false;
+}
+
 #endif /* CONFIG_FUSE_IO_URING */
 
 #endif /* _FS_FUSE_DEV_URING_I_H */
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index 3b2bfe1248d3..2481da3388c5 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -61,6 +61,7 @@ int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *args,
 void fuse_dev_queue_forget(struct fuse_iqueue *fiq,
 			   struct fuse_forget_link *forget);
 void fuse_dev_queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req);
+bool fuse_remove_pending_req(struct fuse_req *req, spinlock_t *lock);
 
 #endif
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index fee96fe7887b..2086dac7243b 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -378,6 +378,7 @@ struct fuse_io_priv {
  * FR_FINISHED:		request is finished
  * FR_PRIVATE:		request is on private list
  * FR_ASYNC:		request is asynchronous
+ * FR_URING:		request is handled through fuse-io-uring
  */
 enum fuse_req_flag {
 	FR_ISREPLY,
@@ -392,6 +393,7 @@ enum fuse_req_flag {
 	FR_FINISHED,
 	FR_PRIVATE,
 	FR_ASYNC,
+	FR_URING,
 };
 
 /**
@@ -441,6 +443,7 @@ struct fuse_req {
 
 #ifdef CONFIG_FUSE_IO_URING
 	void *ring_entry;
+	void *ring_queue;
 #endif
 };
 
-- 
2.49.0



