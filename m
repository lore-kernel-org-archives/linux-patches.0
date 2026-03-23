Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048DE3B19B4;
	Mon, 23 Mar 2026 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274559; cv=none; b=hZmk78m+7EnBL8FMKvMfcq9z7PPNUxQwcbDwNRTqv/MMgznYdlZkJOQcpzCtcfiUqaDf8FPLllhZskPMsb+eFJER5R9jI/49or12bZKbQWxq/9AqNDDSBXAPpHQgCiMG3E7RO30nhuMwYIKdQKR1397uzvjKLQCjoy23svoHjr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274559; c=relaxed/simple;
	bh=qojsMIK9Ej/tnGcIhVvvuAwMGw+LWKUNwi15V1PN/Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n14Zs6amCDEg17eYooESv8pTY7lOq6wgarCsCNEtPAnDyfnh64bD92XIcGe3OGnlPxN7C9PP6PdqR9H4El+bmBQ6MOTWmmb3b0G9c5FDaZi2hNIqJ5oPbxCPgNx5TdWkPNWAG4vdr40PrQyJKXGrMXeLMcNiFLlZuXrJzkGIO44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZY/nZPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZY/nZPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490AAC4CEF7;
	Mon, 23 Mar 2026 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274558;
	bh=qojsMIK9Ej/tnGcIhVvvuAwMGw+LWKUNwi15V1PN/Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZY/nZPKnwY+Okr6rR1AymRP6JLToJYEc/wuVqFsAUF3yLAm80VR9Ito8kLlz75ld
	 uRP+y3LK20S0UgHT9bSArvE17qv0UI48R0wQTUJp80aFboPYlK0AocA4l4RNPKBSDm
	 CUq1THTcQPitjkrUiVhuSU8KaAGEsAULEAkm0JXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@ownmail.net>,
	stable@kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 006/212] sunrpc: fix cache_request leak in cache_release
Date: Mon, 23 Mar 2026 14:43:47 +0100
Message-ID: <20260323134503.968577643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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


