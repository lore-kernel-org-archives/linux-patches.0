Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7311BD033;
	Tue, 18 Jun 2024 12:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714604; cv=none; b=cbxYtezhcQgmNpDJPdGu8upS6kEOu2y350LbgEp+nouNnm4sfSK5Pl3R/SvAotDsmU6S9Jvl4zJfOT8AkqXgq0z0mZ24BwepQBxhs6nbUqTitFhJpy0oCOUOd5hUTfvc7UtlIvw7G40jQe9hszm/pWRhaAjFNuNmJKs91i2nZEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714604; c=relaxed/simple;
	bh=2a+Pj1EuD//+1FI6Vl7hvh4c7013DCmTw5P87Dy2Otw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kjjd4vt+PjQ4S3fwcZWOy8TyBrSQwWHsuVwYvHUi6lTCJw8VinQyH9G+Dm8o+P3nI5LKcOk5tsH4I4be1ylRMXJxKEfkqxTYZQ+zqAhdEFrZbSCFOuik5ifV8RcHUs6EVXIGzFmyUM3+H2v1Fw0ngBbvCeA2oQ9v+U1iqpFBFMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNxm6z6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNxm6z6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F248EC4AF4D;
	Tue, 18 Jun 2024 12:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714604;
	bh=2a+Pj1EuD//+1FI6Vl7hvh4c7013DCmTw5P87Dy2Otw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNxm6z6Q1qy1qA/9Gr9eEbdDPKono+qm4TLrbmgmUtom99bYlxstgaekevQcRZzEd
	 rmr1js8WKZYsF1W2tKRPmdVcjovyXnAFOjqDyqgBjV9KD1FolpQl2w2MJmfET3nI/M
	 AnToqQDHVfPhObl5Af3YpyfHsMxtqnPBvQtGH5Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/770] NFSD: Replace READ* macros that decode the fattr4 umask attribute
Date: Tue, 18 Jun 2024 14:27:59 +0200
Message-ID: <20240618123408.305404615@linuxfoundation.org>
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

[ Upstream commit 66f0476c704c86d44aa9da19d4753df66f2dbc96 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 453a902c7490a..2d97bbff13b68 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -358,7 +358,6 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 {
 	unsigned int starting_pos;
 	u32 attrlist4_count;
-	u32 dummy32;
 
 	DECODE_HEAD;
 	iattr->ia_valid = 0;
@@ -474,13 +473,16 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			return status;
 	}
 	if (bmval[2] & FATTR4_WORD2_MODE_UMASK) {
+		u32 mode, mask;
+
 		if (!umask)
-			goto xdr_error;
-		READ_BUF(8);
-		dummy32 = be32_to_cpup(p++);
-		iattr->ia_mode = dummy32 & (S_IFMT | S_IALLUGO);
-		dummy32 = be32_to_cpup(p++);
-		*umask = dummy32 & S_IRWXUGO;
+			return nfserr_bad_xdr;
+		if (xdr_stream_decode_u32(argp->xdr, &mode) < 0)
+			return nfserr_bad_xdr;
+		iattr->ia_mode = mode & (S_IFMT | S_IALLUGO);
+		if (xdr_stream_decode_u32(argp->xdr, &mask) < 0)
+			return nfserr_bad_xdr;
+		*umask = mask & S_IRWXUGO;
 		iattr->ia_valid |= ATTR_MODE;
 	}
 
-- 
2.43.0



