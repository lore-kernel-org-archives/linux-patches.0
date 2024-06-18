Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862B14F130;
	Tue, 18 Jun 2024 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715227; cv=none; b=V/LcaoDaKnYIAGhFVq/Y/nLLlYHsJ9s2jx8+2/MEPyYPyCFbuzZ5xjsmwoAMrOxN3Symf9PRVkpAXT8mvapmHQ0YYFYtM4B35rgIsINLOyXfxhVPj4fOcxLbhs4yV8vzUG9xVMq2HL4NtjZzhh+3AED98epItgAPR39ZMGRd0hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715227; c=relaxed/simple;
	bh=CmB2o3NeklHr+RDWbIkOt+1Ry21g2r0UMuqWm5Gg9Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=df3LCmdwd6RZXr8jM0efBpPEIbUONYIgQGXI5WwDX3nuTsd/+K23q/FepU0tZwRazw2usAk0pnxo/nmoUVwqHMgocsK5IgvOicMrURkKuY57xpWzolD0DwHrI1hGu7mG4fVuPlbrc0Tcj7gL+tfvdOIZHGJsrYsJXdxcstYD8nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmKOQrBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmKOQrBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64FFC3277B;
	Tue, 18 Jun 2024 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715227;
	bh=CmB2o3NeklHr+RDWbIkOt+1Ry21g2r0UMuqWm5Gg9Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmKOQrBl9rbyh9jTNRDGzTt6hAwcztZYTjRLiDdFWXis7iWiAPupPjZ/J/N3E+UIt
	 7TbfnWNE4p5G1nO5Cqx/J3kT7gcjbowrfKMQBYmln/urR902Nd+DJiuphakY1FSi/c
	 PScm8hk/QbIitBKkcY8zRDizGP42yCWDbBwj6c7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/770] NFSD: Update the NFSv3 SETACL result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:29 +0200
Message-ID: <20240618123416.388194302@linuxfoundation.org>
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

[ Upstream commit 15e432bf0cfd1e6aebfa9ffd4e0cc2ff4f3ae2db ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index 04e157b0b201a..cfb686f23e571 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -217,11 +217,11 @@ static int nfs3svc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 /* SETACL */
 static int nfs3svc_encode_setaclres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_attrstat *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	p = nfs3svc_encode_post_op_attr(rqstp, p, &resp->fh);
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_nfsstat3(xdr, resp->status) &&
+		svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh);
 }
 
 /*
-- 
2.43.0



