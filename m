Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C333839B2;
	Sat, 17 Oct 2026 17:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259812; cv=none; b=nRercyIhXH8vZMSxyN0UyffhC4kdtj1WP91boiJ7nosqbqicJP5tJlsPWEs99GErrjYPlrcxWI594QmBXOEr13vu2pwQXKdtSexAo61a151KRQ0xKxmE+nW568d9ucSSQlsDXrq00ol7lS3ENTRIRQC2gywITm93telRzey/LO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259812; c=relaxed/simple;
	bh=Gy67I0SWv8jj4y1kp/jGqqMScOSI8MEVjyAhV0hDYNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8rXa4n8SxE617fauN3ZmwhyY894SmJIWHYm5wDn/fUswT7DgMLetZpKl0IzB4QCX/7u0P67Z5K0qWciKWSCc6qlfSQGKhDfxM+Y4WfA01fhz0Ez4Krow7lF8ZcFE6RdFl1seS5in2ivR71MS3lRTfEsBxUIV3fv8s8MUGADSNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4aQQtMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4aQQtMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CDD1F000C5;
	Sat, 17 Oct 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259811;
	bh=cGaypskIPUA/s8nbcpUhGfashtjDpOuj6bJCQkx5OMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4aQQtMKgGPs+CywAcg0Hl5d1yPzd6Bu5YQYUbKj0lfZwgQtikssqQrDxvCLuAcUr
	 7OLfww2voOBsmHtiFDRBRz8JpwY3kiQDMDISMOYJESqoyWJ+QTCZJqiNdnwxyVzDG2
	 4btChvyPWRsZH9MtFO8b/FrTByOX6VkObgdiUHxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1321/1674] NFSD: Clean up nfsd4_encode_stateid()
Date: Sat, 17 Oct 2026 17:59:53 +0200
Message-ID: <20261017160505.054448267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 40bb2baaa8edecfc21a3c176e4af1a3445157677 ]

Update the encoder function name to match the type name, as is the
convention with other such encoder utility functions, and with
nfsd4_decode_stateid4().

Make the @stateid argument a const so that callers of
nfsd4_encode_stateid4() in the future can be passed const pointers
to structures.

Since the compiler is allowed to add padding to structs, use the
wire (spec-defined) size when reserving buffer space.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: ca94ba361720 ("nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on racing delegation revoke")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9fe19a889ae69..5b7c944fa1297 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3730,18 +3730,18 @@ nfsd4_encode_clientid4(struct xdr_stream *xdr, const clientid_t *clientid)
 	return nfs_ok;
 }
 
+/* This is a frequently-encoded item; open-coded for speed */
 static __be32
-nfsd4_encode_stateid(struct xdr_stream *xdr, stateid_t *sid)
+nfsd4_encode_stateid4(struct xdr_stream *xdr, const stateid_t *sid)
 {
 	__be32 *p;
 
-	p = xdr_reserve_space(xdr, sizeof(stateid_t));
+	p = xdr_reserve_space(xdr, NFS4_STATEID_SIZE);
 	if (!p)
 		return nfserr_resource;
 	*p++ = cpu_to_be32(sid->si_generation);
-	p = xdr_encode_opaque_fixed(p, &sid->si_opaque,
-					sizeof(stateid_opaque_t));
-	return 0;
+	memcpy(p, &sid->si_opaque, sizeof(sid->si_opaque));
+	return nfs_ok;
 }
 
 static __be32
@@ -3785,7 +3785,8 @@ nfsd4_encode_close(struct nfsd4_compoundres *resp, __be32 nfserr,
 	struct nfsd4_close *close = &u->close;
 	struct xdr_stream *xdr = resp->xdr;
 
-	return nfsd4_encode_stateid(xdr, &close->cl_stateid);
+	/* open_stateid */
+	return nfsd4_encode_stateid4(xdr, &close->cl_stateid);
 }
 
 
