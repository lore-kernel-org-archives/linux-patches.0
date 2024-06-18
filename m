Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C564A13C675;
	Tue, 18 Jun 2024 12:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714654; cv=none; b=XX6B4bC6dArcVvz3w9ta+kNbyNwms+iOWW1NxGBZnRzY4/S0da//HU0OkEdhzPrshRln5j4+nBV+7DDLPuNFW+E2NaN0Q2mwsqAfwd3+AswdZRheCZ91/Ars5/o6dw78VAWIGBzX6B+0hieNv7P7hvWcDEvFVXkez+NqmMLVAM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714654; c=relaxed/simple;
	bh=So5lDhCUbR9zQcvqK7ve/7p6kiTp5S9M4Byt/T3zZo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ju8oAdPmR0yj/zIlhrj1nZCPuHB62nhwB6RuMAMNZ23nwAaEY5fy1MrGZLsgvXdJDsqygSrsygxZ6te/lXiHSZQmaGa5qE7hj+G04grbdcsuvhh4LhLowMuSmF7RWbho5AkdiO0woWkmuBsJVl5DdALbwovJxXQLKndKNle0E84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2cc+zK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2cc+zK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EBFC3277B;
	Tue, 18 Jun 2024 12:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714654;
	bh=So5lDhCUbR9zQcvqK7ve/7p6kiTp5S9M4Byt/T3zZo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2cc+zK5Gs9mB2mdjtqK2SF8ijTWQtamYd7BlAzjir95bSXSkkqUmdgHXDVpAuu5s
	 dpdwnHtuICfrbgm3TTy/qPJgQxAdkbSUQ1NgMWRbYURJUrFFJzyMA/A7hVhwUxxRlW
	 jfGbXNowNux9VPqB4yhL66dvHdCG6EhCP26Llw+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/770] NFSD: Add helper to decode OPENs open_claim4 argument
Date: Tue, 18 Jun 2024 14:28:17 +0200
Message-ID: <20240618123408.995426797@linuxfoundation.org>
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

[ Upstream commit 1708e50b0145f393acbec9e319bdf0e33f765d25 ]

Refactor for clarity.

