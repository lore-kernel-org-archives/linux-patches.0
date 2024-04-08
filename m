Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEE781745;
	Mon,  8 Apr 2024 13:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584078; cv=none; b=IbfFC0TkorVgX0Z7x1faEd6KNCXwLCTyMPTorxT82YUAaPkOiVQKa63wpljX84KPDHkjsBkZhIItYtWK6b+dEunlRkb2ZTlQQH0YJ2vev2jxIc2VD9UajkBl6xl/q5GFXuG4JEYfoqOSVcv2flHKp29ZtDLSerbxVCYHzv56Cag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584078; c=relaxed/simple;
	bh=2RmQqspAo7/FDVT/GKR1m93mdmS17KeZvP4NjtK9/9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rge9esFkvxtHww3Qst4VZT36gw3/0XY06MItKHdfWnwzX5wazpI+rrmcDYstbaiv9e/HRlLVNIVq/6R37xIOuRE1MYGRrdJZtQM15Pk/1NXPymnBqvZ7PmKT/Nm/iqOx1HL3a3K81+kXWlXr+lT9S34tibXTI/ll390Ij+nEcDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVeGQ9tG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVeGQ9tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392A7C433F1;
	Mon,  8 Apr 2024 13:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584077;
	bh=2RmQqspAo7/FDVT/GKR1m93mdmS17KeZvP4NjtK9/9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVeGQ9tGed/Kz9EnV5U54w+Lqmww2hyJ6gCMl3LIx2PXTeEWxrQHdpS7mJZ3TNsop
	 HYeqwuDVKjECLXOpfQV90QMo9pXeBP1I/StsOGt7HlXGIHTN7DXJc5U/AT847cFW0s
	 sa3mSImwDBTcv5yuJ7JY6c8qj2JKjVn2JOcRE4FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 330/690] NFSD: Add documenting comment for nfsd4_release_lockowner()
Date: Mon,  8 Apr 2024 14:53:16 +0200
Message-ID: <20240408125411.563542079@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 043862b09cc00273e35e6c3a6389957953a34207 ]

And return explicit nfserr values that match what is documented in the
new comment / API contract.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2d52656095340..08700b6acba31 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7542,6 +7542,23 @@ check_for_locks(struct nfs4_file *fp, struct nfs4_lockowner *lowner)
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
@@ -7568,7 +7585,7 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 	lo = find_lockowner_str_locked(clp, &rlockowner->rl_owner);
 	if (!lo) {
 		spin_unlock(&clp->cl_lock);
-		return status;
+		return nfs_ok;
 	}
 	if (atomic_read(&lo->lo_owner.so_count) != 2) {
 		spin_unlock(&clp->cl_lock);
@@ -7584,11 +7601,11 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
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



