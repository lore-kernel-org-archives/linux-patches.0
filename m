Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321C2346E72;
	Fri, 21 Nov 2025 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733325; cv=none; b=fxGW9Js79sRjAF8ahC0s7mb5UAdqBK5RC5TdzpwzeeK40s/Px+Lb8N/D7dab1Af8sc9uo8368LCiM5uwiHKEkdzGL79SxOCkmXGZ7yrQfkMJEZzqCXc0C561ZGmr2HyFdy2VEGsEZ5i6i255zLqLdGA/B1OqOAjMbHP3RlNSUGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733325; c=relaxed/simple;
	bh=eI/rFC4hWxVLjKnW//pCD+lv+EpaFI8VuMik0vmmecg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDXan2gqtxm/C+t83wiNCP6Lv/QnO8Tzmf1KpjSH+X1+GlaZYHT1wI2au97VYGbntf8TU0J3lErTr/+4xhFXN2Bea6LPB27ETYTzV3sQMhMDdA48BHSt585VMqCcO9GSnODqJtGwipCEc8WIpeVvd2N4jMOSsVEB9+BO59r4hqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zfo8KZUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zfo8KZUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6EFC4CEF1;
	Fri, 21 Nov 2025 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733324;
	bh=eI/rFC4hWxVLjKnW//pCD+lv+EpaFI8VuMik0vmmecg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfo8KZUXM9shxkfJhPGr1qQwXlyIg0VnB2zkZ8g14Ablc4QjCZakvXU+JWfIikDo9
	 FeqDIt6u9oGI8UyYBlO+H+cff8mUvvIZO4fb0BdZplzpKcOhDh+d33YTJJDDPC/u1Z
	 NyNODXwsL6sy58wD8wrQ8Esq5FbUOwHXFyUtcPyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 430/529] pnfs: Fix TLS logic in _nfs4_pnfs_v4_ds_connect()
Date: Fri, 21 Nov 2025 14:12:09 +0100
Message-ID: <20251121130246.315521298@linuxfoundation.org>
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

[ Upstream commit 28e19737e1570c7c71890547c2e43c3e0da79df9 ]

Don't try to add an RDMA transport to a client that is already marked as
being a TCP/TLS transport.

Fixes: a35518cae4b3 ("NFSv4.1/pnfs: fix NFS with TLS in pnfs")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs_nfs.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 1b317c44da126..5314dabb725d8 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -914,7 +914,10 @@ static int _nfs4_pnfs_v4_ds_connect(struct nfs_server *mds_srv,
 				 u32 minor_version)
 {
 	struct nfs_client *clp = ERR_PTR(-EIO);
+	struct nfs_client *mds_clp = mds_srv->nfs_client;
+	enum xprtsec_policies xprtsec_policy = mds_clp->cl_xprtsec.policy;
 	struct nfs4_pnfs_ds_addr *da;
+	int ds_proto;
 	int status = 0;
 
 	dprintk("--> %s DS %s\n", __func__, ds->ds_remotestr);
@@ -942,12 +945,8 @@ static int _nfs4_pnfs_v4_ds_connect(struct nfs_server *mds_srv,
 				.data = &xprtdata,
 			};
 
-			if (da->da_transport != clp->cl_proto &&
-					clp->cl_proto != XPRT_TRANSPORT_TCP_TLS)
-				continue;
-			if (da->da_transport == XPRT_TRANSPORT_TCP &&
-				mds_srv->nfs_client->cl_proto ==
-					XPRT_TRANSPORT_TCP_TLS) {
+			if (xprt_args.ident == XPRT_TRANSPORT_TCP &&
+			    clp->cl_proto == XPRT_TRANSPORT_TCP_TLS) {
 				struct sockaddr *addr =
 					(struct sockaddr *)&da->da_addr;
 				struct sockaddr_in *sin =
@@ -978,7 +977,10 @@ static int _nfs4_pnfs_v4_ds_connect(struct nfs_server *mds_srv,
 				xprt_args.ident = XPRT_TRANSPORT_TCP_TLS;
 				xprt_args.servername = servername;
 			}
-			if (da->da_addr.ss_family != clp->cl_addr.ss_family)
+			if (xprt_args.ident != clp->cl_proto)
+				continue;
+			if (xprt_args.dstaddr->sa_family !=
+			    clp->cl_addr.ss_family)
 				continue;
 
 			/**
@@ -992,15 +994,14 @@ static int _nfs4_pnfs_v4_ds_connect(struct nfs_server *mds_srv,
 			if (xprtdata.cred)
 				put_cred(xprtdata.cred);
 		} else {
-			if (da->da_transport == XPRT_TRANSPORT_TCP &&
-				mds_srv->nfs_client->cl_proto ==
-					XPRT_TRANSPORT_TCP_TLS)
-				da->da_transport = XPRT_TRANSPORT_TCP_TLS;
-			clp = nfs4_set_ds_client(mds_srv,
-						&da->da_addr,
-						da->da_addrlen,
-						da->da_transport, timeo,
-						retrans, minor_version);
+			ds_proto = da->da_transport;
+			if (ds_proto == XPRT_TRANSPORT_TCP &&
+			    xprtsec_policy != RPC_XPRTSEC_NONE)
+				ds_proto = XPRT_TRANSPORT_TCP_TLS;
+
+			clp = nfs4_set_ds_client(mds_srv, &da->da_addr,
+						 da->da_addrlen, ds_proto,
+						 timeo, retrans, minor_version);
 			if (IS_ERR(clp))
 				continue;
 
@@ -1011,7 +1012,6 @@ static int _nfs4_pnfs_v4_ds_connect(struct nfs_server *mds_srv,
 				clp = ERR_PTR(-EIO);
 				continue;
 			}
-
 		}
 	}
 
-- 
2.51.0



