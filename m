Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA39813E022;
	Tue, 18 Jun 2024 12:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714666; cv=none; b=EkYsUtaeC+SEmqEKN3clpBW5EqqIzttPvbAmQPxXmaSkD4vShmCRFqj4zU3K81bMR+mEX/CX0tySFUqBh9kdopcymhx1VnjGdhE5ea5T90A7eyemMIeEpkHuc6j147IXi63PiMPJn1P7mZ3Bt4jyIQQUx38r39E0KgLfISF7k18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714666; c=relaxed/simple;
	bh=386+NpsYlY3u0tzImXswkk/VWDa1aOz6aoEm7RtB2oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKjMG9n0Beh8OzKcwp5is6QJcosuGhwJOZ6xDclj9PmKUrLv1jLSY3PKr0vlQktB0XSDEH034WF3W3yH70fd36nxC4O94IP9sXigGPrbvM4gJH5Xf4L98NkMMAPUa1SSfEIGp+RrNP3a3IU3xZFPzXx38PvEaDIO4u0zTOZO7H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbmliNzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbmliNzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE9EC3277B;
	Tue, 18 Jun 2024 12:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714666;
	bh=386+NpsYlY3u0tzImXswkk/VWDa1aOz6aoEm7RtB2oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbmliNzGTxe0sznUqqO8PGG0RHLnqKcwdhy61KV+StUnk80aHn46PyS03Oexc9+eg
	 MskicnR/pYjrCCiDEAxaqB+QZhOEuyxdr9xrVMU9JVt8pELtUlCiwoeJlZYVZkJfnx
	 jwnGnTIQQNG5TbzzpjaHG15QMm/8qogr05JdZ+2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/770] NFSD: Replace READ* macros in nfsd4_decode_putfh()
Date: Tue, 18 Jun 2024 14:28:21 +0200
Message-ID: <20240618123409.145866361@linuxfoundation.org>
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

[ Upstream commit a73bed98413b1d9eb4466f776a56d2fde8b3b2c9 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 95c755473899f..149948393ccb1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1190,16 +1190,21 @@ nfsd4_decode_open_downgrade(struct nfsd4_compoundargs *argp, struct nfsd4_open_d
 static __be32
 nfsd4_decode_putfh(struct nfsd4_compoundargs *argp, struct nfsd4_putfh *putfh)
 {
-	DECODE_HEAD;
+	__be32 *p;
 
-	READ_BUF(4);
-	putfh->pf_fhlen = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &putfh->pf_fhlen) < 0)
+		return nfserr_bad_xdr;
 	if (putfh->pf_fhlen > NFS4_FHSIZE)
-		goto xdr_error;
-	READ_BUF(putfh->pf_fhlen);
-	SAVEMEM(putfh->pf_fhval, putfh->pf_fhlen);
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, putfh->pf_fhlen);
+	if (!p)
+		return nfserr_bad_xdr;
+	putfh->pf_fhval = svcxdr_tmpalloc(argp, putfh->pf_fhlen);
+	if (!putfh->pf_fhval)
+		return nfserr_jukebox;
+	memcpy(putfh->pf_fhval, p, putfh->pf_fhlen);
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



