Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9286B31E10D;
	Tue,  2 Sep 2025 13:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820152; cv=none; b=EESXVXuzIciZBP+DnvJZT1hiqtftVjmfjETiUEou6gEAko+CxL2VLDFjd4CqOAiXgnb68B3gLGLwpg5IiGZoRAu8gYkJRrCqcWlAJ984v0Km2CPJDqcBdqxT3jZ8tE3DnkZx4dXZHFKE0v/97VpbzqA8RdwYnclyx71tigXOnvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820152; c=relaxed/simple;
	bh=BK3kDA9/LDb/4tAVjRmbLOyDCvTJB8MLjb6VHWyMeWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0suYmdDUHa2Fc+BdMzw895Ar85VE+J5lYkBNCwzUjfdm4DcMIeLr3Ssv5p60q9vmzru6jQp22XyeOZ7PVrO3wVdUT2SgVwCq9d26R8OacjGgvgEIJkJKh0muQuiR7+Fsd6PnLOFA9pLUzqD0GGnmy4/3yxktKR3ZD+iXKFcGkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+RFrcg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+RFrcg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5B7C4CEED;
	Tue,  2 Sep 2025 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820152;
	bh=BK3kDA9/LDb/4tAVjRmbLOyDCvTJB8MLjb6VHWyMeWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+RFrcg1Kb+TwcK3ys2IHtgCT/g8oZoeHvKI1pgvjVYJv52lXpDGphagjnfAQDqqg
	 C5cJ8qb8hVB5/iACoNHfDl5cVyMFFWGVUQ/Eb0i7WhhsVigtJyeGIQdNDyFAnKk2vg
	 KogF7PWAL+6IW0lfSeuHmirm6a7vs/cNez4mEEpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Joe Quanaim <jdq@meta.com>,
	Andrew Steffen <aksteffen@meta.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.6 15/75] NFS: Fix a race when updating an existing write
Date: Tue,  2 Sep 2025 15:20:27 +0200
Message-ID: <20250902131935.712990590@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 76d2e3890fb169168c73f2e4f8375c7cc24a765e upstream.

After nfs_lock_and_join_requests() tests for whether the request is
still attached to the mapping, nothing prevents a call to
nfs_inode_remove_request() from succeeding until we actually lock the
page group.
The reason is that whoever called nfs_inode_remove_request() doesn't
necessarily have a lock on the page group head.

So in order to avoid races, let's take the page group lock earlier in
nfs_lock_and_join_requests(), and hold it across the removal of the
request in nfs_inode_remove_request().

Reported-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Joe Quanaim <jdq@meta.com>
Tested-by: Andrew Steffen <aksteffen@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Fixes: bd37d6fce184 ("NFSv4: Convert nfs_lock_and_join_requests() to use nfs_page_find_head_request()")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pagelist.c        |    9 +++--
 fs/nfs/write.c           |   71 ++++++++++++++++-------------------------------
 include/linux/nfs_page.h |    1 
 3 files changed, 31 insertions(+), 50 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -272,13 +272,14 @@ nfs_page_group_unlock(struct nfs_page *r
 	nfs_page_clear_headlock(req);
 }
 
-/*
- * nfs_page_group_sync_on_bit_locked
+/**
+ * nfs_page_group_sync_on_bit_locked - Test if all requests have @bit set
+ * @req: request in page group
+ * @bit: PG_* bit that is used to sync page group
  *
  * must be called with page group lock held
  */
-static bool
-nfs_page_group_sync_on_bit_locked(struct nfs_page *req, unsigned int bit)
+bool nfs_page_group_sync_on_bit_locked(struct nfs_page *req, unsigned int bit)
 {
 	struct nfs_page *head = req->wb_head;
 	struct nfs_page *tmp;
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -156,20 +156,10 @@ nfs_page_set_inode_ref(struct nfs_page *
 	}
 }
 
-static int
-nfs_cancel_remove_inode(struct nfs_page *req, struct inode *inode)
+static void nfs_cancel_remove_inode(struct nfs_page *req, struct inode *inode)
 {
-	int ret;
-
-	if (!test_bit(PG_REMOVE, &req->wb_flags))
-		return 0;
-	ret = nfs_page_group_lock(req);
-	if (ret)
-		return ret;
 	if (test_and_clear_bit(PG_REMOVE, &req->wb_flags))
 		nfs_page_set_inode_ref(req, inode);
-	nfs_page_group_unlock(req);
-	return 0;
 }
 
 static struct nfs_page *nfs_folio_private_request(struct folio *folio)
