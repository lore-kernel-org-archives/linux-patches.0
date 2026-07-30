Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC3A449999;
	Thu, 30 Jul 2026 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425052; cv=none; b=S6wXNedCMzHDKj0M+zNvWNM775yzoSCUBzDMSFfTq4sdbrHgEMT85HpDz0fVtgfeccKjGZ2uGl1CHpXnfNcpkews0Yd1be5zPpJeNDvCvV2H8BUYxUvW+Imnpd1MfN2PuvHTwzSEmar07dK0ZKH4kp7b3N1olhsRhZf1EH0IPEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425052; c=relaxed/simple;
	bh=5pj99COxL1s9paw+TrdC1l8AqL5XTveFXjw7pWIh7TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0kdlibN5JKNqVmlVI73J2lCML1IlsV1KZpFWjrprQJuYQu+ZHv40NVrae9YWax3q2RPtuSmBcy0wmQ4xJEF7oPSyN9au1qc3BR5hEbu2c24ahPSVR8Kb0wNDv2FiM3qmKsGhwgnNwjT0PZ3k7l1c8ikTq3eQqwBMrAjuGPN7Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5UEx2yD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5UEx2yD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3C61F000E9;
	Thu, 30 Jul 2026 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425051;
	bh=BKqC0p59gtNVH004/8ml4tDfeC1OfV2KmXGGhItxz58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5UEx2yD1GG7R87uegvU8wqCwiPxZRmH/avXRrkAqQPve65+SMC6Nkjd0kmQZlL1Y
	 LM3oL+SFWGBWuLFBgV3gqyNJZ8hgNR+UDLkjMnqcVMPDS4Zq+KJ58X4eAWFSRr5tJT
	 D1AIb1B17em8dj7Yw5FvbsxcOMdBk53pOKWRXy9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 610/675] fuse-uring: fix race between registration and connection abortion
Date: Thu, 30 Jul 2026 16:15:40 +0200
Message-ID: <20260730141458.081759065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

[ Upstream commit 952b5d36f6a298f57c52a59e72076c69386a8aaf ]

This fixes this race:
- thread a: io_uring_enter -> register sqe ->
  fuse_uring_create_ring_ent -> allocate ent but doesn't grab queue_ref
  yet
- thread b: fuse_conn_destroy() -> fuse_chan_abort() ->
  fuse_uring_abort() is a no-op due to queue ref being 0
- thread a: grabs the queue_ref, queue_ref is now 1, rest of
  fuse_uring_do_register() logic executes
- thread b: fuse_chan_abort() returns, fuse_chan_wait_aborted() now runs
  and calls
  "wait_event(ring->stop_waitq, atomic_read(&ring->queue_refs) == 0);"
The abort/unmount thread will hang indefinitely in unkillable state as
nothing will decrement queue_refs or wake stop_waitq, and the ring,
queue, and ent are leaked.

Fix this by checking fch->connected under fch->lock after the created
ent has grabbed a ref count on the queue. This ensures that in the
scenario above, it is guaranteed that we either release the queue ref
and wake up stop_waitq (in case fuse_chan_wait_aborted() is already
waiting) in fuse_uring_do_register() when we detect !fch->connected, or
if the connection is aborted after the check, it is guaranteed that the
async teardown worker will be running in the background cleaning up ents
and decrementing the ent's ref on the queue, which will unblock the
eventual queue and ring teardown.

Fixes: 24fe962c86f5 ("fuse: {io-uring} Handle SQEs - register commands")
Cc: stable@vger.kernel.org
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ changed fch->lock/fch->connected references to fc->lock/fc->connected since struct fuse_chan does not exist in this tree ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -998,15 +998,26 @@ static bool is_ring_ready(struct fuse_ri
 /*
  * fuse_uring_req_fetch command handling
  */
-static void fuse_uring_do_register(struct fuse_ring_ent *ent,
-				   struct io_uring_cmd *cmd,
-				   unsigned int issue_flags)
+static int fuse_uring_do_register(struct fuse_ring_ent *ent,
+				  struct io_uring_cmd *cmd,
+				  unsigned int issue_flags)
 {
 	struct fuse_ring_queue *queue = ent->queue;
 	struct fuse_ring *ring = queue->ring;
 	struct fuse_conn *fc = ring->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 
+	spin_lock(&fc->lock);
+	/* abort teardown path is running or has run */
+	if (!fc->connected) {
+		spin_unlock(&fc->lock);
+		if (atomic_dec_and_test(&ring->queue_refs))
+			wake_up_all(&ring->stop_waitq);
+		kfree(ent);
+		return -ECONNABORTED;
+	}
+	spin_unlock(&fc->lock);
+
 	fuse_uring_prepare_cancel(cmd, issue_flags, ent);
 
 	spin_lock(&queue->lock);
@@ -1023,6 +1034,7 @@ static void fuse_uring_do_register(struc
 			wake_up_all(&fc->blocked_waitq);
 		}
 	}
+	return 0;
 }
 
 /*
@@ -1138,9 +1150,7 @@ static int fuse_uring_register(struct io
 	if (IS_ERR(ent))
 		return PTR_ERR(ent);
 
-	fuse_uring_do_register(ent, cmd, issue_flags);
-
-	return 0;
+	return fuse_uring_do_register(ent, cmd, issue_flags);
 }
 
 /*


