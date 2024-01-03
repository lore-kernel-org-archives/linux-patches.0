Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2F81BDF0;
	Wed,  3 Jan 2024 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OruHDmOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A302BC433C8;
	Wed,  3 Jan 2024 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301587;
	bh=JwoXEJH7ReM9iPBmOIveOZmnsLz+08X6KHaTy+iZs6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OruHDmOzhssp/SLawhzZ04epYP8uTvHZL9pSyazxp2B8na94dMVSa2h4ZyH4m6mxk
	 vcEJlXQnAAXAJAp3ZF2aq5kcpdAhPWwXfGTwjk5RfxvMq37qBdadXAEG8lDpF3fxzj
	 8zCNM1SMSxV8slUXoL6v02r2g9rN7VDaOaJHutbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 70/95] ksmbd: send v2 lease break notification for directory
Date: Wed,  3 Jan 2024 17:55:18 +0100
Message-ID: <20240103164904.427694165@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit d47d9886aeef79feba7adac701a510d65f3682b5 ]

If client send different parent key, different client guid, or there is
no parent lease key flags in create context v2 lease, ksmbd send lease
break to client.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/oplock.c    | 56 ++++++++++++++++++++++++++++++++++++++++----
 fs/ksmbd/oplock.h    |  4 ++++
 fs/ksmbd/smb2pdu.c   |  7 ++++++
 fs/ksmbd/smb2pdu.h   |  1 +
 fs/ksmbd/vfs_cache.c | 13 +++++++++-
 fs/ksmbd/vfs_cache.h |  2 ++
 6 files changed, 77 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 600312e2c6c21..df6f00f58f19d 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -102,6 +102,7 @@ static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
 	lease->new_state = 0;
 	lease->flags = lctx->flags;
 	lease->duration = lctx->duration;
+	lease->is_dir = lctx->is_dir;
 	memcpy(lease->parent_lease_key, lctx->parent_lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->version = lctx->version;
 	lease->epoch = le16_to_cpu(lctx->epoch);
@@ -543,12 +544,13 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
 			     atomic_read(&ci->sop_count)) == 1) {
-				if (lease->state ==
-				    (lctx->req_state & lease->state)) {
+				if (lease->state != SMB2_LEASE_NONE_LE &&
+				    lease->state == (lctx->req_state & lease->state)) {
 					lease->state |= lctx->req_state;
 					if (lctx->req_state &
 						SMB2_LEASE_WRITE_CACHING_LE)
 						lease_read_to_write(opinfo);
+
 				}
 			} else if ((atomic_read(&ci->op_count) +
 				    atomic_read(&ci->sop_count)) > 1) {
@@ -900,7 +902,8 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level)
 					lease->new_state =
 						SMB2_LEASE_READ_CACHING_LE;
 			} else {
-				if (lease->state & SMB2_LEASE_HANDLE_CACHING_LE)
+				if (lease->state & SMB2_LEASE_HANDLE_CACHING_LE &&
+						!lease->is_dir)
 					lease->new_state =
 						SMB2_LEASE_READ_CACHING_LE;
 				else
@@ -1082,6 +1085,48 @@ static void set_oplock_level(struct oplock_info *opinfo, int level,
 	}
 }
 
