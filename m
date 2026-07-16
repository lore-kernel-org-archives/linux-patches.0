Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D30427A04;
	Thu, 16 Jul 2026 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212249; cv=none; b=knTZzfXHIs3DpTZa3h7PMw1zQA8mXskkFLqHYaf48Eq+28ApNWI/NT+mMAwmtB/UHg8OTmcgqGlMc5OTl2/5hEfXJm3ZOMLq2xZ07FTT7NGayFXaxrIhyR43j85BfipBp/Zdri7Y06H6yYFqc11baiLEgwAID0q5/T8tI/+dBME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212249; c=relaxed/simple;
	bh=uYxMJE8PP41aUckSJMgNN7nHSPxdSgkjkSPui69MI4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq6ZdaeYWYGqA0QAovTzKjM3HCsGzOf2eO6TMOGOVhNeslm6wFbfVRBmPmn/CnQAZ9fDag6BgGCJgLdug4eZoEZxutpeBNWpBRPa4Uu54pFgSZVAvxYK3JUv5zDoYGQnCCjn/syV9TDcfvBu74lb2NnJlSOn4PCtFNB93crDVUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRcUoY13; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRcUoY13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8931F00A3A;
	Thu, 16 Jul 2026 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212247;
	bh=n3MbIwzJ0KMb7GX7FdbcbxS4Is55bsMIGRnWnHCzjls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRcUoY136ipQIrp6fnmnMw9pQIIsQki3pFd6kvtD8tuiLQ2wc0OEqd9z0Hzm24ryR
	 qj5npMacU6TG/I0l4paGeCbCC6UW/qrsCHWILHHVuZXyKVAenX/a7wzb4z97/3e6OM
	 FSA4QEPPqLcGwOPoTTJhcdFF1v5xsXfiBXiAH8Dw=
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
Subject: [PATCH 6.12 255/349] block: skip sync_blockdev() on surprise removal in bdev_mark_dead()
Date: Thu, 16 Jul 2026 15:33:09 +0200
Message-ID: <20260716133039.057342464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1213,7 +1213,13 @@ void bdev_mark_dead(struct block_device
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


