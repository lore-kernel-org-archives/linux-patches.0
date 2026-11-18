Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049596;
	b=bJLKfNxl+c8RrIG7wHtUsR2mafbYIeHOgjcSCl3AobtX+E+Vax1u9ffTEjZBz8N+s+ux
	 OYyTcb8z8ydt1ie0Gp711g6+6Rugu1+jiuu/RN6YV3KmDZSZV59stEo66XV+tp4/ut/q4
	 GAmLwHoMcNwc81uJM3YtX8SkgKz6sU5dnEt/K+h1EQES0O1eVISfaO0X+GjWImwh5uIYU
	 fHPj/V0+CH5M7kOaV/a194vt62SeJB5cLQFnBu6/Lpxb3HKB7QHdj5DNXIy6NQmpBwLqR
	 G/hv/WeLepYOLGmpOq24IKK3pS4QDHEKVJN4fHCCJafdS2oPARMlf1XVEBh1uwSh/JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jd0TEYKa+AzH/7yRaEsOOP96yBvdjI4DToycubi6TDE=;
	b=FzlaSHSLHj5c7Jx/0/Fik70JwlVSPGcC+1x+rgw/nwX3Roj8pmeQ92RjVSOrei9HMzzj
	 2FIhsBftrPF4Ih1JukXJti0873JQwj7iAPi7+BB9vJaXZ6RPT8dhcprlru6H97LzUWVUu
	 94rtKODHCWWc4EQhHetP2qst1dxG2VgwlmZi13advNJMfmT/rNkVlMjxZdxyR29MTAnii
	 Y1vcDOCd6RpwiRoDsILy+dIFgyf6VuC0q8bHUIndBr2bfXueYmxbydCfqRp6Hg/y1vXbj
	 jplKcsC/17AxpsCKEVyMgyjXV8crVqMKlg6LPVeuWVtjK05emKsajPtoMaLfDPCarHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5Ndt3UF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC0C606A31C;
	Thu, 19 Nov 2026 00:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5Ndt3UF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EA81F000C4;
	Thu, 19 Nov 2026 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049596;
	bh=Jd0TEYKa+AzH/7yRaEsOOP96yBvdjI4DToycubi6TDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5Ndt3UFfeOYcqaS9kN2GuEWbsFghSLkRu6yTd2eKppQY5GWV7h9XUHIw/w9sWhZs
	 DtovHnAqphOoTHOl6rb0zLCWdyq1qXvq6Rw7m0l7bM5V4Atu82oHUxdmi113CQviq5
	 hN0NozaSxp5uc2HWVfocnFMG+yIPfPwfu54ZzW8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2367/2857] btrfs: convert btrfs_read_merkle_tree_page() to use a folio
Date: Wed, 18 Nov 2026 15:56:41 +0100
Message-ID: <20261118150326.743404077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 06ed09351b67eb1114ae106a87a0ee3ea9adb3db ]

Remove a number of hidden calls to compound_head() by using a folio
throughout.  Also follow core kernel coding style by adding the folio to
the page cache immediately after allocation instead of doing the read
first, then adding it to the page cache.  This ordering makes subsequent
readers block waiting for the first reader instead of duplicating the
work only to throw it away when they find out they lost the race.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: fdf56b9d03d4 ("btrfs: refactor read_key_bytes() to remove the dest_folio parameter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/verity.c | 64 +++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index ee00e33c309e0..abd76905daa00 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -709,7 +709,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 						pgoff_t index,
 						unsigned long num_ra_pages)
 {
-	struct page *page;
+	struct folio *folio;
 	u64 off = (u64)index << PAGE_SHIFT;
 	loff_t merkle_pos = merkle_file_pos(inode);
 	int ret;
@@ -720,29 +720,36 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 		return ERR_PTR(-EFBIG);
 	index += merkle_pos >> PAGE_SHIFT;
 again:
-	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
-	if (page) {
-		if (PageUptodate(page))
-			return page;
+	folio = __filemap_get_folio(inode->i_mapping, index, FGP_ACCESSED, 0);
+	if (!IS_ERR(folio)) {
+		if (folio_test_uptodate(folio))
+			goto out;
 
-		lock_page(page);
-		/*
-		 * We only insert uptodate pages, so !Uptodate has to be
-		 * an error
-		 */
-		if (!PageUptodate(page)) {
-			unlock_page(page);
-			put_page(page);
+		folio_lock(folio);
+		/* If it's not uptodate after we have the lock, we got a read error. */
+		if (!folio_test_uptodate(folio)) {
+			folio_unlock(folio);
+			folio_put(folio);
 			return ERR_PTR(-EIO);
 		}
-		unlock_page(page);
-		return page;
+		folio_unlock(folio);
+		goto out;
 	}
 
-	page = __page_cache_alloc(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS));
-	if (!page)
+	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
+				    0);
+	if (!folio)
 		return ERR_PTR(-ENOMEM);
 
+	ret = filemap_add_folio(inode->i_mapping, folio, index, GFP_NOFS);
+	if (ret) {
+		folio_put(folio);
+		/* Did someone else insert a folio here? */
+		if (ret == -EEXIST)
+			goto again;
+		return ERR_PTR(ret);
+	}
+
 	/*
 	 * Merkle item keys are indexed from byte 0 in the merkle tree.
 	 * They have the form:
@@ -750,28 +757,19 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	 * [ inode objectid, BTRFS_MERKLE_ITEM_KEY, offset in bytes ]
 	 */
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
-			     page_address(page), PAGE_SIZE, page);
+			     folio_address(folio), PAGE_SIZE, &folio->page);
 	if (ret < 0) {
-		put_page(page);
+		folio_put(folio);
 		return ERR_PTR(ret);
 	}
 	if (ret < PAGE_SIZE)
-		memzero_page(page, ret, PAGE_SIZE - ret);
+		folio_zero_segment(folio, ret, PAGE_SIZE);
 
-	SetPageUptodate(page);
-	ret = add_to_page_cache_lru(page, inode->i_mapping, index, GFP_NOFS);
+	folio_mark_uptodate(folio);
+	folio_unlock(folio);
 
-	if (!ret) {
-		/* Inserted and ready for fsverity */
-		unlock_page(page);
-	} else {
-		put_page(page);
-		/* Did someone race us into inserting this page? */
-		if (ret == -EEXIST)
-			goto again;
-		page = ERR_PTR(ret);
-	}
-	return page;
+out:
+	return folio_file_page(folio, index);
 }
 
 /*
-- 
2.53.0



