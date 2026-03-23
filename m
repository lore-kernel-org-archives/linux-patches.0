Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1BB3A6B88;
	Mon, 23 Mar 2026 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273855; cv=none; b=kj4zydkzxewpF+ubCuXJIohH/Cyy/6n4Bp7nGW+WZ+EjB/u6WIi5Qe9VN/LtjWYWtyiiAtkCxAO5TctEnBNQtQ5KKfEXXAXXvhZUqHsAHdpXcRkSfztsS8sk3EXlMPU/dxHoExIh4a1M3pYosV+uk0Em7a0CFea7SKzHybJwWiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273855; c=relaxed/simple;
	bh=OWyle4wAovgdu9w5AJ2XjgiUAULMBPgyDhMzpEgT9nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdAK9T2EPsdP+nNezi9CEyiZ5I/Y6+ydThSB3DAQaBYmDmLIVoXbwybBFljPOnxulR5wZT3mBIqMQAsW/9LrX4+QyFCKGRt7L6gPiXpSrzvCBIshCYTUV0feyylQjKrZAiJlXgcxo8k0Um5fBxydWiZ8S2lFKONnAyZw69I4Blo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TDb+ef6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TDb+ef6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3235FC4CEF7;
	Mon, 23 Mar 2026 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273855;
	bh=OWyle4wAovgdu9w5AJ2XjgiUAULMBPgyDhMzpEgT9nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TDb+ef6WW5OryMXiWz2nbj0Ow65rgtBsa8JpQD2uSFvSdyK4wVREDFVPWZGVAg9Z
	 LhPRlsMOVQSluq1EF8qpTpmhTlZVl5VLwWhopp9MUxLwOXYkQY+ISN+6V0ixxEp4Po
	 LLQ78IfLKcUrPZM0pkmSH0W0VnneDcliB7RvT/Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@ownmail.net>,
	stable@kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.19 006/220] sunrpc: fix cache_request leak in cache_release
Date: Mon, 23 Mar 2026 14:43:03 +0100
Message-ID: <20260323134504.783952444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 17ad31b3a43b72aec3a3d83605891e1397d0d065 upstream.

When a reader's file descriptor is closed while in the middle of reading
a cache_request (rp->offset != 0), cache_release() decrements the
request's readers count but never checks whether it should free the
request.

In cache_read(), when readers drops to 0 and CACHE_PENDING is clear, the
cache_request is removed from the queue and freed along with its buffer
and cache_head reference. cache_release() lacks this cleanup.

The only other path that frees requests with readers == 0 is
cache_dequeue(), but it runs only when CACHE_PENDING transitions from
set to clear. If that transition already happened while readers was
still non-zero, cache_dequeue() will have skipped the request, and no
subsequent call will clean it up.

Add the same cleanup logic from cache_read() to cache_release(): after
decrementing readers, check if it reached 0 with CACHE_PENDING clear,
and if so, dequeue and free the cache_request.

Reported-by: NeilBrown <neilb@ownmail.net>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/cache.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1061,14 +1061,25 @@ static int cache_release(struct inode *i
 	struct cache_reader *rp = filp->private_data;
 
 	if (rp) {
+		struct cache_request *rq = NULL;
+
 		spin_lock(&queue_lock);
 		if (rp->offset) {
 			struct cache_queue *cq;
-			for (cq= &rp->q; &cq->list != &cd->queue;
-			     cq = list_entry(cq->list.next, struct cache_queue, list))
+			for (cq = &rp->q; &cq->list != &cd->queue;
+			     cq = list_entry(cq->list.next,
+					     struct cache_queue, list))
 				if (!cq->reader) {
-					container_of(cq, struct cache_request, q)
-						->readers--;
+					struct cache_request *cr =
+						container_of(cq,
+						struct cache_request, q);
+					cr->readers--;
+					if (cr->readers == 0 &&
+					    !test_bit(CACHE_PENDING,
+						      &cr->item->flags)) {
+						list_del(&cr->q.list);
+						rq = cr;
+					}
 					break;
 				}
 			rp->offset = 0;
@@ -1076,9 +1087,14 @@ static int cache_release(struct inode *i
 		list_del(&rp->q.list);
 		spin_unlock(&queue_lock);
 
+		if (rq) {
+			cache_put(rq->item, cd);
+			kfree(rq->buf);
+			kfree(rq);
+		}
+
 		filp->private_data = NULL;
 		kfree(rp);
-
 	}
 	if (filp->f_mode & FMODE_WRITE) {
 		atomic_dec(&cd->writers);


