Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55B3144307;
	Wed, 19 Jun 2024 13:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802045; cv=none; b=YWdIHhz1LQGQR7oEUdiePx4V1wIRmgpKNa7WN++a4RBnXDeEsYCaArwpB09f6bQTi1oloUsR3uqvQubzBPHsr8vduq4oUURlK7BH77SZgMpa5sf3KsyWoAeXQ8fqWE1q1GLWDuRy7vC4rizm/Oh5agtjBSzR5p62pVNsttulGx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802045; c=relaxed/simple;
	bh=R1o3n6NQonRhVzUkIML0U2EZUL7ldJtl9aQ4qIaLqVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsyOlY+hXCsPWdAHlKls9ErHSixHinB/gd+9FPgAV3XxEXsn7C6HxzMnl90McxkqjFe7POc4BKVmx1sOhPP/ddutDHmOVgPHe/E4Rp9q9Q6YebWND9CgTzaFfzlktK7doVeM2SOw1R1YqliqupU/OogCyy4Fr5kQnUdNmASznxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuiOlSDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuiOlSDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADC5C2BBFC;
	Wed, 19 Jun 2024 13:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802045;
	bh=R1o3n6NQonRhVzUkIML0U2EZUL7ldJtl9aQ4qIaLqVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuiOlSDsIvTKlWpBxQVGLhedMVuhKyMLpmlSJb0uTfMaMdeDdNGea6bV94EYT2L2w
	 hbkOKKwMShoncWoFqZ+pdVJ24Fo/iETL+wY989bE7yHkCNOWycTKO3zGoov4bT86eM
	 a0q4kkZnXeB9KiyzcnLx4I0kgL0CcOWjBbkZqYXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/267] ksmbd: use rwsem instead of rwlock for lease break
Date: Wed, 19 Jun 2024 14:53:35 +0200
Message-ID: <20240619125608.816010489@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

[ Upstream commit d1c189c6cb8b0fb7b5ee549237d27889c40c2f8b ]

lease break wait for lease break acknowledgment.
rwsem is more suitable than unlock while traversing the list for parent
lease break in ->m_op_list.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c     | 30 +++++++++++-------------------
 fs/smb/server/smb2pdu.c    |  4 ++--
 fs/smb/server/smb_common.c |  4 ++--
 fs/smb/server/vfs_cache.c  | 28 ++++++++++++++--------------
 fs/smb/server/vfs_cache.h  |  2 +-
 5 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 7d17a14378e33..a8f52c4ebbdad 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -207,9 +207,9 @@ static void opinfo_add(struct oplock_info *opinfo)
 {
 	struct ksmbd_inode *ci = opinfo->o_fp->f_ci;
 
-	write_lock(&ci->m_lock);
+	down_write(&ci->m_lock);
 	list_add_rcu(&opinfo->op_entry, &ci->m_op_list);
-	write_unlock(&ci->m_lock);
+	up_write(&ci->m_lock);
 }
 
 static void opinfo_del(struct oplock_info *opinfo)
@@ -221,9 +221,9 @@ static void opinfo_del(struct oplock_info *opinfo)
 		lease_del_list(opinfo);
 		write_unlock(&lease_list_lock);
 	}
-	write_lock(&ci->m_lock);
+	down_write(&ci->m_lock);
 	list_del_rcu(&opinfo->op_entry);
-	write_unlock(&ci->m_lock);
+	up_write(&ci->m_lock);
 }
 
 static unsigned long opinfo_count(struct ksmbd_file *fp)
@@ -526,21 +526,18 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 	 * Compare lease key and client_guid to know request from same owner
 	 * of same client
 	 */
-	read_lock(&ci->m_lock);
+	down_read(&ci->m_lock);
 	list_for_each_entry(opinfo, &ci->m_op_list, op_entry) {
 		if (!opinfo->is_lease || !opinfo->conn)
 			continue;
-		read_unlock(&ci->m_lock);
 		lease = opinfo->o_lease;
 
 		ret = compare_guid_key(opinfo, client_guid, lctx->lease_key);
 		if (ret) {
 			m_opinfo = opinfo;
 			/* skip upgrading lease about breaking lease */
-			if (atomic_read(&opinfo->breaking_cnt)) {
-				read_lock(&ci->m_lock);
+			if (atomic_read(&opinfo->breaking_cnt))
 				continue;
-			}
 
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
@@ -570,9 +567,8 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 				lease_none_upgrade(opinfo, lctx->req_state);
 			}
 		}
-		read_lock(&ci->m_lock);
 	}
-	read_unlock(&ci->m_lock);
+	up_read(&ci->m_lock);
 
 	return m_opinfo;
 }
@@ -1119,7 +1115,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	if (!p_ci)
 		return;
 
-	read_lock(&p_ci->m_lock);
+	down_read(&p_ci->m_lock);
 	list_for_each_entry(opinfo, &p_ci->m_op_list, op_entry) {
 		if (opinfo->conn == NULL || !opinfo->is_lease)
 			continue;
@@ -1137,13 +1133,11 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				continue;
 			}
 
-			read_unlock(&p_ci->m_lock);
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
 			opinfo_conn_put(opinfo);
-			read_lock(&p_ci->m_lock);
 		}
 	}
-	read_unlock(&p_ci->m_lock);
+	up_read(&p_ci->m_lock);
 
 	ksmbd_inode_put(p_ci);
 }
@@ -1164,7 +1158,7 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 	if (!p_ci)
 		return;
 
