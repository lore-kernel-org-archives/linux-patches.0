Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6298E3D5645;
	Fri, 24 Apr 2026 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038112; cv=none; b=bTkuMSs35PmtZFkZC2U7RWyl3Y5szqx4vnABD8f5lmMpJQOLGbefJOw1mVdjAIgikUmdOAqtySkAo6fplJhIbUYX79nJxtLguCB5x5yA59/Re2/JoUv+EfNdmY0W1FRE9CmxZi73AblIDiIVMBHyG7RAt7AJP3MROIAwldm24pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038112; c=relaxed/simple;
	bh=QAR4SSkDTe1BcFo2DdU4Bg+fG16soJwT2YSm3q/Ipb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiU2g1ZVgsRvATHk2pw9mvP0FTGSUfFoJRM7a61TJgcvLK5EgXo0kZ1KqKiB8mIMs/kAQBFWDoLTATNaniaP+1zuUjUQGYBVL8FzMvt6jQB6F3xqTq5ahUWits6uwYpmYMXoi3Iuy/e5iv77kBiErO1FTP4ze7wVgDDktotbiXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrRBumsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrRBumsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDFFC19425;
	Fri, 24 Apr 2026 13:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038112;
	bh=QAR4SSkDTe1BcFo2DdU4Bg+fG16soJwT2YSm3q/Ipb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrRBumsM8XEYY/xg8fOnzy5NSbJXz9UObQsp4ZwsVcn+BDyJ6ANoK0ZDrTxlzSdPi
	 GvVxM8LXHqDxdC73rJ6nXzfsUcJj1bniN65xwiM45PsaNZ24JpSgtSaf/ZXII+jSNh
	 bWCQAA7JkhJKciqlUu0htBnfN65ehbSUkuS6tjVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Navaneeth K <knavaneeth786@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 09/55] ksmbd: validate owner of durable handle on reconnect
Date: Fri, 24 Apr 2026 15:30:48 +0200
Message-ID: <20260424132431.999743575@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 49110a8ce654bbe56bef7c5e44cce31f4b102b8a ]

Currently, ksmbd does not verify if the user attempting to reconnect
to a durable handle is the same user who originally opened the file.
This allows any authenticated user to hijack an orphaned durable handle
by predicting or brute-forcing the persistent ID.

