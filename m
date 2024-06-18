Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C38E15696E;
	Tue, 18 Jun 2024 12:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715556; cv=none; b=flrjkpHuOYJNbZRD46uCLMSqkjJCyeXeuWdncNm/bhS9hj87nf99uLcwX+GnTnM+U7kluHfuP/hG7/06wwfmh3LgEBiwrmVLScz04PiCt4mBT/HIYbN6NNAkyc8xIQ8cvsBwfEP1ghXORroZ46qFPEKMvkqRQr7Et4mMC09JjlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715556; c=relaxed/simple;
	bh=yX1iuB3AGbf0hldLRQDYfIDsmd84aQMFZuJ3y/AB+C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7/u/zMH9geEOXXEGMsVy53vwgYMJlETps9L8oTqctptgNqWA0axSx4dZ5ubgJzC9d5zbAjhD1f1VQooUT+R3yf643X4ez2ZQwk74DWPlbeAIp+IDGgpfH1mJXXNeAbHSdPafY8mimV8u66oYhe9ft7557TVVHnxi/NY4DuZ8I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NY0a8wVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NY0a8wVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225F3C3277B;
	Tue, 18 Jun 2024 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715556;
	bh=yX1iuB3AGbf0hldLRQDYfIDsmd84aQMFZuJ3y/AB+C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NY0a8wVNwhM8Ul0u54xnaPz4sO0HmgJquqi5koJgYNf/tWHkLxl9gjJz46LxC7/4W
	 DXd412fFq/BoOkZNG3gQ3dQsnvVkHfZhN209LKu13MTvRlNy8z6gCWO6Eib5yeZtBw
	 SSl9ERd2+hZUMFQdduGBAOAWN7Lf0etJpKZ/IYwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/770] lockd: Update the NLMv4 LOCK arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:50 +0200
Message-ID: <20240618123419.494749960@linuxfoundation.org>
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

[ Upstream commit 0e5977af4fdc277984fca7d8c2e0c880935775a0 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index cf64794fdc1fa..1d3e780c25fd5 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -264,35 +264,40 @@ nlm4svc_decode_testargs(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
-int
-nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_res *resp = rqstp->rq_resp;
-
-	if (!(p = nlm4_encode_testres(p, resp)))
-		return 0;
-	return xdr_ressize_check(rqstp, p);
-}
-
 int
 nlm4svc_decode_lockargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nlm_args *argp = rqstp->rq_argp;
-	u32	exclusive;
+	u32 exclusive;
 
-	if (!(p = nlm4_decode_cookie(p, &argp->cookie)))
+	if (!svcxdr_decode_cookie(xdr, &argp->cookie))
 		return 0;
-	argp->block  = ntohl(*p++);
-	exclusive    = ntohl(*p++);
-	if (!(p = nlm4_decode_lock(p, &argp->lock)))
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
+nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct nlm_res *resp = rqstp->rq_resp;
+
+	if (!(p = nlm4_encode_testres(p, resp)))
+		return 0;
+	return xdr_ressize_check(rqstp, p);
 }
 
 int
-- 
2.43.0



