Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB489217722;
	Fri, 17 Oct 2025 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714816; cv=none; b=fe/lnty8FAu3nnqbBmqpslcV0uK38XYhmVKCstFPFlQ669gGRO+0L1FL1l8ok97BZoa3GMpMF03bWSOIKGElzVjxPh1Yy9YVILGPR+qlBKGuu9Qk7OlpWS8vuuppnqF7VeLI0IY/1bMCAKR4g33k6dGg+YgP5Tmm0QCh8T9DGuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714816; c=relaxed/simple;
	bh=34SkSD3RwEbwuXn5w3+ZD16CpiUHmNX4tH7K+T6wMlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkVheVgioQifutLjGGMU1Ot9k968z9FSqpMT1DNVdKJssE582VNknaMIfqb/8T/0iSe4F8peKMTehDrDGJwcdWuBRJLV36nJFnGFzGnN3uRRFc8IVvs1+6GmWDsYDwbf+HRmrvoVqyAu61Rw0pP18+wfJ62KT7rRB+oLj9i9ERU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XahleXZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XahleXZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9EEC4CEE7;
	Fri, 17 Oct 2025 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714816;
	bh=34SkSD3RwEbwuXn5w3+ZD16CpiUHmNX4tH7K+T6wMlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XahleXZ0vOW3WSh6HK/27/bGcy3e+zcVL994hyT6q1Uyqus2tDuIlhVKIIQPBeoRd
	 1BpiaDG6oEeTxGeKrRg0ogcoe6O12pVo7jlaJ9nnExm/UucU3sAxAbKJ5GgvW7qNoq
	 cxv0crjSDsBv3m+HVkog/DzyFJmfngJrCdVmX9xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 275/277] nfsd: fix __fh_verify for localio
Date: Fri, 17 Oct 2025 16:54:42 +0200
Message-ID: <20251017145157.200933922@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit d9d6b74e4be989f919498798fa40df37a74b5bb0 upstream.

__fh_verify() added a call to svc_xprt_set_valid() to help do connection
management but during LOCALIO path rqstp argument is NULL, leading to
NULL pointer dereferencing and a crash.

Fixes: eccbbc7c00a5 ("nfsd: don't use sv_nrthreads in connection limiting calculations.")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -381,8 +381,9 @@ __fh_verify(struct svc_rqst *rqstp,
 	error = check_nfsd_access(exp, rqstp, may_bypass_gss);
 	if (error)
 		goto out;
-
-	svc_xprt_set_valid(rqstp->rq_xprt);
+	/* During LOCALIO call to fh_verify will be called with a NULL rqstp */
+	if (rqstp)
+		svc_xprt_set_valid(rqstp->rq_xprt);
 
 	/* Finally, check access permissions. */
 	error = nfsd_permission(cred, exp, dentry, access);


