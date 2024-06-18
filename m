Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF97315539D;
	Tue, 18 Jun 2024 12:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715491; cv=none; b=fx10fF4WzdjZew+NEguw/2PTPe+AM8RhKqWRg155c2SuComHMqq+yJnBsUEw0gVvEcY/FgvdZ5RUJEpB+ana2hpiLJw4wOSPxGo49VuyG8AO9Vx4ZAf9l2GFB10CDBGmFwQuy6YEPmW0k4UuQAbw/mXTksP3F2gOLChak2Oere8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715491; c=relaxed/simple;
	bh=DBAISPC70FxlnvZ5XUUC3DF8uolS9STTDCyLsfm+nRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXpr75iZOJHPkxgimqR5btIs9ITOrmno7d1CneKZ6J5mQsvcNy2ByLFZ88hAIfq6oor/XImRmXyfGerIkye8RJmhsU7hhP72Mj6EnmT573/Z7lR1cW5YU56hOa43TNG4tPWP0YinPVKSYrhczuuFsBMjczeTlCOACrAIIlwo++Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwS+tha6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwS+tha6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C00C3277B;
	Tue, 18 Jun 2024 12:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715490;
	bh=DBAISPC70FxlnvZ5XUUC3DF8uolS9STTDCyLsfm+nRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwS+tha6G31cqoNFp3YMMTG6Hjy1vxP6uPtvcjnL3ugXy4BUQ7XIPbK0yQxgf8ayK
	 wPapvs6mNgbyKOfwYzxpmEgPWcETdQJmYnZJkIp2UdjVt2aLc9+MSXFkcNdKVq/L+c
	 c5KIrrvHsnSu2nrJ0c1E5uVd6oIyuiGdBXaoJZaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/770] lockd: Update the NLMv4 SHARE results encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:33:00 +0200
Message-ID: <20240618123419.887750611@linuxfoundation.org>
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

[ Upstream commit 0ff5b50ab1f7f39862d0cdf6803978d31b27f25e ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index efdede71b9511..98e957e4566c2 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -40,15 +40,6 @@ loff_t_to_s64(loff_t offset)
 	return res;
 }
 
-static __be32 *
-nlm4_encode_cookie(__be32 *p, struct nlm_cookie *c)
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
@@ -356,11 +347,16 @@ nlm4svc_encode_res(struct svc_rqst *rqstp, __be32 *p)
 int
 nlm4svc_encode_shareres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm4_encode_cookie(p, &resp->cookie)))
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



