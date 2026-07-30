Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E4A3932E0;
	Thu, 30 Jul 2026 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427611; cv=none; b=RGNptadVQ4Idpii/B9GCAlWFOrERv4lIM9w3Xh7AOLOeW/tKBO8LmvjFBfxB1SoUDjdtBWn5Tuw1yWl+UU0Qf+U68OXPFZAQEXX2CUFEjc43kMYw+pey09PIJwCdxKT9GmtBmxTz8H7nsk1/iHO7FiF3vakQ4bwq04GVAsfx6bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427611; c=relaxed/simple;
	bh=3bFqVle0SlNdg9B97lmqTk9+p5am6S1gl59SF9mbJio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJhl47wtLzLzLSILnWEt7fYkBgGoxfhEKALWRK7IoIu8sljBZDshJIArFunaxZ5K5QyT89JBoCtWFen+ul7+GCB4+/yX8/AOLcv6tKaTIhdy8AH3TNH3/hcuYQeus0zhOU/+H6oaQyDGtkongQUnLizuFTkut4zpqIPDBWCkg7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6y78V+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6y78V+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F151F000E9;
	Thu, 30 Jul 2026 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427610;
	bh=5IN/7PRz902AuP+XrAA0zGRLy+CJGWfP0KnNhhPC1mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6y78V+URdGuT2rdoFnpY1wiAv1kExGKFJDdM2AGYJ69EZDgeAqud90FOavVnzloN
	 lRlzHccmUw39braA7RptLgT7IwpGU4NY3p/WuB44S3ruxL8q1qGE7H7qgLwYoRCXff
	 77gYBb2zm3yv+AOujl8SgtrfRTpd9Nvkpnmun6Rs=
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
Subject: [PATCH 6.6 186/484] iomap: correct the range of a partial dirty clear
Date: Thu, 30 Jul 2026 16:11:23 +0200
Message-ID: <20260730141427.506286577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 4bc57934aa52df..bc7d176c4cf139 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -98,13 +98,17 @@ static void ifs_clear_range_dirty(struct folio *folio,
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



