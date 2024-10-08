Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3811DE4CC;
	Tue,  8 Oct 2024 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393524; cv=none; b=keMEtJS5NGgcHo74XxccfCsjfsDu4GwULVXoFLhmJHJPU7hc0dUuBLy/hJlm0a99iYmFVbB9VXbbWR4TAtuMXONxMTotLqc9vuvMmgyKaLAO6UhoCqRw5XPE2SJoYxVeFW9EmvhTtzlSeFaeBQKGiZj7c1tRznQgkcBXrESJQWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393524; c=relaxed/simple;
	bh=3oDBzZfNnZSI9c6BbxAwvnO4kl6osWRFofz9GQRhZZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOu3HZO0YQ6Cc2N1ozOgvTcIleuDtQ4heYhYZUDf8woagUqMNrQ+E6mfgxhHf3cMM+8gMbl7VJaWwzZDvlchrFbVyYyaT3AeoQSZKU8Du2+s+sJdpUDwMLed+9iHyak/JqqR6ps38cXbLlaiJ4TAWyk72iG1Ki9aJQwGSeHpjXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/Zs8V2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/Zs8V2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700AEC4CEC7;
	Tue,  8 Oct 2024 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393523;
	bh=3oDBzZfNnZSI9c6BbxAwvnO4kl6osWRFofz9GQRhZZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/Zs8V2wTgS4585W8YeOIAfAFVIilwVKbjNbVjTDPSJs9oD+y7R9lpBXhCmFZdyfV
	 RkcmlDsYS2kcq534OFU5ld+60UCDYU/4tme0muxL4zicyGWsJQERgCQKH9TrbHFohc
	 P8tZOa5kGCcYSAt1yFgzoAO7wg6UZMKhrnH5ZnmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/386] ksmbd: add refcnt to ksmbd_conn struct
Date: Tue,  8 Oct 2024 14:07:02 +0200
Message-ID: <20241008115636.382268163@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit ee426bfb9d09b29987369b897fe9b6485ac2be27 ]

When sending an oplock break request, opinfo->conn is used,
But freed ->conn can be used on multichannel.
This patch add a reference count to the ksmbd_conn struct
so that it can be freed when it is no longer used.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c |  4 ++-
 fs/smb/server/connection.h |  1 +
 fs/smb/server/oplock.c     | 55 +++++++++++---------------------------
 fs/smb/server/vfs_cache.c  |  3 +++
 4 files changed, 23 insertions(+), 40 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 7889df8112b4e..cac80e7bfefc7 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -39,7 +39,8 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
