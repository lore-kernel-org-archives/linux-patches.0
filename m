Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6CB2E11A6;
	Tue, 31 Mar 2026 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976667; cv=none; b=EK7SNGQBr7QpACX5uogpRQlTx9hbZU2wm9OFdVyv/CY3NFpZCZ8ANOl2GjQ24FR52QaBWklM/WXsy7KnRG1SI+IJJHgHzaL0QrqHVutuDqWPlGQwt8BIAqEjgTdStnRZfveyodXzlwU0O2dvGr2i3KrHIjDIO6XnQ2EYX1tTx2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976667; c=relaxed/simple;
	bh=dza7VChuPQpyoSVaPnU/tsbnjiXEb9TnyYuNcl7h07U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKX35oKRsH884Hp9yC4Ombhi5SgVHJ55EuA2jm76jusjzzW1lH+4dLpvmEzhxVrSQ+aA8+IT3lXgiVsLeOX/Z+1JX7V8R7Ra7KRSFQg3vv0T9TPIrxYFOvRaoSw022twimKmqvKCj+BYObqpRppdgLNpgH198fhQK3ymj846WDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0b4W0ryF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0b4W0ryF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238F5C19423;
	Tue, 31 Mar 2026 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976667;
	bh=dza7VChuPQpyoSVaPnU/tsbnjiXEb9TnyYuNcl7h07U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0b4W0ryFzr9o8s1KOFOP2EaNbBd7zmOOHVUzROuvGl9Oa7DaMBYkvR2ug4yYh6gNV
	 9SVODk3QmgFjOw00Gdsut9Z4AK81qJ0YrXdUwz5dfekj3va7Erc5y8P0givIYhQS8Q
	 0fvYo7CapaZ00zcJwACDZC8ZDKmi6nCxYgCg5/Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Werner Kasselman <werner@verivus.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 182/309] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Date: Tue, 31 Mar 2026 18:21:25 +0200
Message-ID: <20260331161800.164108475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Kasselman <werner@verivus.com>

commit 309b44ed684496ed3f9c5715d10b899338623512 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7602,14 +7602,15 @@ retry:
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
@@ -7678,6 +7679,9 @@ skip:
 				spin_unlock(&work->conn->llist_lock);
 				ksmbd_debug(SMB, "successful in taking lock\n");
 			} else {
+				locks_free_lock(flock);
+				kfree(smb_lock);
+				err = rc;
 				goto out;
 			}
 		}
@@ -7708,13 +7712,17 @@ out:
 		struct file_lock *rlock = NULL;
 
 		rlock = smb_flock_init(filp);
-		rlock->c.flc_type = F_UNLCK;
-		rlock->fl_start = smb_lock->start;
-		rlock->fl_end = smb_lock->end;
-
-		rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
-		if (rc)
-			pr_err("rollback unlock fail : %d\n", rc);
+		if (rlock) {
+			rlock->c.flc_type = F_UNLCK;
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
@@ -7724,7 +7732,8 @@ out:
 		spin_unlock(&work->conn->llist_lock);
 
 		locks_free_lock(smb_lock->fl);
-		locks_free_lock(rlock);
+		if (rlock)
+			locks_free_lock(rlock);
 		kfree(smb_lock);
 	}
 out2:


