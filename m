Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885171DA24;
	Tue, 18 Jun 2024 12:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714743; cv=none; b=b+/BfdBlIcJ4aWm4IYtGtwyb9C1lfvVXqrKzDgtWcx2azeo/PPGtSMGJ8oaXYD4lakJSOS+/zG4YM3uJPe0Ss/PtXQSymPCR2feWrmHjfbaJdxigFQwFEmaxQ90hMFxGARoovyha8I6tXU7hTgPRLl5+OZ3Rt74YgvZs8SsnprY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714743; c=relaxed/simple;
	bh=9f8WlK25TAxdYK5tQUgjbMZOFoCuv/dJ00Fzqipb/w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkE5Q2LLneV7HK9HQMDt6eTHQ1Rp1Ss8yLxazfdDKS/rUX6Rkf9pOVlD/iShHCeqgjuB4pw4kYXzq0BxvsXvUNAsJMFhs0J2EdkHMteuBbIDHN9WqyWoV8cXQ+Y1OOVFEkFYJAuTL4xUK4v9bYalhLLZAO2FNpdXtQw44pro3bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj9xBZ4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj9xBZ4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF40C3277B;
	Tue, 18 Jun 2024 12:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714743;
	bh=9f8WlK25TAxdYK5tQUgjbMZOFoCuv/dJ00Fzqipb/w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj9xBZ4wFtTgic8FwrIWfjs0KFNUJoe4HBRLDVeESO6DmjJ3uXVASRVqUdKT48Pmy
	 mdW7P+wQqjm2vWYfbYPiWcUY8SZrv06qx2b+Lr/4+BdmI/xlwXY5YjOk/4mMxhtq/x
	 l5xeEsGxD/gpO+lvHOuFMMhdtr66DVJ1fxWyrhwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/770] NFSD: Replace READ* macros in nfsd4_decode_share_access()
Date: Tue, 18 Jun 2024 14:28:15 +0200
Message-ID: <20240618123408.918295103@linuxfoundation.org>
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

[ Upstream commit 9aa62f5199749b274454b6d7d914c9b2a5e77031 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 76715d1935ade..a43b39940ab25 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1012,11 +1012,10 @@ nfsd4_decode_openflag4(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 
 static __be32 nfsd4_decode_share_access(struct nfsd4_compoundargs *argp, u32 *share_access, u32 *deleg_want, u32 *deleg_when)
 {
-	__be32 *p;
 	u32 w;
 
-	READ_BUF(4);
-	w = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &w) < 0)
+		return nfserr_bad_xdr;
 	*share_access = w & NFS4_SHARE_ACCESS_MASK;
 	*deleg_want = w & NFS4_SHARE_WANT_MASK;
 	if (deleg_when)
@@ -1059,7 +1058,6 @@ static __be32 nfsd4_decode_share_access(struct nfsd4_compoundargs *argp, u32 *sh
 	      NFS4_SHARE_PUSH_DELEG_WHEN_UNCONTENDED):
 		return nfs_ok;
 	}
-xdr_error:
 	return nfserr_bad_xdr;
 }
 
-- 
2.43.0



