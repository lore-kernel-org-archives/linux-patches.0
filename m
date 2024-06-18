Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C1E1419BA;
	Tue, 18 Jun 2024 12:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714791; cv=none; b=SmU2QHXVIwxCF3uGMGIaRNUQ15+CBtUsyq7B5zFSMTay3MPHrG8omt8Hr4trvm5pr/vFDuZ//b2cHeGax4RwU67QMcTqU0OGs2jPHrF/NyN3GbkmK1JDfGhOWHRGKXJ6mKN2MrfjGJ+UbhEooldzyTei5PkoPGu1PksiNLRBKFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714791; c=relaxed/simple;
	bh=DAqgWnzt2JFgsMoqpDldCiPg4oiOscK2VulYDRD6X08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4sUDHJXl4a9gfIc79VLlUH1rQKEcMijtZ+180sEHO9eZCSMBlIshoZWfhIOzJIwBqhouC5Dek5TX73mEozirA7yzORYAj7aUD3d0LkdhL26mSPGYlcegQ3GtgMLwtohbh3j92f2/aw8HZfJEIyDF9JbnJ4/bUhCgOF8SixJ5eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgObb3qS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgObb3qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53291C3277B;
	Tue, 18 Jun 2024 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714790;
	bh=DAqgWnzt2JFgsMoqpDldCiPg4oiOscK2VulYDRD6X08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgObb3qS06cLtywhNYNDZmVJtGVN2qgpAIT2+T7VjohwdfmDU6lbd5MKRI4tWuU8r
	 cGdzXuzs36VAEoALd+O6O2Jq6kAO3CLbtl70t6McI1GXHhHiHyoj+UjPFeKv+oi3uS
	 72UMhG/YPjmdAi3UV7AKXJfkwQs+fc7R8SxCOI5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/770] NFSD: Replace READ* macros in nfsd4_decode_setxattr()
Date: Tue, 18 Jun 2024 14:29:02 +0200
Message-ID: <20240618123410.711216936@linuxfoundation.org>
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

[ Upstream commit 403366a7e8e2930002157525cd44add7fa01bca9 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 1fcb668e4110d..38610764d7161 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2184,11 +2184,11 @@ static __be32
 nfsd4_decode_setxattr(struct nfsd4_compoundargs *argp,
 		      struct nfsd4_setxattr *setxattr)
 {
-	DECODE_HEAD;
 	u32 flags, maxcount, size;
+	__be32 status;
 
-	READ_BUF(4);
-	flags = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &flags) < 0)
+		return nfserr_bad_xdr;
 
 	if (flags > SETXATTR4_REPLACE)
 		return nfserr_inval;
@@ -2201,8 +2201,8 @@ nfsd4_decode_setxattr(struct nfsd4_compoundargs *argp,
 	maxcount = svc_max_payload(argp->rqstp);
 	maxcount = min_t(u32, XATTR_SIZE_MAX, maxcount);
 
-	READ_BUF(4);
-	size = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &size) < 0)
+		return nfserr_bad_xdr;
 	if (size > maxcount)
 		return nfserr_xattr2big;
 
@@ -2211,12 +2211,12 @@ nfsd4_decode_setxattr(struct nfsd4_compoundargs *argp,
 		struct xdr_buf payload;
 
 		if (!xdr_stream_subsegment(argp->xdr, &payload, size))
-			goto xdr_error;
+			return nfserr_bad_xdr;
 		status = nfsd4_vbuf_from_vector(argp, &payload,
 						&setxattr->setxa_buf, size);
 	}
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



