Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0DF19E81B;
	Tue, 18 Jun 2024 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716682; cv=none; b=fZstWMqvBSS2sdTU5QhS/4AL7PzvbsNNeWHOG1woyC4uEs1b5JrHf/IupBFA/vfcf0RhIyZUQ7BAEdvYXywvImFhIWZ1rl4IpjEfw8swaugE9ysNLSgWhcDNNxT8ElKUKWETOiD72OHFL601gvwaRxOwSzUee62RSIbiWJ/0B2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716682; c=relaxed/simple;
	bh=eNRxidlg5Itu6/yfMNltpPRnw8Cd0VFSUIIiqs5shHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6pQGL9L2nVTj4EjULCPRnYS31cgUGeifpw2atDccQE1aXG4MvX6rIXZa7GZWRdMfDgukJdMCrDxKPMyCGnv3ckkKemXd2Oauzm5JmrGDfl56mk7fCn6CdP2rd8dXMnQJq+YMx8jW19qjzR49xgQ8laHaF9O8odzd0g+sCpX7aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr5XId8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr5XId8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B82C3277B;
	Tue, 18 Jun 2024 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716682;
	bh=eNRxidlg5Itu6/yfMNltpPRnw8Cd0VFSUIIiqs5shHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr5XId8S09YzorCpSl7+Tz2eNlRLnSnAoRn2mZAPya0SXlFy+uxJP31VtlIi8VvdL
	 RWSRq007/2PXdc6leG7z5juL2A+xmUwCymP+5jLMVuC+5D95CQMmCYPvLTC/qO1KR6
	 pcHxulBeGd+c1C5bMdyoqwNKAHj6v5wXC0ZgWwkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruben Vestergaard <rubenv@drcmr.dk>,
	Torkil Svensgaard <torkil@drcmr.dk>,
	Shachar Kagan <skagan@nvidia.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 728/770] nfsd: dont free files unconditionally in __nfsd_file_cache_purge
Date: Tue, 18 Jun 2024 14:39:41 +0200
Message-ID: <20240618123435.369222094@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 4bdbba54e9b1c769da8ded9abd209d765715e1d6 ]

nfsd_file_cache_purge is called when the server is shutting down, in
which case, tearing things down is generally fine, but it also gets
called when the exports cache is flushed.

Instead of walking the cache and freeing everything unconditionally,
handle it the same as when we have a notification of conflicting access.

Fixes: ac3a2585f018 ("nfsd: rework refcounting in filecache")
Reported-by: Ruben Vestergaard <rubenv@drcmr.dk>
Reported-by: Torkil Svensgaard <torkil@drcmr.dk>
Reported-by: Shachar Kagan <skagan@nvidia.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Shachar Kagan <skagan@nvidia.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 61 ++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 6a62d95d5ce64..68c7c82f8b3bb 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -660,6 +660,39 @@ static struct shrinker	nfsd_file_shrinker = {
 	.seeks = 1,
 };
 
+/**
+ * nfsd_file_cond_queue - conditionally unhash and queue a nfsd_file
+ * @nf: nfsd_file to attempt to queue
+ * @dispose: private list to queue successfully-put objects
+ *
+ * Unhash an nfsd_file, try to get a reference to it, and then put that
+ * reference. If it's the last reference, queue it to the dispose list.
+ */
+static void
+nfsd_file_cond_queue(struct nfsd_file *nf, struct list_head *dispose)
+	__must_hold(RCU)
+{
+	int decrement = 1;
+
+	/* If we raced with someone else unhashing, ignore it */
+	if (!nfsd_file_unhash(nf))
+		return;
+
+	/* If we can't get a reference, ignore it */
+	if (!nfsd_file_get(nf))
+		return;
+
+	/* Extra decrement if we remove from the LRU */
+	if (nfsd_file_lru_remove(nf))
+		++decrement;
+
+	/* If refcount goes to 0, then put on the dispose list */
+	if (refcount_sub_and_test(decrement, &nf->nf_ref)) {
+		list_add(&nf->nf_lru, dispose);
+		trace_nfsd_file_closing(nf);
+	}
+}
+
 /**
  * nfsd_file_queue_for_close: try to close out any open nfsd_files for an inode
  * @inode:   inode on which to close out nfsd_files
@@ -687,30 +720,11 @@ nfsd_file_queue_for_close(struct inode *inode, struct list_head *dispose)
 
 	rcu_read_lock();
 	do {
-		int decrement = 1;
-
 		nf = rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
 				       nfsd_file_rhash_params);
 		if (!nf)
 			break;
-
-		/* If we raced with someone else unhashing, ignore it */
-		if (!nfsd_file_unhash(nf))
-			continue;
-
-		/* If we can't get a reference, ignore it */
-		if (!nfsd_file_get(nf))
-			continue;
-
-		/* Extra decrement if we remove from the LRU */
-		if (nfsd_file_lru_remove(nf))
-			++decrement;
-
-		/* If refcount goes to 0, then put on the dispose list */
-		if (refcount_sub_and_test(decrement, &nf->nf_ref)) {
-			list_add(&nf->nf_lru, dispose);
-			trace_nfsd_file_closing(nf);
-		}
+		nfsd_file_cond_queue(nf, dispose);
 	} while (1);
 	rcu_read_unlock();
 }
@@ -927,11 +941,8 @@ __nfsd_file_cache_purge(struct net *net)
 
 		nf = rhashtable_walk_next(&iter);
 		while (!IS_ERR_OR_NULL(nf)) {
-			if (!net || nf->nf_net == net) {
-				nfsd_file_unhash(nf);
-				nfsd_file_lru_remove(nf);
-				list_add(&nf->nf_lru, &dispose);
-			}
+			if (!net || nf->nf_net == net)
+				nfsd_file_cond_queue(nf, &dispose);
 			nf = rhashtable_walk_next(&iter);
 		}
 
-- 
2.43.0



