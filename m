Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397B215A84B;
	Tue, 18 Jun 2024 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716727; cv=none; b=qN/tkTjhH3fIdLSgIf2gYxUzWWoNRGHPaJuBApTKMWkDFnXLN68tEhKdr+y+3j9jTSzHmpoCMKQ/U7zPREaPhIIWijjG36ihTRvza7/ZjSmbimphVOeJrt5P85zydy8hauV9qZ/jEXHheD2zIE1Cy7cmIM4WwuJrg2C/9Cxl2vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716727; c=relaxed/simple;
	bh=hiU710JXJBqvt4Ojqyw9HOj6DQ1T1fQIN+WgkyeoXgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQkthM/3DjL4HuXwkm5sq8XTOaRAFVnUhRHci2Q3kXeRW/pr2SnbzSlI7xzlxrrOkUKnjEopDLNMfM1PAwXvURWxt5AQZ6+Kwqcw6h9Od++K8tcAEiiCOTE6u0Rz9Zxvvvix8C1Lk9A0fHb588sZedYvgkBfuAJdaG/4+VLPX6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBEn6HDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBEn6HDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F8EC3277B;
	Tue, 18 Jun 2024 13:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716727;
	bh=hiU710JXJBqvt4Ojqyw9HOj6DQ1T1fQIN+WgkyeoXgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBEn6HDpUT1YcXY8s9It2WiwvNlQixNMlx2yoVTusTYarYEkSsKowAdmyZH4Ald6m
	 5SLvS6XcWdE/IxtqAx/0I0vjD1FQL2D/nEQWpbxvu2Dqi3pjX15N6IDYaG6xlSIsg7
	 sTVjAOZfjDaSqSwq2lulU5fI4ErnmPVpo6VxI+HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 742/770] NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL
Date: Tue, 18 Jun 2024 14:39:55 +0200
Message-ID: <20240618123435.909733649@linuxfoundation.org>
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

[ Upstream commit 804d8e0a6e54427268790472781e03bc243f4ee3 ]

OPDESC() simply indexes into nfsd4_ops[] by the op's operation
number, without range checking that value. It assumes callers are
careful to avoid calling it with an out-of-bounds opnum value.

nfsd4_decode_compound() is not so careful, and can invoke OPDESC()
with opnum set to OP_ILLEGAL, which is 10044 -- well beyond the end
of nfsd4_ops[].

Reported-by: Jeff Layton <jlayton@kernel.org>
Fixes: f4f9ef4a1b0a ("nfsd4: opdesc will be useful outside nfs4proc.c")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d0b9fbf189ac6..e1f2f26ba93f2 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2476,10 +2476,12 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 	for (i = 0; i < argp->opcnt; i++) {
 		op = &argp->ops[i];
 		op->replay = NULL;
+		op->opdesc = NULL;
 
 		if (xdr_stream_decode_u32(argp->xdr, &op->opnum) < 0)
 			return false;
 		if (nfsd4_opnum_in_range(argp, op)) {
+			op->opdesc = OPDESC(op);
 			op->status = nfsd4_dec_ops[op->opnum](argp, &op->u);
 			if (op->status != nfs_ok)
 				trace_nfsd_compound_decode_err(argp->rqstp,
@@ -2490,7 +2492,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 			op->opnum = OP_ILLEGAL;
 			op->status = nfserr_op_illegal;
 		}
-		op->opdesc = OPDESC(op);
+
 		/*
 		 * We'll try to cache the result in the DRC if any one
 		 * op in the compound wants to be cached:
-- 
2.43.0



