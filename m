Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026182;
	b=D16o6cBmO5XjFxubaHLI71HMQNfVg0dgJZVPgotWO8cqQ9VmV2xyW4tB4GsMMqV1FQFp
	 Aqj4yc85QomI6oV1Qp4HLds+GJG63ferzCsyv73L6TWKGrF3OeqaLPet6pmFQ/mXZlwTF
	 oJL21or/uz6XYQJZ77COyu9sRtDiCNVXct1Te96CEGpKHWzjnvjKTQU2RtV6U5y+vwag4
	 s99OVQrAqyugiQEKPEbi/DemaXIU5RhL0c6V9TXNMMolwZzTXNVwlRL50BUDAxz32fD/o
	 NywU3UOGAXvHvcZmJP8Fa1PHqeLa1VCshcU+ZC0toaT9lSWWMNgBHAa56SA8XAYZYYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOkBstrieUlbJmAr4JG5MI7FHFW+C970cdLteaavXQo=;
	b=c3xkWz5+Zz/f3GtqOdxTJEPn88o+ARUGMsywfBTp+0U/5ad7lHxwATcGLGU39fkmZXCQ
	 YFcQejpGJdZ1RCsPEIaKXdKvPvw6MWmgcrlpbQVYVO/Tv21ZZY1xAPBsmcLOqrioBlif5
	 px15EnWW1d53qmXuYuWl3EPJ09bP3RlOXUCdIiLzFvjaMZr6gC2wgg1OQDlBwS9rg7+3L
	 WFQ9doaeVYF7lrEzbEAtfqBURBxI4vVy+vyeDyS0nbMsGvdB6iuIPDl+kZnJfIJKc6KTk
	 nPSd4aNsp6xA2YVQc5W/EucqZLl9dzGecKiVo4eJlGeZ3xfz+Kk/yJW+A1zoE2pjGuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rlNWWEVe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE4E60A381E;
	Wed, 18 Nov 2026 18:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rlNWWEVe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476B11F00937;
	Wed, 18 Nov 2026 18:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026182;
	bh=WOkBstrieUlbJmAr4JG5MI7FHFW+C970cdLteaavXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlNWWEVeO5+qnYAel1PxK0prKLts9WEb5pY2hsPJf6lW5M3ZdvGatSZ2z6dnNnOP5
	 MOqdvOGrnPdCUIUqoUTUgxal/eAvZtKYBGxHXlgDbyyvHjLxYMP0NoGnGifmvCdEJF
	 MTvOHLM6K2wn3iDu0kKIAokOSOLm9X6BghH/zYJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenxian Ma <mzx199711@gmail.com>,
	Zhenxian Ma <mazhenxian@xiaohongshu.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1345/2151] block: skip redundant flush for O_DSYNC direct writes
Date: Wed, 18 Nov 2026 15:51:20 +0100
Message-ID: <20261118150211.042718329@linuxfoundation.org>
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

[ Upstream commit bec7d36a6514153ded6ffe1323ab14912ced42df ]

For an O_DIRECT | O_DSYNC write, dio_bio_write_op() adds REQ_FUA to the
bio, so the data is durable once the direct I/O returns.  The
unconditional generic_write_sync() in blkdev_write_iter() then issues a
REQ_PREFLUSH that is redundant.

Skip it when the direct path already provided durability via FUA.  A
need_sync flag, clear by default, is set only for buffered writes and
for the buffered fallback after a partial direct write.

Measured on a Seagate ST20000NM007D (20 TB, 7200 rpm, fua=1,
write_cache=write back), Linux v7.2.0-rc7, single-threaded pwrite()
loop opening the raw block device with O_WRONLY | O_DIRECT | O_DSYNC,
4 KiB writes for 60 s:

  Sequential 4 KiB writes:
                            baseline    patched
    IOPS                       119.7     7497.0
    avg latency (us)            8357        133
    p50 latency (us)            8346        127
    p99 latency (us)            8368        395
    p99.9 latency (us)          8728        569

  Random 4 KiB writes (100 GiB span):
                            baseline    patched
    IOPS                       156.1      666.4
    avg latency (us)            6405       1500
    p50 latency (us)            6186       1450
    p99 latency (us)           16133       2285
    p99.9 latency (us)         17250       9916

Signed-off-by: Zhenxian Ma <mzx199711@gmail.com>
Signed-off-by: Zhenxian Ma <mazhenxian@xiaohongshu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/f847707d772a9225460406b5aecba030d7209b05.1786782832.git.mzx199711@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 2fec4fd97cc3 ("block: take i_rwsem for the direct I/O write fallback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index b805f360e4606..45398fcdaacbc 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -761,6 +761,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	bool atomic = iocb->ki_flags & IOCB_ATOMIC;
 	loff_t size = bdev_nr_bytes(bdev);
 	size_t shorted = 0;
+	bool need_sync = false;
 	ssize_t ret;
 
 	if (bdev_read_only(bdev))
@@ -798,9 +799,11 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
-		if (ret >= 0 && iov_iter_count(from))
+		if (ret >= 0 && iov_iter_count(from)) {
 			ret = direct_write_fallback(iocb, from, ret,
 					blkdev_buffered_write(iocb, from));
+			need_sync = true;
+		}
 	} else {
 		/*
 		 * Take i_rwsem and invalidate_lock to avoid racing with
@@ -810,9 +813,10 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		inode_lock_shared(bd_inode);
 		ret = blkdev_buffered_write(iocb, from);
 		inode_unlock_shared(bd_inode);
+		need_sync = true;
 	}
 
-	if (ret > 0)
+	if (ret > 0 && need_sync)
 		ret = generic_write_sync(iocb, ret);
 	iov_iter_reexpand(from, iov_iter_count(from) + shorted);
 	return ret;
-- 
2.53.0



