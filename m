Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF5046EF71;
	Tue, 21 Jul 2026 17:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656651; cv=none; b=gAgOb+5000hAAwT5SOgumrO4EGLoqDxLOz2OGNwAOsg9jEjAGOGKgsXKoky3DVspqqjNP+uu9c++c/ejaUi4uZwpsAE9srx60LhGsEr7hoHaKucHmoNKpyPReq0c2LrmblZXE04IqFMxBHSfnQHO7ZJLTC18kIiWr1QbiMtbKsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656651; c=relaxed/simple;
	bh=jY7YGNxQus7XcGtyN6gU7vhnzS5JFUzj5HgqSRnEMdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fs9m/3iGi498kag+hHzh0JGCVu1/PEcGkHdDq2h32Hr5KJUsvfoniHzPhFXDtOXjNt7ws3i1HntaIEzF31bA0dBKjPJr9S14S5zwwZutJchi7aCpVJY2Ey3MmosdXD48e3Rrsxj+CiGeDIX9hw/6NzBqcdTuSss0CadYKhAPz9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFD0LMx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFD0LMx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8861F00A3D;
	Tue, 21 Jul 2026 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656650;
	bh=+G4iQMsBpHyV/nPDkQRM4Atec3FyCqvVpT1YA1lP/+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFD0LMx9T/N0pcHcNvzFosR/9r8DJIVAN2BwD/+yr76kRoJJCACO2TIFlT/cctoet
	 NzxeVjrotZdEGa0I5jNbbD+91mjfna+G8DNTR/bfG09E/7BJhT5ScKZ9XOYh2X6xGi
	 tOzydOyf4ObF5y8whNLZjT6YSnKphM7T03HpDW+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0424/1611] Revert "btrfs: fix the file offset calculation inside btrfs_decompress_buf2page()"
Date: Tue, 21 Jul 2026 17:09:00 +0200
Message-ID: <20260721152524.806109911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 8c3899832a1aa1..fbf1ff5965994c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1187,22 +1187,6 @@ void __cold btrfs_exit_compress(void)
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
@@ -1255,7 +1239,7 @@ int btrfs_decompress_buf2page(const char *buf, u32 buf_len,
 		 * cb->start may underflow, but subtracting that value can still
 		 * give us correct offset inside the full decompressed extent.
 		 */
-		bvec_offset = file_offset_from_bvec(&bvec) - cb->start;
+		bvec_offset = page_offset(bvec.bv_page) + bvec.bv_offset - cb->start;
 
 		/* Haven't reached the bvec range, exit */
 		if (decompressed + buf_len <= bvec_offset)
-- 
2.53.0



