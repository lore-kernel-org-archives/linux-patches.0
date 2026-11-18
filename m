Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019567;
	b=OyFF/cqB7QcKTegOGqv/lhYhOMALZT+KpnLYdg0gnK2Y80qfGLedFfA9pRIo/vgPhFzR
	 HN4pRCWARI19/4o/egjqqO1N1tRo97l/enD4czH1nUpvZjTtTqa5F89yQ3XkhsljE6lcu
	 RCeh9Tsa0iqAoacJ5WmdD+z25z5zURtF02qw3Cw3s5f5M3SUrokU9k6Ywk+/73hlN62m3
	 riFGOjhaUi9YWcTnmAHh1gp8vS3PLNtC9KdC0u886/9wk5ivVo3pc1JiwPFX451T3QE9y
	 WGcEPSqEjWeIyZ6r7J/6Kw82YP8pTo5nlXgYhQsjp/4sL9gEg7IZ10UORSd2AA8WebQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KA5DA/VAbT8NSWbMeJtsMoEJAFH4yR8kF2ud8HrUD9A=;
	b=QyxdYGrAr7S3j/54oDzaZm2wWYo3+9g2zGwZTkRbaze1eJmBeF94cVMYYpeaf2whqWft
	 3TXqxrEBRz4oRanzkftuwRqg2HTkTMFLDu2Jen+SRFla0A6oawAI39KY2qfJdoZDYIK5t
	 DWcFsaW4Y1GfWgNlmr8g7G4HURTEahekR6L0Bls3FFhh7OS5Mjn0E92Vr37LFzJ1ASVsW
	 2KZ68GJQCSnCrFDowEngX4iJawm9XqbC8raFAzNxoXMc/TpXFOf0eTkiY2MHtkBlwd6AO
	 MWaT5YQXUPGbHg5tP2mXTpHuRCvjTjWJkoAo1F8Ofywd2PFA/Ka7CyHwx/VDbfGZ7cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfjxiIf7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E988E606A7C0;
	Wed, 18 Nov 2026 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfjxiIf7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB8B1F000C6;
	Wed, 18 Nov 2026 16:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019566;
	bh=KA5DA/VAbT8NSWbMeJtsMoEJAFH4yR8kF2ud8HrUD9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfjxiIf70Ig/0/AGSyjCy8uDdkd4W6Sljq+lLUse+uuRdYyrUZYRLdp8AP5hrtKxx
	 ZvVAnidq7ugUE/HyHm58y8eB4QnRKsi9xDnPnTWTByfyHq0LpkmWpVD87jnRXa5GxS
	 EnzWFBQaiKa/D0iwLWk+BqsoWw/szmU9juOM/BVY=
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
Subject: [PATCH 7.3 1642/2651] block: only use REQ_FUA for direct writes if the device supports it
Date: Wed, 18 Nov 2026 15:48:02 +0100
Message-ID: <20261118150346.928884555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f95e1d6c3e5b3..76be51d43b410 100644
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
@@ -75,7 +89,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 		if (user_backed_iter(iter))
 			should_dirty = true;
 	} else {
-		bio_init(&bio, bdev, vecs, nr_pages, dio_bio_write_op(iocb));
+		bio_init(&bio, bdev, vecs, nr_pages,
+			 dio_bio_write_op(iocb, bdev));
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
@@ -179,7 +194,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	struct blkdev_dio *dio;
 	struct bio *bio;
 	bool is_read = (iov_iter_rw(iter) == READ), is_sync;
-	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
+	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb, bdev);
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
@@ -325,7 +340,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 					unsigned int nr_pages)
 {
 	bool is_read = iov_iter_rw(iter) == READ;
-	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
+	blk_opf_t opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb, bdev);
 	struct blkdev_dio *dio;
 	struct bio *bio;
 	loff_t pos = iocb->ki_pos;
@@ -775,6 +790,13 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
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



