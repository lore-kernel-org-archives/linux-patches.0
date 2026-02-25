Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AEB1E2834;
	Wed, 25 Feb 2026 01:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984029; cv=none; b=IYiqi0LLkkBlf7oxOeyyREtBhPyqVGs3Tqki1jwqfhndthagmwmzDbMaPC7BBoLxD8vGjIbJcWq2miNZ7oisLzdoGUtbhxfvo2xhrrzSXEt596mtDypwGYvNLXeVltJEvj2+UvjV5sT77mIC2wn7aWy1AsgVx3XEnH1CFUCDew4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984029; c=relaxed/simple;
	bh=/W8roA8HR0CsODb2KDU/EcPTXtIeFcyhTLrELGCTrc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKlU1pnG1+c8RaK9Hkdaz2BxqzBqDSyVOm1cy3R26RPo6fY5VMo6bCY+Zx2MpCJS16lqvPaLloYyTkP2mtEENX9Ye8tNhHpiVOH484MHz5wOsm+WCe9oKFbe28ZfVIj9GqA6YrTNWFwz31zMPwRVGX8FQkC1f2T3f6T8Zlazo7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dA8PLcKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dA8PLcKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0947CC116D0;
	Wed, 25 Feb 2026 01:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984029;
	bh=/W8roA8HR0CsODb2KDU/EcPTXtIeFcyhTLrELGCTrc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dA8PLcKB8pEXXk3KekvscxLF+e+pXo+oPdfOcsMTuI6Deqpjf8PcA7akzBZ72Gfh5
	 PlIv+9mhu5aqJy+EZA6qfgHEP9hO7khQcA8NXwv/A8xopXT1zH7D9GxI+z4brEmYAc
	 5VM9kTasiX7FNMavd+YFsTe+DUBS9B7Ko/73wzww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/641] nfsd: never defer requests during idmap lookup
Date: Tue, 24 Feb 2026 17:20:00 -0800
Message-ID: <20260225012355.435599152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 42a6b914c0fe6..8dada7ef97cb1 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2995,8 +2995,6 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	BUG_ON(cstate->replay_owner);
 out:
 	cstate->status = status;
-	/* Reset deferral mechanism for RPC deferrals */
-	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4a403ce4fd468..5f046d5be4a6e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -6001,6 +6001,22 @@ nfs4svc_decode_compoundargs(struct svc_rqst *rqstp, struct xdr_stream *xdr)
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



