Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A9E13D8BC;
	Tue, 18 Jun 2024 12:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715183; cv=none; b=KhpYtGVeqEma7qphNXvPUDv4lKAgHxb0jQVmv4bj2h3wJ6/wrk3vXotMBCqiI3Gkdg8njYczR4nocZzbpTi7cWLqkBHGtaZqRihGr4CcxptLVJGm5gOKSf/VjRi7Nu2K6+KSoixKtgmqfBn+N2ndtjQ942H3TLbN3hWOJaTad1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715183; c=relaxed/simple;
	bh=6NpiRStYMt21FVMdQ2prTCQG6oZzslHCJE2mOvFP4Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/R6SuxUse22+o9nw0cr5yPZjSn+1NLmLNIIr8TwcjpH2tqHOlA1agiaKubOPhYsrn2H92PT6SHSl6myX4ZvH9jxHi9b7nlI9dxZUP+y6lijlhwmB6CVvWuiKJkv1kTHgqCnj+N7pm2EYs1gRMLhjPnJmVc/1hdEfVY0m+/IzFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9f6UKgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9f6UKgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4FFC3277B;
	Tue, 18 Jun 2024 12:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715182;
	bh=6NpiRStYMt21FVMdQ2prTCQG6oZzslHCJE2mOvFP4Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9f6UKgERZNORqqKyh2FXfumu9BGz8gP2mEZAiO4YT+X/5QKSAUx5HNQlUdJWqzca
	 3LwTUWi3gcxmKrVoCXQFR14tfiKuSA4/LpV57/CvnIPXK3uT4jzHWxu4RXxN08UhAD
	 +sFnMxJu/5cIyJMM9TAh1vWtcuF10cYyyQna/K/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/770] NFSD: Update the NFSv2 STATFS result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:16 +0200
Message-ID: <20240618123415.889851747@linuxfoundation.org>
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

[ Upstream commit bf15229f2ced4f14946eef958336f764e30f8efb ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index d6d7d07dbb1b2..39d296aecd3e7 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -592,19 +592,26 @@ nfssvc_encode_readdirres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_encode_statfsres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd_statfsres *resp = rqstp->rq_resp;
 	struct kstatfs	*stat = &resp->stats;
 
-	*p++ = resp->status;
-	if (resp->status != nfs_ok)
-		return xdr_ressize_check(rqstp, p);
+	if (!svcxdr_encode_stat(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		p = xdr_reserve_space(xdr, XDR_UNIT * 5);
+		if (!p)
+			return 0;
+		*p++ = cpu_to_be32(NFSSVC_MAXBLKSIZE_V2);
+		*p++ = cpu_to_be32(stat->f_bsize);
+		*p++ = cpu_to_be32(stat->f_blocks);
+		*p++ = cpu_to_be32(stat->f_bfree);
+		*p = cpu_to_be32(stat->f_bavail);
+		break;
+	}
 
-	*p++ = htonl(NFSSVC_MAXBLKSIZE_V2);	/* max transfer size */
-	*p++ = htonl(stat->f_bsize);
-	*p++ = htonl(stat->f_blocks);
-	*p++ = htonl(stat->f_bfree);
-	*p++ = htonl(stat->f_bavail);
-	return xdr_ressize_check(rqstp, p);
+	return 1;
 }
 
 int
-- 
2.43.0



