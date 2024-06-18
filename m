Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0D014036D;
	Tue, 18 Jun 2024 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714841; cv=none; b=aMKNO0KOSJG6iDOLu4BroWidWn+rJRms9OqdSZnCf5m9uk/O9Xm4gMapkJQ4Y/N+e7ij2v34W0ORBEu40ShJYhmaQcl8pjFDhd1hjuSduLfMg4Uuz67kFa66gESSqzqUnag1RPSAEc47Ny7dCMSf4FBSboEEY1+jpQbZJfQxa8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714841; c=relaxed/simple;
	bh=n8uYZAfLJHaaxDUW85ESXg4GFlwqRcFRfQsUpytcgeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pc+BNyRn0BwDxOpTm7nlZVLkTF8s0E/FBkU+izMCIuxyIMpyE1VDFNSuY53FOvudc7+UEAX5a4Z/HNtAASiD+G1morx3IP7Z0RwLf5qq/tTbJHGtIeXx5Z5XBQi1NjDFQ2CrbnflkxtQEhYd/FMqIiXwbUisJ5v7ilcBcHo+vKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8ad10WE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8ad10WE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA5EC3277B;
	Tue, 18 Jun 2024 12:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714840;
	bh=n8uYZAfLJHaaxDUW85ESXg4GFlwqRcFRfQsUpytcgeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8ad10WERFZTlYCPfRaYAT0/+aS2/pTekZlf9bYdzsP49gIibnt8WCmi5NEgHsuUc
	 XfVESpFKsP4a1QnY9RpRigiUe78ON8qZ+fyIUSU6L37qHI6iVuPuHFjTV3YqZTkhVY
	 VHqKrs1Z02ntgRQZp3PKY2P8UhJ2lNheDllTaja0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/770] NFSD: Replace READ* macros in nfsd4_decode_layoutget()
Date: Tue, 18 Jun 2024 14:28:47 +0200
Message-ID: <20240618123410.140228056@linuxfoundation.org>
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

[ Upstream commit c8e88e3aa73889421461f878cd569ef84f231ceb ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9cd7270e67adc..837d2d8fb3ff8 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1844,24 +1844,27 @@ static __be32
 nfsd4_decode_layoutget(struct nfsd4_compoundargs *argp,
 		struct nfsd4_layoutget *lgp)
 {
-	DECODE_HEAD;
-
-	READ_BUF(36);
-	lgp->lg_signal = be32_to_cpup(p++);
-	lgp->lg_layout_type = be32_to_cpup(p++);
-	lgp->lg_seg.iomode = be32_to_cpup(p++);
-	p = xdr_decode_hyper(p, &lgp->lg_seg.offset);
-	p = xdr_decode_hyper(p, &lgp->lg_seg.length);
-	p = xdr_decode_hyper(p, &lgp->lg_minlength);
+	__be32 status;
 
-	status = nfsd4_decode_stateid(argp, &lgp->lg_sid);
+	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_signal) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_layout_type) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_seg.iomode) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &lgp->lg_seg.offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &lgp->lg_seg.length) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &lgp->lg_minlength) < 0)
+		return nfserr_bad_xdr;
+	status = nfsd4_decode_stateid4(argp, &lgp->lg_sid);
 	if (status)
 		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &lgp->lg_maxcount) < 0)
+		return nfserr_bad_xdr;
 
-	READ_BUF(4);
-	lgp->lg_maxcount = be32_to_cpup(p++);
-
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



