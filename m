Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18B114F13E;
	Tue, 18 Jun 2024 12:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715033; cv=none; b=HSucl0tvo/Cel/iBhZbjZVbT3jM2moVSLCyg33uQAQJGLYkl8PPowP1gAoLXVvAeAMjTdCep+Go7hGl5ieN7N/fYr3kO7CVIJAvAWynJ9OfGoRWkfeA1es87ix8Nc1Exo4IZv6H1+wBQGn9neYVNAb8kvrbDPU/w3GdRUZY/p6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715033; c=relaxed/simple;
	bh=1cA1ntzi8t+PcBgiu28VHoizSDBVJlAiG+yvIUNcacM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBMgj1p8yKq0G13gCN9vmCxeTQhbCLlebPaNileKZXs/hdgdezOwTOwDWmn62RVlgFAUIlxqiOQjzsSleTRpD9Fw6LAJtEQ/qdey4abY35pCetgRpQ3yxHyEYbLDJDNjrWKkUg4XO28G2NCY55EVtNRNu6OG2jZNAptC/MrVwI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRACbCII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRACbCII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D675C3277B;
	Tue, 18 Jun 2024 12:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715032;
	bh=1cA1ntzi8t+PcBgiu28VHoizSDBVJlAiG+yvIUNcacM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRACbCIIUoesNPz3KbaCpzgBzvkSfdhfe31zjyBl5YDbMxj+cgdmbTSH05B/g6BAa
	 CSlZm+xMWJdJTu7wt+v94J/fkKBzu9JacY7AnXFm+pkPs8Bud2CHs2crWUo0Pg+RfU
	 tIZnTKxpd2k7MehPn+0zrHF6zcwmrYIWM4m16Zr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/770] NFSD: Update the NFSv2 ACL ACCESS argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:23 +0200
Message-ID: <20240618123413.833228826@linuxfoundation.org>
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

[ Upstream commit 64063892efc1daa3a48882673811ff327ba75ed5 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 0274348f6679e..7eeac5b81c200 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -222,14 +222,15 @@ static int nfsaclsvc_decode_setaclargs(struct svc_rqst *rqstp, __be32 *p)
 
 static int nfsaclsvc_decode_accessargs(struct svc_rqst *rqstp, __be32 *p)
 {
-	struct nfsd3_accessargs *argp = rqstp->rq_argp;
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nfsd3_accessargs *args = rqstp->rq_argp;
 
-	p = nfs2svc_decode_fh(p, &argp->fh);
-	if (!p)
+	if (!svcxdr_decode_fhandle(xdr, &args->fh))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->access) < 0)
 		return 0;
-	argp->access = ntohl(*p++);
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 /*
-- 
2.43.0



