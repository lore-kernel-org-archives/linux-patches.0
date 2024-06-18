Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AA31891BB;
	Tue, 18 Jun 2024 13:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715653; cv=none; b=LW9ouxYnsxBlPkBLtfOopXnxsk9wmSt56slxmf7mFKZCTd9H/hdqDB7uy5mGBDzQUsVpCFQWWfkXt1xffOC3AXubjeBkI3hhsbjx5m1WEiPsqBx2BgVpJWJf2/f8oeFKvuCDyNIc/SvIEYg3mPYkfwR/82aNyOEHusL7R1qukIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715653; c=relaxed/simple;
	bh=uLe9DAZu53Gkw7kT5VmVGM011nLZIhtyJ9VtqdVzQJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIfiHkFL29Kb3d+mfEbrrCxg8o85/ecZrbcNg8A9K5n1cJc4O4v6/1u79oN6T2RB5XhxXZelbY4h04mxXfmcbCpa2/GUzXFmiJtngCkuqak5Xt48dk1hU2ymUFb+SDkR9PQ1REfS7CSY0lPiTCm6s04KAd4hclFza80qwFicTAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gC7FWxVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gC7FWxVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0212C3277B;
	Tue, 18 Jun 2024 13:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715653;
	bh=uLe9DAZu53Gkw7kT5VmVGM011nLZIhtyJ9VtqdVzQJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gC7FWxVPgco+63z38lKn12ZsFSBr7LBjT+MoHEanzf0vX2G0EnNRebkjP7xj0ffPe
	 9UhdapP0WA9p8YoJmyw1gSGG5kUWqOHSVL3H+vx8h6YE3QPBhEfQq3wZKKVy/TE8K6
	 dX2x4LnszSEPliN77eRQVR55Zblu+Ftib8M72aqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/770] nfs: dont atempt blocking locks on nfs reexports
Date: Tue, 18 Jun 2024 14:33:23 +0200
Message-ID: <20240618123420.770084959@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit f657f8eef3ff870552c9fd2839e0061046f44618 ]

NFS implements blocking locks by blocking inside its lock method.  In
the reexport case, this blocks the nfs server thread, which could lead
to deadlocks since an nfs server thread might be required to unlock the
conflicting lock.  It also causes a crash, since the nfs server thread
assumes it can free the lock when its lm_notify lock callback is called.

Ideal would be to make the nfs lock method return without blocking in
this case, but for now it works just not to attempt blocking locks.  The
difference is just that the original client will have to poll (as it
does in the v4.0 case) instead of getting a callback when the lock's
available.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Acked-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/export.c          | 2 +-
 fs/nfsd/nfs4state.c      | 8 ++++++--
 include/linux/exportfs.h | 2 ++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index b347e3ce0cc8e..40beac65d1355 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -184,5 +184,5 @@ const struct export_operations nfs_export_ops = {
 	.fetch_iversion = nfs_fetch_iversion,
 	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
 		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS|
-		EXPORT_OP_NOATOMIC_ATTR,
+		EXPORT_OP_NOATOMIC_ATTR|EXPORT_OP_SYNC_LOCKS,
 };
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 401f0f2743717..fd3bdf0bf0052 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6878,6 +6878,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd4_blocked_lock *nbl = NULL;
 	struct file_lock *file_lock = NULL;
 	struct file_lock *conflock = NULL;
+	struct super_block *sb;
 	__be32 status = 0;
 	int lkflg;
 	int err;
@@ -6899,6 +6900,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		dprintk("NFSD: nfsd4_lock: permission denied!\n");
 		return status;
 	}
+	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {
 		if (nfsd4_has_session(cstate))
@@ -6947,7 +6949,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) &&
+			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_READ_LT:
@@ -6959,7 +6962,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			fl_type = F_RDLCK;
 			break;
 		case NFS4_WRITEW_LT:
-			if (nfsd4_has_session(cstate))
+			if (nfsd4_has_session(cstate) &&
+			    !(sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS))
 				fl_flags |= FL_SLEEP;
 			fallthrough;
 		case NFS4_WRITE_LT:
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index fe848901fcc3a..3260fe7148462 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -221,6 +221,8 @@ struct export_operations {
 #define EXPORT_OP_NOATOMIC_ATTR		(0x10) /* Filesystem cannot supply
 						  atomic attribute updates
 						*/
+#define EXPORT_OP_SYNC_LOCKS		(0x20) /* Filesystem can't do
+						  asychronous blocking locks */
 	unsigned long	flags;
 };
 
-- 
2.43.0



