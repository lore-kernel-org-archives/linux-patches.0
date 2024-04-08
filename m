Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70C780619;
	Mon,  8 Apr 2024 13:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583628; cv=none; b=hAd+lwDGort7GifOM61biMhJKtVEwHQEGnOHi5BmGhip8AxPdyOUVn4FOKF3Ey/QD7k7nBb7AMKHqD2Oqe3AOl52i++xFSu8sK5+YTDe0DM2zsBnEWwwoxIRgwRBqOrWcPURqaq/FYe4etECR7imPZPJPgOtllk6DZPdhc6Y2KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583628; c=relaxed/simple;
	bh=QIxXb7wByVYZfI7WzX7qKqeiVM080+/8sTpeZt072TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqlHC/xVlmAch8n0QqFJTmj3nS59p/zcIUwApl9RD/T+yOOpPdIPlDHvcmjXkyA+pwW3Q9iAE/wmQz64Wpf/WTHOyF1LSr3jLAkFVlDEPR3nMl+5V7+F5gTT0wmCLScWi9nT+ezcngxJ1Hdr+88GqzFgJi98MznI/SrMaMKhBP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfPqxdND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfPqxdND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B66BC433C7;
	Mon,  8 Apr 2024 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583628;
	bh=QIxXb7wByVYZfI7WzX7qKqeiVM080+/8sTpeZt072TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfPqxdND5+sKpDZdOXEW5tjwIaFh/Z7molQ+eJo5ChSQJfBTIPdhnyEy4Y0LbbJQF
	 hy0A2bDi6KuTZbuFYxxk3JlQA2SmALY2eDFZtrcrZCNAh3lkPoCzjZMNe6Ow9p4l9V
	 nmS0EEit1p0JtLyzzNSEG253lRftBIyoUZ5DSR+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 268/690] orDate: Thu Sep 30 19:19:57 2021 -0400
Date: Mon,  8 Apr 2024 14:52:14 +0200
Message-ID: <20240408125409.330662285@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

NFSD: De-duplicate hash bucket indexing

[ Upstream commit 378a6109dd142a678f629b740f558365150f60f9 ]

Clean up: The details of finding the right hash bucket are exactly
the same in both nfsd_cache_lookup() and nfsd_cache_update().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfscache.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index a838909502907..7880a2f2d29f6 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -84,12 +84,6 @@ nfsd_hashsize(unsigned int limit)
 	return roundup_pow_of_two(limit / TARGET_BUCKET_SIZE);
 }
 
-static u32
-nfsd_cache_hash(__be32 xid, struct nfsd_net *nn)
-{
-	return hash_32((__force u32)xid, nn->maskbits);
-}
-
 static struct svc_cacherep *
 nfsd_reply_cache_alloc(struct svc_rqst *rqstp, __wsum csum,
 			struct nfsd_net *nn)
@@ -241,6 +235,14 @@ lru_put_end(struct nfsd_drc_bucket *b, struct svc_cacherep *rp)
 	list_move_tail(&rp->c_lru, &b->lru_head);
 }
 
+static noinline struct nfsd_drc_bucket *
+nfsd_cache_bucket_find(__be32 xid, struct nfsd_net *nn)
+{
+	unsigned int hash = hash_32((__force u32)xid, nn->maskbits);
+
+	return &nn->drc_hashtbl[hash];
+}
+
 static long prune_bucket(struct nfsd_drc_bucket *b, struct nfsd_net *nn,
 			 unsigned int max)
 {
@@ -421,10 +423,8 @@ int nfsd_cache_lookup(struct svc_rqst *rqstp)
 {
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct svc_cacherep	*rp, *found;
-	__be32			xid = rqstp->rq_xid;
 	__wsum			csum;
-	u32 hash = nfsd_cache_hash(xid, nn);
-	struct nfsd_drc_bucket *b = &nn->drc_hashtbl[hash];
+	struct nfsd_drc_bucket	*b = nfsd_cache_bucket_find(rqstp->rq_xid, nn);
 	int type = rqstp->rq_cachetype;
 	int rtn = RC_DOIT;
 
@@ -528,7 +528,6 @@ void nfsd_cache_update(struct svc_rqst *rqstp, int cachetype, __be32 *statp)
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct svc_cacherep *rp = rqstp->rq_cacherep;
 	struct kvec	*resv = &rqstp->rq_res.head[0], *cachv;
-	u32		hash;
 	struct nfsd_drc_bucket *b;
 	int		len;
 	size_t		bufsize = 0;
@@ -536,8 +535,7 @@ void nfsd_cache_update(struct svc_rqst *rqstp, int cachetype, __be32 *statp)
 	if (!rp)
 		return;
 
-	hash = nfsd_cache_hash(rp->c_key.k_xid, nn);
-	b = &nn->drc_hashtbl[hash];
+	b = nfsd_cache_bucket_find(rp->c_key.k_xid, nn);
 
 	len = resv->iov_len - ((char*)statp - (char*)resv->iov_base);
 	len >>= 2;
-- 
2.43.0



