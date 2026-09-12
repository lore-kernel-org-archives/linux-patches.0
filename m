Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEEA365A0B;
	Sat, 12 Sep 2026 09:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204041; cv=none; b=c6drLDHFq782z04C50CnTt41rttPEWj2w1xv7vqIWzL8ScCGEYYAl1m2jfopxJVu3jMtGG59PH1a7sD/hh4BWHlR0kwrW/Zq+3J/cRFBDNVzm8sMCInjmIDzg4P+ex82XHA6F+63mjB8QZi9Om4x0uCGcdecCwXmP0GShBl8OEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204041; c=relaxed/simple;
	bh=kmAPSoval9eo3MKayIXUErZJ+b2brBeAWjboTfYEH/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkEMIel/rNqpv1hDMxkaxnOQCiNbOSJLW3CKxmsvcaqXk1QBn/TcQl2mKwz9FOT0EgsT7IbP1E76J1TuDiIhzDkBIyq/LS9JRciG+HdmXEwoQIIRt7UGMDucxQAGL3sQAE0qvFaU6nFyrht/oG3knhPdR4iRsWvTa41N0HDd1Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKCv9vL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKCv9vL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8A01F000FF;
	Sat, 12 Sep 2026 09:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204039;
	bh=ktk8YGzKcqlyqDs/QACM9M9f4LRtQUSfhi66QV3fLoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKCv9vL3evGLOOeCpK13zNO9j5lVyA2UPxEOvukKV3ItoenNaHy3YczRFhfRq5to5
	 KRQg8dEG+1BAKL3LE4RESQHtT0RRebkem0Z/BHzZPjDY/nPzgYJELRfOpCLPU4Q/tw
	 1RNcGhUR0JSS4ZNVkbIZs9wPvetYeJSgK6JNeWi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyenghwan Hwang <obnred@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1531/1815] ksmbd: detach blocked lock requests before freeing
Date: Sat, 12 Sep 2026 08:54:41 +0200
Message-ID: <20260912065724.947333061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/smb2pdu.c   | 17 ++++++++++++-----
 fs/smb/server/vfs_cache.c |  8 +++++---
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 42ca6125a510c..534416e2b599c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8522,6 +8522,12 @@ static void smb2_remove_blocked_lock(void **argv)
 	locks_wake_up(flock);
 }
 
+static void smb2_free_lock(struct file_lock *flock)
+{
+	ksmbd_vfs_posix_lock_unblock(flock);
+	locks_free_lock(flock);
+}
+
 static void smb2_free_blocked_lock(struct file_lock *flock)
 {
 	ksmbd_vfs_posix_lock_unblock(flock);
@@ -8714,14 +8720,14 @@ int smb2_lock(struct ksmbd_work *work)
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
@@ -8885,7 +8891,8 @@ int smb2_lock(struct ksmbd_work *work)
 	/* publish only once the whole batch has committed */
 	if (!list_empty(&rollback_list)) {
 		spin_lock(&work->conn->llist_lock);
-		list_for_each_entry(smb_lock, &rollback_list, llist) {
+		list_for_each_entry_safe(smb_lock, tmp, &rollback_list, llist) {
+			list_del_init(&smb_lock->llist);
 			smb_lock->conn = ksmbd_conn_get(work->conn);
 			list_add_tail(&smb_lock->clist,
 				      &work->conn->lock_list);
@@ -8925,7 +8932,7 @@ int smb2_lock(struct ksmbd_work *work)
 		}
 
 		list_del(&smb_lock->llist);
-		locks_free_lock(smb_lock->fl);
+		smb2_free_lock(smb_lock->fl);
 		if (rlock)
 			locks_free_lock(rlock);
 		kfree(smb_lock);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 460684624678f..9e5a3bfaefaf8 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -511,8 +511,9 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
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
@@ -525,7 +526,8 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
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



