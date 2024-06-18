Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40F6145B13;
	Tue, 18 Jun 2024 12:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714837; cv=none; b=kPB6ruzqid3auJbBIcWqXfatrcpM2ewDEEPu03O5gDRfdbG6T/x8+wZAP/UQ13NfrwWqVx/qM53asC+TRjxxF7+nxL1qEl0csSxIb0FinAQJobQ7V14TAN7YzBvo0ytvcnGs8gZLUWVh7/wytGZlLFb/qpx+IQdlZd8JdxNxHAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714837; c=relaxed/simple;
	bh=Sj0ETzn43bO9a+LWqn+E3mpQldUZusTBREENazgABXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MC/5gac6wW9HTX4tF45aRv/sJYbuuUalvE8R4wu0fBYNJPDFAlBDYGpnBiuq3rkWrnbJyp4mXA8AoHyTgvW8oXRj6vQP1EJdI9naUVpgJ2EfRntfkU2wv+mkNoTBJf+Y3MsoAFdPJBNqvMo6zoyZNwioK4IBdAClnq8Xgg96ifQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l56gBo69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l56gBo69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB5AC3277B;
	Tue, 18 Jun 2024 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714837;
	bh=Sj0ETzn43bO9a+LWqn+E3mpQldUZusTBREENazgABXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l56gBo69DehCPUI8U6lgdJf3uau5zfOZ7dSJSJkFFckGYvP6qlVjGZpWM1C1Hrk6p
	 m6aM3HvPIDc0G7zD6NxEsGXnWfOo1x1YmyvtzjwySMkk74XcfjI4MBwCNFZGg36/UG
	 ffKM65kkmxI5F4SHQQkeBqRODSexHkvsRFK+e+64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/770] NFSD: Replace READ* macros in nfsd4_decode_layoutcommit()
Date: Tue, 18 Jun 2024 14:28:46 +0200
Message-ID: <20240618123410.102647188@linuxfoundation.org>
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

[ Upstream commit 5185980d8a23001c2317c290129ab7ab20067e20 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 120 ++++++++++++++++++++++------------------------
 1 file changed, 58 insertions(+), 62 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 11e32c244b23c..9cd7270e67adc 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -274,20 +274,6 @@ nfsd4_decode_component4(struct nfsd4_compoundargs *argp, char **namp, u32 *lenp)
 	return nfs_ok;
 }
 
