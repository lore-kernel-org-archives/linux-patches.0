Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF9637524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302562; cv=none; b=p+j01BK+q0qyCEKNzGlPhYDLOPOUYzHy3OaI517OIFV/jQnX1M5C11c/JEaGDnjMUNztu1QZOa9FRzkhnCfPwqwVh9iy88afZHhrP5thAiNuAqnZMgYdo8EPU+RQ+EIdUiJZKCSHGwTtM3VQOm7Iua+2y+0ltNSDDI0IEQZref8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302562; c=relaxed/simple;
	bh=JjjthuMcvXNmiNBflfNBxy4fyyTQBaqqfGbiGKfnSXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAMJPo675vruo8VxywNXaJo83ptNXpnPrYw6Cpa/btF0fouW9bHCtvdpRr6zbV+ygUiE6PKa/+IoMGstOxO88SPvbz+F1zX7xTFKc06Q425G+73e4Uq7fZsyjsc0hqTlM4/P6HIWsz9/OToIwbQQ6S7t9B5iqhrfg5tkQ7jsEkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uJrnWWHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJrnWWHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED007C19423;
	Sat, 28 Feb 2026 18:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302562;
	bh=JjjthuMcvXNmiNBflfNBxy4fyyTQBaqqfGbiGKfnSXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJrnWWHXglE5UW3qmS1sYQkL8ChEfIfY6agBaF4F+fuNTgI2Cz8ji6wYYWMvKDOrN
	 FYobQtKCv5cu4ifo3zsrxf6LCXyyGcB28kz3hLWdi2K2+t7cKZP87t3WpHoJUwkfyC
	 6l/alMFbatPMBYwxT2I6tFmmLNplUMErYTg/NnZXUoCjwTq7XD4POpOKgEsuZd9a/z
	 fJxQWbtv0EiAIu3HUvqG7Pe0TMlelHlfhS3jCOLl14g65kQ2PEzjpBOvWHp2lyOyJi
	 jBUPyHe81sECgDPxZVWTUxbqOiSbrmR2yaFm+JbGE3fup433aouJKoqSjOBnC7CnPe
	 M0xcilZAy9ZsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anthony Iliopoulos <ailiop@suse.com>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/164] nfsd: never defer requests during idmap lookup
Date: Sat, 28 Feb 2026 13:13:27 -0500
Message-ID: <20260228181505.1600663-68-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 717e400b16b86..21e5b4c990ef3 100644
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
index 2d6e88f3370bf..7a85817fa5bfe 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2717,8 +2717,6 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	BUG_ON(cstate->replay_owner);
 out:
 	cstate->status = status;
-	/* Reset deferral mechanism for RPC deferrals */
-	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9e25079804732..46a7fd731ba0a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5500,6 +5500,22 @@ nfs4svc_decode_compoundargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
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

