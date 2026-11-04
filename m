Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829066;
	b=cTKMSYQm9okC/f69oYDRoAkddLnR8k2HagMMraMAXVKOBXhrM8hIe/uQlFpYn1i2s8gK
	 mHwgKvV+lzj1SBGVnhQhQNdkrt4OfHnn6q9Wzl7z9i1H6FDmV5xV5OPmPk99i4FKy3mKb
	 UV7TWfpJ50onZSLk4lBnvO8eRu4KFOOL7+d7zbPJ9iqT/RppeeToememSp8eLMKDr8sY5
	 WkC9RSA618b29bsomPpTd5CQAit2CVBphYR15aV4Ds6QmDitC4q7S24gPwH1BnbMdCBox
	 QS95GiSQ38T5Ur94r+KZic3AkAQlkrQ07fl1pHhiHwHcv4mGya6Ue0cAWgKKQTRyaMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G0Euo1K6jLT1SQCgT4ccTrRPTq5JkHFYWKypagy7X48=;
	b=H28AvtDRLd2MJwiXkqaIVOcyV0AXfoWR6VrKATb4Y6pXjJzJb7/nyj3Z0w3KhRkumnsT
	 53eeqZpC7XRd5OmiIBtSJIV1ci6fULRuX6++sL725GtklvUoFYczBBWDpbHLLT28ZU6ZO
	 1rMVhbmOdJXxTkaDTELKhVv/2Hg61172PFIylG0jiwx8YxRwPZVWP+G0+yMul+nH3fbj7
	 6qTNY2pLFn3gFgNtnxU7cL2dzXVJhr6aA8iua1SUxl4wyTV3c1ECZpFLFa4roFINtX1ot
	 2UCBIPo0PkTHt6GQFs+Mdgv/iOg1Kyn82RpFoWHCFl4wIuEswgtH0bxkgdS+GsQ1ZlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yIeII3jN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B3608209F;
	Wed,  4 Nov 2026 21:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yIeII3jN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5400C1F00A02;
	Wed,  4 Nov 2026 21:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829065;
	bh=G0Euo1K6jLT1SQCgT4ccTrRPTq5JkHFYWKypagy7X48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIeII3jN9n31007SMyqw7mtxy183McmB9hE3B2mAev+yVGViwMaToLxFk51odAdPq
	 X/HymBOITf05UPdsBGYfEwsa6K3CLCF8vaRZBtbmUXEA8HKZVVDb+6UItR8BxaFT/e
	 AEaK4MzjBFmrRbyoou6kcxFLdAgQm7hBg5wLQ+4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 421/547] NFSD: Fix out-of-bounds read in the rpc_status dump
Date: Wed,  4 Nov 2026 16:10:05 -0500
Message-ID: <20261104211050.296045699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit cbea14890783fead76f878caf0775a62a42049bf upstream.

nfsd_nl_rpc_status_get_dumpit() loads args->opcnt and
args->ops separately, then walks ops[] before rechecking
rq_status_counter. A COMPOUND that completes between the two loads
runs nfsd4_release_compoundargs(), which zeroes opcnt and points ops
back at the eight-entry inline array. A dump that already sampled an
opcnt of 200 clamps it to the sixteen slots in rq_opnum, then indexes
iops[0..15]. iops is the last member of struct nfsd4_compoundargs and
rq_argp is allocated at exactly that size, so the walk runs off the
end of the allocation. The trailing recheck discards the sampled data,
but the read has already happened. NFSD_CMD_RPC_STATUS_GET carries
no GENL_ADMIN_PERM, so an unprivileged local user can repeat the dump
against a busy server until it lands in the window.

Sample opcnt and ops into locals, then finish the counter recheck
before dereferencing ops. An unchanged counter means both came from the
same COMPOUND, where opcnt cannot exceed what ops holds.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Reported-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Closes: https://lore.kernel.org/linux-nfs/20260823113255.3417-1-prabhakar.pujeri@dell.com/
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260824-nfsd-posix-acl-ownership-v1-1-090fffc608ec@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1585,14 +1585,29 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 			    rqstp->rq_proc == NFSPROC4_COMPOUND) {
 				/* NFSv4 compound */
 				struct nfsd4_compoundargs *args;
+				struct nfsd4_op *ops;
+				u32 opcnt;
 				int j;
 
 				args = rqstp->rq_argp;
-				genl_rqstp.rq_opcnt = min_t(u32, args->opcnt,
+				opcnt = READ_ONCE(args->opcnt);
+				ops = READ_ONCE(args->ops);
+
+				/*
+				 * Finish the seqcount retry before
+				 * dereferencing ops. An unchanged counter means
+				 * opcnt and ops came from the same COMPOUND,
+				 * where opcnt cannot exceed what ops holds.
+				 */
+				smp_rmb();
+				if (READ_ONCE(rqstp->rq_status_counter) !=
+				    status_counter)
+					continue;
+
+				genl_rqstp.rq_opcnt = min_t(u32, opcnt,
 							    ARRAY_SIZE(genl_rqstp.rq_opnum));
 				for (j = 0; j < genl_rqstp.rq_opcnt; j++)
-					genl_rqstp.rq_opnum[j] =
-						args->ops[j].opnum;
+					genl_rqstp.rq_opnum[j] = ops[j].opnum;
 			}
 #endif /* CONFIG_NFSD_V4 */
 


