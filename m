Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4567D15539D;
	Tue, 18 Jun 2024 12:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715464; cv=none; b=qw2/UvVUuD9TPICc0IDGXV0blMC1EHTszJ0c7WJvF7rh4c3b64fPsqsI2YVsxsMvoWnD2yNagGRgpbyc85ukeHGvYCvHa66OwHrCgqJxOmoGTAdqU9dHuZjNmjeKhG8paP/f4JtrKIUQkkaj/8VFFqKj3eW/dOz0X9+ah+SaRXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715464; c=relaxed/simple;
	bh=rWjS8wIFEJ/QQo7q5ice11lCKRE+oC82A0yaWsjJx0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwBpzcrjtDDFcXEIzVKLgQbBqYbnGnYtWpScSojEJZ+cyVwBtcVdyKsNRwhS4o5oqAum94Wi7zRd4sDC1vdC4a3XqnYag5nWKx5z1DHIP6F3eMg7cZy4+SU6bKgm7IyjNW2QQ3oQ2u8zWAJ4DQnmPFCr6Z0hbHq3d4emnioHqPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtkdQ46r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtkdQ46r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06BFC3277B;
	Tue, 18 Jun 2024 12:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715464;
	bh=rWjS8wIFEJ/QQo7q5ice11lCKRE+oC82A0yaWsjJx0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtkdQ46rY4T2Y3QzzDuNKBpiWTFnDzEgLSIoR0jM01NfVljcumK+s5l22WuonKFB2
	 Z/+D0X4tVzI0CLv9YXKJq6HZh5NYUBNyP5kOzfbMMX8sAh8TAIqN6CndeQcazAEJmr
	 Ad38o9O4OD8mengXALwFoGgDuwxzCItx0NDGdz10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/770] lockd: Update the NLMv4 CANCEL arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:51 +0200
Message-ID: <20240618123419.532335548@linuxfoundation.org>
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

[ Upstream commit 1e1f38dcf3c031715191e1fd26f70a0affca4dbd ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 1d3e780c25fd5..37d45f1d71999 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -291,30 +291,33 @@ nlm4svc_decode_lockargs(struct svc_rqst *rqstp, __be32 *p)
 }
 
 int
-nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
+nlm4svc_decode_cancargs(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nlm_res *resp = rqstp->rq_resp;
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_args *argp = rqstp->rq_argp;
+	u32 exclusive;
 
-	if (!(p = nlm4_encode_testres(p, resp)))
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
+	return 1;
 }
 
 int
-nlm4svc_decode_cancargs(struct svc_rqst *rqstp, __be32 *p)
+nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nlm_args *argp = rqstp->rq_argp;
-	u32	exclusive;
+	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm4_decode_cookie(p, &argp->cookie)))
-		return 0;
-	argp->block = ntohl(*p++);
-	exclusive = ntohl(*p++);
-	if (!(p = nlm4_decode_lock(p, &argp->lock)))
+	if (!(p = nlm4_encode_testres(p, resp)))
 		return 0;
-	if (exclusive)
-		argp->lock.fl.fl_type = F_WRLCK;
-	return xdr_argsize_check(rqstp, p);
+	return xdr_ressize_check(rqstp, p);
 }
 
 int
-- 
2.43.0



