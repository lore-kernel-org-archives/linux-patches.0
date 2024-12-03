Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8F41AB6C9;
	Tue,  3 Dec 2024 16:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242827; cv=none; b=fUng4C+HDhASSwBSACuXj8W4jmybTCvGw5876wnnF09ylO9Oe4Jo6tNJHv0xj28QDF0Vb+Smh+oGJhgszOa5ne9L3TsZDlfVAG1/UJPpBNLGpgBjZoF6qEQnwP0TDaIyHItdxC2iWzXPJRy63oAO6JqunjbdtPk/6ISZn2pWj9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242827; c=relaxed/simple;
	bh=OTexgQ5/kTOJ4trrURVidr2BU+e/5tdemti/Pobzg0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4AvdMTHkSJyAQa2ROk+yJKu6I0nBHYIHLpc7ovOkTjeSC47WEDCYclBd+hroz/G3ElBGJ5IH8XAPo/bPUtfMbGmQmB7zl7tj67xDpAbz14bjCdJqbOgMtUD4yqu+3iGvrtxAnf0rMmzCbL58dI7ontj7jI6G9mjiKK0N5IN2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsbJj4aX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsbJj4aX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B57C4CECF;
	Tue,  3 Dec 2024 16:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242826;
	bh=OTexgQ5/kTOJ4trrURVidr2BU+e/5tdemti/Pobzg0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsbJj4aXTYkgvwZ1sLytK+lIB4yKnzWNZJIRD05Jp1C+UT8m40PJwsF9yL1t5TKKw
	 uGEXwkvHESjEbYK9VvVk0FrjNFiFN1+UefnfEpbmYztS4S2u1gTzG5UaM6cNCB1OGk
	 waIa/LERh48RyBYhqIWkvOfS/o0TtY7Buf9i5o+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Raits <igor@gooddata.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 790/826] Revert "nfs: dont reuse partially completed requests in nfs_lock_and_join_requests"
Date: Tue,  3 Dec 2024 15:48:37 +0100
Message-ID: <20241203144814.578185616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 66f9dac9077c9c063552e465212abeb8f97d28a7 ]

This reverts commit b571cfcb9dcac187c6d967987792d37cb0688610.

This patch appears to assume that if one request is complete, then the
others will complete too before unlocking. That is not a valid
assumption, since other requests could hit a non-fatal error or a short
write that would cause them not to complete.

Reported-by: Igor Raits <igor@gooddata.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219508
Fixes: b571cfcb9dca ("nfs: don't reuse partially completed requests in nfs_lock_and_join_requests")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index ead2dc55952db..82ae2b85d393c 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -144,6 +144,31 @@ static void nfs_io_completion_put(struct nfs_io_completion *ioc)
 		kref_put(&ioc->refcount, nfs_io_completion_release);
 }
 
+static void
+nfs_page_set_inode_ref(struct nfs_page *req, struct inode *inode)
+{
+	if (!test_and_set_bit(PG_INODE_REF, &req->wb_flags)) {
+		kref_get(&req->wb_kref);
+		atomic_long_inc(&NFS_I(inode)->nrequests);
+	}
+}
+
+static int
+nfs_cancel_remove_inode(struct nfs_page *req, struct inode *inode)
+{
+	int ret;
+
+	if (!test_bit(PG_REMOVE, &req->wb_flags))
+		return 0;
+	ret = nfs_page_group_lock(req);
+	if (ret)
+		return ret;
+	if (test_and_clear_bit(PG_REMOVE, &req->wb_flags))
+		nfs_page_set_inode_ref(req, inode);
+	nfs_page_group_unlock(req);
+	return 0;
+}
+
 /**
  * nfs_folio_find_head_request - find head request associated with a folio
  * @folio: pointer to folio
@@ -540,7 +565,6 @@ static struct nfs_page *nfs_lock_and_join_requests(struct folio *folio)
 	struct inode *inode = folio->mapping->host;
 	struct nfs_page *head, *subreq;
 	struct nfs_commit_info cinfo;
-	bool removed;
 	int ret;
 
 	/*
@@ -565,18 +589,18 @@ static struct nfs_page *nfs_lock_and_join_requests(struct folio *folio)
 		goto retry;
 	}
 
-	ret = nfs_page_group_lock(head);
+	ret = nfs_cancel_remove_inode(head, inode);
 	if (ret < 0)
 		goto out_unlock;
 
-	removed = test_bit(PG_REMOVE, &head->wb_flags);
+	ret = nfs_page_group_lock(head);
+	if (ret < 0)
+		goto out_unlock;
 
 	/* lock each request in the page group */
 	for (subreq = head->wb_this_page;
 	     subreq != head;
 	     subreq = subreq->wb_this_page) {
-		if (test_bit(PG_REMOVE, &subreq->wb_flags))
-			removed = true;
 		ret = nfs_page_group_lock_subreq(head, subreq);
 		if (ret < 0)
 			goto out_unlock;
@@ -584,21 +608,6 @@ static struct nfs_page *nfs_lock_and_join_requests(struct folio *folio)
 
 	nfs_page_group_unlock(head);
 
-	/*
-	 * If PG_REMOVE is set on any request, I/O on that request has
-	 * completed, but some requests were still under I/O at the time
-	 * we locked the head request.
-	 *
-	 * In that case the above wait for all requests means that all I/O
-	 * has now finished, and we can restart from a clean slate.  Let the
-	 * old requests go away and start from scratch instead.
-	 */
-	if (removed) {
-		nfs_unroll_locks(head, head);
-		nfs_unlock_and_release_request(head);
-		goto retry;
-	}
-
 	nfs_init_cinfo_from_inode(&cinfo, inode);
 	nfs_join_page_group(head, &cinfo, inode);
 	return head;
-- 
2.43.0



