Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7391BD8E6;
	Tue, 18 Jun 2024 12:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714607; cv=none; b=klcs4FXG2G3Cei3/TzDcGiNkNQYHLcRR6shX2PSAn4uqGHsImXFn9hAs0NLoUH4gsQnqVdzF9n3kuZfGT56Q3/Kar47Uq/fAl0ENHJIghz36lj2WcKRUd9xAe3SnV4U+Gjtq6CwWBne6RcKmXPQi6uNLmQYVfi3GbJw5QFEufmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714607; c=relaxed/simple;
	bh=D0WRbd/IX7JNyB5qJ/ofMocZT8TiYDCv5Zsjvr30+u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qllJy/XahK6wAB+Csy+Qe9Yib8U/K2c0FEdXRlLlvTdaY3maNLq878GlxSinHs9HRXY9eaUcE2hrR9cRAkSLI7n9jLPJPo3lJppPXp3Z2YU3jCNaSMHeSqP8A9gny8K9ZRw7qCQlfG34301bL0Pr4nWBAU0l8h9STyUffXGZAEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojplo3wF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojplo3wF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DC5C32786;
	Tue, 18 Jun 2024 12:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714607;
	bh=D0WRbd/IX7JNyB5qJ/ofMocZT8TiYDCv5Zsjvr30+u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojplo3wF4CM1/JzeIraQSUjEZr+SqaAxYaWS8MXcG7iP/n/30xR/Lo7bhJgGoMynb
	 mV1+JISmY+tlXdwl/cfWKu+8ZBMI1HbjjZ08hgahOYNTgOXvChFASZ4IeLBWpthox5
	 /4J3E1dMk5tNYq+dtUyc7TdUnqsSb5y7b/t8smfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/770] NFSD: Replace READ* macros in nfsd4_decode_fattr()
Date: Tue, 18 Jun 2024 14:28:00 +0200
Message-ID: <20240618123408.343389290@linuxfoundation.org>
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

[ Upstream commit d1c263a031e876ac3ca5223c728e4d98ed50b3c0 ]

Let's be more careful to avoid overrunning the memory that backs
the bitmap array. This requires updating the synopsis of
nfsd4_decode_fattr().

Bruce points out that a server needs to be careful to return nfs_ok
when a client presents bitmap bits the server doesn't support. This
includes bits in bitmap words the server might not yet support.

The current READ* based implementation is good about that, but that
requirement hasn't been documented.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 82 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 2d97bbff13b68..c916e5d9d3074 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -260,6 +260,46 @@ nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 	DECODE_TAIL;
 }
 
