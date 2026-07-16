Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED245422E10;
	Thu, 16 Jul 2026 14:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211589; cv=none; b=mo1QYhQO8Pyts0GSmuviC/zw2YH08mGECJc2qSIgDu96WkNqb16pztUZgE4s5dlK6VqZatJRJ8T7g5PkdawWCX5MWgFtJNxuTqObZK32xjCNBAO3PGgTQKQaaXK1tOUEJQNYzKyZsKXbWpCu+CNceIwB9DRgqVNqL+kdCKug5EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211589; c=relaxed/simple;
	bh=ZqfP3Bq+xKEey6p5RL65+bn5/k8N8TvCifDeqnO802o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrI+3bW3mxco3jjikDoiv15I/8V7Qg+WY2GAxPIVSPx6jj3rkcW1Bm4W1lh7TiFJt4yfWHv7jm1rVf30jBiL7AQhFmOdEJJ0I87cEnCZEHfjHMF9ycH+afR3CTj2OJ0YcjVAx3zdxlGwk6aq3DF74z2IR9baM3mxLvyRoZJYyOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBomlgVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBomlgVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E12C1F00A3A;
	Thu, 16 Jul 2026 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211587;
	bh=k5m7nBuuA/MyQjvhSzVyd7/RS+sBzF5LBBPIwD85ZTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBomlgVWB8805HR5XKf8S5KM4ywFEN3DHvAYBNevH0PoNFNn3yvGvGUxJFmbjTRrb
	 Pm+lxWHhRYr3BTQG2IfTF7yQcTU05nhxZu/PxYb4tVGIQ1JI2sl0iNDTK1ojA9iPGg
	 4XzLZL3xFldTTQGAHnlwyl+WTJgi0ccbpEh44b5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Chris Mason <clm@meta.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 469/480] fuse-uring: fix data races on ring->ready
Date: Thu, 16 Jul 2026 15:33:36 +0200
Message-ID: <20260716133054.966637821@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 46725a0056c884cf58a6897f222892807327d82d upstream.

On weakly-ordered architectures, the store to fiq->ops can be
reordered past the store to ring->ready, allowing a CPU that sees
ring->ready == true via fuse_uring_ready() to dispatch requests
through a stale fiq->ops pointer. Upgrade the store to
smp_store_release() and the load in fuse_uring_ready() to
smp_load_acquire() so that the preceding WRITE_ONCE(fiq->ops, ...)
is visible to any CPU that observes ring->ready == true.

Additionally, fuse_uring_do_register() publishes ring->ready with
WRITE_ONCE() but the fast-path check reads it with a plain load.
This is a marked-vs-unmarked access that KCSAN will flag. Wrap it in
READ_ONCE() to mark it without adding unnecessary ordering.

Also wrap the fc->ring load in fuse_uring_ready() in READ_ONCE() to
prevent the compiler from reloading it between the NULL check and the
dereference.

Fixes: c2c9af9a0b13 ("fuse: Allow to queue fg requests through io-uring")
Cc: stable@vger.kernel.org
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c   |    4 ++--
 fs/fuse/dev_uring_i.h |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -992,12 +992,12 @@ static void fuse_uring_do_register(struc
 	fuse_uring_ent_avail(ent, queue);
 	spin_unlock(&queue->lock);
 
-	if (!ring->ready) {
+	if (!READ_ONCE(ring->ready)) {
 		bool ready = is_ring_ready(ring, queue->qid);
 
 		if (ready) {
 			WRITE_ONCE(fiq->ops, &fuse_io_uring_ops);
-			WRITE_ONCE(ring->ready, true);
+			smp_store_release(&ring->ready, true);
 			wake_up_all(&fc->blocked_waitq);
 		}
 	}
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -169,7 +169,9 @@ static inline void fuse_uring_wait_stopp
 
 static inline bool fuse_uring_ready(struct fuse_conn *fc)
 {
-	return fc->ring && fc->ring->ready;
+	struct fuse_ring *ring = READ_ONCE(fc->ring);
+
+	return ring && smp_load_acquire(&ring->ready);
 }
 
 #else /* CONFIG_FUSE_IO_URING */


