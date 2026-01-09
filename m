Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B122A32FA3D;
	Fri,  9 Jan 2026 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959879; cv=none; b=S/KK457T8CxV+b89y1vtSYzn4dCJpiBstm1yDFfWSOg+BHfwKJW1YSL6Lfg/+bHWKjR0t9K3p25JGGOsU1+yQNI4Rn4JCxEa1QWLdeejLTFgb3j3Z8AJm8M0b8grg/GulheJyTbI3zwYbETMNdp9/Z2bfkgWEmhCHITf4y5cSlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959879; c=relaxed/simple;
	bh=6NJrVZrKTUSABspteSLMBGpQrUd5L+PqzOJdU5AGcjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuVUV7bjTASdRx32Fi1rd5S/uq7Ax+SpeksIKvt7o7SijXcVSuxJpj2bgmKrUmWnUpuo8cxkwUfpLmRJf/Lt2PO7AsGFXTkC9w3/2O4s8SB8XTY4InhGNcyvQ95AB/jN3cVeEGQZIB2DUwP8X8xvISU7r1OWDfm7sfgCgFfMYX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0kIB2O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0kIB2O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9CEC4CEF1;
	Fri,  9 Jan 2026 11:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959879;
	bh=6NJrVZrKTUSABspteSLMBGpQrUd5L+PqzOJdU5AGcjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0kIB2O4Av5PusCXT3GT0TuSDQXAKUZMcdDk5X3QY8umADHuqYirY1MS+4G1VMRhH
	 cnXHduM3HGq8qO6FvLsQvSCf43NqrgAEE0Uqnh7JMFm/uTRZchCwLpZyuMQoxuiFFe
	 gV+DaxET/TTWmeilAChAOGNFiicFQJBIaalOn0CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/737] iomap: factor out a iomap_dio_done helper
Date: Fri,  9 Jan 2026 12:35:45 +0100
Message-ID: <20260109112141.749898532@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ae2f33a519af3730cacd1c787ebe1f7475df5ba8 ]

Split out the struct iomap-dio level final completion from
iomap_dio_bio_end_io into a helper to clean up the code and make it
reusable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250206064035.2323428-7-hch@lst.de
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: ddb4873286e0 ("iomap: always run error completions in user context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 76 ++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index bcd3f8cf5ea42..1b0f06e7e58de 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -156,43 +156,31 @@ static inline void iomap_dio_set_error(struct iomap_dio *dio, int ret)
 	cmpxchg(&dio->error, 0, ret);
 }
 
-void iomap_dio_bio_end_io(struct bio *bio)
+/*
+ * Called when dio->ref reaches zero from an I/O completion.
+ */
+static void iomap_dio_done(struct iomap_dio *dio)
 {
-	struct iomap_dio *dio = bio->bi_private;
-	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
 	struct kiocb *iocb = dio->iocb;
 
-	if (bio->bi_status)
-		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
-	if (!atomic_dec_and_test(&dio->ref))
-		goto release_bio;
-
-	/*
-	 * Synchronous dio, task itself will handle any completion work
-	 * that needs after IO. All we need to do is wake the task.
-	 */
 	if (dio->wait_for_completion) {
+		/*
+		 * Synchronous I/O, task itself will handle any completion work
+		 * that needs after IO. All we need to do is wake the task.
+		 */
 		struct task_struct *waiter = dio->submit.waiter;
 
 		WRITE_ONCE(dio->submit.waiter, NULL);
 		blk_wake_io_task(waiter);
-		goto release_bio;
-	}
-
-	/*
-	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
-	 */
-	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
+	} else if (dio->flags & IOMAP_DIO_INLINE_COMP) {
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
-		goto release_bio;
-	}
-
-	/*
-	 * If this dio is flagged with IOMAP_DIO_CALLER_COMP, then schedule
-	 * our completion that way to avoid an async punt to a workqueue.
-	 */
-	if (dio->flags & IOMAP_DIO_CALLER_COMP) {
+	} else if (dio->flags & IOMAP_DIO_CALLER_COMP) {
+		/*
+		 * If this dio is flagged with IOMAP_DIO_CALLER_COMP, then
+		 * schedule our completion that way to avoid an async punt to a
+		 * workqueue.
+		 */
 		/* only polled IO cares about private cleared */
 		iocb->private = dio;
 		iocb->dio_complete = iomap_dio_deferred_complete;
@@ -210,19 +198,31 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		 * issuer.
 		 */
 		iocb->ki_complete(iocb, 0);
-		goto release_bio;
+	} else {
+		struct inode *inode = file_inode(iocb->ki_filp);
+
+		/*
+		 * Async DIO completion that requires filesystem level
+		 * completion work gets punted to a work queue to complete as
+		 * the operation may require more IO to be issued to finalise
+		 * filesystem metadata changes or guarantee data integrity.
+		 */
+		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
+		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
 	}
+}
+
+void iomap_dio_bio_end_io(struct bio *bio)
+{
+	struct iomap_dio *dio = bio->bi_private;
+	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
+
+	if (bio->bi_status)
+		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
+
+	if (atomic_dec_and_test(&dio->ref))
+		iomap_dio_done(dio);
 
-	/*
-	 * Async DIO completion that requires filesystem level completion work
-	 * gets punted to a work queue to complete as the operation may require
-	 * more IO to be issued to finalise filesystem metadata changes or
-	 * guarantee data integrity.
-	 */
-	INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
-	queue_work(file_inode(iocb->ki_filp)->i_sb->s_dio_done_wq,
-			&dio->aio.work);
-release_bio:
 	if (should_dirty) {
 		bio_check_pages_dirty(bio);
 	} else {
-- 
2.51.0



