Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F634429CD6;
	Thu, 16 Jul 2026 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209848; cv=none; b=Qy74RpVGeYE2Mcn3Xn5vs5pL2q+T430Mp+2jLpicfqqTQjF8kJXjR9kflCjbbDDq8+OqY/+wb8rY2qZbsjIqsxHelzw+FcfJH2s16JdQJkOvHKlz4PNTk9HtwE05Q/UDe1C341CFvBfquirpTzYhWlUCS8WqoKK/WT52VOWfrYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209848; c=relaxed/simple;
	bh=V5hcN40Qf4FPsACNP8iTpzSwa3kwsZsEKkSavx2o1Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSNMoOvpTJn7iZUXCO84sqJFhY5jso3zjwH6w6Uv3Bx7cvgiQI+EK7sG/S031a0cWrc8sjvgVzLNcsORKMfHcWEmCn9UlDNQqBNFd1Yw47ltPUDFYmSrFp4SEnSB9BSfVrQZEHSASOR/tKiLXjP+h+BzQz3Y8fTQgwa/s/zid6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4rQEEZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4rQEEZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD2A1F00A3D;
	Thu, 16 Jul 2026 13:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209846;
	bh=VftYEMQ4hRT826KU9fNX1IVMGetXoKurebZQI/Xen4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4rQEEZBFebfILd3F1Sk00Mtf2bxdP07Csi/kbVAkza2VYEs8IN5go5s2E6RdWagm
	 eDHQddEJX8B7APwBqghynE78bdMH0UqxMUIvpGSHb0X1J7Y0bfRX4D7L0GOQ2UXghP
	 OUsDWHtnntpBL58twQ6MrxRZLxSjzj5l7C0aHQaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Dave Tian <daveti@purdue.edu>,
	Weidong Zhu <weizhu@fiu.edu>,
	Chao Shi <coshi036@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 340/518] block: skip sync_blockdev() on surprise removal in bdev_mark_dead()
Date: Thu, 16 Jul 2026 15:30:08 +0200
Message-ID: <20260716133055.251797092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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

Found by FuzzNvme(Syzkaller with FEMU fuzzing framework).

Fixes: d8530de5a6e8 ("block: call into the file system for bdev_mark_dead")
Acked-by: Sungwoo Kim <iam@sung-woo.kim>
Acked-by: Dave Tian <daveti@purdue.edu>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260522220025.1770388-1-coshi036@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bdev.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1245,7 +1245,13 @@ void bdev_mark_dead(struct block_device
 		bdev->bd_holder_ops->mark_dead(bdev, surprise);
 	else {
 		mutex_unlock(&bdev->bd_holder_lock);
-		sync_blockdev(bdev);
+		/*
+		 * On surprise removal the device is already gone; syncing is
+		 * futile and can hang forever waiting on I/O that will never
+		 * complete.  Match fs_bdev_mark_dead(), which also skips it.
+		 */
+		if (!surprise)
+			sync_blockdev(bdev);
 	}
 
 	invalidate_bdev(bdev);


