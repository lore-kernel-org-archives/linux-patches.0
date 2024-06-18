Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955CE15DBC6;
	Tue, 18 Jun 2024 12:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714843; cv=none; b=vFBK0PO/8+UJEBVbhEe/bBGArwu1a6k7zj8PSRy2PSqrEAnkdeWl9eeMb1qvpK60G4LptKdeEALr8QnIuSr6hm2qYYFm2LLIzWFHmItMsVlfxYfFekaCoK3zvxHjEXW8Xm8/UsgeaZwUNxFLgRPiChaTWDoZkXqaDqbd1WA/Td8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714843; c=relaxed/simple;
	bh=5nGVD01Eig3U2Fy3gBGTd0ZSdQx7GZvGeRjdha9BepQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX2rRPIjfgz47IJDiTxhCJvKYVcvW5iHTP6ib4vupozIFXK1RHMiahNtDGsjwf0kRWMktAqRxHG36sVzDrYa/k+acYVXeNeKMyxSIrS9Ln4QGiziBIxAXlVTCDp2SRqpPmHmHz9e443x6lRusBO3SZ1uovzWTlRfsjHs3P0YToY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsQ5FrKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsQ5FrKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEE6C3277B;
	Tue, 18 Jun 2024 12:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714843;
	bh=5nGVD01Eig3U2Fy3gBGTd0ZSdQx7GZvGeRjdha9BepQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsQ5FrKhNjNEPv+ZkPt8Oc6LIVBf/g67k4CYmwhyt+2GG7M8DQhj5omuM0LmOTme8
	 SKJFiJhiDx3vzFgGzHdD6ppPylf2ZhQcLVozS3D/QA1o5ErsYZVbUFa3qIHzVvFNVK
	 GdwSgIa9HxFFXoJnuB/3yxw1/3074dAn+h4cGNPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/770] NFSD: Replace READ* macros in nfsd4_decode_layoutreturn()
Date: Tue, 18 Jun 2024 14:28:48 +0200
Message-ID: <20240618123410.178859888@linuxfoundation.org>
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

[ Upstream commit 645fcad371420913c30e9aca80fc0a38f3acf432 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 72 +++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 837d2d8fb3ff8..ae70070a58213 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -660,6 +660,43 @@ nfsd4_decode_layoutupdate4(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_layoutreturn4(struct nfsd4_compoundargs *argp,
+			   struct nfsd4_layoutreturn *lrp)
+{
+	__be32 status;
+
+	if (xdr_stream_decode_u32(argp->xdr, &lrp->lr_return_type) < 0)
+		return nfserr_bad_xdr;
+	switch (lrp->lr_return_type) {
+	case RETURN_FILE:
+		if (xdr_stream_decode_u64(argp->xdr, &lrp->lr_seg.offset) < 0)
+			return nfserr_bad_xdr;
+		if (xdr_stream_decode_u64(argp->xdr, &lrp->lr_seg.length) < 0)
+			return nfserr_bad_xdr;
+		status = nfsd4_decode_stateid4(argp, &lrp->lr_sid);
+		if (status)
+			return status;
+		if (xdr_stream_decode_u32(argp->xdr, &lrp->lrf_body_len) < 0)
+			return nfserr_bad_xdr;
+		if (lrp->lrf_body_len > 0) {
+			lrp->lrf_body = xdr_inline_decode(argp->xdr, lrp->lrf_body_len);
+			if (!lrp->lrf_body)
+				return nfserr_bad_xdr;
+		}
+		break;
+	case RETURN_FSID:
+	case RETURN_ALL:
+		lrp->lr_seg.offset = 0;
+		lrp->lr_seg.length = NFS4_MAX_UINT64;
+		break;
+	default:
+		return nfserr_bad_xdr;
+	}
+
+	return nfs_ok;
+}
+
 #endif /* CONFIG_NFSD_PNFS */
 
 static __be32
@@ -1871,34 +1908,13 @@ static __be32
 nfsd4_decode_layoutreturn(struct nfsd4_compoundargs *argp,
 		struct nfsd4_layoutreturn *lrp)
 {
-	DECODE_HEAD;
-
-	READ_BUF(16);
-	lrp->lr_reclaim = be32_to_cpup(p++);
-	lrp->lr_layout_type = be32_to_cpup(p++);
-	lrp->lr_seg.iomode = be32_to_cpup(p++);
-	lrp->lr_return_type = be32_to_cpup(p++);
-	if (lrp->lr_return_type == RETURN_FILE) {
-		READ_BUF(16);
-		p = xdr_decode_hyper(p, &lrp->lr_seg.offset);
-		p = xdr_decode_hyper(p, &lrp->lr_seg.length);
-
-		status = nfsd4_decode_stateid(argp, &lrp->lr_sid);
-		if (status)
-			return status;
-
-		READ_BUF(4);
-		lrp->lrf_body_len = be32_to_cpup(p++);
-		if (lrp->lrf_body_len > 0) {
-			READ_BUF(lrp->lrf_body_len);
-			READMEM(lrp->lrf_body, lrp->lrf_body_len);
-		}
-	} else {
-		lrp->lr_seg.offset = 0;
-		lrp->lr_seg.length = NFS4_MAX_UINT64;
-	}
-
-	DECODE_TAIL;
+	if (xdr_stream_decode_bool(argp->xdr, &lrp->lr_reclaim) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &lrp->lr_layout_type) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &lrp->lr_seg.iomode) < 0)
+		return nfserr_bad_xdr;
+	return nfsd4_decode_layoutreturn4(argp, lrp);
 }
 #endif /* CONFIG_NFSD_PNFS */
 
-- 
2.43.0



