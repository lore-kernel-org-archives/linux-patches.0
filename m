Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF04BB67E;
	Wed,  8 Apr 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672338; cv=none; b=pbehYZTNcYyKUFVmNDsHjH+ChCssmcBsQ2sfN5G4nvaRhlTyFYZdaNLptaRL7mjYz1ktga4O/2mheXQTpg16YN36OVCykN2BNvSbnX/ASpDi+xn+HvCkVe5QQW4mLZnAvlOG+Q5o+qhoaKxLwSerhIUFqTREZouvf4x8+WraNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672338; c=relaxed/simple;
	bh=aGICxead0iEbkm/INdas3PPO3P4R1Hyp3W+YxwK58kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8ppv2ugX0VsZM7SCLsUDwS1MtlT9qzHr9XMqN851R2k6mLB7AzUNKsXXzLH+L+A0YXy4+cse6Q+9bWuy4bH6l2FO1XO0wJ2PZNW0xzjQQG1hYxkCyH+ZvQ0XZE7Sdmafsc2D8Cx1Qe0zYp1KrMW2Ijd6egatvZvx+c8glrsFsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHjQMh+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHjQMh+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44384C19421;
	Wed,  8 Apr 2026 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672338;
	bh=aGICxead0iEbkm/INdas3PPO3P4R1Hyp3W+YxwK58kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHjQMh+O2/XiNlP1bkxbjMnfHQnVYw2xSR0i8rNWwH4bBTg2T3dGUr9EmVxtPBL8h
	 npfRKUhVNfj+yxNLOQiDjOXel1roOYG2YHqVQjz+JA5+vDIrF7H7pjgmHCl4Cu4cYh
	 LDfPQva1apz+1VLIbO1iPUHOxB9QIRjrj6o+BAZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Werner Kasselman <werner@verivus.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 281/312] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Date: Wed,  8 Apr 2026 20:03:18 +0200
Message-ID: <20260408175944.248833072@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Werner Kasselman <werner@verivus.com>

[ Upstream commit 309b44ed684496ed3f9c5715d10b899338623512 ]

smb2_lock() has three error handling issues after list_del() detaches
smb_lock from lock_list at no_check_cl:

1) If vfs_lock_file() returns an unexpected error in the non-UNLOCK
   path, goto out leaks smb_lock and its flock because the out:
   handler only iterates lock_list and rollback_list, neither of
   which contains the detached smb_lock.

2) If vfs_lock_file() returns -ENOENT in the UNLOCK path, goto out
   leaks smb_lock and flock for the same reason.  The error code
   returned to the dispatcher is also stale.

3) In the rollback path, smb_flock_init() can return NULL on
   allocation failure.  The result is dereferenced unconditionally,
   causing a kernel NULL pointer dereference.  Add a NULL check to
   prevent the crash and clean up the bookkeeping; the VFS lock
   itself cannot be rolled back without the allocation and will be
   released at file or connection teardown.

Fix cases 1 and 2 by hoisting the locks_free_lock()/kfree() to before
the if(!rc) check in the UNLOCK branch so all exit paths share one
free site, and by freeing smb_lock and flock before goto out in the
non-UNLOCK branch.  Propagate the correct error code in both cases.
Fix case 3 by wrapping the VFS unlock in an if(rlock) guard and adding
a NULL check for locks_free_lock(rlock) in the shared cleanup.

Found via call-graph analysis using sqry.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Suggested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Werner Kasselman <werner@verivus.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ adapted rlock->c.flc_type to rlock->fl_type ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7145,14 +7145,15 @@ retry:
 		rc = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
 skip:
 		if (smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) {
+			locks_free_lock(flock);
+			kfree(smb_lock);
 			if (!rc) {
 				ksmbd_debug(SMB, "File unlocked\n");
 			} else if (rc == -ENOENT) {
 				rsp->hdr.Status = STATUS_NOT_LOCKED;
+				err = rc;
 				goto out;
 			}
-			locks_free_lock(flock);
-			kfree(smb_lock);
 		} else {
 			if (rc == FILE_LOCK_DEFERRED) {
 				void **argv;
@@ -7221,6 +7222,9 @@ skip:
 				spin_unlock(&work->conn->llist_lock);
 				ksmbd_debug(SMB, "successful in taking lock\n");
 			} else {
+				locks_free_lock(flock);
+				kfree(smb_lock);
+				err = rc;
 				goto out;
 			}
 		}
@@ -7251,13 +7255,17 @@ out:
 		struct file_lock *rlock = NULL;
 
 		rlock = smb_flock_init(filp);
-		rlock->fl_type = F_UNLCK;
-		rlock->fl_start = smb_lock->start;
-		rlock->fl_end = smb_lock->end;
-
-		rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
-		if (rc)
-			pr_err("rollback unlock fail : %d\n", rc);
+		if (rlock) {
+			rlock->fl_type = F_UNLCK;
+			rlock->fl_start = smb_lock->start;
+			rlock->fl_end = smb_lock->end;
+
+			rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
+			if (rc)
+				pr_err("rollback unlock fail : %d\n", rc);
+		} else {
+			pr_err("rollback unlock alloc failed\n");
+		}
 
 		list_del(&smb_lock->llist);
 		spin_lock(&work->conn->llist_lock);
@@ -7267,7 +7275,8 @@ out:
 		spin_unlock(&work->conn->llist_lock);
 
 		locks_free_lock(smb_lock->fl);
-		locks_free_lock(rlock);
+		if (rlock)
+			locks_free_lock(rlock);
 		kfree(smb_lock);
 	}
 out2:


