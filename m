Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E980114EC75;
	Tue, 18 Jun 2024 12:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715012; cv=none; b=mm3xLnHNHV4xZg5euSpR3NPeKH/ADaIs+3a86nw7pNy8gUyyqAXtk49RbZAJ2tlc26+eku2B/WD60FjiZYF51w+XuT+Lx668H9VsLxaCUlhhrsHeCK7BSRPn2VVQnlgrc6OzisoeooTGLB21Gvw4ln+I75cQwSEE9ZIbMDYs03k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715012; c=relaxed/simple;
	bh=4MdQdzJFH9Ohdr3lb9VXGRooENhYX3rSrssdSQ571eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajeKW/1RbDF2V9A92i0veBOSzuyBa4HG4gHEI4K+qSbRRKJTg2zg1T/EJj+rY2VY59srf8cMaYOl5D4HCI2YGVKl5jTQTwc2qtWhZe33FjD880uACp77xVdDOIICq/xojWLr/qBSUfYZpPC6kJQEnqRoxOaOHTDzyndk5y9s4AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSKnqXCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSKnqXCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AEDC3277B;
	Tue, 18 Jun 2024 12:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715011;
	bh=4MdQdzJFH9Ohdr3lb9VXGRooENhYX3rSrssdSQ571eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSKnqXCq1F/06CtyP6zml6rTQd9PZq0eONMViHPzFyI7WfT8Jh3ALvvl/p7Sgy+A3
	 1nl+IKqUf9jta1qHneoJ0qnIKPHjwEJJ4HD1F1a3foHiYLIKYMnSZ6+tz7x4JNUSPw
	 WLXtJjQJs292gm1rNRvbH+CqYG/3J1YPOQs4XVE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/770] NFSD: Update the NFSv2 SYMLINK argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:17 +0200
Message-ID: <20240618123413.606070046@linuxfoundation.org>
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

[ Upstream commit 09f75a5375ac61f4adb94da0accc1cfc60eb4f2b ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 113 +++++------------------------------------------
 1 file changed, 10 insertions(+), 103 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 2e2806cbe7b88..f2cb4794aeaf6 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -66,26 +66,6 @@ encode_fh(__be32 *p, struct svc_fh *fhp)
 	return p + (NFS_FHSIZE>> 2);
 }
 
