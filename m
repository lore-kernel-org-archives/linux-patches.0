Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6703769F5;
	Thu, 30 Jul 2026 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424117; cv=none; b=Y87rKWqLMVcpTG0CbkNOX23fV9v25pG1JrNi+S3ifP92MNueYjsnkWEMCThhRl7YnogSmxXJ7HWBBJWc2tWB6iOyN9UzyoJQolhkkKck/Ea+jqKRnO++BQu94ZIl2n6lFNchvkhgUjDJaAyWOele1PUXkioxFAYCW1lWPIAQ0cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424117; c=relaxed/simple;
	bh=ZSvAk47OzTg3lNW8mKfoyezHAIJu7ohzQT/wuTSDbHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djRJyWgDqo2EejRswUAeTUc9YPKCHmup+3SJheLb0LjrxD4ydc6wo4NrUWWCnBT8a7GlcFOzCsCdTImqxA1REZv48rGSve06uMGuGZJOri/Al3xpmQOdByL/VAhyCyPRkDNw5CobiywEA4vR5sO/4mlJJZa/I7ACrxan+mw7S7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucf7hjba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucf7hjba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6C91F000E9;
	Thu, 30 Jul 2026 15:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424116;
	bh=2FUe3L2uOUbB1QtepNXpKkBcDRWqYiTKXut0b87ploI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ucf7hjbaPUsH9/Ot+Hi+NNrc4ABHSckNIE+Lad3UT6aXjJFawuuNseEa/NSrM9zht
	 e+mQZdLDs8qMfKsU+Gn7V7jriSpv3xqRBHbT9chN9mUeuukyQjUojP7hMQ0yeQGq/r
	 4K0RMNyNiSx9KiiX3uTG3I9uvxYn8Zk16gRGc/H0=
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
Subject: [PATCH 6.18 282/675] iomap: correct the range of a partial dirty clear
Date: Thu, 30 Jul 2026 16:10:12 +0200
Message-ID: <20260730141451.117980395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index c0fa6acf19375b..734854f864fd1e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -127,13 +127,17 @@ static void ifs_clear_range_dirty(struct folio *folio,
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



