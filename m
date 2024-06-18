Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5714D14F108;
	Tue, 18 Jun 2024 12:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715215; cv=none; b=ptV2tRdYnta2nWNmDiJu9EDGsLYppayo16f2VZbJLFSYhaBf9zHzuaqQlwFh2bPwler4DvgTQNKPvOKvFxKt/vZHsGFL9jbw7W/oiN0WxNuDXeqwgle2XCZBCRMIm0rnsEEaPHY7KCfjv7iAsfJR8dReBBXPbII01iRJYyfA9M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715215; c=relaxed/simple;
	bh=ZktXT0KL1hiCRgpEr3/sFsgWBP0J2Ap6zPNHoFKf5Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzQ3d3MktSznSVZtG79Uwl+xF6m1GUTxxBfX82E1SrjU0zl/8SSdTkNb2QrRuL5IGip9OMnoigYworMpaTuYOJ0VdSW2cHsIRWafb96mAHT7Y+kU47DuxrYAUSZwuDjIPRylWAzM402i6Cuceth+QHvNO4lQHwOVeyzjAJAOjl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/oVEXaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/oVEXaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF87AC3277B;
	Tue, 18 Jun 2024 12:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715215;
	bh=ZktXT0KL1hiCRgpEr3/sFsgWBP0J2Ap6zPNHoFKf5Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/oVEXaTR8SOCQyWE+7fFEaalvn1OZxLH01aW6MURNx2totDh/4kuEguq3jklfjf5
	 fmG0H2mfb8Ftx0vNihRqy6H7h7N39reMfvYmdFXHtEWpqJlPk7Qq2ggTkMqrpHS+MI
	 DtmE5VUFjDQWE/BepnFn7GNYELQXYm3wUzN8icKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/770] NFSD: Update the NFSv2 ACL ACCESS result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:26 +0200
Message-ID: <20240618123416.275242488@linuxfoundation.org>
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

[ Upstream commit 07f5c2963c04b11603e9667f89bb430c132e9cc1 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index c805ac8dd7e77..8703326fc1654 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -280,16 +280,21 @@ static int nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 /* ACCESS */
 static int nfsaclsvc_encode_accessres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_accessres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	if (resp->status != nfs_ok)
-		goto out;
+	if (!svcxdr_encode_stat(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
+			return 0;
+		if (xdr_stream_encode_u32(xdr, resp->access) < 0)
+			return 0;
+		break;
+	}
 
-	p = nfs2svc_encode_fattr(rqstp, p, &resp->fh, &resp->stat);
-	*p++ = htonl(resp->access);
-out:
-	return xdr_ressize_check(rqstp, p);
+	return 1;
 }
 
 /*
-- 
2.43.0



