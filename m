Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216384;
	b=tCdkNsdX3usHEBhLccZDIzFlrY2kxI+xQRcZ+U0m8eikjQLIjaCsfuhTYvw1CaxIeEF3
	 r2oW2/V6pE2YOZBZzTvabQOIAI58xl5Yx4LPm3mNwyZQxBlbAZ92S8AByMu11RbjaVVXp
	 yYiH1WYJJPjoSnVLX67KNuLSblXl70RVqtE6WcGRgurl6SP8C2sI1vqRY13qI4UL4xG4Y
	 eCJnLw0SecWcdI22VG8Azj4g0+gxAK5D3SSs1DexA5wQyV+9B1xF/2lv5LVqA9UMKiD3/
	 igNwHtqm89VbheurML4gb9+qOwJH00DTucSCHxkLQs0u5wxiqKA1lPODCNAJSenOJNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gzNmQ5gntO4jPI/Yok9LvwK0a1Tw57hHTShc3xdAzCU=;
	b=doEWHrr5TS+46VAq8shHbZlgLHNKqubbB2BqdjEo4qLOPTbf+esgdJLwPvOZzR8aUuCT
	 DSMhayLmMLK9GWHbjsVyYbzSEYlQD/A5m/Arz4eh6p0sZVj65RPERlTF4/0YiXA2nNhDB
	 TI9mCnaOhQMrFTGGd1slk7Il83hVQFfBJ2LeW6wYL88X1eKxVslw0qWqdFrdbgRvs2IqY
	 xB48odW7PIVbmrznMYO2vzmaaVS2m1qaGTPGZ1VldqVSxxK7zUeXg/DjsUSbbRLe2Q1GC
	 j2rPktwYn6k/Doahb69QgUmKk20LNBBBLH06fc+8CD06P9WxNWx90Vqi0pie1CjbsyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6cDCwjW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B405606A31C;
	Wed, 28 Oct 2026 19:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6cDCwjW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460B31F01825;
	Wed, 28 Oct 2026 19:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216383;
	bh=gzNmQ5gntO4jPI/Yok9LvwK0a1Tw57hHTShc3xdAzCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6cDCwjWMBU+G0hbIpD3gFEd6Fk3D7CKfQ4S4WccP6hPrZa4AWex0WkRK6gNYRet7
	 AuDdVpxACy2u7Hnp5DY+rDiEi4WQjYOSt+mkVwm3nEVEa59EGdc5qojuWeBGG2Nx0e
	 wasQqSdRgmZeiL3lB8sAp8v6rsbH5KI9a3ZSRRe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyenghwan Hwang <obnred@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1537/1887] ksmbd: detach blocked lock requests before freeing
Date: Wed, 28 Oct 2026 18:00:33 +0100
Message-ID: <20261028170534.443850971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 24506691be74e..f89b90eb9bf31 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7081,6 +7081,12 @@ static void smb2_remove_blocked_lock(void **argv)
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
@@ -7234,14 +7240,14 @@ int smb2_lock(struct ksmbd_work *work)
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
@@ -7439,7 +7445,7 @@ int smb2_lock(struct ksmbd_work *work)
 		spin_unlock(&conn->llist_lock);
 		ksmbd_conn_put(conn);
 
-		locks_free_lock(smb_lock->fl);
+		smb2_free_lock(smb_lock->fl);
 		if (rlock)
 			locks_free_lock(rlock);
 		kfree(smb_lock);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index f59abc34bbfe2..3eff8b7df9a2b 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -353,8 +353,9 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
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
@@ -367,7 +368,8 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
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



