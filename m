Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A931FECAB;
	Tue, 26 Aug 2025 11:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208595; cv=none; b=t6d230MTGEnW6B11+/qDlO0MyTW0QBSCSGvjfYlw6dLoE6L1x7NZSgsxNDTl7KTC8poYYdr2X/5Obrs1vHZ95gYIsJxJ0jcQbCawaT4qcGd0aFsU8XJnQIMNLcfrYtq+fbd4SoBgp7eaZhaYVMa6NL9UupiiYzNpS2ZwnrfMffo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208595; c=relaxed/simple;
	bh=RzUR9XBw6cDuKqKZyoCOkuBqF1XWsb9dSiLy99KoV/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb/leJvH3wuvHcC0cvsqw3FIgwKA2BvY06pSee62osNGi8oN0A+0zrPNyp+4UwfU/W6n2E2KVglHJvqaW4WlRvS/vXYnMa7JD5J+HJSUQz2Qp85fToXcFOP7E3POyDcO/AWjB2q7dYPhKgeAREQpXOmPIXCLtS/UBOY9GuaR5h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFai7Q3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFai7Q3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12C3C4CEF1;
	Tue, 26 Aug 2025 11:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208595;
	bh=RzUR9XBw6cDuKqKZyoCOkuBqF1XWsb9dSiLy99KoV/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFai7Q3oPGnPUMbanHFYjq9TDkd6dQbGiceZUXqGyDu3HjcFviBASmHtd7KEd4j7q
	 GCUfS2lBktmDCv9dNgxukcU5OKwuaGYCAEsuEBnCWLXAi62OQ1hEq7RwvvSb1PPPVI
	 nS5p3kmDOcyZqZ7CuGVCaJiLLr2WbzaQ42Hu1R1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Joe Quanaim <jdq@meta.com>,
	Andrew Steffen <aksteffen@meta.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.12 170/322] NFS: Fix a race when updating an existing write
Date: Tue, 26 Aug 2025 13:09:45 +0200
Message-ID: <20250826110920.048192836@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfs/pagelist.c        |    9 +++++----
 fs/nfs/write.c           |   29 ++++++++++-------------------
 include/linux/nfs_page.h |    1 +
 3 files changed, 16 insertions(+), 23 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -253,13 +253,14 @@ nfs_page_group_unlock(struct nfs_page *r
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
@@ -153,20 +153,10 @@ nfs_page_set_inode_ref(struct nfs_page *
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
 
 /**
@@ -585,19 +575,18 @@ retry:
 		}
 	}
 
+	ret = nfs_page_group_lock(head);
+	if (ret < 0)
+		goto out_unlock;
+
 	/* Ensure that nobody removed the request before we locked it */
 	if (head != folio->private) {
+		nfs_page_group_unlock(head);
 		nfs_unlock_and_release_request(head);
 		goto retry;
 	}
 
-	ret = nfs_cancel_remove_inode(head, inode);
-	if (ret < 0)
-		goto out_unlock;
-
-	ret = nfs_page_group_lock(head);
-	if (ret < 0)
-		goto out_unlock;
+	nfs_cancel_remove_inode(head, inode);
 
 	/* lock each request in the page group */
 	for (subreq = head->wb_this_page;
@@ -801,7 +790,8 @@ static void nfs_inode_remove_request(str
 {
 	struct nfs_inode *nfsi = NFS_I(nfs_page_to_inode(req));
 
-	if (nfs_page_group_sync_on_bit(req, PG_REMOVE)) {
+	nfs_page_group_lock(req);
+	if (nfs_page_group_sync_on_bit_locked(req, PG_REMOVE)) {
 		struct folio *folio = nfs_page_to_folio(req->wb_head);
 		struct address_space *mapping = folio->mapping;
 
@@ -812,6 +802,7 @@ static void nfs_inode_remove_request(str
 		}
 		spin_unlock(&mapping->i_private_lock);
 	}
+	nfs_page_group_unlock(req);
 
 	if (test_and_clear_bit(PG_INODE_REF, &req->wb_flags)) {
 		atomic_long_dec(&nfsi->nrequests);
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -160,6 +160,7 @@ extern void nfs_join_page_group(struct n
 extern int nfs_page_group_lock(struct nfs_page *);
 extern void nfs_page_group_unlock(struct nfs_page *);
 extern bool nfs_page_group_sync_on_bit(struct nfs_page *, unsigned int);
+extern bool nfs_page_group_sync_on_bit_locked(struct nfs_page *, unsigned int);
 extern	int nfs_page_set_headlock(struct nfs_page *req);
 extern void nfs_page_clear_headlock(struct nfs_page *req);
 extern bool nfs_async_iocounter_wait(struct rpc_task *, struct nfs_lock_context *);


