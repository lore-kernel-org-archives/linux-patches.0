Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D899A18DB2A;
	Wed, 25 Feb 2026 01:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983214; cv=none; b=KMad4Mp+p5P2Drma8bfRPhoHg0Bx3kiF3k1DLLoKYFDskCSn+JK5ZlAPd5yKKJlKOJ7aBnNO8PXaz9TSKF6zyeKgL6M9HC+eh+NMG+eY6R6o00sCbWWVqcS15vSWRp6ckTRnLuTVB1TZNo2AWhBPXDiKWUsNEa3ah4FHFj/5uUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983214; c=relaxed/simple;
	bh=RU//DBNy43mBR2b6xVbEUWoKkwbqlRwztNYlLiHnSZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URPXjUKyMrf/RhNTT0FOFeEO8pMJ/9fmwKn4eRGpUuNexa4Tj6xofXFWZJsOqGR0lX5P3zuIz+04KwyrHM5JW8pZQFHOdLI/YE6wzGCk/OGL5ZTLv0owU14U16lwZUEL/UQ/rO0mGRWqzwIaorn8TX2ZGch4uW9Vr4wqsvCVy4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFnkqCnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFnkqCnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9165AC116D0;
	Wed, 25 Feb 2026 01:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983214;
	bh=RU//DBNy43mBR2b6xVbEUWoKkwbqlRwztNYlLiHnSZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFnkqCnL6z8iaXdtVcvrjw9qapKBKh9n/aF4fq3ZRQxl6pp756bFjBI3+ZqwY38/z
	 V23PXpqYgJ0jKwNVzZGOFOiEjQUfK1R9tw8v9BKnsf4Dbl3I+C/WasnCXfWl5CBvqs
	 VBQA+5XkhuIHnupO/I5eZZoTKtmRSEAGhunl4yQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 363/781] nfsd: never defer requests during idmap lookup
Date: Tue, 24 Feb 2026 17:17:52 -0800
Message-ID: <20260225012408.586215217@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit f9c206cdc4266caad6a9a7f46341420a10f03ccb ]

During v4 request compound arg decoding, some ops (e.g. SETATTR)
can trigger idmap lookup upcalls. When those upcall responses get
delayed beyond the allowed time limit, cache_check() will mark the
request for deferral and cause it to be dropped.

This prevents nfs4svc_encode_compoundres from being executed, and
thus the session slot flag NFSD4_SLOT_INUSE never gets cleared.
Subsequent client requests will fail with NFSERR_JUKEBOX, given
that the slot will be marked as in-use, making the SEQUENCE op
fail.

Fix this by making sure that the RQ_USEDEFERRAL flag is always
clear during nfs4svc_decode_compoundargs(), since no v4 request
should ever be deferred.

Fixes: 2f425878b6a7 ("nfsd: don't use the deferral service, return NFS4ERR_DELAY")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4idmap.c | 48 +++++++++++++++++++++++++++++++++++++++------
 fs/nfsd/nfs4proc.c  |  2 --
 fs/nfsd/nfs4xdr.c   | 16 +++++++++++++++
 3 files changed, 58 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index 8cca1329f3485..b5b3d45979c9b 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -643,13 +643,31 @@ static __be32 encode_name_from_id(struct xdr_stream *xdr,
 	return idmap_id_to_name(xdr, rqstp, type, id);
 }
 
-__be32
-nfsd_map_name_to_uid(struct svc_rqst *rqstp, const char *name, size_t namelen,
-		kuid_t *uid)
+/**
+ * nfsd_map_name_to_uid - Map user@domain to local UID
+ * @rqstp: RPC execution context
+ * @name: user@domain name to be mapped
+ * @namelen: length of name, in bytes
+ * @uid: OUT: mapped local UID value
+ *
+ * Returns nfs_ok on success or an NFSv4 status code on failure.
+ */
+__be32 nfsd_map_name_to_uid(struct svc_rqst *rqstp, const char *name,
+			    size_t namelen, kuid_t *uid)
 {
 	__be32 status;
 	u32 id = -1;
 
+	/*
+	 * The idmap lookup below triggers an upcall that invokes
+	 * cache_check(). RQ_USEDEFERRAL must be clear to prevent
+	 * cache_check() from setting RQ_DROPME via svc_defer().
+	 * NFSv4 servers are not permitted to drop requests. Also
+	 * RQ_DROPME will force NFSv4.1 session slot processing to
+	 * be skipped.
+	 */
+	WARN_ON_ONCE(test_bit(RQ_USEDEFERRAL, &rqstp->rq_flags));
+
 	if (name == NULL || namelen == 0)
 		return nfserr_inval;
 
@@ -660,13 +678,31 @@ nfsd_map_name_to_uid(struct svc_rqst *rqstp, const char *name, size_t namelen,
 	return status;
 }
 
-__be32
-nfsd_map_name_to_gid(struct svc_rqst *rqstp, const char *name, size_t namelen,
-		kgid_t *gid)
+/**
+ * nfsd_map_name_to_gid - Map user@domain to local GID
+ * @rqstp: RPC execution context
+ * @name: user@domain name to be mapped
+ * @namelen: length of name, in bytes
+ * @gid: OUT: mapped local GID value
+ *
+ * Returns nfs_ok on success or an NFSv4 status code on failure.
+ */
+__be32 nfsd_map_name_to_gid(struct svc_rqst *rqstp, const char *name,
+			    size_t namelen, kgid_t *gid)
 {
 	__be32 status;
 	u32 id = -1;
 
+	/*
+	 * The idmap lookup below triggers an upcall that invokes
+	 * cache_check(). RQ_USEDEFERRAL must be clear to prevent
+	 * cache_check() from setting RQ_DROPME via svc_defer().
+	 * NFSv4 servers are not permitted to drop requests. Also
+	 * RQ_DROPME will force NFSv4.1 session slot processing to
+	 * be skipped.
+	 */
+	WARN_ON_ONCE(test_bit(RQ_USEDEFERRAL, &rqstp->rq_flags));
+
 	if (name == NULL || namelen == 0)
 		return nfserr_inval;
 
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 9ec08dd4fe823..f780024f9a088 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -3011,8 +3011,6 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	BUG_ON(cstate->replay_owner);
 out:
 	cstate->status = status;
-	/* Reset deferral mechanism for RPC deferrals */
-	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 51ef97c254568..5065727204b95 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -6013,6 +6013,22 @@ nfs4svc_decode_compoundargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 	args->ops = args->iops;
 	args->rqstp = rqstp;
 
+	/*
+	 * NFSv4 operation decoders can invoke svc cache lookups
+	 * that trigger svc_defer() when RQ_USEDEFERRAL is set,
+	 * setting RQ_DROPME. This creates two problems:
+	 *
+	 * 1. Non-idempotency: Compounds make it too hard to avoid
+	 *    problems if a request is deferred and replayed.
+	 *
+	 * 2. Session slot leakage (NFSv4.1+): If RQ_DROPME is set
+	 *    during decode but SEQUENCE executes successfully, the
+	 *    session slot will be marked INUSE. The request is then
+	 *    dropped before encoding, so the slot is never released,
+	 *    rendering it permanently unusable by the client.
+	 */
+	clear_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+
 	return nfsd4_decode_compound(args);
 }
 
-- 
2.51.0