Note that op_fname is the only instance of an NFSv4 filename stored
in a struct xdr_netobj. Convert it to a u32/char * pair so that the
new nfsd4_decode_filename() helper can be used.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c |  8 ++--
 fs/nfsd/nfs4xdr.c  | 95 ++++++++++++++++++++++++----------------------
 fs/nfsd/xdr4.h     |  3 +-
 3 files changed, 56 insertions(+), 50 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 95545a61bfc77..a038d1e182ff3 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -257,8 +257,8 @@ do_open_lookup(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate, stru
 		 * in NFSv4 as in v3 except EXCLUSIVE4_1.
 		 */
 		current->fs->umask = open->op_umask;
-		status = do_nfsd_create(rqstp, current_fh, open->op_fname.data,
-					open->op_fname.len, &open->op_iattr,
+		status = do_nfsd_create(rqstp, current_fh, open->op_fname,
+					open->op_fnamelen, &open->op_iattr,
 					*resfh, open->op_createmode,
 					(u32 *)open->op_verf.data,
 					&open->op_truncate, &open->op_created);
@@ -283,7 +283,7 @@ do_open_lookup(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate, stru
 		 * a chance to an acquire a delegation if appropriate.
 		 */
 		status = nfsd_lookup(rqstp, current_fh,
-				     open->op_fname.data, open->op_fname.len, *resfh);
+				     open->op_fname, open->op_fnamelen, *resfh);
 	if (status)
 		goto out;
 	status = nfsd_check_obj_isreg(*resfh);
@@ -360,7 +360,7 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	bool reclaim = false;
 
 	dprintk("NFSD: nfsd4_open filename %.*s op_openowner %p\n",
-		(int)open->op_fname.len, open->op_fname.data,
+		(int)open->op_fnamelen, open->op_fname,
 		open->op_openowner);
 
 	/* This check required by spec. */
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index a9257ec9d151d..3e0fca521c39b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1072,6 +1072,55 @@ static __be32 nfsd4_decode_share_deny(struct nfsd4_compoundargs *argp, u32 *x)
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_open_claim4(struct nfsd4_compoundargs *argp,
+			 struct nfsd4_open *open)
+{
+	__be32 status;
+
+	if (xdr_stream_decode_u32(argp->xdr, &open->op_claim_type) < 0)
+		return nfserr_bad_xdr;
+	switch (open->op_claim_type) {
+	case NFS4_OPEN_CLAIM_NULL:
+	case NFS4_OPEN_CLAIM_DELEGATE_PREV:
+		status = nfsd4_decode_component4(argp, &open->op_fname,
+						 &open->op_fnamelen);
+		if (status)
+			return status;
+		break;
+	case NFS4_OPEN_CLAIM_PREVIOUS:
+		if (xdr_stream_decode_u32(argp->xdr, &open->op_delegate_type) < 0)
+			return nfserr_bad_xdr;
+		break;
+	case NFS4_OPEN_CLAIM_DELEGATE_CUR:
+		status = nfsd4_decode_stateid4(argp, &open->op_delegate_stateid);
+		if (status)
+			return status;
+		status = nfsd4_decode_component4(argp, &open->op_fname,
+						 &open->op_fnamelen);
+		if (status)
+			return status;
+		break;
+	case NFS4_OPEN_CLAIM_FH:
+	case NFS4_OPEN_CLAIM_DELEG_PREV_FH:
+		if (argp->minorversion < 1)
+			return nfserr_bad_xdr;
+		/* void */
+		break;
+	case NFS4_OPEN_CLAIM_DELEG_CUR_FH:
+		if (argp->minorversion < 1)
+			return nfserr_bad_xdr;
+		status = nfsd4_decode_stateid4(argp, &open->op_delegate_stateid);
+		if (status)
+			return status;
+		break;
+	default:
+		return nfserr_bad_xdr;
+	}
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 {
@@ -1102,51 +1151,7 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 	status = nfsd4_decode_openflag4(argp, open);
 	if (status)
 		return status;
-
-	/* open_claim */
-	READ_BUF(4);
-	open->op_claim_type = be32_to_cpup(p++);
-	switch (open->op_claim_type) {
-	case NFS4_OPEN_CLAIM_NULL:
-	case NFS4_OPEN_CLAIM_DELEGATE_PREV:
-		READ_BUF(4);
-		open->op_fname.len = be32_to_cpup(p++);
-		READ_BUF(open->op_fname.len);
-		SAVEMEM(open->op_fname.data, open->op_fname.len);
-		if ((status = check_filename(open->op_fname.data, open->op_fname.len)))
-			return status;
-		break;
-	case NFS4_OPEN_CLAIM_PREVIOUS:
-		READ_BUF(4);
-		open->op_delegate_type = be32_to_cpup(p++);
-		break;
-	case NFS4_OPEN_CLAIM_DELEGATE_CUR:
-		status = nfsd4_decode_stateid(argp, &open->op_delegate_stateid);
-		if (status)
-			return status;
-		READ_BUF(4);
-		open->op_fname.len = be32_to_cpup(p++);
-		READ_BUF(open->op_fname.len);
-		SAVEMEM(open->op_fname.data, open->op_fname.len);
-		if ((status = check_filename(open->op_fname.data, open->op_fname.len)))
-			return status;
-		break;
-	case NFS4_OPEN_CLAIM_FH:
-	case NFS4_OPEN_CLAIM_DELEG_PREV_FH:
-		if (argp->minorversion < 1)
-			goto xdr_error;
-		/* void */
-		break;
-	case NFS4_OPEN_CLAIM_DELEG_CUR_FH:
-		if (argp->minorversion < 1)
-			goto xdr_error;
-		status = nfsd4_decode_stateid(argp, &open->op_delegate_stateid);
-		if (status)
-			return status;
-		break;
-	default:
-		goto xdr_error;
-	}
+	status = nfsd4_decode_open_claim4(argp, open);
 
 	DECODE_TAIL;
 }
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 0eb13bd603ea6..6245004a9993b 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -252,7 +252,8 @@ struct nfsd4_listxattrs {
 
 struct nfsd4_open {
 	u32		op_claim_type;      /* request */
-	struct xdr_netobj op_fname;	    /* request - everything but CLAIM_PREV */
+	u32		op_fnamelen;
+	char *		op_fname;	    /* request - everything but CLAIM_PREV */
 	u32		op_delegate_type;   /* request - CLAIM_PREV only */
 	stateid_t       op_delegate_stateid; /* request - response */
 	u32		op_why_no_deleg;    /* response - DELEG_NONE_EXT only */
-- 
2.43.0



