Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3714A14F9E2;
	Tue, 18 Jun 2024 12:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715159; cv=none; b=IfwDWZRbIHTKXCR2ZrId7iqWpN2CcO7+zGWpzUFQHgzN3+9W4ChJ98LKnAuowJhpzbZpSVXzdXCnIdCy4fcplFbNwJL3CFEi1Tfc8ir7oHKqWPBzLQ78PO+81um5p7n0AOi/EyI6DcFfogV9EY3plosrj7fpMtQsRyEXH+zZOGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715159; c=relaxed/simple;
	bh=atJD2C7hlwVIiJSs2U8gZU/h+c0rLfU/jaKFH38sNf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6RRXEZ9Q/UZxs9VC3k9/2EAO2y4K5YtjKk6KpzwnhpxOWx1YZd3SdKg89jFIvoJtYcqlw3KsPjcCzUBBR7JeTC4IrX2Pxuhe4IRJBn/CQPyJ+bcYRWMTWQOX5ReOsRQzGRcQKX/WrP9Sfa0e3vVzTI5CP0PrKZs2U1MDWjkc84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciQIuNo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciQIuNo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0FDC3277B;
	Tue, 18 Jun 2024 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715159;
	bh=atJD2C7hlwVIiJSs2U8gZU/h+c0rLfU/jaKFH38sNf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciQIuNo025uiDE4V+aD7uFsk6jX6cXj/2d4LyIYewLi2n+yyjsZVx1kdwiOzjyU7c
	 0ZUh7jNdGrNZLC/UY/8EJiyQd9nIIAZaC95uUf1UmRnGmq5Cdz+/NJxdDLWvE8VgfJ
	 h7cIfz2flWX5XUV8C7nCqPP5ZWpsx7/rnSLZfpoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/770] NFSD: Update the NFSv3 LINK3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:00 +0200
Message-ID: <20240618123415.267107902@linuxfoundation.org>
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

[ Upstream commit 4d74380a446f75eebb2171687d9b8baf0025bdf1 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 1d52a69562b82..e159e45574288 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -1128,12 +1128,12 @@ nfs3svc_encode_renameres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_linkres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_linkres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	p = encode_post_op_attr(rqstp, p, &resp->fh);
-	p = encode_wcc_data(rqstp, p, &resp->tfh);
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_nfsstat3(xdr, resp->status) &&
+		svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh) &&
+		svcxdr_encode_wcc_data(rqstp, xdr, &resp->tfh);
 }
 
 /* READDIR */
-- 
2.43.0



