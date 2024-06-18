Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F71157A49;
	Tue, 18 Jun 2024 13:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715921; cv=none; b=ee+gzuZXO8gMItd00eMx45RFjdo9eNTDbN3oMT2ewxejQFe/WkzfH6D35fQTOymYzM9nSUUUqo340yQIQhBs4NMQuQi3lsi3+KafUe82rbW3rNElQ55vs/Bn6DYxQZLy2tdMfMG0Sv6f0gnrovKQvbhxMohl1OHoSt/OPYJC7bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715921; c=relaxed/simple;
	bh=2fiLgtRXOAmZk80ypKMXopHn63yBWXtN4dOLkYT6jdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N50TxLieRO5AUJWzwKXikjI3fA8xXCZhYdTIA1NMcsbPTC8cOm1XPoNxkmNQfM1tb70IZa1vHHoH3ZhP0h5G8+DNSgwV4tvBkk46ru+Bl7zrynH0ERZ67Tr5mAEwFs/1GsiCfX/FoMiLMg/bQhUdcU8ImYfdO7PlQfO6reMwgm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdD+IEpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdD+IEpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA73C3277B;
	Tue, 18 Jun 2024 13:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715920;
	bh=2fiLgtRXOAmZk80ypKMXopHn63yBWXtN4dOLkYT6jdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdD+IEpuZPYw2vAo71oR4+uOgE/Eb6KRJJjMXvO20yag5vtsG13XShYl7NqPYiVLv
	 omotbq3yw2uIgJOgGj2CDR5FU5y8rYTvh9iNaTgi5jvAFHftRAH+gFyjMolQqIqZfA
	 qefI6RkoCR/cfslYkiKclISSzHo+K4XnZ3HW9iWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 471/770] NFSD: De-duplicate hash bucket indexing
Date: Tue, 18 Jun 2024 14:35:24 +0200
Message-ID: <20240618123425.495352856@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 378a6109dd142a678f629b740f558365150f60f9 ]

Clean up: The details of finding the right hash bucket are exactly
the same in both nfsd_cache_lookup() and nfsd_cache_update().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfscache.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index a4a69ab6ab280..f79790d367288 100644
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



