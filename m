Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E473747F774;
	Thu, 20 Aug 2026 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246994; cv=none; b=AqGIo2aY8cQF8LhpCQXHsfBNMfg6JuFZi0ro5lPuB+WJTvr8FvjeKA58cp7IoI2zbWxS6y7gCMR6hTOW0xLdYWiOODfBdF3vgyE3AgGqjrgnOGeOlgJcfSikRoxkKMoX8q+OO/ieuP2YfXSXtXCB+5vEzSPddZxR24EkizW2wVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246994; c=relaxed/simple;
	bh=TAVKgA4JpeY/kgUlJ2p1GK9XmyBeLnRZKuDMm8p8EOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZaZYUF+GpLN3+bR+SgALgd79Wu4+UTKt1/SlzUCvh0ftWMG5NPFXOAQyHAAmLJNtRWLpA3+WIpo5OlXY4sxNZ+cuzh3ZHP3Mm6P3Wsz/EEwJnMmzlQi9DD+9ztgnMcx6Sk6zrtScpSD37z2Z1JlHbeXwYVmQ/C1NK5ND57pf5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBp5cT5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBp5cT5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F4D1F000E9;
	Thu, 20 Aug 2026 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246992;
	bh=pqKUd4+0U56s+HhjUKSlwRbkB4+SvO3VZbIbbmUHCQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBp5cT5uEQUNoU9OyLmzFMFWu4N4t22u0/SGTJu/5Rj6doVRbnO7C4mlQnanvN4Fj
	 60fGakN7FLpXyV6F1PM/MIRxpUjY4A0u5nIzsN7viKt0oWpaSsq/x/hvawF+LO4kIQ
	 eCghXiGiYdWWlwkyzHiUFRA+TW90okU4HDNiWRpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/220] ceph: Convert ceph_find_incompatible() to take a folio
Date: Thu, 20 Aug 2026 16:55:03 +0200
Message-ID: <20260820145226.872162883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

[ Upstream commit f9707a8b5b9d0a631e0a64eab5c3d2bb6d43758c ]

Both callers already have the folio.  Pass it in and use it throughout.
Removes some hidden calls to compound_head() and a reference to
page->mapping.

Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20250217185119.430193-4-willy@infradead.org
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: cbf59617cd71 ("ceph: fix writeback_count leak in write_folio_nounlock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1425,56 +1425,56 @@ static int context_is_writeable_or_writt
 
 /**
  * ceph_find_incompatible - find an incompatible context and return it
- * @page: page being dirtied
+ * @folio: folio being dirtied
  *
- * We are only allowed to write into/dirty a page if the page is
+ * We are only allowed to write into/dirty a folio if the folio is
  * clean, or already dirty within the same snap context. Returns a
  * conflicting context if there is one, NULL if there isn't, or a
  * negative error code on other errors.
  *
- * Must be called with page lock held.
+ * Must be called with folio lock held.
  */
 static struct ceph_snap_context *
-ceph_find_incompatible(struct page *page)
+ceph_find_incompatible(struct folio *folio)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
 	if (ceph_inode_is_shutdown(inode)) {
-		doutc(cl, " %llx.%llx page %p is shutdown\n",
-		      ceph_vinop(inode), page);
+		doutc(cl, " %llx.%llx folio %p is shutdown\n",
+		      ceph_vinop(inode), folio);
 		return ERR_PTR(-ESTALE);
 	}
 
 	for (;;) {
 		struct ceph_snap_context *snapc, *oldest;
 
-		wait_on_page_writeback(page);
+		folio_wait_writeback(folio);
 
-		snapc = page_snap_context(page);
+		snapc = page_snap_context(&folio->page);
 		if (!snapc || snapc == ci->i_head_snapc)
 			break;
 
 		/*
-		 * this page is already dirty in another (older) snap
+		 * this folio is already dirty in another (older) snap
 		 * context!  is it writeable now?
 		 */
 		oldest = get_oldest_context(inode, NULL, NULL);
 		if (snapc->seq > oldest->seq) {
 			/* not writeable -- return it for the caller to deal with */
 			ceph_put_snap_context(oldest);
-			doutc(cl, " %llx.%llx page %p snapc %p not current or oldest\n",
-			      ceph_vinop(inode), page, snapc);
+			doutc(cl, " %llx.%llx folio %p snapc %p not current or oldest\n",
+			      ceph_vinop(inode), folio, snapc);
 			return ceph_get_snap_context(snapc);
 		}
 		ceph_put_snap_context(oldest);
 
-		/* yay, writeable, do it now (without dropping page lock) */
-		doutc(cl, " %llx.%llx page %p snapc %p not current, but oldest\n",
-		      ceph_vinop(inode), page, snapc);
-		if (clear_page_dirty_for_io(page)) {
-			int r = writepage_nounlock(page, NULL);
+		/* yay, writeable, do it now (without dropping folio lock) */
+		doutc(cl, " %llx.%llx folio %p snapc %p not current, but oldest\n",
+		      ceph_vinop(inode), folio, snapc);
+		if (folio_clear_dirty_for_io(folio)) {
+			int r = writepage_nounlock(&folio->page, NULL);
 			if (r < 0)
 				return ERR_PTR(r);
 		}
@@ -1489,7 +1489,7 @@ static int ceph_netfs_check_write_begin(
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_snap_context *snapc;
 
-	snapc = ceph_find_incompatible(folio_page(*foliop, 0));
+	snapc = ceph_find_incompatible(*foliop);
 	if (snapc) {
 		int r;
 
@@ -1749,7 +1749,7 @@ static vm_fault_t ceph_page_mkwrite(stru
 			break;
 		}
 
-		snapc = ceph_find_incompatible(&folio->page);
+		snapc = ceph_find_incompatible(folio);
 		if (!snapc) {
 			/* success.  we'll keep the folio locked. */
 			folio_mark_dirty(folio);


