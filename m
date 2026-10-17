Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF593839B2;
	Sat, 17 Oct 2026 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259993; cv=none; b=E5Rbvz8pZ+aPLembmk0muzFYxd8hLuOv2QZJqp3OfZ7QzkW8keoQljlKuDveI+yK8G2RCTX7srIq7FOR1OJc81pYe+sWv5OuoAl9G2MAXYlTA6J3kja+rclcdmKRUv07OKyy3sliBgVX2z46dPMmYZzfnOdTyUjpYseG1ov195Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259993; c=relaxed/simple;
	bh=yF0omd5LwZ34qjAVjHJfK8MLo0z45yid71izv01k+gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEeORaH2L38a1C5yWaKf529b+9Ya0xRM0an+hoTYUx5CQEFeVzSI/1Jw6+C4GF3AVOvEp/QVyDQtakansOJgSaCzYP3l80ghTOg/DIGCYfLuFMW6evg/XxlWxUfpE5G1ZvDYA4uUpJ2CbGMS1UtS1YUpuLSPiG07hNnrTZ5NALI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJ2MROdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJ2MROdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4951F000C4;
	Sat, 17 Oct 2026 17:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259991;
	bh=hJN8eX4O4Oj3uRW7UdeDOH8G83+f5t713sXtjSqoFb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJ2MROdIPdcS77CVnx7UXDM8Q2mSSEKj5Joupbv92zJh3hZD/7vRsvuhOP+IrZd7Q
	 M1h6e8yzSUCwwbwpWoNmLJr2HFbhbNkhtvQnEnZMg9g+QZI63kVYDUBbofVHbaVdnw
	 qTiLV3iOz9ttL5sLHnCutnctrtjhWYsaERIoHL4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyenghwan Hwang <obnred@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1396/1674] ksmbd: detach blocked lock requests before freeing
Date: Sat, 17 Oct 2026 18:01:08 +0200
Message-ID: <20261017160507.009130866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8f9f4f9360bbb..602b170c4bb5b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7506,6 +7506,12 @@ static void smb2_remove_blocked_lock(void **argv)
 	wake_up(&flock->fl_wait);
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
@@ -7659,14 +7665,14 @@ int smb2_lock(struct ksmbd_work *work)
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
@@ -7864,7 +7870,7 @@ int smb2_lock(struct ksmbd_work *work)
 		spin_unlock(&conn->llist_lock);
 		ksmbd_conn_put(conn);
 
-		locks_free_lock(smb_lock->fl);
+		smb2_free_lock(smb_lock->fl);
 		if (rlock)
 			locks_free_lock(rlock);
 		kfree(smb_lock);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 287858f6304ef..c96016417e918 100644
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



