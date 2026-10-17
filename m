Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497623A0E85;
	Sat, 17 Oct 2026 16:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254960; cv=none; b=B4oMiUtj13r+WpKETyRNbNkkDCXLTco80WAKcdR7SirwezAmkIbV9gtB/uYZI94IPtxqsn5bZA1DglRu1TBGehuPcBpMZnqkyQ/vC+PigVPTCJf7euxbg4dpzppiZVzGv6/SymeULOr7dQCgdYil+tTOyJ0HxNccxWKlQaHRNYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254960; c=relaxed/simple;
	bh=nioVPgbzLYlU+B2jnPHOhfwXdNFOWosYWYeqJyAtxL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8w1smXwTJZKhOg0jG+rQnWeSF4WjHfCpGYstTqybAofmz9HUcbHCTSYcqHP8I2XNzrjlq8he4mnDQSo14YgGE/wjubvbEPhyvKbyP4ZRt8pirQTwLCNPBDBpgTazRN8AH+4bPUD/LpnlFMU2RRu+apUdarb0gdyODcgjYWrr74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBHlukKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBHlukKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933271F000C4;
	Sat, 17 Oct 2026 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254959;
	bh=NLX8Co2E3vb0lTZ59/Qyt3OymZ+K7omIgfCEYDHXXPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBHlukKoNsKAXxX2Z6+xNTxM/TT0p4XLMet0InBpYfkhoffKgpccwsW9K8bGMoYpM
	 6bJRHwttoCv4IUCiOz8ILDdZaUPWXcD38SqKGRe8BQeb6bGAz4H29KckzCG95Phv3v
	 t8ORYV4UiYReESq98sLl9dvdXv2xzzwqcFtq1H/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyenghwan Hwang <obnred@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 619/869] ksmbd: detach blocked lock requests before freeing
Date: Sat, 17 Oct 2026 17:57:40 +0200
Message-ID: <20261017160052.900419017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 215e8816b1ac25176d911abb8704390413ccee4b ]

A file_lock retained by ksmbd for byte-range lock bookkeeping can still
be part of the VFS blocked-request graph. In particular, the VFS can
chain a new waiter below an already blocked request through
flc_blocked_requests. The ksmbd_file reference count does not cover that
graph.

Both __ksmbd_close_fd() and the cross-request unlock path free these
retained file_lock objects directly. If a dependent waiter is still
attached, locks_release_private() hits
BUG_ON(!list_empty(&flc->flc_blocked_requests)). The same lifetime
mismatch can leave a freed ksmbd_lock reachable through its request-local
llist.

Detach the file_lock from the blocked-request graph before freeing it in
the close, cross-request unlock, and rollback paths. locks_delete_block()
also wakes requests chained below the object. Remove llist when a
completed lock is published so a globally visible ksmbd_lock no longer
points into the submitting worker's stack.

Fixes: d63528eb0d43 ("ksmbd: free ksmbd_lock when file is closed")
Reported-by: Kyenghwan Hwang <obnred@gmail.com>
Tested-by: Kyenghwan Hwang <obnred@gmail.com>
Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 14 ++++++++++----
 fs/smb/server/vfs_cache.c |  8 +++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0785f921aec06..b2d4c30571d6c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7524,6 +7524,12 @@ static void smb2_remove_blocked_lock(void **argv)
 	locks_wake_up(flock);
 }
 
+static void smb2_free_lock(struct file_lock *flock)
+{
+	ksmbd_vfs_posix_lock_unblock(flock);
+	locks_free_lock(flock);
+}
+
 static inline bool lock_defer_pending(struct file_lock *fl)
 {
 	/* check pending lock waiters */
@@ -7677,14 +7683,14 @@ int smb2_lock(struct ksmbd_work *work)
 					    cmp_lock->end == smb_lock->end &&
 					    !lock_defer_pending(cmp_lock->fl)) {
 						nolock = 0;
-						list_del(&cmp_lock->flist);
-						list_del(&cmp_lock->clist);
+						list_del_init(&cmp_lock->flist);
+						list_del_init(&cmp_lock->clist);
 						cmp_lock->conn = NULL;
 						spin_unlock(&conn->llist_lock);
 						up_read(&conn_list_lock);
 
 						ksmbd_conn_put(conn);
-						locks_free_lock(cmp_lock->fl);
+						smb2_free_lock(cmp_lock->fl);
 						kfree(cmp_lock);
 						goto out_check_cl;
 					}
@@ -7882,7 +7888,7 @@ int smb2_lock(struct ksmbd_work *work)
 		spin_unlock(&conn->llist_lock);
 		ksmbd_conn_put(conn);
 
-		locks_free_lock(smb_lock->fl);
+		smb2_free_lock(smb_lock->fl);
 		if (rlock)
 			locks_free_lock(rlock);
 		kfree(smb_lock);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index ce6e9886df8be..970b8f185aacd 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -388,8 +388,9 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 	if (!IS_ERR_OR_NULL(filp))
 		fput(filp);
 
-	/* because the reference count of fp is 0, it is guaranteed that
-	 * there are not accesses to fp->lock_list.
+	/*
+	 * The zero fp reference count serializes access to fp->lock_list, but
+	 * the VFS may still have blocked requests chained below these locks.
 	 */
 	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
 		struct ksmbd_conn *conn = smb_lock->conn;
@@ -402,7 +403,8 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 			ksmbd_conn_put(conn);
 		}
 
-		list_del(&smb_lock->flist);
+		list_del_init(&smb_lock->flist);
+		ksmbd_vfs_posix_lock_unblock(smb_lock->fl);
 		locks_free_lock(smb_lock->fl);
 		kfree(smb_lock);
 	}
-- 
2.53.0



