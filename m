Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAD141F37E;
	Thu, 16 Jul 2026 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211160; cv=none; b=XyMfg/8tT9178XSbMchlWMvVYDwgUZnLin2izUjQHXBlm8Hsb3i2Iu/fLXikD/LSfR25s0QvieZzAIAdNXiLabT45hpdZHgjj22FPk1+kUvbMn9RW/7DKlBq3UJKdYrJDDLqr5CJmqPu5wXbO+92gx14DOf9ly+6WjLvIuswpKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211160; c=relaxed/simple;
	bh=oM0GBwQsYmuJ/lHBnhoWYbZdte1dhSgep9/DzLOn/BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blfTFHNQjUsFhnbakineJGrevhrX+50DsL9MdO7GtUZGl5w8Qz9/Hb1gyhhwFagV/GLETDT2N1Jb3HP81SL5Y/FLqtaK4cOzUscFv3ZwP+taAECIGgThsCgvn2VGhLCtylwUrNTUKzYzW5z08Wcbno5l574G1AXZjIYUbTTHtiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o84Vqd88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o84Vqd88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90621F000E9;
	Thu, 16 Jul 2026 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211159;
	bh=qzbVp5Ji1Z8B1Fkt0g0o/ok89h9wEEDJg/U3UbCSh4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o84Vqd88qHtnBsxJrVcNR8GgUzJk4mE7pXLrj75FcigtKvZhOpB57FmDwJpNnAQM3
	 2r6D5Agyab0q3S3fWAU4s+Cx1OEN+Ksp3MLsA7vypuxayVbcFrZwrK6nEqvT4xtLZ/
	 CdenlbhTDjBjo3s3u2VGIpXNbiXOEa0NXkKB14S0=
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
Subject: [PATCH 6.18 320/480] block: skip sync_blockdev() on surprise removal in bdev_mark_dead()
Date: Thu, 16 Jul 2026 15:31:07 +0200
Message-ID: <20260716133051.742630862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1237,7 +1237,13 @@ void bdev_mark_dead(struct block_device
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


