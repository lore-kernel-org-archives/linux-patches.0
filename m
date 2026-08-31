Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D294E48097D;
	Mon, 31 Aug 2026 13:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183482; cv=none; b=a1jZPmRCDUm+a2YyAqtu54PPwws6VC42yC8YtCmC+d2Mn5X3eboI9F7rO1TJcDMVyXHtTEPjlmgcDvxiAXL+I/g30flVB0JSuMLMCDNgbd7RCUov2hGWlmJC2f6az1wnEiSpBcVyJOgzUeMU822UMjnVfSLGb95VDDfHF518hrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183482; c=relaxed/simple;
	bh=886wIDmybvPa3mRQfte+0Msv/6Sy8Rbyf5niB7PeoOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDQS4T1VnpLLqIZu69WjPyBWcw/gwQLQo4vkbCsGKMQvl8q0tsSlfbr5UcGqeM0zEBbm+LvhQXzfQbQrgvbhVGUuGTCK++AY6M4WT/fHfjXLKdqHeEAUfWymjiip1m9KZ4rXgRGq0KmQ56EQ/8oOxryV8OwFYioW4aXhhFcpycE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Dt6+Js7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Dt6+Js7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C751F000E9;
	Mon, 31 Aug 2026 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183480;
	bh=VD9Hu4eUE1TgY/mp3DoRpgg8i2Is/9Dwk9emO4bpnxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Dt6+Js78YPpoTsawEo7eqMlijP9R+Ql9Kyi7Dao/9epfM+N/e6kISU3nREnnsUaH
	 77jSkJhKHglm8hMiQe2iizouhbTq+Gw+PCz4VaBuugMDqs9s7zZ/BzKF7sYPqE+smR
	 iV4qI4SrVJYj9nrElmw0WJyStX+Fp3fNtHEtRFQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.2 14/71] fuse: publish io-uring queues with release semantics
Date: Mon, 31 Aug 2026 15:33:39 +0200
Message-ID: <20260831133359.716810965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit 42df916e5a5f8fb4b60c8cefb54318d1ec02c580 upstream.

fuse_uring_create_queue() initializes a fuse_ring_queue and then
publishes the pointer into ring->queues[qid] with WRITE_ONCE() under the
fch->lock. There are several readers that may concurrently be fetching
that pointer locklessly and then deferencing it.

WRITE_ONCE() doesn't ensure ordering of the queue's field
initialization before the ring->queues[qid] pointer assignment. The
queue must be published with smp_store_release() so the field
initialization is guaranteed to happen before.

Readers in paths where the read may happen concurrently with the store
need to use READ_ONCE() because any race involving a plain access is
undefined.

Fixes: 24fe962c86f5 ("fuse: {io-uring} Handle SQEs - register commands")
Cc: stable@vger.kernel.org
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -204,7 +204,7 @@ void fuse_uring_destruct(struct fuse_cha
 		return;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
-		struct fuse_ring_queue *queue = ring->queues[qid];
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
 		struct fuse_ring_ent *ent, *next;
 
 		if (!queue)
@@ -223,7 +223,7 @@ void fuse_uring_destruct(struct fuse_cha
 
 		kfree(queue->fpq.processing);
 		kfree(queue);
-		ring->queues[qid] = NULL;
+		WRITE_ONCE(ring->queues[qid], NULL);
 	}
 
 	kfree(ring->queues);
@@ -321,9 +321,11 @@ static struct fuse_ring_queue *fuse_urin
 	}
 
 	/*
-	 * write_once and lock as the caller mostly doesn't take the lock at all
+	 * fch->lock serializes concurrent creators for this qid.
+	 * smp_store_release() are for the lockless readers who must see a
+	 * fully initialized queue after &ring->queues[qid] is set
 	 */
-	WRITE_ONCE(ring->queues[qid], queue);
+	smp_store_release(&ring->queues[qid], queue);
 	spin_unlock(&fch->lock);
 
 	return queue;
@@ -434,7 +436,7 @@ static void fuse_uring_log_ent_state(str
 	struct fuse_ring_ent *ent;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
-		struct fuse_ring_queue *queue = ring->queues[qid];
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
 
 		if (!queue)
 			continue;
@@ -967,7 +969,7 @@ static int fuse_uring_commit_fetch(struc
 	if (qid >= ring->nr_queues)
 		return -EINVAL;
 
-	queue = ring->queues[qid];
+	queue = READ_ONCE(ring->queues[qid]);
 	if (!queue)
 		return err;
 	fpq = &queue->fpq;
@@ -1035,7 +1037,7 @@ static bool is_ring_ready(struct fuse_ri
 		if (current_qid == qid)
 			continue;
 
-		queue = ring->queues[qid];
+		queue = READ_ONCE(ring->queues[qid]);
 		if (!queue) {
 			ready = false;
 			break;
@@ -1191,7 +1193,7 @@ static int fuse_uring_register(struct io
 		return -EINVAL;
 	}
 
-	queue = ring->queues[qid];
+	queue = READ_ONCE(ring->queues[qid]);
 	if (!queue) {
 		queue = fuse_uring_create_queue(ring, qid);
 		if (!queue)
@@ -1330,7 +1332,7 @@ static struct fuse_ring_queue *fuse_urin
 		      ring->nr_queues))
 		qid = 0;
 
-	queue = ring->queues[qid];
+	queue = READ_ONCE(ring->queues[qid]);
 	WARN_ONCE(!queue, "Missing queue for qid %d\n", qid);
 
 	return queue;


