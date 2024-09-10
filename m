Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BD917A924;
	Tue, 10 Sep 2024 10:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964942; cv=none; b=IwVOWVuatjS7s0P4rj+r+jqupaW8//ZPfIeP99wqZAHLUHZQFKvlkBWEhXJkJAdsAuHWOIGW3cocBeTrzdLo6JzVSWWuOD9As65QXW/CG3Is9HWOgidmspNoepIdLF77wnFYGV9I70g4SSF7U6Yl1Fdbbf5m8vvjeXBD6Lia2cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964942; c=relaxed/simple;
	bh=NK6KBoTPQHkiQ/ABOfyKwHr3eqJFbINk47r+fAzrp6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBJysSPV3wcs4zsfCocIyjPdR4py3br3WgzM4vjUmoUf/u7XG1/MIakaV2bheGuRiZ+x2s4yqI5xSnED8DYyIN0ShrDKDH4Vuz/946dEpHI775eKTwBihzeuT1paPyaK10ktfuC5P9mDjXohN7T7DlHfsZyMoiqXWuI9LoZ5cAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/u8PGgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/u8PGgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424F5C4CEC3;
	Tue, 10 Sep 2024 10:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964942;
	bh=NK6KBoTPQHkiQ/ABOfyKwHr3eqJFbINk47r+fAzrp6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/u8PGgNaUdBPGr2nmhDmDHa4zzylog9PGlcaGvuxfgA4yQcQKf4cnAFjqpvnIP2n
	 eP7Vn1yjedlt8zczm7puz7r/Nk5Lc7HwcTmq7rtYyCo6e5iEUx3LN1z0fjQ6GltVSM
	 gFzwIdf3xi+AdE4+Di8KG97TyDzcnareDVYJStCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 083/186] NFSD: Refactor the duplicate reply cache shrinker
Date: Tue, 10 Sep 2024 11:32:58 +0200
Message-ID: <20240910092557.928692752@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c135e1269f34dfdea4bd94c11060c83a3c0b3c12 ]

Avoid holding the bucket lock while freeing cache entries. This
change also caps the number of entries that are freed when the
shrinker calls to reduce the shrinker's impact on the cache's
effectiveness.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |   82 +++++++++++++++++++++++++----------------------------
 1 file changed, 39 insertions(+), 43 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -309,68 +309,64 @@ nfsd_prune_bucket_locked(struct nfsd_net
 	}
 }
 
-static long prune_bucket(struct nfsd_drc_bucket *b, struct nfsd_net *nn,
-			 unsigned int max)
+/**
+ * nfsd_reply_cache_count - count_objects method for the DRC shrinker
+ * @shrink: our registered shrinker context
+ * @sc: garbage collection parameters
+ *
+ * Returns the total number of entries in the duplicate reply cache. To
+ * keep things simple and quick, this is not the number of expired entries
+ * in the cache (ie, the number that would be removed by a call to
+ * nfsd_reply_cache_scan).
+ */
+static unsigned long
+nfsd_reply_cache_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct svc_cacherep *rp, *tmp;
-	long freed = 0;
+	struct nfsd_net *nn = container_of(shrink,
+				struct nfsd_net, nfsd_reply_cache_shrinker);
 
-	list_for_each_entry_safe(rp, tmp, &b->lru_head, c_lru) {
-		/*
-		 * Don't free entries attached to calls that are still
-		 * in-progress, but do keep scanning the list.
-		 */
-		if (rp->c_state == RC_INPROG)
-			continue;
-		if (atomic_read(&nn->num_drc_entries) <= nn->max_drc_entries &&
-		    time_before(jiffies, rp->c_timestamp + RC_EXPIRE))
-			break;
-		nfsd_reply_cache_free_locked(b, rp, nn);
-		if (max && freed++ > max)
-			break;
-	}
-	return freed;
+	return atomic_read(&nn->num_drc_entries);
 }
 
-/*
- * Walk the LRU list and prune off entries that are older than RC_EXPIRE.
- * Also prune the oldest ones when the total exceeds the max number of entries.
+/**
+ * nfsd_reply_cache_scan - scan_objects method for the DRC shrinker
+ * @shrink: our registered shrinker context
+ * @sc: garbage collection parameters
+ *
+ * Free expired entries on each bucket's LRU list until we've released
+ * nr_to_scan freed objects. Nothing will be released if the cache
+ * has not exceeded it's max_drc_entries limit.
+ *
+ * Returns the number of entries released by this call.
  */
-static long
-prune_cache_entries(struct nfsd_net *nn)
+static unsigned long
+nfsd_reply_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
+	struct nfsd_net *nn = container_of(shrink,
+				struct nfsd_net, nfsd_reply_cache_shrinker);
+	unsigned long freed = 0;
+	LIST_HEAD(dispose);
 	unsigned int i;
-	long freed = 0;
 
 	for (i = 0; i < nn->drc_hashsize; i++) {
 		struct nfsd_drc_bucket *b = &nn->drc_hashtbl[i];
 
 		if (list_empty(&b->lru_head))
 			continue;
+
 		spin_lock(&b->cache_lock);
-		freed += prune_bucket(b, nn, 0);
+		nfsd_prune_bucket_locked(nn, b, 0, &dispose);
 		spin_unlock(&b->cache_lock);
-	}
-	return freed;
-}
 
-static unsigned long
-nfsd_reply_cache_count(struct shrinker *shrink, struct shrink_control *sc)
-{
-	struct nfsd_net *nn = container_of(shrink,
-				struct nfsd_net, nfsd_reply_cache_shrinker);
+		freed += nfsd_cacherep_dispose(&dispose);
+		if (freed > sc->nr_to_scan)
+			break;
+	}
 
-	return atomic_read(&nn->num_drc_entries);
+	trace_nfsd_drc_gc(nn, freed);
+	return freed;
 }
 
-static unsigned long
-nfsd_reply_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
-{
-	struct nfsd_net *nn = container_of(shrink,
-				struct nfsd_net, nfsd_reply_cache_shrinker);
-
-	return prune_cache_entries(nn);
-}
 /*
  * Walk an xdr_buf and get a CRC for at most the first RC_CSUMLEN bytes
  */


