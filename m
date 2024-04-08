Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41997A15C;
	Mon,  8 Apr 2024 13:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584632; cv=none; b=QIzu7mH2cmo4PlbpnzLc7YoOjks8CEGp9Ppmh04548IBmFd1r1K5+hgP4fh5uqFt5EaHKe8WRdqMRHCVyTqn1AuUBQ+CdtK1sEamnOpjX+yt93Rbd1KJcPIwls4S7VSVTJk7pQtvxEbg8cBl69H+bmU8dVhLSQ/2RiiB3o5ho3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584632; c=relaxed/simple;
	bh=yLQpUj3Jc3djj4T2r+ISJUPcpI5fIWeGq2glROi9ECk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSra/c+XPo1WVPlZSubGzeQ3ZJKCEZyIaJTg6x4IE28RDCFIxb4tw1Ad49w7BDG7tMUztg43DX1DmVlPE7BGvlKktPX0wJpyKmL0/X1lFLw4xmiiQslZuKqR/hR88K34a+QGtA2E1vtpBQkAcHCgPwh2TuE1CJdop/pTVgsGB2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4GG7Smy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4GG7Smy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD893C433F1;
	Mon,  8 Apr 2024 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584632;
	bh=yLQpUj3Jc3djj4T2r+ISJUPcpI5fIWeGq2glROi9ECk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4GG7Smyof9zPPf7OhgVDlj8SSThqji1c+l0Sw9RD1cL6TMOSjqtJ6Ut0VYgDKKV4
	 S921uSIv7BKjOuZHT/8MXzQmlMrLguYpc4SH0ltexCGG7iXhbu5gaHA6tBtf6+v4pQ
	 PbB3cCXRTxtBhwKVqFkGC+K0OUZkN3wtdPkSksUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 504/690] NFSD: add support for sending CB_RECALL_ANY
Date: Mon,  8 Apr 2024 14:56:10 +0200
Message-ID: <20240408125417.898928527@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 3959066b697b5dfbb7141124ae9665337d4bc638 ]

Add XDR encode and decode function for CB_RECALL_ANY.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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
index 0eb00105d845b..4fd2cf6d1d2dc 100644
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



