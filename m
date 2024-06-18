Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43B813D8BC;
	Tue, 18 Jun 2024 13:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716296; cv=none; b=bWK8+Tgfa/4aA7E5tdS3m2n4Sg1k1cJVMwJcjSU31gvFOPmLIsndGjwQD7XY0Rq+9qqnZXTcBh0y5GYYzvDP/bA/yYrNpQduiM8Ajbqxw/kNxjBUOc1QUNVA4dWVhP2jPKYeOAf4ssTBBV7VXtbswSkGaYoz1tqliPIm4QHiY3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716296; c=relaxed/simple;
	bh=LejHuANvxhhtjusRXlAadk4q/rEBNTwzURscRi0ZFyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kw3FbNsuu6tKD0MlcM/bURHUxBYF0T/Ao2mfbwo04R0dC4Yc57F6BkC3XGz4h7+B9BiFXHy7WgfcD/SwVgavGsYWPWlBjKMMuJywGHs1hhvjnjyuowVdZXMW9eGkP3ctmI+tHZb9XCy8ghiNtgzMHB/tFoCqX1tLQQaAX9vdH8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N54lD09Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N54lD09Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAD2C3277B;
	Tue, 18 Jun 2024 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716296;
	bh=LejHuANvxhhtjusRXlAadk4q/rEBNTwzURscRi0ZFyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N54lD09ZYJWzlEIvRMDibxR4bu0WyGoT8mRsM5CAxy8v7muEXn+YUqxEppoHPm71/
	 mofxAAqyHZOZfyKXlu0wPizOjLaNmPZL8RFkT1BqTcRrBvToHGVK1AQEjpPey4TnMa
	 6FEnjyHbO5wiFDsG2TIMhdQqz8MTlBXp+MwDOZds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 599/770] NFSD: Shrink size of struct nfsd4_copy_notify
Date: Tue, 18 Jun 2024 14:37:32 +0200
Message-ID: <20240618123430.413416887@linuxfoundation.org>
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

[ Upstream commit 09426ef2a64ee189ca1e3298f1e874842dbf35ea ]

struct nfsd4_copy_notify is part of struct nfsd4_op, which resides
in an 8-element array.

sizeof(struct nfsd4_op):
Before: /* size: 2208, cachelines: 35, members: 5 */
After:  /* size: 1696, cachelines: 27, members: 5 */

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c |  4 ++--
 fs/nfsd/nfs4xdr.c  | 12 ++++++++++--
 fs/nfsd/xdr4.h     |  4 ++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 1b49b4e2803c7..3ed9c36bc4078 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1945,9 +1945,9 @@ nfsd4_copy_notify(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	/* For now, only return one server address in cpn_src, the
 	 * address used by the client to connect to this server.
 	 */
-	cn->cpn_src.nl4_type = NL4_NETADDR;
+	cn->cpn_src->nl4_type = NL4_NETADDR;
 	status = nfsd4_set_netaddr((struct sockaddr *)&rqstp->rq_daddr,
-				 &cn->cpn_src.u.nl4_addr);
+				 &cn->cpn_src->u.nl4_addr);
 	WARN_ON_ONCE(status);
 	if (status) {
 		nfs4_put_cpntf_state(nn, cps);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index fcf56e396e66b..537c358fec98c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1952,10 +1952,17 @@ nfsd4_decode_copy_notify(struct nfsd4_compoundargs *argp,
 {
 	__be32 status;
 
+	cn->cpn_src = svcxdr_tmpalloc(argp, sizeof(*cn->cpn_src));
+	if (cn->cpn_src == NULL)
+		return nfserr_jukebox;
+	cn->cpn_dst = svcxdr_tmpalloc(argp, sizeof(*cn->cpn_dst));
+	if (cn->cpn_dst == NULL)
+		return nfserr_jukebox;
+
 	status = nfsd4_decode_stateid4(argp, &cn->cpn_src_stateid);
 	if (status)
 		return status;
-	return nfsd4_decode_nl4_server(argp, &cn->cpn_dst);
+	return nfsd4_decode_nl4_server(argp, cn->cpn_dst);
 }
 
 static __be32
@@ -4906,7 +4913,8 @@ nfsd4_encode_copy_notify(struct nfsd4_compoundres *resp, __be32 nfserr,
 
 	*p++ = cpu_to_be32(1);
 
-	return nfsd42_encode_nl4_server(resp, &cn->cpn_src);
+	nfserr = nfsd42_encode_nl4_server(resp, cn->cpn_src);
+	return nfserr;
 }
 
 static __be32
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 32617639a3ece..27f9300fadbe0 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -595,13 +595,13 @@ struct nfsd4_offload_status {
 struct nfsd4_copy_notify {
 	/* request */
 	stateid_t		cpn_src_stateid;
-	struct nl4_server	cpn_dst;
+	struct nl4_server	*cpn_dst;
 
 	/* response */
 	stateid_t		cpn_cnr_stateid;
 	u64			cpn_sec;
 	u32			cpn_nsec;
-	struct nl4_server	cpn_src;
+	struct nl4_server	*cpn_src;
 };
 
 struct nfsd4_op {
-- 
2.43.0



