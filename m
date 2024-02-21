Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1BE69962;
	Wed, 21 Feb 2024 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525071; cv=none; b=nnirVEAemz0+TvL05kYKqn7rJ8OZcIwyHcz63BcDf5DT4LFZ790+02PrGm5C54Ee0XIB+nekz5V1v9GXsWiq8gXNFrn34Pv1Ctdap+m/M8blaccCisxVACFC9zyp5C+veWKFVHi9dnSbLMPrr2Q9ulKDRvtMoHqZwlk9wFioK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525071; c=relaxed/simple;
	bh=g152cpNauYOHBIjGvSEcp2l2kF4FUepzitmSBJbpR2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4QcAaq5dA4F6vA6x9o0dGS988jpW5bYYSEfXLccDRSNZJEqrD56tjbSNV5Cm8WP/KM+ImZfhRpAQ0bHdNbvVclGzoQSEVW8LDRM5S3Gj/8jZM6PCKXXZa7olpXCVwmu6zE9tIiaS0zBbCdMiZlbwzc3Jwb4TLeFyLBhV82vNTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr0+N0Ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr0+N0Ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC47AC433C7;
	Wed, 21 Feb 2024 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525071;
	bh=g152cpNauYOHBIjGvSEcp2l2kF4FUepzitmSBJbpR2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr0+N0KecHRr2uoVRKEiV/OrRG/D63JbtYswwgqu5zD0zN7I6qRKwwxRu7zRWzNhd
	 MAkrCNM/IM+w6MLzGMngAl9lNsvD3kcBmOuQz88vQ9dOXzXLhJyfQVcMRzUBWyrywN
	 XWsga85wiD/ebQUs1nk9Uu63fwvn0ByiSNj7Jz7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/267] NFSD: Add documenting comment for nfsd4_release_lockowner()
Date: Wed, 21 Feb 2024 14:06:34 +0100
Message-ID: <20240221125941.674754981@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9a77a3eac4ac..0dfc45d37658 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6867,6 +6867,23 @@ check_for_locks(struct nfs4_file *fp, struct nfs4_lockowner *lowner)
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
@@ -6893,7 +6910,7 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 	lo = find_lockowner_str_locked(clp, &rlockowner->rl_owner);
 	if (!lo) {
 		spin_unlock(&clp->cl_lock);
-		return status;
+		return nfs_ok;
 	}
 	if (atomic_read(&lo->lo_owner.so_count) != 2) {
 		spin_unlock(&clp->cl_lock);
@@ -6909,11 +6926,11 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
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



