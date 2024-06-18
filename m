Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09E615FA70;
	Tue, 18 Jun 2024 12:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715030; cv=none; b=fht5ON2Hi15JN40oKFImtyLT3glqwyAdXJNhPlTmyeXJ22OUWrXIByLFLbWRPWD1OnlzzZ5Bv62gKGjt8cASWvC7MHllxX4qS3CjW7R4AFO1NJ89vmyWDIo6MGr/qCCAYA7dSKy/1X6QFJPmHfDsqYzVzwVmiJpPIyw0tD//vo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715030; c=relaxed/simple;
	bh=9oCK5IAGNCmb0hjGUN7JpqOegJjBD0rMxIzK0lL7PHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6udpMgTw0EfV0FW/v5+l8giLCC57KEsNYGcdmTUZQc+pOUkVa5Z4CUd+6o4GrSfaa+7sDY5OqeHTIFoscDAZqChc7PUv1aphOvBZtShl6WaZz8PP8LyHhYPY5+/fWcmCOqWTlW1OY27ttNsZM4N6sxF8cr1WC2Jaq5O+oKM4Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKSg0Mzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKSg0Mzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC22C3277B;
	Tue, 18 Jun 2024 12:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715029;
	bh=9oCK5IAGNCmb0hjGUN7JpqOegJjBD0rMxIzK0lL7PHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKSg0Mzl356UZAfdA8GcZUOiCRIKhVaWbq1oK6dgy8lORhs+w2QqCvdp1G0NqYTej
	 MWXk5WJHbmWOkR3nMlKngxe4V0zfzhehwFCxcrM74hsTevr85BrtBiblGFjt9S2M/A
	 3+bVzrzWOZdOx7YQonv2+SCLQkpWkxPfx8qJlFPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/770] NFSD: Update the NFSv2 ACL GETATTR argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:22 +0200
Message-ID: <20240618123413.795168981@linuxfoundation.org>
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

[ Upstream commit 571d31f37a57729c9d3463b5a692a84e619b408a ]

Since the ACL GETATTR procedure is the same as the normal GETATTR
procedure, simply re-use nfssvc_decode_fhandleargs.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 123820ec79d37..0274348f6679e 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -220,16 +220,6 @@ static int nfsaclsvc_decode_setaclargs(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
-static int nfsaclsvc_decode_fhandleargs(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nfsd_fhandle *argp = rqstp->rq_argp;
-
-	p = nfs2svc_decode_fh(p, &argp->fh);
-	if (!p)
-		return 0;
-	return xdr_argsize_check(rqstp, p);
-}
-
 static int nfsaclsvc_decode_accessargs(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nfsd3_accessargs *argp = rqstp->rq_argp;
@@ -392,7 +382,7 @@ static const struct svc_procedure nfsd_acl_procedures2[5] = {
 	},
 	[ACLPROC2_GETATTR] = {
 		.pc_func = nfsacld_proc_getattr,
-		.pc_decode = nfsaclsvc_decode_fhandleargs,
+		.pc_decode = nfssvc_decode_fhandleargs,
 		.pc_encode = nfsaclsvc_encode_attrstatres,
 		.pc_release = nfsaclsvc_release_attrstat,
 		.pc_argsize = sizeof(struct nfsd_fhandle),
-- 
2.43.0



