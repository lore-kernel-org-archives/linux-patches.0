Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C8915531C;
	Tue, 18 Jun 2024 12:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715431; cv=none; b=cMTaw7Bg0KEa9apJtgBYh8x5HO/g9YVKuEgJWtA2pAPO/S8BR/ZeZ3gZR1TB0gDQFssjYZbVLup5e3OZdB4zBYUUpuIw6PUrcXwfAux4nEdJ2ZAHFJhqMrA8DaJihazkIdrYhkMz2EE6+9PAsIjshdoA30On+XEApNcggSqDLFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715431; c=relaxed/simple;
	bh=MdSqieXRtaYbRqF/ODB4JUHLbwurELY7riu4YP6M220=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckERCoiURzJ+uxCBUKCslOU9swYdh6wmtyfR63xO30+XeSiGWjf5XXCoy/f9B856eD6UxlDTpIiaPfhweSUd7siG0MR+2yq83l3j17hrGO9NdYj9kCLC/+nPrngts49xWEKd2JUH9V1jpdzVKfj14kseC+6UD6XpmKPfUMr+Hsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+9djoaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+9djoaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487DBC3277B;
	Tue, 18 Jun 2024 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715431;
	bh=MdSqieXRtaYbRqF/ODB4JUHLbwurELY7riu4YP6M220=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+9djoaRgI17SH6cDoXzh2zV+VtTIV/N2tfUYRDlneuU5UV02JWgM5RJZdzBn8Y8B
	 sBR8GoPxU63U0aMCSGimxeb3ZtT3jrWzo1phBQAX0geUY6UCho/NsRkm7thJsZE03D
	 Qn8TnGSiLG7jaAsfmmS7RmCo6Z7X2X5RQLlz6Y2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/770] lockd: Update the NLMv1 CANCEL arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:38 +0200
Message-ID: <20240618123419.035218035@linuxfoundation.org>
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

[ Upstream commit f4e08f3ac8c4945ea54a740e3afcf44b34e7cf44 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 8a9f02e45df2d..ef38f07d1224c 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -294,30 +294,34 @@ nlmsvc_decode_lockargs(struct svc_rqst *rqstp, __be32 *p)
 }
 
 int
-nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
+nlmsvc_decode_cancargs(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nlm_res *resp = rqstp->rq_resp;
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_args *argp = rqstp->rq_argp;
+	u32 exclusive;
 
-	if (!(p = nlm_encode_testres(p, resp)))
+	if (!svcxdr_decode_cookie(xdr, &argp->cookie))
 		return 0;
-	return xdr_ressize_check(rqstp, p);
+	if (xdr_stream_decode_bool(xdr, &argp->block) < 0)
+		return 0;
+	if (xdr_stream_decode_bool(xdr, &exclusive) < 0)
+		return 0;
+	if (!svcxdr_decode_lock(xdr, &argp->lock))
+		return 0;
+	if (exclusive)
+		argp->lock.fl.fl_type = F_WRLCK;
+
+	return 1;
 }
 
 int
-nlmsvc_decode_cancargs(struct svc_rqst *rqstp, __be32 *p)
+nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nlm_args *argp = rqstp->rq_argp;
-	u32	exclusive;
+	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm_decode_cookie(p, &argp->cookie)))
-		return 0;
-	argp->block = ntohl(*p++);
-	exclusive = ntohl(*p++);
-	if (!(p = nlm_decode_lock(p, &argp->lock)))
+	if (!(p = nlm_encode_testres(p, resp)))
 		return 0;
-	if (exclusive)
-		argp->lock.fl.fl_type = F_WRLCK;
-	return xdr_argsize_check(rqstp, p);
+	return xdr_ressize_check(rqstp, p);
 }
 
 int
-- 
2.43.0



