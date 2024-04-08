Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3659F42046;
	Mon,  8 Apr 2024 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584498; cv=none; b=WbDc+Jbmtav4SCZY0LoeQLVTgzAbXsJkAHSZp2jCIFS/Psup/dvKwbJ9eH+RIxzR08AbsbObh8HbtMLdfEHtBPwm0ptzh7QgvyJq6qFUsW882Wa9SNPC3lGm9wEge3g2B3fJlfEJ9vOjSAGBCZyO/mGVBGWzKMpe6jZn2ra2558=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584498; c=relaxed/simple;
	bh=qDdxELZs5RVbs8Z4j/SsSZHWh8ymJyVaAsQGJNQ8xCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfmrJ7rItaoy6ue99JMFBONHu5zrtLTYHFd89cpz6l0nY2/k20213Yg5qlsvmKJ/Rpd5Dt0szZgRHFYHM538NyGpf2cSHF3SbLISIBIpe8e8/ffEky9HDyQiuB1wkLBjFkPLreT+IJKY1/bxEYo1mK76p7WTFbq5ShRQ4TfQbFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yJovdgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yJovdgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A78C433C7;
	Mon,  8 Apr 2024 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584498;
	bh=qDdxELZs5RVbs8Z4j/SsSZHWh8ymJyVaAsQGJNQ8xCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yJovdgdc9rEPwL/RptbR+GWR+s5FyvOg8893mOC9wow2bS+qrt8qQyecuq+FMrul
	 gmuLNdfKQQ8YL55sfSxdlDwcZZbKVZnlmPN0Y37LLK9GwNBkOEc8pLjXT1Z5s0TPBy
	 zKrSqjqAx12S4LvDeOBcWCdO6dK3GWYkSm/gU4VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 459/690] nfsd: fix nfsd_file_unhash_and_dispose
Date: Mon,  8 Apr 2024 14:55:25 +0200
Message-ID: <20240408125416.253259758@linuxfoundation.org>
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

[ Upstream commit 8d0d254b15cc5b7d46d85fb7ab8ecede9575e672 ]

nfsd_file_unhash_and_dispose() is called for two reasons:

We're either shutting down and purging the filecache, or we've gotten a
notification about a file delete, so we want to go ahead and unhash it
so that it'll get cleaned up when we close.

We're either walking the hashtable or doing a lookup in it and we
don't take a reference in either case. What we want to do in both cases
is to try and unhash the object and put it on the dispose list if that
was successful. If it's no longer hashed, then we don't want to touch
it, with the assumption being that something else is already cleaning
up the sentinel reference.

Instead of trying to selectively decrement the refcount in this
function, just unhash it, and if that was successful, move it to the
dispose list. Then, the disposal routine will just clean that up as
usual.

Also, just make this a void function, drop the WARN_ON_ONCE, and the
comments about deadlocking since the nature of the purported deadlock
is no longer clear.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index fa8e1546e0206..a0d93e797cdce 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -404,22 +404,15 @@ nfsd_file_unhash(struct nfsd_file *nf)
 	return false;
 }
 
-/*
- * Return true if the file was unhashed.
- */
-static bool
+static void
 nfsd_file_unhash_and_dispose(struct nfsd_file *nf, struct list_head *dispose)
 {
 	trace_nfsd_file_unhash_and_dispose(nf);
-	if (!nfsd_file_unhash(nf))
-		return false;
-	/* keep final reference for nfsd_file_lru_dispose */
-	if (refcount_dec_not_one(&nf->nf_ref))
-		return true;
-
-	nfsd_file_lru_remove(nf);
-	list_add(&nf->nf_lru, dispose);
-	return true;
+	if (nfsd_file_unhash(nf)) {
+		/* caller must call nfsd_file_dispose_list() later */
+		nfsd_file_lru_remove(nf);
+		list_add(&nf->nf_lru, dispose);
+	}
 }
 
 static void
@@ -561,8 +554,6 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
  * @lock: LRU list lock (unused)
  * @arg: dispose list
  *
- * Note this can deadlock with nfsd_file_cache_purge.
- *
  * Return values:
  *   %LRU_REMOVED: @item was removed from the LRU
  *   %LRU_ROTATE: @item is to be moved to the LRU tail
@@ -747,8 +738,6 @@ nfsd_file_close_inode(struct inode *inode)
  *
  * Walk the LRU list and close any entries that have not been used since
  * the last scan.
- *
- * Note this can deadlock with nfsd_file_cache_purge.
  */
 static void
 nfsd_file_delayed_close(struct work_struct *work)
@@ -890,16 +879,12 @@ nfsd_file_cache_init(void)
 	goto out;
 }
 
-/*
- * Note this can deadlock with nfsd_file_lru_cb.
- */
 static void
 __nfsd_file_cache_purge(struct net *net)
 {
 	struct rhashtable_iter iter;
 	struct nfsd_file *nf;
 	LIST_HEAD(dispose);
-	bool del;
 
 	rhashtable_walk_enter(&nfsd_file_rhash_tbl, &iter);
 	do {
@@ -909,14 +894,7 @@ __nfsd_file_cache_purge(struct net *net)
 		while (!IS_ERR_OR_NULL(nf)) {
 			if (net && nf->nf_net != net)
 				continue;
-			del = nfsd_file_unhash_and_dispose(nf, &dispose);
-
-			/*
-			 * Deadlock detected! Something marked this entry as
-			 * unhased, but hasn't removed it from the hash list.
-			 */
-			WARN_ON_ONCE(!del);
-
+			nfsd_file_unhash_and_dispose(nf, &dispose);
 			nf = rhashtable_walk_next(&iter);
 		}
 
-- 
2.43.0



