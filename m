Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026185;
	b=TkRsR+h25V2YUqz4WGZBdykPVrMud8ay1OgB0jHR+rmuQCx+Xty2UjUqf7O7lSBIVvUj
	 tohgqjLa4GzGl5hckYK7GBjX0KBZUX+kRiLTUJ5CjkWbKypnuC/MjNxklcYWSqG+phshN
	 ESrle3HlzYlvGDp5R5DLFlEOpkTyrNFsMrJgQ6gAWgL/bHGQK6OgCYTLvFvE8wlPeYcX1
	 fESpPiByE1E293WiiEH/gltqJ1k1mFjZcfMmeBNeOrES5Nj0MvozHuyy2VmqyimpE7muz
	 NvLNr5+hUrgK2FdK5hJ60ZNl+K1yDdCxvyJ4juGItJB7W3z+PMADR9sSUP1k6+HFgGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KBVEa5R0q40vdFNeGa5iCnDjP18Ca8cuuOfLWjuTPY8=;
	b=G4zkgSco8plka79C9irxqXIRq7ZeYzPx/bK1gKPr6RCwbyjXz1S26QCMoTqlUsVvUG80
	 zgLzYUtIsjBARyQ17UaCYnosE1AfR7UXvI1HQeybnjqNoQSOQM5oFRoWKuzWk5iKS4E/h
	 TKFzfQQ4jWxkdpiyHaubiTzjHbYGpkf7rCl+/yCTao0/ELcywuk+xCP9IDAHFYdzxKLzV
	 SVltq0dg3fWsLVF05M7BSwDW497eRgsJU/QhG8zVruIoZkhnyfwYJecWp4S46tj6cfIi3
	 8MidsjuxJTuNKJwGJeyoXgfJqmKR/EhmlfSGoxxx0tauA/nAJs5u+OK6kVLfKPoor6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0JY0tEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229660A383D;
	Wed, 18 Nov 2026 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0JY0tEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9BC1F000CA;
	Wed, 18 Nov 2026 18:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026185;
	bh=KBVEa5R0q40vdFNeGa5iCnDjP18Ca8cuuOfLWjuTPY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0JY0tEPyprbskBq2XE9gTLzOs4mHe43XXoJVN7xTeKjchBbRUbLrxbJtO9qh+Il4
	 C0LBecXBUIPvVaagsf3WXXHLgXJUjjrb06Ei5uI5m3AMpRXGSlkjD0iM9qSwux0zU9
	 9xcJb1JkFiXDWzUbS/DN2woXh8RDyEWwauFGjD7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Zhenxian Ma <mzx199711@gmail.com>,
	Zhenxian Ma <mazhenxian@xiaohongshu.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1346/2151] block: only use REQ_FUA for direct writes if the device supports it
Date: Wed, 18 Nov 2026 15:51:21 +0100
Message-ID: <20261118150211.078147338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Zhenxian Ma <mzx199711@gmail.com>

[ Upstream commit 0d492f40c4ad7af7b1625fd81dd58a7978ab97f6 ]

When a block device does not support FUA natively, the block layer
emulates it by adding a cache flush to every write bio.  An O_DSYNC
direct write that spans N bios then costs N flushes, rather than the
single generic_write_sync() issued after the write completes.

Introduce blkdev_dio_fua() to decide when REQ_FUA is set.  A synchronous
write can rely on generic_write_sync() when the device lacks FUA, so it
sets REQ_FUA only when bdev_fua() is true.  An asynchronous write
completes in blkdev_bio_end_io() and cannot call the blocking
generic_write_sync(), so it keeps REQ_FUA (emulated when needed) to stay
durable.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Zhenxian Ma <mzx199711@gmail.com>
Signed-off-by: Zhenxian Ma <mazhenxian@xiaohongshu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/tencent_A41247F29AC0971AE96B52964BE4491B440A@qq.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 2fec4fd97cc3 ("block: take i_rwsem for the direct I/O write fallback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 45398fcdaacbc..e94ad38f0a426 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -26,12 +26,26 @@ static inline struct inode *bdev_file_inode(struct file *file)
 	return file->f_mapping->host;
 }
 
-static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
+static bool blkdev_dio_fua(struct kiocb *iocb, struct block_device *bdev)
+{
+	if (!iocb_is_dsync(iocb))
+		return false;
+	/*
+	 * Async writes cannot fall back to generic_write_sync(), so they must
+	 * use FUA (emulated if needed); sync writes only need it when the
+	 * device supports FUA natively.
+	 */
+	if (!is_sync_kiocb(iocb))
+		return true;
+	return bdev_fua(bdev);
+}
+
+static blk_opf_t dio_bio_write_op(struct kiocb *iocb, struct block_device *bdev)
 {
 	blk_opf_t opf = REQ_OP_WRITE | REQ_SYNC | REQ_IDLE;
 
 	/* avoid the need for a I/O completion work item */
-	if (iocb_is_dsync(iocb))
+	if (blkdev_dio_fua(iocb, bdev))
 		opf |= REQ_FUA;
 	return opf;
 }
@@ -76,7 +90,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 		if (user_backed_iter(iter))
 			should_dirty = true;
 	} else {
-		bio_init(&bio, bdev, vecs, nr_pages, dio_bio_write_op(iocb));
+		bio_init(&bio, bdev, vecs, nr_pages,
+			 dio_bio_write_op(iocb, bdev));
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
@@ -180,7 +195,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	struct blkdev_dio *dio;
 	struct bio *bio;
 	bool is_read = (iov_iter_rw(iter) == READ), is_sync;
-	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
+	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb, bdev);
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
@@ -328,7 +343,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 					unsigned int nr_pages)
 {
 	bool is_read = iov_iter_rw(iter) == READ;
-	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
+	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb, bdev);
 	struct blkdev_dio *dio;
 	struct bio *bio;
 	loff_t pos = iocb->ki_pos;
@@ -803,6 +818,13 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			ret = direct_write_fallback(iocb, from, ret,
 					blkdev_buffered_write(iocb, from));
 			need_sync = true;
+		} else if (ret > 0 && !blkdev_dio_fua(iocb, bdev)) {
+			/*
+			 * The device does not support FUA, so REQ_FUA was not
+			 * set and the O_DSYNC direct write still needs a flush
+			 * to be made durable.
+			 */
+			need_sync = true;
 		}
 	} else {
 		/*
-- 
2.53.0



