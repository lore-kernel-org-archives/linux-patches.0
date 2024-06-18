Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812715B553;
	Tue, 18 Jun 2024 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714720; cv=none; b=V1daqSomgEq9RjPnfgybujqNXWrYirwpAEZNdkfsrAuZ2YXaOSEfhlA2tu+zrwWRifCVEjV1E8SsXRLUhm1+9UNJjK8khsjIfbFDYrWKOEXORWHR8vYA/9Av80Vdva5hzDJY12+tI8aG00Lqyxls1t5NB0VlzW5DjFi6wI5bADc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714720; c=relaxed/simple;
	bh=UbXhqBeW3LctKspbK9f46kEnXkUZhAIdKVNcSNquDk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5pDb0DAhJslhT+pBKlfni18iZFeSTVPkIi4pKEg7lUoMhNVKbD102iIhrJ1M9Zi524g6o2WOJJ4raWNimuqxoTU2u9T/5LOlIcJUfk0GdGG9Jp3ig/HGBRd34Sk0HeynHRfRnOiZ97drFV8zJ+2ktDCzYH5Tqdoq/lbWvSYeWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM5EqjGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM5EqjGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD6CC3277B;
	Tue, 18 Jun 2024 12:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714719;
	bh=UbXhqBeW3LctKspbK9f46kEnXkUZhAIdKVNcSNquDk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gM5EqjGDXNPwMppzT2yhOT3zC90uC/BazKGkNqXF2rY7Eyimyk+Y9EAHZlYanOL+S
	 1nIh+WFCEsHSnfVdh+1TvC8RQXheDdcHR5c8ZRumm+aBM9R2w9Bb6VkJxS+G1PZSyT
	 GhESRQRyfC++VPLmNQ5D2AyWgdvmvWkYS/8DEpOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/770] NFSD: Add a separate decoder to handle state_protect_ops
Date: Tue, 18 Jun 2024 14:28:37 +0200
Message-ID: <20240618123409.755076583@linuxfoundation.org>
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

[ Upstream commit 2548aa784d760567c2a77cbd8b7c55b211167c37 ]

Refactor for clarity and de-duplication of code.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 66 +++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 43 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 5dad32ab02ec4..15535b14328e4 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -315,32 +315,6 @@ nfsd4_decode_verifier4(struct nfsd4_compoundargs *argp, nfs4_verifier *verf)
 	return nfs_ok;
 }
 
-static __be32
-nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
-{
-	u32 bmlen;
-	DECODE_HEAD;
-
-	bmval[0] = 0;
-	bmval[1] = 0;
-	bmval[2] = 0;
-
-	READ_BUF(4);
-	bmlen = be32_to_cpup(p++);
-	if (bmlen > 1000)
-		goto xdr_error;
-
-	READ_BUF(bmlen << 2);
-	if (bmlen > 0)
-		bmval[0] = be32_to_cpup(p++);
-	if (bmlen > 1)
-		bmval[1] = be32_to_cpup(p++);
-	if (bmlen > 2)
-		bmval[2] = be32_to_cpup(p++);
-
-	DECODE_TAIL;
-}
-
 /**
  * nfsd4_decode_bitmap4 - Decode an NFSv4 bitmap4
  * @argp: NFSv4 compound argument structure
@@ -1496,6 +1470,24 @@ static __be32 nfsd4_decode_bind_conn_to_session(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_state_protect_ops(struct nfsd4_compoundargs *argp,
+			       struct nfsd4_exchange_id *exid)
+{
+	__be32 status;
+
+	status = nfsd4_decode_bitmap4(argp, exid->spo_must_enforce,
+				      ARRAY_SIZE(exid->spo_must_enforce));
+	if (status)
+		return nfserr_bad_xdr;
+	status = nfsd4_decode_bitmap4(argp, exid->spo_must_allow,
+				      ARRAY_SIZE(exid->spo_must_allow));
+	if (status)
+		return nfserr_bad_xdr;
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 			 struct nfsd4_exchange_id *exid)
@@ -1520,27 +1512,15 @@ nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 	case SP4_NONE:
 		break;
 	case SP4_MACH_CRED:
-		/* spo_must_enforce */
-		status = nfsd4_decode_bitmap(argp,
-					exid->spo_must_enforce);
-		if (status)
-			goto out;
-		/* spo_must_allow */
-		status = nfsd4_decode_bitmap(argp, exid->spo_must_allow);
+		status = nfsd4_decode_state_protect_ops(argp, exid);
 		if (status)
-			goto out;
+			return status;
 		break;
 	case SP4_SSV:
 		/* ssp_ops */
-		READ_BUF(4);
-		dummy = be32_to_cpup(p++);
-		READ_BUF(dummy * 4);
-		p += dummy;
-
-		READ_BUF(4);
-		dummy = be32_to_cpup(p++);
-		READ_BUF(dummy * 4);
-		p += dummy;
+		status = nfsd4_decode_state_protect_ops(argp, exid);
+		if (status)
+			return status;
 
 		/* ssp_hash_algs<> */
 		READ_BUF(4);
-- 
2.43.0



