Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E91143C47;
	Tue, 23 Apr 2024 21:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908495; cv=none; b=qb04KEPnfCL9Hi4wLHQnkxVBK7wTepaqMGM4RFZcN5nSzpeiE2v05hXyhpCS2gZiZfFcAK4IDfGZjkkxr3NkAQdEmp+ylVoM5s4+fy6ClZIuAEpzBV8hDUq/tfZWTPCsz6zuBZKKLi1tmhDX8rdzm6rJQvSiamwUuy7GAFXBXJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908495; c=relaxed/simple;
	bh=6AfFH5heKauHHjdoDEVTGxOUABHpvjXgmXP9OXZDR+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOBkFpv7pIu+l3rLGxRAZjIrwJF1BRMjJ0lpipTZdtVkRmAVHK3NK9WqZRGKmeIAGRYnVWSgy6FWNF/RyLnPj/aJdiL+wVF9bBLnKdDt320qToSHqezK886jG+DsnnlYqy/HeWbpnMjlztmSD6W9LMi/hf0VCLZnlS52RNN/M5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khOFwJ2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khOFwJ2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F169EC3277B;
	Tue, 23 Apr 2024 21:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908495;
	bh=6AfFH5heKauHHjdoDEVTGxOUABHpvjXgmXP9OXZDR+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khOFwJ2N9gvXBVgzBqzS0Bv2dBQP1ADPWdlm9e+Tj27/dn9I6QlsBXWparlQkaAZ0
	 QkpMiNeNKMDN9rStevkzVK+Jryz2MNQIAC/wj0ivTThep1umznA4ArGLBQJlB10ELG
	 r9WF43T+bSOPQQARTiRCP3X4UAKJUo8BhloJxddA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 054/158] NFSD: fix endianness issue in nfsd4_encode_fattr4
Date: Tue, 23 Apr 2024 14:37:56 -0700
Message-ID: <20240423213857.685962295@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit f488138b526715c6d2568d7329c4477911be4210 ]

The nfs4 mount fails with EIO on 64-bit big endian architectures since
v6.7. The issue arises from employing a union in the nfsd4_encode_fattr4()
function to overlay a 32-bit array with a 64-bit values based bitmap,
which does not function as intended. Address the endianness issue by
utilizing bitmap_from_arr32() to copy 32-bit attribute masks into a
bitmap in an endianness-agnostic manner.

Cc: stable@vger.kernel.org
Fixes: fce7913b13d0 ("NFSD: Use a bitmask loop to encode FATTR4 results")
Link: https://bugs.launchpad.net/ubuntu/+source/nfs-utils/+bug/2060217
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c719c475a068e..c17bdf973c18d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3490,11 +3490,13 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		    struct dentry *dentry, const u32 *bmval,
 		    int ignore_crossmnt)
 {
+	DECLARE_BITMAP(attr_bitmap, ARRAY_SIZE(nfsd4_enc_fattr4_encode_ops));
 	struct nfsd4_fattr_args args;
 	struct svc_fh *tempfh = NULL;
 	int starting_len = xdr->buf->len;
 	__be32 *attrlen_p, status;
 	int attrlen_offset;
+	u32 attrmask[3];
 	int err;
 	struct nfsd4_compoundres *resp = rqstp->rq_resp;
 	u32 minorversion = resp->cstate.minorversion;
@@ -3502,10 +3504,6 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		.mnt	= exp->ex_path.mnt,
 		.dentry	= dentry,
 	};
-	union {
-		u32		attrmask[3];
-		unsigned long	mask[2];
-	} u;
 	unsigned long bit;
 
 	WARN_ON_ONCE(bmval[1] & NFSD_WRITEONLY_ATTRS_WORD1);
@@ -3519,20 +3517,19 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	/*
 	 * Make a local copy of the attribute bitmap that can be modified.
 	 */
-	memset(&u, 0, sizeof(u));
-	u.attrmask[0] = bmval[0];
-	u.attrmask[1] = bmval[1];
-	u.attrmask[2] = bmval[2];
+	attrmask[0] = bmval[0];
+	attrmask[1] = bmval[1];
+	attrmask[2] = bmval[2];
 
 	args.rdattr_err = 0;
 	if (exp->ex_fslocs.migrated) {
-		status = fattr_handle_absent_fs(&u.attrmask[0], &u.attrmask[1],
-						&u.attrmask[2], &args.rdattr_err);
+		status = fattr_handle_absent_fs(&attrmask[0], &attrmask[1],
+						&attrmask[2], &args.rdattr_err);
 		if (status)
 			goto out;
 	}
 	args.size = 0;
