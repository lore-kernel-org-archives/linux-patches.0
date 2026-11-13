Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591489;
	b=tRnv6Ff03d7PNR50ZhVFD0wRb2zkdMyzqjTKozwG19+Gu6Poha0ptsY4DjpLUGmaiVUH
	 ioa1ikwOyPItcYtH1h/CPX0NFrGXjuVjB6Nf/BlGH/U9d53UVEm5/VN9RrkXa0FoYEHpx
	 nkI1fie8QQAY6iG+L3SYUSq/3snCj9RYeAxwdSt3QYLhlzSWH+dXO3or5fP/tLrvngQea
	 v+uHhJ9vG3jqXR8XbkPluBgAbIiUG+3/Dh8XkZHl544ezc5AU6/cRUODgeOKfZ9En1m7t
	 i4ceiIpl/IoL3RRAnK4VzK1eVgpUmdiKE2Y0nP9ff2Xidp3zYgJZ+dJbRP3cLZbu1aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ubuSMlgTeuUZmrz0Nm9BPB+67dw3C9e59AAbQo/XUog=;
	b=HfyqwpIzAAERTZvRAdCYjDPRDGM6+mq8+BXEnTT9BPLvGeZ0PI70wGRdCC++o6kxNz6V
	 6H4215CPYc2xSUAZtZ/c196hwiM8eUJwKpImhVlherCcZKWUvHa7YfAsZOMMRY05LU5GH
	 tJsEc4qi+6gdKYkSuxknJD8zhbjc97tGftFIIp08u16NYOxUE+Yb93DTLeyhBau0c+dZO
	 gNOAVRc68WRRN/c8DMu/aMo/4HyQjyPaUkxmKneahT/FHgOHMxhVTeVaUBhbqoYegYfZs
	 SrIXISUJeAHEFHYBDSNWPF2u0lo3sxxEVZbR5UIwMNO70GDjPUY+w0iJ3b4d3lGWlrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pGAfxu9N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB49607E059;
	Fri, 13 Nov 2026 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pGAfxu9N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211F71F000C6;
	Fri, 13 Nov 2026 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591489;
	bh=ubuSMlgTeuUZmrz0Nm9BPB+67dw3C9e59AAbQo/XUog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGAfxu9N3mt42icP9B4tjs1VgJu2TWZ6Jgw6INePXqkZ8PJSbbuIco4jXGxh3yJsA
	 VKCg1F7ATcLrHkjJGDwpZp+0PsDUcWSfgkWNhApS3rSScWJqCR4dvDqBYRTRuo/AsL
	 GJMRp45RDUb5/6BW1M9YK9ngsbZFdOzBSTNyXo5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 571/670] block: introduce bio_in_atomic()
Date: Fri, 13 Nov 2026 10:52:15 -0500
Message-ID: <20261113153831.211213261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 8ed0831b5263e1aa48d99063795a1f20e4e69b50 ]

Move the atomic context detection logic from erofs's z_erofs_in_atomic()
into the block layer as bio_in_atomic(). This helper returns true when
the current context is unsafe for sleeping bio completion handlers (e.g.,
hard/soft IRQ, preempt-disabled).

The logic was originally added to erofs in commit c99fab6e80b7 ("erofs:
fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC"). A
subsequent patch will use it in the block layer's bio completion
infrastructure, so move it to include/linux/bio.h where both subsystems
can share it.

Convert erofs to call the new bio_in_atomic() directly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: a605d5d71a6d ("f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c    | 11 +----------
 include/linux/bio.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 08720efbb1a17..10b9aa2c28541 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1386,15 +1386,6 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
 }
 #endif
 
-/* Use (kthread_)work in atomic contexts to minimize scheduling overhead */
-static inline bool z_erofs_in_atomic(void)
-{
-	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
-		return true;
-	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
-		return true;
-	return !preemptible();
-}
 
 static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 				       int bios)
@@ -1411,7 +1402,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
-	if (z_erofs_in_atomic()) {
+	if (bio_in_atomic()) {
 		/* See `sync_decompress` in sysfs-fs-erofs for more details */
 		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
 			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d4f58a2d15b69..104a68749ab1e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -377,6 +377,21 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+/**
+ * bio_in_atomic - check if the current context is unsafe for bio completion
+ *
+ * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
+ * %false when a bio can be safely completed in the current context.
+ */
+static inline bool bio_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
 extern void bio_endio(struct bio *);
 
 static inline void bio_io_error(struct bio *bio)
-- 
2.53.0



