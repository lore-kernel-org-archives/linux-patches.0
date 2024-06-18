Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F67158D72;
	Tue, 18 Jun 2024 13:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716329; cv=none; b=UoVJNf4lRNfUL04WAafOdpA/IjkTrsuNsOUnx1L+on4Jg+g0uaqFuz/UxwTEc0CkIx8ii0LqD+uaAAi6r2h0nneF98O2RMCb3fP1tP2Yyf2pwoeVX/hHCfAzXK8DoamWDFc3dHAKIDt9ghYr14mQZOOJ5q07bxgJ4gt2o4gKXT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716329; c=relaxed/simple;
	bh=6w6kMJ8ZdObNPx8O2ol88ukd6ekIhbIbUp0AfO20+ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdnhuaV7dwr+aDHSpanNlCNDU2d6eEXxse3dr1cgdHwgEwbthEI1V0vofkNUutGim7FvDPoXY8b3sHV7htS6rF+3B/vaIBp2cvpU4JZzV8KTE5cjy6vWwXC7uS/HcEMmYnzhdL6EvDCTMULAgPlH1pMPX0ZIoZcS21EUfw1dByI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XovXlX/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XovXlX/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEF7C3277B;
	Tue, 18 Jun 2024 13:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716329;
	bh=6w6kMJ8ZdObNPx8O2ol88ukd6ekIhbIbUp0AfO20+ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XovXlX/YYXN6r6UmPPtoalRdzRZprpCD0CDE61njlD2BthHdp4rKCMzVl438eNuA6
	 BP5r7xXU4tzKSQSXLyNOMEgXLcSZ3KdCyQxF29UI0U4PUCBy/tj6UPrMRgkdeaeZQ8
	 f4ptNNXiR+AIjoRfd41/EnkrvI6k5AjuOz9bZXPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 609/770] NFSD: Move copy offload callback arguments into a separate structure
Date: Tue, 18 Jun 2024 14:37:42 +0200
Message-ID: <20240618123430.795929550@linuxfoundation.org>
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

[ Upstream commit a11ada99ce93a79393dc6683d22f7915748c8f6b ]

Refactor so that CB_OFFLOAD arguments can be passed without
allocating a whole struct nfsd4_copy object. On my system (x86_64)
this removes another 96 bytes from struct nfsd4_copy.

