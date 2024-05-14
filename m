Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A90433BE;
	Tue, 14 May 2024 10:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682148; cv=none; b=ZJdiNI5gBJzwzo+FxgtFT59Wm4wB7e68xLJCw6CMndfr+DCktbX3iBHONqIMuUGUlUmK171vuliUydgScSWZiWMyAMPBw0RHjAdq4rylJ7pLCVi+z+negZJ+br42WfDJLoRWayeZ3W2REEa45NMCWYccZz6Xu94zl9TA84YkvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682148; c=relaxed/simple;
	bh=U9s6/z6c/akeuBW8JO/nTu89qG4H+TPPre8N9w6ouxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiBPDzyZXLWcdnDMUGtl9wR21PDnO9NEKn2K9g13A26FjEtFI3LE/vBni+4fgHFDhviqJwZlZ9O80toJc6RcheoYY3NQTiiX5VRMpzfcWMOt4fcsMkkWN/i5fq781UaAb1zzX1As2ql42+/yt2ksZGKPlOJYOql+yLFRuFOOq6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0JQd+Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0JQd+Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BA2C2BD10;
	Tue, 14 May 2024 10:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682148;
	bh=U9s6/z6c/akeuBW8JO/nTu89qG4H+TPPre8N9w6ouxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0JQd+DcAPQg1TwrBXcz/2UP6XWPnkU0qa6xPMyNBYokSKIbC4VMPdI3ZoGqZ+U07
	 6YD+/SOMMrAtxGTaLdOQDrl63S+jAzwldmVl0bW/E9szrW/O3kC3Y/gzUDAEsmtznU
	 1+KcVR/eqNlgOY6+oMGQsnRMNcm7bwf29Zf5mvUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 020/336] NFSD: add support for CB_GETATTR callback
Date: Tue, 14 May 2024 12:13:44 +0200
Message-ID: <20240514101039.370534291@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 6487a13b5c6bee2ca3fc931f8ad28c8ae887a41f ]

Includes:
   . CB_GETATTR proc for nfs4_cb_procedures[]
   . XDR encoding and decoding function for CB_GETATTR request/reply
   . add nfs4_cb_fattr to nfs4_delegation for sending CB_GETATTR
     and store file attributes from client's reply.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 18180a4550d0 ("NFSD: Fix nfsd4_encode_fattr4() crasher")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 97 +++++++++++++++++++++++++++++++++++++++++-
 fs/nfsd/state.h        | 14 ++++++
 fs/nfsd/xdr4cb.h       | 18 ++++++++
 3 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 926c29879c6ab..30aa241038eb4 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -85,7 +85,21 @@ static void encode_uint32(struct xdr_stream *xdr, u32 n)
 static void encode_bitmap4(struct xdr_stream *xdr, const __u32 *bitmap,
 			   size_t len)
 {
-	WARN_ON_ONCE(xdr_stream_encode_uint32_array(xdr, bitmap, len) < 0);
+	xdr_stream_encode_uint32_array(xdr, bitmap, len);
+}
+
+static int decode_cb_fattr4(struct xdr_stream *xdr, uint32_t *bitmap,
+				struct nfs4_cb_fattr *fattr)
+{
+	fattr->ncf_cb_change = 0;
+	fattr->ncf_cb_fsize = 0;
+	if (bitmap[0] & FATTR4_WORD0_CHANGE)
+		if (xdr_stream_decode_u64(xdr, &fattr->ncf_cb_change) < 0)
+			return -NFSERR_BAD_XDR;
+	if (bitmap[0] & FATTR4_WORD0_SIZE)
+		if (xdr_stream_decode_u64(xdr, &fattr->ncf_cb_fsize) < 0)
+			return -NFSERR_BAD_XDR;
+	return 0;
 }
 
 static void encode_nfs_cb_opnum4(struct xdr_stream *xdr, enum nfs_cb_opnum4 op)
@@ -333,6 +347,30 @@ encode_cb_recallany4args(struct xdr_stream *xdr,
 	hdr->nops++;
 }
 
+/*
+ * CB_GETATTR4args
+ *	struct CB_GETATTR4args {
+ *	   nfs_fh4 fh;
+ *	   bitmap4 attr_request;
+ *	};
+ *
+ * The size and change attributes are the only one
+ * guaranteed to be serviced by the client.
+ */
+static void
+encode_cb_getattr4args(struct xdr_stream *xdr, struct nfs4_cb_compound_hdr *hdr,
+			struct nfs4_cb_fattr *fattr)
+{
+	struct nfs4_delegation *dp =
+		container_of(fattr, struct nfs4_delegation, dl_cb_fattr);
+	struct knfsd_fh *fh = &dp->dl_stid.sc_file->fi_fhandle;
+
+	encode_nfs_cb_opnum4(xdr, OP_CB_GETATTR);
+	encode_nfs_fh4(xdr, fh);
+	encode_bitmap4(xdr, fattr->ncf_cb_bmap, ARRAY_SIZE(fattr->ncf_cb_bmap));
+	hdr->nops++;
+}
+
 /*
  * CB_SEQUENCE4args
  *
@@ -468,6 +506,26 @@ static void nfs4_xdr_enc_cb_null(struct rpc_rqst *req, struct xdr_stream *xdr,
 	xdr_reserve_space(xdr, 0);
 }
 
+/*
+ * 20.1.  Operation 3: CB_GETATTR - Get Attributes
+ */
+static void nfs4_xdr_enc_cb_getattr(struct rpc_rqst *req,
+		struct xdr_stream *xdr, const void *data)
+{
+	const struct nfsd4_callback *cb = data;
+	struct nfs4_cb_fattr *ncf =
+		container_of(cb, struct nfs4_cb_fattr, ncf_getattr);
+	struct nfs4_cb_compound_hdr hdr = {
+		.ident = cb->cb_clp->cl_cb_ident,
+		.minorversion = cb->cb_clp->cl_minorversion,
+	};
+
+	encode_cb_compound4args(xdr, &hdr);
+	encode_cb_sequence4args(xdr, cb, &hdr);
+	encode_cb_getattr4args(xdr, &hdr, ncf);
+	encode_cb_nops(&hdr);
+}
+
 /*
  * 20.2. Operation 4: CB_RECALL - Recall a Delegation
  */
