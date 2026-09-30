Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA1652188D;
	Wed, 30 Sep 2026 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790180; cv=none; b=OY9xuJfMLEx5vwaUbjS684JLQzphEOOvQj47geFFVwlww1TxE83U6ESwTgnblBOwAbB1nG2PBAdGMCjcwmj9xYPIHRKCFP3kYYGdZtAOKfH+Jrl4fNKvWuxeSksmROMMXUFnRoLFmHfnlgI0LxJk0bew0pGNDiS6Spp9sd1LgdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790180; c=relaxed/simple;
	bh=P3uaYOu9HSazeCPRyiXDJm5t3eiYotToSqKjfvLGsqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVFavrUnwIHC6czdY/qYIkeD+h9Yv6LPOwIptqNDRnB+7LqY9DgEoh0gAjcPDBAFiUkLZkmdIF20OnBHihXkyA0UV61Tw2XzS6Qo9qQmGbO104GIskFSYrh9XtXdmzvJNKGZ9zwwBEybwStcmzaDFoYLsZBIIe2WnOHvNPDU9sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwNiQKM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwNiQKM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783431F000FF;
	Wed, 30 Sep 2026 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790179;
	bh=pHyTUpEv/juCZcgn+xnGODho3Os0FS7msH1oXm5tm+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwNiQKM6Wf6E8Q6gv2wpJyrbQ7hAiSvFs+p+cNrn76p6EhXq3jgavOgzhjfBG1uDT
	 lWxEhKlWOB3xYVXDRVAi+I7sRJFXaobAQiJL7a95x65OmTC5UEzjtY+rKdFq3YX1uE
	 pZ57S/l4/9Fjc3vUyD+/3Pt3gh3BZib4t3Hf3pYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 694/877] f2fs: Convert clear_node_page_dirty() to clear_node_folio_dirty()
Date: Wed, 30 Sep 2026 17:26:45 +0200
Message-ID: <20260930152429.654368603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit f16ebe0de73274fd1cf885b30cc4fe42d2a1821a ]

Both callers have a folio so pass it in, removing five calls to
compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Backport to 6.12: retain the page-based node interfaces and pass
page_folio() at the two existing cleanup call sites. Use
F2FS_M_SB(folio->mapping), since this tree has no F2FS_F_SB() helper.

Keep a folio reference in __get_node_page() and convert its existing
uptodate clearing and error reporting to use that folio. This preserves
behavior while allowing the one-line error-path change in upstream
commit 5b86eab84ac8e9289b5afc52ef88ab18ba5bacab to cherry-pick cleanly.
No new functions or wider node-interface conversions are needed.

Stable-dep-of: 5b86eab84ac8 ("f2fs: fix to clear dirty flag on folio in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -125,14 +125,14 @@ bool f2fs_available_free_memory(struct f
 	return res;
 }
 
-static void clear_node_page_dirty(struct page *page)
+static void clear_node_folio_dirty(struct folio *folio)
 {
-	if (PageDirty(page)) {
-		f2fs_clear_page_cache_dirty_tag(page_folio(page));
-		clear_page_dirty_for_io(page);
-		dec_page_count(F2FS_P_SB(page), F2FS_DIRTY_NODES);
+	if (folio_test_dirty(folio)) {
+		f2fs_clear_page_cache_dirty_tag(folio);
+		folio_clear_dirty_for_io(folio);
+		dec_page_count(F2FS_M_SB(folio->mapping), F2FS_DIRTY_NODES);
 	}
-	ClearPageUptodate(page);
+	folio_clear_uptodate(folio);
 }
 
 static struct page *get_current_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
@@ -941,7 +941,7 @@ static int truncate_node(struct dnode_of
 		f2fs_inode_synced(dn->inode);
 	}
 
-	clear_node_page_dirty(dn->node_page);
+	clear_node_folio_dirty(page_folio(dn->node_page));
 	set_sbi_flag(sbi, SBI_IS_DIRTY);
 
 	index = page_folio(dn->node_page)->index;
@@ -1394,7 +1394,7 @@ struct page *f2fs_new_node_page(struct d
 		inc_valid_inode_count(sbi);
 	return page;
 fail:
-	clear_node_page_dirty(page);
+	clear_node_folio_dirty(page_folio(page));
 	f2fs_put_page(page, 1);
 	return ERR_PTR(err);
 }
@@ -1476,6 +1476,7 @@ static struct page *__get_node_page(stru
 					struct page *parent, int start)
 {
 	struct page *page;
+	struct folio *folio;
 	int err;
 
 	if (!nid)
@@ -1487,6 +1488,7 @@ repeat:
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
+	folio = page_folio(page);
 	err = read_node_page(page, 0);
 	if (err < 0) {
 		goto out_put_err;
@@ -1526,11 +1528,11 @@ page_hit:
 	f2fs_handle_error(sbi, ERROR_INCONSISTENT_FOOTER);
 	err = -EFSCORRUPTED;
 out_err:
-	ClearPageUptodate(page);
+	folio_clear_uptodate(folio);
 out_put_err:
 	/* ENOENT comes from read_node_page which is not an error. */
 	if (err != -ENOENT)
-		f2fs_handle_page_eio(sbi, page_folio(page), NODE);
+		f2fs_handle_page_eio(sbi, folio, NODE);
 	f2fs_put_page(page, 1);
 	return ERR_PTR(err);
 }


