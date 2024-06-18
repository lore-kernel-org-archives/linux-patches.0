Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557D82139DB;
	Tue, 18 Jun 2024 13:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716521; cv=none; b=Ltuqf+4HnHPMXDJ5DJY4MAnJWrCFehehyhFxMVY/qTHxd1GkN3HeQ8GpXCDt/4wYwnNh/9S9w0wTGMd7J/eKuf4II1tPePtrcic6GODIVg7pC/15GHFTy4SGB+is5WJyhRfjQAfYAQPdZMVqTYvBK6LxV0P47LcZg+fF1xOmNNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716521; c=relaxed/simple;
	bh=hoPsNRNU82pCYh3o+y40FERs3/8J1beE50uWzXLMpJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pm+tbThGmDSZQKc9tkBI8rAi3G9Cx3pWMp+yVES4sSbDfoVrhuJP81o09kMrMjtj1QCv18ZvGeHCbiwp6GOvuSa+adTI2hkLiFyPHKwf0Ef8GgRTkEQmTW1aOZf1cTB7XlSYI/x1cnITHh38veprqh/GpRypLdT5Th9b06ewC6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGE5h+0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGE5h+0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7683DC3277B;
	Tue, 18 Jun 2024 13:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716519;
	bh=hoPsNRNU82pCYh3o+y40FERs3/8J1beE50uWzXLMpJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGE5h+0ysMRHkOwSWG9HtqduQngzUQPxyMrrlcu2tEbVE5eWeicHWMXxwKsa8r0VD
	 aAYALi30+21msWFASl9J2zyPS9BHbvjaUtF11pF5nFv7Hqisp9Auw7qKKVRqHDMpql
	 Hyyqyr2L33qPgNXG9D4QsgkkGIOhxFx2wTD/VoQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 672/770] nfsd: fix nfsd_file_unhash_and_dispose
Date: Tue, 18 Jun 2024 14:38:45 +0200
Message-ID: <20240618123433.220484449@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



