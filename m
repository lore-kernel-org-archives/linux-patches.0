Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BCC158878;
	Tue, 23 Jul 2024 18:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759992; cv=none; b=nkKT9El/+sWWYMWHkgknehVx3IyZ7Nqk40s5AB5AUlMlk73CWjXzBYktb2yQNBjoNq6Yj9sYZlVrzsl22bvqZSwmrJ3buS1O0GVPaij90INcoxhCkg3E6FvfvqJdACY6PxhAp59VGBK21xTzRUu+7Pa6q22Esnntti5Ey/ldz1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759992; c=relaxed/simple;
	bh=TPXes8IA0j1MXYObiXkEEvOJQ6esrz9ni06nypEsw+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADG5DtnritXJURX2O8bzssLpJZPP6yWzIYamLL52AHULOVzIsqy3anG3a8VKxnWos9XIVuXhTc0oMiImg2eTWIVMs/hp937HGEV7fmCm3nYI0fZYFoeajPvpTWRAxeX5UBgPX9TYXWgtEiDTd0Et2wTRF5WMbp7yj/EATqHbjQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq2aeVss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq2aeVss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6A9C4AF0A;
	Tue, 23 Jul 2024 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759992;
	bh=TPXes8IA0j1MXYObiXkEEvOJQ6esrz9ni06nypEsw+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lq2aeVssQ8LKnwHQtOuYCzPl/m2odTvVDG5rMN7HET3veeTX0k646EHTJEuS7kE/i
	 2yjUbBt+WOW559iJXY+5nBPvF0qHgbG5TJb1+b4QoSUVp6yyg+8s6g3A6YuLOlaUtx
	 Va629r5pCN0d+NfP09bocMS1qocZzDClWaLhrPsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Cyril Hrubis <chrubis@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 065/163] loop: Disable fallocate() zero and discard if not supported
Date: Tue, 23 Jul 2024 20:23:14 +0200
Message-ID: <20240723180145.984044325@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Hrubis <chrubis@suse.cz>

[ Upstream commit 5f75e081ab5cbfbe7aca2112a802e69576ee9778 ]

If fallcate is implemented but zero and discard operations are not
supported by the filesystem the backing file is on we continue to fill
dmesg with errors from the blk_mq_end_request() since each time we call
fallocate() on the loop device the EOPNOTSUPP error from lo_fallocate()
ends up propagated into the block layer. In the end syscall succeeds
since the blkdev_issue_zeroout() falls back to writing zeroes which
makes the errors even more misleading and confusing.

How to reproduce:

1. make sure /tmp is mounted as tmpfs
2. dd if=/dev/zero of=/tmp/disk.img bs=1M count=100
3. losetup /dev/loop0 /tmp/disk.img
4. mkfs.ext2 /dev/loop0
5. dmesg |tail

[710690.898214] operation not supported error, dev loop0, sector 204672 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.898279] operation not supported error, dev loop0, sector 522 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.898603] operation not supported error, dev loop0, sector 16906 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.898917] operation not supported error, dev loop0, sector 32774 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.899218] operation not supported error, dev loop0, sector 49674 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.899484] operation not supported error, dev loop0, sector 65542 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.899743] operation not supported error, dev loop0, sector 82442 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.900015] operation not supported error, dev loop0, sector 98310 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.900276] operation not supported error, dev loop0, sector 115210 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
[710690.900546] operation not supported error, dev loop0, sector 131078 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0

This patch changes the lo_fallocate() to clear the flags for zero and
discard operations if we get EOPNOTSUPP from the backing file fallocate
callback, that way we at least stop spewing errors after the first
unsuccessful try.

CC: Jan Kara <jack@suse.cz>
Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240613163817.22640-1-chrubis@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 28a95fd366fea..95a468eaa7013 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -302,6 +302,21 @@ static int lo_read_simple(struct loop_device *lo, struct request *rq,
 	return 0;
 }
 
+static void loop_clear_limits(struct loop_device *lo, int mode)
+{
+	struct queue_limits lim = queue_limits_start_update(lo->lo_queue);
+
+	if (mode & FALLOC_FL_ZERO_RANGE)
+		lim.max_write_zeroes_sectors = 0;
+
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		lim.max_hw_discard_sectors = 0;
+		lim.discard_granularity = 0;
+	}
+
+	queue_limits_commit_update(lo->lo_queue, &lim);
+}
+
 static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
 			int mode)
 {
@@ -320,6 +335,14 @@ static int lo_fallocate(struct loop_device *lo, struct request *rq, loff_t pos,
 	ret = file->f_op->fallocate(file, mode, pos, blk_rq_bytes(rq));
 	if (unlikely(ret && ret != -EINVAL && ret != -EOPNOTSUPP))
 		return -EIO;
+
+	/*
+	 * We initially configure the limits in a hope that fallocate is
+	 * supported and clear them here if that turns out not to be true.
+	 */
+	if (unlikely(ret == -EOPNOTSUPP))
+		loop_clear_limits(lo, mode);
+
 	return ret;
 }
 
-- 
2.43.0



