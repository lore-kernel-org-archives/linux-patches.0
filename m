Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBB814F9C9;
	Tue, 18 Jun 2024 12:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715044; cv=none; b=YVKuwHwKW2kc8suAerkJ/3dPTw1wfNueE6Ta1lTFZlKuBFqGLU5gLBGcGV7C22rQTBjwTyHMCRxHjqzBwiat6kxovYlB9lEqRA/UA3D0KdGJhDCLF6zUlgl8YIInYEQZ/Zw0dWTyRum0vY9EDTno5hftOLpCisRLnWuRPjGbFjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715044; c=relaxed/simple;
	bh=9/DhotEpa3u/Ec3Px+HqTaLwR8guzH9bA61lvhluYm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPZSagYUTw1foYXDmn3isQuqZqGOLd65cMzLKZs8rOaaqhjGtU4yexEDS5uCXxFdNhs+oV3IW5p0eELX4qQIiRZZxYBmK8MeGJDymk2HhfYmr+mg6/TbhI3nAe14nFgSUEkmO9rRB2Ve+dnoTlN2z7obfRM5rbxPZg+coFNaJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROmibgCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROmibgCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1704C3277B;
	Tue, 18 Jun 2024 12:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715044;
	bh=9/DhotEpa3u/Ec3Px+HqTaLwR8guzH9bA61lvhluYm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROmibgCMGZ6vUSLR4o0A6apOcsZm7KqnVAcKHQ5GuhinF75HX5AmCI+yQAinIlFSl
	 +nYvlzbB2mih8xYP4/t4z/fddzvTiu/AOPnlsfcZ9DQuHJqwZHRJG0Y4Jh28L4hfXJ
	 UCYzhy+sGPzsPsqquljYjAwOhbee2xsUW0Qu/SsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/770] NFSD: Update READDIR3args decoders to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:29:56 +0200
Message-ID: <20240618123412.797457996@linuxfoundation.org>
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

[ Upstream commit 9cedc2e64c296efb3bebe93a0ceeb5e71e8d722d ]

As an additional clean up, neither nfsd3_proc_readdir() nor
nfsd3_proc_readdirplus() make use of the dircount argument, so
remove it from struct nfsd3_readdirargs.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 38 ++++++++++++++++++++++++--------------
 fs/nfsd/xdr3.h    |  1 -
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 8394aeb8381e6..eb55be106a04e 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -559,33 +559,43 @@ nfs3svc_decode_linkargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_readdirargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_readdirargs *args = rqstp->rq_argp;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
+		return 0;
+	if (xdr_stream_decode_u64(xdr, &args->cookie) < 0)
+		return 0;
+	args->verf = xdr_inline_decode(xdr, NFS3_COOKIEVERFSIZE);
+	if (!args->verf)
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->count) < 0)
 		return 0;
-	p = xdr_decode_hyper(p, &args->cookie);
-	args->verf   = p; p += 2;
-	args->dircount = ~0;
-	args->count  = ntohl(*p++);
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 int
 nfs3svc_decode_readdirplusargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_readdirargs *args = rqstp->rq_argp;
+	u32 dircount;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
+		return 0;
+	if (xdr_stream_decode_u64(xdr, &args->cookie) < 0)
+		return 0;
+	args->verf = xdr_inline_decode(xdr, NFS3_COOKIEVERFSIZE);
+	if (!args->verf)
+		return 0;
+	/* dircount is ignored */
+	if (xdr_stream_decode_u32(xdr, &dircount) < 0)
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->count) < 0)
 		return 0;
-	p = xdr_decode_hyper(p, &args->cookie);
-	args->verf     = p; p += 2;
-	args->dircount = ntohl(*p++);
-	args->count    = ntohl(*p++);
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 int
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 789a364d5e69d..64af5b01c5d7b 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -90,7 +90,6 @@ struct nfsd3_symlinkargs {
 struct nfsd3_readdirargs {
 	struct svc_fh		fh;
 	__u64			cookie;
-	__u32			dircount;
 	__u32			count;
 	__be32 *		verf;
 };
-- 
2.43.0



