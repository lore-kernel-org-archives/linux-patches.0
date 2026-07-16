Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454853101BF;
	Thu, 16 Jul 2026 13:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210287; cv=none; b=M8rs4NREwO6hd7Oo/ko1/XRdC1YxyA2HMwIczEME8vjFYU8ezJGHr+whDBn70hDCUM3sjDFS9V0uwBShWrJdue+OQW5m4oWdmDw9LzDN0mWD6Bs37su8V+qzISzBNxfo8WBUtAiVqyBTzMKtEKrZ8WKyATYNtul/pCh2oqvTS7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210287; c=relaxed/simple;
	bh=FMarQwRfmLqq7bm8WAT3Vbvtjz5MY0nKrXhGoIOfbzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myUISsER2igXbOPH/8RLwMKi4DJNvmsGtLE9AWT7JjF+INYjvKC+0NkCXSfCDuLeyQ/FsyGM7yDTEnkdmW6EZZCUOtpOMUWSkTRPc4XH5f/pBHzQ9b0YqvIiUNesSd3DcQeL0ELFAmZocbeoCDY7fYwaHqrBgibk3g+6Hu+KA1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPVOWfG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPVOWfG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807891F00A3A;
	Thu, 16 Jul 2026 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210285;
	bh=ftZFd1HaXhQs42P7G9+o4X7F245x5xvhBic1fjnoHms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPVOWfG90TfOQ5mVPUaJD0DpETDLXNafqCd1rFeAnMg1RDl/en3T5/g2LRbT1zdj/
	 i5aBM9ohXT8P6VYTZ/MDFLiJ45TB5JiZNeC070rGMwqb0tvybkeUpyGYuHinCdK8uy
	 27oNXw0L7+016yBqOWF9/NaOR+KXi8GHSSKLSQUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Chris Mason <clm@meta.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 509/518] fuse-uring: fix data races on ring->ready
Date: Thu, 16 Jul 2026 15:32:57 +0200
Message-ID: <20260716133058.976449946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -989,12 +989,12 @@ static void fuse_uring_do_register(struc
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


