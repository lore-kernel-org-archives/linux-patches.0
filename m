Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392892F617C;
	Sat, 12 Sep 2026 09:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204620; cv=none; b=eQZYSfg4kmCDAlqZijUs5+UGbUZSQ8H2udzH1Zvl7pqTdq9pjFPBYzhPy4UsxFD8GPyF9XLVZ+C33aPd2XOosJD9ehv5ZsFvipuRo/qk57YQWL0oPS5EYVH31pH5NkWV0fI8YNX9gTLi1ZaEvH21v2exwh4E5tNJaemX4lrMrvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204620; c=relaxed/simple;
	bh=VkcI/HIDuP4g3swLOpazR3bftexiPUdQqXJdvpDAeO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+R7bC/QL8nHTBOWG20Zliv+1OWFhtvojxNSQZj8H2sLulCsU1ZIrf/bgjFRQmvfDYEkmRgfMohXshiqW+LQVRMRMK13MJcgtnmn+2wMi+tbsMvc975+SzHjkfb8qxWrvVo86KqCeSl834XpLclqFFX6eGCyep+tKC99sWytMFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmxWb3Wq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmxWb3Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19F11F000FF;
	Sat, 12 Sep 2026 09:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204619;
	bh=1R2oF4/HoBGjgHxGEwSVCPNBbie4OHkjO/0YKpy88mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmxWb3WqCLFoIW5TgnzFo5J4tRXC4E5VCN92wRMPKHWdw3EvFh+DfGionbGNSaURo
	 4j489JqH6rhu/vQUEVFh5j9rTtFDlkHuyi10Cbr1VsNO5FeYHIMkTejWIo1tqklRsB
	 CqXAxmSwvdQ/o7UBnXb+Vl0/5CDL4v4/SyyAh0z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1607/1815] ntfs: Remove references to page->__folio_index
Date: Sat, 12 Sep 2026 08:55:57 +0200
Message-ID: <20260912065726.718139446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit f6ce4cbcc53cf258ae0c8f77106f2eab40a1e412 ]

Pages don't have indexes, folios have indexes.  Correct this in
ntfs_read_compressed_block() and also remove a use of page->mapping
while I'm in here.  Also convert the calls to unlock_page() and
flush_dcache_page().

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/compress.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index f03fae63c199d..d83d3e8e06aeb 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -456,14 +456,14 @@ int ntfs_read_compressed_block(struct folio *folio)
 	struct page *page = &folio->page;
 	loff_t i_size;
 	s64 initialized_size;
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
 	struct ntfs_inode *ni = NTFS_I(mapping->host);
 	struct ntfs_volume *vol = ni->vol;
 	struct super_block *sb = vol->sb;
 	struct runlist_element *rl;
 	unsigned long flags;
 	u8 *cb, *cb_pos, *cb_end;
-	unsigned long offset, index = page->__folio_index;
+	unsigned long offset, index = folio->index;
 	u32 cb_size = ni->itype.compressed.block_size;
 	u64 cb_size_mask = cb_size - 1UL;
 	s64 vcn;
@@ -812,14 +812,16 @@ int ntfs_read_compressed_block(struct folio *folio)
 	for (cur_page = 0; cur_page < max_page; cur_page++) {
 		page = pages[cur_page];
 		if (page) {
+			folio = page_folio(page);
+
 			ntfs_error(vol->sb,
 				"Still have pages left! Terminating them with extreme prejudice.  Inode 0x%llx, page index 0x%lx.",
-				ni->mft_no, page->__folio_index);
-			flush_dcache_page(page);
+				ni->mft_no, folio->index);
+			flush_dcache_folio(folio);
 			kunmap_local(page_address(page));
-			unlock_page(page);
+			folio_unlock(folio);
 			if (cur_page != xpage)
-				put_page(page);
+				folio_put(folio);
 			pages[cur_page] = NULL;
 		}
 	}
-- 
2.53.0



