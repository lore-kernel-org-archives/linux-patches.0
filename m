Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0561BE243;
	Tue, 18 Jun 2024 12:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714610; cv=none; b=EFVRqwgQlhZoBnDuFrTGNNtKIDb3EQSAMOsqNBfix3tqAuEEmmIiu7R+yvqcs4aHIwjtwoomiwKasih6EN8QyqwkVybiSa8PX5bEosEMdUCtd1XqfiGkoRjGpCiKREpDOlnAkj6HG/+SXSHKqULST2ZlbbqUI/8g4ky8fvoH+fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714610; c=relaxed/simple;
	bh=sqvpZvyEtOXyhnuNrVL619j7BNc6rAEfO/mGuPVUfGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnF0xap7FM8XoJ/7jY1lHxXwrT7lhrDYRE+MRmhSUW1EhYKAQMizrJ4ijjSUZ9JkkbeN+v507JKMMK7ZxZqGWBz9sIHlfWSzGsBZdkOx5LGuHTR2IwVY+BADxFrMW3/AykBpAGsbJmGC6Tl4NhGYl/jVVX0S4iANx5r0hKizbTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVJZlkfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVJZlkfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D327BC3277B;
	Tue, 18 Jun 2024 12:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714610;
	bh=sqvpZvyEtOXyhnuNrVL619j7BNc6rAEfO/mGuPVUfGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVJZlkfNGOS0nVoQJujFKg/koPX8O5KN3hZpHw5OpJEDa3JefJDKfQE/Ux/8UxCUj
	 QI3Bs9SDYrqu0fmRDxuP7/pA8xd6oMJ0b5TKhJ4k/9IDEb56l15JtbsvpcAYJGuwlr
	 rTu8guq8xGyw2Yhgg+r4X17i1CyUqvdcn1cOOSKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/770] NFSD: Replace READ* macros in nfsd4_decode_create()
Date: Tue, 18 Jun 2024 14:28:01 +0200
Message-ID: <20240618123408.381050518@linuxfoundation.org>
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

[ Upstream commit 000dfa18b3df9c62df5f768f9187cf1a94ded71d ]

A dedicated decoder for component4 is introduced here, which will be
used by other operation decoders in subsequent patches.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 58 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c916e5d9d3074..8f296f5568b11 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -92,6 +92,8 @@ check_filename(char *str, int len)
 
 	if (len == 0)
 		return nfserr_inval;
+	if (len > NFS4_MAXNAMLEN)
+		return nfserr_nametoolong;
 	if (isdotent(str, len))
 		return nfserr_badname;
 	for (i = 0; i < len; i++)
@@ -205,6 +207,27 @@ static char *savemem(struct nfsd4_compoundargs *argp, __be32 *p, int nbytes)
 	return ret;
 }
 
+static __be32
+nfsd4_decode_component4(struct nfsd4_compoundargs *argp, char **namp, u32 *lenp)
+{
+	__be32 *p, status;
+
+	if (xdr_stream_decode_u32(argp->xdr, lenp) < 0)
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, *lenp);
+	if (!p)
+		return nfserr_bad_xdr;
+	status = check_filename((char *)p, *lenp);
+	if (status)
+		return status;
+	*namp = svcxdr_tmpalloc(argp, *lenp);
+	if (!*namp)
+		return nfserr_jukebox;
+	memcpy(*namp, p, *lenp);
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_time(struct nfsd4_compoundargs *argp, struct timespec64 *tv)
 {
@@ -698,24 +721,27 @@ nfsd4_decode_commit(struct nfsd4_compoundargs *argp, struct nfsd4_commit *commit
 static __be32
 nfsd4_decode_create(struct nfsd4_compoundargs *argp, struct nfsd4_create *create)
 {
-	DECODE_HEAD;
+	__be32 *p, status;
 
-	READ_BUF(4);
-	create->cr_type = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &create->cr_type) < 0)
+		return nfserr_bad_xdr;
 	switch (create->cr_type) {
 	case NF4LNK:
-		READ_BUF(4);
-		create->cr_datalen = be32_to_cpup(p++);
-		READ_BUF(create->cr_datalen);
+		if (xdr_stream_decode_u32(argp->xdr, &create->cr_datalen) < 0)
+			return nfserr_bad_xdr;
+		p = xdr_inline_decode(argp->xdr, create->cr_datalen);
+		if (!p)
+			return nfserr_bad_xdr;
 		create->cr_data = svcxdr_dupstr(argp, p, create->cr_datalen);
 		if (!create->cr_data)
 			return nfserr_jukebox;
 		break;
 	case NF4BLK:
 	case NF4CHR:
-		READ_BUF(8);
-		create->cr_specdata1 = be32_to_cpup(p++);
-		create->cr_specdata2 = be32_to_cpup(p++);
+		if (xdr_stream_decode_u32(argp->xdr, &create->cr_specdata1) < 0)
+			return nfserr_bad_xdr;
+		if (xdr_stream_decode_u32(argp->xdr, &create->cr_specdata2) < 0)
+			return nfserr_bad_xdr;
 		break;
 	case NF4SOCK:
 	case NF4FIFO:
@@ -723,22 +749,18 @@ nfsd4_decode_create(struct nfsd4_compoundargs *argp, struct nfsd4_create *create
 	default:
 		break;
 	}
-
-	READ_BUF(4);
-	create->cr_namelen = be32_to_cpup(p++);
-	READ_BUF(create->cr_namelen);
-	SAVEMEM(create->cr_name, create->cr_namelen);
-	if ((status = check_filename(create->cr_name, create->cr_namelen)))
+	status = nfsd4_decode_component4(argp, &create->cr_name,
+					 &create->cr_namelen);
+	if (status)
 		return status;
-
 	status = nfsd4_decode_fattr4(argp, create->cr_bmval,
 				    ARRAY_SIZE(create->cr_bmval),
 				    &create->cr_iattr, &create->cr_acl,
 				    &create->cr_label, &create->cr_umask);
 	if (status)
-		goto out;
+		return status;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static inline __be32
-- 
2.43.0



