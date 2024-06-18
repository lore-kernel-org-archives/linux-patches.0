Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0CC50297;
	Tue, 18 Jun 2024 12:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714782; cv=none; b=PBqYT2K2tbqPHo2lJQ02BtHUwug27eRluDJsgURqbvmlgYShBM9zqtGkPjB6K2Mm5cH0Nkfm9DfATAzt6u/GVQwlBVlAgHamdncD/yUzU6eaHSKk6hb+aWJtd7KQ6uvgs5JAu4NPbdm8Q1Vk/bz+/Y4zSF9V8bBCylN5KAzqEao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714782; c=relaxed/simple;
	bh=OXHL3z1lE4NeVzWqWkqdgglhOl5z54zuLMUVvLNlEVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXPFrmN4AkezzO9wJ2v5m+0IUevp/8kLkkQISiCtLQzF1JTq/YGGoJ5KlElqxMFV9BvyQe/XWoOSyMnT9ewAgiZT7+L/PcU7gceiR1M8U4xxmLWydv0Lb684F1k+o25/a5gDu/5cOwGuR3wLwpogAkJHPDDqYI73NQzrQxEixvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7ZNF1a9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7ZNF1a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C6CC3277B;
	Tue, 18 Jun 2024 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714781;
	bh=OXHL3z1lE4NeVzWqWkqdgglhOl5z54zuLMUVvLNlEVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7ZNF1a9Xs/2sCiDQzTYC8V+QFeNAQ6JDule68iTHiS1WSQrMHl4GjN3g2kaohr1L
	 dqkjo39lt4Q7O2WYd2Xh9UFbsZK7rtWYCXZgIZIoOYWX8iZ84rxcm2+sRwW0OLu3CN
	 23kIU0hls8+36r672yiPvQCiXNTBub6rQfsUJiZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/770] NFSD: Replace READ* macros in nfsd4_decode_clone()
Date: Tue, 18 Jun 2024 14:29:00 +0200
Message-ID: <20240618123410.636467826@linuxfoundation.org>
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

[ Upstream commit 3dfd0b0e15671e2b4047ccb9222432f0b2d930be ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 52 +++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 2e2fae7e38db2..bf2a2ef6a8b97 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -575,18 +575,6 @@ nfsd4_decode_fattr4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen,
 	return nfs_ok;
 }
 
-static __be32
-nfsd4_decode_stateid(struct nfsd4_compoundargs *argp, stateid_t *sid)
-{
-	DECODE_HEAD;
-
-	READ_BUF(sizeof(stateid_t));
-	sid->si_generation = be32_to_cpup(p++);
-	COPYMEM(&sid->si_opaque, sizeof(stateid_opaque_t));
-
-	DECODE_TAIL;
-}
-
 static __be32
 nfsd4_decode_stateid4(struct nfsd4_compoundargs *argp, stateid_t *sid)
 {
@@ -1919,25 +1907,6 @@ nfsd4_decode_fallocate(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
-static __be32
-nfsd4_decode_clone(struct nfsd4_compoundargs *argp, struct nfsd4_clone *clone)
-{
-	DECODE_HEAD;
-
-	status = nfsd4_decode_stateid(argp, &clone->cl_src_stateid);
-	if (status)
-		return status;
-	status = nfsd4_decode_stateid(argp, &clone->cl_dst_stateid);
-	if (status)
-		return status;
-
-	READ_BUF(8 + 8 + 8);
-	p = xdr_decode_hyper(p, &clone->cl_src_pos);
-	p = xdr_decode_hyper(p, &clone->cl_dst_pos);
-	p = xdr_decode_hyper(p, &clone->cl_count);
-	DECODE_TAIL;
-}
-
 static __be32 nfsd4_decode_nl4_server(struct nfsd4_compoundargs *argp,
 				      struct nl4_server *ns)
 {
@@ -2067,6 +2036,27 @@ nfsd4_decode_seek(struct nfsd4_compoundargs *argp, struct nfsd4_seek *seek)
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_clone(struct nfsd4_compoundargs *argp, struct nfsd4_clone *clone)
+{
+	__be32 status;
+
+	status = nfsd4_decode_stateid4(argp, &clone->cl_src_stateid);
+	if (status)
+		return status;
+	status = nfsd4_decode_stateid4(argp, &clone->cl_dst_stateid);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u64(argp->xdr, &clone->cl_src_pos) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &clone->cl_dst_pos) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &clone->cl_count) < 0)
+		return nfserr_bad_xdr;
+
+	return nfs_ok;
+}
+
 /*
  * XDR data that is more than PAGE_SIZE in size is normally part of a
  * read or write. However, the size of extended attributes is limited
-- 
2.43.0