-/*
- * Decode a file name and make sure that the path contains
- * no slashes or null bytes.
- */
-static __be32 *
-decode_filename(__be32 *p, char **namp, unsigned int *lenp)
-{
-	char		*name;
-	unsigned int	i;
-
-	if ((p = xdr_decode_string_inplace(p, namp, lenp, NFS_MAXNAMLEN)) != NULL) {
-		for (i = 0, name = *namp; i < *lenp; i++, name++) {
-			if (*name == '\0' || *name == '/')
-				return NULL;
-		}
-	}
-
-	return p;
-}
-
 static bool
 svcxdr_decode_filename(struct xdr_stream *xdr, char **name, unsigned int *len)
 {
@@ -118,61 +98,6 @@ svcxdr_decode_diropargs(struct xdr_stream *xdr, struct svc_fh *fhp,
 		svcxdr_decode_filename(xdr, name, len);
 }
 
-static __be32 *
-decode_sattr(__be32 *p, struct iattr *iap, struct user_namespace *userns)
-{
-	u32	tmp, tmp1;
-
-	iap->ia_valid = 0;
-
-	/* Sun client bug compatibility check: some sun clients seem to
-	 * put 0xffff in the mode field when they mean 0xffffffff.
-	 * Quoting the 4.4BSD nfs server code: Nah nah nah nah na nah.
-	 */
-	if ((tmp = ntohl(*p++)) != (u32)-1 && tmp != 0xffff) {
-		iap->ia_valid |= ATTR_MODE;
-		iap->ia_mode = tmp;
-	}
-	if ((tmp = ntohl(*p++)) != (u32)-1) {
-		iap->ia_uid = make_kuid(userns, tmp);
-		if (uid_valid(iap->ia_uid))
-			iap->ia_valid |= ATTR_UID;
-	}
-	if ((tmp = ntohl(*p++)) != (u32)-1) {
-		iap->ia_gid = make_kgid(userns, tmp);
-		if (gid_valid(iap->ia_gid))
-			iap->ia_valid |= ATTR_GID;
-	}
-	if ((tmp = ntohl(*p++)) != (u32)-1) {
-		iap->ia_valid |= ATTR_SIZE;
-		iap->ia_size = tmp;
-	}
-	tmp  = ntohl(*p++); tmp1 = ntohl(*p++);
-	if (tmp != (u32)-1 && tmp1 != (u32)-1) {
-		iap->ia_valid |= ATTR_ATIME | ATTR_ATIME_SET;
-		iap->ia_atime.tv_sec = tmp;
-		iap->ia_atime.tv_nsec = tmp1 * 1000; 
-	}
-	tmp  = ntohl(*p++); tmp1 = ntohl(*p++);
-	if (tmp != (u32)-1 && tmp1 != (u32)-1) {
-		iap->ia_valid |= ATTR_MTIME | ATTR_MTIME_SET;
-		iap->ia_mtime.tv_sec = tmp;
-		iap->ia_mtime.tv_nsec = tmp1 * 1000; 
-		/*
-		 * Passing the invalid value useconds=1000000 for mtime
-		 * is a Sun convention for "set both mtime and atime to
-		 * current server time".  It's needed to make permissions
-		 * checks for the "touch" program across v2 mounts to
-		 * Solaris and Irix boxes work correctly. See description of
-		 * sattr in section 6.1 of "NFS Illustrated" by
-		 * Brent Callaghan, Addison-Wesley, ISBN 0-201-32750-5
-		 */
-		if (tmp1 == 1000000)
-			iap->ia_valid &= ~(ATTR_ATIME_SET|ATTR_MTIME_SET);
-	}
-	return p;
-}
-
 static bool
 svcxdr_decode_sattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		    struct iattr *iap)
@@ -435,40 +360,22 @@ nfssvc_decode_linkargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_decode_symlinkargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_symlinkargs *args = rqstp->rq_argp;
-	char *base = (char *)p;
-	size_t xdrlen;
+	struct kvec *head = rqstp->rq_arg.head;
 
-	if (   !(p = decode_fh(p, &args->ffh))
-	    || !(p = decode_filename(p, &args->fname, &args->flen)))
+	if (!svcxdr_decode_diropargs(xdr, &args->ffh, &args->fname, &args->flen))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->tlen) < 0)
 		return 0;
-
-	args->tlen = ntohl(*p++);
 	if (args->tlen == 0)
 		return 0;
 
-	args->first.iov_base = p;
-	args->first.iov_len = rqstp->rq_arg.head[0].iov_len;
-	args->first.iov_len -= (char *)p - base;
-
-	/* This request is never larger than a page. Therefore,
-	 * transport will deliver either:
-	 * 1. pathname in the pagelist -> sattr is in the tail.
-	 * 2. everything in the head buffer -> sattr is in the head.
-	 */
-	if (rqstp->rq_arg.page_len) {
-		if (args->tlen != rqstp->rq_arg.page_len)
-			return 0;
-		p = rqstp->rq_arg.tail[0].iov_base;
-	} else {
-		xdrlen = XDR_QUADLEN(args->tlen);
-		if (xdrlen > args->first.iov_len - (8 * sizeof(__be32)))
-			return 0;
-		p += xdrlen;
-	}
-	decode_sattr(p, &args->attrs, nfsd_user_namespace(rqstp));
-
-	return 1;
+	args->first.iov_len = head->iov_len - xdr_stream_pos(xdr);
+	args->first.iov_base = xdr_inline_decode(xdr, args->tlen);
+	if (!args->first.iov_base)
+		return 0;
+	return svcxdr_decode_sattr(rqstp, xdr, &args->attrs);
 }
 
 int
-- 
2.43.0



