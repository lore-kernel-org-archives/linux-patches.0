Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6538D73461;
	Tue, 18 Jun 2024 12:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715212; cv=none; b=r5OokOAeoZ/DZiySmxd6oKL1uPxUu6gw9oT5GLhAF+C7BQfO9Z1CLoLGz3T1Sfbn2XKoWrVPc+vAKbau9VEjrfypS8mwZ8CzC5YayOtK6wao2UYfv4ZiliCTHgdv2MnzNOEIYW1tOnbKBa++Xx4YP2D2Zcjz5LEz1HzhNa5rDgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715212; c=relaxed/simple;
	bh=d71R2Ix8RMGhvAfeV9L8eWDikf9lSViBB29OVD6sgws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXFdx2K0+x0wMD2iLd1YBHLi5rPWhLapctYfR4bokdXOJEWOEkQtBd0A3wYn05R3cZE7Ht2plTe4G2P3soo6feGO5uC3EcCKPZ8wP5NNcVFBwUkI691Uv3jr+YCkHGGhtByT4skFofK2Myo244oyMuUVi8Epf9lBXKfrlve6O98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXgFFxQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXgFFxQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB12C3277B;
	Tue, 18 Jun 2024 12:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715212;
	bh=d71R2Ix8RMGhvAfeV9L8eWDikf9lSViBB29OVD6sgws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXgFFxQbYt3OeUmn6P7OYLJDjtF0CFTRrkVd5DDBx7X8JI8TmY1AP9CpcSh2c3gUA
	 Luha26E9ltOeollS/tqbsaElu6ofiGWpj0MyRXHZAKfbX4AQTMaoscWC/oaWV5q8dN
	 Fk+iJc/sSuMd1vG/Hr/xXvRwyR2K3pIhcL/tsoUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/770] NFSD: Update the NFSv2 ACL GETATTR result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:25 +0200
Message-ID: <20240618123416.237295142@linuxfoundation.org>
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

[ Upstream commit 8d2009a10b3abaa12a39deb4876b215714993fe8 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index ef06a2a384bea..c805ac8dd7e77 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -277,19 +277,6 @@ static int nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
-static int nfsaclsvc_encode_attrstatres(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nfsd_attrstat *resp = rqstp->rq_resp;
-
-	*p++ = resp->status;
-	if (resp->status != nfs_ok)
-		goto out;
-
-	p = nfs2svc_encode_fattr(rqstp, p, &resp->fh, &resp->stat);
-out:
-	return xdr_ressize_check(rqstp, p);
-}
-
 /* ACCESS */
 static int nfsaclsvc_encode_accessres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -317,13 +304,6 @@ static void nfsaclsvc_release_getacl(struct svc_rqst *rqstp)
 	posix_acl_release(resp->acl_default);
 }
 
-static void nfsaclsvc_release_attrstat(struct svc_rqst *rqstp)
-{
-	struct nfsd_attrstat *resp = rqstp->rq_resp;
-
-	fh_put(&resp->fh);
-}
-
 static void nfsaclsvc_release_access(struct svc_rqst *rqstp)
 {
 	struct nfsd3_accessres *resp = rqstp->rq_resp;
@@ -374,8 +354,8 @@ static const struct svc_procedure nfsd_acl_procedures2[5] = {
 	[ACLPROC2_GETATTR] = {
 		.pc_func = nfsacld_proc_getattr,
 		.pc_decode = nfssvc_decode_fhandleargs,
-		.pc_encode = nfsaclsvc_encode_attrstatres,
-		.pc_release = nfsaclsvc_release_attrstat,
+		.pc_encode = nfssvc_encode_attrstatres,
+		.pc_release = nfssvc_release_attrstat,
 		.pc_argsize = sizeof(struct nfsd_fhandle),
 		.pc_ressize = sizeof(struct nfsd_attrstat),
 		.pc_cachetype = RC_NOCACHE,
-- 
2.43.0



