Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A0F15A857;
	Tue, 18 Jun 2024 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716825; cv=none; b=NGsIges1afDLpKIe4LzyycGO6wmVkdJ9ooghZSTogjL2Mcmt04CxvF66ze1LUqqtoJdx/cZPJZzhw41m/+gGDj5uH1KvaA6lNVg9Zt9PGmkXqaCF4sY9BvOKdebWGeFDJn9UNgvTvNNdVGVFH7iqi36gS7LdNDGkJnkQ+z0wb6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716825; c=relaxed/simple;
	bh=ZSv4ddwQKUCMSKQL98iP/hGYzk29HspwX2m/dLSjJ1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi7di/+THZZYfmtofwWvIljTptX7TUenCOKL+sfUUN5ngsUpWQoHQBfe3TNGdZnO/x0MZXYwYd5YcSoefq9thzUWwazBFNvUkWQVUps9c/fw9g1v97gV4xqMmEBGtYkOrE8pPCETyvUUBI9+WAWrMBnGS59PVzts7vH2ISgk61A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAcdodbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAcdodbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E600C3277B;
	Tue, 18 Jun 2024 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716825;
	bh=ZSv4ddwQKUCMSKQL98iP/hGYzk29HspwX2m/dLSjJ1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAcdodbPqlqaqbmB34sfCbBIw1vahNM572Drd3YEqocdRMq23Ov/A3B+uzqoXXG/a
	 lz4IR2PW1wypCRn51R09Qmcpm6H2RucaDbf56zjjBf5P+Cmo+VTQAhmIAHFNuDRAn/
	 xK/UA+1FcTMS2dXVWtR9phEeoiFclO20goyRRiFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 758/770] NFSD: Add an nfsd4_encode_nfstime4() helper
Date: Tue, 18 Jun 2024 14:40:11 +0200
Message-ID: <20240618123436.527723149@linuxfoundation.org>
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

[ Upstream commit 262176798b18b12fd8ab84c94cfece0a6a652476 ]

Clean up: de-duplicate some common code.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d62382dfc135e..a81938c1e3efb 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2541,6 +2541,20 @@ static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode,
 	return p;
 }
 
+static __be32 nfsd4_encode_nfstime4(struct xdr_stream *xdr,
+				    struct timespec64 *tv)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT * 3);
+	if (!p)
+		return nfserr_resource;
+
+	p = xdr_encode_hyper(p, (s64)tv->tv_sec);
+	*p = cpu_to_be32(tv->tv_nsec);
+	return nfs_ok;
+}
+
 /*
  * ctime (in NFSv4, time_metadata) is not writeable, and the client
  * doesn't really care what resolution could theoretically be stored by
@@ -3346,11 +3360,9 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		p = xdr_encode_hyper(p, dummy64);
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_ACCESS) {
-		p = xdr_reserve_space(xdr, 12);
-		if (!p)
-			goto out_resource;
-		p = xdr_encode_hyper(p, (s64)stat.atime.tv_sec);
-		*p++ = cpu_to_be32(stat.atime.tv_nsec);
+		status = nfsd4_encode_nfstime4(xdr, &stat.atime);
+		if (status)
+			goto out;
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_DELTA) {
 		p = xdr_reserve_space(xdr, 12);
@@ -3359,25 +3371,19 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		p = encode_time_delta(p, d_inode(dentry));
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_METADATA) {
-		p = xdr_reserve_space(xdr, 12);
-		if (!p)
-			goto out_resource;
-		p = xdr_encode_hyper(p, (s64)stat.ctime.tv_sec);
-		*p++ = cpu_to_be32(stat.ctime.tv_nsec);
+		status = nfsd4_encode_nfstime4(xdr, &stat.ctime);
+		if (status)
+			goto out;
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_MODIFY) {
-		p = xdr_reserve_space(xdr, 12);
-		if (!p)
-			goto out_resource;
-		p = xdr_encode_hyper(p, (s64)stat.mtime.tv_sec);
-		*p++ = cpu_to_be32(stat.mtime.tv_nsec);
+		status = nfsd4_encode_nfstime4(xdr, &stat.mtime);
+		if (status)
+			goto out;
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_CREATE) {
-		p = xdr_reserve_space(xdr, 12);
-		if (!p)
-			goto out_resource;
-		p = xdr_encode_hyper(p, (s64)stat.btime.tv_sec);
-		*p++ = cpu_to_be32(stat.btime.tv_nsec);
+		status = nfsd4_encode_nfstime4(xdr, &stat.btime);
+		if (status)
+			goto out;
 	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
 		u64 ino = stat.ino;
-- 
2.43.0



