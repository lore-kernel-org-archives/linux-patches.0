Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373FA51DE1C;
	Wed, 30 Sep 2026 18:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793862; cv=none; b=E0fWxvlh/q17kEsMUTvDfHrxxvMt0OW6BSJ/8R/XseChUnnFcUjmMOQQllvIKQWcGTA1hWwXliL8hQ01DSaF1mVx5Uy3wtQ5pF02RMgjXlRhskpta/GvxKg9JYOezx3IJFISeFXwHlnR5klTug0u6Qr/H5Y83XqrdsDiI22IV0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793862; c=relaxed/simple;
	bh=aZivDwVcNHGM738prAMp1BbYX3Z+HfBkwncVEl1QxmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knx4dkkY950ogtyhawbibPOe/MVI5y63xqTqhQxUeE9NyHJ1zQ6XsJTnJaKD2TiNFAWIVjDOMB1KJoE+VGbA43S5DcOG64OCMB1PVQhM5pUTERQZsB0yZQvt73PsKkmhJpnfbtVHrL7bZZwkLvG8xCDDCXeKXnNJ0YItoefuxhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdDmz/LV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdDmz/LV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CE11F000FF;
	Wed, 30 Sep 2026 18:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793861;
	bh=n4Y93jg8lFdoZtj2tmL0AQl9HF7z+m5jartgIPtYRk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdDmz/LVcQEPEpbr2/FxYcdkntCYVdSmQToby4FiWzzjXl5MpjscEcpxK/CZk84fH
	 9QKz7WrdWNhlbko4Sp9WaC1OuJDeRLAkzxWpWyAXBcb3g8VtcUPOJcjOTDSEPn+4P5
	 GFE/s3JIyMnnWS6XxQCEloHO3AccxbR5u1HaNFbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0001/1193] ksmbd: fix use-after-free in oplock break notification
Date: Wed, 30 Sep 2026 17:11:25 +0200
Message-ID: <20260930152434.340990881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

commit 0e753899627b5e28a9fea8bca98262a6f65a2452 upstream.

smb2_oplock_break_noti() reads opinfo->conn without any lock and
dereferences it after two allocations which may sleep.  When the
durable handle owning the oplock is disconnected, session_fd_check()
clears opinfo->conn and drops its conn reference under ci->m_lock, and
the last ksmbd_conn_put() frees the connection.  A break triggered by
another connection that races with the teardown can then resurrect the
freed connection: ksmbd_conn_get() is a plain atomic_inc, and the
queued break work later dereferences the stale conn via
ksmbd_conn_write(), a use-after-free reachable by any authenticated
client holding a durable batch oplock.

Thread the caller's inode into the notification path instead of taking
a new reference on it.  Every caller of oplock_break() already holds a
live ksmbd_file (or an explicit ksmbd_inode_lookup_lock() reference,
in the parent lease break paths) on the inode that owns the break
target's oplock list, so ci cannot be freed during the call, and its
lock can be taken without dereferencing opinfo->o_fp, which a
concurrent close may free.  Select and pin the connection under
ci->m_lock, the same lock session_fd_check() and
ksmbd_reopen_durable_fd() use to update opinfo->conn, so a concurrent
detach either loses the race to the clear or keeps the connection
alive until the notification work releases it.  Transfer the reference
to the work item and release it on allocation failures.

[ This tree predates the deferred break machinery
  (oplock_break_add()/oplock_break_drain_none()) that the original
  commit is layered on, so it is ported in the same patch: the three
  walks that hold ci->m_lock (smb_send_parent_lease_break_noti(),
  smb_lazy_parent_lease_break_close(), smb_break_all_levII_oplock())
  collect the breaks and drain them after releasing the lock, and
  every oplock_break() call site runs outside ci->m_lock, so
  smb2_oplock_break_conn_get() takes the read lock itself, as in the
  6.18.y backport. ]

