Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFAF13A259;
	Tue, 18 Jun 2024 12:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714799; cv=none; b=kYzUSDzUxgGtvbAPnLRK5/ZxNoKNsRHT1GV+1NOGGlmALDpLTVm4SX6iOMDAzVGmD/fPH3zlRuawS/BlhfGCdAgQMNJNngv32PInsX7J6PJGJ3eo4eH6jHrzB+N9GpUmgORJwSC0SJjaKOVcfft2sYp55sKRCJLV4ds7yk7B8C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714799; c=relaxed/simple;
	bh=iK/Hfic/6DndTtG1V8ph+tykXwT2Y9s8psqcmukxvRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9UjJD0bYsJNX/VB/PV5CE+rv9ovDGpS5aStwO9A5W+mtP5DlPas+7vIVSzBtBvpVQ86mvt+PAs1EXj4lntFwbVth8zlFjEnYCu03mfcU99xh4bSwI4n2ylbacoiuZ0kDWiQ/CPb/YFstxkvmHM6jF9TdmhCjZ3SVOLDdKR4ajg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaTzypAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaTzypAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6F0C3277B;
	Tue, 18 Jun 2024 12:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714799;
	bh=iK/Hfic/6DndTtG1V8ph+tykXwT2Y9s8psqcmukxvRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaTzypAi8VjVoOm63iT6w9OD/IopF+hQ15BR3DVkYSQeF2O6VMrCCbTZqYuwEqZcI
	 +iEJdaQWvhq9oU4KK2X9yLxJIsW+iHj28sVVK+qyBKFXpWU2wgVA2v4LrNGYyavCCI
	 jEYlpzisPjHjhhEQVUGwNDBEwVEoWeuBO87Sja5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/770] NFSD: Replace READ* macros in nfsd4_decode_compound()
Date: Tue, 18 Jun 2024 14:29:05 +0200
Message-ID: <20240618123410.825835228@linuxfoundation.org>
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

[ Upstream commit d9b74bdac6f24afc3101b6a5b6f59842610c9c94 ]

And clean-up: Now that we have removed the DECODE_TAIL macro from
nfsd4_decode_compound(), we observe that there's no benefit for
nfsd4_decode_compound() to return nfs_ok or nfserr_bad_xdr only to
have its sole caller convert those values to one or zero,
respectively. Have nfsd4_decode_compound() return 1/0 instead.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 69 ++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 40 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 085191b4b3aa5..30604a3e70c0f 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -186,28 +186,6 @@ svcxdr_dupstr(struct nfsd4_compoundargs *argp, void *buf, u32 len)
 	return p;
 }
 
-/**
- * savemem - duplicate a chunk of memory for later processing
- * @argp: NFSv4 compound argument structure to be freed with
- * @p: pointer to be duplicated
- * @nbytes: length to be duplicated
- *
- * Returns a pointer to a copy of @nbytes bytes of memory at @p
- * that are preserved until processing of the NFSv4 compound
- * operation described by @argp finishes.
- */
-static char *savemem(struct nfsd4_compoundargs *argp, __be32 *p, int nbytes)
-{
-	void *ret;
-
-	ret = svcxdr_tmpalloc(argp, nbytes);
-	if (!ret)
-		return NULL;
-	memcpy(ret, p, nbytes);
-	return ret;
-}
-
-
 /*
  * NFSv4 basic data type decoders
  */
@@ -2372,43 +2350,54 @@ nfsd4_opnum_in_range(struct nfsd4_compoundargs *argp, struct nfsd4_op *op)
 	return true;
 }
 
-static __be32
+static int
 nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 {
-	DECODE_HEAD;
 	struct nfsd4_op *op;
 	bool cachethis = false;
 	int auth_slack= argp->rqstp->rq_auth_slack;
 	int max_reply = auth_slack + 8; /* opcnt, status */
 	int readcount = 0;
 	int readbytes = 0;
+	__be32 *p;
 	int i;
 
-	READ_BUF(4);
-	argp->taglen = be32_to_cpup(p++);
-	READ_BUF(argp->taglen);
-	SAVEMEM(argp->tag, argp->taglen);
-	READ_BUF(8);
-	argp->minorversion = be32_to_cpup(p++);
-	argp->opcnt = be32_to_cpup(p++);
-	max_reply += 4 + (XDR_QUADLEN(argp->taglen) << 2);
-
-	if (argp->taglen > NFSD4_MAX_TAGLEN)
-		goto xdr_error;
+	if (xdr_stream_decode_u32(argp->xdr, &argp->taglen) < 0)
+		return 0;
+	max_reply += XDR_UNIT;
+	argp->tag = NULL;
+	if (unlikely(argp->taglen)) {
+		if (argp->taglen > NFSD4_MAX_TAGLEN)
+			return 0;
+		p = xdr_inline_decode(argp->xdr, argp->taglen);
+		if (!p)
+			return 0;
+		argp->tag = svcxdr_tmpalloc(argp, argp->taglen);
+		if (!argp->tag)
+			return 0;
+		memcpy(argp->tag, p, argp->taglen);
+		max_reply += xdr_align_size(argp->taglen);
+	}
+
+	if (xdr_stream_decode_u32(argp->xdr, &argp->minorversion) < 0)
+		return 0;
+	if (xdr_stream_decode_u32(argp->xdr, &argp->opcnt) < 0)
+		return 0;
+
 	/*
 	 * NFS4ERR_RESOURCE is a more helpful error than GARBAGE_ARGS
 	 * here, so we return success at the xdr level so that
 	 * nfsd4_proc can handle this is an NFS-level error.
 	 */
 	if (argp->opcnt > NFSD_MAX_OPS_PER_COMPOUND)
-		return 0;
+		return 1;
 
 	if (argp->opcnt > ARRAY_SIZE(argp->iops)) {
 		argp->ops = kzalloc(argp->opcnt * sizeof(*argp->ops), GFP_KERNEL);
 		if (!argp->ops) {
 			argp->ops = argp->iops;
 			dprintk("nfsd: couldn't allocate room for COMPOUND\n");
-			goto xdr_error;
+			return 0;
 		}
 	}
 
@@ -2420,7 +2409,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 		op->replay = NULL;
 
 		if (xdr_stream_decode_u32(argp->xdr, &op->opnum) < 0)
-			return nfserr_bad_xdr;
+			return 0;
 		if (nfsd4_opnum_in_range(argp, op)) {
 			op->status = nfsd4_dec_ops[op->opnum](argp, &op->u);
 			if (op->status != nfs_ok)
@@ -2467,7 +2456,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 	if (readcount > 1 || max_reply > PAGE_SIZE - auth_slack)
 		clear_bit(RQ_SPLICE_OK, &argp->rqstp->rq_flags);
 
-	DECODE_TAIL;
+	return 1;
 }
 
 static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode,
@@ -5496,7 +5485,7 @@ nfs4svc_decode_compoundargs(struct svc_rqst *rqstp, __be32 *p)
 	args->ops = args->iops;
 	args->rqstp = rqstp;
 
-	return !nfsd4_decode_compound(args);
+	return nfsd4_decode_compound(args);
 }
 
 int
-- 
2.43.0



