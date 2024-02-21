Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7336A47A7C;
	Wed, 21 Feb 2024 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524051; cv=none; b=ROB0l7prRXHYhoiCM2zoI79fNANkqNDUdiN2i60Zn09f0/FZjmFFHuxJEJj1uFjfeLEBM2F5TYlrIp1YoQ1asD4DkP63s5/HXTH4VFjSsESY4Zd5YvTkNAg59in405TMP9PB3VddJcQM3uhqjCjGhmLUYJeeWky2Rv8EcOy8Kks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524051; c=relaxed/simple;
	bh=YpyWVYswGpziSy3HhcIZxNBwCd0d8KAAi+gDYlV/m1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXKver4CltkBp8fiWzOY8iS6MLcnoqL/qXvJvoyy3wGhWgyI7SWge2xdKZvLliE6r76kDpL9Q60XM3scrGTv0X7g+uJwszDPASsIWXOo1sg54Ticc/va3SknKggfienPkJJCGsc7ZrbO/LmvXNTbMg74wbvmonMclgpPgnANbEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SC4C7g7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SC4C7g7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7736C433C7;
	Wed, 21 Feb 2024 14:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524051;
	bh=YpyWVYswGpziSy3HhcIZxNBwCd0d8KAAi+gDYlV/m1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC4C7g7pZqrDJ79Nq4piYUA2CPEsG88qytJgLbQopbJghOKk9AogXEK650l2LL3O4
	 CUNI/yg2UgKxw6kzPOhng6O3Qd/FPW/KnSZzwEUVoMDvFxadi0XKDS7vb9aBZ65TY/
	 IQP7ULhK/9eBa3f/ny+c9gLgiaHglImy/NUEb83U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/379] NFSD: Add documenting comment for nfsd4_release_lockowner()
Date: Wed, 21 Feb 2024 14:04:31 +0100
Message-ID: <20240221125957.626899942@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 043862b09cc00273e35e6c3a6389957953a34207 ]

And return explicit nfserr values that match what is documented in the
new comment / API contract.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: edcf9725150e ("nfsd: fix RELEASE_LOCKOWNER")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1b40b2197ce6..b6480be7b5e6 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7107,6 +7107,23 @@ check_for_locks(struct nfs4_file *fp, struct nfs4_lockowner *lowner)
 	return status;
 }
 
+/**
+ * nfsd4_release_lockowner - process NFSv4.0 RELEASE_LOCKOWNER operations
+ * @rqstp: RPC transaction
+ * @cstate: NFSv4 COMPOUND state
+ * @u: RELEASE_LOCKOWNER arguments
+ *
+ * The lockowner's so_count is bumped when a lock record is added
+ * or when copying a conflicting lock. The latter case is brief,
+ * but can lead to fleeting false positives when looking for
+ * locks-in-use.
+ *
+ * Return values:
+ *   %nfs_ok: lockowner released or not found
+ *   %nfserr_locks_held: lockowner still in use
+ *   %nfserr_stale_clientid: clientid no longer active
+ *   %nfserr_expired: clientid not recognized
+ */
 __be32
 nfsd4_release_lockowner(struct svc_rqst *rqstp,
 			struct nfsd4_compound_state *cstate,
@@ -7133,7 +7150,7 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 	lo = find_lockowner_str_locked(clp, &rlockowner->rl_owner);
 	if (!lo) {
 		spin_unlock(&clp->cl_lock);
-		return status;
+		return nfs_ok;
 	}
 	if (atomic_read(&lo->lo_owner.so_count) != 2) {
 		spin_unlock(&clp->cl_lock);
@@ -7149,11 +7166,11 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 		put_ol_stateid_locked(stp, &reaplist);
 	}
 	spin_unlock(&clp->cl_lock);
+
 	free_ol_stateid_reaplist(&reaplist);
 	remove_blocked_locks(lo);
 	nfs4_put_stateowner(&lo->lo_owner);
-
-	return status;
+	return nfs_ok;
 }
 
 static inline struct nfs4_client_reclaim *
-- 
2.43.0