-static __be32
-nfsd4_decode_time(struct nfsd4_compoundargs *argp, struct timespec64 *tv)
-{
-	DECODE_HEAD;
-
-	READ_BUF(12);
-	p = xdr_decode_hyper(p, &tv->tv_sec);
-	tv->tv_nsec = be32_to_cpup(p++);
-	if (tv->tv_nsec >= (u32)1000000000)
-		return nfserr_inval;
-
-	DECODE_TAIL;
-}
-
 static __be32
 nfsd4_decode_nfstime4(struct nfsd4_compoundargs *argp, struct timespec64 *tv)
 {
@@ -651,6 +637,29 @@ nfsd4_decode_deviceid4(struct nfsd4_compoundargs *argp,
 	memcpy(devid, p, sizeof(*devid));
 	return nfs_ok;
 }
+
+static __be32
+nfsd4_decode_layoutupdate4(struct nfsd4_compoundargs *argp,
+			   struct nfsd4_layoutcommit *lcp)
+{
+	if (xdr_stream_decode_u32(argp->xdr, &lcp->lc_layout_type) < 0)
+		return nfserr_bad_xdr;
+	if (lcp->lc_layout_type < LAYOUT_NFSV4_1_FILES)
+		return nfserr_bad_xdr;
+	if (lcp->lc_layout_type >= LAYOUT_TYPE_MAX)
+		return nfserr_bad_xdr;
+
+	if (xdr_stream_decode_u32(argp->xdr, &lcp->lc_up_len) < 0)
+		return nfserr_bad_xdr;
+	if (lcp->lc_up_len > 0) {
+		lcp->lc_up_layout = xdr_inline_decode(argp->xdr, lcp->lc_up_len);
+		if (!lcp->lc_up_layout)
+			return nfserr_bad_xdr;
+	}
+
+	return nfs_ok;
+}
+
 #endif /* CONFIG_NFSD_PNFS */
 
 static __be32
@@ -1796,6 +1805,41 @@ nfsd4_decode_getdeviceinfo(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_layoutcommit(struct nfsd4_compoundargs *argp,
+			  struct nfsd4_layoutcommit *lcp)
+{
+	__be32 *p, status;
+
+	if (xdr_stream_decode_u64(argp->xdr, &lcp->lc_seg.offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &lcp->lc_seg.length) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_bool(argp->xdr, &lcp->lc_reclaim) < 0)
+		return nfserr_bad_xdr;
+	status = nfsd4_decode_stateid4(argp, &lcp->lc_sid);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &lcp->lc_newoffset) < 0)
+		return nfserr_bad_xdr;
+	if (lcp->lc_newoffset) {
+		if (xdr_stream_decode_u64(argp->xdr, &lcp->lc_last_wr) < 0)
+			return nfserr_bad_xdr;
+	} else
+		lcp->lc_last_wr = 0;
+	p = xdr_inline_decode(argp->xdr, XDR_UNIT);
+	if (!p)
+		return nfserr_bad_xdr;
+	if (xdr_item_is_present(p)) {
+		status = nfsd4_decode_nfstime4(argp, &lcp->lc_mtime);
+		if (status)
+			return status;
+	} else {
+		lcp->lc_mtime.tv_nsec = UTIME_NOW;
+	}
+	return nfsd4_decode_layoutupdate4(argp, lcp);
+}
+
 static __be32
 nfsd4_decode_layoutget(struct nfsd4_compoundargs *argp,
 		struct nfsd4_layoutget *lgp)
@@ -1820,54 +1864,6 @@ nfsd4_decode_layoutget(struct nfsd4_compoundargs *argp,
 	DECODE_TAIL;
 }
 
-static __be32
-nfsd4_decode_layoutcommit(struct nfsd4_compoundargs *argp,
-		struct nfsd4_layoutcommit *lcp)
-{
-	DECODE_HEAD;
-	u32 timechange;
-
-	READ_BUF(20);
-	p = xdr_decode_hyper(p, &lcp->lc_seg.offset);
-	p = xdr_decode_hyper(p, &lcp->lc_seg.length);
-	lcp->lc_reclaim = be32_to_cpup(p++);
-
-	status = nfsd4_decode_stateid(argp, &lcp->lc_sid);
-	if (status)
-		return status;
-
-	READ_BUF(4);
-	lcp->lc_newoffset = be32_to_cpup(p++);
-	if (lcp->lc_newoffset) {
-		READ_BUF(8);
-		p = xdr_decode_hyper(p, &lcp->lc_last_wr);
-	} else
-		lcp->lc_last_wr = 0;
-	READ_BUF(4);
-	timechange = be32_to_cpup(p++);
-	if (timechange) {
-		status = nfsd4_decode_time(argp, &lcp->lc_mtime);
-		if (status)
-			return status;
-	} else {
-		lcp->lc_mtime.tv_nsec = UTIME_NOW;
-	}
-	READ_BUF(8);
-	lcp->lc_layout_type = be32_to_cpup(p++);
-
-	/*
-	 * Save the layout update in XDR format and let the layout driver deal
-	 * with it later.
-	 */
-	lcp->lc_up_len = be32_to_cpup(p++);
-	if (lcp->lc_up_len > 0) {
-		READ_BUF(lcp->lc_up_len);
-		READMEM(lcp->lc_up_layout, lcp->lc_up_len);
-	}
-
-	DECODE_TAIL;
-}
-
 static __be32
 nfsd4_decode_layoutreturn(struct nfsd4_compoundargs *argp,
 		struct nfsd4_layoutreturn *lrp)
-- 
2.43.0



