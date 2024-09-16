Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A42159571;
	Mon, 16 Sep 2024 12:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488310; cv=none; b=IPqbnP+YNgMMGFEnRYViJdDvdNY3QgVUnjR1i5yZx222Pxm0XygAe2w8P5ijxLo8LdeKwh6KBybie7AvJCEew0Us5976cOcfe2BhoW7G/13gn2Cpp8gMedl1t2+9guFhwAGL2BsMji0+HJoNiCJO/pp91gHD6B4bUwh4qxOGh5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488310; c=relaxed/simple;
	bh=FMc7JL97ozfQ3+XnuaQKhVNhWkHq690btThLk1cgAKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAc6kWJCdDcyzxq3E1Us7QmWJWDCOvSmL2gdtAIXYH6qF/3AaYsH3S71GqpOHnicE9rsW1mJEn1F0YBlw8awOdhcxUUw06bxOVBV8oGqjZamVi1aos79VepsVsHdOzcIjXJSVszHq792gKIdvnP6hZ6x5SsT06djYxyVK/7CJow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IJOi+ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IJOi+ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC83C4CEC4;
	Mon, 16 Sep 2024 12:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488310;
	bh=FMc7JL97ozfQ3+XnuaQKhVNhWkHq690btThLk1cgAKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IJOi+htzlD3Ka6G7Lk21Sg4bvssrR1FmPxQGzmcjFiCCKJP+nSJuL9YRUCfGSK2j
	 dZpu3DnZbCE7SlPp8dRqXp74H0J5ZlKwn4LANAJqwjDBWviSc+ovYaMbVRoqLtTFf4
	 vb7kca6ta/1dhYEQBSMSPdK4nkDD0xe2QvQP2NlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 042/121] NFS: Avoid unnecessary rescanning of the per-server delegation list
Date: Mon, 16 Sep 2024 13:43:36 +0200
Message-ID: <20240916114230.523783593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6bace5fece04..ed362d291b90 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -624,6 +624,9 @@ static int nfs_server_return_marked_delegations(struct nfs_server *server,
 				prev = delegation;
 			continue;
 		}
+		inode = nfs_delegation_grab_inode(delegation);
+		if (inode == NULL)
+			continue;
 
 		if (prev) {
 			struct inode *tmp = nfs_delegation_grab_inode(prev);
@@ -634,12 +637,6 @@ static int nfs_server_return_marked_delegations(struct nfs_server *server,
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
 
@@ -1161,7 +1158,6 @@ static int nfs_server_reap_unclaimed_delegations(struct nfs_server *server,
 	struct inode *inode;
 restart:
 	rcu_read_lock();
-restart_locked:
 	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
 		if (test_bit(NFS_DELEGATION_INODE_FREEING,
 					&delegation->flags) ||
@@ -1172,7 +1168,7 @@ static int nfs_server_reap_unclaimed_delegations(struct nfs_server *server,
 			continue;
 		inode = nfs_delegation_grab_inode(delegation);
 		if (inode == NULL)
-			goto restart_locked;
+			continue;
 		delegation = nfs_start_delegation_return_locked(NFS_I(inode));
 		rcu_read_unlock();
 		if (delegation != NULL) {
@@ -1295,7 +1291,6 @@ static int nfs_server_reap_expired_delegations(struct nfs_server *server,
 
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



