Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0923587BE;
	Tue, 16 Dec 2025 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886636; cv=none; b=VRnK/5XfMfOZD22Rxy0gxnK5KQosJzotE5uvTeg5UcZm4KkCXtRWbuXnPfjFg34cBDA+Oex1HwthaOAgxxHDMV4+6x7LWsTyvWac6u0HOsXxEhpy3huMDNhlbj6i0BKNG92WvTquaOpku23SWEQFzm8dhqUsVXzcnbEbOeeaLaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886636; c=relaxed/simple;
	bh=wVjAR5rNhMFCq2/yy68F/9eZvJ6Cu6fNQVMUfElONM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9QOdgI/a+m9nEVKm6SZpOzwFXIypHA9s5msRoZwg5bmOmZigjy7Jbn+kjKCeIRSx9x1KCf8YOXtOf4A3lvVeMbp5+Mc1oBX6HhjPpZ9xqo82r7PjVxftz7K0UmLBt/AROMugfo+ZkpRmvJG+yjE8ElEOCAKcnz8UScX5oNuuIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3YE0qI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3YE0qI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B1BC4CEF1;
	Tue, 16 Dec 2025 12:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886636;
	bh=wVjAR5rNhMFCq2/yy68F/9eZvJ6Cu6fNQVMUfElONM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3YE0qI7DWJzTx+PBHpS6Dzk/wXudzgqYBImGjgyd1UiSzvtaOOYh1r8QVbQ8HsyX
	 Sda64gi3TK00NuP4fP1bS6mXX2ketgyHY54UPWoyGRwRgVVLyvL8wczHMM4MiUbcub
	 Ltg8e7bRsU2L/IeBUkvvTcXBq+7FhIA9CEYNVJYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+527a7e48a3d3d315d862@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 462/507] block: fix memory leak in __blkdev_issue_zero_pages
Date: Tue, 16 Dec 2025 12:15:03 +0100
Message-ID: <20251216111402.184420576@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

[ Upstream commit f7e3f852a42d7cd8f1af2c330d9d153e30c8adcf ]

Move the fatal signal check before bio_alloc() to prevent a memory
leak when BLKDEV_ZERO_KILLABLE is set and a fatal signal is pending.

Previously, the bio was allocated before checking for a fatal signal.
If a signal was pending, the code would break out of the loop without
freeing or chaining the just-allocated bio, causing a memory leak.

This matches the pattern already used in __blkdev_issue_write_zeroes()
where the signal check precedes the allocation.

Fixes: bf86bcdb4012 ("blk-lib: check for kill signal in ioctl BLKZEROOUT")
Reported-by: syzbot+527a7e48a3d3d315d862@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=527a7e48a3d3d315d862
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Tested-by: syzbot+527a7e48a3d3d315d862@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 4c9f20a689f7b..8cb2987db786f 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -200,13 +200,13 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
 		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
 		struct bio *bio;
 
-		bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);
-		bio->bi_iter.bi_sector = sector;
-
 		if ((flags & BLKDEV_ZERO_KILLABLE) &&
 		    fatal_signal_pending(current))
 			break;
 
+		bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);
+		bio->bi_iter.bi_sector = sector;
+
 		do {
 			unsigned int len, added;
 
-- 
2.51.0



