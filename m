Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6343F313298;
	Mon, 13 Apr 2026 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098918; cv=none; b=J8nF90D8LkHDA5yp0NwS7EOfusCo1GDHS5Dw+eA2skYG5i2kVOzDDaKd/t2LEt820ZRKauVkjorKib7bfJ/aFIflBZfNrSE2VaQazQbJCho99fkoC8UjOHzKkSZFQ1CC6bhayBPDNwhxrRFLOFGBMoXu0kxLHMhYRO1K+LIA2G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098918; c=relaxed/simple;
	bh=JbSXeSpHB1qyexYFmGwDqbHlwHMvJqL64v1L0aoZ464=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f541Bpm089P7bnB3wLKu975y63/FZHA8ZQ6orzb+tX4oRd1GLDs/as+/KLXZMD4wfrUzw5YBk2LNSAbqjU5Fcn4H1tgV5mOmE1jNOIJUUIYPm+abOd2WjCAFi6S66wYQd0OJaCuMTGM0mNZayFToFXl/MfNHJ+9dBu2j+EdNdPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVzojiP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVzojiP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6ECC2BCAF;
	Mon, 13 Apr 2026 16:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098918;
	bh=JbSXeSpHB1qyexYFmGwDqbHlwHMvJqL64v1L0aoZ464=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVzojiP2sbzWsZH3zlxaTITu3GBnGbGAOZWguz/dVIfZ4zi2meQ5/VIthgYA4bLXU
	 1Sa2XcOLzr9cnzeEfm0ex9T7EkA263+RC8O8HD4tfY1iUPdjbnivbltzXmZAPQdi16
	 a2r2cqLPz6chUQyh6XZsJPicKEgGAhsDim+5z8Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@ownmail.net>,
	stable@kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 138/491] sunrpc: fix cache_request leak in cache_release
Date: Mon, 13 Apr 2026 17:56:23 +0200
Message-ID: <20260413155824.206223457@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1056,14 +1056,25 @@ static int cache_release(struct inode *i
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
@@ -1071,9 +1082,14 @@ static int cache_release(struct inode *i
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


