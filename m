Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DCD156222;
	Mon, 16 Sep 2024 12:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488565; cv=none; b=hD1IEk14NqOdJatdHq3sJCIEVYb26iwRK7EE/qjSjxkU7QJ7QuBxbqcdC3ElROIfuvCf/ToE+euXvRbKFBIg4rB5OkqDIctEOIyVrW7lYdIlRHDFcQXCnzRTEY0lW1tshtUbqBTVbgE1Y79mEfAaZiWvPb+pA7D5TP7CcMHmq8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488565; c=relaxed/simple;
	bh=LA4aSc1ETp2YBSaTPFmIKP1u/BxazkwXNh/Nllc/nbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ra7XZmf/RDtCO0mh0EkElDFCvz4nxrMDpIA9Y89SP03qodz4z9w+JhvMsGrMWyGwIreyWIleC6igFwjtDdiifnUKpc+UuyErA1F5oEEiFc9pDFj+6f/GVvHya8xaoy+48MwlfiYMBbh2eVJHRVr5y32dsr6n8GJ57P+8vCO+iec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEk/fL2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEk/fL2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC3DC4CEC4;
	Mon, 16 Sep 2024 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488564;
	bh=LA4aSc1ETp2YBSaTPFmIKP1u/BxazkwXNh/Nllc/nbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEk/fL2mwysnuKzx3Lo9umzyPu9aVl3oKXZ9G+XvWXSQmGQwb7L0BKYWtunBzyCyx
	 /VECxUenAcZ4CrhD84n/0ELq0ueGi1FfJNQfDFvuT1LoPdf8DKg2PFRluv6edC7z+g
	 gM/yBFpMeN+jcAt0Ucyr+/YEwHTxlWNVNEtntZqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 35/91] NFS: Avoid unnecessary rescanning of the per-server delegation list
Date: Mon, 16 Sep 2024 13:44:11 +0200
Message-ID: <20240916114225.669660711@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit f92214e4c312f6ea9d78650cc6291d200f17abb6 ]

If the call to nfs_delegation_grab_inode() fails, we will not have
dropped any locks that require us to rescan the list.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index cf7365581031..a2034511b631 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -627,6 +627,9 @@ static int nfs_server_return_marked_delegations(struct nfs_server *server,
 				prev = delegation;
 			continue;
 		}
+		inode = nfs_delegation_grab_inode(delegation);
+		if (inode == NULL)
+			continue;
 
 		if (prev) {
 			struct inode *tmp = nfs_delegation_grab_inode(prev);
@@ -637,12 +640,6 @@ static int nfs_server_return_marked_delegations(struct nfs_server *server,
 			}
 		}
 
-		inode = nfs_delegation_grab_inode(delegation);
-		if (inode == NULL) {
-			rcu_read_unlock();
-			iput(to_put);
-			goto restart;
-		}
 		delegation = nfs_start_delegation_return_locked(NFS_I(inode));
 		rcu_read_unlock();
 
@@ -1164,7 +1161,6 @@ static int nfs_server_reap_unclaimed_delegations(struct nfs_server *server,
 	struct inode *inode;
 restart:
 	rcu_read_lock();
-restart_locked:
 	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
 		if (test_bit(NFS_DELEGATION_INODE_FREEING,
 					&delegation->flags) ||
@@ -1175,7 +1171,7 @@ static int nfs_server_reap_unclaimed_delegations(struct nfs_server *server,
 			continue;
 		inode = nfs_delegation_grab_inode(delegation);
 		if (inode == NULL)
-			goto restart_locked;
+			continue;
 		delegation = nfs_start_delegation_return_locked(NFS_I(inode));
 		rcu_read_unlock();
 		if (delegation != NULL) {
@@ -1296,7 +1292,6 @@ static int nfs_server_reap_expired_delegations(struct nfs_server *server,
 	nfs4_stateid stateid;
 restart:
 	rcu_read_lock();
-restart_locked:
 	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
 		if (test_bit(NFS_DELEGATION_INODE_FREEING,
 					&delegation->flags) ||
@@ -1307,7 +1302,7 @@ static int nfs_server_reap_expired_delegations(struct nfs_server *server,
 			continue;
 		inode = nfs_delegation_grab_inode(delegation);
 		if (inode == NULL)
-			goto restart_locked;
+			continue;
 		spin_lock(&delegation->lock);
 		cred = get_cred_rcu(delegation->cred);
 		nfs4_stateid_copy(&stateid, &delegation->stateid);
-- 
2.43.0



