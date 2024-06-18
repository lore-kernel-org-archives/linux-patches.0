Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942F614EC71;
	Tue, 18 Jun 2024 12:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714976; cv=none; b=EwxVmXULQbl5a4hiXKDnSMbEK+Zg9g8AOLOpNRZQqrWMeZIEqW7i7koZs1BTC/P5u5CdETk52hPg4Tnin5UwM6ukRPzYysyiSazZRSZZ7xmGG52pdOFnF+g39+TZS0AWXWzCXTWpXn4+THUptpg4YC7Y8zVKwFxiGpKC0Was+rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714976; c=relaxed/simple;
	bh=qlMrfBg4PqPYY+r22LBoSMlBT0XM9Udsml+fuSfHN0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qni5Xo+RF0jHlbgduxIEeTcICJuGzabSx68omra06QX9zIlGT9uhI9OFMP9kFDCgOnJ+SOtAzy66ngRqHATK40MGMn0E+RN+MY774E7J6zyohKXjprqt+64K10YbGaG+L9rHWJFvEctqa6E76ToYeRW7jDvSAjzvWO9Flf1ZWN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pl20153A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pl20153A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F59C3277B;
	Tue, 18 Jun 2024 12:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714976;
	bh=qlMrfBg4PqPYY+r22LBoSMlBT0XM9Udsml+fuSfHN0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pl20153AYku82ABCsiarOlgOcki6rWuYVJX4+qBJa7Djn5xp8reX3B8dzNNbOZ9YF
	 biULJ5sFBGzVpVApPSSSlgtQKTPVdwZuOZcjVa7E3J5R4pnQTcNaxeTk9Lin1Heuvy
	 nuV/xTNq7AhcbEs01jr4TjOJiRlLP0JxST5pmqQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/770] NFSD: Update the NFSv2 GETATTR argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:06 +0200
Message-ID: <20240618123413.182083662@linuxfoundation.org>
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

[ Upstream commit ebcd8e8b28535b643a4c06685bd363b3b73a96af ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c |  4 ++--
 fs/nfsd/nfsxdr.c  | 26 ++++++++++++++++++++------
 fs/nfsd/xdr.h     |  2 +-
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index f22f70f63b53e..3cac9972aa83f 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -627,7 +627,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	},
 	[NFSPROC_GETATTR] = {
 		.pc_func = nfsd_proc_getattr,
-		.pc_decode = nfssvc_decode_fhandle,
+		.pc_decode = nfssvc_decode_fhandleargs,
 		.pc_encode = nfssvc_encode_attrstat,
 		.pc_release = nfssvc_release_attrstat,
 		.pc_argsize = sizeof(struct nfsd_fhandle),
@@ -793,7 +793,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	},
 	[NFSPROC_STATFS] = {
 		.pc_func = nfsd_proc_statfs,
-		.pc_decode = nfssvc_decode_fhandle,
+		.pc_decode = nfssvc_decode_fhandleargs,
 		.pc_encode = nfssvc_encode_statfsres,
 		.pc_argsize = sizeof(struct nfsd_fhandle),
 		.pc_ressize = sizeof(struct nfsd_statfsres),
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 7aa6e8aca2c1a..f3189e1be20fa 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -23,8 +23,9 @@ static u32	nfs_ftypes[] = {
 
 
 /*
- * XDR functions for basic NFS types
+ * Basic NFSv2 data types (RFC 1094 Section 2.3)
  */
+
 static __be32 *
 decode_fh(__be32 *p, struct svc_fh *fhp)
 {
@@ -37,6 +38,21 @@ decode_fh(__be32 *p, struct svc_fh *fhp)
 	return p + (NFS_FHSIZE >> 2);
 }
 
+static bool
+svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(xdr, NFS_FHSIZE);
+	if (!p)
+		return false;
+	fh_init(fhp, NFS_FHSIZE);
+	memcpy(&fhp->fh_handle.fh_base, p, NFS_FHSIZE);
+	fhp->fh_handle.fh_size = NFS_FHSIZE;
+
+	return true;
+}
+
 /* Helper function for NFSv2 ACL code */
 __be32 *nfs2svc_decode_fh(__be32 *p, struct svc_fh *fhp)
 {
@@ -194,14 +210,12 @@ __be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *f
  */
 
 int
-nfssvc_decode_fhandle(struct svc_rqst *rqstp, __be32 *p)
+nfssvc_decode_fhandleargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_fhandle *args = rqstp->rq_argp;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
-		return 0;
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_fhandle(xdr, &args->fh);
 }
 
 int
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index edd87688ff863..50466ac6200cc 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -144,7 +144,7 @@ union nfsd_xdrstore {
 #define NFS2_SVC_XDRSIZE	sizeof(union nfsd_xdrstore)
 
 
-int nfssvc_decode_fhandle(struct svc_rqst *, __be32 *);
+int nfssvc_decode_fhandleargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_sattrargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_diropargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_readargs(struct svc_rqst *, __be32 *);
-- 
2.43.0



