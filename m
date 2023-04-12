Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B095F2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3397AC433D2;
	Wed, 12 Apr 2023 08:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288815;
	bh=bqBIyY/AsZnH1fMI04h3dJNsJxpfw71Irxi+NwJ7sFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SL2NsbDhy0MOB4FDijaIwrIDTOBRs/rW9HLhY50kuBkBlMpQgv17JUBJFK0j11iEi
	 ob74BZUHc7Ea9knJBK0PFDbgqpoLinCQ7ePVy/A8t05iwWHiRpvAu0BAkpQB4JaWlv
	 /+oM8IxamP59TQU8LdCaYHFLtBmXytbtvQBfmqXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/164] NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL
Date: Wed, 12 Apr 2023 10:32:30 +0200
Message-Id: <20230412082838.117729130@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 8377e14b8fba9..405087bda8cc1 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2417,10 +2417,12 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
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
@@ -2431,7 +2433,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 			op->opnum = OP_ILLEGAL;
 			op->status = nfserr_op_illegal;
 		}
-		op->opdesc = OPDESC(op);
+
 		/*
 		 * We'll try to cache the result in the DRC if any one
 		 * op in the compound wants to be cached:
-- 
2.39.2



