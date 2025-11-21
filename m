Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3E51F09AC;
	Fri, 21 Nov 2025 13:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731147; cv=none; b=DBcUEh0FSyFO8YFHiEYEW0kVSWtaEA5hXqeL/z8Z9EQyDbiejSaaOvZqECZ3NQHG2zzyT7GVoVa8yexv65LwmxFEI96OaXOxyt4peHlzLlS/MDWVWEyuOU/p83qAelA/zBd44iwMSymsiANE9eVVVoiNaUPDayn6nwlGW5PJgIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731147; c=relaxed/simple;
	bh=LrYSoamEYVUMGPjRdxy1Gl+Z3g/0BciaFi6s9C1oriM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZLh6mJxxqjY6ez2vVM9ikXUMr5OwxZ4iDAtBGjJnxslLcBDUJhXGaFxhH55leVTFNE3NfqmuvyA1McZfGHCKUXPPh6fNH4m18GP02lZyzYVttKkLyZA0a8ehacazzE3mZuBH30m00N+krJzmWpKj54S3+fFnbe3QXcdQyEVA0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPAY3p6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPAY3p6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB9DC116C6;
	Fri, 21 Nov 2025 13:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731147;
	bh=LrYSoamEYVUMGPjRdxy1Gl+Z3g/0BciaFi6s9C1oriM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPAY3p6Dg/ebIAU7fzZ9XQQnnazfpJXJ+y6YWs9vc1l+RVZB68bkPHQiHa44H7aJD
	 +g3NjRcdKaoR/jdtlZL9U67SvWDk3ISYAOZ/Sa9Qw+xn+mPPP7V0HCRivCpm0U4mNB
	 Wy/XhlK6DKxtOezXdxBPXyZF0IZx3SfryFzUxE88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 106/247] pnfs: Set transport security policy to RPC_XPRTSEC_NONE unless using TLS
Date: Fri, 21 Nov 2025 14:10:53 +0100
Message-ID: <20251121130158.392319575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 8ab523ce78d4ca13add6b4ecbacff0f84c274603 ]

The default setting for the transport security policy must be
RPC_XPRTSEC_NONE, when using a TCP or RDMA connection without TLS.
Conversely, when using TLS, the security policy needs to be set.

Fixes: 6c0a8c5fcf71 ("NFS: Have struct nfs_client carry a TLS policy field")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs3client.c | 14 ++++++++++++--
 fs/nfs/nfs4client.c | 14 ++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs3client.c b/fs/nfs/nfs3client.c
index 0d7310c1ee0c0..5d97c1d38bb62 100644
--- a/fs/nfs/nfs3client.c
+++ b/fs/nfs/nfs3client.c
@@ -2,6 +2,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_mount.h>
 #include <linux/sunrpc/addr.h>
+#include <net/handshake.h>
 #include "internal.h"
 #include "nfs3_fs.h"
 #include "netns.h"
@@ -98,7 +99,11 @@ struct nfs_client *nfs3_set_ds_client(struct nfs_server *mds_srv,
 		.net = mds_clp->cl_net,
 		.timeparms = &ds_timeout,
 		.cred = mds_srv->cred,
-		.xprtsec = mds_clp->cl_xprtsec,
+		.xprtsec = {
+			.policy = RPC_XPRTSEC_NONE,
+			.cert_serial = TLS_NO_CERT,
+			.privkey_serial = TLS_NO_PRIVKEY,
+		},
 		.connect_timeout = connect_timeout,
 		.reconnect_timeout = connect_timeout,
 	};
@@ -111,9 +116,14 @@ struct nfs_client *nfs3_set_ds_client(struct nfs_server *mds_srv,
 	cl_init.hostname = buf;
 
 	switch (ds_proto) {
+	case XPRT_TRANSPORT_TCP_TLS:
+		if (mds_clp->cl_xprtsec.policy != RPC_XPRTSEC_NONE)
+			cl_init.xprtsec = mds_clp->cl_xprtsec;
+		else
+			ds_proto = XPRT_TRANSPORT_TCP;
+		fallthrough;
 	case XPRT_TRANSPORT_RDMA:
 	case XPRT_TRANSPORT_TCP:
-	case XPRT_TRANSPORT_TCP_TLS:
 		if (mds_clp->cl_nconnect > 1)
 			cl_init.nconnect = mds_clp->cl_nconnect;
 	}
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 5998d6bd8a4f4..3a4baed993c96 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -11,6 +11,7 @@
 #include <linux/sunrpc/xprt.h>
 #include <linux/sunrpc/bc_xprt.h>
 #include <linux/sunrpc/rpc_pipe_fs.h>
+#include <net/handshake.h>
 #include "internal.h"
 #include "callback.h"
 #include "delegation.h"
@@ -983,7 +984,11 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 		.net = mds_clp->cl_net,
 		.timeparms = &ds_timeout,
 		.cred = mds_srv->cred,
-		.xprtsec = mds_srv->nfs_client->cl_xprtsec,
+		.xprtsec = {
+			.policy = RPC_XPRTSEC_NONE,
+			.cert_serial = TLS_NO_CERT,
+			.privkey_serial = TLS_NO_PRIVKEY,
+		},
 	};
 	char buf[INET6_ADDRSTRLEN + 1];
 
@@ -992,9 +997,14 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 	cl_init.hostname = buf;
 
 	switch (ds_proto) {
+	case XPRT_TRANSPORT_TCP_TLS:
+		if (mds_srv->nfs_client->cl_xprtsec.policy != RPC_XPRTSEC_NONE)
+			cl_init.xprtsec = mds_srv->nfs_client->cl_xprtsec;
+		else
+			ds_proto = XPRT_TRANSPORT_TCP;
+		fallthrough;
 	case XPRT_TRANSPORT_RDMA:
 	case XPRT_TRANSPORT_TCP:
-	case XPRT_TRANSPORT_TCP_TLS:
 		if (mds_clp->cl_nconnect > 1) {
 			cl_init.nconnect = mds_clp->cl_nconnect;
 			cl_init.max_connect = NFS_MAX_TRANSPORTS;
-- 
2.51.0



