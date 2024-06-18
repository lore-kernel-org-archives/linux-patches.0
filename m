Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DB514F130;
	Tue, 18 Jun 2024 12:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715245; cv=none; b=h9YC288uZWhleQoaZpGI85tyNs2FxcufLuX8G2L++I61K2F6iOuycBCeFhiN3L9xyIIxzvNLi4B9eJl5SELNYIzK0jVaG8qcU9KFExM5BulXorhYKYdnZoRsTK6xq4ax7P+2OIvzyu1b5PcTTDPVMA6OlzMWTIQixjkaf9f4oEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715245; c=relaxed/simple;
	bh=lER9RqQpDr5ECIXLiCuBJvgJDzlZSYHy5vAhySegagA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQ/i+pYoYMKWa/Gtm0+mfVIh+KJfkzyeH/OhlfNtAv3lM2P5T8WYYpgwMx+BizcDB/sT0PMN7+kWkpnKcTFYrh536RnB8Lhyqg9a1PJoqruoBX/XBCdvCv9WsRtIn3vVoFPwJyGjtBtbhamBPbUlx6USVng0hUXcMwpK/STDbw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ns0SuKgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ns0SuKgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFF8C3277B;
	Tue, 18 Jun 2024 12:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715244;
	bh=lER9RqQpDr5ECIXLiCuBJvgJDzlZSYHy5vAhySegagA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ns0SuKgKgqp/qCqg9HwcVgJf3ylqWw/dhClJgYOanB7WlbMaD631Xw55ZGesVd64g
	 jnHBPRD12RyGIdwvi2d6LP+0dfM8RdqFXuTpcEIzCHxj/8RUi8hQJ+aHRQ13C2Uyjl
	 mCLt62ltL+zWpAGmZoTlkI79Sy118u6G6DIECnz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/770] NFSD: Add a helper that encodes NFSv3 directory offset cookies
Date: Tue, 18 Jun 2024 14:31:05 +0200
Message-ID: <20240618123415.457478779@linuxfoundation.org>
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

[ Upstream commit a161e6c76aeba835e475a2f27dbbe5c37e565e94 ]

Refactor: De-duplicate identical code that handles encoding of
directory offset cookies across page boundaries.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 24 ++----------------------
 fs/nfsd/nfs3xdr.c  | 36 +++++++++++++++++++++++-------------
 fs/nfsd/xdr3.h     |  2 ++
 3 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 201f2009b540b..acb0a2d37dcbb 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -500,17 +500,7 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 		count += PAGE_SIZE;
 	}
 	resp->count = count >> 2;
-	if (resp->offset) {
-		if (unlikely(resp->offset1)) {
-			/* we ended up with offset on a page boundary */
-			*resp->offset = htonl(offset >> 32);
-			*resp->offset1 = htonl(offset & 0xffffffff);
-			resp->offset1 = NULL;
-		} else {
-			xdr_encode_hyper(resp->offset, offset);
-		}
-		resp->offset = NULL;
-	}
+	nfs3svc_encode_cookie3(resp, offset);
 
 	return rpc_success;
 }
@@ -565,17 +555,7 @@ nfsd3_proc_readdirplus(struct svc_rqst *rqstp)
 		count += PAGE_SIZE;
 	}
 	resp->count = count >> 2;
-	if (resp->offset) {
-		if (unlikely(resp->offset1)) {
-			/* we ended up with offset on a page boundary */
-			*resp->offset = htonl(offset >> 32);
-			*resp->offset1 = htonl(offset & 0xffffffff);
-			resp->offset1 = NULL;
-		} else {
-			xdr_encode_hyper(resp->offset, offset);
-		}
-		resp->offset = NULL;
-	}
+	nfs3svc_encode_cookie3(resp, offset);
 
 out:
 	return rpc_success;
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index eab14b52db202..e334a1454edbb 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -1219,6 +1219,28 @@ static __be32 *encode_entryplus_baggage(struct nfsd3_readdirres *cd, __be32 *p,
 	return p;
 }
 
+/**
+ * nfs3svc_encode_cookie3 - Encode a directory offset cookie
+ * @resp: readdir result context
+ * @offset: offset cookie to encode
+ *
+ */
+void nfs3svc_encode_cookie3(struct nfsd3_readdirres *resp, u64 offset)
+{
+	if (!resp->offset)
+		return;
+
+	if (resp->offset1) {
+		/* we ended up with offset on a page boundary */
+		*resp->offset = cpu_to_be32(offset >> 32);
+		*resp->offset1 = cpu_to_be32(offset & 0xffffffff);
+		resp->offset1 = NULL;
+	} else {
+		xdr_encode_hyper(resp->offset, offset);
+	}
+	resp->offset = NULL;
+}
+
 /*
  * Encode a directory entry. This one works for both normal readdir
  * and readdirplus.
@@ -1244,19 +1266,7 @@ encode_entry(struct readdir_cd *ccd, const char *name, int namlen,
 	int		elen;		/* estimated entry length in words */
 	int		num_entry_words = 0;	/* actual number of words */
 
-	if (cd->offset) {
-		u64 offset64 = offset;
-
-		if (unlikely(cd->offset1)) {
-			/* we ended up with offset on a page boundary */
-			*cd->offset = htonl(offset64 >> 32);
-			*cd->offset1 = htonl(offset64 & 0xffffffff);
-			cd->offset1 = NULL;
-		} else {
-			xdr_encode_hyper(cd->offset, offset64);
-		}
-		cd->offset = NULL;
-	}
+	nfs3svc_encode_cookie3(cd, offset);
 
 	/*
 	dprintk("encode_entry(%.*s @%ld%s)\n",
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 8073350418ae0..e76e9230827e4 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -300,6 +300,8 @@ int nfs3svc_encode_commitres(struct svc_rqst *, __be32 *);
 
 void nfs3svc_release_fhandle(struct svc_rqst *);
 void nfs3svc_release_fhandle2(struct svc_rqst *);
+
+void nfs3svc_encode_cookie3(struct nfsd3_readdirres *resp, u64 offset);
 int nfs3svc_encode_entry(void *, const char *name,
 				int namlen, loff_t offset, u64 ino,
 				unsigned int);
-- 
2.43.0



