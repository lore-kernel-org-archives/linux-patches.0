Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7637A3A8F3;
	Fri, 24 Nov 2023 18:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHCXpRA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01648C433C8;
	Fri, 24 Nov 2023 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850716;
	bh=96qB7PTLTrohUNYPqxIIZAl4KQWNCvaZ4OPO9hKGWfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHCXpRA67KTvFtDe1NA4w4noRPb8VEerEYMuUFW5ZdK9zZ/n59koKyzltq6D9CVia
	 G4q/4TXue718uL3KlnVnQSFymYNIcB7K24uk6eBnBo7bPIKQvCKvrheYY+m7a2mCB7
	 AEor0dFxxnPmZhfPM589JSukj6oemy36puaXD6CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 160/491] NFSv4.1: fix handling NFS4ERR_DELAY when testing for session trunking
Date: Fri, 24 Nov 2023 17:46:36 +0000
Message-ID: <20231124172029.285502438@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 6bd1a77dc72dea0b0d8b6014f231143984d18f6d ]

Currently when client sends an EXCHANGE_ID for a possible trunked
connection, for any error that happened, the trunk will be thrown
out. However, an NFS4ERR_DELAY is a transient error that should be
retried instead.

Fixes: e818bd085baf ("NFSv4.1 remove xprt from xprt_switch if session trunking test fails")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5f088e3eeca1d..c710fde58be11 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8934,6 +8934,7 @@ void nfs4_test_session_trunk(struct rpc_clnt *clnt, struct rpc_xprt *xprt,
 
 	sp4_how = (adata->clp->cl_sp4_flags == 0 ? SP4_NONE : SP4_MACH_CRED);
 
+try_again:
 	/* Test connection for session trunking. Async exchange_id call */
 	task = nfs4_run_exchange_id(adata->clp, adata->cred, sp4_how, xprt);
 	if (IS_ERR(task))
@@ -8946,11 +8947,15 @@ void nfs4_test_session_trunk(struct rpc_clnt *clnt, struct rpc_xprt *xprt,
 
 	if (status == 0)
 		rpc_clnt_xprt_switch_add_xprt(clnt, xprt);
-	else if (rpc_clnt_xprt_switch_has_addr(clnt,
+	else if (status != -NFS4ERR_DELAY && rpc_clnt_xprt_switch_has_addr(clnt,
 				(struct sockaddr *)&xprt->addr))
 		rpc_clnt_xprt_switch_remove_xprt(clnt, xprt);
 
 	rpc_put_task(task);
+	if (status == -NFS4ERR_DELAY) {
+		ssleep(1);
+		goto try_again;
+	}
 }
 EXPORT_SYMBOL_GPL(nfs4_test_session_trunk);
 
-- 
2.42.0



