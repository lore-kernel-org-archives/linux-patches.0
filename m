Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3421315F3FE;
	Tue, 18 Jun 2024 12:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714994; cv=none; b=Se71Dv7Tc3iTRoJ2Zz1A8ZdVlyDNQSLTjy1LVPykeeexOitnNDr4mwWq+B2E4KGSqPGYW49KjTbJV9LL+Td4XFmExWlVC/S3kq31f3JwN3mF1s3CPaPTxYUiY93E7D+YvYQ5exMS9k74j86dSzt/K3m1ig3o4zHiKPA6sVVWiVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714994; c=relaxed/simple;
	bh=pAeuwA9b9d1IhcUJhvmLC7pbvAdWYfTd8vk54iSy6tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpuEJBAz6CEujwAQS1YoJMmFUao79YDOQNx88wOggONQbCB/eDNmc2ETnIsFASVc02EFAtLuiIrolpUNFPP6OUEdnlvomGdDigwpz15T/8AC45yiGkkZ4cSXnQEpSjd5EMTMNwSNyhe5G0yCUUrRFcwS1R8MDjUFiXh5wGwq50s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEnsd9WW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEnsd9WW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E11C3277B;
	Tue, 18 Jun 2024 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714994;
	bh=pAeuwA9b9d1IhcUJhvmLC7pbvAdWYfTd8vk54iSy6tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEnsd9WWzHvc9tPZBIOHiH9nYqQsov6jhNm0G6wVCwkA7JTfuS9J3fZIT+bFtxwSj
	 0incFOrYkOmNvzUjIWaOq6+apmSX8oNE/Y6cNwStlSajxHuqKkdMrv402ZmW5+U0Tn
	 gvz9Ld5HSmgvFqW26dAx2hKYBg8tNXbGrVR55Xi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/770] NFSD: Update the NFSv2 READDIR argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:11 +0200
Message-ID: <20240618123413.375466299@linuxfoundation.org>
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

[ Upstream commit 8688361ae2edb8f7e61d926dc5000c9a44f29370 ]

As an additional clean up, move code not related to XDR decoding
into readdir's .pc_func call out.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 3d72334e16733..7b33093f8d8b4 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -381,15 +381,17 @@ nfssvc_decode_symlinkargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_decode_readdirargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_readdirargs *args = rqstp->rq_argp;
 
-	p = decode_fh(p, &args->fh);
-	if (!p)
+	if (!svcxdr_decode_fhandle(xdr, &args->fh))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->cookie) < 0)
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &args->count) < 0)
 		return 0;
-	args->cookie = ntohl(*p++);
-	args->count  = ntohl(*p++);
 
-	return xdr_argsize_check(rqstp, p);
+	return 1;
 }
 
 /*
-- 
2.43.0