-	kfree(conn);
+	if (atomic_dec_and_test(&conn->refcnt))
+		kfree(conn);
 }
 
 /**
@@ -68,6 +69,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 		conn->um = NULL;
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
+	atomic_set(&conn->refcnt, 1);
 	conn->total_credits = 1;
 	conn->outstanding_credits = 0;
 
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index b93e5437793e0..82343afc8d049 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -106,6 +106,7 @@ struct ksmbd_conn {
 	bool				signing_negotiated;
 	__le16				signing_algorithm;
 	bool				binding;
+	atomic_t			refcnt;
 };
 
 struct ksmbd_conn_ops {
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index e546ffa57b55a..8ee86478287f9 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -51,6 +51,7 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 	init_waitqueue_head(&opinfo->oplock_brk);
 	atomic_set(&opinfo->refcount, 1);
 	atomic_set(&opinfo->breaking_cnt, 0);
+	atomic_inc(&opinfo->conn->refcnt);
 
 	return opinfo;
 }
@@ -124,6 +125,8 @@ static void free_opinfo(struct oplock_info *opinfo)
 {
 	if (opinfo->is_lease)
 		free_lease(opinfo);
+	if (opinfo->conn && atomic_dec_and_test(&opinfo->conn->refcnt))
+		kfree(opinfo->conn);
 	kfree(opinfo);
 }
 
@@ -163,9 +166,7 @@ static struct oplock_info *opinfo_get_list(struct ksmbd_inode *ci)
 		    !atomic_inc_not_zero(&opinfo->refcount))
 			opinfo = NULL;
 		else {
-			atomic_inc(&opinfo->conn->r_count);
 			if (ksmbd_conn_releasing(opinfo->conn)) {
-				atomic_dec(&opinfo->conn->r_count);
 				atomic_dec(&opinfo->refcount);
 				opinfo = NULL;
 			}
@@ -177,26 +178,11 @@ static struct oplock_info *opinfo_get_list(struct ksmbd_inode *ci)
 	return opinfo;
 }
 
-static void opinfo_conn_put(struct oplock_info *opinfo)
+void opinfo_put(struct oplock_info *opinfo)
 {
-	struct ksmbd_conn *conn;
-
 	if (!opinfo)
 		return;
 
-	conn = opinfo->conn;
-	/*
-	 * Checking waitqueue to dropping pending requests on
-	 * disconnection. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
-		wake_up(&conn->r_count_q);
-	opinfo_put(opinfo);
-}
-
-void opinfo_put(struct oplock_info *opinfo)
-{
 	if (!atomic_dec_and_test(&opinfo->refcount))
 		return;
 
@@ -1127,14 +1113,11 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
-			atomic_inc(&opinfo->conn->r_count);
-			if (ksmbd_conn_releasing(opinfo->conn)) {
-				atomic_dec(&opinfo->conn->r_count);
+			if (ksmbd_conn_releasing(opinfo->conn))
 				continue;
-			}
 
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
-			opinfo_conn_put(opinfo);
+			opinfo_put(opinfo);
 		}
 	}
 	up_read(&p_ci->m_lock);
@@ -1167,13 +1150,10 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
-			atomic_inc(&opinfo->conn->r_count);
-			if (ksmbd_conn_releasing(opinfo->conn)) {
-				atomic_dec(&opinfo->conn->r_count);
+			if (ksmbd_conn_releasing(opinfo->conn))
 				continue;
-			}
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
-			opinfo_conn_put(opinfo);
+			opinfo_put(opinfo);
 		}
 	}
 	up_read(&p_ci->m_lock);
@@ -1252,7 +1232,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	prev_opinfo = opinfo_get_list(ci);
 	if (!prev_opinfo ||
 	    (prev_opinfo->level == SMB2_OPLOCK_LEVEL_NONE && lctx)) {
-		opinfo_conn_put(prev_opinfo);
+		opinfo_put(prev_opinfo);
 		goto set_lev;
 	}
 	prev_op_has_lease = prev_opinfo->is_lease;
@@ -1262,19 +1242,19 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	if (share_ret < 0 &&
 	    prev_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		err = share_ret;
-		opinfo_conn_put(prev_opinfo);
+		opinfo_put(prev_opinfo);
 		goto err_out;
 	}
 
 	if (prev_opinfo->level != SMB2_OPLOCK_LEVEL_BATCH &&
 	    prev_opinfo->level != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		opinfo_conn_put(prev_opinfo);
+		opinfo_put(prev_opinfo);
 		goto op_break_not_needed;
 	}
 
 	list_add(&work->interim_entry, &prev_opinfo->interim_list);
 	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II);
-	opinfo_conn_put(prev_opinfo);
+	opinfo_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
 	/* Check all oplock was freed by close */
@@ -1337,14 +1317,14 @@ static void smb_break_all_write_oplock(struct ksmbd_work *work,
 		return;
 	if (brk_opinfo->level != SMB2_OPLOCK_LEVEL_BATCH &&
 	    brk_opinfo->level != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
-		opinfo_conn_put(brk_opinfo);
+		opinfo_put(brk_opinfo);
 		return;
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
 	list_add(&work->interim_entry, &brk_opinfo->interim_list);
 	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II);
-	opinfo_conn_put(brk_opinfo);
+	opinfo_put(brk_opinfo);
 }
 
 /**
@@ -1376,11 +1356,8 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 		if (!atomic_inc_not_zero(&brk_op->refcount))
 			continue;
 
-		atomic_inc(&brk_op->conn->r_count);
-		if (ksmbd_conn_releasing(brk_op->conn)) {
-			atomic_dec(&brk_op->conn->r_count);
+		if (ksmbd_conn_releasing(brk_op->conn))
 			continue;
-		}
 
 		rcu_read_unlock();
 		if (brk_op->is_lease && (brk_op->o_lease->state &
@@ -1411,7 +1388,7 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 		brk_op->open_trunc = is_trunc;
 		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE);
 next:
-		opinfo_conn_put(brk_op);
+		opinfo_put(brk_op);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 8b2e37c8716ed..271a23abc82fd 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -710,6 +710,8 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
 		if (op->conn != conn)
 			continue;
+		if (op->conn && atomic_dec_and_test(&op->conn->refcnt))
+			kfree(op->conn);
 		op->conn = NULL;
 	}
 	up_write(&ci->m_lock);
@@ -807,6 +809,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 		if (op->conn)
 			continue;
 		op->conn = fp->conn;
+		atomic_inc(&op->conn->refcnt);
 	}
 	up_write(&ci->m_lock);
 
-- 
2.43.0



