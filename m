Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3E257981F;
	Wed,  9 Sep 2026 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964466; cv=none; b=Pdael2VYUsneHjKyC9sg88E3Cz+CBUc/UV1qQAkMhqcCeaK0gKvQn2RAAsljeU1xmfYIi3KIP1P9hL1Cue0SYhBrNssc9ijabuWaK1S3pvEHVJkyf9oLOrK8oOOqO3F4a2iohgDYvGxQKbtVPkUvq+5YJcKseoVAIOCcSxSaerg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964466; c=relaxed/simple;
	bh=0KJkkhcTGk/oRfjus2XQ447GC3ltM2X0eCs+MQoe+0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzD79g4Ep4pHQeXZRZqd4z75S/0SSSP/tCxQ8t6k+SGS9RIfn7nHT/C76lIMlvDGzO0YBLtXfjIT2U61THw2EzpeCFYE0+nHqD5//TYU2D2aVFq5ipj+cnpGB0WPHdKj4aFDEM53NpQvaFcyygE8fQDKSFLZR41VEzjUcYovDJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELMfgjij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELMfgjij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C651F00A3A;
	Wed,  9 Sep 2026 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964465;
	bh=m6fpw/tKLdWy5SjvsH5lWmng7Hts59Pe3gmaOAwRdNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELMfgjijVmjC7Q8MfPG4RUJnhMj2otcRSsoxdnzPrZycUeXg3qvmPs37vnD3O27vH
	 IBBV8jgLHEtYFLofmnz65gBsU4iOxVfsmnBWVPHqFsabx1P81DYVpZGmSRn7xUU+m7
	 4NDmov6MRdpGgH/rc93tYumIduUQmjDqFUe8Irkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 431/583] fuse: publish io-uring queues with release semantics
Date: Wed,  9 Sep 2026 15:41:56 +0200
Message-ID: <20260909134252.921678646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

[ Upstream commit 42df916e5a5f8fb4b60c8cefb54318d1ec02c580 ]

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
[ renamed `fch->lock` to `fc->lock` since this tree lacks `struct fuse_chan` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -194,7 +194,7 @@ void fuse_uring_destruct(struct fuse_con
 		return;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
-		struct fuse_ring_queue *queue = ring->queues[qid];
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
 		struct fuse_ring_ent *ent, *next;
 
 		if (!queue)
@@ -213,7 +213,7 @@ void fuse_uring_destruct(struct fuse_con
 
 		kfree(queue->fpq.processing);
 		kfree(queue);
-		ring->queues[qid] = NULL;
+		WRITE_ONCE(ring->queues[qid], NULL);
 	}
 
 	kfree(ring->queues);
@@ -307,9 +307,11 @@ static struct fuse_ring_queue *fuse_urin
 	}
 
 	/*
-	 * write_once and lock as the caller mostly doesn't take the lock at all
+	 * fc->lock serializes concurrent creators for this qid.
+	 * smp_store_release() are for the lockless readers who must see a
+	 * fully initialized queue after &ring->queues[qid] is set
 	 */
-	WRITE_ONCE(ring->queues[qid], queue);
+	smp_store_release(&ring->queues[qid], queue);
 	spin_unlock(&fc->lock);
 
 	return queue;
@@ -406,7 +408,7 @@ static void fuse_uring_log_ent_state(str
 	struct fuse_ring_ent *ent;
 
 	for (qid = 0; qid < ring->nr_queues; qid++) {
-		struct fuse_ring_queue *queue = ring->queues[qid];
+		struct fuse_ring_queue *queue = READ_ONCE(ring->queues[qid]);
 
 		if (!queue)
 			continue;
@@ -911,7 +913,7 @@ static int fuse_uring_commit_fetch(struc
 	if (qid >= ring->nr_queues)
 		return -EINVAL;
 
-	queue = ring->queues[qid];
+	queue = READ_ONCE(ring->queues[qid]);
 	if (!queue)
 		return err;
 	fpq = &queue->fpq;
@@ -980,7 +982,7 @@ static bool is_ring_ready(struct fuse_ri
 		if (current_qid == qid)
 			continue;
 
-		queue = ring->queues[qid];
+		queue = READ_ONCE(ring->queues[qid]);
 		if (!queue) {
 			ready = false;
 			break;
@@ -1134,7 +1136,7 @@ static int fuse_uring_register(struct io
 		return -EINVAL;
 	}
 
-	queue = ring->queues[qid];
+	queue = READ_ONCE(ring->queues[qid]);
 	if (!queue) {
 		queue = fuse_uring_create_queue(ring, qid);
 		if (!queue)
@@ -1286,7 +1288,7 @@ static struct fuse_ring_queue *fuse_urin
 		      ring->nr_queues))
 		qid = 0;
 
-	queue = ring->queues[qid];
+	queue = READ_ONCE(ring->queues[qid]);
 	WARN_ONCE(!queue, "Missing queue for qid %d\n", qid);
 
 	return queue;


