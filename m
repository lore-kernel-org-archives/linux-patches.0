Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FA414F13D;
	Tue, 18 Jun 2024 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715056; cv=none; b=LiKYkAOGLgK5b5O2OemdkBaPTc165ZbTZua4jmKiY1YffV1aY15XdlX7youW3e4QWRjit2bu8vksh+dDsmXrQqbFDdhmVxHQuTo45nUs9EYO9If2PrLpoTCSAsUjfXN37egTsKG3uuB9rUn7wVlOQhn0ymtBJCbDPdO13JUN4p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715056; c=relaxed/simple;
	bh=pQS73G415LPYGFbrmfKx1h/qhVCItetiTD+uU1+wfLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwJgaUtsObMd+BEjkqp2AhDTtXfXI+fISElfvsG+jbLExH+C/jh6Fjplfdeo9XhLKruHPRrvzJ57JQSTqvAjuIzg1l1JoMBWGs9qHs2qYdbzDrE78wn3Dvr6qCnwkeStfBqjPP4bUc3i5pfzRHZmtec0mh2sj1ia0oEWeZ8vPQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YE6tCiKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YE6tCiKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C4BC3277B;
	Tue, 18 Jun 2024 12:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715055;
	bh=pQS73G415LPYGFbrmfKx1h/qhVCItetiTD+uU1+wfLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YE6tCiKfTxR/IfK5CjR09c3+7zK3KKezMy6nZL5VZrRsPKZrGEUv0eRHW+iWcpCeC
	 nf7fEBQiJGR+aFOz7EVJPrf0o7iMXVzEQrjcAARwJeqo4V5LhvRYmy4hJV6tINWvky
	 R1qPmKLJaDVPfg31YIFtjHt/YWbXfh4FrjZ5O4YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/770] NFSD: Update ACCESS3arg decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:29:50 +0200
Message-ID: <20240618123412.565466399@linuxfoundation.org>
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

[ Upstream commit 3b921a2b14251e9e203f1e8af76e8ade79f50e50 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 9 +++++----
 fs/nfsd/xdr3.h    | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 3a2b4abea1a42..e07cebd80ef7f 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -375,14 +375,15 @@ nfs3svc_decode_diropargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_decode_accessargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd3_accessargs *args = rqstp->rq_argp;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_nfs_fh3(xdr, &args->fh))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->access) < 0)
 		return 0;
-	args->access = ntohl(*p++);
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 int
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 62ea669768cf3..a4dce4baec7c3 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -25,7 +25,7 @@ struct nfsd3_diropargs {
 
 struct nfsd3_accessargs {
 	struct svc_fh		fh;
-	unsigned int		access;
+	__u32			access;
 };
 
 struct nfsd3_readargs {
-- 
2.43.0



