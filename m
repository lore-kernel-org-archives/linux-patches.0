Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BA413D528;
	Tue, 18 Jun 2024 13:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716774; cv=none; b=UFUeo9DIccOCJNf0gI0N8Tiiarky1HVSnl6dfd2xsfoZySnUiW5ljSpHlXFe90GyNdMH1NltTYk0M56k5TT0fVm/hMui4w7QWpKThBFrKIYfYdgPIc+1S9ZU7nyXNHf2Ph1VlMSg4MJMFas6QuSrSinhuEWk2uCiuZ7ysRdjAFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716774; c=relaxed/simple;
	bh=ngdEodPDGZzNtO7hSQitlR5dxFXancfrV5HUI07mel4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rt121mJJl8OgSJtEmENfDjywVCnFkVNaYwMObvaDmebHIcNKup3MK5NyjNf2LPCRig+YFb28iB24lTatVz+u7dwie2hW8tTJ678vKX3lYtvptvqPDeqqTA7CZZuaUUP6RbcKF5oXAJ2PU1AmdNFIMedK5C1h8Zi24QhpBIdmQy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ewwXdTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ewwXdTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5385C3277B;
	Tue, 18 Jun 2024 13:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716774;
	bh=ngdEodPDGZzNtO7hSQitlR5dxFXancfrV5HUI07mel4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ewwXdTe0bVj7h7xk+Bl+dfwQnk1mCDmZQBoVLJvGrz1bIhr0iNKq4HERsiDYGnEm
	 5v3zMiHsWIIa0t61kAoa2Nvbl/sELdXOJQnAVj4lEI9c1g6BS/HX/d0CoJpkH4h9Nu
	 xVrw9hDnqj6fvsoYnX30jfWvhr6i/mSftn3oxTLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 717/770] NFSD: add support for sending CB_RECALL_ANY
Date: Tue, 18 Jun 2024 14:39:30 +0200
Message-ID: <20240618123434.947602792@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 3959066b697b5dfbb7141124ae9665337d4bc638 ]

Add XDR encode and decode function for CB_RECALL_ANY.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 72 ++++++++++++++++++++++++++++++++++++++++++
 fs/nfsd/state.h        |  1 +
 fs/nfsd/xdr4.h         |  5 +++
 fs/nfsd/xdr4cb.h       |  6 ++++
 4 files changed, 84 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 39989c14c8a1e..4eae2c5af2edf 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -76,6 +76,17 @@ static __be32 *xdr_encode_empty_array(__be32 *p)
  * 1 Protocol"
  */
 
