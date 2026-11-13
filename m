Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591478;
	b=QwLm+FPj8FBTnAHt7iEaifSwOstYwIklcHlhZKxE4Dggp39St1XivKoFao93/tvthvRU
	 tdBMeokuSZLbPkJKsSgQyf8dMIwjwmrV/6idD/U42MG4pGl6Ja7HJKl2zvV7NOTrJODQ9
	 HREy94tw/+dCMPwvySP0m6g1l6To/jhFpcB3OdZimXkMQty9peb1wgBgVzRr0K3vGad9L
	 gRr79W3GBe5tl6de3zs6F8jJ2MqAqlCctSeZcV//QyKLGc+kF5lE/mOHYCkBk51rFW3r2
	 XbWWTYeNeTfbWbQvVXH+8NRUjPa4SgdId745bVoKsX+azaAYey1Fhcou0/e0rwYfotg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UDrKYqHmUndpDwJg5vQwBKqrEubt2bAspWVXHgdgMII=;
	b=ktGoA+oly6did30P+TsShLLMy1iEjQEskGzGi84DGYjMNV6TlrisU1GqtDl1ODxS5hlR
	 RlDUOQoAglQKBH+yeeWHeWy82KU6q7d0mVWy40FZnROWbwJzJBnVf13jvxLHmcJbi8TdX
	 puydcDI8XeOJEtrz34C+HpJLqTcjKBy/QytptxMxptYcyg87xdp8/iF3LzN2W+k8e3x0p
	 hrrZuUKCE68EwesgPtgRpH94DdYC4TqRT89I2BirDL7SOpahepYPCUrOcdGAzCtD9F7hA
	 ZaLBDYat/Ea7uVplgesQFU8WUoiVL71M3eRW+SMwil67ajyTW2wkBFgAutHzucHCq4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qawxo0kP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F0607D2DF;
	Fri, 13 Nov 2026 17:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qawxo0kP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE491F000C4;
	Fri, 13 Nov 2026 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591478;
	bh=UDrKYqHmUndpDwJg5vQwBKqrEubt2bAspWVXHgdgMII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qawxo0kPpipCuVJavu5v/I95/QQ0OSKLkS5uIsxj3UnHTIR29OXTEJLkSJ7guLARK
	 hJpM1/IqT6crpn/WjRnXFEOBsbtE7znD77HgasM7hrMmA8TYqJBZ3rVcGrsHKAd0uI
	 yvGQyBKGFyVZp43SFnBFsJTLjxS2vjTJKokQAYaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 559/670] nilfs2: convert nilfs_page_count_clean_buffers() to take a folio
Date: Fri, 13 Nov 2026 10:52:03 -0500
Message-ID: <20261113153830.826616192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit c1d73eb8d06003e7714cd3ce1d0d79832e59b1e9 ]

Both callers have a folio, so pass it in and use it directly.

[konishi.ryusuke@gmail.com: fixed a checkpatch warning about function declaration]
Link: https://lkml.kernel.org/r/20241002150036.1339475-3-willy@infradead.org
Link: https://lkml.kernel.org/r/20241024092602.13395-11-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: cb6702e63e0a ("nilfs2: force clear dirty state when restoring from the shadow map")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c   | 2 +-
 fs/nilfs2/inode.c | 2 +-
 fs/nilfs2/page.c  | 4 ++--
 fs/nilfs2/page.h  | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index b0f182b1da8d0..287e7c8e5dccc 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -95,7 +95,7 @@ static void nilfs_commit_chunk(struct folio *folio,
 	unsigned int nr_dirty;
 	int err;
 
-	nr_dirty = nilfs_page_count_clean_buffers(&folio->page, from, to);
+	nr_dirty = nilfs_page_count_clean_buffers(folio, from, to);
 	copied = block_write_end(NULL, mapping, pos, len, len, folio, NULL);
 	if (pos + copied > dir->i_size)
 		i_size_write(dir, pos + copied);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 52f783f90d9e1..d6ac7be5b2596 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -242,7 +242,7 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 	unsigned int nr_dirty;
 	int err;
 
-	nr_dirty = nilfs_page_count_clean_buffers(&folio->page, start,
+	nr_dirty = nilfs_page_count_clean_buffers(folio, start,
 						  start + copied);
 	copied = generic_write_end(file, mapping, pos, len, copied, folio,
 				   fsdata);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index bc698bb66f790..012ade1714e60 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -458,14 +458,14 @@ void nilfs_clear_folio_dirty(struct folio *folio)
 	__nilfs_clear_folio_dirty(folio);
 }
 
-unsigned int nilfs_page_count_clean_buffers(struct page *page,
+unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
 					    unsigned int from, unsigned int to)
 {
 	unsigned int block_start, block_end;
 	struct buffer_head *bh, *head;
 	unsigned int nc = 0;
 
-	for (bh = head = page_buffers(page), block_start = 0;
+	for (bh = head = folio_buffers(folio), block_start = 0;
 	     bh != head || !block_start;
 	     block_start = block_end, bh = bh->b_this_page) {
 		block_end = block_start + bh->b_size;
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 64521a03a19e0..136cd1c143c9c 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -43,8 +43,8 @@ int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_folio_dirty(struct folio *folio);
 void nilfs_clear_dirty_pages(struct address_space *mapping);
-unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
-					    unsigned int);
+unsigned int nilfs_page_count_clean_buffers(struct folio *folio,
+		unsigned int from, unsigned int to);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 					    sector_t start_blk,
 					    sector_t *blkoff);
-- 
2.53.0



