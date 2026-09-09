Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B991D58596D;
	Wed,  9 Sep 2026 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964441; cv=none; b=ii6aggvMW51yfTOrJ9i/7hHMehpSgth3asyCwUnC98jxBVVEALBmoi9E/Rie5CJ/n7cBnl0AyLmVM5ZXtfhGS4CN5YELcnQQ5HXxdMUg+y89O+kOdDPv1P4m+jhfubbUxgtMI56VM4rpbiYrP/a7MTeuFJt7tt4Vr6BirtwK8rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964441; c=relaxed/simple;
	bh=uo3zeYxgD8FTSNV0IQa3RS0yubSzQ9KmHOFkxHkmWi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FP81FQgYdrjKOU+rVgGl6YhXbCUOoExHLBVUDVyyGuCCQWtDmdn2Vnf+qVKTbGl0QrgliwpCVByOdoqtyVlOojHN6K558xEg0rsRYw5TpZUTK6V9OaxPbm6mfhAYEetrDaz+sybk6uUQvmZFFOxrqZR13QxTATeoOIJsa3tqiTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLAYZvT8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLAYZvT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9D01F0155C;
	Wed,  9 Sep 2026 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964439;
	bh=BuZ7MVXwYoSiqUw5ZtzP1f8H0oJXyEVTbLI6yT+mAxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLAYZvT8bv093pR1KO7WVdTjnFzplx3ldcY/Zviv0p6fQiJZ/Uf3mdQhalS6rEWI1
	 58wKIm56y8/Jw9Cchkk3S88qzAIYiE36tlNM/Bx9LhuQlPsquyQp0kvQa5tPDHn+Tb
	 taMXM2NW8iLxEpggnpygiMQUXyrwzmUmEZoxpVhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 422/583] ksmbd: fix use-after-free in oplock break notification
Date: Wed,  9 Sep 2026 15:41:47 +0200
Message-ID: <20260909134252.595417594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

Fixes: b003086d7696 ("ksmbd: fix NULL-deref of opinfo->conn in oplock/lease break notifiers")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   61 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 12 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -708,31 +708,67 @@ out:
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
 
 	br_info = kmalloc(sizeof(struct oplock_break_info), KSMBD_DEFAULT_GFP);
 	if (!br_info) {
 		ksmbd_free_work_struct(work);
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
 	}
 
@@ -741,7 +777,8 @@ static int smb2_oplock_break_noti(struct
 	br_info->open_trunc = opinfo->open_trunc;
 
 	work->request_buf = (char *)br_info;
-	work->conn = ksmbd_conn_get(conn);
+	/* Transfer the reference acquired by smb2_oplock_break_conn_get(). */
+	work->conn = conn;
 	work->sess = opinfo->sess;
 
 	ksmbd_conn_r_count_inc(conn);
@@ -890,8 +927,8 @@ static void wait_lease_breaking(struct o
 	}
 }
 
-static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
-			struct ksmbd_work *in_work)
+static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
+			int req_op_level, struct ksmbd_work *in_work)
 {
 	int err = 0;
 
@@ -957,7 +994,7 @@ static int oplock_break(struct oplock_in
 	if (brk_opinfo->is_lease)
 		err = smb2_lease_break_noti(brk_opinfo);
 	else
-		err = smb2_oplock_break_noti(brk_opinfo);
+		err = smb2_oplock_break_noti(brk_opinfo, ci);
 
 	ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
 	if (brk_opinfo->op_state == OPLOCK_CLOSING)
@@ -1137,7 +1174,7 @@ void smb_send_parent_lease_break_noti(st
 				continue;
 			}
 
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
+			oplock_break(opinfo, p_ci, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_put(opinfo);
 		}
 	}
@@ -1178,7 +1215,7 @@ void smb_lazy_parent_lease_break_close(s
 				continue;
 			}
 
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
+			oplock_break(opinfo, p_ci, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_put(opinfo);
 		}
 	}
@@ -1280,7 +1317,7 @@ int smb_grant_oplock(struct ksmbd_work *
 		goto op_break_not_needed;
 	}
 
-	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II, work);
+	err = oplock_break(prev_opinfo, fp->f_ci, SMB2_OPLOCK_LEVEL_II, work);
 	opinfo_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
@@ -1366,7 +1403,7 @@ static void smb_break_all_write_oplock(s
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
-	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II, work);
+	oplock_break(brk_opinfo, fp->f_ci, SMB2_OPLOCK_LEVEL_II, work);
 	opinfo_put(brk_opinfo);
 }
 
@@ -1430,7 +1467,7 @@ void smb_break_all_levII_oplock(struct k
 			    SMB2_LEASE_KEY_SIZE))
 			goto next;
 		brk_op->open_trunc = is_trunc;
-		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE, NULL);
+		oplock_break(brk_op, ci, SMB2_OPLOCK_LEVEL_NONE, NULL);
 next:
 		opinfo_put(brk_op);
 	}