+static void encode_uint32(struct xdr_stream *xdr, u32 n)
+{
+	WARN_ON_ONCE(xdr_stream_encode_u32(xdr, n) < 0);
+}
+
+static void encode_bitmap4(struct xdr_stream *xdr, const __u32 *bitmap,
+			   size_t len)
+{
+	WARN_ON_ONCE(xdr_stream_encode_uint32_array(xdr, bitmap, len) < 0);
+}
+
 /*
  *	nfs_cb_opnum4
  *
@@ -328,6 +339,24 @@ static void encode_cb_recall4args(struct xdr_stream *xdr,
 	hdr->nops++;
 }
 
+/*
+ * CB_RECALLANY4args
+ *
+ *	struct CB_RECALLANY4args {
+ *		uint32_t	craa_objects_to_keep;
+ *		bitmap4		craa_type_mask;
+ *	};
+ */
+static void
+encode_cb_recallany4args(struct xdr_stream *xdr,
+	struct nfs4_cb_compound_hdr *hdr, struct nfsd4_cb_recall_any *ra)
+{
+	encode_nfs_cb_opnum4(xdr, OP_CB_RECALL_ANY);
+	encode_uint32(xdr, ra->ra_keep);
+	encode_bitmap4(xdr, ra->ra_bmval, ARRAY_SIZE(ra->ra_bmval));
+	hdr->nops++;
+}
+
 /*
  * CB_SEQUENCE4args
  *
@@ -482,6 +511,26 @@ static void nfs4_xdr_enc_cb_recall(struct rpc_rqst *req, struct xdr_stream *xdr,
 	encode_cb_nops(&hdr);
 }
 
+/*
+ * 20.6. Operation 8: CB_RECALL_ANY - Keep Any N Recallable Objects
+ */
+static void
+nfs4_xdr_enc_cb_recall_any(struct rpc_rqst *req,
+		struct xdr_stream *xdr, const void *data)
+{
+	const struct nfsd4_callback *cb = data;
+	struct nfsd4_cb_recall_any *ra;
+	struct nfs4_cb_compound_hdr hdr = {
+		.ident = cb->cb_clp->cl_cb_ident,
+		.minorversion = cb->cb_clp->cl_minorversion,
+	};
+
+	ra = container_of(cb, struct nfsd4_cb_recall_any, ra_cb);
+	encode_cb_compound4args(xdr, &hdr);
+	encode_cb_sequence4args(xdr, cb, &hdr);
+	encode_cb_recallany4args(xdr, &hdr, ra);
+	encode_cb_nops(&hdr);
+}
 
 /*
  * NFSv4.0 and NFSv4.1 XDR decode functions
@@ -520,6 +569,28 @@ static int nfs4_xdr_dec_cb_recall(struct rpc_rqst *rqstp,
 	return decode_cb_op_status(xdr, OP_CB_RECALL, &cb->cb_status);
 }
 
+/*
+ * 20.6. Operation 8: CB_RECALL_ANY - Keep Any N Recallable Objects
+ */
+static int
+nfs4_xdr_dec_cb_recall_any(struct rpc_rqst *rqstp,
+				  struct xdr_stream *xdr,
+				  void *data)
+{
+	struct nfsd4_callback *cb = data;
+	struct nfs4_cb_compound_hdr hdr;
+	int status;
+
+	status = decode_cb_compound4res(xdr, &hdr);
+	if (unlikely(status))
+		return status;
+	status = decode_cb_sequence4res(xdr, cb);
+	if (unlikely(status || cb->cb_seq_status))
+		return status;
+	status =  decode_cb_op_status(xdr, OP_CB_RECALL_ANY, &cb->cb_status);
+	return status;
+}
+
 #ifdef CONFIG_NFSD_PNFS
 /*
  * CB_LAYOUTRECALL4args
@@ -783,6 +854,7 @@ static const struct rpc_procinfo nfs4_cb_procedures[] = {
 #endif
 	PROC(CB_NOTIFY_LOCK,	COMPOUND,	cb_notify_lock,	cb_notify_lock),
 	PROC(CB_OFFLOAD,	COMPOUND,	cb_offload,	cb_offload),
+	PROC(CB_RECALL_ANY,	COMPOUND,	cb_recall_any,	cb_recall_any),
 };
 
 static unsigned int nfs4_cb_counts[ARRAY_SIZE(nfs4_cb_procedures)];
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index eadd7f465bf52..e30882f8b8516 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -636,6 +636,7 @@ enum nfsd4_cb_op {
 	NFSPROC4_CLNT_CB_OFFLOAD,
 	NFSPROC4_CLNT_CB_SEQUENCE,
 	NFSPROC4_CLNT_CB_NOTIFY_LOCK,
+	NFSPROC4_CLNT_CB_RECALL_ANY,
 };
 
 /* Returns true iff a is later than b: */
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 8f323d9071f06..24934cf90a84f 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -896,6 +896,11 @@ struct nfsd4_operation {
 			union nfsd4_op_u *);
 };
 
+struct nfsd4_cb_recall_any {
+	struct nfsd4_callback	ra_cb;
+	u32			ra_keep;
+	u32			ra_bmval[1];
+};
 
 #endif
 
diff --git a/fs/nfsd/xdr4cb.h b/fs/nfsd/xdr4cb.h
index 547cf07cf4e08..0d39af1b00a0f 100644
--- a/fs/nfsd/xdr4cb.h
+++ b/fs/nfsd/xdr4cb.h
@@ -48,3 +48,9 @@
 #define NFS4_dec_cb_offload_sz		(cb_compound_dec_hdr_sz  +      \
 					cb_sequence_dec_sz +            \
 					op_dec_sz)
+#define NFS4_enc_cb_recall_any_sz	(cb_compound_enc_hdr_sz +       \
+					cb_sequence_enc_sz +            \
+					1 + 1 + 1)
+#define NFS4_dec_cb_recall_any_sz	(cb_compound_dec_hdr_sz  +      \
+					cb_sequence_dec_sz +            \
+					op_dec_sz)
-- 
2.43.0



