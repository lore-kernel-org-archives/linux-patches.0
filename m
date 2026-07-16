Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70730332604;
	Thu, 16 Jul 2026 14:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211557; cv=none; b=UNqO1doTqMlrb6ufevRfjA9IFlNor3iYmB0CwD6/sinRh7444WN4T3fQvRKvIXSZ37QXk2bZ2H/QK8ZPJBDPgrkS3j6MDuJY+0LaeQ3RoNDvAi2qs7dyXDxjo7xWtsuDd4/v1nQvyWfAi/bKFVpUbxgSbIn50UKlped2Ytz/jbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211557; c=relaxed/simple;
	bh=yKCme1Kps3sELDSQdMKBUYMRlNRw39oU1h5UJcDSomw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkTES0mSO7zixz1CW1FHutlrG7IwmZBSsYAVovwbXKPXfNGj8gqoPlL4GlGj0vDS3pH9JhLkxdVqzF0gUatZPDyldXSAXN/Nw8bL+22Q3STodVTLuWIk7SFjxB9aAuTqo4kfCxImX3bAf8VkIj5Oj2+15ZC/YCLFrhltkEUMXPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FH/4ZBkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FH/4ZBkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9F71F000E9;
	Thu, 16 Jul 2026 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211556;
	bh=2QT/99xc3S5GpyyY/CaCxsFnWmlIeaKFHNForbUcb9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FH/4ZBkHSEw85clzz4oIaQALbsT7zXLCcD2d+6LJDu2xaoyTx7vFYNZEPhlChcv3i
	 KD3/rc10ZJ/mJ2S+5E/GobEf2YR3ASivUK2h/VVKk2nBxfWQIeevY7+BftTZpB9v/G
	 3bZP7/RBmpaVtp6LimsLCFd8myndGJBBklkTV7Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xlabai <xlabai@tencent.com>,
	Berkant Koc <me@berkoc.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	stable@kernel.org
Subject: [PATCH 6.18 474/480] fuse-uring: make a fuse_req on SQE commit only findable after memcpy
Date: Thu, 16 Jul 2026 15:33:41 +0200
Message-ID: <20260716133055.075550457@linuxfoundation.org>
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

commit 1efd3d474fc0ba74dfd984249bca78807d739812 upstream.

Bad userspace might try to trick us and send commit SQEs request
unique / commit-id of requests that are not even send to
fuse-server (io_uring_cmd_done() not called) yet.

fuse_uring_commit_fetch() ends the fuse request when the ring entry
has a wrong state, but that could have caused a use-after-free
with the memcpy operations in fuse_uring_send_in_task().
In order to avoid such races the call of fuse_uring_add_to_pq()
is moved after the copy operations and just before completing
the io-uring request - malicious userspace cannot find the request
anymore until all prepration work in fuse-client/kernel is completed.

This also moves fuse_uring_add_to_pq() a bit up in the code to
avoid a forward declaration. Also not with a preparation commit,
to make it easier to back port to older kernels.

Reported-by: xlabai <xlabai@tencent.com>
Reported-by: Berkant Koc <me@berkoc.com>
Fixes: c090c8abae4b6b ("fuse: Add io-uring sqe commit and fetch support")
Cc: stable@kernel.org # 6.14
Signed-off-by: Bernd Schubert <bernd@bsbernd.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -718,6 +718,19 @@ static int fuse_uring_prepare_send(struc
 	return err;
 }
 
+/* Used to find the request on SQE commit */
+static void fuse_uring_add_to_pq(struct fuse_ring_ent *ent)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+	struct fuse_pqueue *fpq = &queue->fpq;
+	unsigned int hash;
+	struct fuse_req *req = ent->fuse_req;
+
+	req->ring_entry = ent;
+	hash = fuse_req_hash(req->in.h.unique);
+	list_move_tail(&req->list, &fpq->processing[hash]);
+}
+
 /*
  * Write data to the ring buffer and send the request to userspace,
  * userspace will read it
@@ -740,6 +753,7 @@ static int fuse_uring_send_next_to_ring(
 	ent->cmd = NULL;
 	ent->state = FRRS_USERSPACE;
 	list_move_tail(&ent->list, &queue->ent_in_userspace);
+	fuse_uring_add_to_pq(ent);
 	spin_unlock(&queue->lock);
 
 	io_uring_cmd_done(cmd, 0, issue_flags);
@@ -757,19 +771,6 @@ static void fuse_uring_ent_avail(struct
 	ent->state = FRRS_AVAILABLE;
 }
 
-/* Used to find the request on SQE commit */
-static void fuse_uring_add_to_pq(struct fuse_ring_ent *ent,
-				 struct fuse_req *req)
-{
-	struct fuse_ring_queue *queue = ent->queue;
-	struct fuse_pqueue *fpq = &queue->fpq;
-	unsigned int hash;
-
-	req->ring_entry = ent;
-	hash = fuse_req_hash(req->in.h.unique);
-	list_move_tail(&req->list, &fpq->processing[hash]);
-}
-
 /*
  * Assign a fuse queue entry to the given entry
  */
@@ -787,10 +788,13 @@ static void fuse_uring_add_req_to_ring_e
 	}
 
 	clear_bit(FR_PENDING, &req->flags);
+
+	/* Until fuse_uring_add_to_pq() the req is not attached to any list */
+	list_del_init(&req->list);
+
 	ent->fuse_req = req;
 	ent->state = FRRS_FUSE_REQ;
 	list_move_tail(&ent->list, &queue->ent_w_req_queue);
-	fuse_uring_add_to_pq(ent, req);
 }
 
 /* Fetch the next fuse request if available */
@@ -1209,6 +1213,7 @@ static void fuse_uring_send(struct fuse_
 	ent->state = FRRS_USERSPACE;
 	list_move_tail(&ent->list, &queue->ent_in_userspace);
 	ent->cmd = NULL;
+	fuse_uring_add_to_pq(ent);
 	spin_unlock(&queue->lock);
 
 	io_uring_cmd_done(cmd, ret, issue_flags);


