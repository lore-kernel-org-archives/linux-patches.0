Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFDA1DA24;
	Tue, 18 Jun 2024 12:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714740; cv=none; b=O0TBpubOSmd2POw9rMcTtt6+pP+bi/i53NAIzCYdxdRDfQXc7mgBUwwg5mdPxVa28GO0+uYGS2VhXCYgvPHjybM0+JH+vF7FM/5LXePCtVMwTzPMroW1uLgRyn/CTzF4ij4HyrfeQoUjF6LcAOHWUVR60Y4aEfNqIttZyG3XrZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714740; c=relaxed/simple;
	bh=6PGos+GehKJnDuBZ//DYuAbQ2+M73JAvJg5joSCnBHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=durAB8+ZiBeH8U6R5Wfjr8PZoMLqPgiPN97s75ews48qdgSXwkjgPKSOww9M7R5EauVcfqV7e7yjb5v7wHDXDIrQ5LB+3pEj1kefCtbFdgShglA6uc1jhBrvrzJTN0AkTrPEVXPGGxPkVaQrZoH5tvYtRQbM9f/0FOR/okxHl0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFEwmC41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFEwmC41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1667BC3277B;
	Tue, 18 Jun 2024 12:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714740;
	bh=6PGos+GehKJnDuBZ//DYuAbQ2+M73JAvJg5joSCnBHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFEwmC41FI1klCR7ZcOv7TR7nZ7o1w3Lxbtr8kpubpbkOfBJhBybgFMPe5EkIPudW
	 qy8UjS1fdlINBnLbFDXmD1NS6G8ZDvB2j9jrX3uDNkmBPXYlj5995QB1pdLuefJhYh
	 nPHxJPD3LjDh+nV7O3JCLMPWSN8FaDHDAtCVCm1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/770] NFSD: Add helper to decode OPENs openflag4 argument
Date: Tue, 18 Jun 2024 14:28:14 +0200
Message-ID: <20240618123408.879614172@linuxfoundation.org>
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

[ Upstream commit e6ec04b27bfb4869c0e35fbcf24333d379f101d5 ]

Refactor for clarity.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 62096b2a57b35..76715d1935ade 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -988,6 +988,28 @@ nfsd4_decode_createhow4(struct nfsd4_compoundargs *argp, struct nfsd4_open *open
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_openflag4(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
+{
+	__be32 status;
+
+	if (xdr_stream_decode_u32(argp->xdr, &open->op_create) < 0)
+		return nfserr_bad_xdr;
+	switch (open->op_create) {
+	case NFS4_OPEN_NOCREATE:
+		break;
+	case NFS4_OPEN_CREATE:
+		status = nfsd4_decode_createhow4(argp, open);
+		if (status)
+			return status;
+		break;
+	default:
+		return nfserr_bad_xdr;
+	}
+
+	return nfs_ok;
+}
+
 static __be32 nfsd4_decode_share_access(struct nfsd4_compoundargs *argp, u32 *share_access, u32 *deleg_want, u32 *deleg_when)
 {
 	__be32 *p;
@@ -1082,19 +1104,9 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 	status = nfsd4_decode_opaque(argp, &open->op_owner);
 	if (status)
 		goto xdr_error;
-	READ_BUF(4);
-	open->op_create = be32_to_cpup(p++);
-	switch (open->op_create) {
-	case NFS4_OPEN_NOCREATE:
-		break;
-	case NFS4_OPEN_CREATE:
-		status = nfsd4_decode_createhow4(argp, open);
-		if (status)
-			return status;
-		break;
-	default:
-		goto xdr_error;
-	}
+	status = nfsd4_decode_openflag4(argp, open);
+	if (status)
+		return status;
 
 	/* open_claim */
 	READ_BUF(4);
-- 
2.43.0



