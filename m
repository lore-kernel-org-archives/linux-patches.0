Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24352F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6202FC433EF;
	Wed, 12 Apr 2023 08:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288576;
	bh=S9C+DVbDNihUIuicsPTUcuL1eZSUUL8degTs7J10umU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrtYXU10zhc2W4oXj83PIOcpMPBsQdUJVdktkQoHWyYGclJn3yivxYtb/pNXV6K6W
	 i7aBXtvIRCFOP4I1kRl23xH9rfDgjScF2v5DH+7zTW4nDlyLfNid5E1leUYOetQF9/
	 qZZnC5GFQQDBfocW4k1CcrizFslW5SqNO3xl4N8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/93] NFSD: Avoid calling OPDESC() with ops->opnum == OP_ILLEGAL
Date: Wed, 12 Apr 2023 10:33:32 +0200
Message-Id: <20230412082824.407883014@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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
index dfd3877fdd818..0394dd60a0b47 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2370,10 +2370,12 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 	for (i = 0; i < argp->opcnt; i++) {
 		op = &argp->ops[i];
 		op->replay = NULL;
+		op->opdesc = NULL;
 
 		if (xdr_stream_decode_u32(argp->xdr, &op->opnum) < 0)
 			return 0;
 		if (nfsd4_opnum_in_range(argp, op)) {
+			op->opdesc = OPDESC(op);
 			op->status = nfsd4_dec_ops[op->opnum](argp, &op->u);
 			if (op->status != nfs_ok)
 				trace_nfsd_compound_decode_err(argp->rqstp,
@@ -2384,7 +2386,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
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



