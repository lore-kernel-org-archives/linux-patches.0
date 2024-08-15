Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A95C1AC8BB;
	Thu, 15 Aug 2024 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730732; cv=none; b=N5hehpMm1FA9pFkrQB5hVlXe+JaU3jirGCpx9WJ/TKxN3v1ecq/XbXnmHOgGB9FbQbe/p68EMbv8SytZOKnojZbDT3IfNpO40PMErEHaJHqNUrFIXZo+dDJaVIYLpI0yU03IJcilmQYrDSW3kCyV2mUysXqTYBswqQ7TqTXbJ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730732; c=relaxed/simple;
	bh=R8xzYibVXCpIglO8nRvfbQDfpIbMTFZ4AV9NSrFMwUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+X6d+Cojv3dCAX1gFZM9kIgLDvOLEA5U5e/OpnS6B0i2+3bq3OIcsYLv7n2m4Cf7WRAbAH5l/uBAAffcPaXTbAT1DYfjFXWJ2R+p3JF25QATeN6BgR4ANsRb/wcwqGz20YKFBmewboS2KQpmspzKAp9CkU/3IKEK9zpGcbn0dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hw1yLeIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hw1yLeIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0528C32786;
	Thu, 15 Aug 2024 14:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730732;
	bh=R8xzYibVXCpIglO8nRvfbQDfpIbMTFZ4AV9NSrFMwUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hw1yLeIRDC0lgTUkETAcCHgO2BatPvgdNhQxFQsSO4TwJ6JltZ5AreJjq8oBQgo//
	 V8RFactc4FmmcitPiMJ3AMFjrmcWTDBsKOSwGKQjjP2F7D+l89kduOj6lc1mPNBU/l
	 ap8ilY9ytok5eHo+/8+We5MfzmINOGbDRtOQPztc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 15/38] NFSD: Refactor the duplicate reply cache shrinker
Date: Thu, 15 Aug 2024 15:25:49 +0200
Message-ID: <20240815131833.538482037@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c135e1269f34dfdea4bd94c11060c83a3c0b3c12 ]

Avoid holding the bucket lock while freeing cache entries. This
change also caps the number of entries that are freed when the
shrinker calls to reduce the shrinker's impact on the cache's
effectiveness.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v6.1.y -- this one might not be necessary ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |   83 ++++++++++++++++++++++++-----------------------------
 1 file changed, 39 insertions(+), 44 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -310,67 +310,62 @@ nfsd_prune_bucket_locked(struct nfsd_net
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
-
-static unsigned long
-nfsd_reply_cache_count(struct shrinker *shrink, struct shrink_control *sc)
-{
-	struct nfsd_net *nn = container_of(shrink,
-				struct nfsd_net, nfsd_reply_cache_shrinker);
 
-	return atomic_read(&nn->num_drc_entries);
-}
-
-static unsigned long
-nfsd_reply_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
-{
-	struct nfsd_net *nn = container_of(shrink,
-				struct nfsd_net, nfsd_reply_cache_shrinker);
+		freed += nfsd_cacherep_dispose(&dispose);
+		if (freed > sc->nr_to_scan)
+			break;
+	}
 
-	return prune_cache_entries(nn);
+	trace_nfsd_drc_gc(nn, freed);
+	return freed;
 }
 
 /**


