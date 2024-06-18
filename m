Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BAA15B570;
	Tue, 18 Jun 2024 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714727; cv=none; b=TRVMJrLZSv3EiGG0lTDi/8toEpbA0Q9bEz4EmMOyllKkCOkvKVvyauaD4wv8bxrIR0ZsU/jsm0EnrIZ7rclcF/DK7QyAFWmtPFHojXVCZ8RtzP/0+w64xY3Jbu63O2h8jKCGl/eZJEUNXB1tTY+CKh+qk2x97m6ukYU9wsUqjss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714727; c=relaxed/simple;
	bh=TsLcA+eXQat7m1K+naI4eKP2HlKNBrfZXdYCe9HwgUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvIygmYBq7pmMApqn441BQ/2xNRGSSiXAOin5cVHy+QdEJ4NgBrX4CbVmIa/CKUU4sJyt8VrLfXvRgc721B9fe1SBAxxfexT5BHZv7Zwnp7+td9OLlYc9+/+jaCo9Wj0akdsK/hkKDdVo+1Iatyn6s5UpvyiMXjFVJxmjxRjxp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIpA6FtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIpA6FtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D00CC3277B;
	Tue, 18 Jun 2024 12:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714725;
	bh=TsLcA+eXQat7m1K+naI4eKP2HlKNBrfZXdYCe9HwgUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIpA6FtQoQ2xX5mPKCmxlWT/dlioZDc5dinUqt853sq0d6C3DWUpnwCBX+SZCIQbX
	 F6TWH3EMzBVv4hH51nFK8oRokmjx7cLokhqN3GItAx8qeKEf9VyckY7U97VRwguZ9g
	 Uy3sUBVFYTpPDLXfA+HZQa2de59qpw7bA68MIBG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/770] NFSD: Add a helper to decode state_protect4_a
Date: Tue, 18 Jun 2024 14:28:39 +0200
Message-ID: <20240618123409.833566789@linuxfoundation.org>
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

[ Upstream commit 523ec6ed6fb80fd1537d748a06bffd060a8b3235 ]

Refactor for clarity.

Also, remove a stale comment. Commit ed94164398c9 ("nfsd: implement
machine credential support for some operations") added support for
SP4_MACH_CRED, so state_protect_a is no longer completely ignored.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c |  2 +-
 fs/nfsd/nfs4xdr.c   | 44 +++++++++++++++++++++++++++-----------------
 fs/nfsd/xdr4.h      |  2 +-
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d402ca0b535f0..e7ec7593eaaa3 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3089,7 +3089,7 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	rpc_ntop(sa, addr_str, sizeof(addr_str));
 	dprintk("%s rqstp=%p exid=%p clname.len=%u clname.data=%p "
-		"ip_addr=%s flags %x, spa_how %d\n",
+		"ip_addr=%s flags %x, spa_how %u\n",
 		__func__, rqstp, exid, exid->clname.len, exid->clname.data,
 		addr_str, exid->flags, exid->spa_how);
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 8c5701367e4af..6a4ab81e01ffc 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1531,25 +1531,13 @@ nfsd4_decode_ssv_sp_parms(struct nfsd4_compoundargs *argp,
 }
 
 static __be32
-nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
-			 struct nfsd4_exchange_id *exid)
+nfsd4_decode_state_protect4_a(struct nfsd4_compoundargs *argp,
+			      struct nfsd4_exchange_id *exid)
 {
-	DECODE_HEAD;
-	int dummy;
-
-	READ_BUF(NFS4_VERIFIER_SIZE);
-	COPYMEM(exid->verifier.data, NFS4_VERIFIER_SIZE);
+	__be32 status;
 
-	status = nfsd4_decode_opaque(argp, &exid->clname);
-	if (status)
+	if (xdr_stream_decode_u32(argp->xdr, &exid->spa_how) < 0)
 		return nfserr_bad_xdr;
-
-	READ_BUF(4);
-	exid->flags = be32_to_cpup(p++);
-
-	/* Ignore state_protect4_a */
-	READ_BUF(4);
-	exid->spa_how = be32_to_cpup(p++);
 	switch (exid->spa_how) {
 	case SP4_NONE:
 		break;
@@ -1564,9 +1552,31 @@ nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 			return status;
 		break;
 	default:
-		goto xdr_error;
+		return nfserr_bad_xdr;
 	}
 
+	return nfs_ok;
+}
+
+static __be32
+nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
+			 struct nfsd4_exchange_id *exid)
+{
+	DECODE_HEAD;
+	int dummy;
+
+	status = nfsd4_decode_verifier4(argp, &exid->verifier);
+	if (status)
+		return status;
+	status = nfsd4_decode_opaque(argp, &exid->clname);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &exid->flags) < 0)
+		return nfserr_bad_xdr;
+	status = nfsd4_decode_state_protect4_a(argp, exid);
+	if (status)
+		return status;
+
 	READ_BUF(4);    /* nfs_impl_id4 array length */
 	dummy = be32_to_cpup(p++);
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 6245004a9993b..232529bc1b798 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -433,7 +433,7 @@ struct nfsd4_exchange_id {
 	u32		flags;
 	clientid_t	clientid;
 	u32		seqid;
-	int		spa_how;
+	u32		spa_how;
 	u32             spo_must_enforce[3];
 	u32             spo_must_allow[3];
 	struct xdr_netobj nii_domain;
-- 
2.43.0