@@ -3889,7 +3890,7 @@ nfsd4_encode_lock(struct nfsd4_compoundres *resp, __be32 nfserr,
 	struct xdr_stream *xdr = resp->xdr;
 
 	if (!nfserr)
-		nfserr = nfsd4_encode_stateid(xdr, &lock->lk_resp_stateid);
+		nfserr = nfsd4_encode_stateid4(xdr, &lock->lk_resp_stateid);
 	else if (nfserr == nfserr_denied)
 		nfserr = nfsd4_encode_lock_denied(xdr, &lock->lk_denied);
 
@@ -3915,7 +3916,8 @@ nfsd4_encode_locku(struct nfsd4_compoundres *resp, __be32 nfserr,
 	struct nfsd4_locku *locku = &u->locku;
 	struct xdr_stream *xdr = resp->xdr;
 
-	return nfsd4_encode_stateid(xdr, &locku->lu_stateid);
+	/* lock_stateid */
+	return nfsd4_encode_stateid4(xdr, &locku->lu_stateid);
 }
 
 
@@ -3938,7 +3940,7 @@ nfsd4_encode_open(struct nfsd4_compoundres *resp, __be32 nfserr,
 	struct xdr_stream *xdr = resp->xdr;
 	__be32 *p;
 
-	nfserr = nfsd4_encode_stateid(xdr, &open->op_stateid);
+	nfserr = nfsd4_encode_stateid4(xdr, &open->op_stateid);
 	if (nfserr)
 		return nfserr;
 	nfserr = nfsd4_encode_change_info4(xdr, &open->op_cinfo);
@@ -3961,7 +3963,7 @@ nfsd4_encode_open(struct nfsd4_compoundres *resp, __be32 nfserr,
 	case NFS4_OPEN_DELEGATE_NONE:
 		break;
 	case NFS4_OPEN_DELEGATE_READ:
-		nfserr = nfsd4_encode_stateid(xdr, &open->op_delegate_stateid);
+		nfserr = nfsd4_encode_stateid4(xdr, &open->op_delegate_stateid);
 		if (nfserr)
 			return nfserr;
 		p = xdr_reserve_space(xdr, 20);
@@ -3978,7 +3980,7 @@ nfsd4_encode_open(struct nfsd4_compoundres *resp, __be32 nfserr,
 		*p++ = cpu_to_be32(0);   /* XXX: is NULL principal ok? */
 		break;
 	case NFS4_OPEN_DELEGATE_WRITE:
-		nfserr = nfsd4_encode_stateid(xdr, &open->op_delegate_stateid);
+		nfserr = nfsd4_encode_stateid4(xdr, &open->op_delegate_stateid);
 		if (nfserr)
 			return nfserr;
 
@@ -4036,7 +4038,8 @@ nfsd4_encode_open_confirm(struct nfsd4_compoundres *resp, __be32 nfserr,
 	struct nfsd4_open_confirm *oc = &u->open_confirm;
 	struct xdr_stream *xdr = resp->xdr;
 
-	return nfsd4_encode_stateid(xdr, &oc->oc_resp_stateid);
+	/* open_stateid */
+	return nfsd4_encode_stateid4(xdr, &oc->oc_resp_stateid);
 }
 
 static __be32
@@ -4046,7 +4049,8 @@ nfsd4_encode_open_downgrade(struct nfsd4_compoundres *resp, __be32 nfserr,
 	struct nfsd4_open_downgrade *od = &u->open_downgrade;
 	struct xdr_stream *xdr = resp->xdr;
 
-	return nfsd4_encode_stateid(xdr, &od->od_stateid);
+	/* open_stateid */
+	return nfsd4_encode_stateid4(xdr, &od->od_stateid);
 }
 
 /*
@@ -4790,7 +4794,7 @@ nfsd4_encode_layoutreturn(struct nfsd4_compoundres *resp, __be32 nfserr,
 		return nfserr_resource;
 	*p++ = cpu_to_be32(lrp->lrs_present);
 	if (lrp->lrs_present)
-		return nfsd4_encode_stateid(xdr, &lrp->lr_sid);
+		return nfsd4_encode_stateid4(xdr, &lrp->lr_sid);
 	return 0;
 }
 #endif /* CONFIG_NFSD_PNFS */
@@ -4809,7 +4813,7 @@ nfsd42_encode_write_res(struct nfsd4_compoundres *resp,
 	else {
 		__be32 nfserr;
 		*p++ = cpu_to_be32(1);
-		nfserr = nfsd4_encode_stateid(resp->xdr, &write->cb_stateid);
+		nfserr = nfsd4_encode_stateid4(resp->xdr, &write->cb_stateid);
 		if (nfserr)
 			return nfserr;
 	}
@@ -4993,7 +4997,7 @@ nfsd4_encode_copy_notify(struct nfsd4_compoundres *resp, __be32 nfserr,
 	*p++ = cpu_to_be32(cn->cpn_nsec);
 
 	/* cnr_stateid */
-	nfserr = nfsd4_encode_stateid(xdr, &cn->cpn_cnr_stateid);
+	nfserr = nfsd4_encode_stateid4(xdr, &cn->cpn_cnr_stateid);
 	if (nfserr)
 		return nfserr;
 
-- 
2.53.0