Fixes: b003086d7696 ("ksmbd: fix NULL-deref of opinfo->conn in oplock/lease break notifiers")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 118 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 104 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 6f595756c41fd..296eb3db37355 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -708,31 +708,67 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 	ksmbd_conn_put(conn);
 }
 
+/*
+ * Select and pin the connection used for an oplock break before doing any
+ * allocations which may sleep.  The caller of oplock_break() holds a live
+ * reference on ci (a file being opened, a file being operated on, or an
+ * explicit ksmbd_inode_lookup_lock() reference in the parent lease break
+ * paths), so the inode cannot be freed during the call.
+ *
+ * opinfo->conn is cleared under ci->m_lock by session_fd_check() when the
+ * durable handle owning the oplock is disconnected, reassigned by
+ * ksmbd_reopen_durable_fd() under the same lock, and the last
+ * ksmbd_conn_put() of the old connection frees it.  Holding the read lock
+ * excludes both writers, so the connection cannot be freed while it is
+ * selected.
+ */
+static struct ksmbd_conn *smb2_oplock_break_conn_get(struct oplock_info *opinfo,
+						     struct ksmbd_inode *ci)
+{
+	struct ksmbd_conn *conn;
+
+	down_read(&ci->m_lock);
+	conn = READ_ONCE(opinfo->conn);
+	if (conn && !ksmbd_conn_releasing(conn))
+		conn = ksmbd_conn_get(conn);
+	else
+		conn = NULL;
+	up_read(&ci->m_lock);
+
+	return conn;
+}
+
 /**
  * smb2_oplock_break_noti() - send smb2 exclusive/batch to level2 oplock
  *		break command from server to client
  * @opinfo:		oplock info object
+ * @ci:		inode owning the break target's oplock list, pinned by
+ *		the caller
  *
  * Return:      0 on success, otherwise error
  */
-static int smb2_oplock_break_noti(struct oplock_info *opinfo)
+static int smb2_oplock_break_noti(struct oplock_info *opinfo,
+				  struct ksmbd_inode *ci)
 {
 	struct ksmbd_conn *conn;
 	struct oplock_break_info *br_info;
 	int ret = 0;
 	struct ksmbd_work *work;
 
-	conn = READ_ONCE(opinfo->conn);
+	conn = smb2_oplock_break_conn_get(opinfo, ci);
 	if (!conn)
 		return 0;
 
 	work = ksmbd_alloc_work_struct();
-	if (!work)
+	if (!work) {
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
+	}
 
 	br_info = kmalloc(sizeof(struct oplock_break_info), GFP_KERNEL);
 	if (!br_info) {
 		ksmbd_free_work_struct(work);
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
 	}
 
@@ -741,7 +777,8 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	br_info->open_trunc = opinfo->open_trunc;
 
 	work->request_buf = (char *)br_info;
-	work->conn = ksmbd_conn_get(conn);
+	/* Transfer the reference acquired by smb2_oplock_break_conn_get(). */
+	work->conn = conn;
 	work->sess = opinfo->sess;
 
 	ksmbd_conn_r_count_inc(conn);
@@ -890,8 +927,8 @@ static void wait_lease_breaking(struct oplock_info *opinfo)
 	}
 }
 
-static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
-			struct ksmbd_work *in_work)
+static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
+			int req_op_level, struct ksmbd_work *in_work)
 {
 	int err = 0;
 
@@ -957,7 +994,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 	if (brk_opinfo->is_lease)
 		err = smb2_lease_break_noti(brk_opinfo);
 	else
-		err = smb2_oplock_break_noti(brk_opinfo);
+		err = smb2_oplock_break_noti(brk_opinfo, ci);
 
 	ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
 	if (brk_opinfo->op_state == OPLOCK_CLOSING)
@@ -969,6 +1006,43 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 	return err;
 }
 
