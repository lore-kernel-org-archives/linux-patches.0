Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E731D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F3EC433C7;
	Wed,  4 Oct 2023 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442565;
	bh=7yTNt4dZE663W7yv7eGyMmkOshG0cwLRV1QxWOS8ZXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfcDsz7MJM/4lWlL96hkyskMTiWlyvi70t+lzL9fz1yGTkZ2Ua1x6ckImKOcIjlS4
	 quAcXJK2nRmmBfjiJDCTE9mhQwdmUH/kpGqmbN+JzJPaipM3PvJ2JV29O+cuJKpVD3
	 ZOivFnuk6tq3mYH+yS9LeCpqo2PX8X8ARqhnzYk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/183] NFSv4.1: use EXCHGID4_FLAG_USE_PNFS_DS for DS server
Date: Wed,  4 Oct 2023 19:53:56 +0200
Message-ID: <20231004175204.205602527@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 51d674a5e4889f1c8e223ac131cf218e1631e423 ]

After receiving the location(s) of the DS server(s) in the
GETDEVINCEINFO, create the request for the clientid to such
server and indicate that the client is connecting to a DS.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: 806a3bc421a1 ("NFSv4.1: fix pnfs MDS=DS session trunking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 3 +++
 fs/nfs/nfs4proc.c   | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 1bf7a72ebda6e..81cda46d5829d 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -231,6 +231,8 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
 	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
 
+	if (test_bit(NFS_CS_DS, &cl_init->init_flags))
+		__set_bit(NFS_CS_DS, &clp->cl_flags);
 	/*
 	 * Set up the connection to the server before we add add to the
 	 * global list.
@@ -993,6 +995,7 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 	if (mds_srv->flags & NFS_MOUNT_NORESVPORT)
 		__set_bit(NFS_CS_NORESVPORT, &cl_init.init_flags);
 
+	__set_bit(NFS_CS_DS, &cl_init.init_flags);
 	/*
 	 * Set an authflavor equual to the MDS value. Use the MDS nfs_client
 	 * cl_ipaddr so as to use the same EXCHANGE_ID co_ownerid as the MDS
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a21e25cbd4515..32204c0b3d098 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8715,6 +8715,8 @@ nfs4_run_exchange_id(struct nfs_client *clp, const struct cred *cred,
 #ifdef CONFIG_NFS_V4_1_MIGRATION
 	calldata->args.flags |= EXCHGID4_FLAG_SUPP_MOVED_MIGR;
 #endif
+	if (test_bit(NFS_CS_DS, &clp->cl_flags))
+		calldata->args.flags |= EXCHGID4_FLAG_USE_PNFS_DS;
 	msg.rpc_argp = &calldata->args;
 	msg.rpc_resp = &calldata->res;
 	task_setup_data.callback_data = calldata;
@@ -8792,6 +8794,8 @@ static int _nfs4_proc_exchange_id(struct nfs_client *clp, const struct cred *cre
 	/* Save the EXCHANGE_ID verifier session trunk tests */
 	memcpy(clp->cl_confirm.data, argp->verifier.data,
 	       sizeof(clp->cl_confirm.data));
+	if (resp->flags & EXCHGID4_FLAG_USE_PNFS_DS)
+		set_bit(NFS_CS_DS, &clp->cl_flags);
 out:
 	trace_nfs4_exchange_id(clp, status);
 	rpc_put_task(task);
-- 
2.40.1



