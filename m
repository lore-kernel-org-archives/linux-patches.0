Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAF745FFAD;
	Thu, 20 Aug 2026 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246991; cv=none; b=aoFhGpCwO26aRVXGOWebx9PaaCIjrc0wpipiIBo4kfYytzKRX6q0SF6U16o+hYWJk4eU6X56qj3R3QFGzVZwsvGCOBPUX++8A9Na215+8yB6mI+XMXQQc5Hx/wU/C3HZCktqsfqnXRQ5AJe2w2hdtDjQ8D5INOS6SR+qQvqGwLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246991; c=relaxed/simple;
	bh=knF9e74/omhms02Ba29L0nOj+dtVVZaZBIAOqHnSctY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCjBYwaC9nUGuH7S+xLDWNuOXjEeSdWhfsCf6GKRXPyVI8wYfoSWA22beXgMusEsbPICzENoq+rLWpP920DFSAouGzokNemUn7FXw+MgDxnevJkhF2PvZ3pWy5qVuufTodBiKLGm2GSOgas/07bMoc4e/koCiBZX95jMBKR/LOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGRh3O2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGRh3O2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D601F000E9;
	Thu, 20 Aug 2026 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246990;
	bh=XcUmB0vaRJ9F2QfDNgZIkitHaFTO0Gg03Dui4qhdNHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGRh3O2WnpirltTR733A7UlJOQifVNWFszTJG0ldNJTe4hwmpeD2kjG348LchfGxC
	 wic1C7MbHp7g28GZqvJeHZD+KqboqU8jf4+UqNsWVHCPKheExpQX4Tn5IWVu7XRu2d
	 crRkptElzrUq89JQ/P8UtggJ68WnCxAFMD8eZ/U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/220] ceph: Use a folio in ceph_page_mkwrite()
Date: Thu, 20 Aug 2026 16:55:02 +0200
Message-ID: <20260820145226.840135405@linuxfoundation.org>
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

[ Upstream commit 88a59bda3f3786107694a3f5fd7f9df421752c21 ]

Convert the passed page to a folio and use it
throughout ceph_page_mkwrite().  Removes the last call to
page_mkwrite_check_truncate(), the last call to offset_in_thp() and one
of the last calls to thp_size().  Saves a few calls to compound_head().

Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20250217185119.430193-3-willy@infradead.org
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: cbf59617cd71 ("ceph: fix writeback_count leak in write_folio_nounlock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1696,8 +1696,8 @@ static vm_fault_t ceph_page_mkwrite(stru
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_info *fi = vma->vm_file->private_data;
 	struct ceph_cap_flush *prealloc_cf;
-	struct page *page = vmf->page;
-	loff_t off = page_offset(page);
+	struct folio *folio = page_folio(vmf->page);
+	loff_t off = folio_pos(folio);
 	loff_t size = i_size_read(inode);
 	size_t len;
 	int want, got, err;
@@ -1714,10 +1714,10 @@ static vm_fault_t ceph_page_mkwrite(stru
 	sb_start_pagefault(inode->i_sb);
 	ceph_block_sigs(&oldset);
 
-	if (off + thp_size(page) <= size)
-		len = thp_size(page);
+	if (off + folio_size(folio) <= size)
+		len = folio_size(folio);
 	else
-		len = offset_in_thp(page, size);
+		len = offset_in_folio(folio, size);
 
 	doutc(cl, "%llx.%llx %llu~%zd getting caps i_size %llu\n",
 	      ceph_vinop(inode), off, len, size);
@@ -1734,30 +1734,30 @@ static vm_fault_t ceph_page_mkwrite(stru
 	doutc(cl, "%llx.%llx %llu~%zd got cap refs on %s\n", ceph_vinop(inode),
 	      off, len, ceph_cap_string(got));
 
-	/* Update time before taking page lock */
+	/* Update time before taking folio lock */
 	file_update_time(vma->vm_file);
 	inode_inc_iversion_raw(inode);
 
 	do {
 		struct ceph_snap_context *snapc;
 
-		lock_page(page);
+		folio_lock(folio);
 
-		if (page_mkwrite_check_truncate(page, inode) < 0) {
-			unlock_page(page);
+		if (folio_mkwrite_check_truncate(folio, inode) < 0) {
+			folio_unlock(folio);
 			ret = VM_FAULT_NOPAGE;
 			break;
 		}
 
-		snapc = ceph_find_incompatible(page);
+		snapc = ceph_find_incompatible(&folio->page);
 		if (!snapc) {
-			/* success.  we'll keep the page locked. */
-			set_page_dirty(page);
+			/* success.  we'll keep the folio locked. */
+			folio_mark_dirty(folio);
 			ret = VM_FAULT_LOCKED;
 			break;
 		}
 
-		unlock_page(page);
+		folio_unlock(folio);
 
 		if (IS_ERR(snapc)) {
 			ret = VM_FAULT_SIGBUS;


