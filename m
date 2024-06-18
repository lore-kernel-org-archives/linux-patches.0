Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FB617CA1D;
	Tue, 18 Jun 2024 12:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715547; cv=none; b=DU+pXA3zrNNm9N1QN6K95Ql2dOIB5DtN4g+pRSlR3PG5p/axJuvUBA9gpwGK2pN9R3/kBO+Kw+14xXsexYswXW2rA9BXBenpJQM59AzvgzzDo3dSKAo/PjhHR8GmXY1BjnMNVpOgo8AoK6lxiuS44irtSsIy3lxAUBgMrlFwbN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715547; c=relaxed/simple;
	bh=jKreDOpmOMLQus8+O3KzAlfwoPf7eEqbr/s5QHKYdEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEJTM6JzindZHsisJ/lBk7cp8DLzpfZdUhYdUoUHnmU0I6vRSyeCMK60zdYU35bqpownObq4Y2NOqxyCbo2U1MeyCVTRhAbccuxS7erDauMeAkwSbD0q5c6eVpoxGQLMpWmCcFIyi/pyoKyeKkviPpy3vKCUeA/v7ofV1vcSJAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGX/M8Q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGX/M8Q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F895C32786;
	Tue, 18 Jun 2024 12:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715547;
	bh=jKreDOpmOMLQus8+O3KzAlfwoPf7eEqbr/s5QHKYdEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGX/M8Q34M5L38AvrOkO6P4s8pTDUEqozpqeXdfO4nGUeokVceqxN/x2I//ynb3Wb
	 d0hgrPOC27Z+t//axV28BJ/QgcGNVteTb3EyVXG5oZX619LY6t5VCALqKdJMTfjXPh
	 W1U5HcgEOxROl75bEFRMPKv9ee7Wra5D/sRlaiLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/770] lockd: Update the NLMv1 SHARE results encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:47 +0200
Message-ID: <20240618123419.377673114@linuxfoundation.org>
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

[ Upstream commit 529ca3a116e8978575fec061a71fa6865a344891 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 4fb6090bc9158..9235e60b17694 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -41,18 +41,6 @@ loff_t_to_s32(loff_t offset)
 	return res;
 }
 
-/*
- * XDR functions for basic NLM types
- */
-static inline __be32 *
-nlm_encode_cookie(__be32 *p, struct nlm_cookie *c)
-{
-	*p++ = htonl(c->len);
-	memcpy(p, c->data, c->len);
-	p+=XDR_QUADLEN(c->len);
-	return p;
-}
-
 /*
  * NLM file handles are defined by specification to be a variable-length
  * XDR opaque no longer than 1024 bytes. However, this implementation
@@ -361,11 +349,16 @@ nlmsvc_encode_res(struct svc_rqst *rqstp, __be32 *p)
 int
 nlmsvc_encode_shareres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm_encode_cookie(p, &resp->cookie)))
+	if (!svcxdr_encode_cookie(xdr, &resp->cookie))
 		return 0;
-	*p++ = resp->status;
-	*p++ = xdr_zero;		/* sequence argument */
-	return xdr_ressize_check(rqstp, p);
+	if (!svcxdr_encode_stats(xdr, resp->status))
+		return 0;
+	/* sequence */
+	if (xdr_stream_encode_u32(xdr, 0) < 0)
+		return 0;
+
+	return 1;
 }
-- 
2.43.0



