Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965793F825C;
	Tue, 21 Jul 2026 17:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654718; cv=none; b=bkRZzrnGCvFEWyKERHLiyeLNCJXa9ICrXiAe4FTIhg/jbuZjFkcyAUpcjtvWDuNl4/SFwJAuZXL/ddhy5uHUUjnRiE4cf6d8aQbkQCVCPXG3MUXNLRHj2uFDrlrSn/ERXYHF/aYYje56VEvdMSAZoMOp0WE2KPWvl4fx4grRioo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654718; c=relaxed/simple;
	bh=Yv62bP5i5F3BJ88ap7rykinmGK+87YnEgizrLrHywxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la/ToATEbEfUA0KBnZsp8XGklgB6SbnkGZqXZGkrtYIIRu280j/6G2Z3fQb6zMtoIzitDV/RussWPGkKk8VrprP35/HBwz/TBnnAxts5nZxP5d9lZbXl0vhiPe/MI4wJudt0LCybERKIny9q+ELEZafjpfHzDM/5GKT20/icjRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkREeL8X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkREeL8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0159A1F000E9;
	Tue, 21 Jul 2026 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654717;
	bh=H2PVxswkFEWIy4IFpNO+OM2N3Z//RJJec0AW/6eieDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkREeL8XyhqSdKPPVFcOKiQTNEfrw9i6ciXcI+expWc8iMnvgkKPDSDX/cumZLf/V
	 5Z2sLSVjijydRr2BXNhupdERrESA1+wSnnpInwW6df9hgwQxOhUjjn2Wy6+nb6FzXv
	 59ql3SH3FSh2Erz3+i+sktXfDOTQOgje1T6fvLeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Claude Sonnet 5 <noreply@anthropic.com>
Subject: [PATCH 7.1 1812/2077] NFS: Charge unstable writes by request size, not folio size
Date: Tue, 21 Jul 2026 17:24:45 +0200
Message-ID: <20260721152635.483219222@linuxfoundation.org>
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

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 27934d02cbeb8a957dd11c985a579e58d30c5270 upstream.

nfs_folio_mark_unstable() and nfs_folio_clear_commit() charge and
uncharge NR_WRITEBACK/WB_WRITEBACK by folio_nr_pages(folio) once per
*request* added to or removed from a commit list. This is correct only
when a folio has a single associated request. When pg_test splits a
folio into N sub-folio requests (e.g. pNFS flexfiles striping with a
stripe unit smaller than the folio size, or plain wsize-limited
splitting), each of the N requests independently charges the whole
folio's page count, inflating the accounting by a factor of N per
folio. With large folios and small stripe units this reaches multiple
orders of magnitude: a 2 MiB folio split into 512 4 KiB requests can
charge up to 512x its real size, pushing global dirty+writeback
accounting past the system's dirty threshold and forcing every
buffered writer on the host into the hard-throttle path, including
unrelated in-kernel NFS server threads sharing the box.

Charge each request only for the pages it actually covers.

Fixes: 0c493b5cf16e ("NFS: Convert buffered writes to use folios")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Assisted-By: Claude Sonnet 5 <noreply@anthropic.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h |   12 +++++++-----
 fs/nfs/pnfs_nfs.c |    2 +-
 fs/nfs/write.c    |   14 ++++++++------
 3 files changed, 16 insertions(+), 12 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -847,17 +847,19 @@ void nfs_super_set_maxbytes(struct super
 }
 
 /*
- * Record the page as unstable (an extra writeback period) and mark its
- * inode as dirty.
+ * Record the request's range as unstable (an extra writeback period) and
+ * mark its inode as dirty.
  */
-static inline void nfs_folio_mark_unstable(struct folio *folio,
+static inline void nfs_folio_mark_unstable(struct nfs_page *req,
 					   struct nfs_commit_info *cinfo)
 {
+	struct folio *folio = nfs_page_to_folio(req);
+
 	if (folio && !cinfo->dreq) {
 		struct inode *inode = folio->mapping->host;
-		long nr = folio_nr_pages(folio);
+		long nr = DIV_ROUND_UP(req->wb_bytes, PAGE_SIZE);
 
-		/* This page is really still in write-back - just that the
+		/* This range is really still in write-back - just that the
 		 * writeback is happening on the server now.
 		 */
 		node_stat_mod_folio(folio, NR_WRITEBACK, nr);
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -1199,7 +1199,7 @@ pnfs_layout_mark_request_commit(struct n
 
 	nfs_request_add_commit_list_locked(req, list, cinfo);
 	mutex_unlock(&NFS_I(cinfo->inode)->commit_mutex);
-	nfs_folio_mark_unstable(nfs_page_to_folio(req), cinfo);
+	nfs_folio_mark_unstable(req, cinfo);
 	return;
 out_resched:
 	mutex_unlock(&NFS_I(cinfo->inode)->commit_mutex);
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -807,7 +807,7 @@ nfs_request_add_commit_list(struct nfs_p
 	mutex_lock(&NFS_I(cinfo->inode)->commit_mutex);
 	nfs_request_add_commit_list_locked(req, &cinfo->mds->list, cinfo);
 	mutex_unlock(&NFS_I(cinfo->inode)->commit_mutex);
-	nfs_folio_mark_unstable(nfs_page_to_folio(req), cinfo);
+	nfs_folio_mark_unstable(req, cinfo);
 }
 EXPORT_SYMBOL_GPL(nfs_request_add_commit_list);
 
@@ -866,10 +866,12 @@ nfs_mark_request_commit(struct nfs_page
 	nfs_request_add_commit_list(req, cinfo);
 }
 
-static void nfs_folio_clear_commit(struct folio *folio)
+static void nfs_folio_clear_commit(struct nfs_page *req)
 {
+	struct folio *folio = nfs_page_to_folio(req);
+
 	if (folio) {
-		long nr = folio_nr_pages(folio);
+		long nr = DIV_ROUND_UP(req->wb_bytes, PAGE_SIZE);
 
 		node_stat_mod_folio(folio, NR_WRITEBACK, -nr);
 		bdi_wb_stat_mod(folio->mapping->host, WB_WRITEBACK, -nr);
@@ -889,7 +891,7 @@ static void nfs_clear_request_commit(str
 			nfs_request_remove_commit_list(req, cinfo);
 		}
 		mutex_unlock(&NFS_I(inode)->commit_mutex);
-		nfs_folio_clear_commit(nfs_page_to_folio(req));
+		nfs_folio_clear_commit(req);
 	}
 }
 
@@ -1741,7 +1743,7 @@ void nfs_retry_commit(struct list_head *
 		req = nfs_list_entry(page_list->next);
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req, lseg, cinfo, ds_commit_idx);
-		nfs_folio_clear_commit(nfs_page_to_folio(req));
+		nfs_folio_clear_commit(req);
 		nfs_unlock_and_release_request(req);
 	}
 }
@@ -1813,7 +1815,7 @@ static void nfs_commit_release_pages(str
 		req = nfs_list_entry(data->pages.next);
 		nfs_list_remove_request(req);
 		folio = nfs_page_to_folio(req);
-		nfs_folio_clear_commit(folio);
+		nfs_folio_clear_commit(req);
 
 		dprintk("NFS:       commit (%s/%llu %d@%lld)",
 			nfs_req_openctx(req)->dentry->d_sb->s_id,


