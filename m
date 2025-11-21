Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984A42F360C;
	Fri, 21 Nov 2025 13:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731141; cv=none; b=O8ARDyMdAFqDnTNTU8SigXPuTb7ca6XY1iZ3/92+opdNpJOfiqTS3uzbVYg4xOXHJcFWZvqI2erZHGag8TSoN5VJf9XE/nOc8mV/seUWr9HHbVmFpjXn2i8YqDAPvbcQOwBZSNj3dnSnFtFzfO2lZcdcsuQGWTt/wgP9lroVYuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731141; c=relaxed/simple;
	bh=aNdjpDSM8AkEs1tKCqB7z+Y6NXfEAo3d4m97uUx3Ly4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKyWGfXn/exy2qnhXSWhb7GXmygP0+7c7bmqoUijciybIdpNF7wcPJBZquziyquP2VU/NsAIpsDm+BznIvBI1Zq2uY/aubhtIJ/XA/dyio7aBO0l9UaS8kTuMViDwJbh+13g6gJeqbIAPTDF258u3hDdcYYWD6auV71VT+s0rfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lk3+3Knl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lk3+3Knl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232F7C4CEF1;
	Fri, 21 Nov 2025 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731141;
	bh=aNdjpDSM8AkEs1tKCqB7z+Y6NXfEAo3d4m97uUx3Ly4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lk3+3KnlO+s322vpHP9g/79ETC+bMxsp4GL8TPezc9H6TJKw4zq2/xPtlS8Ows4A1
	 4r5GUQH/GskmAcZ5qeOlpV2zAlYeZw6LagcV+Ai2NlbVLDUAHi9seWyPSqyrNcZ4XR
	 lu2cVvewQ9Twqzwe08669NL3gxvR1WfqFavTvkyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 104/247] pnfs: Fix TLS logic in _nfs4_pnfs_v3_ds_connect()
Date: Fri, 21 Nov 2025 14:10:51 +0100
Message-ID: <20251121130158.320546345@linuxfoundation.org>
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

[ Upstream commit 7aca00d950e782e66c34fbd045c9605eca343a36 ]

Don't try to add an RDMA transport to a client that is already marked as
being a TCP/TLS transport.

Fixes: 04a15263662a ("pnfs/flexfiles: connect to NFSv3 DS using TLS if MDS connection uses TLS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs_nfs.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 7b32afb297827..ff48056bf750e 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -809,8 +809,11 @@ static int _nfs4_pnfs_v3_ds_connect(struct nfs_server *mds_srv,
 				 unsigned int retrans)
 {
 	struct nfs_client *clp = ERR_PTR(-EIO);
+	struct nfs_client *mds_clp = mds_srv->nfs_client;
+	enum xprtsec_policies xprtsec_policy = mds_clp->cl_xprtsec.policy;
 	struct nfs4_pnfs_ds_addr *da;
 	unsigned long connect_timeout = timeo * (retrans + 1) * HZ / 10;
+	int ds_proto;
 	int status = 0;
 
 	dprintk("--> %s DS %s\n", __func__, ds->ds_remotestr);
@@ -834,27 +837,28 @@ static int _nfs4_pnfs_v3_ds_connect(struct nfs_server *mds_srv,
 				.xprtsec = clp->cl_xprtsec,
 			};
 
-			if (da->da_transport != clp->cl_proto &&
-			    clp->cl_proto != XPRT_TRANSPORT_TCP_TLS)
-				continue;
-			if (da->da_transport == XPRT_TRANSPORT_TCP &&
-			    mds_srv->nfs_client->cl_proto == XPRT_TRANSPORT_TCP_TLS)
+			if (xprt_args.ident == XPRT_TRANSPORT_TCP &&
+			    clp->cl_proto == XPRT_TRANSPORT_TCP_TLS)
 				xprt_args.ident = XPRT_TRANSPORT_TCP_TLS;
 
-			if (da->da_addr.ss_family != clp->cl_addr.ss_family)
+			if (xprt_args.ident != clp->cl_proto)
+				continue;
+			if (xprt_args.dstaddr->sa_family !=
+			    clp->cl_addr.ss_family)
 				continue;
 			/* Add this address as an alias */
 			rpc_clnt_add_xprt(clp->cl_rpcclient, &xprt_args,
-					rpc_clnt_test_and_add_xprt, NULL);
+					  rpc_clnt_test_and_add_xprt, NULL);
 			continue;
 		}
-		if (da->da_transport == XPRT_TRANSPORT_TCP &&
-		    mds_srv->nfs_client->cl_proto == XPRT_TRANSPORT_TCP_TLS)
-			da->da_transport = XPRT_TRANSPORT_TCP_TLS;
-		clp = get_v3_ds_connect(mds_srv,
-				&da->da_addr,
-				da->da_addrlen, da->da_transport,
-				timeo, retrans);
+
+		ds_proto = da->da_transport;
+		if (ds_proto == XPRT_TRANSPORT_TCP &&
+		    xprtsec_policy != RPC_XPRTSEC_NONE)
+			ds_proto = XPRT_TRANSPORT_TCP_TLS;
+
+		clp = get_v3_ds_connect(mds_srv, &da->da_addr, da->da_addrlen,
+					ds_proto, timeo, retrans);
 		if (IS_ERR(clp))
 			continue;
 		clp->cl_rpcclient->cl_softerr = 0;
-- 
2.51.0



