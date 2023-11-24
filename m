Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E09C22F1D;
	Fri, 24 Nov 2023 18:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tplcu21H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DAFC433C7;
	Fri, 24 Nov 2023 18:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851848;
	bh=PANjxE2k8IudLThlALmK7JCH2erSFLg+6g+hvOk2M9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tplcu21HGId4WtbTWjz0jT7u8zIDpKRSHcJHNVLVgenFWDBG3XZ+QGewl9zGFH1wQ
	 KOIKGqFON90GsLsDRALsGtxpnKUX0NYRDwylzewjEE9JhkPScS2rWudfUWvfax2JZw
	 8Kz/iwArp6CRH3da2K4OeiGhCD+o1WaqcRPsoE4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/372] NFSv4.1: fix handling NFS4ERR_DELAY when testing for session trunking
Date: Fri, 24 Nov 2023 17:48:27 +0000
Message-ID: <20231124172014.483519726@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5cf53def987e5..4058861c72123 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8939,6 +8939,7 @@ void nfs4_test_session_trunk(struct rpc_clnt *clnt, struct rpc_xprt *xprt,
 
 	sp4_how = (adata->clp->cl_sp4_flags == 0 ? SP4_NONE : SP4_MACH_CRED);
 
+try_again:
 	/* Test connection for session trunking. Async exchange_id call */
 	task = nfs4_run_exchange_id(adata->clp, adata->cred, sp4_how, xprt);
 	if (IS_ERR(task))
@@ -8951,11 +8952,15 @@ void nfs4_test_session_trunk(struct rpc_clnt *clnt, struct rpc_xprt *xprt,
 
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



