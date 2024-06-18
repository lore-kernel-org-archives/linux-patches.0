Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BFD15A843;
	Tue, 18 Jun 2024 12:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714578; cv=none; b=JR3k2UGOZ+b0u2x4B1vMosqLysjEvYotfDJzKgxvnE5uRM6hq8rK0UtV4jemC1TnpGdDMLJnIZevbJ5039PjNTXMr4gxS90DcRTWkIl9REUpOo9293MGA7hpsdlNs7D+vSKI0J1av3TB+gEwDLAq/3PKeOYpKKt2EdbGUKbz3ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714578; c=relaxed/simple;
	bh=tn0LLPzBTQGrLCXJWkB/PlaECpiCgJ5BLriBla0OECU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oy2P0NMDUPDXCacxao9VZpl0Zt7ZrF6BoIynuxCerU7LmXtKlicc3nFJuW6+w8O1skSlChHgOS3zuQ7euc8cGURYcxPReaQDPlIWHiUjYXLZvIKWtiuDq7nYvl+BaOSqKwJcQJGm507mZHRy3107tYx6ac30eENAmmNoYDFnkeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygNqz9fg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygNqz9fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFC4C3277B;
	Tue, 18 Jun 2024 12:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714577;
	bh=tn0LLPzBTQGrLCXJWkB/PlaECpiCgJ5BLriBla0OECU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygNqz9fgM8kGHidS4Vfb9BetspWXPlDkNQM9fzaBeR+xxjYkm/ous7y8ssj3t+ZAO
	 6WCpkFk1eTCiPI9tM+CbIr2AsHd0N8+Fk9jBErpcbqqF0WP6fBMNLr3nKP2vgFlamO
	 eFKYQ9JM5Y5Kw1nuV9fpAZxaATpaJXFLeBnAgWys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/770] NFSD: Change the way the expected length of a fattr4 is checked
Date: Tue, 18 Jun 2024 14:27:51 +0200
Message-ID: <20240618123408.001563918@linuxfoundation.org>
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

[ Upstream commit 081d53fe0b43c47c36d1832b759bf14edde9cdbb ]

Because the fattr4 is now managed in an xdr_stream, all that is
needed is to store the initial position of the stream before
decoding the attribute list. Then the actual length of the list
is computed using the final stream position, after decoding is
complete.

No behavior change is expected.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 8251b905d5479..de5ac334cb8ab 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -250,7 +250,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		   struct iattr *iattr, struct nfs4_acl **acl,
 		   struct xdr_netobj *label, int *umask)
 {
-	int expected_len, len = 0;
+	unsigned int starting_pos;
+	u32 attrlist4_count;
 	u32 dummy32;
 	char *buf;
 
@@ -267,12 +268,12 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		return nfserr_attrnotsupp;
 	}
 
-	READ_BUF(4);
-	expected_len = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &attrlist4_count) < 0)
+		return nfserr_bad_xdr;
+	starting_pos = xdr_stream_pos(argp->xdr);
 
 	if (bmval[0] & FATTR4_WORD0_SIZE) {
 		READ_BUF(8);
-		len += 8;
 		p = xdr_decode_hyper(p, &iattr->ia_size);
 		iattr->ia_valid |= ATTR_SIZE;
 	}
@@ -280,7 +281,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		u32 nace;
 		struct nfs4_ace *ace;
 
-		READ_BUF(4); len += 4;
+		READ_BUF(4);
 		nace = be32_to_cpup(p++);
 
 		if (nace > xdr_stream_remaining(argp->xdr) / sizeof(struct nfs4_ace))
@@ -297,13 +298,12 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 
 		(*acl)->naces = nace;
 		for (ace = (*acl)->aces; ace < (*acl)->aces + nace; ace++) {
-			READ_BUF(16); len += 16;
+			READ_BUF(16);
 			ace->type = be32_to_cpup(p++);
 			ace->flag = be32_to_cpup(p++);
 			ace->access_mask = be32_to_cpup(p++);
 			dummy32 = be32_to_cpup(p++);
 			READ_BUF(dummy32);
-			len += XDR_QUADLEN(dummy32) << 2;
 			READMEM(buf, dummy32);
 			ace->whotype = nfs4_acl_get_whotype(buf, dummy32);
 			status = nfs_ok;
@@ -322,17 +322,14 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		*acl = NULL;
 	if (bmval[1] & FATTR4_WORD1_MODE) {
 		READ_BUF(4);
-		len += 4;
 		iattr->ia_mode = be32_to_cpup(p++);
 		iattr->ia_mode &= (S_IFMT | S_IALLUGO);
 		iattr->ia_valid |= ATTR_MODE;
 	}
 	if (bmval[1] & FATTR4_WORD1_OWNER) {
 		READ_BUF(4);
-		len += 4;
 		dummy32 = be32_to_cpup(p++);
 		READ_BUF(dummy32);
-		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
 		if ((status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
 			return status;
@@ -340,10 +337,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	}
 	if (bmval[1] & FATTR4_WORD1_OWNER_GROUP) {
 		READ_BUF(4);
-		len += 4;
 		dummy32 = be32_to_cpup(p++);
 		READ_BUF(dummy32);
-		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
 		if ((status = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
 			return status;
@@ -351,11 +346,9 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_ACCESS_SET) {
 		READ_BUF(4);
-		len += 4;
 		dummy32 = be32_to_cpup(p++);
 		switch (dummy32) {
 		case NFS4_SET_TO_CLIENT_TIME:
-			len += 12;
 			status = nfsd4_decode_time(argp, &iattr->ia_atime);
 			if (status)
 				return status;
@@ -370,11 +363,9 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_MODIFY_SET) {
 		READ_BUF(4);
-		len += 4;
 		dummy32 = be32_to_cpup(p++);
 		switch (dummy32) {
 		case NFS4_SET_TO_CLIENT_TIME:
-			len += 12;
 			status = nfsd4_decode_time(argp, &iattr->ia_mtime);
 			if (status)
 				return status;
@@ -392,18 +383,14 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	if (IS_ENABLED(CONFIG_NFSD_V4_SECURITY_LABEL) &&
 	    bmval[2] & FATTR4_WORD2_SECURITY_LABEL) {
 		READ_BUF(4);
-		len += 4;
 		dummy32 = be32_to_cpup(p++); /* lfs: we don't use it */
 		READ_BUF(4);
-		len += 4;
 		dummy32 = be32_to_cpup(p++); /* pi: we don't use it either */
 		READ_BUF(4);
-		len += 4;
 		dummy32 = be32_to_cpup(p++);
 		READ_BUF(dummy32);
 		if (dummy32 > NFS4_MAXLABELLEN)
 			return nfserr_badlabel;
-		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
 		label->len = dummy32;
 		label->data = svcxdr_dupstr(argp, buf, dummy32);
@@ -414,15 +401,16 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		if (!umask)
 			goto xdr_error;
 		READ_BUF(8);
-		len += 8;
 		dummy32 = be32_to_cpup(p++);
 		iattr->ia_mode = dummy32 & (S_IFMT | S_IALLUGO);
 		dummy32 = be32_to_cpup(p++);
 		*umask = dummy32 & S_IRWXUGO;
 		iattr->ia_valid |= ATTR_MODE;
 	}
-	if (len != expected_len)
-		goto xdr_error;
+
+	/* request sanity: did attrlist4 contain the expected number of words? */
+	if (attrlist4_count != xdr_stream_pos(argp->xdr) - starting_pos)
+		return nfserr_bad_xdr;
 
 	DECODE_TAIL;
 }
-- 
2.43.0



