Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481A546C4B2;
	Tue, 21 Jul 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649520; cv=none; b=Tf/89bwThBo7gXrXMz+B3GXSPTYsS5jdmQbNvvtpgkM1LrrORC8mmqKx+TrSBIa4sYpFXFlVqa9BDD+4IQ6Lq585QvNK6kE0JUJgyH6ww9rgiwPa0ZHCYMcRSTR0wVFRVlWCPGSs2xtXzYoi6fptBUZ5H6yAWvlDjmxq/wbnNwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649520; c=relaxed/simple;
	bh=GmG2A00IUOrNjgS72iRB5zJE0w0vWydK7GpH/aD9FMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJRzqXAqNnFo1SKWFDnSL45l/hAcZv5O7d3iqmIf6yfRdgDBhRHYONpclzQ1mQgRQWVJFreT2aL3UQHO5EA0FaxrET07wWflQy2C4Tu80kdAR/DUb4hNtTmuicvuITGYI7tKUzG7StQ0x6pjVPYSmVySefnqg7G6vwPdhw9fxuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usp2Urik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usp2Urik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5291F000E9;
	Tue, 21 Jul 2026 15:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649519;
	bh=ytbMmqUTB05trw1Jlx1taQ9GHM06CbgC2ldosS037vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usp2UrikrsYNe2aua+8uIr5d55tcHlohU82ryUZd7tX2c/ft4WPPnoGbIQf4pCTaY
	 hbnwpmtLqVlnn4orIm6HfrkjsOPY48Rfnk/J3whruBr3bHLs6Wpp6uF1zAEzpCKEWh
	 Ehf6nwzafWFrnfIvEqrCrEynDe6nAhTG9RXFJd5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0610/2077] Revert "btrfs: fix the file offset calculation inside btrfs_decompress_buf2page()"
Date: Tue, 21 Jul 2026 17:04:43 +0200
Message-ID: <20260721152607.194570250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 0279bed34c22dd5ebff12e5af8ef940de93c5523 ]

It seems that af566bdaff54 was tested against a tree which did not
contain commit 12851bd921d4 ("fs: Turn page_offset() into a wrapper
around folio_pos()).  Unfortunately it has a bug of its own; on 32-bit
systems, shifting by PAGE_SHIFT will overflow on files larger than 4GiB.
Since page_offset() is now fixed, just revert af566bdaff54.

Fixes: af566bdaff54 (btrfs: fix the file offset calculation inside btrfs_decompress_buf2page())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Tested-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/compression.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index a02b62e0a8f33e..2ceb5661e0718a 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1191,22 +1191,6 @@ void __cold btrfs_exit_compress(void)
 	bioset_exit(&btrfs_compressed_bioset);
 }
 
-/*
- * The bvec is a single page bvec from a bio that contains folios from a filemap.
- *
- * Since the folio may be a large one, and if the bv_page is not a head page of
- * a large folio, then page->index is unreliable.
- *
- * Thus we need this helper to grab the proper file offset.
- */
-static u64 file_offset_from_bvec(const struct bio_vec *bvec)
-{
-	const struct page *page = bvec->bv_page;
-	const struct folio *folio = page_folio(page);
-
-	return (page_pgoff(folio, page) << PAGE_SHIFT) + bvec->bv_offset;
-}
-
 /*
  * Copy decompressed data from working buffer to pages.
  *
@@ -1259,7 +1243,7 @@ int btrfs_decompress_buf2page(const char *buf, u32 buf_len,
 		 * cb->start may underflow, but subtracting that value can still
 		 * give us correct offset inside the full decompressed extent.
 		 */
-		bvec_offset = file_offset_from_bvec(&bvec) - cb->start;
+		bvec_offset = page_offset(bvec.bv_page) + bvec.bv_offset - cb->start;
 
 		/* Haven't reached the bvec range, exit */
 		if (decompressed + buf_len <= bvec_offset)
-- 
2.53.0



