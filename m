Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ACC139CFE;
	Tue, 18 Jun 2024 12:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714767; cv=none; b=qrGelkvwxIoobZX/10ryuhCOzTJrCGWU6hmJuZOup4bmBBvewmfbVP+AtzEMtZZyaD1LkGBpbQ/PbwOF/UGSLFaFjKxQ67XBXMqPPbp+ZeI2tlM4JKXw8XGvcZBSXJI0Hi+dvbtNWEsB5m5YTkAfLj7lbjj4v1JdqPlLR3BdfgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714767; c=relaxed/simple;
	bh=0wZzRAEDUwP4oSqc83neebiqisJA9ug7hkFqtWUmo8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbSk5sQS6KTSZvoeFMn+a408pI9oRAx346291JQ0N/8Rcmv9OtrCSZr0ZIvAFB8s3SVFcFM/8fDDIwzkcnLQC3dZPKwefFY7cScNokudOmkuDAVgFjosti30kZgYGujue0GnKpn9DfyMt3uj0Y+RZlPbO64sIZ3xqqFmYsoxJ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzm6Ly2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzm6Ly2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED1EC3277B;
	Tue, 18 Jun 2024 12:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714767;
	bh=0wZzRAEDUwP4oSqc83neebiqisJA9ug7hkFqtWUmo8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzm6Ly2y0/MZ5O3ZeHYEEQ5+lXiroAwxm/qaozhvBHm+21cbicPsUjarVqxi2z0bS
	 TcqhRdDpIF9HbtoIJR/2Ky8m66TbYUq46JX1wP3G/vdoMIHta6jjcHNemb512KEvmp
	 TC67d51DlEXJEW6mDm/pYo8FIox2ZRKV1RFkKxZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/770] NFSD: Replace READ* macros in nfsd4_decode_nl4_server()
Date: Tue, 18 Jun 2024 14:28:55 +0200
Message-ID: <20240618123410.446395818@linuxfoundation.org>
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

[ Upstream commit f49e4b4d58cc835d8bd0cc9663f7b9c5497e0e7e ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c8506bb6d8725..05aa36f92a929 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1941,36 +1941,42 @@ nfsd4_decode_clone(struct nfsd4_compoundargs *argp, struct nfsd4_clone *clone)
 static __be32 nfsd4_decode_nl4_server(struct nfsd4_compoundargs *argp,
 				      struct nl4_server *ns)
 {
-	DECODE_HEAD;
 	struct nfs42_netaddr *naddr;
+	__be32 *p;
 
-	READ_BUF(4);
-	ns->nl4_type = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &ns->nl4_type) < 0)
+		return nfserr_bad_xdr;
 
 	/* currently support for 1 inter-server source server */
 	switch (ns->nl4_type) {
 	case NL4_NETADDR:
 		naddr = &ns->u.nl4_addr;
 
-		READ_BUF(4);
-		naddr->netid_len = be32_to_cpup(p++);
+		if (xdr_stream_decode_u32(argp->xdr, &naddr->netid_len) < 0)
+			return nfserr_bad_xdr;
 		if (naddr->netid_len > RPCBIND_MAXNETIDLEN)
-			goto xdr_error;
+			return nfserr_bad_xdr;
 
-		READ_BUF(naddr->netid_len + 4); /* 4 for uaddr len */
-		COPYMEM(naddr->netid, naddr->netid_len);
+		p = xdr_inline_decode(argp->xdr, naddr->netid_len);
+		if (!p)
+			return nfserr_bad_xdr;
+		memcpy(naddr->netid, p, naddr->netid_len);
 
-		naddr->addr_len = be32_to_cpup(p++);
+		if (xdr_stream_decode_u32(argp->xdr, &naddr->addr_len) < 0)
+			return nfserr_bad_xdr;
 		if (naddr->addr_len > RPCBIND_MAXUADDRLEN)
-			goto xdr_error;
+			return nfserr_bad_xdr;
 
-		READ_BUF(naddr->addr_len);
-		COPYMEM(naddr->addr, naddr->addr_len);
+		p = xdr_inline_decode(argp->xdr, naddr->addr_len);
+		if (!p)
+			return nfserr_bad_xdr;
+		memcpy(naddr->addr, p, naddr->addr_len);
 		break;
 	default:
-		goto xdr_error;
+		return nfserr_bad_xdr;
 	}
-	DECODE_TAIL;
+
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



