Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4230713D272;
	Tue, 18 Jun 2024 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714770; cv=none; b=AbJA88TgUfPh879A2FLWU7/tbNKKG/b6XXvzr5TtcWod7tFxiOUJj2VgiamFWYyDZdH/UMs/kSb+PZLQuda42nFlmtDVwXf23bWTDJjGQ0AT3qP/U5G63tfdWythDk35vpxdc9hXMbFL+iHYfTKYnCqHZxPPmcgP82mxGqf/QZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714770; c=relaxed/simple;
	bh=H+E7cX9+ejJ95EOlTm1wZHxA9X4h3Vy4gdUbiKKluFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIk1yIGdb5i+VCS+YbKeotxw15cxTxpc/GVqkHXC8TllPW1S/a3BPKToNt8iGl+ohSFPVOLxbpETnRJNN03036rYsKopys0S0eX4ctAeo8NN1osvymRF1qFvlKbK+WyLuWJcHsLXyxjgRvVIrlrwfVcmqRm8RL3gixr5mmuWh1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pR2MaNwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pR2MaNwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2CBC3277B;
	Tue, 18 Jun 2024 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714770;
	bh=H+E7cX9+ejJ95EOlTm1wZHxA9X4h3Vy4gdUbiKKluFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pR2MaNwpLrm63M1WZyTteepL1mzAKG6mt31FvDwbhu4aNj9bTs+NM29n5nUOo4Yng
	 MlYGzpCGKSSVG927bW0sAFBzp+aYs8LIyIyCo4K65DOvyGvoMKTM0tksHV+HVpUIOZ
	 QLWUfFFWeXh6PmEifYVQH61G/E239UoOshCxud8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/770] NFSD: Replace READ* macros in nfsd4_decode_copy()
Date: Tue, 18 Jun 2024 14:28:56 +0200
Message-ID: <20240618123410.484487893@linuxfoundation.org>
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

[ Upstream commit e8febea7190bcbd1e608093acb67f2a5009556aa ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 41 ++++++++++++++++++++++-------------------
 fs/nfsd/xdr4.h    |  2 +-
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 05aa36f92a929..2529368cbbc0b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1982,40 +1982,44 @@ static __be32 nfsd4_decode_nl4_server(struct nfsd4_compoundargs *argp,
 static __be32
 nfsd4_decode_copy(struct nfsd4_compoundargs *argp, struct nfsd4_copy *copy)
 {
-	DECODE_HEAD;
 	struct nl4_server *ns_dummy;
-	int i, count;
+	u32 consecutive, i, count;
+	__be32 status;
 
-	status = nfsd4_decode_stateid(argp, &copy->cp_src_stateid);
+	status = nfsd4_decode_stateid4(argp, &copy->cp_src_stateid);
 	if (status)
 		return status;
-	status = nfsd4_decode_stateid(argp, &copy->cp_dst_stateid);
+	status = nfsd4_decode_stateid4(argp, &copy->cp_dst_stateid);
 	if (status)
 		return status;
+	if (xdr_stream_decode_u64(argp->xdr, &copy->cp_src_pos) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &copy->cp_dst_pos) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &copy->cp_count) < 0)
+		return nfserr_bad_xdr;
+	/* ca_consecutive: we always do consecutive copies */
+	if (xdr_stream_decode_u32(argp->xdr, &consecutive) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &copy->cp_synchronous) < 0)
+		return nfserr_bad_xdr;
 
-	READ_BUF(8 + 8 + 8 + 4 + 4 + 4);
-	p = xdr_decode_hyper(p, &copy->cp_src_pos);
-	p = xdr_decode_hyper(p, &copy->cp_dst_pos);
-	p = xdr_decode_hyper(p, &copy->cp_count);
-	p++; /* ca_consecutive: we always do consecutive copies */
-	copy->cp_synchronous = be32_to_cpup(p++);
-
-	count = be32_to_cpup(p++);
-
+	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
+		return nfserr_bad_xdr;
 	copy->cp_intra = false;
 	if (count == 0) { /* intra-server copy */
 		copy->cp_intra = true;
-		goto intra;
+		return nfs_ok;
 	}
 
-	/* decode all the supplied server addresses but use first */
+	/* decode all the supplied server addresses but use only the first */
 	status = nfsd4_decode_nl4_server(argp, &copy->cp_src);
 	if (status)
 		return status;
 
 	ns_dummy = kmalloc(sizeof(struct nl4_server), GFP_KERNEL);
 	if (ns_dummy == NULL)
-		return nfserrno(-ENOMEM);
+		return nfserrno(-ENOMEM);	/* XXX: jukebox? */
 	for (i = 0; i < count - 1; i++) {
 		status = nfsd4_decode_nl4_server(argp, ns_dummy);
 		if (status) {
@@ -2024,9 +2028,8 @@ nfsd4_decode_copy(struct nfsd4_compoundargs *argp, struct nfsd4_copy *copy)
 		}
 	}
 	kfree(ns_dummy);
-intra:
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
@@ -4792,7 +4795,7 @@ nfsd4_encode_copy(struct nfsd4_compoundres *resp, __be32 nfserr,
 	__be32 *p;
 
 	nfserr = nfsd42_encode_write_res(resp, &copy->cp_res,
-			copy->cp_synchronous);
+					 !!copy->cp_synchronous);
 	if (nfserr)
 		return nfserr;
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 232529bc1b798..facc5762bf831 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -554,7 +554,7 @@ struct nfsd4_copy {
 	bool			cp_intra;
 
 	/* both */
-	bool		cp_synchronous;
+	u32			cp_synchronous;
 
 	/* response */
 	struct nfsd42_write_res	cp_res;
-- 
2.43.0



