Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3E918040;
	Tue, 18 Jun 2024 12:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715494; cv=none; b=iGlPsDmdY58m2tlHMM/CDUot1sqvUOH4z8gefy0IH6QavvNG1UH599EGMOEcP26SJxqfV2xWE2/f/YElwlSh6ISairrw8NnXHt9LaHDVZvuv6hQHlh+sHD9lLNPNcTpM+Wk1MQgQzAo2egYPsHqm4qriOvSp63JLmKlTceDxxKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715494; c=relaxed/simple;
	bh=BruV77qX5bW1E686uBmUOu5YPhUal+pfhtlwg9oneMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8tm/RpHZ0RHrpYz67S62OWAzViuTGgXXxaq7LePpsx1r5khHW0e2pBI/9G5RrKy6Bya8qVKYmPjNZxUmOHMZ7hAb1I83Gty9B6y2O0rKS+pgv3yN//NhlELruxprNuelXlYFqzAsvQ2ymwoaGj5Z4XVjJBJVMr6ac+4bjfpfnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lM8ipxyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lM8ipxyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CD3C3277B;
	Tue, 18 Jun 2024 12:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715493;
	bh=BruV77qX5bW1E686uBmUOu5YPhUal+pfhtlwg9oneMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lM8ipxyHdkq6KrDO4QjZ75LwwjncsJqBVz8CEj35sIM+r5vchX4VUf9Znafv7if/u
	 R9KmG5zGC4cpaiIwAdmypOlQ20bS2NztY3T83TL4/YkjrPeF4WGGgX+HFGDj09NH7F
	 tReNvvP9URn0Q8UtGNEil8TwjoonNMmJJEZagwWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/770] lockd: Update the NLMv1 FREE_ALL arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:43 +0200
Message-ID: <20240618123419.225834399@linuxfoundation.org>
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

[ Upstream commit 14e105256b9dcdf50a003e2e9a0da77e06770a4b ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index c496f18eff06e..091c8c463ab40 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -316,6 +316,21 @@ nlmsvc_decode_shareargs(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+int
+nlmsvc_decode_notify(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_args *argp = rqstp->rq_argp;
+	struct nlm_lock	*lock = &argp->lock;
+
+	if (!svcxdr_decode_string(xdr, &lock->caller, &lock->len))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &argp->state) < 0)
+		return 0;
+
+	return 1;
+}
+
 int
 nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -349,19 +364,6 @@ nlmsvc_encode_res(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_ressize_check(rqstp, p);
 }
 
-int
-nlmsvc_decode_notify(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_args *argp = rqstp->rq_argp;
-	struct nlm_lock	*lock = &argp->lock;
-
-	if (!(p = xdr_decode_string_inplace(p, &lock->caller,
-					    &lock->len, NLM_MAXSTRLEN)))
-		return 0;
-	argp->state = ntohl(*p++);
-	return xdr_argsize_check(rqstp, p);
-}
-
 int
 nlmsvc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
-- 
2.43.0



