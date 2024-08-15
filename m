Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177571714A8;
	Thu, 15 Aug 2024 13:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729491; cv=none; b=WT1oqxVReYZ3rv/5Qa4FDO71g8Hmr6gKEkOg1HvsPuxs8l0QNt+oyqYqMKA3CYQ15n6rxWld5YNw8KevH2K/toen/D4l81jGMknOnppjSwfC6b1deoLattP1D3LJDkxPxLu/752ozNTdSVh5PaGTP2a+A9QzSSkWC42k0CZiZmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729491; c=relaxed/simple;
	bh=P3wtNF+zq4tzjACUmV5BqchuesjPbIWd9YzSD7EwPrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdYoYHi7kQ0LvQIRQcTclPs2SjqDXqgCntQITMqEDb/iu3SoN6K7TAdbi+fVtL615yhUbjf3q/UTSzJupQ3tu8uJ45+gHJL96jU7IsEZyDLDkdVnHJC+RIPfnHKTYVKY5RrPMYowEDhWs/pras7sREmxxnWeofrcW+1NIxE2W6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlcF7kVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlcF7kVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93912C32786;
	Thu, 15 Aug 2024 13:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729491;
	bh=P3wtNF+zq4tzjACUmV5BqchuesjPbIWd9YzSD7EwPrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlcF7kVFfl92ohLlX3h5IeQdfF94KF6C0E6rEb4g+iJ1NnA0hD+WDzgoDAqRw0XGi
	 +Rr9Fw8RHoT31FvrS6C/TZujk87UwkqR9gkyJc7nnDnFyo2Y3075Px4VQ66FinEW0l
	 +yTuXYCPNKSW4dBZx3EvFI9dCR/gNsPkpGJmG9wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/484] NFSv4.1 another fix for EXCHGID4_FLAG_USE_PNFS_DS for DS server
Date: Thu, 15 Aug 2024 15:19:32 +0200
Message-ID: <20240815131945.695839225@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index cba8b4c1fb4a3..8557b2218aa19 100644
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
index 167f2cc3c3798..770fa1cb112d8 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8718,7 +8718,7 @@ nfs4_run_exchange_id(struct nfs_client *clp, const struct cred *cred,
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



