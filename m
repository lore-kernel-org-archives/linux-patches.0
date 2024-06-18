Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF8C15958E;
	Tue, 18 Jun 2024 12:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714584; cv=none; b=L+UeXqrVTpDL5xoIMHMuVmjDxyG5etRuAqGhTczKEd1WFSpLj6BRIC22KmWIQ7CN9CFVVEY7AO1QSHGbq+YfpTmRVWvGYgoZkaL5YHlfEecKJT6nq972R2mI9WsQo/fw3jzw3kth+k74P1Ftvd0GGA+sVAB8+lePrfoQifzJ8B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714584; c=relaxed/simple;
	bh=KLDW5IdmMk2e7F9iLOp9WSGsxaVtva3vsyc/pmd1Tb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqHob+yXY90SSySj7yVDU6QIQ5tcsVO4T+GPoCKWQtYm/WIfgnSLC7TNymLu9jeyBCT6noM2Wsde33u3nvfHDDmC5QsZ3B3jQd9WroXq12L31Cn4enh3R8ZkWkR8w3AdPS6H2dgVMJ1DrGBniNigOZq3OUKheM6vPIXXgEkwGG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGGDoVmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGGDoVmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC73C4AF1D;
	Tue, 18 Jun 2024 12:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714583;
	bh=KLDW5IdmMk2e7F9iLOp9WSGsxaVtva3vsyc/pmd1Tb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGGDoVmoYI4QBBRTL74oFx04Ro1eAvjlzQyH/cDidL0XemzEfOgrDQtEngYn01++N
	 aG4QjsLO/03cl8UvhWuc8My+hqLZO9ZUtiktyFOrKE95ukcUwwGJm7H9AWS1vOCbL5
	 uulBZwT+4NPCMcjQQN3qtKQLBqBz7J0intCUxfbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/770] NFSD: Replace READ* macros that decode the fattr4 acl attribute
Date: Tue, 18 Jun 2024 14:27:53 +0200
Message-ID: <20240618123408.077361021@linuxfoundation.org>
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

[ Upstream commit c941a96823cf52e742606b486b81ab346bf111c9 ]

Refactor for clarity and to move infrequently-used code out of line.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 107 +++++++++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 40 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 5ec0c2dac3348..0fe57ca0f31ac 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -245,6 +245,70 @@ nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 	DECODE_TAIL;
 }
 
+static __be32
+nfsd4_decode_nfsace4(struct nfsd4_compoundargs *argp, struct nfs4_ace *ace)
+{
+	__be32 *p, status;
+	u32 length;
+
+	if (xdr_stream_decode_u32(argp->xdr, &ace->type) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &ace->flag) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &ace->access_mask) < 0)
+		return nfserr_bad_xdr;
+
+	if (xdr_stream_decode_u32(argp->xdr, &length) < 0)
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, length);
+	if (!p)
+		return nfserr_bad_xdr;
+	ace->whotype = nfs4_acl_get_whotype((char *)p, length);
+	if (ace->whotype != NFS4_ACL_WHO_NAMED)
+		status = nfs_ok;
+	else if (ace->flag & NFS4_ACE_IDENTIFIER_GROUP)
+		status = nfsd_map_name_to_gid(argp->rqstp,
+				(char *)p, length, &ace->who_gid);
+	else
+		status = nfsd_map_name_to_uid(argp->rqstp,
+				(char *)p, length, &ace->who_uid);
+
+	return status;
+}
+
+/* A counted array of nfsace4's */
+static noinline __be32
+nfsd4_decode_acl(struct nfsd4_compoundargs *argp, struct nfs4_acl **acl)
+{
+	struct nfs4_ace *ace;
+	__be32 status;
+	u32 count;
+
+	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
+		return nfserr_bad_xdr;
+
+	if (count > xdr_stream_remaining(argp->xdr) / 20)
+		/*
+		 * Even with 4-byte names there wouldn't be
+		 * space for that many aces; something fishy is
+		 * going on:
+		 */
+		return nfserr_fbig;
+
+	*acl = svcxdr_tmpalloc(argp, nfs4_acl_bytes(count));
+	if (*acl == NULL)
+		return nfserr_jukebox;
+
+	(*acl)->naces = count;
+	for (ace = (*acl)->aces; ace < (*acl)->aces + count; ace++) {
+		status = nfsd4_decode_nfsace4(argp, ace);
+		if (status)
+			return status;
+	}
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		   struct iattr *iattr, struct nfs4_acl **acl,
@@ -281,46 +345,9 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		iattr->ia_valid |= ATTR_SIZE;
 	}
 	if (bmval[0] & FATTR4_WORD0_ACL) {
-		u32 nace;
-		struct nfs4_ace *ace;
-
-		READ_BUF(4);
-		nace = be32_to_cpup(p++);
-
-		if (nace > xdr_stream_remaining(argp->xdr) / sizeof(struct nfs4_ace))
-			/*
-			 * Even with 4-byte names there wouldn't be
-			 * space for that many aces; something fishy is
-			 * going on:
-			 */
-			return nfserr_fbig;
-
-		*acl = svcxdr_tmpalloc(argp, nfs4_acl_bytes(nace));
-		if (*acl == NULL)
-			return nfserr_jukebox;
-
-		(*acl)->naces = nace;
-		for (ace = (*acl)->aces; ace < (*acl)->aces + nace; ace++) {
-			READ_BUF(16);
-			ace->type = be32_to_cpup(p++);
-			ace->flag = be32_to_cpup(p++);
-			ace->access_mask = be32_to_cpup(p++);
-			dummy32 = be32_to_cpup(p++);
-			READ_BUF(dummy32);
-			READMEM(buf, dummy32);
-			ace->whotype = nfs4_acl_get_whotype(buf, dummy32);
-			status = nfs_ok;
-			if (ace->whotype != NFS4_ACL_WHO_NAMED)
-				;
-			else if (ace->flag & NFS4_ACE_IDENTIFIER_GROUP)
-				status = nfsd_map_name_to_gid(argp->rqstp,
-						buf, dummy32, &ace->who_gid);
-			else
-				status = nfsd_map_name_to_uid(argp->rqstp,
-						buf, dummy32, &ace->who_uid);
-			if (status)
-				return status;
-		}
+		status = nfsd4_decode_acl(argp, acl);
+		if (status)
+			return status;
 	} else
 		*acl = NULL;
 	if (bmval[1] & FATTR4_WORD1_MODE) {
-- 
2.43.0



