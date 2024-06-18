Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AD914F13D;
	Tue, 18 Jun 2024 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715050; cv=none; b=JtJasEYDYwlxBmf3drqGrbvWFA8LOOFUSrY8Ma/UcBNRK2NU1B6KAZSADXGoFcywR8pnXnrgON39Ed99LA0QojKJbJ2nnF8Mm5egcrLE9NRM7dtwqq8dc0Hh+s8pbWQuIwjzGjcSK13tCZukmdCjpzoI7OwRzcwDV7TXQTn5uL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715050; c=relaxed/simple;
	bh=ZcqHbl1kQHN/4tOxIpGp2tNPPsw7da2x9s6HcUw0ATs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmKM9p8vzJ/LRnSW6usFR44RNNACPtjMNCJNQiXC5dIjT1fxzt6xfYZRegG9z8MurmhfvWE0bpiJKdQCebAj/Xvyt6EzEOqDxJChbG/7dIadrFFp1EZVtFJ494A2FGb+Z7L6QnGURqXlzrZGsmCEoYplurHJ2jJfSSGRxJTT2I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaCjaPUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaCjaPUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A32C32786;
	Tue, 18 Jun 2024 12:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715050;
	bh=ZcqHbl1kQHN/4tOxIpGp2tNPPsw7da2x9s6HcUw0ATs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaCjaPUrDnoVMWPfD5D04SFqb2Q2Y46XCq35G6qBxuF1SVLrKrAtH8tC91Cse9msM
	 nErdpbNAqeS5UYTGb6F2gUYnRGZbr+Ln0ouOGza1mWuy6JGQiLaZ/oNZHMr33VtXB2
	 uZhbrhEUS9Cr01jc5WoBprwcFMrKrJ4HZ09mN19c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/770] NFSD: Update the NFSv3 DIROPargs decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:29:58 +0200
Message-ID: <20240618123412.873111329@linuxfoundation.org>
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

[ Upstream commit 54d1d43dc709f58be38d278bfc38e9bfb38d35fc ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index bafb84c978616..299ea8bbd685f 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -117,6 +117,39 @@ decode_filename(__be32 *p, char **namp, unsigned int *lenp)
 	return p;
 }
 
+static bool
+svcxdr_decode_filename3(struct xdr_stream *xdr, char **name, unsigned int *len)
+{
+	u32 size, i;
+	__be32 *p;
+	char *c;
+
+	if (xdr_stream_decode_u32(xdr, &size) < 0)
+		return false;
+	if (size == 0 || size > NFS3_MAXNAMLEN)
+		return false;
+	p = xdr_inline_decode(xdr, size);
+	if (!p)
+		return false;
+
+	*len = size;
+	*name = (char *)p;
+	for (i = 0, c = *name; i < size; i++, c++) {
+		if (*c == '\0' || *c == '/')
+			return false;
+	}
+
+	return true;
+}
+
+static bool
+svcxdr_decode_diropargs3(struct xdr_stream *xdr, struct svc_fh *fhp,
+			 char **name, unsigned int *len)
+{
+	return svcxdr_decode_nfs_fh3(xdr, fhp) &&
+		svcxdr_decode_filename3(xdr, name, len);
+}
+
 static __be32 *
 decode_sattr3(__be32 *p, struct iattr *iap, struct user_namespace *userns)
 {
@@ -363,13 +396,10 @@ nfs3svc_decode_sattrargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_diropargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_diropargs *args = rqstp->rq_argp;
 
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = decode_filename(p, &args->name, &args->len)))
-		return 0;
-
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_diropargs3(xdr, &args->fh, &args->name, &args->len);
 }
 
 int
-- 
2.43.0



