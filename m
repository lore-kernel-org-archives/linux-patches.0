Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386EE15539D;
	Tue, 18 Jun 2024 12:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715467; cv=none; b=E63nw8gFwtHfnW0WQQzybn66TLiV+PYW0ZFLmecnn1O+nQUd2N9zgDZx9cyRVrW/ILXv3DHv0q2sIbYiZUi/kGJNm8qHsuhDYuTmCOrPxiXy5KOXQFwP8VlZAYMZVkUbf11KMGMeTantiZUibqiyabMbuXQoCPOaVsPHcq+BTkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715467; c=relaxed/simple;
	bh=Hr2iZTfLFCebgXQZqwqG9g2xHN2fD2Qq74hFsW0Mul8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS5VKd4sAIVloHZfJhYHaFxtysPe4DUrr6iP2JDmC3eVx/HR6akX3Va1A7JZMx1NSTdsnrUKa6Itig5j/JXaAWyqwIsM8bdEAz8wkQ+2O5j1AaKGH9OblSt9IlQKQDAkbYbjGnTzYDxYls7s/Al4D8rX9tDizdZvB+TRogOIlXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ued7rJLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ued7rJLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64E9C3277B;
	Tue, 18 Jun 2024 12:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715467;
	bh=Hr2iZTfLFCebgXQZqwqG9g2xHN2fD2Qq74hFsW0Mul8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ued7rJLDFEOabN5kCplRbRuFsDdu264JCdi2jHFjq8XdHaeghyeDw5ZfrjsyLIUuL
	 j6Xtv8YG8P5+IGmMdWxljeK6NqYHwUdQoblw8eATeV6qbqs4u7J9BDBj8y1MmMVR68
	 m9DKJwlYjv4JSj7U4bH7/HWmAkIJY8gWjsX5pf8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/770] lockd: Update the NLMv4 UNLOCK arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:52 +0200
Message-ID: <20240618123419.570104207@linuxfoundation.org>
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

[ Upstream commit d76d8c25cea794f65615f3a2324052afa4b5f900 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 53 ++++++++++++-------------------------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 37d45f1d71999..47a87ea4a99b1 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -131,36 +131,6 @@ nlm4_decode_oh(__be32 *p, struct xdr_netobj *oh)
 	return xdr_decode_netobj(p, oh);
 }
 
-static __be32 *
-nlm4_decode_lock(__be32 *p, struct nlm_lock *lock)
-{
-	struct file_lock	*fl = &lock->fl;
-	__u64			len, start;
-	__s64			end;
-
-	if (!(p = xdr_decode_string_inplace(p, &lock->caller,
-					    &lock->len, NLM_MAXSTRLEN))
-	 || !(p = nlm4_decode_fh(p, &lock->fh))
-	 || !(p = nlm4_decode_oh(p, &lock->oh)))
-		return NULL;
-	lock->svid  = ntohl(*p++);
-
-	locks_init_lock(fl);
-	fl->fl_flags = FL_POSIX;
-	fl->fl_type  = F_RDLCK;		/* as good as anything else */
-	p = xdr_decode_hyper(p, &start);
-	p = xdr_decode_hyper(p, &len);
-	end = start + len - 1;
-
-	fl->fl_start = s64_to_loff_t(start);
-
-	if (len == 0 || end < 0)
-		fl->fl_end = OFFSET_MAX;
-	else
-		fl->fl_end = s64_to_loff_t(end);
-	return p;
-}
-
 static bool
 svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 {
@@ -311,25 +281,28 @@ nlm4svc_decode_cancargs(struct svc_rqst *rqstp, __be32 *p)
 }
 
 int
-nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
+nlm4svc_decode_unlockargs(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nlm_res *resp = rqstp->rq_resp;
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_args *argp = rqstp->rq_argp;
 
-	if (!(p = nlm4_encode_testres(p, resp)))
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
-nlm4svc_decode_unlockargs(struct svc_rqst *rqstp, __be32 *p)
+nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nlm_args *argp = rqstp->rq_argp;
+	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm4_decode_cookie(p, &argp->cookie))
-	 || !(p = nlm4_decode_lock(p, &argp->lock)))
+	if (!(p = nlm4_encode_testres(p, resp)))
 		return 0;
-	argp->lock.fl.fl_type = F_UNLCK;
-	return xdr_argsize_check(rqstp, p);
+	return xdr_ressize_check(rqstp, p);
 }
 
 int
-- 
2.43.0



