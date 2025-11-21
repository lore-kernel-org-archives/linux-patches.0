Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D39834DB51;
	Fri, 21 Nov 2025 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733330; cv=none; b=rpAsSfQUFiGTZsE7wsZvR4JboEtbvaOvMVCpqP9uNAlR1/DPvH6WlAYN6mXnrXkGnc1huZTRA/g55B6c6mHfBqn4rx9KUWhUCWi9H2GlFtU4nBBZTgRBejyNDd8/So29phAFrYFcPj8v5Ooq0R1zPT68RUtf7K1fUGfgm2kbeII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733330; c=relaxed/simple;
	bh=3urgKYE/KOUiYTn2C9zROCzEdQYy65HiVLnXn3mSUbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTO7KNwUX2MBiqgdZFsfaOTLLjZArlqlHKbjE0WU3iwiiUH9Pvb8XMmMS6oyT7EEALIRQyR4ZBQPS+WeZXvPBtCskfaJOZsKlcchTFW1k/mXCVkuWzMSSuGDoi2zuKCKZqdYF3P3Ml3bXHv0LdZzoulfrmwu/HUDoSi2eIkRLEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jO21tBoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jO21tBoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79707C4CEF1;
	Fri, 21 Nov 2025 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733329;
	bh=3urgKYE/KOUiYTn2C9zROCzEdQYy65HiVLnXn3mSUbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jO21tBoeEmHi4tn7cooq5RfYAT3BKS1pNQHaQCdvQB8vbSNX+KRCyt7zNjIsMtn5j
	 w+f+cqmdiYAH5D95I+qFjNUnAOYWBNgo0EGC278P8l5toiibUyABQPvw3v2B4en/69
	 kiaPtjzh/Y5sdPO0jeh3q4dEckmGaPjJT0NjniA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 432/529] pnfs: Set transport security policy to RPC_XPRTSEC_NONE unless using TLS
Date: Fri, 21 Nov 2025 14:12:11 +0100
Message-ID: <20251121130246.386137864@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b0c8a39c2bbde..1aa4c43c9b3b4 100644
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
index aaf723471228b..b14688da814d6 100644
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
@@ -992,7 +993,11 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
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
 
@@ -1001,9 +1006,14 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
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



