Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDC215532E;
	Tue, 18 Jun 2024 12:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715428; cv=none; b=mXUWvMsaaYGznYMiiQ77LeEDvyg5595DX5ZwlWkhnJRzBApeqHbipIvpf6JjU4O4tWd043gyXD1q+Gc+vDBlRSQOLFG0+D1nRx1H8BcuR3GGQdGEqVwEqipwGRDRl97FDnO++OtHWFApFaV0GHVqvjzBo+TOcyY2jpRtRkcTFLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715428; c=relaxed/simple;
	bh=T/D/iM9bpa6c8SUUrHuhgSyG8bBFs8xGmFGd7fRzEA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQDmGCpkD/YsF+GrRRGo9sUyu1ff4zeCfH9mIKS2h70Ze+Ej+p6vA46q/qlGVrbgRZrGrhH7XUl48LkiQMGz/XqAnFLo0i3HZhReCkO2l+vGXoY6eN3W7R5TnR0H2nUUZvteG3AXegl2UMHXJvHIh0fDMJlE8YdPNNXClQOlfKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHrvAysX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHrvAysX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D6DC3277B;
	Tue, 18 Jun 2024 12:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715428;
	bh=T/D/iM9bpa6c8SUUrHuhgSyG8bBFs8xGmFGd7fRzEA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHrvAysXR7eq7vzE6J8QGNOsA4xDZdObuIHSWe4eTo+m5mibcd0iSo+FwJX9vnlil
	 rjrYDiHvD7IMbwh5dDDQTWzf+bVjKD4A74tnbwpPinOAY/ixCTZgoMeSGTVngPGefE
	 Gna8qtDpKssBpMG2nhmjkvfFbHkhi7JB1r4/m61g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 304/770] lockd: Update the NLMv1 LOCK arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:37 +0200
Message-ID: <20240618123418.997681746@linuxfoundation.org>
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

[ Upstream commit c1adb8c672ca2b085c400695ef064547d77eda29 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 56982edd47667..8a9f02e45df2d 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -267,35 +267,40 @@ nlmsvc_decode_testargs(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
-int
-nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_res *resp = rqstp->rq_resp;
-
-	if (!(p = nlm_encode_testres(p, resp)))
-		return 0;
-	return xdr_ressize_check(rqstp, p);
-}
-
 int
 nlmsvc_decode_lockargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nlm_args *argp = rqstp->rq_argp;
-	u32	exclusive;
+	u32 exclusive;
 
-	if (!(p = nlm_decode_cookie(p, &argp->cookie)))
+	if (!svcxdr_decode_cookie(xdr, &argp->cookie))
 		return 0;
-	argp->block  = ntohl(*p++);
-	exclusive    = ntohl(*p++);
-	if (!(p = nlm_decode_lock(p, &argp->lock)))
+	if (xdr_stream_decode_bool(xdr, &argp->block) < 0)
+		return 0;
+	if (xdr_stream_decode_bool(xdr, &exclusive) < 0)
+		return 0;
+	if (!svcxdr_decode_lock(xdr, &argp->lock))
 		return 0;
 	if (exclusive)
 		argp->lock.fl.fl_type = F_WRLCK;
-	argp->reclaim = ntohl(*p++);
-	argp->state   = ntohl(*p++);
+	if (xdr_stream_decode_bool(xdr, &argp->reclaim) < 0)
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &argp->state) < 0)
+		return 0;
 	argp->monitor = 1;		/* monitor client by default */
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
+}
+
+int
+nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct nlm_res *resp = rqstp->rq_resp;
+
+	if (!(p = nlm_encode_testres(p, resp)))
+		return 0;
+	return xdr_ressize_check(rqstp, p);
 }
 
 int
-- 
2.43.0



