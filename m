Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18705475F;
	Sat, 12 Sep 2026 14:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224155; cv=none; b=fidndscY5/+XrH7YAE9ivhkpCl0iLpz/w+0O5VLsvzcrlitgVJeHjrM6LdWaFD3dTlcFLbRVPdeUrZVG0pIt6O03gn7T81opYUXXyYFR/RufXitmX4+GG/ttFCQVNdEr35xGlbITTaINvdjKoDfVD6+6e4iZvYdKbfZmS2oeGP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224155; c=relaxed/simple;
	bh=UQfBHXWM5YBdYStCgftlbdDPzq2RuVuMFRLx7qHrlOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQyeDHh9hOxolj0/MEt7Bx+KhnQ77tRSUyZULAr50myggbZf8LkSZvtC8SXHVKqrJd7WpIVIrOT80BFCWeNIBvQeYhj1NnRLs9effHGDPdGpXUZLnd2vj8fe9Wobw1998Pp2UncuZi/KBmy7YJaUV0FYnPfR0NnRiEVoTbtPxxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfWIBSqy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfWIBSqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC31F000FF;
	Sat, 12 Sep 2026 14:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224153;
	bh=4KdaxLy7RFeIu2UN2/pDmBgO/9fy43h5zguHHDAgyfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yfWIBSqyTc0cNKe3F9+yt6wI1pXLmBZ90tpkPyh4HJLccrSVW+8UHdA9o1Mc51s2z
	 EJEVEglZ3oQHAEEZJY5yVFMhhzr3XWetwLfh0/YTX9utDk91OmMGKSsZNqEaeWP9J6
	 fbRoC31ucUeBHjdVZXpTtUyASjBsumK0mrBId1n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0908/1424] nilfs2: convert nilfs_forget_buffer to use a folio
Date: Sat, 12 Sep 2026 08:55:40 +0200
Message-ID: <20260912065627.660912230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 797e25ad106b5f0c49bdbeb6ce015acae6b93b3b ]

Save two hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-5-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 66f4ad3ce158 ("nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/page.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 144e200c4909a..2582e8a508d60 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -73,7 +73,7 @@ struct buffer_head *nilfs_grab_buffer(struct inode *inode,
  */
 void nilfs_forget_buffer(struct buffer_head *bh)
 {
-	struct page *page = bh->b_page;
+	struct folio *folio = bh->b_folio;
 	const unsigned long clear_bits =
 		(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 		 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
@@ -82,12 +82,12 @@ void nilfs_forget_buffer(struct buffer_head *bh)
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
-	if (nilfs_page_buffers_clean(page))
-		__nilfs_clear_page_dirty(page);
+	if (nilfs_page_buffers_clean(&folio->page))
+		__nilfs_clear_page_dirty(&folio->page);
 
 	bh->b_blocknr = -1;
-	ClearPageUptodate(page);
-	ClearPageMappedToDisk(page);
+	folio_clear_uptodate(folio);
+	folio_clear_mappedtodisk(folio);
 	unlock_buffer(bh);
 	brelse(bh);
 }
-- 
2.53.0



