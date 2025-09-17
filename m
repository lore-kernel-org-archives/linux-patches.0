Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8C71E9B19;
	Wed, 17 Sep 2025 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112568; cv=none; b=OGo39h4MkT5Waml0wmpGhcTAOp/lOUsM8F8imPWtAhvAWiXSncaNDFenpT88v1E6pvZ63EG28P4xNT1zLETG78+1q2j6eoAgRsJW7Qquv6XfKuHQOc5dFHsGzyvdjcv2rlDyWBnO6iATXLwUSxMyGurU3wwyv2W3hHMJ9xZljig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112568; c=relaxed/simple;
	bh=/7Hj2kvWCTzjbLpn7cbIRnzMp6gv+c1FpJsS5dUrlE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxU1vZTqya+a4e2x2e19XdSedjmlrW5i8qLw3qN11hLsS47X9rOtWalpsZvCoSAscM0XUVhHFYXmeIhKy01MgRZaXv2h4j74KL4vnJUvG7xyLsV4dlgy9xyQNUfGPg4WUbtF8SfL1pl3W3wfUQC30NsRT/Pj56dIljSl+UUttCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIaZe4Lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIaZe4Lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B33C4CEF0;
	Wed, 17 Sep 2025 12:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112566;
	bh=/7Hj2kvWCTzjbLpn7cbIRnzMp6gv+c1FpJsS5dUrlE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIaZe4LqKKbd/UxXDJ+dGf3K0aJdxoKTvBbKDOsuTtRHR4KFdX2DlAZ+jmaHZqEk3
	 BbHYbfDmgtyJmvCmSLs2I43CjNfsfOOgslC/mdO8NsL3BbSeUEzJT9PNYybf3k+ZrA
	 qB0GXcDLFx8XypCy/6Ycw3+9sDu88J37gWuFGoBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 002/189] block: dont silently ignore metadata for sync read/write
Date: Wed, 17 Sep 2025 14:31:52 +0200
Message-ID: <20250917123351.908532934@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2729a60bbfb9215997f25372ebe9b7964f038296 ]

The block fops don't try to handle metadata for synchronous requests,
probably because the completion handler looks at dio->iocb which is not
valid for synchronous requests.

But silently ignoring metadata (or warning in case of
__blkdev_direct_IO_simple) is a really bad idea as that can cause
silent data corruption if a user ever shows up.

Instead simply handle metadata for synchronous requests as the completion
handler can simply check for bio_integrity() as the block layer default
integrity will already be freed at this point, and thus bio_integrity()
will only return true for user mapped integrity.

Fixes: 3d8b5a22d404 ("block: add support to pass user meta buffer")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/20250819082517.2038819-3-hch@lst.de
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index e7bfe65c57f22..d62fbefb2e671 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -55,7 +55,6 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	struct bio bio;
 	ssize_t ret;
 
-	WARN_ON_ONCE(iocb->ki_flags & IOCB_HAS_METADATA);
 	if (nr_pages <= DIO_INLINE_BIO_VECS)
 		vecs = inline_vecs;
 	else {
@@ -132,7 +131,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 	if (bio->bi_status && !dio->bio.bi_status)
 		dio->bio.bi_status = bio->bi_status;
 
-	if (!is_sync && (dio->iocb->ki_flags & IOCB_HAS_METADATA))
+	if (bio_integrity(bio))
 		bio_integrity_unmap_user(bio);
 
 	if (atomic_dec_and_test(&dio->ref)) {
@@ -234,7 +233,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			}
 			bio->bi_opf |= REQ_NOWAIT;
 		}
-		if (!is_sync && (iocb->ki_flags & IOCB_HAS_METADATA)) {
+		if (iocb->ki_flags & IOCB_HAS_METADATA) {
 			ret = bio_integrity_map_iter(bio, iocb->private);
 			if (unlikely(ret))
 				goto fail;
@@ -302,7 +301,7 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
-	if (iocb->ki_flags & IOCB_HAS_METADATA)
+	if (bio_integrity(bio))
 		bio_integrity_unmap_user(bio);
 
 	iocb->ki_complete(iocb, ret);
@@ -423,7 +422,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	}
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
-	if (likely(nr_pages <= BIO_MAX_VECS)) {
+	if (likely(nr_pages <= BIO_MAX_VECS &&
+		   !(iocb->ki_flags & IOCB_HAS_METADATA))) {
 		if (is_sync_kiocb(iocb))
 			return __blkdev_direct_IO_simple(iocb, iter, bdev,
 							nr_pages);
-- 
2.51.0



