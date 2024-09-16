Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F9A1547C4;
	Mon, 16 Sep 2024 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487989; cv=none; b=R6TUnPfNEI3kUrbHJBEVbz17h2IcX6Jistkw3l8tqkoiadfrAlDf7/SoSGSR3jyDuO/C28qUKO70tU32caTAES3EfDNfMenjiu35Zhd64VwqO+eHicQ9ldLQVr+zk6JSYuLlWnD/NqID5yyfaRCTJlcRGiyZauSXcT7OMzvva+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487989; c=relaxed/simple;
	bh=hS0DF/NrT1AKpp77bbCZz/S/IFJBs/kEVPCRlMAEXEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+/0wOx0Ge+u5i5zHb19XbM3gIyxZcZ9KmdTBgHM6mq58VSY328V5TYy0dlX5/E0Z8LylYyKO0rsHT3yyz1rIakNgsFwnKGx32fpWIqfUfDyGaHRMWe65yXqLFUEvGGwmEUOCvh2efiMmig/l/QdahTwVIEGeetuLHmCnC3zzNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTq2g5gT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTq2g5gT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605ABC4CEC4;
	Mon, 16 Sep 2024 11:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726487988;
	bh=hS0DF/NrT1AKpp77bbCZz/S/IFJBs/kEVPCRlMAEXEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTq2g5gTXJIFaXQX3idHNhsb6EFLj5kKaK3dPRXu8vj+c/Y2q3g8OfQwe5Sh43uiq
	 QhcWg9BWDtx5v1dCQSn5FVCtm8TCniNiLLu6sCVs5pPQnp/uGU9nsN6aKnjxYLM0V9
	 Dr1JR3uKTo0LZPOfEE2pfIpvivRhiavbBUS9LfV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/63] NFS: Avoid unnecessary rescanning of the per-server delegation list
Date: Mon, 16 Sep 2024 13:43:59 +0200
Message-ID: <20240916114221.786276532@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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
index ead8a0e06abf..2ba4d221bf9d 100644
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



