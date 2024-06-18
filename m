Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D01A15B159;
	Tue, 18 Jun 2024 12:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714693; cv=none; b=ChH3DhI1b+QM2vawpDGmLkV88EmI/ogyO1VbaWaImUw+jcMD50PotSNe9FRuxGWeTTQtw8Zrjy8VHMb1pv3BC+E72vFO4YYbtXyn0pU2UnSWP+dQJw+f9fnB8UjYOLtN1sf8O+minJZ/SmBQKf1k2S0+l0RoszCvZZR6SzMxg4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714693; c=relaxed/simple;
	bh=9d2HwQl0/533u6Gg3ADFJczirsXDs0KvHsEE62xtT5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRvDGEAly58ma5f0ZwMZNh/luYB7/tnIhV5yFkzPdnetcVyXLe7Sv1g6wezJK3yxDMhh1XxdYglC5sEV+/bBd2iiziYNwzaHbl/zP2LezUFUvVosJZAeyZbjD8CQPXJEjp8m8W8RJa9VuxT38rUZsetkmdue1KQie8m14yH/Lkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5I7SZEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5I7SZEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8992C3277B;
	Tue, 18 Jun 2024 12:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714693;
	bh=9d2HwQl0/533u6Gg3ADFJczirsXDs0KvHsEE62xtT5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5I7SZErTgoI1tPPRefJFyiobEkjO4smEgyASz9xyBIq+fDHzCu9/al3CYph60Cbr
	 CeV08w0vq+XFCnPjPStpMCL4lV2U2ertjVL0yD8wiV7BZ6As9WYJ6si7ttpmKIb7Ck
	 mvTQmQauElzj/yYl0I8bxCTPR9fsbZkIAz4/SamE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/770] NFSD: Replace READ* macros in nfsd4_decode_setclientid()
Date: Tue, 18 Jun 2024 14:28:29 +0200
Message-ID: <20240618123409.451241377@linuxfoundation.org>
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

[ Upstream commit 92fa6c08c251d52d0d7b46066ecf87b96a0c4b8f ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index cda56ca9ca3fc..0af51cc1adba3 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1310,31 +1310,46 @@ nfsd4_decode_setattr(struct nfsd4_compoundargs *argp, struct nfsd4_setattr *seta
 static __be32
 nfsd4_decode_setclientid(struct nfsd4_compoundargs *argp, struct nfsd4_setclientid *setclientid)
 {
-	DECODE_HEAD;
+	__be32 *p, status;
 
 	if (argp->minorversion >= 1)
 		return nfserr_notsupp;
 
-	READ_BUF(NFS4_VERIFIER_SIZE);
-	COPYMEM(setclientid->se_verf.data, NFS4_VERIFIER_SIZE);
-
+	status = nfsd4_decode_verifier4(argp, &setclientid->se_verf);
+	if (status)
+		return status;
 	status = nfsd4_decode_opaque(argp, &setclientid->se_name);
 	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_prog) < 0)
 		return nfserr_bad_xdr;
-	READ_BUF(8);
-	setclientid->se_callback_prog = be32_to_cpup(p++);
-	setclientid->se_callback_netid_len = be32_to_cpup(p++);
-	READ_BUF(setclientid->se_callback_netid_len);
-	SAVEMEM(setclientid->se_callback_netid_val, setclientid->se_callback_netid_len);
-	READ_BUF(4);
-	setclientid->se_callback_addr_len = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_netid_len) < 0)
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, setclientid->se_callback_netid_len);
+	if (!p)
+		return nfserr_bad_xdr;
+	setclientid->se_callback_netid_val = svcxdr_tmpalloc(argp,
+						setclientid->se_callback_netid_len);
+	if (!setclientid->se_callback_netid_val)
+		return nfserr_jukebox;
+	memcpy(setclientid->se_callback_netid_val, p,
+	       setclientid->se_callback_netid_len);
 
-	READ_BUF(setclientid->se_callback_addr_len);
-	SAVEMEM(setclientid->se_callback_addr_val, setclientid->se_callback_addr_len);
-	READ_BUF(4);
-	setclientid->se_callback_ident = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_addr_len) < 0)
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, setclientid->se_callback_addr_len);
+	if (!p)
+		return nfserr_bad_xdr;
+	setclientid->se_callback_addr_val = svcxdr_tmpalloc(argp,
+						setclientid->se_callback_addr_len);
+	if (!setclientid->se_callback_addr_val)
+		return nfserr_jukebox;
+	memcpy(setclientid->se_callback_addr_val, p,
+	       setclientid->se_callback_addr_len);
+	if (xdr_stream_decode_u32(argp->xdr, &setclientid->se_callback_ident) < 0)
+		return nfserr_bad_xdr;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



