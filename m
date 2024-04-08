Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E36371742;
	Mon,  8 Apr 2024 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584715; cv=none; b=FAiXivYr7rQzjAvI9jNyhnFTzJhsg/zXk3a2ou00xhRes28S87lt7XKBR6Q/XFFMmlv5Ls7RDA1WqafmSBUH1a0dekBKrd1kDZn+ddIFZ9zGPSkG1kBFkMYQp+JrMQeVV0S2MXafcaAgpqCINeMHWQqTv/PvrcYytYBoMiFDKY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584715; c=relaxed/simple;
	bh=GNIVkZUNURupYhkK81LJEr8+Z0ArZvOjuKMeKDn3vJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hk2sKy1JtDPnNM8FAB3naRsH1LhUGteoHBFBxqVTb51oQwwoMg0JITNaLLbsnVAC3uw7oiJhS9r2hJkk2ddDYpVmgwpBi/gqFLJRYrar0Mj1w8A9FIqZWLFm8KrPPwdpQxBHNnMpRhouz4lvxbVEJ8zLpc5y5//XhyABBSkuS8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3Ptyfvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3Ptyfvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2E4C43394;
	Mon,  8 Apr 2024 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584715;
	bh=GNIVkZUNURupYhkK81LJEr8+Z0ArZvOjuKMeKDn3vJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3PtyfvddMfuerHMILJIUDkn5h4AdRTs+UEJCBL7RGTvaI3Q/0ixWjvAHjMs5Dehc
	 kwBETHl6icyV/vTAZtRnRA1TNAk8+U9iNWK7B6FKd4Qc26a4RUOUeCG7jReJHB8ZQs
	 edhXt0e2blF+XvD1YphcC/oyDA35JxBbQEn1LPcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruben Vestergaard <rubenv@drcmr.dk>,
	Torkil Svensgaard <torkil@drcmr.dk>,
	Shachar Kagan <skagan@nvidia.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 515/690] nfsd: dont free files unconditionally in __nfsd_file_cache_purge
Date: Mon,  8 Apr 2024 14:56:21 +0200
Message-ID: <20240408125418.307946959@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



