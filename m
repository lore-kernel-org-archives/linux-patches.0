Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4C5415F0E;
	Tue, 21 Jul 2026 20:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665614; cv=none; b=mQXZD8U0qTeKUXoViQzx2I7NcCYhYmWiob87JmPvmcT+688kmouaOzREBYzvpI2ub5j1nRJyVmYmntaBOqzq562Za6V9CqVh9iItpKHsLx7eklaZAHHpCvyAJmS0ZIpfWHrno2IP8RGNPf8iiJaXbqWmC/zXgkkKazMOfSgyIJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665614; c=relaxed/simple;
	bh=BSJnDPh1WPVOlUWCpqM9yBzAlAepQH2RuyKHuFKriK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bejXrLHg3NRKLK6TK5wg97heXO0xcMVxQLC9x8JufkVBbE7bucUtGI2J4IAGCV9oHWWv8Zif3zxszrT5fnyuvsEODUgK6O/EYdY1fxsq6VuxaQhgU96OTBaVDMfo7yV8TJySXl2DfPPmi1BjRVV5Iimu7wXZy3NMn7Tk88UT23M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tp08bdfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tp08bdfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645121F00A3A;
	Tue, 21 Jul 2026 20:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665612;
	bh=kDzf6Ym96pkdiqqMyoFa1JzVBVLML+bnjlUCgSnF/HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tp08bdfLHiqpYbDBWvx1/87htigk6H/D5HgNFcQoQjBm2vcZhyufLiQU9bKNqKqya
	 s5Vv+iCgUPZzPDQsNc1tHSP6vzR8ET5xKBPgsbe2piQJPofCLG+nTAnXikoNY9l3B4
	 UbxtVF2cyRC90aU3C2w5RNxmH0/FTA3PSBwm/c9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Dave Tian <daveti@purdue.edu>,
	Weidong Zhu <weizhu@fiu.edu>,
	Chao Shi <coshi036@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0327/1266] block: skip sync_blockdev() on surprise removal in bdev_mark_dead()
Date: Tue, 21 Jul 2026 17:12:44 +0200
Message-ID: <20260721152449.152018274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Chao Shi <coshi036@gmail.com>

commit 49f06cff50a4ccf3b7a1a662ceb892b3b21a527a upstream.

bdev_mark_dead()'s @surprise == true means the device is already gone.
The filesystem callback fs_bdev_mark_dead() honours this and skips
sync_filesystem(), but the bare block device path (no ->mark_dead op)
lost its !surprise guard when the holder ->mark_dead callback was wired
up (see Fixes), and now calls sync_blockdev() unconditionally, which can
hang forever waiting on writeback that can no longer complete.

syzkaller hit this via nvme_reset_work()'s "I/O queues lost" path:
nvme_mark_namespaces_dead() -> blk_mark_disk_dead() ->
bdev_mark_dead(bdev, true) -> sync_blockdev() blocks in
folio_wait_writeback(), wedging the reset worker and every task waiting
on it.

Skip the sync on surprise removal, matching fs_bdev_mark_dead();
invalidate_bdev() still runs. Orderly removal (surprise == false) is
unchanged.

Found by FuzzNvme.

Fixes: d8530de5a6e8 ("block: call into the file system for bdev_mark_dead")
Acked-by: Sungwoo Kim <iam@sung-woo.kim>
Acked-by: Dave Tian <daveti@purdue.edu>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260522220025.1770388-1-coshi036@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ adjusted for 6.6.y: bdev_mark_dead() there still unlocks bd_holder_lock
  after the if/else and the else arm is a bare sync_blockdev(), so the
  !surprise guard is added as "else if (!surprise)" instead of inside the
  mainline else block. ]
Signed-off-by: Chao Shi <coshi036@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index 598f94827b941f..a255492ba82654 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1024,7 +1024,12 @@ void bdev_mark_dead(struct block_device *bdev, bool surprise)
 	mutex_lock(&bdev->bd_holder_lock);
 	if (bdev->bd_holder_ops && bdev->bd_holder_ops->mark_dead)
 		bdev->bd_holder_ops->mark_dead(bdev, surprise);
-	else
+	/*
+	 * On surprise removal the device is already gone; syncing is
+	 * futile and can hang forever waiting on I/O that will never
+	 * complete.  Match fs_bdev_mark_dead(), which also skips it.
+	 */
+	else if (!surprise)
 		sync_blockdev(bdev);
 	mutex_unlock(&bdev->bd_holder_lock);
 
-- 
2.53.0



