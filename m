Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019564;
	b=LB/Sozffkv4GIqOK5NVg4dp+rZSKmt7WibiNkgtAE9XuKOlicxycwBakN2iuTQPPliQv
	 aQ4b8Cyt3bILdayguJtjdZcCauXH+K4qmMtVM24PgovrmdOI4rw0b0fFxxMWgzEUhCfGu
	 p1/CAB4SYMqoJKk5SpG65zN950+flE0iMit6ccKknYQwYtw0CiJj8l5AFTkllbs+v6M1i
	 7ST1IaOUtJfNTH8o6SSPQUIU6IuMOzO/248ckB/nuCdjnc100zMeM9/QS+a5S+2PmYpbW
	 8PCZxGybdpzfMWsrokyDx1Mos/TB0b13A7ntABeB1+aWadLGRFsXe9Kv72myDUoUK3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bm8xgolY8pzLiVcNKd3J16ZrhbOZdvxRwZcIgi4q+X0=;
	b=nj1ZlIqwZOlLLu6/0hClsOd9cm+7bQFBouwL4pNLWJJUNu43gTABUQ72g15VHpipDQMR
	 REBFgZMJaqXaCgojczeMlTvMSrtzT0MYGfVpSRfnUkKpigJuqoASnMgcaOn5l+dB4AcYu
	 AbgYSvaDezlgoNK6qx8RQGqJvk2753lmxbrATBvRlQYeQGdrOD4bJebh5kUDsCz+m5maN
	 O5VhdIsEwLLJg7st4pAugSiCsZ/0yujWbNZYqZAcRYS3/BW56LVHDJBBwin56LZ6m/lYk
	 ffG54BrOqLQDTOsBPOcOCcXDuFm595J47jZ+ybf4YTe8zABJULshIuh9Ypw9APRPRhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHl9JYpy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A036606A7DE;
	Wed, 18 Nov 2026 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHl9JYpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639331F000C8;
	Wed, 18 Nov 2026 16:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019563;
	bh=Bm8xgolY8pzLiVcNKd3J16ZrhbOZdvxRwZcIgi4q+X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHl9JYpyduUo+A4VJbR4oWfkFwjZKZhxeynCsUeA6L23azkxtsAkw5IK6N9ZKe+1g
	 v8hFlu80OsMgUHe1s9GmuN64suHouGGveiuvzpAbCu8K57OncEesKPTE3869W7E3/S
	 xCGH0SbcsvOLu1tHTpzf/JTn7hl3T6FMpOj38Wf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenxian Ma <mzx199711@gmail.com>,
	Zhenxian Ma <mazhenxian@xiaohongshu.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1641/2651] block: skip redundant flush for O_DSYNC direct writes
Date: Wed, 18 Nov 2026 15:48:01 +0100
Message-ID: <20261118150346.897630519@linuxfoundation.org>
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
index 8d74d0e57f43f..f95e1d6c3e5b3 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -733,6 +733,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	bool atomic = iocb->ki_flags & IOCB_ATOMIC;
 	loff_t size = bdev_nr_bytes(bdev);
 	size_t shorted = 0;
+	bool need_sync = false;
 	ssize_t ret;
 
 	if (bdev_read_only(bdev))
@@ -770,9 +771,11 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
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
@@ -782,9 +785,10 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
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



