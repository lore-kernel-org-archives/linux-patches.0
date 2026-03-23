Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43AE3AF679;
	Mon, 23 Mar 2026 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277071; cv=none; b=Z8CcjZbI3m6S9XcEPZKpbV/RjLb04NW7cJCzGQ81Me8cvfb+HP1MGDI/edif5LBVhjKltanS+U8fY4M2Q9wDWxmOpW/LF9wVmnGnOVhKGIgqgJp9uvSrOhnuxJv2YCBU2GPM417uzO4STU3hgB71F+iS6OmH4zFBelSifiYIVNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277071; c=relaxed/simple;
	bh=sCWvowsv1PPBFEZTH9ea0RSjQOLoPc/hdBvLkzqtE4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAeiXgFw6DKYdPbBj4+4UNSqCk+vfDJrAQJsUkxGr4CRMzfduQPoweW5Vp/6d69cQ7COrX+3vat9U1PPQeFcCTVgJ3mCfBt1VxtO+BzkHmamRy4mzu7nXfQs/OllblmUmG4yhm2gPJwUv84eXGRrVTJjGM+ZaNaX34W/r1TKpN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kROD5Ouw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kROD5Ouw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353D0C2BCB3;
	Mon, 23 Mar 2026 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277071;
	bh=sCWvowsv1PPBFEZTH9ea0RSjQOLoPc/hdBvLkzqtE4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kROD5OuwfvZIHuJvtxe838jgphTwqE8QDcbhAhMqZTORRrviF79GQsEY/REZb7HT0
	 7l3NWDq+CDja3z7+N4a45A4win+GLyL33BbzF3YowfWBFdz2y0jHpcEDSUC8gMcMk8
	 Gjp/63+H/XcyG6OkgLHhcNeKG35sUx8qwL71Aq6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@ownmail.net>,
	stable@kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 310/460] sunrpc: fix cache_request leak in cache_release
Date: Mon, 23 Mar 2026 14:45:06 +0100
Message-ID: <20260323134534.117822737@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1049,14 +1049,25 @@ static int cache_release(struct inode *i
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
@@ -1064,9 +1075,14 @@ static int cache_release(struct inode *i
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


