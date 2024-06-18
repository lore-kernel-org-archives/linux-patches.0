Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350C143722;
	Tue, 18 Jun 2024 12:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714796; cv=none; b=dxFJnUUqTthnXPmTzVjJQjpbY0maZdtW5Vej7FNGtDCJQWQ2955SEebO5zR3XqIev4pwBReNJNUAtbwKvqF2viNPY9YJ+MQtn8MzQnGtxHEG2KXFl4mW6zFpcEOW+56TuI8zvqa2N/opCtY91MoclugUnwE+SqToas2hUgnnAvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714796; c=relaxed/simple;
	bh=+1VVj7BOzVlF40rSzHlJ+lwxnhsQ+wAnWg0SfmEp9XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex7Gh+jyDQI+kVhU5Iv2piD6xCSaFL3q+LKqTykelkgZtk3b9oRR+Ei4Ulwcp96tJHI8arKXAPpyULR4YiGHgVW+F31OVgPz266Jca/ntuhziu+Jww/8UN8nB/WzN0L3X5RMC6KcX1pyCTyH04SVYUkVExfRqsW+pVhqWiaZiAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G35VPXBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G35VPXBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8C9C3277B;
	Tue, 18 Jun 2024 12:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714796;
	bh=+1VVj7BOzVlF40rSzHlJ+lwxnhsQ+wAnWg0SfmEp9XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G35VPXBt2fpnHo33PCC+35roR5DEJ+B5+aJtbv4GtpYHLyo8HN5iPP+712HU7O50e
	 mNbwgUYQ6FOpzH7BmR5hdTeIP29iwku/YOjC/mqHSYhJbsyHmH1EvqPrLk1uShD5dz
	 71kLWfN8YF5MT3VlD9K30u396asxGNRSwsZ2sbEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/770] NFSD: Make nfsd4_ops::opnum a u32
Date: Tue, 18 Jun 2024 14:29:04 +0200
Message-ID: <20240618123410.786728370@linuxfoundation.org>
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

[ Upstream commit 3a237b4af5b7b0e77588e120554077cab3341943 ]

Avoid passing a "pointer to int" argument to xdr_stream_decode_u32.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 +-
 fs/nfsd/nfs4xdr.c  | 7 +++----
 fs/nfsd/xdr4.h     | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index a038d1e182ff3..6b06f0ad05615 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -3272,7 +3272,7 @@ int nfsd4_max_reply(struct svc_rqst *rqstp, struct nfsd4_op *op)
 void warn_on_nonidempotent_op(struct nfsd4_op *op)
 {
 	if (OPDESC(op)->op_flags & OP_MODIFIES_SOMETHING) {
-		pr_err("unable to encode reply to nonidempotent op %d (%s)\n",
+		pr_err("unable to encode reply to nonidempotent op %u (%s)\n",
 			op->opnum, nfsd4_op_name(op->opnum));
 		WARN_ON_ONCE(1);
 	}
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index bf8eacab64952..085191b4b3aa5 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2419,9 +2419,8 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 		op = &argp->ops[i];
 		op->replay = NULL;
 
-		READ_BUF(4);
-		op->opnum = be32_to_cpup(p++);
-
+		if (xdr_stream_decode_u32(argp->xdr, &op->opnum) < 0)
+			return nfserr_bad_xdr;
 		if (nfsd4_opnum_in_range(argp, op)) {
 			op->status = nfsd4_dec_ops[op->opnum](argp, &op->u);
 			if (op->status != nfs_ok)
@@ -5395,7 +5394,7 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 	if (op->status && opdesc &&
 			!(opdesc->op_flags & OP_NONTRIVIAL_ERROR_ENCODE))
 		goto status;
-	BUG_ON(op->opnum < 0 || op->opnum >= ARRAY_SIZE(nfsd4_enc_ops) ||
+	BUG_ON(op->opnum >= ARRAY_SIZE(nfsd4_enc_ops) ||
 	       !nfsd4_enc_ops[op->opnum]);
 	encoder = nfsd4_enc_ops[op->opnum];
 	op->status = encoder(resp, op->status, &op->u);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index facc5762bf831..2c31f3a7d7c74 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -615,7 +615,7 @@ struct nfsd4_copy_notify {
 };
 
 struct nfsd4_op {
-	int					opnum;
+	u32					opnum;
 	const struct nfsd4_operation *		opdesc;
 	__be32					status;
 	union nfsd4_op_u {
-- 
2.43.0



