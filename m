Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B761591F0;
	Tue, 18 Jun 2024 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716493; cv=none; b=GCPAj0/+8N81yQsviUUDsH5dIJp+LJA8aQkGMzPkfWLZOAR1cZ2zr1vKtLuw+cFKdLuDx9aBBD/gkMoN1pzNNDiySlB1Z3a4/Rgz7P/Q0UjD6FyGlOTMfgwMRETyBdjN8z3IQeVMHjQY9vLnAh18ERpXgPCVFeedWAFUNiqKjD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716493; c=relaxed/simple;
	bh=He1xy2VBFv7ik7p/zF40khL59IJTClFEXoB/kN8Rw/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsn2oYcOyTYXUaWmGkc/m1gjGI2VCEKL5+V21Qi570fskmevF3cC7lKmEQOhIObWg/zeLSjyUx9YMOvfyXMlU7nTXrtptjNqrAvPKOul1vq9n6LarhyyRhGeg+4JIWJ4Ni5IB9Qr3hlo9mWf/iNS3PF5DS5xTabarIs7Gp2kJm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXd8ro1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXd8ro1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01912C3277B;
	Tue, 18 Jun 2024 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716493;
	bh=He1xy2VBFv7ik7p/zF40khL59IJTClFEXoB/kN8Rw/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXd8ro1bbbstJ7MYijHXjILUs+Fkva3jIcxmn8BH8EZqxLKdRZubdjcDPtfafWyLG
	 folaEwpwPrhj5rPedwIEDBilM32liwkPOpyZau/mE8hREfWthtk2jJkIGFU7DTyRSR
	 ELADnSt12XidBWONQEdXU2DXxLhVeas3wE3k/IrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 664/770] NFSD: Cap rsize_bop result based on send buffer size
Date: Tue, 18 Jun 2024 14:38:37 +0200
Message-ID: <20240618123432.915458518@linuxfoundation.org>
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

[ Upstream commit 76ce4dcec0dc08a032db916841ddc4e3998be317 ]

Since before the git era, NFSD has conserved the number of pages
held by each nfsd thread by combining the RPC receive and send
buffers into a single array of pages. This works because there are
no cases where an operation needs a large RPC Call message and a
large RPC Reply at the same time.

Once an RPC Call has been received, svc_process() updates
svc_rqst::rq_res to describe the part of rq_pages that can be
used for constructing the Reply. This means that the send buffer
(rq_res) shrinks when the received RPC record containing the RPC
Call is large.

Add an NFSv4 helper that computes the size of the send buffer. It
replaces svc_max_payload() in spots where svc_max_payload() returns
a value that might be larger than the remaining send buffer space.
Callers who need to know the transport's actual maximum payload size
will continue to use svc_max_payload().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 48 +++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index e1aa48d496b98..50fd4ba04a3e0 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2763,6 +2763,22 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 
 #define op_encode_channel_attrs_maxsz	(6 + 1 + 1)
 
