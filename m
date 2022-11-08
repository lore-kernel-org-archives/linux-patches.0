Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B70015CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A31C433D7;
	Tue,  8 Nov 2022 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915552;
	bh=gircjBMm/s/idxmHBnbJRXTON+VhDfEmi3AANon/C9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siHGLLXxdfgVYzIBtihagoY9Dzd1gQEZ0wYXWBoZtTzveeypactQr5I3SxUJGHfAR
	 emySiVM4WZ8t3iMFWviBsXXJA9f5wx1PXAm/dorvUVCUVWYEsJvm8ivsO6Y5C6PtYG
	 s8ol8qPPo1U/RZCUZ3h1QUVk3y5S1BsQoV0Zz53E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/118] NFSv4: Fix a potential state reclaim deadlock
Date: Tue,  8 Nov 2022 14:38:13 +0100
Message-Id: <20221108133341.347934870@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1ba04394e028ea8b45d92685cc0d6ab582cf7647 ]

If the server reboots while we are engaged in a delegation return, and
there is a pNFS layout with return-on-close set, then the current code
can end up deadlocking in pnfs_roc() when nfs_inode_set_delegation()
tries to return the old delegation.
Now that delegreturn actually uses its own copy of the stateid, it
should be safe to just always update the delegation stateid in place.

Fixes: 078000d02d57 ("pNFS: We want return-on-close to complete when evicting the inode")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index d6ac2c4f88b6..1eb6c7a142ff 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -228,8 +228,7 @@ static int nfs_delegation_claim_opens(struct inode *inode,
  *
  */
 void nfs_inode_reclaim_delegation(struct inode *inode, const struct cred *cred,
-				  fmode_t type,
-				  const nfs4_stateid *stateid,
+				  fmode_t type, const nfs4_stateid *stateid,
 				  unsigned long pagemod_limit)
 {
 	struct nfs_delegation *delegation;
@@ -239,25 +238,24 @@ void nfs_inode_reclaim_delegation(struct inode *inode, const struct cred *cred,
 	delegation = rcu_dereference(NFS_I(inode)->delegation);
 	if (delegation != NULL) {
 		spin_lock(&delegation->lock);
-		if (nfs4_is_valid_delegation(delegation, 0)) {
-			nfs4_stateid_copy(&delegation->stateid, stateid);
-			delegation->type = type;
-			delegation->pagemod_limit = pagemod_limit;
-			oldcred = delegation->cred;
-			delegation->cred = get_cred(cred);
-			clear_bit(NFS_DELEGATION_NEED_RECLAIM,
-				  &delegation->flags);
-			spin_unlock(&delegation->lock);
-			rcu_read_unlock();
-			put_cred(oldcred);
-			trace_nfs4_reclaim_delegation(inode, type);
-			return;
-		}
-		/* We appear to have raced with a delegation return. */
+		nfs4_stateid_copy(&delegation->stateid, stateid);
+		delegation->type = type;
+		delegation->pagemod_limit = pagemod_limit;
+		oldcred = delegation->cred;
+		delegation->cred = get_cred(cred);
+		clear_bit(NFS_DELEGATION_NEED_RECLAIM, &delegation->flags);
+		if (test_and_clear_bit(NFS_DELEGATION_REVOKED,
+				       &delegation->flags))
+			atomic_long_inc(&nfs_active_delegations);
 		spin_unlock(&delegation->lock);
+		rcu_read_unlock();
+		put_cred(oldcred);
+		trace_nfs4_reclaim_delegation(inode, type);
+	} else {
+		rcu_read_unlock();
+		nfs_inode_set_delegation(inode, cred, type, stateid,
+					 pagemod_limit);
 	}
-	rcu_read_unlock();
-	nfs_inode_set_delegation(inode, cred, type, stateid, pagemod_limit);
 }
 
 static int nfs_do_return_delegation(struct inode *inode, struct nfs_delegation *delegation, int issync)
-- 
2.35.1



