Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B238B1E520A;
	Sat, 17 Oct 2026 16:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253950; cv=none; b=tmyE5OuhUrUlztMHygNflcxXijAh2lSmuRGdYNr9blmGbR3pxsqt8AlpEbHbX9m8+kpxd0HxU/UDDr1CQJsJ2N+p5ZpX2go1BNY0TpRfQWpeEBIiJ+WY/qDMfmwnEFy7Ly2mKJ3kKqK5WUsSRsOTpdwVL887+5hegyXtJfgfncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253950; c=relaxed/simple;
	bh=sy5e6WY+D3Iv1Zr8XCPcQl4bjDtXhuF0CHXpR2pxiwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFl1aKmWfgwDKWRGka6yiA7H5+xv0V/0Dz4zot8V2B+33AZlSobvEIqisAp7farIYFkrFbhG3e/BhQrQ9aMSWfZCiBJ08M8bjqqYRY/A9od4YhJz1YnZYZDb6zyhqxbLLKHqgwoa2hpJndCgsNfAWW72/xxEmOGyuQXORKYtNJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZV4sASM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZV4sASM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A041F000C4;
	Sat, 17 Oct 2026 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253948;
	bh=3mokuArO3rNb6KBF5vJ13qSHhPuHN3iInh08QfjiQTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZV4sASM8ebu4iGBlpstIsABwszlNe40+aVIuH0C2H5Yf6Zf2RnTUmsKVtUHWgllT
	 G8f4r6sF8I1pazCBVlr/ZRC0u57S5wI3wrUJusQHd6jPqoZkc8+qqAwgDp4mh3W2BI
	 vj5A6xwA13QPGBXfOy2/fCO4AxRNYiFjudXe+HJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/869] ceph: Remove uses of page from ceph_process_folio_batch()
Date: Sat, 17 Oct 2026 17:52:05 +0200
Message-ID: <20261017160044.355719224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit a55cf4fd8faea83dbb1ac7a3cb708193e33aa7a1 ]

Remove uses of page->index and deprecated page APIs.  Saves a lot of
hidden calls to compound_head().

Also convert is_page_index_contiguous() to is_folio_index_contiguous()
and make its arguments const.

Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20250217185119.430193-8-willy@infradead.org
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: a0d9555bf9ea ("ceph: fix num_ops off-by-one when crypto allocation fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 36aa5cf8300af..4ba991efb1ca3 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1220,10 +1220,10 @@ void ceph_allocate_page_array(struct address_space *mapping,
 }
 
 static inline
-bool is_page_index_contiguous(struct ceph_writeback_ctl *ceph_wbc,
-			      struct page *page)
+bool is_folio_index_contiguous(const struct ceph_writeback_ctl *ceph_wbc,
+			      const struct folio *folio)
 {
-	return page->index == (ceph_wbc->offset + ceph_wbc->len) >> PAGE_SHIFT;
+	return folio->index == (ceph_wbc->offset + ceph_wbc->len) >> PAGE_SHIFT;
 }
 
 static inline
@@ -1288,7 +1288,6 @@ int ceph_process_folio_batch(struct address_space *mapping,
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
 	struct ceph_client *cl = fsc->client;
 	struct folio *folio = NULL;
-	struct page *page = NULL;
 	unsigned i;
 	int rc = 0;
 
@@ -1298,11 +1297,9 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		if (!folio)
 			continue;
 
-		page = &folio->page;
-
 		doutc(cl, "? %p idx %lu, folio_test_writeback %#x, "
 			"folio_test_dirty %#x, folio_test_locked %#x\n",
-			page, page->index, folio_test_writeback(folio),
+			folio, folio->index, folio_test_writeback(folio),
 			folio_test_dirty(folio),
 			folio_test_locked(folio));
 
@@ -1315,27 +1312,27 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		}
 
 		if (ceph_wbc->locked_pages == 0)
-			lock_page(page);  /* first page */
-		else if (!trylock_page(page))
+			folio_lock(folio);
+		else if (!folio_trylock(folio))
 			break;
 
 		rc = ceph_check_page_before_write(mapping, wbc,
 						  ceph_wbc, folio);
 		if (rc == -ENODATA) {
 			rc = 0;
-			unlock_page(page);
+			folio_unlock(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
 		} else if (rc == -E2BIG) {
 			rc = 0;
-			unlock_page(page);
+			folio_unlock(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			break;
 		}
 
-		if (!clear_page_dirty_for_io(page)) {
-			doutc(cl, "%p !clear_page_dirty_for_io\n", page);
-			unlock_page(page);
+		if (!folio_clear_dirty_for_io(folio)) {
+			doutc(cl, "%p !folio_clear_dirty_for_io\n", folio);
+			folio_unlock(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
 		}
@@ -1347,35 +1344,35 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		 * allocate a page array
 		 */
 		if (ceph_wbc->locked_pages == 0) {
-			ceph_allocate_page_array(mapping, ceph_wbc, page);
-		} else if (!is_page_index_contiguous(ceph_wbc, page)) {
+			ceph_allocate_page_array(mapping, ceph_wbc, &folio->page);
+		} else if (!is_folio_index_contiguous(ceph_wbc, folio)) {
 			if (is_num_ops_too_big(ceph_wbc)) {
-				redirty_page_for_writepage(wbc, page);
-				unlock_page(page);
+				folio_redirty_for_writepage(wbc, folio);
+				folio_unlock(folio);
 				break;
 			}
 
 			ceph_wbc->num_ops++;
-			ceph_wbc->offset = (u64)page_offset(page);
+			ceph_wbc->offset = (u64)folio_pos(folio);
 			ceph_wbc->len = 0;
 		}
 
 		/* note position of first page in fbatch */
-		doutc(cl, "%llx.%llx will write page %p idx %lu\n",
-		      ceph_vinop(inode), page, page->index);
+		doutc(cl, "%llx.%llx will write folio %p idx %lu\n",
+		      ceph_vinop(inode), folio, folio->index);
 
 		fsc->write_congested = is_write_congestion_happened(fsc);
 
 		rc = ceph_move_dirty_page_in_page_array(mapping, wbc,
-							ceph_wbc, page);
+							ceph_wbc, &folio->page);
 		if (rc) {
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
+			folio_redirty_for_writepage(wbc, folio);
+			folio_unlock(folio);
 			break;
 		}
 
 		ceph_wbc->fbatch.folios[i] = NULL;
-		ceph_wbc->len += thp_size(page);
+		ceph_wbc->len += folio_size(folio);
 	}
 
 	ceph_wbc->processed_in_fbatch = i;
-- 
2.53.0



