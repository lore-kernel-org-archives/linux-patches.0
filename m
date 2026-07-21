Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609B2470426;
	Tue, 21 Jul 2026 19:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663879; cv=none; b=BSykd9ego46yXJVZwU0l5KCg11B9M/r+45fo+nZdloApSpwQ/p6lvZNwArUISLJ915Djw5mX3UrtdhGK5NzTZJy/uXfI8gWxgYIKZTUfyMrUVhG3dQf7cI5JRw5PLftmauDmE237347BRsPuXS+EBMQyGcRCFrkfl9t3VqJXg6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663879; c=relaxed/simple;
	bh=iSHq0d0UUvYdBpwTXwEaK3BY7XkWCAdBHsRSjnh5Ju8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hg0g6oyYzzjnmJQnQwyyZupKGU7WD1Nbalw0w6wjGSBG8PRxQvdBdV+7ZDQZIdfH2sGDRgJxpgFSEErh8pZ3DB/Vv1J0yTHm+YFanKuUwA931KSOzWpFlIvWpit7OHIF8KkIFsrhBnb3ij/vtxPszbBHN6p6EAjbW1DDWMRzrTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySNyCIGN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySNyCIGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0918D1F00A3A;
	Tue, 21 Jul 2026 19:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663874;
	bh=fq5xDzJNGmvU0L0WtFVV5cFYkQUsdbfbjwXVItJI1lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySNyCIGNtsTqI7pn8LSNVF7+s0bvktCu1/+SoSJo7cqBivvdaxso6aYdgPF0A2G5m
	 MFHf0XjBXaKRwTwFmz7tgceCLeYmbDE8BJoDpckO2tZBXiOuNcO4dzDW0U0aGuajLu
	 9AQQ7GuQvXn5Oimq/9vAsg82Nn1kJUPzVlfweTGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Claude Sonnet 5 <noreply@anthropic.com>
Subject: [PATCH 6.12 0988/1276] NFS: Charge unstable writes by request size, not folio size
Date: Tue, 21 Jul 2026 17:23:51 +0200
Message-ID: <20260721152508.124889837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -839,17 +839,19 @@ void nfs_super_set_maxbytes(struct super
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
@@ -1179,7 +1179,7 @@ pnfs_layout_mark_request_commit(struct n
 
 	nfs_request_add_commit_list_locked(req, list, cinfo);
 	mutex_unlock(&NFS_I(cinfo->inode)->commit_mutex);
-	nfs_folio_mark_unstable(nfs_page_to_folio(req), cinfo);
+	nfs_folio_mark_unstable(req, cinfo);
 	return;
 out_resched:
 	mutex_unlock(&NFS_I(cinfo->inode)->commit_mutex);
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -858,7 +858,7 @@ nfs_request_add_commit_list(struct nfs_p
 	mutex_lock(&NFS_I(cinfo->inode)->commit_mutex);
 	nfs_request_add_commit_list_locked(req, &cinfo->mds->list, cinfo);
 	mutex_unlock(&NFS_I(cinfo->inode)->commit_mutex);
-	nfs_folio_mark_unstable(nfs_page_to_folio(req), cinfo);
+	nfs_folio_mark_unstable(req, cinfo);
 }
 EXPORT_SYMBOL_GPL(nfs_request_add_commit_list);
 
@@ -917,10 +917,12 @@ nfs_mark_request_commit(struct nfs_page
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
 		wb_stat_mod(&inode_to_bdi(folio->mapping->host)->wb,
@@ -941,7 +943,7 @@ static void nfs_clear_request_commit(str
 			nfs_request_remove_commit_list(req, cinfo);
 		}
 		mutex_unlock(&NFS_I(inode)->commit_mutex);
-		nfs_folio_clear_commit(nfs_page_to_folio(req));
+		nfs_folio_clear_commit(req);
 	}
 }
 
@@ -1777,7 +1779,7 @@ void nfs_retry_commit(struct list_head *
 		req = nfs_list_entry(page_list->next);
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req, lseg, cinfo, ds_commit_idx);
-		nfs_folio_clear_commit(nfs_page_to_folio(req));
+		nfs_folio_clear_commit(req);
 		nfs_unlock_and_release_request(req);
 	}
 }
@@ -1848,7 +1850,7 @@ static void nfs_commit_release_pages(str
 		req = nfs_list_entry(data->pages.next);
 		nfs_list_remove_request(req);
 		folio = nfs_page_to_folio(req);
-		nfs_folio_clear_commit(folio);
+		nfs_folio_clear_commit(req);
 
 		dprintk("NFS:       commit (%s/%llu %d@%lld)",
 			nfs_req_openctx(req)->dentry->d_sb->s_id,


