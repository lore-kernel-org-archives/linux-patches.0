Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C837214F9E2;
	Tue, 18 Jun 2024 12:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715132; cv=none; b=kh/wEiaw1rfajh6LZvxFTPRJyjoZjkkAcCTTqyI7TZ6PtxdB0WNqYFsZG3NIqiyC+ZxgGlLFAWSqV6sL6qvQN4wqblFH343/Ndclg0grH+DnikxK6TF8CX5ShJp4WkVd5iqOy/KIGwOWSfyQl+8Q6Dj2ZI9nJLmSeIoraTQu7L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715132; c=relaxed/simple;
	bh=df6sj4hD5uh8uA+K8liQuQJ7IyVxfzOrVD5uAwkg9y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uomYEXYEVdtuu4Q9FulKnzcljUw0xg4eYoC6ILDQDEtFarahGDJQexdCShlWz+G8UHCQSsTQW5a4VBFqaFKQVKtJr7CqjmYtxxfYNPENXAH4d7LQGoxKbCdfvRghEgu8leTb4UmlDLyNeuuG45IOfHKS+rJkcnREvCnlT7hKIHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+KTLImp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+KTLImp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41D0C32786;
	Tue, 18 Jun 2024 12:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715132;
	bh=df6sj4hD5uh8uA+K8liQuQJ7IyVxfzOrVD5uAwkg9y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+KTLImpwseARozc8165/dQI/MfCgPbnShgwJonfDWBDTsrMgTRy56C39MuS8FW/k
	 TvVNQiR1aDwcrEeHWNJT7Sjjq0Yf41OlTGDHWHNM6VqozU3QSL+xRUe9zDcEGxwD22
	 71+9QI7/RUFQuqEJtXzkchmdRJt12lIJ4GZVtb9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/770] NFSD: Update the NFSv3 WRITE3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:57 +0200
Message-ID: <20240618123415.150725301@linuxfoundation.org>
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

[ Upstream commit ecb7a085ac15a8844ebf12fca6ae51ce71ac9b3b ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 859cc6c51c1a5..0191cbfc486b8 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -131,6 +131,19 @@ encode_fh(__be32 *p, struct svc_fh *fhp)
 	return p + XDR_QUADLEN(size);
 }
 
+static bool
+svcxdr_encode_writeverf3(struct xdr_stream *xdr, const __be32 *verf)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, NFS3_WRITEVERFSIZE);
+	if (!p)
+		return false;
+	memcpy(p, verf, NFS3_WRITEVERFSIZE);
+
+	return true;
+}
+
 static bool
 svcxdr_decode_filename3(struct xdr_stream *xdr, char **name, unsigned int *len)
 {
@@ -1038,17 +1051,28 @@ nfs3svc_encode_readres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_writeres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_writeres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	p = encode_wcc_data(rqstp, p, &resp->fh);
-	if (resp->status == 0) {
-		*p++ = htonl(resp->count);
-		*p++ = htonl(resp->committed);
-		*p++ = resp->verf[0];
-		*p++ = resp->verf[1];
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_wcc_data(rqstp, xdr, &resp->fh))
+			return 0;
+		if (xdr_stream_encode_u32(xdr, resp->count) < 0)
+			return 0;
+		if (xdr_stream_encode_u32(xdr, resp->committed) < 0)
+			return 0;
+		if (!svcxdr_encode_writeverf3(xdr, resp->verf))
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_wcc_data(rqstp, xdr, &resp->fh))
+			return 0;
 	}
-	return xdr_ressize_check(rqstp, p);
+
+	return 1;
 }
 
 /* CREATE, MKDIR, SYMLINK, MKNOD */
-- 
2.43.0



