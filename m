Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513DC15B159;
	Tue, 18 Jun 2024 12:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714717; cv=none; b=NnIxuRlPeUzTXbsUf35L6VXHqqadDFRrflH9W9wJytiTa9LF/24jIP3dkLQL0i2R88h5R6O4xtRYHrbs1vEeWepgsYiDUIBRUhnaRJp5IvJpstjqfNHAZ9RjYL2DPff3nX0pNHYtMRr16jJ8apNmtoeTGMdGpmxpL7C3CtZYQW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714717; c=relaxed/simple;
	bh=l2DRmQV4hf01KZaOPfeZcwjf659eh43oJ6Mt99Kxh3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTcS9AeAZ+jQcoE8eUDfr/03OR48oFIcMsIqytsbmCHtoEJG3SabwUPQOljL2ZZlWVNYBcDHdZYxP/VznKSor5/u9eGUGacbRGKogmCnRBciPshuZzsQvV5YOgdt6yG+lHpi8n5eu3Op2RmEdE7Ux9fQ3K2qY7u/Dtik31ltyiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5nhgk0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5nhgk0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B888C3277B;
	Tue, 18 Jun 2024 12:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714716;
	bh=l2DRmQV4hf01KZaOPfeZcwjf659eh43oJ6Mt99Kxh3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5nhgk0uxX5nkFb3sfk6ztZd+CnzYV+jv+zKnOWbDiyYizy4BNNHINRMqG1xWaekc
	 GXSVFujKXUKpDXEsvE7AS+UFi1KQRr9Dz/YdsLjqX1mjrxnekGU3gyR/GC94PjTgR4
	 zLfrXFsYpRYQW2XH0AH3kLie2h6zVgBFMGqIOq1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/770] NFSD: Replace READ* macros in nfsd4_decode_locku()
Date: Tue, 18 Jun 2024 14:28:10 +0200
Message-ID: <20240618123408.724945398@linuxfoundation.org>
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

[ Upstream commit ca9cf9fc27f8f722e9eb2763173ba01f6ac3dad1 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4f2680650a567..3c20a1f8eaa91 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -909,21 +909,23 @@ nfsd4_decode_lockt(struct nfsd4_compoundargs *argp, struct nfsd4_lockt *lockt)
 static __be32
 nfsd4_decode_locku(struct nfsd4_compoundargs *argp, struct nfsd4_locku *locku)
 {
-	DECODE_HEAD;
+	__be32 status;
 
-	READ_BUF(8);
-	locku->lu_type = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &locku->lu_type) < 0)
+		return nfserr_bad_xdr;
 	if ((locku->lu_type < NFS4_READ_LT) || (locku->lu_type > NFS4_WRITEW_LT))
-		goto xdr_error;
-	locku->lu_seqid = be32_to_cpup(p++);
-	status = nfsd4_decode_stateid(argp, &locku->lu_stateid);
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &locku->lu_seqid) < 0)
+		return nfserr_bad_xdr;
+	status = nfsd4_decode_stateid4(argp, &locku->lu_stateid);
 	if (status)
 		return status;
-	READ_BUF(16);
-	p = xdr_decode_hyper(p, &locku->lu_offset);
-	p = xdr_decode_hyper(p, &locku->lu_length);
+	if (xdr_stream_decode_u64(argp->xdr, &locku->lu_offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &locku->lu_length) < 0)
+		return nfserr_bad_xdr;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