-	if (u.attrmask[0] & (FATTR4_WORD0_CHANGE | FATTR4_WORD0_SIZE)) {
+	if (attrmask[0] & (FATTR4_WORD0_CHANGE | FATTR4_WORD0_SIZE)) {
 		status = nfsd4_deleg_getattr_conflict(rqstp, d_inode(dentry));
 		if (status)
 			goto out;
@@ -3547,16 +3544,16 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 
 	if (!(args.stat.result_mask & STATX_BTIME))
 		/* underlying FS does not offer btime so we can't share it */
-		u.attrmask[1] &= ~FATTR4_WORD1_TIME_CREATE;
-	if ((u.attrmask[0] & (FATTR4_WORD0_FILES_AVAIL | FATTR4_WORD0_FILES_FREE |
+		attrmask[1] &= ~FATTR4_WORD1_TIME_CREATE;
+	if ((attrmask[0] & (FATTR4_WORD0_FILES_AVAIL | FATTR4_WORD0_FILES_FREE |
 			FATTR4_WORD0_FILES_TOTAL | FATTR4_WORD0_MAXNAME)) ||
-	    (u.attrmask[1] & (FATTR4_WORD1_SPACE_AVAIL | FATTR4_WORD1_SPACE_FREE |
+	    (attrmask[1] & (FATTR4_WORD1_SPACE_AVAIL | FATTR4_WORD1_SPACE_FREE |
 		       FATTR4_WORD1_SPACE_TOTAL))) {
 		err = vfs_statfs(&path, &args.statfs);
 		if (err)
 			goto out_nfserr;
 	}
-	if ((u.attrmask[0] & (FATTR4_WORD0_FILEHANDLE | FATTR4_WORD0_FSID)) &&
+	if ((attrmask[0] & (FATTR4_WORD0_FILEHANDLE | FATTR4_WORD0_FSID)) &&
 	    !fhp) {
 		tempfh = kmalloc(sizeof(struct svc_fh), GFP_KERNEL);
 		status = nfserr_jukebox;
@@ -3571,10 +3568,10 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		args.fhp = fhp;
 
 	args.acl = NULL;
-	if (u.attrmask[0] & FATTR4_WORD0_ACL) {
+	if (attrmask[0] & FATTR4_WORD0_ACL) {
 		err = nfsd4_get_nfs4_acl(rqstp, dentry, &args.acl);
 		if (err == -EOPNOTSUPP)
-			u.attrmask[0] &= ~FATTR4_WORD0_ACL;
+			attrmask[0] &= ~FATTR4_WORD0_ACL;
 		else if (err == -EINVAL) {
 			status = nfserr_attrnotsupp;
 			goto out;
@@ -3586,17 +3583,17 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 	args.context = NULL;
-	if ((u.attrmask[2] & FATTR4_WORD2_SECURITY_LABEL) ||
-	     u.attrmask[0] & FATTR4_WORD0_SUPPORTED_ATTRS) {
+	if ((attrmask[2] & FATTR4_WORD2_SECURITY_LABEL) ||
+	     attrmask[0] & FATTR4_WORD0_SUPPORTED_ATTRS) {
 		if (exp->ex_flags & NFSEXP_SECURITY_LABEL)
 			err = security_inode_getsecctx(d_inode(dentry),
 						&args.context, &args.contextlen);
 		else
 			err = -EOPNOTSUPP;
 		args.contextsupport = (err == 0);
-		if (u.attrmask[2] & FATTR4_WORD2_SECURITY_LABEL) {
+		if (attrmask[2] & FATTR4_WORD2_SECURITY_LABEL) {
 			if (err == -EOPNOTSUPP)
-				u.attrmask[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
+				attrmask[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 			else if (err)
 				goto out_nfserr;
 		}
@@ -3604,8 +3601,8 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 #endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
 
 	/* attrmask */
-	status = nfsd4_encode_bitmap4(xdr, u.attrmask[0],
-				      u.attrmask[1], u.attrmask[2]);
+	status = nfsd4_encode_bitmap4(xdr, attrmask[0], attrmask[1],
+				      attrmask[2]);
 	if (status)
 		goto out;
 
@@ -3614,7 +3611,9 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	attrlen_p = xdr_reserve_space(xdr, XDR_UNIT);
 	if (!attrlen_p)
 		goto out_resource;
-	for_each_set_bit(bit, (const unsigned long *)&u.mask,
+	bitmap_from_arr32(attr_bitmap, attrmask,
+			  ARRAY_SIZE(nfsd4_enc_fattr4_encode_ops));
+	for_each_set_bit(bit, attr_bitmap,
 			 ARRAY_SIZE(nfsd4_enc_fattr4_encode_ops)) {
 		status = nfsd4_enc_fattr4_encode_ops[bit](xdr, &args);
 		if (status != nfs_ok)
-- 
2.43.0