According to MS-SMB2, the server MUST verify that the SecurityContext
of the reconnect request matches the SecurityContext associated with
the existing open.
Add a durable_owner structure to ksmbd_file to store the original opener's
UID, GID, and account name. and catpure the owner information when a file
handle becomes orphaned. and implementing ksmbd_vfs_compare_durable_owner()
to validate the identity of the requester during SMB2_CREATE (DHnC).

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Reported-by: Navaneeth K <knavaneeth786@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |    7 +--
 fs/smb/server/oplock.c            |    7 +++
 fs/smb/server/oplock.h            |    1 
 fs/smb/server/smb2pdu.c           |    3 -
 fs/smb/server/vfs_cache.c         |   87 ++++++++++++++++++++++++++++++++++----
 fs/smb/server/vfs_cache.h         |   12 ++++-
 6 files changed, 102 insertions(+), 15 deletions(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -161,11 +161,10 @@ void ksmbd_session_destroy(struct ksmbd_
 	if (!sess)
 		return;
 
+	ksmbd_tree_conn_session_logoff(sess);
+	ksmbd_destroy_file_table(sess);
 	if (sess->user)
 		ksmbd_free_user(sess->user);
-
-	ksmbd_tree_conn_session_logoff(sess);
-	ksmbd_destroy_file_table(&sess->file_table);
 	ksmbd_launch_ksmbd_durable_scavenger();
 	ksmbd_session_rpc_clear_list(sess);
 	free_channel_list(sess);
@@ -396,7 +395,7 @@ void destroy_previous_session(struct ksm
 		goto out;
 	}
 
-	ksmbd_destroy_file_table(&prev_sess->file_table);
+	ksmbd_destroy_file_table(prev_sess);
 	prev_sess->state = SMB2_SESSION_EXPIRED;
 	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_SETUP);
 	ksmbd_launch_ksmbd_durable_scavenger();
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1841,6 +1841,7 @@ int smb2_check_durable_oplock(struct ksm
 			      struct ksmbd_share_config *share,
 			      struct ksmbd_file *fp,
 			      struct lease_ctx_info *lctx,
+			      struct ksmbd_user *user,
 			      char *name)
 {
 	struct oplock_info *opinfo = opinfo_get(fp);
@@ -1849,6 +1850,12 @@ int smb2_check_durable_oplock(struct ksm
 	if (!opinfo)
 		return 0;
 
+	if (ksmbd_vfs_compare_durable_owner(fp, user) == false) {
+		ksmbd_debug(SMB, "Durable handle reconnect failed: owner mismatch\n");
+		ret = -EBADF;
+		goto out;
+	}
+
 	if (opinfo->is_lease == false) {
 		if (lctx) {
 			pr_err("create context include lease\n");
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -126,5 +126,6 @@ int smb2_check_durable_oplock(struct ksm
 			      struct ksmbd_share_config *share,
 			      struct ksmbd_file *fp,
 			      struct lease_ctx_info *lctx,
+			      struct ksmbd_user *user,
 			      char *name);
 #endif /* __KSMBD_OPLOCK_H */
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3022,7 +3022,8 @@ int smb2_open(struct ksmbd_work *work)
 		}
 
 		if (dh_info.reconnected == true) {
-			rc = smb2_check_durable_oplock(conn, share, dh_info.fp, lc, name);
+			rc = smb2_check_durable_oplock(conn, share, dh_info.fp,
+					lc, sess->user, name);
 			if (rc) {
 				ksmbd_put_durable_fd(dh_info.fp);
 				goto err_out2;
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -18,6 +18,7 @@
 #include "connection.h"
 #include "mgmt/tree_connect.h"
 #include "mgmt/user_session.h"
+#include "mgmt/user_config.h"
 #include "smb_common.h"
 #include "server.h"
 
@@ -383,6 +384,8 @@ static void __ksmbd_close_fd(struct ksmb
 
 	if (ksmbd_stream_fd(fp))
 		kfree(fp->stream.name);
+	kfree(fp->owner.name);
+
 	kmem_cache_free(filp_cache, fp);
 }
 
@@ -694,11 +697,13 @@ void ksmbd_update_fstate(struct ksmbd_fi
 }
 
 static int
-__close_file_table_ids(struct ksmbd_file_table *ft,
+__close_file_table_ids(struct ksmbd_session *sess,
 		       struct ksmbd_tree_connect *tcon,
 		       bool (*skip)(struct ksmbd_tree_connect *tcon,
-				    struct ksmbd_file *fp))
+				    struct ksmbd_file *fp,
+				    struct ksmbd_user *user))
 {
+	struct ksmbd_file_table *ft = &sess->file_table;
 	struct ksmbd_file *fp;
 	unsigned int id = 0;
 	int num = 0;
@@ -711,7 +716,7 @@ __close_file_table_ids(struct ksmbd_file
 			break;
 		}
 
-		if (skip(tcon, fp) ||
+		if (skip(tcon, fp, sess->user) ||
 		    !atomic_dec_and_test(&fp->refcount)) {
 			id++;
 			write_unlock(&ft->lock);
@@ -763,7 +768,8 @@ static inline bool is_reconnectable(stru
 }
 
 static bool tree_conn_fd_check(struct ksmbd_tree_connect *tcon,
-			       struct ksmbd_file *fp)
+			       struct ksmbd_file *fp,
+			       struct ksmbd_user *user)
 {
 	return fp->tcon != tcon;
 }
@@ -898,8 +904,62 @@ void ksmbd_stop_durable_scavenger(void)
 	kthread_stop(server_conf.dh_task);
 }
 
+/*
+ * ksmbd_vfs_copy_durable_owner - Copy owner info for durable reconnect
+ * @fp: ksmbd file pointer to store owner info
+ * @user: user pointer to copy from
+ *
+ * This function binds the current user's identity to the file handle
+ * to satisfy MS-SMB2 Step 8 (SecurityContext matching) during reconnect.
+ *
+ * Return: 0 on success, or negative error code on failure
+ */
+static int ksmbd_vfs_copy_durable_owner(struct ksmbd_file *fp,
+		struct ksmbd_user *user)
+{
+	if (!user)
+		return -EINVAL;
+
+	/* Duplicate the user name to ensure identity persistence */
+	fp->owner.name = kstrdup(user->name, GFP_KERNEL);
+	if (!fp->owner.name)
+		return -ENOMEM;
+
+	fp->owner.uid = user->uid;
+	fp->owner.gid = user->gid;
+
+	return 0;
+}
+
+/**
+ * ksmbd_vfs_compare_durable_owner - Verify if the requester is original owner
+ * @fp: existing ksmbd file pointer
+ * @user: user pointer of the reconnect requester
+ *
+ * Compares the UID, GID, and name of the current requester against the
+ * original owner stored in the file handle.
+ *
+ * Return: true if the user matches, false otherwise
+ */
+bool ksmbd_vfs_compare_durable_owner(struct ksmbd_file *fp,
+		struct ksmbd_user *user)
+{
+	if (!user || !fp->owner.name)
+		return false;
+
+	/* Check if the UID and GID match first (fast path) */
+	if (fp->owner.uid != user->uid || fp->owner.gid != user->gid)
+		return false;
+
+	/* Validate the account name to ensure the same SecurityContext */
+	if (strcmp(fp->owner.name, user->name))
+		return false;
+
+	return true;
+}
+
 static bool session_fd_check(struct ksmbd_tree_connect *tcon,
-			     struct ksmbd_file *fp)
+			     struct ksmbd_file *fp, struct ksmbd_user *user)
 {
 	struct ksmbd_inode *ci;
 	struct oplock_info *op;
@@ -909,6 +969,9 @@ static bool session_fd_check(struct ksmb
 	if (!is_reconnectable(fp))
 		return false;
 
+	if (ksmbd_vfs_copy_durable_owner(fp, user))
+		return false;
+
 	conn = fp->conn;
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
@@ -940,7 +1003,7 @@ static bool session_fd_check(struct ksmb
 
 void ksmbd_close_tree_conn_fds(struct ksmbd_work *work)
 {
-	int num = __close_file_table_ids(&work->sess->file_table,
+	int num = __close_file_table_ids(work->sess,
 					 work->tcon,
 					 tree_conn_fd_check);
 
@@ -949,7 +1012,7 @@ void ksmbd_close_tree_conn_fds(struct ks
 
 void ksmbd_close_session_fds(struct ksmbd_work *work)
 {
-	int num = __close_file_table_ids(&work->sess->file_table,
+	int num = __close_file_table_ids(work->sess,
 					 work->tcon,
 					 session_fd_check);
 
@@ -1046,6 +1109,10 @@ int ksmbd_reopen_durable_fd(struct ksmbd
 	}
 	up_write(&ci->m_lock);
 
+	fp->owner.uid = fp->owner.gid = 0;
+	kfree(fp->owner.name);
+	fp->owner.name = NULL;
+
 	return 0;
 }
 
@@ -1060,12 +1127,14 @@ int ksmbd_init_file_table(struct ksmbd_f
 	return 0;
 }
 
-void ksmbd_destroy_file_table(struct ksmbd_file_table *ft)
+void ksmbd_destroy_file_table(struct ksmbd_session *sess)
 {
+	struct ksmbd_file_table *ft = &sess->file_table;
+
 	if (!ft->idr)
 		return;
 
-	__close_file_table_ids(ft, NULL, session_fd_check);
+	__close_file_table_ids(sess, NULL, session_fd_check);
 	idr_destroy(ft->idr);
 	kfree(ft->idr);
 	ft->idr = NULL;
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -68,6 +68,13 @@ enum {
 	FP_CLOSED
 };
 
+/* Owner information for durable handle reconnect */
+struct durable_owner {
+	unsigned int uid;
+	unsigned int gid;
+	char *name;
+};
+
 struct ksmbd_file {
 	struct file			*filp;
 	u64				persistent_id;
@@ -114,6 +121,7 @@ struct ksmbd_file {
 	bool				is_resilient;
 
 	bool                            is_posix_ctxt;
+	struct durable_owner		owner;
 };
 
 static inline void set_ctx_actor(struct dir_context *ctx,
@@ -140,7 +148,7 @@ static inline bool ksmbd_stream_fd(struc
 }
 
 int ksmbd_init_file_table(struct ksmbd_file_table *ft);
-void ksmbd_destroy_file_table(struct ksmbd_file_table *ft);
+void ksmbd_destroy_file_table(struct ksmbd_session *sess);
 int ksmbd_close_fd(struct ksmbd_work *work, u64 id);
 struct ksmbd_file *ksmbd_lookup_fd_fast(struct ksmbd_work *work, u64 id);
 struct ksmbd_file *ksmbd_lookup_foreign_fd(struct ksmbd_work *work, u64 id);
@@ -166,6 +174,8 @@ void ksmbd_free_global_file_table(void);
 void ksmbd_set_fd_limit(unsigned long limit);
 void ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 			 unsigned int state);
+bool ksmbd_vfs_compare_durable_owner(struct ksmbd_file *fp,
+		struct ksmbd_user *user);
 
 /*
  * INODE hash


