Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2255230BDB;
	Fri,  9 Oct 2026 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555929; cv=none; b=k4Isk0deea2vm5DRNVwYzcjJZDacKxCDigLLsS9PU4Z16srQs0nlXswxOVUhgODfz47V2Bu9+P//x3DUYtNOpFBf9lGuCBwgM3VNzkLZBpjZzi0owPpcXNuZNQ+JUIK9UWbriIEGTjizQyrBJEdMLMVcrUwFJ7qpLq8vHtGEg0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555929; c=relaxed/simple;
	bh=snu+dbTAWxaAoDzUjcshmGSClusomZDaQLXsOGxzIa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncZWltxCvKyotRQ6QCk/De+kRys7V+L7l8dURkfXTQzbpdCVdc9UV0AMSqpCx5fMyhqUCpRwkg7Xv+cBQWLL15ZzDV6JqtoDCLgUF89OFH2gwg+1LQ/BPK4hP7fYso+G2t4+AZrfNlzwklhwH+XyWV1Gabs+UfmFXvtq9KRH+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeTGOx1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeTGOx1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C571F000FF;
	Fri,  9 Oct 2026 14:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555928;
	bh=elQIOqcVY7s5nUqfuwn49ysUP++eYvyiDqOqoJXmGyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeTGOx1JKEbObok0VwdV2TJgWgbgsofRPT/D0+OFCA+Fz7t6Tvprri9tDE4jOrb7k
	 QV77/EOiUkzadzpld3nby0dYZy0WVHJ6oj320ilwZWoBfiYaKOxQKBe7XbdDUGLV7a
	 SPJW/gk0k95iaVHK4qruauk2egLUVhAE4VO1osZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 092/428] block: reject polled dio with user integrity metadata
Date: Fri,  9 Oct 2026 16:07:09 +0200
Message-ID: <20261009140948.221082522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 2a42e6fe1293f2e2d579c9fe5bbab056dd8b880e ]

IOCB_HAS_METADATA leaves iocb->private as a uio_meta, while
iocb_bio_iopoll() expects a bio. Since 2729a60bbfb9, metadata I/O
always uses __blkdev_direct_IO(), which never publishes the bio for
polling, so IOPOLL calls bio_poll() on the uio_meta.

Reproducer: io_uring IOPOLL plus a PI attribute on an integrity device
(scsi_debug dif=1 dix=1). KASAN reports:

  Oops: general protection fault, probably for non-canonical
  address 0xdffffc0000000004
  KASAN: null-ptr-deref in range
  [0x0000000000000020-0x0000000000000027]
  RIP: 0010:bio_poll+0x9d/0x4b0
  Call Trace:
   iocb_bio_iopoll+0x5b/0x80
   io_uring_classic_poll+0xf3/0x140
   io_do_iopoll+0x4e3/0xc00
   io_iopoll_check+0x275/0x560
   __do_sys_io_uring_enter+0x2e5/0x720

Return -EOPNOTSUPP when HIPRI is combined with user metadata.

Fixes: 2729a60bbfb9 ("block: don't silently ignore metadata for sync read/write")
Assisted-by: LLM
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20260923093732.1504291-1-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index cb919dea00411..1f29aeb19157f 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -404,6 +404,11 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (blkdev_dio_invalid(bdev, iocb, iter))
 		return -EINVAL;
 
+	/* HIPRI needs private as bio; HAS_METADATA keeps it as uio_meta */
+	if ((iocb->ki_flags & IOCB_HIPRI) &&
+	    (iocb->ki_flags & IOCB_HAS_METADATA))
+		return -EOPNOTSUPP;
+
 	if (iov_iter_rw(iter) == WRITE) {
 		u16 max_write_streams = bdev_max_write_streams(bdev);
 
-- 
2.53.0



