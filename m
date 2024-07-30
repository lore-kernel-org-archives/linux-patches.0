Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F3D1A616E;
	Tue, 30 Jul 2024 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356246; cv=none; b=E+PepOLMBTXoSOUU7XEQqsE+kLGV2YloeC0/ZuWk1GeZN3y9KuOOJoNCnhr9eV9sIu4yRXy9cIg9PWaRt6FylNiriDRHiP9EHAAWlO6x+0MhFej0W9DhR/rdV0r5sQohIc+pt5wgqaorxNEA/hb2X11uxKTcU0L67Fsf7DeoT/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356246; c=relaxed/simple;
	bh=fWPg1TwJyz74PT776KJkXab0fOmgooMnBd8u6XhvF8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lC3PSDfNX2AsURX8qUKBbtbUC/sUsPyeRK1nrnuafOzuJyHqeMz1RNKgjnFNc9q0TSasMsJ+PWj4FtVyLyfQV+QgsDoLGfwZyRoxu6uNcyITNfXxDklOdRWfST9SfZjKrEso0NTM19ISIszNDalWQ57JpTgNGeYCm089AxlYpLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDN/p2aV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDN/p2aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73530C32782;
	Tue, 30 Jul 2024 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356245;
	bh=fWPg1TwJyz74PT776KJkXab0fOmgooMnBd8u6XhvF8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDN/p2aVKGxzoCn2ujkhJqYlJgvW5YjOOiu/SVoC135S8JPzlMKS/nIEs9saLQ4UZ
	 DzlCbkFylkaFy59aqvvFBCpMGmG8hRYJPlWHeu5apki4NX3VNBQXYFxvclMy7Cyv0J
	 HeY63c9F/9ylmXSnTjw2MU+a9WcC1biSSOrkr4aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/440] NFSv4.1 another fix for EXCHGID4_FLAG_USE_PNFS_DS for DS server
Date: Tue, 30 Jul 2024 17:46:45 +0200
Message-ID: <20240730151622.591256512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

[ Upstream commit 4840c00003a2275668a13b82c9f5b1aed80183aa ]

Previously in order to mark the communication with the DS server,
we tried to use NFS_CS_DS in cl_flags. However, this flag would
only be saved for the DS server and in case where DS equals MDS,
the client would not find a matching nfs_client in nfs_match_client
that represents the MDS (but is also a DS).

Instead, don't rely on the NFS_CS_DS but instead use NFS_CS_PNFS.

Fixes: 379e4adfddd6 ("NFSv4.1: fixup use EXCHGID4_FLAG_USE_PNFS_DS for DS server")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4client.c | 6 ++----
 fs/nfs/nfs4proc.c   | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 84b345efcec00..02caeec2c1739 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -230,9 +230,8 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
 	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
 	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
-
-	if (test_bit(NFS_CS_DS, &cl_init->init_flags))
-		__set_bit(NFS_CS_DS, &clp->cl_flags);
+	if (test_bit(NFS_CS_PNFS, &cl_init->init_flags))
+		__set_bit(NFS_CS_PNFS, &clp->cl_flags);
 	/*
 	 * Set up the connection to the server before we add add to the
 	 * global list.
@@ -997,7 +996,6 @@ struct nfs_client *nfs4_set_ds_client(struct nfs_server *mds_srv,
 	if (mds_srv->flags & NFS_MOUNT_NORESVPORT)
 		__set_bit(NFS_CS_NORESVPORT, &cl_init.init_flags);
 
-	__set_bit(NFS_CS_DS, &cl_init.init_flags);
 	__set_bit(NFS_CS_PNFS, &cl_init.init_flags);
 	cl_init.max_connect = NFS_MAX_TRANSPORTS;
 	/*
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index cc620fc7aaf7b..467e9439ededb 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8821,7 +8821,7 @@ nfs4_run_exchange_id(struct nfs_client *clp, const struct cred *cred,
 #ifdef CONFIG_NFS_V4_1_MIGRATION
 	calldata->args.flags |= EXCHGID4_FLAG_SUPP_MOVED_MIGR;
 #endif
-	if (test_bit(NFS_CS_DS, &clp->cl_flags))
+	if (test_bit(NFS_CS_PNFS, &clp->cl_flags))
 		calldata->args.flags |= EXCHGID4_FLAG_USE_PNFS_DS;
 	msg.rpc_argp = &calldata->args;
 	msg.rpc_resp = &calldata->res;
-- 
2.43.0