[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 37 +++++++++++++++++------------------
 fs/nfsd/nfs4proc.c     | 44 +++++++++++++++++++++---------------------
 fs/nfsd/xdr4.h         | 11 +++++++----
 3 files changed, 47 insertions(+), 45 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index e1272a7f45220..face8908a40b1 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -679,7 +679,7 @@ static int nfs4_xdr_dec_cb_notify_lock(struct rpc_rqst *rqstp,
  *	case NFS4_OK:
  *		write_response4	coa_resok4;
  *	default:
- *	length4		coa_bytes_copied;
+ *		length4		coa_bytes_copied;
  * };
  * struct CB_OFFLOAD4args {
  *	nfs_fh4		coa_fh;
@@ -688,21 +688,22 @@ static int nfs4_xdr_dec_cb_notify_lock(struct rpc_rqst *rqstp,
  * };
  */
 static void encode_offload_info4(struct xdr_stream *xdr,
-				 __be32 nfserr,
-				 const struct nfsd4_copy *cp)
+				 const struct nfsd4_cb_offload *cbo)
 {
 	__be32 *p;
 
 	p = xdr_reserve_space(xdr, 4);
-	*p++ = nfserr;
-	if (!nfserr) {
+	*p = cbo->co_nfserr;
+	switch (cbo->co_nfserr) {
+	case nfs_ok:
 		p = xdr_reserve_space(xdr, 4 + 8 + 4 + NFS4_VERIFIER_SIZE);
 		p = xdr_encode_empty_array(p);
-		p = xdr_encode_hyper(p, cp->cp_res.wr_bytes_written);
-		*p++ = cpu_to_be32(cp->cp_res.wr_stable_how);
-		p = xdr_encode_opaque_fixed(p, cp->cp_res.wr_verifier.data,
+		p = xdr_encode_hyper(p, cbo->co_res.wr_bytes_written);
+		*p++ = cpu_to_be32(cbo->co_res.wr_stable_how);
+		p = xdr_encode_opaque_fixed(p, cbo->co_res.wr_verifier.data,
 					    NFS4_VERIFIER_SIZE);
-	} else {
+		break;
+	default:
 		p = xdr_reserve_space(xdr, 8);
 		/* We always return success if bytes were written */
 		p = xdr_encode_hyper(p, 0);
@@ -710,18 +711,16 @@ static void encode_offload_info4(struct xdr_stream *xdr,
 }
 
 static void encode_cb_offload4args(struct xdr_stream *xdr,
-				   __be32 nfserr,
-				   const struct knfsd_fh *fh,
-				   const struct nfsd4_copy *cp,
+				   const struct nfsd4_cb_offload *cbo,
 				   struct nfs4_cb_compound_hdr *hdr)
 {
 	__be32 *p;
 
 	p = xdr_reserve_space(xdr, 4);
-	*p++ = cpu_to_be32(OP_CB_OFFLOAD);
-	encode_nfs_fh4(xdr, fh);
-	encode_stateid4(xdr, &cp->cp_res.cb_stateid);
-	encode_offload_info4(xdr, nfserr, cp);
+	*p = cpu_to_be32(OP_CB_OFFLOAD);
+	encode_nfs_fh4(xdr, &cbo->co_fh);
+	encode_stateid4(xdr, &cbo->co_res.cb_stateid);
+	encode_offload_info4(xdr, cbo);
 
 	hdr->nops++;
 }
@@ -731,8 +730,8 @@ static void nfs4_xdr_enc_cb_offload(struct rpc_rqst *req,
 				    const void *data)
 {
 	const struct nfsd4_callback *cb = data;
-	const struct nfsd4_copy *cp =
-		container_of(cb, struct nfsd4_copy, cp_cb);
+	const struct nfsd4_cb_offload *cbo =
+		container_of(cb, struct nfsd4_cb_offload, co_cb);
 	struct nfs4_cb_compound_hdr hdr = {
 		.ident = 0,
 		.minorversion = cb->cb_clp->cl_minorversion,
@@ -740,7 +739,7 @@ static void nfs4_xdr_enc_cb_offload(struct rpc_rqst *req,
 
 	encode_cb_compound4args(xdr, &hdr);
 	encode_cb_sequence4args(xdr, cb, &hdr);
-	encode_cb_offload4args(xdr, cp->nfserr, &cp->fh, cp, &hdr);
+	encode_cb_offload4args(xdr, cbo, &hdr);
 	encode_cb_nops(&hdr);
 }
 
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 332fd1d0b188d..fdde7eca8d438 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1635,9 +1635,10 @@ nfsd4_cleanup_intra_ssc(struct nfsd_file *src, struct nfsd_file *dst)
 
 static void nfsd4_cb_offload_release(struct nfsd4_callback *cb)
 {
-	struct nfsd4_copy *copy = container_of(cb, struct nfsd4_copy, cp_cb);
+	struct nfsd4_cb_offload *cbo =
+		container_of(cb, struct nfsd4_cb_offload, co_cb);
 
-	nfs4_put_copy(copy);
+	kfree(cbo);
 }
 
 static int nfsd4_cb_offload_done(struct nfsd4_callback *cb,
@@ -1753,25 +1754,23 @@ static void cleanup_async_copy(struct nfsd4_copy *copy)
 	nfs4_put_copy(copy);
 }
 
-static void nfsd4_send_cb_offload(struct nfsd4_copy *copy)
+static void nfsd4_send_cb_offload(struct nfsd4_copy *copy, __be32 nfserr)
 {
-	struct nfsd4_copy *cb_copy;
+	struct nfsd4_cb_offload *cbo;
 
-	cb_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
-	if (!cb_copy)
+	cbo = kzalloc(sizeof(*cbo), GFP_KERNEL);
+	if (!cbo)
 		return;
 
-	refcount_set(&cb_copy->refcount, 1);
-	memcpy(&cb_copy->cp_res, &copy->cp_res, sizeof(copy->cp_res));
-	cb_copy->cp_clp = copy->cp_clp;
-	cb_copy->nfserr = copy->nfserr;
-	memcpy(&cb_copy->fh, &copy->fh, sizeof(copy->fh));
+	memcpy(&cbo->co_res, &copy->cp_res, sizeof(copy->cp_res));
+	memcpy(&cbo->co_fh, &copy->fh, sizeof(copy->fh));
+	cbo->co_nfserr = nfserr;
 
-	nfsd4_init_cb(&cb_copy->cp_cb, cb_copy->cp_clp,
-			&nfsd4_cb_offload_ops, NFSPROC4_CLNT_CB_OFFLOAD);
-	trace_nfsd_cb_offload(copy->cp_clp, &copy->cp_res.cb_stateid,
-			      &copy->fh, copy->cp_count, copy->nfserr);
-	nfsd4_run_cb(&cb_copy->cp_cb);
+	nfsd4_init_cb(&cbo->co_cb, copy->cp_clp, &nfsd4_cb_offload_ops,
+		      NFSPROC4_CLNT_CB_OFFLOAD);
+	trace_nfsd_cb_offload(copy->cp_clp, &cbo->co_res.cb_stateid,
+			      &cbo->co_fh, copy->cp_count, nfserr);
+	nfsd4_run_cb(&cbo->co_cb);
 }
 
 /**
@@ -1784,6 +1783,7 @@ static void nfsd4_send_cb_offload(struct nfsd4_copy *copy)
 static int nfsd4_do_async_copy(void *data)
 {
 	struct nfsd4_copy *copy = (struct nfsd4_copy *)data;
+	__be32 nfserr;
 
 	if (nfsd4_ssc_is_inter(copy)) {
 		struct file *filp;
@@ -1791,21 +1791,21 @@ static int nfsd4_do_async_copy(void *data)
 		filp = nfs42_ssc_open(copy->ss_mnt, &copy->c_fh,
 				      &copy->stateid);
 		if (IS_ERR(filp)) {
-			copy->nfserr = nfserr_offload_denied;
+			nfserr = nfserr_offload_denied;
 			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
-		copy->nfserr = nfsd4_do_copy(copy, filp,
-					     copy->nf_dst->nf_file, false);
+		nfserr = nfsd4_do_copy(copy, filp, copy->nf_dst->nf_file,
+				       false);
 		nfsd4_cleanup_inter_ssc(copy->ss_mnt, filp, copy->nf_dst);
 	} else {
-		copy->nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
-					     copy->nf_dst->nf_file, false);
+		nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
+				       copy->nf_dst->nf_file, false);
 		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 
 do_callback:
-	nfsd4_send_cb_offload(copy);
+	nfsd4_send_cb_offload(copy, nfserr);
 	cleanup_async_copy(copy);
 	return 0;
 }
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 1f6ac92bcf856..3b9e60249aea9 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -533,6 +533,13 @@ struct nfsd42_write_res {
 	stateid_t		cb_stateid;
 };
 
+struct nfsd4_cb_offload {
+	struct nfsd4_callback	co_cb;
+	struct nfsd42_write_res	co_res;
+	__be32			co_nfserr;
+	struct knfsd_fh		co_fh;
+};
+
 struct nfsd4_copy {
 	/* request */
 	stateid_t		cp_src_stateid;
@@ -550,10 +557,6 @@ struct nfsd4_copy {
 
 	/* response */
 	struct nfsd42_write_res	cp_res;
-
-	/* for cb_offload */
-	struct nfsd4_callback	cp_cb;
-	__be32			nfserr;
 	struct knfsd_fh		fh;
 
 	struct nfs4_client      *cp_clp;
-- 
2.43.0