+void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
+				      struct lease_ctx_info *lctx)
+{
+	struct oplock_info *opinfo;
+	struct ksmbd_inode *p_ci = NULL;
+
+	if (lctx->version != 2)
+		return;
+
+	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
+	if (!p_ci)
+		return;
+
+	read_lock(&p_ci->m_lock);
+	list_for_each_entry(opinfo, &p_ci->m_op_list, op_entry) {
+		if (!opinfo->is_lease)
+			continue;
+
+		if (opinfo->o_lease->state != SMB2_OPLOCK_LEVEL_NONE &&
+		    (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
+		     !compare_guid_key(opinfo, fp->conn->ClientGUID,
+				      lctx->parent_lease_key))) {
+			if (!atomic_inc_not_zero(&opinfo->refcount))
+				continue;
+
+			atomic_inc(&opinfo->conn->r_count);
+			if (ksmbd_conn_releasing(opinfo->conn)) {
+				atomic_dec(&opinfo->conn->r_count);
+				continue;
+			}
+
+			read_unlock(&p_ci->m_lock);
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
+			opinfo_conn_put(opinfo);
+			read_lock(&p_ci->m_lock);
+		}
+	}
+	read_unlock(&p_ci->m_lock);
+
+	ksmbd_inode_put(p_ci);
+}
+
 /**
  * smb_grant_oplock() - handle oplock/lease request on file open
  * @work:		smb work
@@ -1420,10 +1465,11 @@ struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-		if (is_dir)
+		if (is_dir) {
 			lreq->req_state = lc->lcontext.LeaseState &
 				~SMB2_LEASE_WRITE_CACHING_LE;
-		else
+			lreq->is_dir = true;
+		} else
 			lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->epoch = lc->lcontext.Epoch;
diff --git a/fs/ksmbd/oplock.h b/fs/ksmbd/oplock.h
index 672127318c750..b64d1536882a1 100644
--- a/fs/ksmbd/oplock.h
+++ b/fs/ksmbd/oplock.h
@@ -36,6 +36,7 @@ struct lease_ctx_info {
 	__u8			parent_lease_key[SMB2_LEASE_KEY_SIZE];
 	__le16			epoch;
 	int			version;
+	bool			is_dir;
 };
 
 struct lease_table {
@@ -54,6 +55,7 @@ struct lease {
 	__u8			parent_lease_key[SMB2_LEASE_KEY_SIZE];
 	int			version;
 	unsigned short		epoch;
+	bool			is_dir;
 	struct lease_table	*l_lb;
 };
 
@@ -125,4 +127,6 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx);
 void destroy_lease_table(struct ksmbd_conn *conn);
+void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
+				      struct lease_ctx_info *lctx);
 #endif /* __KSMBD_OPLOCK_H */
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 6a3cd6ea3af18..c1dde42043662 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3222,6 +3222,13 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	} else {
 		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
+			/*
+			 * Compare parent lease using parent key. If there is no
+			 * a lease that has same parent key, Send lease break
+			 * notification.
+			 */
+			smb_send_parent_lease_break_noti(fp, lc);
+
 			req_op_level = smb2_map_lease_to_oplock(lc->req_state);
 			ksmbd_debug(SMB,
 				    "lease req for(%s) req oplock state 0x%x, lease state 0x%x\n",
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index e1d0849ee68fd..912bd94257ecf 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -737,6 +737,7 @@ struct create_posix_rsp {
 #define SMB2_LEASE_WRITE_CACHING_LE		cpu_to_le32(0x04)
 
 #define SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE	cpu_to_le32(0x02)
+#define SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE	cpu_to_le32(0x04)
 
 #define SMB2_LEASE_KEY_SIZE			16
 
diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index 774a387fccced..2528ce8aeebbe 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -86,6 +86,17 @@ static struct ksmbd_inode *ksmbd_inode_lookup(struct ksmbd_file *fp)
 	return __ksmbd_inode_lookup(fp->filp->f_path.dentry);
 }
 
+struct ksmbd_inode *ksmbd_inode_lookup_lock(struct dentry *d)
+{
+	struct ksmbd_inode *ci;
+
+	read_lock(&inode_hash_lock);
+	ci = __ksmbd_inode_lookup(d);
+	read_unlock(&inode_hash_lock);
+
+	return ci;
+}
+
 int ksmbd_query_inode_status(struct dentry *dentry)
 {
 	struct ksmbd_inode *ci;
@@ -198,7 +209,7 @@ static void ksmbd_inode_free(struct ksmbd_inode *ci)
 	kfree(ci);
 }
 
-static void ksmbd_inode_put(struct ksmbd_inode *ci)
+void ksmbd_inode_put(struct ksmbd_inode *ci)
 {
 	if (atomic_dec_and_test(&ci->m_count))
 		ksmbd_inode_free(ci);
diff --git a/fs/ksmbd/vfs_cache.h b/fs/ksmbd/vfs_cache.h
index 8325cf4527c46..4d4938d6029b6 100644
--- a/fs/ksmbd/vfs_cache.h
+++ b/fs/ksmbd/vfs_cache.h
@@ -138,6 +138,8 @@ struct ksmbd_file *ksmbd_lookup_foreign_fd(struct ksmbd_work *work, u64 id);
 struct ksmbd_file *ksmbd_lookup_fd_slow(struct ksmbd_work *work, u64 id,
 					u64 pid);
 void ksmbd_fd_put(struct ksmbd_work *work, struct ksmbd_file *fp);
+struct ksmbd_inode *ksmbd_inode_lookup_lock(struct dentry *d);
+void ksmbd_inode_put(struct ksmbd_inode *ci);
 struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
-- 
2.43.0



