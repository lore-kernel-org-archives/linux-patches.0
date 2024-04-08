Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C57BB1A;
	Mon,  8 Apr 2024 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584750; cv=none; b=QxMnJHfgP3b2kpz51QmO7BBzEP2Ug+zwNaKD+dJoah/6WkDinALeCeZFZ0BUPZHHh+c9oggVsgc1m22q7LiO/9E2opIgJg9tU8XqJXP7GBEq3BQBCf4dgsUEVyiCl4p+plXuSQNv/0Lhvp7i9jhr9GnD6guLW84yNLa7+WpsYFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584750; c=relaxed/simple;
	bh=aMW9uc6LrIABUfu/FsZ8kDDccxzq3xTXjTNAeUtAsAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsS8lVZgDzM844d5C1JhTBeTIyGYG5AOg6UIsxrXBotjyupIAZAEulzXiKCBDlacLK37o4EIJrY3dWHBrm3Ht9a+wRmAM29YQIsTedTSQlob0uhR3RI7FO1zEtadhYiSQoiIrsdMFJ7LeVmw0GNcKN9KiPbFjH1DXxOK2bRE+jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os6RDpem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os6RDpem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F534C433F1;
	Mon,  8 Apr 2024 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584750;
	bh=aMW9uc6LrIABUfu/FsZ8kDDccxzq3xTXjTNAeUtAsAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os6RDpemm536c2EB/1zFf+7Jgy9rD0uMcCSsFgECkCDPkErX37UE6vj2Y8zUzWgm5
	 lfCf4/i4+WOdPdoFeZQleY+2vC57DqqAXRi+5Wag7QPhqc3TCwN/HkPC9N2dAgv3fJ
	 fx4F5qbyboXjUKyt66HJ36yiVtRAKoBMjYyuRVmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 543/690] NFSD: Add an nfsd4_encode_nfstime4() helper
Date: Mon,  8 Apr 2024 14:56:49 +0200
Message-ID: <20240408125419.324150334@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 262176798b18b12fd8ab84c94cfece0a6a652476 ]

Clean up: de-duplicate some common code.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 30c64c3f5fa05..c40876daf60c0 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2542,6 +2542,20 @@ static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode,
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
@@ -3347,11 +3361,9 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
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
@@ -3360,25 +3372,19 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
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