@@ -523,6 +581,42 @@ static int nfs4_xdr_dec_cb_null(struct rpc_rqst *req, struct xdr_stream *xdr,
 	return 0;
 }
 
+/*
+ * 20.1.  Operation 3: CB_GETATTR - Get Attributes
+ */
+static int nfs4_xdr_dec_cb_getattr(struct rpc_rqst *rqstp,
+				  struct xdr_stream *xdr,
+				  void *data)
+{
+	struct nfsd4_callback *cb = data;
+	struct nfs4_cb_compound_hdr hdr;
+	int status;
+	u32 bitmap[3] = {0};
+	u32 attrlen;
+	struct nfs4_cb_fattr *ncf =
+		container_of(cb, struct nfs4_cb_fattr, ncf_getattr);
+
+	status = decode_cb_compound4res(xdr, &hdr);
+	if (unlikely(status))
+		return status;
+
+	status = decode_cb_sequence4res(xdr, cb);
+	if (unlikely(status || cb->cb_seq_status))
+		return status;
+
+	status = decode_cb_op_status(xdr, OP_CB_GETATTR, &cb->cb_status);
+	if (status)
+		return status;
+	if (xdr_stream_decode_uint32_array(xdr, bitmap, 3) < 0)
+		return -NFSERR_BAD_XDR;
+	if (xdr_stream_decode_u32(xdr, &attrlen) < 0)
+		return -NFSERR_BAD_XDR;
+	if (attrlen > (sizeof(ncf->ncf_cb_change) + sizeof(ncf->ncf_cb_fsize)))
+		return -NFSERR_BAD_XDR;
+	status = decode_cb_fattr4(xdr, bitmap, ncf);
+	return status;
+}
+
 /*
  * 20.2. Operation 4: CB_RECALL - Recall a Delegation
  */
@@ -831,6 +925,7 @@ static const struct rpc_procinfo nfs4_cb_procedures[] = {
 	PROC(CB_NOTIFY_LOCK,	COMPOUND,	cb_notify_lock,	cb_notify_lock),
 	PROC(CB_OFFLOAD,	COMPOUND,	cb_offload,	cb_offload),
 	PROC(CB_RECALL_ANY,	COMPOUND,	cb_recall_any,	cb_recall_any),
+	PROC(CB_GETATTR,	COMPOUND,	cb_getattr,	cb_getattr),
 };
 
 static unsigned int nfs4_cb_counts[ARRAY_SIZE(nfs4_cb_procedures)];
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 41bdc913fa715..0bbbe57e027d3 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -117,6 +117,16 @@ struct nfs4_cpntf_state {
 	time64_t		cpntf_time;	/* last time stateid used */
 };
 
+struct nfs4_cb_fattr {
+	struct nfsd4_callback ncf_getattr;
+	u32 ncf_cb_status;
+	u32 ncf_cb_bmap[1];
+
+	/* from CB_GETATTR reply */
+	u64 ncf_cb_change;
+	u64 ncf_cb_fsize;
+};
+
 /*
  * Represents a delegation stateid. The nfs4_client holds references to these
  * and they are put when it is being destroyed or when the delegation is
@@ -150,6 +160,9 @@ struct nfs4_delegation {
 	int			dl_retries;
 	struct nfsd4_callback	dl_recall;
 	bool			dl_recalled;
+
+	/* for CB_GETATTR */
+	struct nfs4_cb_fattr    dl_cb_fattr;
 };
 
 #define cb_to_delegation(cb) \
@@ -640,6 +653,7 @@ enum nfsd4_cb_op {
 	NFSPROC4_CLNT_CB_SEQUENCE,
 	NFSPROC4_CLNT_CB_NOTIFY_LOCK,
 	NFSPROC4_CLNT_CB_RECALL_ANY,
+	NFSPROC4_CLNT_CB_GETATTR,
 };
 
 /* Returns true iff a is later than b: */
diff --git a/fs/nfsd/xdr4cb.h b/fs/nfsd/xdr4cb.h
index 0d39af1b00a0f..e8b00309c449f 100644
--- a/fs/nfsd/xdr4cb.h
+++ b/fs/nfsd/xdr4cb.h
@@ -54,3 +54,21 @@
 #define NFS4_dec_cb_recall_any_sz	(cb_compound_dec_hdr_sz  +      \
 					cb_sequence_dec_sz +            \
 					op_dec_sz)
+
+/*
+ * 1: CB_GETATTR opcode (32-bit)
+ * N: file_handle
+ * 1: number of entry in attribute array (32-bit)
+ * 1: entry 0 in attribute array (32-bit)
+ */
+#define NFS4_enc_cb_getattr_sz		(cb_compound_enc_hdr_sz +       \
+					cb_sequence_enc_sz +            \
+					1 + enc_nfs4_fh_sz + 1 + 1)
+/*
+ * 4: fattr_bitmap_maxsz
+ * 1: attribute array len
+ * 2: change attr (64-bit)
+ * 2: size (64-bit)
+ */
+#define NFS4_dec_cb_getattr_sz		(cb_compound_dec_hdr_sz  +      \
+			cb_sequence_dec_sz + 4 + 1 + 2 + 2 + op_dec_sz)
-- 
2.43.0



