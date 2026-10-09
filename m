Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1F633A6EB;
	Fri,  9 Oct 2026 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555585; cv=none; b=ZbKwC5uZBg3o9JqRWJGBILq7MPC2W+0AHJL1a1kEbShSwAbs99KDtm8jCrz48uMJ+dyhyGuHzkrbbzoQDs6Ck2QqwDoAPE92NuGc0B9aD+UB5qrBGryYzOiICiq4ZZngzvdXDNHhvMmwjZivFsk8N8Z8l0BdGAf6v4tfm9IUM4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555585; c=relaxed/simple;
	bh=oFu4D1fpghAnQyEgIdhHG+NVqw6yLH5RIYCFOaLdRFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aemteZeFPH7hgHfU2/a7K/+VseFTjWHJZr4Ds+i9jcPkyvKSs+cRJdVmy2VC6OWH9eAAARtpldRXe1AnhE6SGBujD+T3q1faLlXxfsn/i0g/P/Z+upT7ZhEsi2ULOdl2TiVfFOwkjTeX16m0cfIKAQBJk1hetkS9txl1bnCnNps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We1P6w7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We1P6w7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB171F000FF;
	Fri,  9 Oct 2026 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555577;
	bh=L9QFaTd36/9KITY0PyieBHv3ElkC0nU2YWuEvT6w0ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=We1P6w7gUYp634O08heaxx/5qPtQjQvgzkSh9F5WacuwLFYFioaXSCfpxxEmU2znG
	 51luWs9Y6e8zVta3j+ZtiO9RtiC1jaAAxsQD5aAi3iX8CC1mQw9Qu14PaIcHd64jVe
	 htR1+LyZVO/ewTBBDd+0hKhUvX1JdJAQX8q2PZSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/403] block: reject polled dio with user integrity metadata
Date: Fri,  9 Oct 2026 16:07:23 +0200
Message-ID: <20261009140954.010958711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bbc89773e07f8..cc9cb54fcd416 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -409,6 +409,11 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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



