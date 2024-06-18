Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F7D16EB75;
	Tue, 18 Jun 2024 12:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715414; cv=none; b=miXk0Sr8d2sM1LyVAg14ZuBM6k0dtBVj7JDr+UPn/1RlDAzcGXTBBILDqUe+MIHVAqk3wVvIk5VSRHeOorIO5r4Df8CkFvj3CCviBFzeAr5xi1upzE0CqAx9xwnCsBup9QZJPGeA5v2CwUPVTQssddZD6MWPC6wCRWJ5U7eyK0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715414; c=relaxed/simple;
	bh=alatCwcaSXaLdIp1c994IfB8k64a3AFrv7udli1UIVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSxrl0cfZTRlP3uFai3mzA1SJqPJhtzlMUdJIc1X/tfMLzhQVJjV7yl58v9SYyTyvLEWlgGLcs28PMzsd9cO4npQcQVWVYNhK4nrkHG/GsgsAHehdAgbiCqGPowApXke8RXPTym+oqfbLZKCfak8Z1v2dRCG/2bM/yG6vQ87Uc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNslvQxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNslvQxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8621CC3277B;
	Tue, 18 Jun 2024 12:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715413;
	bh=alatCwcaSXaLdIp1c994IfB8k64a3AFrv7udli1UIVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNslvQxCd9POhQDp79cmxcrB5cA191whf4WCVSJsBRJiOy3jTiuiS12BLLFGdEPvK
	 WPjkiN28KsiHxP9ZqhzUvvXUL05cbxRinCinpPl1gAkszlvYkzjY8b9E0yH5caeHug
	 rvwr7uW88ccDaa/mzOnPO8cm+wom7W0p/aXNEAgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/770] lockd: Create a simplified .vs_dispatch method for NLM requests
Date: Tue, 18 Jun 2024 14:32:33 +0200
Message-ID: <20240618123418.844022133@linuxfoundation.org>
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

[ Upstream commit a9ad1a8090f58b2ed1774dd0f4c7cdb8210a3793 ]

To enable xdr_stream-based encoding and decoding, create a bespoke
RPC dispatch function for the lockd service.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 1a639e34847dd..2de048f80eb8c 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -766,6 +766,46 @@ static void __exit exit_nlm(void)
 module_init(init_nlm);
 module_exit(exit_nlm);
 
+/**
+ * nlmsvc_dispatch - Process an NLM Request
+ * @rqstp: incoming request
+ * @statp: pointer to location of accept_stat field in RPC Reply buffer
+ *
+ * Return values:
+ *  %0: Processing complete; do not send a Reply
+ *  %1: Processing complete; send Reply in rqstp->rq_res
+ */
+static int nlmsvc_dispatch(struct svc_rqst *rqstp, __be32 *statp)
+{
+	const struct svc_procedure *procp = rqstp->rq_procinfo;
+	struct kvec *argv = rqstp->rq_arg.head;
+	struct kvec *resv = rqstp->rq_res.head;
+
+	svcxdr_init_decode(rqstp);
+	if (!procp->pc_decode(rqstp, argv->iov_base))
+		goto out_decode_err;
+
+	*statp = procp->pc_func(rqstp);
+	if (*statp == rpc_drop_reply)
+		return 0;
+	if (*statp != rpc_success)
+		return 1;
+
+	svcxdr_init_encode(rqstp);
+	if (!procp->pc_encode(rqstp, resv->iov_base + resv->iov_len))
+		goto out_encode_err;
+
+	return 1;
+
+out_decode_err:
+	*statp = rpc_garbage_args;
+	return 1;
+
+out_encode_err:
+	*statp = rpc_system_err;
+	return 1;
+}
+
 /*
  * Define NLM program and procedures
  */
@@ -775,6 +815,7 @@ static const struct svc_version	nlmsvc_version1 = {
 	.vs_nproc	= 17,
 	.vs_proc	= nlmsvc_procedures,
 	.vs_count	= nlmsvc_version1_count,
+	.vs_dispatch	= nlmsvc_dispatch,
 	.vs_xdrsize	= NLMSVC_XDRSIZE,
 };
 static unsigned int nlmsvc_version3_count[24];
@@ -783,6 +824,7 @@ static const struct svc_version	nlmsvc_version3 = {
 	.vs_nproc	= 24,
 	.vs_proc	= nlmsvc_procedures,
 	.vs_count	= nlmsvc_version3_count,
+	.vs_dispatch	= nlmsvc_dispatch,
 	.vs_xdrsize	= NLMSVC_XDRSIZE,
 };
 #ifdef CONFIG_LOCKD_V4
@@ -792,6 +834,7 @@ static const struct svc_version	nlmsvc_version4 = {
 	.vs_nproc	= 24,
 	.vs_proc	= nlmsvc_procedures4,
 	.vs_count	= nlmsvc_version4_count,
+	.vs_dispatch	= nlmsvc_dispatch,
 	.vs_xdrsize	= NLMSVC_XDRSIZE,
 };
 #endif
-- 
2.43.0



