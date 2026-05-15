Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409A03FBB53;
	Fri, 15 May 2026 16:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861765; cv=none; b=oZrLfUIYEL89130CJnaWfdjfBPOJKKe9mltf0UBZ6lNGC5SkMjXC0yRQe2d9h8YZY+5rEuGamXA6AzWJY0G5uN3rvT4OynqCm5vTYOwYEJA8UjJkXtCPkobzezRV+FcFM5wpcwdRRs7Iv2t6Ojo3dPNZ0XNaOI54mUYHXrR46LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861765; c=relaxed/simple;
	bh=fnfGsauvpqQD1/PqwjE84FGuhDOOAGpCYN2TtKfW4x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUHAqVg+Im7XIHP9DBOVhXd97ebemmoZgUmdf/QnKBFniy6lg8YoMqv43PgwWVgOchS0HIuFKd+JXUcTa6TEsherRruQwHMaYu2hHPNk3YhaKM0rA6I1SmHeofzAZcthhRafNMlbE/gnRvgfAjV6xtdto5WD8qkWbnopqdYCNp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7Am80nI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7Am80nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D6DC2BCB0;
	Fri, 15 May 2026 16:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861765;
	bh=fnfGsauvpqQD1/PqwjE84FGuhDOOAGpCYN2TtKfW4x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7Am80nIlqi/4U2iu4/2tJXKwjUCt3noX3KJVcaRmjcbDJfoWTuQ5oT5DKRDu63dT
	 so576SGGr/dEpx4yluMO4xX7QxEYyveUFugrgkY8RzOLiQqhJ6I+De3h6QYbRTCedo
	 35pfeLKAxs0XmFYDHYMKEFPrivH1/wIjf9gFHLUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	munan Huang <munanevil@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.6 453/474] ksmbd: fix use-after-free in __ksmbd_close_fd() via durable scavenger
Date: Fri, 15 May 2026 17:49:22 +0200
Message-ID: <20260515154724.894928968@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

commit 235e32320a470fcd3998fb3774f2290a0eb302a1 upstream.

When a durable file handle survives session disconnect (TCP close without
SMB2_LOGOFF), session_fd_check() sets fp->conn = NULL to preserve the
handle for later reconnection. However, it did not clean up the byte-range
locks on fp->lock_list.

Later, when the durable scavenger thread times out and calls
__ksmbd_close_fd(NULL, fp), the lock cleanup loop did:

    spin_lock(&fp->conn->llist_lock);

This caused a slab use-after-free because fp->conn was NULL and the
original connection object had already been freed by
ksmbd_tcp_disconnect().

The root cause is asymmetric cleanup: lock entries (smb_lock->clist) were
left dangling on the freed conn->lock_list while fp->conn was nulled out.

To fix this issue properly, we need to handle the lifetime of
smb_lock->clist across three paths:
 - Safely skip clist deletion when list is empty and fp->conn is NULL.
 - Remove the lock from the old connection's lock_list in
   session_fd_check()
 - Re-add the lock to the new connection's lock_list in
   ksmbd_reopen_durable_fd().

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Co-developed-by: munan Huang <munanevil@gmail.com>
Signed-off-by: munan Huang <munanevil@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Minor context conflict resolved. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -356,9 +356,11 @@ static void __ksmbd_close_fd(struct ksmb
 	 * there are not accesses to fp->lock_list.
 	 */
 	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
-		spin_lock(&fp->conn->llist_lock);
-		list_del(&smb_lock->clist);
-		spin_unlock(&fp->conn->llist_lock);
+		if (!list_empty(&smb_lock->clist) && fp->conn) {
+			spin_lock(&fp->conn->llist_lock);
+			list_del(&smb_lock->clist);
+			spin_unlock(&fp->conn->llist_lock);
+		}
 
 		list_del(&smb_lock->flist);
 		locks_free_lock(smb_lock->fl);
@@ -755,6 +757,7 @@ static bool session_fd_check(struct ksmb
 	struct ksmbd_inode *ci;
 	struct oplock_info *op;
 	struct ksmbd_conn *conn;
+	struct ksmbd_lock *smb_lock, *tmp_lock;
 
 	if (!is_reconnectable(fp))
 		return false;
@@ -771,6 +774,12 @@ static bool session_fd_check(struct ksmb
 	}
 	up_write(&ci->m_lock);
 
+	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
+		spin_lock(&fp->conn->llist_lock);
+		list_del_init(&smb_lock->clist);
+		spin_unlock(&fp->conn->llist_lock);
+	}
+
 	fp->conn = NULL;
 	fp->tcon = NULL;
 	fp->volatile_id = KSMBD_NO_FID;
@@ -844,6 +853,9 @@ int ksmbd_reopen_durable_fd(struct ksmbd
 {
 	struct ksmbd_inode *ci;
 	struct oplock_info *op;
+	struct ksmbd_conn *conn = work->conn;
+	struct ksmbd_lock *smb_lock;
+	unsigned int old_f_state;
 
 	if (!fp->is_durable || fp->conn || fp->tcon) {
 		pr_err("Invalid durable fd [%p:%p]\n", fp->conn, fp->tcon);
@@ -855,9 +867,23 @@ int ksmbd_reopen_durable_fd(struct ksmbd
 		return -EBADF;
 	}
 
-	fp->conn = work->conn;
+	old_f_state = fp->f_state;
+	fp->f_state = FP_NEW;
+	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
+	if (!has_file_id(fp->volatile_id)) {
+		fp->f_state = old_f_state;
+		return -EBADF;
+	}
+
+	fp->conn = conn;
 	fp->tcon = work->tcon;
 
+	list_for_each_entry(smb_lock, &fp->lock_list, flist) {
+		spin_lock(&conn->llist_lock);
+		list_add_tail(&smb_lock->clist, &conn->lock_list);
+		spin_unlock(&conn->llist_lock);
+	}
+
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
@@ -868,12 +894,6 @@ int ksmbd_reopen_durable_fd(struct ksmbd
 	}
 	up_write(&ci->m_lock);
 
-	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
-	if (!has_file_id(fp->volatile_id)) {
-		fp->conn = NULL;
-		fp->tcon = NULL;
-		return -EBADF;
-	}
 	return 0;
 }
 