+/*
+ * The _rsize() helpers are invoked by the NFSv4 COMPOUND decoder, which
+ * is called before sunrpc sets rq_res.buflen. Thus we have to compute
+ * the maximum payload size here, based on transport limits and the size
+ * of the remaining space in the rq_pages array.
+ */
+static u32 nfsd4_max_payload(const struct svc_rqst *rqstp)
+{
+	u32 buflen;
+
+	buflen = (rqstp->rq_page_end - rqstp->rq_next_page) * PAGE_SIZE;
+	buflen -= rqstp->rq_auth_slack;
+	buflen -= rqstp->rq_res.head[0].iov_len;
+	return min_t(u32, buflen, svc_max_payload(rqstp));
+}
+
 static u32 nfsd4_only_status_rsize(const struct svc_rqst *rqstp,
 				   const struct nfsd4_op *op)
 {
@@ -2808,9 +2824,9 @@ static u32 nfsd4_getattr_rsize(const struct svc_rqst *rqstp,
 	u32 ret = 0;
 
 	if (bmap0 & FATTR4_WORD0_ACL)
-		return svc_max_payload(rqstp);
+		return nfsd4_max_payload(rqstp);
 	if (bmap0 & FATTR4_WORD0_FS_LOCATIONS)
-		return svc_max_payload(rqstp);
+		return nfsd4_max_payload(rqstp);
 
 	if (bmap1 & FATTR4_WORD1_OWNER) {
 		ret += IDMAP_NAMESZ + 4;
@@ -2870,10 +2886,7 @@ static u32 nfsd4_open_rsize(const struct svc_rqst *rqstp,
 static u32 nfsd4_read_rsize(const struct svc_rqst *rqstp,
 			    const struct nfsd4_op *op)
 {
-	u32 maxcount = 0, rlen = 0;
-
-	maxcount = svc_max_payload(rqstp);
-	rlen = min(op->u.read.rd_length, maxcount);
+	u32 rlen = min(op->u.read.rd_length, nfsd4_max_payload(rqstp));
 
 	return (op_encode_hdr_size + 2 + XDR_QUADLEN(rlen)) * sizeof(__be32);
 }
@@ -2881,8 +2894,7 @@ static u32 nfsd4_read_rsize(const struct svc_rqst *rqstp,
 static u32 nfsd4_read_plus_rsize(const struct svc_rqst *rqstp,
 				 const struct nfsd4_op *op)
 {
-	u32 maxcount = svc_max_payload(rqstp);
-	u32 rlen = min(op->u.read.rd_length, maxcount);
+	u32 rlen = min(op->u.read.rd_length, nfsd4_max_payload(rqstp));
 	/*
 	 * If we detect that the file changed during hole encoding, then we
 	 * recover by encoding the remaining reply as data. This means we need
@@ -2896,10 +2908,7 @@ static u32 nfsd4_read_plus_rsize(const struct svc_rqst *rqstp,
 static u32 nfsd4_readdir_rsize(const struct svc_rqst *rqstp,
 			       const struct nfsd4_op *op)
 {
-	u32 maxcount = 0, rlen = 0;
-
-	maxcount = svc_max_payload(rqstp);
-	rlen = min(op->u.readdir.rd_maxcount, maxcount);
+	u32 rlen = min(op->u.readdir.rd_maxcount, nfsd4_max_payload(rqstp));
 
 	return (op_encode_hdr_size + op_encode_verifier_maxsz +
 		XDR_QUADLEN(rlen)) * sizeof(__be32);
@@ -3038,10 +3047,7 @@ static u32 nfsd4_copy_notify_rsize(const struct svc_rqst *rqstp,
 static u32 nfsd4_getdeviceinfo_rsize(const struct svc_rqst *rqstp,
 				     const struct nfsd4_op *op)
 {
-	u32 maxcount = 0, rlen = 0;
-
-	maxcount = svc_max_payload(rqstp);
-	rlen = min(op->u.getdeviceinfo.gd_maxcount, maxcount);
+	u32 rlen = min(op->u.getdeviceinfo.gd_maxcount, nfsd4_max_payload(rqstp));
 
 	return (op_encode_hdr_size +
 		1 /* gd_layout_type*/ +
@@ -3091,10 +3097,7 @@ static u32 nfsd4_seek_rsize(const struct svc_rqst *rqstp,
 static u32 nfsd4_getxattr_rsize(const struct svc_rqst *rqstp,
 				const struct nfsd4_op *op)
 {
-	u32 maxcount, rlen;
-
-	maxcount = svc_max_payload(rqstp);
-	rlen = min_t(u32, XATTR_SIZE_MAX, maxcount);
+	u32 rlen = min_t(u32, XATTR_SIZE_MAX, nfsd4_max_payload(rqstp));
 
 	return (op_encode_hdr_size + 1 + XDR_QUADLEN(rlen)) * sizeof(__be32);
 }
@@ -3108,10 +3111,7 @@ static u32 nfsd4_setxattr_rsize(const struct svc_rqst *rqstp,
 static u32 nfsd4_listxattrs_rsize(const struct svc_rqst *rqstp,
 				  const struct nfsd4_op *op)
 {
-	u32 maxcount, rlen;
-
-	maxcount = svc_max_payload(rqstp);
-	rlen = min(op->u.listxattrs.lsxa_maxcount, maxcount);
+	u32 rlen = min(op->u.listxattrs.lsxa_maxcount, nfsd4_max_payload(rqstp));
 
 	return (op_encode_hdr_size + 4 + XDR_QUADLEN(rlen)) * sizeof(__be32);
 }
-- 
2.43.0



