Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB307317D;
	Mon,  8 Apr 2024 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583637; cv=none; b=KZaHhqW7DX6hQOrEN1dwzzWGOFknAG4xyd1E+8h2qcuUKVIgM6nP+vx+uVE7US9S8HnItKGI1Kp8kpPb57LkK/wYhyYqQpiJNkb6iRw9vwkTwwoI853/0+rLhvbRV8oFDC4eND16+epLFblMSqNq2DbcQWkR6tkUXW8Lc5ZeRIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583637; c=relaxed/simple;
	bh=NWjxinMzkptG89dtxECLL31tPcGnW0GQS0g/67MJcIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la8wAz+KUyQkyk0NzHlNvXrLP2VxfTZZS0Q/WXn64AqHx0rZw+coA/WbYILFxZ1oNquCAl6sEvNjyacqfqjuZOezNa3p/vd1w8QklbW2aIt1BLoNggOuM2KDg+bvE89Xz9lcQuhaC2w7UvGCnbAXGx5XKB6paXcF+FF9Guez46w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9/BLzSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9/BLzSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED02CC433C7;
	Mon,  8 Apr 2024 13:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583637;
	bh=NWjxinMzkptG89dtxECLL31tPcGnW0GQS0g/67MJcIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9/BLzSvhfR5zMQbpI3oL4FJ/kLKQ7q13H6EJZrAnDtATUZ0nb0Y0kgfDR1x4N6+H
	 Tq2IBFDpVJnU7WgdBLmhquXwZezogeOCeCcgboma5nAKk10M7fzuhV75keXMYIWYRP
	 1rLAtsNMRhohc94jhaeDvCFQtqDeUSjg8E8HqxnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 269/690] NFSD: Skip extra computation for RC_NOCACHE case
Date: Mon,  8 Apr 2024 14:52:15 +0200
Message-ID: <20240408125409.365391874@linuxfoundation.org>
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

[ Upstream commit 0f29ce32fbc56cfdb304eec8a4deb920ccfd89c3 ]

Force the compiler to skip unneeded initialization for cases that
don't need those values. For example, NFSv4 COMPOUND operations are
RC_NOCACHE.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfscache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 7880a2f2d29f6..1523d2e3dae97 100644
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



