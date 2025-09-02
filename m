Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D85308F1A;
	Tue,  2 Sep 2025 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820549; cv=none; b=sbFXT5w6h1tKgTg2DII9hU9EE2ioURPhCsAiI73cwliDUOCyY3BwYfuxfx0IiJ3z96uick3jbOcg11+mJSGuMSpem9BYJOBAOLved4Th1x323qkihZ4CUr++U7PJTJgZG5XTt5oU0MMRG9nJpL0rXMEcvMNoC/WeQUDw3zT2Nzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820549; c=relaxed/simple;
	bh=Q17JNhDCdZdVU5cWYZ6XHK9SUiGTilNCQr/WVqY0oZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbGNfmdXVO22uGKxSgQ0LlYAaRP5EUG+XbnVx1+FB2hGAQ2VJce3B1J4kU55N8YRYLERVQvKBhwA+fhn2phM/UmAvMJgg7crKzeubMR+eed23G7LqRz9mgv9A5srljGWkhMZvTT3vBTNrLtdEjdVyYTFXg8YBFhlGxWPPTVj/D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFubkf3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFubkf3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43FDC4CEED;
	Tue,  2 Sep 2025 13:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820549;
	bh=Q17JNhDCdZdVU5cWYZ6XHK9SUiGTilNCQr/WVqY0oZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFubkf3nMuoyDFbm3ovTXSF11eztFfSNYeEdXEGEeJOuESCstyqnUIh9i/8bi9C4U
	 o7l04pF2Y3NOW6orRJPWBhrEm3uNbggXfQut+hS2JoByX8eXmhA3SUj4bbMRgNjEwO
	 DVNRQVAqBonu4lNybIgxIX55oaY7ZEsjcmMZ3Tx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Joe Quanaim <jdq@meta.com>,
	Andrew Steffen <aksteffen@meta.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 06/33] NFS: Fix a race when updating an existing write
Date: Tue,  2 Sep 2025 15:21:24 +0200
Message-ID: <20250902131927.297887271@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfs/pagelist.c        |    9 +++---
 fs/nfs/write.c           |   66 ++++++++++++++++-------------------------------
 include/linux/nfs_page.h |    1 
 3 files changed, 29 insertions(+), 47 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -234,13 +234,14 @@ nfs_page_group_unlock(struct nfs_page *r
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
@@ -155,20 +155,10 @@ nfs_page_set_inode_ref(struct nfs_page *
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
 
 static struct nfs_page *
@@ -240,36 +230,6 @@ static struct nfs_page *nfs_page_find_he
 	return req;
 }
 
-static struct nfs_page *nfs_find_and_lock_page_request(struct page *page)
-{
-	struct inode *inode = page_file_mapping(page)->host;
-	struct nfs_page *req, *head;
-	int ret;
-
-	for (;;) {
-		req = nfs_page_find_head_request(page);
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
-		if (head == nfs_page_private_request(page))
-			break;
-		if (PageSwapCache(page))
-			break;
-		nfs_unlock_and_release_request(head);
-	}
-	return head;
-}
-
 /* Adjust the file length if we're writing beyond the end */
 static void nfs_grow_file(struct page *page, unsigned int offset, unsigned int count)
 {
@@ -626,14 +586,32 @@ nfs_lock_and_join_requests(struct page *
 	 * reference to the whole page group - the group will not be destroyed
 	 * until the head reference is released.
 	 */
-	head = nfs_find_and_lock_page_request(page);
+retry:
+	head = nfs_page_find_head_request(page);
 	if (IS_ERR_OR_NULL(head))
 		return head;
 
+	while (!nfs_lock_request(head)) {
+		ret = nfs_wait_on_request(head);
+		if (ret < 0) {
+			nfs_release_request(head);
+			return ERR_PTR(ret);
+		}
+	}
+
 	ret = nfs_page_group_lock(head);
 	if (ret < 0)
 		goto out_unlock;
 
+	/* Ensure that nobody removed the request before we locked it */
+	if (head != nfs_page_private_request(page) && !PageSwapCache(page)) {
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
@@ -843,7 +821,8 @@ static void nfs_inode_remove_request(str
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_page *head;
 
-	if (nfs_page_group_sync_on_bit(req, PG_REMOVE)) {
+	nfs_page_group_lock(req);
+	if (nfs_page_group_sync_on_bit_locked(req, PG_REMOVE)) {
 		head = req->wb_head;
 
 		spin_lock(&mapping->private_lock);
@@ -854,6 +833,7 @@ static void nfs_inode_remove_request(str
 		}
 		spin_unlock(&mapping->private_lock);
 	}
+	nfs_page_group_unlock(req);
 
 	if (test_and_clear_bit(PG_INODE_REF, &req->wb_flags)) {
 		nfs_release_request(req);
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -150,6 +150,7 @@ extern void nfs_join_page_group(struct n
 extern int nfs_page_group_lock(struct nfs_page *);
 extern void nfs_page_group_unlock(struct nfs_page *);
 extern bool nfs_page_group_sync_on_bit(struct nfs_page *, unsigned int);
+extern bool nfs_page_group_sync_on_bit_locked(struct nfs_page *, unsigned int);
 extern	int nfs_page_set_headlock(struct nfs_page *req);
 extern void nfs_page_clear_headlock(struct nfs_page *req);
 extern bool nfs_async_iocounter_wait(struct rpc_task *, struct nfs_lock_context *);