-	read_lock(&p_ci->m_lock);
+	down_read(&p_ci->m_lock);
 	list_for_each_entry(opinfo, &p_ci->m_op_list, op_entry) {
 		if (opinfo->conn == NULL || !opinfo->is_lease)
 			continue;
@@ -1178,13 +1172,11 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 				atomic_dec(&opinfo->conn->r_count);
 				continue;
 			}
-			read_unlock(&p_ci->m_lock);
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
 			opinfo_conn_put(opinfo);
-			read_lock(&p_ci->m_lock);
 		}
 	}
-	read_unlock(&p_ci->m_lock);
+	up_read(&p_ci->m_lock);
 
 	ksmbd_inode_put(p_ci);
 }
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6a15c5d64f415..8df93c9d4ee41 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3376,9 +3376,9 @@ int smb2_open(struct ksmbd_work *work)
 	 * after daccess, saccess, attrib_only, and stream are
 	 * initialized.
 	 */
-	write_lock(&fp->f_ci->m_lock);
+	down_write(&fp->f_ci->m_lock);
 	list_add(&fp->node, &fp->f_ci->m_fp_list);
-	write_unlock(&fp->f_ci->m_lock);
+	up_write(&fp->f_ci->m_lock);
 
 	/* Check delete pending among previous fp before oplock break */
 	if (ksmbd_inode_pending_delete(fp)) {
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index fcaf373cc0080..474dadf6b7b8b 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -646,7 +646,7 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 	 * Lookup fp in master fp list, and check desired access and
 	 * shared mode between previous open and current open.
 	 */
-	read_lock(&curr_fp->f_ci->m_lock);
+	down_read(&curr_fp->f_ci->m_lock);
 	list_for_each_entry(prev_fp, &curr_fp->f_ci->m_fp_list, node) {
 		if (file_inode(filp) != file_inode(prev_fp->filp))
 			continue;
@@ -722,7 +722,7 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 			break;
 		}
 	}
-	read_unlock(&curr_fp->f_ci->m_lock);
+	up_read(&curr_fp->f_ci->m_lock);
 
 	return rc;
 }
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 030f70700036c..6cb599cd287ee 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -165,7 +165,7 @@ static int ksmbd_inode_init(struct ksmbd_inode *ci, struct ksmbd_file *fp)
 	ci->m_fattr = 0;
 	INIT_LIST_HEAD(&ci->m_fp_list);
 	INIT_LIST_HEAD(&ci->m_op_list);
-	rwlock_init(&ci->m_lock);
+	init_rwsem(&ci->m_lock);
 	ci->m_de = fp->filp->f_path.dentry;
 	return 0;
 }
@@ -261,14 +261,14 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 	}
 
 	if (atomic_dec_and_test(&ci->m_count)) {
-		write_lock(&ci->m_lock);
+		down_write(&ci->m_lock);
 		if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
 			ci->m_flags &= ~(S_DEL_ON_CLS | S_DEL_PENDING);
-			write_unlock(&ci->m_lock);
+			up_write(&ci->m_lock);
 			ksmbd_vfs_unlink(filp);
-			write_lock(&ci->m_lock);
+			down_write(&ci->m_lock);
 		}
-		write_unlock(&ci->m_lock);
+		up_write(&ci->m_lock);
 
 		ksmbd_inode_free(ci);
 	}
@@ -289,9 +289,9 @@ static void __ksmbd_remove_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp
 	if (!has_file_id(fp->volatile_id))
 		return;
 
-	write_lock(&fp->f_ci->m_lock);
+	down_write(&fp->f_ci->m_lock);
 	list_del_init(&fp->node);
-	write_unlock(&fp->f_ci->m_lock);
+	up_write(&fp->f_ci->m_lock);
 
 	write_lock(&ft->lock);
 	idr_remove(ft->idr, fp->volatile_id);
@@ -523,17 +523,17 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry)
 	if (!ci)
 		return NULL;
 
-	read_lock(&ci->m_lock);
+	down_read(&ci->m_lock);
 	list_for_each_entry(lfp, &ci->m_fp_list, node) {
 		if (inode == file_inode(lfp->filp)) {
 			atomic_dec(&ci->m_count);
 			lfp = ksmbd_fp_get(lfp);
-			read_unlock(&ci->m_lock);
+			up_read(&ci->m_lock);
 			return lfp;
 		}
 	}
 	atomic_dec(&ci->m_count);
-	read_unlock(&ci->m_lock);
+	up_read(&ci->m_lock);
 	return NULL;
 }
 
@@ -705,13 +705,13 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 
 	conn = fp->conn;
 	ci = fp->f_ci;
-	write_lock(&ci->m_lock);
+	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
 		if (op->conn != conn)
 			continue;
 		op->conn = NULL;
 	}
-	write_unlock(&ci->m_lock);
+	up_write(&ci->m_lock);
 
 	fp->conn = NULL;
 	fp->tcon = NULL;
@@ -801,13 +801,13 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	fp->tcon = work->tcon;
 
 	ci = fp->f_ci;
-	write_lock(&ci->m_lock);
+	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
 		if (op->conn)
 			continue;
 		op->conn = fp->conn;
 	}
-	write_unlock(&ci->m_lock);
+	up_write(&ci->m_lock);
 
 	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
 	if (!has_file_id(fp->volatile_id)) {
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index ed44fb4e18e79..5a225e7055f19 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -47,7 +47,7 @@ struct stream {
 };
 
 struct ksmbd_inode {
-	rwlock_t			m_lock;
+	struct rw_semaphore		m_lock;
 	atomic_t			m_count;
 	atomic_t			op_count;
 	/* opinfo count for streams */
-- 
2.43.0