+struct oplock_break_entry {
+	struct list_head	list;
+	struct oplock_info	*opinfo;
+};
+
+/*
+ * Collect an oplock for a deferred break.  oplock_break() may block for
+ * the client's break acknowledgment, and the close that wakes that wait
+ * needs ci->m_lock for write, so the walks that hold ci->m_lock defer the
+ * break until the lock is released.
+ */
+static int oplock_break_add(struct list_head *head, struct oplock_info *opinfo)
+{
+	struct oplock_break_entry *ent;
+
+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+
+	ent->opinfo = opinfo;
+	list_add_tail(&ent->list, head);
+	return 0;
+}
+
+static void oplock_break_drain_none(struct list_head *head,
+				    struct ksmbd_inode *ci)
+{
+	struct oplock_break_entry *ent, *tmp;
+
+	list_for_each_entry_safe(ent, tmp, head, list) {
+		oplock_break(ent->opinfo, ci, SMB2_OPLOCK_LEVEL_NONE, NULL);
+		list_del(&ent->list);
+		opinfo_put(ent->opinfo);
+		kfree(ent);
+	}
+}
+
 void destroy_lease_table(struct ksmbd_conn *conn)
 {
 	struct lease_table *lb, *lbtmp;
@@ -1112,6 +1186,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 {
 	struct oplock_info *opinfo;
 	struct ksmbd_inode *p_ci = NULL;
+	LIST_HEAD(brk_list);
 
 	if (lctx->version != 2)
 		return;
@@ -1137,12 +1212,14 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				continue;
 			}
 
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
-			opinfo_put(opinfo);
+			if (oplock_break_add(&brk_list, opinfo))
+				opinfo_put(opinfo);
 		}
 	}
 	up_read(&p_ci->m_lock);
 
+	oplock_break_drain_none(&brk_list, p_ci);
+
 	ksmbd_inode_put(p_ci);
 }
 
@@ -1150,6 +1227,7 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 {
 	struct oplock_info *opinfo;
 	struct ksmbd_inode *p_ci = NULL;
+	LIST_HEAD(brk_list);
 
 	rcu_read_lock();
 	opinfo = rcu_dereference(fp->f_opinfo);
@@ -1178,12 +1256,14 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 				continue;
 			}
 
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
-			opinfo_put(opinfo);
+			if (oplock_break_add(&brk_list, opinfo))
+				opinfo_put(opinfo);
 		}
 	}
 	up_read(&p_ci->m_lock);
 
+	oplock_break_drain_none(&brk_list, p_ci);
+
 	ksmbd_inode_put(p_ci);
 }
 
@@ -1280,7 +1360,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		goto op_break_not_needed;
 	}
 
-	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II, work);
+	err = oplock_break(prev_opinfo, fp->f_ci, SMB2_OPLOCK_LEVEL_II, work);
 	opinfo_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
@@ -1366,7 +1446,7 @@ static void smb_break_all_write_oplock(struct ksmbd_work *work,
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
-	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II, work);
+	oplock_break(brk_opinfo, fp->f_ci, SMB2_OPLOCK_LEVEL_II, work);
 	opinfo_put(brk_opinfo);
 }
 
@@ -1383,6 +1463,7 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 	struct oplock_info *op, *brk_op;
 	struct ksmbd_inode *ci;
 	struct ksmbd_conn *conn = work->conn;
+	LIST_HEAD(brk_list);
 
 	if (!test_share_config_flag(work->tcon->share_conf,
 				    KSMBD_SHARE_FLAG_OPLOCKS))
@@ -1430,12 +1511,21 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 			    SMB2_LEASE_KEY_SIZE))
 			goto next;
 		brk_op->open_trunc = is_trunc;
-		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE, NULL);
+
+		/*
+		 * Defer the break until ci->m_lock is released: oplock_break()
+		 * may block waiting for the break acknowledgment, and the
+		 * close that wakes that wait needs ci->m_lock for write.
+		 */
+		if (!oplock_break_add(&brk_list, brk_op))
+			continue;
 next:
 		opinfo_put(brk_op);
 	}
 	up_read(&ci->m_lock);
 
+	oplock_break_drain_none(&brk_list, ci);
+
 	if (op)
 		opinfo_put(op);
 }
-- 
2.53.0



