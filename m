Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CCA15D5A9;
	Tue, 18 Jun 2024 12:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714793; cv=none; b=Vx2VyVs6KJAIIuKx1pKk8JOTPh9d88lZhYyEMAcAC9nM3LlD0rgp4fcYhP3n846MiyzVjPpk9dZM5UxN061lplbk6tcjM0mF1QegUQW1WRVal7sS6egSxPpS96gZBYdxd0Jze6NWgk0ce3UALaHeM97npuMLLhwr9mmQqF8FjD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714793; c=relaxed/simple;
	bh=+2z0fOFMHWqIevcP5ubvKjBVHx9nH2tP5owpEFRpST4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icD4429A/EUjbidS0YmdoO5LZq8qcBsakowLv8cOs8uWUleryZzp/iSxTAUkUa3Y1ZgzTRb42KJo6tkhY0n0J7NP+AVaBXLonL8SScFfEbCiZw46S2A2HvJcO+UbaRACB8EbkhBa9AcNmZjeimnKTFq/8/tEAiz+huJayUdKAPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9le38IK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9le38IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DA7C3277B;
	Tue, 18 Jun 2024 12:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714793;
	bh=+2z0fOFMHWqIevcP5ubvKjBVHx9nH2tP5owpEFRpST4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9le38IK5RXybi2x+z41XhCWQDm8E6gxBfqCnUpC4Sntw29vZk6vibSLey+vChRYc
	 67aaxMVZgRh4Mroek1YWD2Hx5cnivNgfKfB9tQhY15QxCsNr/CpE6lLxoOjLhvWUsg
	 aMUPIktSgyhqsjPUcZF+ngvMAE9NfJxstSQB8VgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/770] NFSD: Replace READ* macros in nfsd4_decode_listxattrs()
Date: Tue, 18 Jun 2024 14:29:03 +0200
Message-ID: <20240618123410.748936793@linuxfoundation.org>
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

[ Upstream commit 2212036cadf4da3c4b0e4bd2a9a8c3d78617ab4f ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 38610764d7161..bf8eacab64952 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2223,11 +2223,10 @@ static __be32
 nfsd4_decode_listxattrs(struct nfsd4_compoundargs *argp,
 			struct nfsd4_listxattrs *listxattrs)
 {
-	DECODE_HEAD;
 	u32 maxcount;
 
-	READ_BUF(12);
-	p = xdr_decode_hyper(p, &listxattrs->lsxa_cookie);
+	if (xdr_stream_decode_u64(argp->xdr, &listxattrs->lsxa_cookie) < 0)
+		return nfserr_bad_xdr;
 
 	/*
 	 * If the cookie  is too large to have even one user.x attribute
@@ -2237,7 +2236,8 @@ nfsd4_decode_listxattrs(struct nfsd4_compoundargs *argp,
 	    (XATTR_LIST_MAX / (XATTR_USER_PREFIX_LEN + 2)))
 		return nfserr_badcookie;
 
-	maxcount = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &maxcount) < 0)
+		return nfserr_bad_xdr;
 	if (maxcount < 8)
 		/* Always need at least 2 words (length and one character) */
 		return nfserr_inval;
@@ -2245,7 +2245,7 @@ nfsd4_decode_listxattrs(struct nfsd4_compoundargs *argp,
 	maxcount = min(maxcount, svc_max_payload(argp->rqstp));
 	listxattrs->lsxa_maxcount = maxcount;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



