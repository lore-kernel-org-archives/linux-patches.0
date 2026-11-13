Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590751;
	b=Xv0YUypItxzt1/Kr5V0alUqTJ3r/oN6gbUVYqbEflwTVSOtjt0AcyAetBP2e3IXOFlui
	 GBJ+1qaSYSq1aLyFlok3FGtggtXCWZ9TTUSq4VTMoXPdb5ZHJ+Z4lE45q8lkRZH38Xm4x
	 7Zvyfu/ciUsFVDuNuQSJ1FnhoyiQW1eRBbONxWII7gHv2k6lUweglieGBYmTVtUBnUMPg
	 3fdr5dNFm3kN+W+nju9OYqiNcRvJwa18kgBr0lw5+TeG7ankumZz/auSJiB9RGHuEZQp8
	 LWG0JfZUqlFkopUbLc5HUcYGwt0vvchltzFByofbChbmVtMhYUHaAlM8hBTniO8z6iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1CCoNtXCtF4o28f6mkV4CpT26H2CNr62Q2NyjMLzAZE=;
	b=ek3by6jhKi2mD5tQS1Wk9dx7Fpoyq6EDsq2++StnUWvp6aDIQalhJAphZ3gEwhI3hE+1
	 KNKBmGrPBeyTNc2asgvgpZrHrnd0VRBK7VvKul8zDDZ4nESwvmYva5pOiVCwQ0fBOJg9I
	 un/tzfe/7fn8uLL+X3FCrvZsN4fBtIo6GhEpIcG1qfzG+5jJA1Fg82DgH4M8VKgLeRPHP
	 4cVj0q+4ZrOBA3eWsghEHio5YbUhS/IYjbuUu1KO/mME4sbunVCQXxQYa9bfYVn+rFnr2
	 UT2cRQ8Od0Pyf0qo2rdCvmi7I3FdCj42JJ6u6PSyQxeEg2DwtC785vHwhRq9QiXkcKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAL3c7Ww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCB8606E202;
	Fri, 13 Nov 2026 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAL3c7Ww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202D11F000C6;
	Fri, 13 Nov 2026 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590751;
	bh=1CCoNtXCtF4o28f6mkV4CpT26H2CNr62Q2NyjMLzAZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAL3c7WwoDgQ999+Ih/l73GqWEQLEKkBFFblcTInX1HzS1hIM77VAvkPQ8roN9nrR
	 crZ0osHHnZESNnwgpRR6IPTn/2TYkW9AFr2ol5f/eBKRjc3BubwhBUUiMvrDWORxnV
	 lxhcB9jMHtk0Qa9lCtxmhTiItkVNusMVTXcoWSuA=
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
Subject: [PATCH 6.18 600/686] block: introduce bio_in_atomic()
Date: Fri, 13 Nov 2026 10:52:13 -0500
Message-ID: <20261113153842.259800975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0af259e22026f..ab4b222aae899 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1414,15 +1414,6 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
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
@@ -1439,7 +1430,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
-	if (z_erofs_in_atomic()) {
+	if (bio_in_atomic()) {
 		/* See `sync_decompress` in sysfs-fs-erofs for more details */
 		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
 			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fb747b053b98c..a5763f11fb137 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -376,6 +376,21 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
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
 
 /**
-- 
2.53.0



