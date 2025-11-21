Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB334DB51;
	Fri, 21 Nov 2025 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733328; cv=none; b=YgxbWTWaNGj6YOifG1hNPor5GBsdwTgm7OMLgHJEssd2QapJpw+z3nWSpvsvndyMD/UETUkL5tFwgogp0bqTsB8Ncug/JZmPTXXVvUwbBEeSf+w4CKgDXPeOfqIk+oTER3M8TXBZ0xtnAmaiW4SRE1iy88gDtV7fKmJSmOajjU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733328; c=relaxed/simple;
	bh=0o7fcO/1TamWMDQGqCwFoz7b8mpoaRpsFMQpodj7Lr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qATN/MyIKDYBki1bppmM+8L+fgaZQoTMGWPFqsjSgjSDcnrp/Fz+al597pJxGQqonSH6QjIVdsGCO3933RR+4Spim9oAAnni4Z6KPrT1AdlpqBpJi+0ELEztRcA7PSSLHBijEAay+ac641zMGJeFgOR1qbTzOiIela2JwyXZQ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6w+IeSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6w+IeSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF560C4CEF1;
	Fri, 21 Nov 2025 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733327;
	bh=0o7fcO/1TamWMDQGqCwFoz7b8mpoaRpsFMQpodj7Lr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6w+IeSLJqJU1IPq9XKtpezfs3Q/EuRkVrPPqfOaeb7B5OdrlYSLh5ySa5Jx78hmn
	 GwrJtvlWtc9NynccVVZymtZdeSnRIYex2gDsxwNrTMxrAMJBO1JnTPlnMT6y/wRSBW
	 LhJibzDcAmazpXxiMTd1Z9uSWvSLHvWfKtJCatMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 431/529] NFS: enable nconnect for RDMA
Date: Fri, 21 Nov 2025 14:12:10 +0100
Message-ID: <20251121130246.350998441@linuxfoundation.org>
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

[ Upstream commit b326df4a8ec6ef53e2e2f1c2cbf14f8a20e85baa ]

It appears that in certain cases, RDMA capable transports can benefit
from the ability to establish multiple connections to increase their
throughput. This patch therefore enables the use of the "nconnect" mount
option for those use cases.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 8ab523ce78d4 ("pnfs: Set transport security policy to RPC_XPRTSEC_NONE unless using TLS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs3client.c | 1 +
 fs/nfs/nfs4client.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/nfs/nfs3client.c b/fs/nfs/nfs3client.c
index 674c012868b1a..b0c8a39c2bbde 100644
--- a/fs/nfs/nfs3client.c
+++ b/fs/nfs/nfs3client.c
@@ -111,6 +111,7 @@ struct nfs_client *nfs3_set_ds_client(struct nfs_server *mds_srv,
 	cl_init.hostname = buf;
 
 	switch (ds_proto) {
+	case XPRT_TRANSPORT_RDMA:
 	case XPRT_TRANSPORT_TCP:
 	case XPRT_TRANSPORT_TCP_TLS:
 		if (mds_clp->cl_nconnect > 1)
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 32b1147fcafc4..aaf723471228b 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -924,6 +924,7 @@ static int nfs4_set_client(struct nfs_server *server,
 	else
 		cl_init.max_connect = max_connect;
 	switch (proto) {
+	case XPRT_TRANSPORT_RDMA:
 	case XPRT_TRANSPORT_TCP:
 	case XPRT_TRANSPORT_TCP_TLS:
 		cl_init.nconnect = nconnect;
@@ -1000,6 +1001,7 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 	cl_init.hostname = buf;
 
 	switch (ds_proto) {
+	case XPRT_TRANSPORT_RDMA:
 	case XPRT_TRANSPORT_TCP:
 	case XPRT_TRANSPORT_TCP_TLS:
 		if (mds_clp->cl_nconnect > 1) {
-- 
2.51.0



