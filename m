Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1A026A0A2;
	Tue,  8 Apr 2025 12:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114829; cv=none; b=JiV3iD4Gyjt1Kg/rhhqgeAHhCLpX2FYwqHGyRqqN4XPZE2J9c/PdNV6ytDm6bY/uz40nvU65kk3LJ8v/Z8NCBkqly/q6Vhbi22XuCEyOCWATEGw3JPmHAie047RKoSVGEYajVLlDn8AO8cq9pzzscY6DwdKrN8K2NUEYw1JVO4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114829; c=relaxed/simple;
	bh=W2LS047pHvlD9sye3q+2AqNDLQOCWPAYcNroar0q/MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhhxZ/JEL8s94Hnb3EzPArx+gQUScv/9O4vLEfQD2FOJiA11A/gV4J0PluqhJJdtGNUTCsqWr9VpMWJUdmB7d/xJ9AIwyf9r7yJyL4O6XhDtHeJZGqkx7pALT+gslHHnLkHkikfbu7Oi7d+F+w5bDGhwgeIk/AC5rq4dQRHBA6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5Hqb14E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5Hqb14E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02CDC4CEE5;
	Tue,  8 Apr 2025 12:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114829;
	bh=W2LS047pHvlD9sye3q+2AqNDLQOCWPAYcNroar0q/MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5Hqb14EB34VItkIM5G14H3ZOYPNgJtRuOaKtW19U6xDHG4s9ity6i2N/hXSrwHNo
	 YfJZiZ4WwWy5adj53KLM3KsG2mor9Ybo+CBH2AkvVJoNjteQKTMr1W3iAPs+Stuq9U
	 dCmpqiDKqppuHxNfbjxzFW/hi0DcTmg42Lr8EF6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 248/499] NFSv4: Avoid unnecessary scans of filesystems for delayed delegations
Date: Tue,  8 Apr 2025 12:47:40 +0200
Message-ID: <20250408104857.398103213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index f4cb1f4850a0c..81ab18658d72d 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -254,6 +254,7 @@ struct nfs_server {
 	unsigned long		delegation_flags;
 #define NFS4SERV_DELEGRETURN		(1)
 #define NFS4SERV_DELEGATION_EXPIRED	(2)
+#define NFS4SERV_DELEGRETURN_DELAYED	(3)
 	unsigned long		delegation_gen;
 	unsigned long		mig_gen;
 	unsigned long		mig_status;
-- 
2.39.5



