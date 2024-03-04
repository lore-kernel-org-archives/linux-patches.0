Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBA7200D4;
	Mon,  4 Mar 2024 21:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589024; cv=none; b=fJTQC21VzXRf4aY9n3MXvCJ9TIv14N0UE1TsXx+tyyQPYPT8HgSYlC1sYnUfyznZpXtxIsjOxpODZa/+JpZ4Yw8+1KakTMS7mrwJ8EZFCcZ0v+3qX/jq19xOXKNCyitWkqGpQGYjEuLmen6ogIRBkVx6iVa5ptXl2+kn6Qqc6l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589024; c=relaxed/simple;
	bh=l4lPkSUzxhjtsRKM5mDiH7AO3RikjRcBA1iHhqCx6sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4d25DoDO8LTZlKzctWQGjhTegpp2vWFTFumDGWrFC/gZXeITQvqiGo3Q+5nYnHm/M6LpUJmraS5/RL3InSLUxL3QW07Jo8tX6FeSvTGyrktk60Td/QVKKPjry+v88ezanh+Fz+yQJezedu8LFfHnD/9EdB6VyTigOKn3O63Bws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ti7r85t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ti7r85t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375E0C433F1;
	Mon,  4 Mar 2024 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589023;
	bh=l4lPkSUzxhjtsRKM5mDiH7AO3RikjRcBA1iHhqCx6sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ti7r85t71WFSqAVA773l9cj6XnuA+15oudGgmKQfC8rnfpY7e+J0K1R2pK5+jvyZl
	 36F0/fnvOv+yleAqObhzB/bkRq//V5jUQScgWV9fVvmDOX3uOGNw+JeA8INWrYi3A8
	 fx/ggWW+v450L7PMpzPpG6e8HLD+ai6YVGiOXgD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 171/215] NFSD: add support for sending CB_RECALL_ANY
Date: Mon,  4 Mar 2024 21:23:54 +0000
Message-ID: <20240304211602.378276537@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 3959066b697b5dfbb7141124ae9665337d4bc638 ]

Add XDR encode and decode function for CB_RECALL_ANY.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfsd/state.h        |    1 
 fs/nfsd/xdr4.h         |    5 +++
 fs/nfsd/xdr4cb.h       |    6 ++++
 4 files changed, 84 insertions(+)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -76,6 +76,17 @@ static __be32 *xdr_encode_empty_array(__
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
@@ -329,6 +340,24 @@ static void encode_cb_recall4args(struct
 }
 
 /*
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
+/*
  * CB_SEQUENCE4args
  *
  *	struct CB_SEQUENCE4args {
@@ -482,6 +511,26 @@ static void nfs4_xdr_enc_cb_recall(struc
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
@@ -520,6 +569,28 @@ static int nfs4_xdr_dec_cb_recall(struct
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
@@ -783,6 +854,7 @@ static const struct rpc_procinfo nfs4_cb
 #endif
 	PROC(CB_NOTIFY_LOCK,	COMPOUND,	cb_notify_lock,	cb_notify_lock),
 	PROC(CB_OFFLOAD,	COMPOUND,	cb_offload,	cb_offload),
+	PROC(CB_RECALL_ANY,	COMPOUND,	cb_recall_any,	cb_recall_any),
 };
 
 static unsigned int nfs4_cb_counts[ARRAY_SIZE(nfs4_cb_procedures)];
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -636,6 +636,7 @@ enum nfsd4_cb_op {
 	NFSPROC4_CLNT_CB_OFFLOAD,
 	NFSPROC4_CLNT_CB_SEQUENCE,
 	NFSPROC4_CLNT_CB_NOTIFY_LOCK,
+	NFSPROC4_CLNT_CB_RECALL_ANY,
 };
 
 /* Returns true iff a is later than b: */
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -896,5 +896,10 @@ struct nfsd4_operation {
 			union nfsd4_op_u *);
 };
 
+struct nfsd4_cb_recall_any {
+	struct nfsd4_callback	ra_cb;
+	u32			ra_keep;
+	u32			ra_bmval[1];
+};
 
 #endif
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


