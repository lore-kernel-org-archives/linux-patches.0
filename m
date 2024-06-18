Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCD214D6EF;
	Tue, 18 Jun 2024 12:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714997; cv=none; b=csu9/pnJq6Je6qtYZ9tOc5YeJpuQzB4pKDghNrdF8KAflGH9xE9Kfau0sRLOI4KLf6vqTbKRhg1VEEU0hgzE+mUJmj1TLz8rQKjeqbyKY+XHL1koOD6E3yIlFBY0etoILITQ9HMDOwGZQgcDeYev/G7WlR4cXIdffesaWJUGaTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714997; c=relaxed/simple;
	bh=j+2mtGOlpJNcXP4RLcCcnWctqMDSdBJVGodMFXE07YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW/27TfXg6Sy8RVdMNkYI6ETO+1eCH5DWuHduJEtBxvXkS8CNG/2DtwHS9sVekAjhUj71q/35m5nh4ZMHjHZneM+/gDOA64toIgbsD1MHePfQGB51XWPRCsAukrabRmnonHv8cCH6Qau0oQmFBbOa4X6VErj0E+q8vF19zHNK80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRpVJuqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRpVJuqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52EAC32786;
	Tue, 18 Jun 2024 12:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714997;
	bh=j+2mtGOlpJNcXP4RLcCcnWctqMDSdBJVGodMFXE07YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRpVJuqKlEGWW2KHz4yIi6TxKt5xJYdi907zwew5FV1mUFYRT7ztCHDGFss5Cz57K
	 kfThs96Yiml09zVeX94Cm34UDUChgMKGlKfRpLTWomBEE2G5FFeK/jzxkrc+O3Z96w
	 sdVHlyD0Bbw4GOBriQFlZqBnb2wBXS+Fp+/XC9xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/770] NFSD: Update NFSv2 diropargs decoding to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:12 +0200
Message-ID: <20240618123413.413530154@linuxfoundation.org>
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

[ Upstream commit 6d742c1864c18f143ea2031f1ed66bcd8f4812de ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 7b33093f8d8b4..00a7db8548ebf 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -86,6 +86,38 @@ decode_filename(__be32 *p, char **namp, unsigned int *lenp)
 	return p;
 }
 
+static bool
+svcxdr_decode_filename(struct xdr_stream *xdr, char **name, unsigned int *len)
+{
+	u32 size, i;
+	__be32 *p;
+	char *c;
+
+	if (xdr_stream_decode_u32(xdr, &size) < 0)
+		return false;
+	if (size == 0 || size > NFS_MAXNAMLEN)
+		return false;
+	p = xdr_inline_decode(xdr, size);
+	if (!p)
+		return false;
+
+	*len = size;
+	*name = (char *)p;
+	for (i = 0, c = *name; i < size; i++, c++)
+		if (*c == '\0' || *c == '/')
+			return false;
+
+	return true;
+}
+
+static bool
+svcxdr_decode_diropargs(struct xdr_stream *xdr, struct svc_fh *fhp,
+			char **name, unsigned int *len)
+{
+	return svcxdr_decode_fhandle(xdr, fhp) &&
+		svcxdr_decode_filename(xdr, name, len);
+}
+
 static __be32 *
 decode_sattr(__be32 *p, struct iattr *iap, struct user_namespace *userns)
 {
@@ -234,13 +266,10 @@ nfssvc_decode_sattrargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_decode_diropargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_diropargs *args = rqstp->rq_argp;
 
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = decode_filename(p, &args->name, &args->len)))
-		return 0;
-
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_diropargs(xdr, &args->fh, &args->name, &args->len);
 }
 
 int
-- 
2.43.0



