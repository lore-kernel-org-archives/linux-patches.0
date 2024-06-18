Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00D2171E7C;
	Tue, 18 Jun 2024 12:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715434; cv=none; b=LJjWwLLocrUnUjkEaC7Ms4te28Skf+XWVrSNv0hfnVTV9UuzWNuXuj3CA2efrdQ/hz2WnivjsLTsDcS4YS2Wzgy5azl+D7i6zkSAVK2eMzjKzwh1p8VbfTLBhotyuuZKslO4RNawi9U4TWwP9D0l876lpZh0Sj3lLIOVSb0ABpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715434; c=relaxed/simple;
	bh=/cHQCEJ6JQZGBYMvsLvG8InuecQPdS2/wfa0ZAfnuMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLfWOBk+Gu09shRx921rfEKSKqiXlVajjj5AivDV2nxDFP/eVL/t1gmZvk/DdkX9uIlLhlh96eaJ1iZvBFVjZ4twiKXunK+HQuCLYKUwVWg7iOUoJOkk0ws98q360q8qm8+ie1n9eXmL1hL3NafmMtkn9lKR9bkkYagTQm8K7wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tnur2S5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tnur2S5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402CFC3277B;
	Tue, 18 Jun 2024 12:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715434;
	bh=/cHQCEJ6JQZGBYMvsLvG8InuecQPdS2/wfa0ZAfnuMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tnur2S5bV3EdZT+koM5J1OmsWCI2zNaQ0qeEN5xiFLiYcM8KMXHdr7t2DcnA3pmL/
	 hsEepLtjbUrJSndM0An8nMuTo2Ln5wVGc4M2Vkwv1oK5hr2yL2mXPBBttVeUS0/1at
	 2rsOc/IH2rs6u50e2j2f5+hpn/P44Hz4J2llDt0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/770] lockd: Update the NLMv1 UNLOCK arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:39 +0200
Message-ID: <20240618123419.073696927@linuxfoundation.org>
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

[ Upstream commit c27045d302b022ed11d24a2653bceb6af56c6327 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 53 +++++++++++++-------------------------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index ef38f07d1224c..b59e02b4417c8 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -140,36 +140,6 @@ nlm_encode_oh(__be32 *p, struct xdr_netobj *oh)
 	return xdr_encode_netobj(p, oh);
 }
 
-static __be32 *
-nlm_decode_lock(__be32 *p, struct nlm_lock *lock)
-{
-	struct file_lock	*fl = &lock->fl;
-	s32			start, len, end;
-
-	if (!(p = xdr_decode_string_inplace(p, &lock->caller,
-					    &lock->len,
-					    NLM_MAXSTRLEN))
-	 || !(p = nlm_decode_fh(p, &lock->fh))
-	 || !(p = nlm_decode_oh(p, &lock->oh)))
-		return NULL;
-	lock->svid  = ntohl(*p++);
-
-	locks_init_lock(fl);
-	fl->fl_flags = FL_POSIX;
-	fl->fl_type  = F_RDLCK;		/* as good as anything else */
-	start = ntohl(*p++);
-	len = ntohl(*p++);
-	end = start + len - 1;
-
-	fl->fl_start = s32_to_loff_t(start);
-
-	if (len == 0 || end < 0)
-		fl->fl_end = OFFSET_MAX;
-	else
-		fl->fl_end = s32_to_loff_t(end);
-	return p;
-}
-
 static bool
 svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 {
@@ -315,25 +285,28 @@ nlmsvc_decode_cancargs(struct svc_rqst *rqstp, __be32 *p)
 }
 
 int
-nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
+nlmsvc_decode_unlockargs(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nlm_res *resp = rqstp->rq_resp;
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_args *argp = rqstp->rq_argp;
 
-	if (!(p = nlm_encode_testres(p, resp)))
+	if (!svcxdr_decode_cookie(xdr, &argp->cookie))
 		return 0;
-	return xdr_ressize_check(rqstp, p);
+	if (!svcxdr_decode_lock(xdr, &argp->lock))
+		return 0;
+	argp->lock.fl.fl_type = F_UNLCK;
+
+	return 1;
 }
 
 int
-nlmsvc_decode_unlockargs(struct svc_rqst *rqstp, __be32 *p)
+nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nlm_args *argp = rqstp->rq_argp;
+	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm_decode_cookie(p, &argp->cookie))
-	 || !(p = nlm_decode_lock(p, &argp->lock)))
+	if (!(p = nlm_encode_testres(p, resp)))
 		return 0;
-	argp->lock.fl.fl_type = F_UNLCK;
-	return xdr_argsize_check(rqstp, p);
+	return xdr_ressize_check(rqstp, p);
 }
 
 int
-- 
2.43.0