+/**
+ * nfsd4_decode_bitmap4 - Decode an NFSv4 bitmap4
+ * @argp: NFSv4 compound argument structure
+ * @bmval: pointer to an array of u32's to decode into
+ * @bmlen: size of the @bmval array
+ *
+ * The server needs to return nfs_ok rather than nfserr_bad_xdr when
+ * encountering bitmaps containing bits it does not recognize. This
+ * includes bits in bitmap words past WORDn, where WORDn is the last
+ * bitmap WORD the implementation currently supports. Thus we are
+ * careful here to simply ignore bits in bitmap words that this
+ * implementation has yet to support explicitly.
+ *
+ * Return values:
+ *   %nfs_ok: @bmval populated successfully
+ *   %nfserr_bad_xdr: the encoded bitmap was invalid
+ */
+static __be32
+nfsd4_decode_bitmap4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen)
+{
+	u32 i, count;
+	__be32 *p;
+
+	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
+		return nfserr_bad_xdr;
+	/* request sanity */
+	if (count > 1000)
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, count << 2);
+	if (!p)
+		return nfserr_bad_xdr;
+	i = 0;
+	while (i < count)
+		bmval[i++] = be32_to_cpup(p++);
+	while (i < bmlen)
+		bmval[i++] = 0;
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_nfsace4(struct nfsd4_compoundargs *argp, struct nfs4_ace *ace)
 {
@@ -352,17 +392,18 @@ nfsd4_decode_security_label(struct nfsd4_compoundargs *argp,
 }
 
 static __be32
-nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
-		   struct iattr *iattr, struct nfs4_acl **acl,
-		   struct xdr_netobj *label, int *umask)
+nfsd4_decode_fattr4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen,
+		    struct iattr *iattr, struct nfs4_acl **acl,
+		    struct xdr_netobj *label, int *umask)
 {
 	unsigned int starting_pos;
 	u32 attrlist4_count;
+	__be32 *p, status;
 
-	DECODE_HEAD;
 	iattr->ia_valid = 0;
-	if ((status = nfsd4_decode_bitmap(argp, bmval)))
-		return status;
+	status = nfsd4_decode_bitmap4(argp, bmval, bmlen);
+	if (status)
+		return nfserr_bad_xdr;
 
 	if (bmval[0] & ~NFSD_WRITEABLE_ATTRS_WORD0
 	    || bmval[1] & ~NFSD_WRITEABLE_ATTRS_WORD1
@@ -490,7 +531,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	if (attrlist4_count != xdr_stream_pos(argp->xdr) - starting_pos)
 		return nfserr_bad_xdr;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
@@ -690,9 +731,10 @@ nfsd4_decode_create(struct nfsd4_compoundargs *argp, struct nfsd4_create *create
 	if ((status = check_filename(create->cr_name, create->cr_namelen)))
 		return status;
 
-	status = nfsd4_decode_fattr(argp, create->cr_bmval, &create->cr_iattr,
-				    &create->cr_acl, &create->cr_label,
-				    &create->cr_umask);
+	status = nfsd4_decode_fattr4(argp, create->cr_bmval,
+				    ARRAY_SIZE(create->cr_bmval),
+				    &create->cr_iattr, &create->cr_acl,
+				    &create->cr_label, &create->cr_umask);
 	if (status)
 		goto out;
 
@@ -941,9 +983,10 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 		switch (open->op_createmode) {
 		case NFS4_CREATE_UNCHECKED:
 		case NFS4_CREATE_GUARDED:
-			status = nfsd4_decode_fattr(argp, open->op_bmval,
-				&open->op_iattr, &open->op_acl, &open->op_label,
-				&open->op_umask);
+			status = nfsd4_decode_fattr4(argp, open->op_bmval,
+						     ARRAY_SIZE(open->op_bmval),
+						     &open->op_iattr, &open->op_acl,
+						     &open->op_label, &open->op_umask);
 			if (status)
 				goto out;
 			break;
@@ -956,9 +999,10 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 				goto xdr_error;
 			READ_BUF(NFS4_VERIFIER_SIZE);
 			COPYMEM(open->op_verf.data, NFS4_VERIFIER_SIZE);
-			status = nfsd4_decode_fattr(argp, open->op_bmval,
-				&open->op_iattr, &open->op_acl, &open->op_label,
-				&open->op_umask);
+			status = nfsd4_decode_fattr4(argp, open->op_bmval,
+						     ARRAY_SIZE(open->op_bmval),
+						     &open->op_iattr, &open->op_acl,
+						     &open->op_label, &open->op_umask);
 			if (status)
 				goto out;
 			break;
@@ -1194,8 +1238,10 @@ nfsd4_decode_setattr(struct nfsd4_compoundargs *argp, struct nfsd4_setattr *seta
 	status = nfsd4_decode_stateid(argp, &setattr->sa_stateid);
 	if (status)
 		return status;
-	return nfsd4_decode_fattr(argp, setattr->sa_bmval, &setattr->sa_iattr,
-				  &setattr->sa_acl, &setattr->sa_label, NULL);
+	return nfsd4_decode_fattr4(argp, setattr->sa_bmval,
+				   ARRAY_SIZE(setattr->sa_bmval),
+				   &setattr->sa_iattr, &setattr->sa_acl,
+				   &setattr->sa_label, NULL);
 }
 
 static __be32
-- 
2.43.0



