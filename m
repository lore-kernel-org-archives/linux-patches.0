Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5602690DB;
	Tue,  8 Apr 2025 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111673; cv=none; b=pOcUHClBp/iBGCfWg3mfEANHi4LIWbaf/ev3Qpp7qmlepYuTQzeNXJinML3OWNDSTEj072oWKj/rSTVIrj5YT/XLXKwdtcobGO8q/Z1nQS2qgi7EW6MlzQ9h3Pm4erYquX+zQYlzh+UV8Ed2jmKHQ6Y4SidQOGlRluPSZbGZgLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111673; c=relaxed/simple;
	bh=PPRvo38YQQy93AaixqY6nMEbm4JkRa+dM41VH0HF5mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aj/KCBoO8BWig5xFoEh4yM9qRZwSgjlS/P0KNGs98eJpAkdeawbBOxXfbShFeiqvGDfoEBJqqlsRPZzRhY3QOIpPbZx3WvjQS+ptD2ZeXRENesk7rsKS1Jqiuabx9pue7wZILFiqMrMdeUyd+DCag90a6D+yYxd4AZGNkYMjCFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DB7a0YH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DB7a0YH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B81C4CEE5;
	Tue,  8 Apr 2025 11:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111673;
	bh=PPRvo38YQQy93AaixqY6nMEbm4JkRa+dM41VH0HF5mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DB7a0YH4AVBDgB+1zqEMAeP6PbW26Cg3+xVVk7FjvTjn73ais7MIZK/uLEVa2hdm8
	 yzW5vAtxjW3+5InRGNMb8Reg5jrVKGg4Yg7UGiC0h7XdT9/CtJIGrzJZz7xwXe2NGx
	 c4lVw87MBsKMf2mi1uNBdh8ZUSJY4RP92bzAV9fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 518/731] NFSv4: Avoid unnecessary scans of filesystems for delayed delegations
Date: Tue,  8 Apr 2025 12:46:55 +0200
Message-ID: <20250408104926.321717885@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e767b59e29b8327d25edde65efc743f479f30d0a ]

The amount of looping through the list of delegations is occasionally
leading to soft lockups. If the state manager was asked to manage the
delayed return of delegations, then only scan those filesystems
containing delegations that were marked as being delayed.

Fixes: be20037725d1 ("NFSv4: Fix delegation return in cases where we have to retry")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c       | 18 ++++++++++++------
 include/linux/nfs_fs_sb.h |  1 +
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index abd952cc47e4b..325ba0663a6de 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -331,14 +331,16 @@ nfs_start_delegation_return(struct nfs_inode *nfsi)
 }
 
 static void nfs_abort_delegation_return(struct nfs_delegation *delegation,
-					struct nfs_client *clp, int err)
+					struct nfs_server *server, int err)
 {
-
 	spin_lock(&delegation->lock);
 	clear_bit(NFS_DELEGATION_RETURNING, &delegation->flags);
 	if (err == -EAGAIN) {
 		set_bit(NFS_DELEGATION_RETURN_DELAYED, &delegation->flags);
-		set_bit(NFS4CLNT_DELEGRETURN_DELAYED, &clp->cl_state);
+		set_bit(NFS4SERV_DELEGRETURN_DELAYED,
+			&server->delegation_flags);
+		set_bit(NFS4CLNT_DELEGRETURN_DELAYED,
+			&server->nfs_client->cl_state);
 	}
 	spin_unlock(&delegation->lock);
 }
@@ -548,7 +550,7 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
  */
 static int nfs_end_delegation_return(struct inode *inode, struct nfs_delegation *delegation, int issync)
 {
-	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
+	struct nfs_server *server = NFS_SERVER(inode);
 	unsigned int mode = O_WRONLY | O_RDWR;
 	int err = 0;
 
@@ -570,11 +572,11 @@ static int nfs_end_delegation_return(struct inode *inode, struct nfs_delegation
 		/*
 		 * Guard against state recovery
 		 */
-		err = nfs4_wait_clnt_recover(clp);
+		err = nfs4_wait_clnt_recover(server->nfs_client);
 	}
 
 	if (err) {
-		nfs_abort_delegation_return(delegation, clp, err);
+		nfs_abort_delegation_return(delegation, server, err);
 		goto out;
 	}
 
@@ -678,6 +680,9 @@ static bool nfs_server_clear_delayed_delegations(struct nfs_server *server)
 	struct nfs_delegation *d;
 	bool ret = false;
 
+	if (!test_and_clear_bit(NFS4SERV_DELEGRETURN_DELAYED,
+				&server->delegation_flags))
+		goto out;
 	list_for_each_entry_rcu (d, &server->delegations, super_list) {
 		if (!test_bit(NFS_DELEGATION_RETURN_DELAYED, &d->flags))
 			continue;
@@ -685,6 +690,7 @@ static bool nfs_server_clear_delayed_delegations(struct nfs_server *server)
 		clear_bit(NFS_DELEGATION_RETURN_DELAYED, &d->flags);
 		ret = true;
 	}
+out:
 	return ret;
 }
 
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 7d6f164036fac..108862d81b579 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -253,6 +253,7 @@ struct nfs_server {
 	unsigned long		delegation_flags;
 #define NFS4SERV_DELEGRETURN		(1)
 #define NFS4SERV_DELEGATION_EXPIRED	(2)
+#define NFS4SERV_DELEGRETURN_DELAYED	(3)
 	unsigned long		delegation_gen;
 	unsigned long		mig_gen;
 	unsigned long		mig_status;
-- 
2.39.5



