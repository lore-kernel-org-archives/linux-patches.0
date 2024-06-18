Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45129155737;
	Tue, 18 Jun 2024 12:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715488; cv=none; b=nOeW6acwQ699GkOuu5IhFcQLkKUDzG7x4reCtVFVa+ovYyDLa32ePQVPeVeyEGAcJdS4DmYB8VySqdWHrpQGg4inxgjerifOdOi4agfR57UIGI6Lmr5AYurbvEJ89XyRBstK8QO4uyeEwewrCXtaBsDvrE+/gqPFsWW5Dyemplg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715488; c=relaxed/simple;
	bh=LTq/IMFE0fcoWf8M4G2XyPsa6L4P3CThEbNIuxmm9i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVeNdQACW9dYVPom/quMRJsUoFY7MxBAAeJw/bxPAWIJSwaq+fKXbE/j6tz00URM7tsL6LXdKIkwPL5HGvSZTyBlkL0MAbRTnKCHUO7zbTSzZXrhOFnjC1VQlT5Oa7rVJT0RfCETcxrtbmsz6ppjr2PYGMy4he+FlYYedGnBFNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOVKhS/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOVKhS/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79404C3277B;
	Tue, 18 Jun 2024 12:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715487;
	bh=LTq/IMFE0fcoWf8M4G2XyPsa6L4P3CThEbNIuxmm9i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOVKhS/Mkl8Wt5QJze3Xbnw3z3GZbyJjPosJcnAU/wumpCW52CGvvrYgzkvMOfnh+
	 8GPFdiBWsZ7TjA8s8nOd4N3tWqDWxU+l/o/ZcbfjXHUV7IAr0g2+4u20x/qNlHQBtk
	 qroe/2+FdnwcnonnWPy5slatn/cItiZvpW1Jodh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/770] lockd: Update the NLMv4 nlm_res results encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:59 +0200
Message-ID: <20240618123419.843207830@linuxfoundation.org>
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

[ Upstream commit 447c14d48968d0d4c2733c3f8052cb63aa1deb38 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 9b8a7afb935ca..efdede71b9511 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -344,24 +344,23 @@ nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 }
 
 int
-nlm4svc_encode_shareres(struct svc_rqst *rqstp, __be32 *p)
+nlm4svc_encode_res(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm4_encode_cookie(p, &resp->cookie)))
-		return 0;
-	*p++ = resp->status;
-	*p++ = xdr_zero;		/* sequence argument */
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_cookie(xdr, &resp->cookie) &&
+		svcxdr_encode_stats(xdr, resp->status);
 }
 
 int
-nlm4svc_encode_res(struct svc_rqst *rqstp, __be32 *p)
+nlm4svc_encode_shareres(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nlm_res *resp = rqstp->rq_resp;
 
 	if (!(p = nlm4_encode_cookie(p, &resp->cookie)))
 		return 0;
 	*p++ = resp->status;
+	*p++ = xdr_zero;		/* sequence argument */
 	return xdr_ressize_check(rqstp, p);
 }
-- 
2.43.0



