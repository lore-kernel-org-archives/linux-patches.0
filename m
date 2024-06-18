Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3926B14F9E2;
	Tue, 18 Jun 2024 12:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715156; cv=none; b=TZ0+BfPsTJgdECkR+NocIXLjxrQRx21T96sMQSmrIFq03geA7MjAt5Wv+TznBiC+NWu4FWUtA8o5Dgy0Ual9kaixB79kpkKybKphjTgijX7C3x4F92CNHPH+4PEPEGJKIX2fhe+nhm4j19yhKdt9vY87ioTmewf1YqeDsvMtAO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715156; c=relaxed/simple;
	bh=IeOMowhY49mHLDEcndYFkNuE05urzzbgnNeHRA9z3rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsxN5O06GiwleSUUKiV3oooE5BaV+b9EljfyauniqIrNnC+qQvspzHVc1Npl7GTDvJrBxeIujlBCJ0jtOmk+0pRWQLYAXGebnMeEOyNElAVFhhNXzG2Ob16lh7r0bwL/SIC3kNvTYrYOEP1T8smCg15dtLh0/G06eLduNRnJUBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOmAd9Gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOmAd9Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19EAC3277B;
	Tue, 18 Jun 2024 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715156;
	bh=IeOMowhY49mHLDEcndYFkNuE05urzzbgnNeHRA9z3rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOmAd9GrmyqbKobuIa43muv4N1sKbRXALSieXbpOLZm+nhcEeD4VKAlAEZps+hvQI
	 Od0L+DzuZhO7bLeCBG4FprWYs/pZ2xjj4Xk2ofeyRuVe/iuffPXlKPnY6czAoIDVm7
	 JOnoAYobz6tMzGiEOX22MxchERD7AYXgiCxi34QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/770] NFSD: Update the NFSv3 GETACL argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:25 +0200
Message-ID: <20240618123413.910025532@linuxfoundation.org>
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

[ Upstream commit 05027eafc266487c6e056d10ab352861df95b5d4 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 11 ++++++-----
 fs/nfsd/nfs3xdr.c | 11 ++++++++++-
 fs/nfsd/xdr3.h    |  1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index 9e1a92fb97712..addb0d7d5500f 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -124,19 +124,20 @@ static __be32 nfsd3_proc_setacl(struct svc_rqst *rqstp)
 /*
  * XDR decode functions
  */
+
 static int nfs3svc_decode_getaclargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_getaclargs *args = rqstp->rq_argp;
 
-	p = nfs3svc_decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->mask) < 0)
 		return 0;
-	args->mask = ntohl(*p); p++;
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
-
 static int nfs3svc_decode_setaclargs(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd3_setaclargs *args = rqstp->rq_argp;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index a30b418a51160..aa55d0ba2a548 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -53,7 +53,16 @@ svcxdr_decode_nfstime3(struct xdr_stream *xdr, struct timespec64 *timep)
 	return true;
 }
 
-static bool
+/**
+ * svcxdr_decode_nfs_fh3 - Decode an NFSv3 file handle
+ * @xdr: XDR stream positioned at an undecoded NFSv3 FH
+ * @fhp: OUT: filled-in server file handle
+ *
+ * Return values:
+ *  %false: The encoded file handle was not valid
+ *  %true: @fhp has been initialized
+ */
+bool
 svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp)
 {
 	__be32 *p;
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 5afb3ce4f0622..7456aee74f3df 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -308,6 +308,7 @@ int nfs3svc_encode_entry_plus(void *, const char *name,
 __be32 *nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p,
 				struct svc_fh *fhp);
 __be32 *nfs3svc_decode_fh(__be32 *p, struct svc_fh *fhp);
+bool svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp);
 
 
 #endif /* _LINUX_NFSD_XDR3_H */
-- 
2.43.0