@@ -238,36 +228,6 @@ static struct nfs_page *nfs_folio_find_h
 	return req;
 }
 
-static struct nfs_page *nfs_folio_find_and_lock_request(struct folio *folio)
-{
-	struct inode *inode = folio_file_mapping(folio)->host;
-	struct nfs_page *req, *head;
-	int ret;
-
-	for (;;) {
-		req = nfs_folio_find_head_request(folio);
-		if (!req)
-			return req;
-		head = nfs_page_group_lock_head(req);
-		if (head != req)
-			nfs_release_request(req);
-		if (IS_ERR(head))
-			return head;
-		ret = nfs_cancel_remove_inode(head, inode);
-		if (ret < 0) {
-			nfs_unlock_and_release_request(head);
-			return ERR_PTR(ret);
-		}
-		/* Ensure that nobody removed the request before we locked it */
-		if (head == nfs_folio_private_request(folio))
-			break;
-		if (folio_test_swapcache(folio))
-			break;
-		nfs_unlock_and_release_request(head);
-	}
-	return head;
-}
-
 /* Adjust the file length if we're writing beyond the end */
 static void nfs_grow_file(struct folio *folio, unsigned int offset,
 			  unsigned int count)
@@ -621,20 +581,37 @@ static struct nfs_page *nfs_lock_and_joi
 	struct nfs_commit_info cinfo;
 	int ret;
 
-	nfs_init_cinfo_from_inode(&cinfo, inode);
 	/*
 	 * A reference is taken only on the head request which acts as a
 	 * reference to the whole page group - the group will not be destroyed
 	 * until the head reference is released.
 	 */
-	head = nfs_folio_find_and_lock_request(folio);
-	if (IS_ERR_OR_NULL(head))
-		return head;
+retry:
+	head = nfs_folio_find_head_request(folio);
+	if (!head)
+		return NULL;
+
+	while (!nfs_lock_request(head)) {
+		ret = nfs_wait_on_request(head);
+		if (ret < 0) {
+			nfs_release_request(head);
+			return ERR_PTR(ret);
+		}
+	}
 
 	ret = nfs_page_group_lock(head);
 	if (ret < 0)
 		goto out_unlock;
 
+	/* Ensure that nobody removed the request before we locked it */
+	if (head != folio->private && !folio_test_swapcache(folio)) {
+		nfs_page_group_unlock(head);
+		nfs_unlock_and_release_request(head);
+		goto retry;
+	}
+
+	nfs_cancel_remove_inode(head, inode);
+
 	/* lock each request in the page group */
 	for (subreq = head->wb_this_page;
 	     subreq != head;
@@ -855,7 +832,8 @@ static void nfs_inode_remove_request(str
 {
 	struct nfs_inode *nfsi = NFS_I(nfs_page_to_inode(req));
 
-	if (nfs_page_group_sync_on_bit(req, PG_REMOVE)) {
+	nfs_page_group_lock(req);
+	if (nfs_page_group_sync_on_bit_locked(req, PG_REMOVE)) {
 		struct folio *folio = nfs_page_to_folio(req->wb_head);
 		struct address_space *mapping = folio_file_mapping(folio);
 
@@ -867,6 +845,7 @@ static void nfs_inode_remove_request(str
 		}
 		spin_unlock(&mapping->private_lock);
 	}
+	nfs_page_group_unlock(req);
 
 	if (test_and_clear_bit(PG_INODE_REF, &req->wb_flags)) {
 		atomic_long_dec(&nfsi->nrequests);
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -162,6 +162,7 @@ extern void nfs_join_page_group(struct n
 extern int nfs_page_group_lock(struct nfs_page *);
 extern void nfs_page_group_unlock(struct nfs_page *);
 extern bool nfs_page_group_sync_on_bit(struct nfs_page *, unsigned int);
+extern bool nfs_page_group_sync_on_bit_locked(struct nfs_page *, unsigned int);
 extern	int nfs_page_set_headlock(struct nfs_page *req);
 extern void nfs_page_clear_headlock(struct nfs_page *req);
 extern bool nfs_async_iocounter_wait(struct rpc_task *, struct nfs_lock_context *);


