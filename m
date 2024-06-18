Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0085157A49;
	Tue, 18 Jun 2024 13:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715924; cv=none; b=nnIUyK/SeaLjUKPsC66b4xt3uPltStZu3twvC6710Ka4WM7H0n3lQrBxyzxonQ6yXNbGdWT3+3t3mrdP2VQvlrVZpLkqmSLHwCIjCvRBu+BoXOtGLW8oOPOCJB0vTq2mqnXVtay+0EVtSSYqWI6alfw1koKH7k4pNSM63OGiKsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715924; c=relaxed/simple;
	bh=buRMJ06txfSY1AX4Q8Ks1PHqxbh8Vf7VRdXCFhCNIDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoW7W81k05i3XWJEqDnQUg3FWU8dnE434kq5Nph842FjK8r28Ja1h3mXPpBaB26EST+4qduRvsf+eyWGWA+orUycNAbCCQEFpUTkYpmDERVcQcuPpFyjC23Z310vUvIc3/uuvuSp6oo1JPBEQ/BNNwGzOX0wIf9XOhfpgbJ5Fx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwJB+ErC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwJB+ErC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EC8C3277B;
	Tue, 18 Jun 2024 13:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715923;
	bh=buRMJ06txfSY1AX4Q8Ks1PHqxbh8Vf7VRdXCFhCNIDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwJB+ErCU7gIoVS72cLS5aDJ9CE46R/qrTIZTPh40Q6nkI4tD7VmI/uw3pTc9G/8P
	 dElSyw9SVIdVMnsfkmkxoGTber3u/v+edw4ELgLS+Ey+cFjMBQ6+yXcw6fjlPgP9LW
	 Ap2Dt3/20GAHqxLK69WCwgK9T25rYRB95Qw7c9ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 472/770] NFSD: Skip extra computation for RC_NOCACHE case
Date: Tue, 18 Jun 2024 14:35:25 +0200
Message-ID: <20240618123425.533007614@linuxfoundation.org>
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

[ Upstream commit 0f29ce32fbc56cfdb304eec8a4deb920ccfd89c3 ]

Force the compiler to skip unneeded initialization for cases that
don't need those values. For example, NFSv4 COMPOUND operations are
RC_NOCACHE.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfscache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index f79790d367288..34087a7e4f93c 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -421,10 +421,10 @@ nfsd_cache_insert(struct nfsd_drc_bucket *b, struct svc_cacherep *key,
  */
 int nfsd_cache_lookup(struct svc_rqst *rqstp)
 {
-	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
+	struct nfsd_net		*nn;
 	struct svc_cacherep	*rp, *found;
 	__wsum			csum;
-	struct nfsd_drc_bucket	*b = nfsd_cache_bucket_find(rqstp->rq_xid, nn);
+	struct nfsd_drc_bucket	*b;
 	int type = rqstp->rq_cachetype;
 	int rtn = RC_DOIT;
 
@@ -440,10 +440,12 @@ int nfsd_cache_lookup(struct svc_rqst *rqstp)
 	 * Since the common case is a cache miss followed by an insert,
 	 * preallocate an entry.
 	 */
+	nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	rp = nfsd_reply_cache_alloc(rqstp, csum, nn);
 	if (!rp)
 		goto out;
 
+	b = nfsd_cache_bucket_find(rqstp->rq_xid, nn);
 	spin_lock(&b->cache_lock);
 	found = nfsd_cache_insert(b, rp, nn);
 	if (found != rp) {
-- 
2.43.0



