Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41AB1741D0;
	Tue, 18 Jun 2024 12:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715437; cv=none; b=KjX/EG7lLizJQYopS7tMf3HesKQofuuLS39lriGglR3pMsX0AX6Yv03bl7KncBwNT9/PLyWn9X6+mpmv2nUVn2G8jEyxCLImWxsafN4F0lsp59Gxf4iEewL3bTyAChPiMaOeGfX7BBvDzgJCJtsAYYZ4dIqGLY9O/x9WHXgxh9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715437; c=relaxed/simple;
	bh=WJx39/98BDW+kLHIyx/jUG/Yw/Vp4vuIG7PY6eyZh/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvxXFvwXAAeedD2mYhU9ul0Er3f8fgMD3efyxr4/aN9cOw6y/C2V8HCjLp/RA6H34He/bNZOW67qsZLqGQWYcYt613VPR1zQrqm8zbIxv/j8ndalWBSyadbDZRyCIpBWsTDHkZbuB0CRfL44Bf79DpVYCyl+g+td76sxxe52smg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6Y8ZvBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6Y8ZvBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CECC3277B;
	Tue, 18 Jun 2024 12:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715437;
	bh=WJx39/98BDW+kLHIyx/jUG/Yw/Vp4vuIG7PY6eyZh/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6Y8ZvBL8BXSaMJKNS3t3uG3qwktvzsZlpRwWnQnZUw3U5F5MSAwBsxcbYxEu1PLj
	 omedGu+c6BdRm5uxrdLxBq851eEqSbnnTE0SQVoWSClIahAhtPJYF946wPJV0BlAbG
	 pwIsr0K3BhzoIICBkA7XCeHmpYLImsTho3RUfEnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/770] lockd: Update the NLMv1 nlm_res arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:40 +0200
Message-ID: <20240618123419.111389075@linuxfoundation.org>
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

[ Upstream commit 16ddcabe6240c4fb01c97f6fce6c35ddf8626ad5 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index b59e02b4417c8..911b6377a6da4 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -299,6 +299,20 @@ nlmsvc_decode_unlockargs(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+int
+nlmsvc_decode_res(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_res *resp = rqstp->rq_argp;
+
+	if (!svcxdr_decode_cookie(xdr, &resp->cookie))
+		return 0;
+	if (!svcxdr_decode_stats(xdr, &resp->status))
+		return 0;
+
+	return 1;
+}
+
 int
 nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -379,17 +393,6 @@ nlmsvc_decode_reboot(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_argsize_check(rqstp, p);
 }
 
-int
-nlmsvc_decode_res(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_res *resp = rqstp->rq_argp;
-
-	if (!(p = nlm_decode_cookie(p, &resp->cookie)))
-		return 0;
-	resp->status = *p++;
-	return xdr_argsize_check(rqstp, p);
-}
-
 int
 nlmsvc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
-- 
2.43.0



