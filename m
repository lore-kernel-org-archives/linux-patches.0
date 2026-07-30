Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4363A19CD1D;
	Thu, 30 Jul 2026 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425876; cv=none; b=crJf7fYGloehV34OtAAz3sbkoKaur1vDkKPMc5Ys0tyZ0MyJGhfGowl2tYIXCJhlBJCymmNqoassOPumdVoSPWwGI8SEGpVDp8TIKK2jc9KXZnZyEhagNX9HWCen1D/I9M9Zd4K3r3KyhKolbUOHcGzc57PNjR+F3LhoeUFtC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425876; c=relaxed/simple;
	bh=UBZWUU/qK2C4vewrw1+YmlxZWu7R+ZDhm1N9+VQHQ3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQKPjX5+kpMZlBOm29cl4atOv6fSZlrihAbRseCkp0tgtQD5CXKFMmq7pw9Gz4dGn1JT1xsMakFKFmhwE7NEOKETf8CtxzFgIi3gbgmhEWcBqLu3hLrw3k2VcdOOMre5pA6yJ1ifuT52d/gZTw+t79ewERA4SZxXn3E4/txlmFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c30a3bd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c30a3bd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA821F00A3A;
	Thu, 30 Jul 2026 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425875;
	bh=Ph4pCA9EnchtZlD8CXORST+WjDHmVphwYKTx/pZ4LYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c30a3bd8NqQXwJNHPfeHeiiV3fiqlyBh71BzgN8cV/K/LIxFRZHGq5ZDeh6+gSjob
	 pX0LXqitK3YRUrdXE2P9k4caRvIbSAX5oX/9cyB/6azQjZ/oQ3tc8NIZD2idACsPQb
	 UzakMV+Vnx92MVtaxQ/WH4IQKn+MbEBVfGfSmk+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/602] iomap: correct the range of a partial dirty clear
Date: Thu, 30 Jul 2026 16:10:13 +0200
Message-ID: <20260730141440.600468085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 88c26515313169806a412a362b32a1eca53d21bd ]

The block range calculation in ifs_clear_range_dirty() is incorrect when
partially clearing a range in a folio. We cannot clear the dirty bit of
the first block or the last block if the start or end offset is not
blocksize-aligned. This has not yet caused any issues since we always
clear a whole folio in iomap_writeback_folio().

Fix this by rounding up the first block to blocksize alignment, and
calculate the last block by rounding down (using truncation). Correct
the nr_blks calculation accordingly.

Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260714082325.325163-2-yi.zhang@huaweicloud.com
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 5f885286b2f4a0..44f5c9889cefcb 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -137,13 +137,17 @@ static void ifs_clear_range_dirty(struct folio *folio,
 {
 	struct inode *inode = folio->mapping->host;
 	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
-	unsigned int first_blk = (off >> inode->i_blkbits);
-	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
-	unsigned int nr_blks = last_blk - first_blk + 1;
+	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
+				 inode->i_blkbits;
+	unsigned int last_blk = (off + len) >> inode->i_blkbits;
 	unsigned long flags;
 
+	if (first_blk >= last_blk)
+		return;
+
 	spin_lock_irqsave(&ifs->state_lock, flags);
-	bitmap_clear(ifs->state, first_blk + blks_per_folio, nr_blks);
+	bitmap_clear(ifs->state, first_blk + blks_per_folio,
+		     last_blk - first_blk);
 	spin_unlock_irqrestore(&ifs->state_lock, flags);
 }
 
-- 
2.53.0



