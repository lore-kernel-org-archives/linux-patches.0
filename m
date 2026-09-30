Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA0D511E8F;
	Wed, 30 Sep 2026 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784618; cv=none; b=G38iVl7KEuVs9pNpJlnUuEReP0kculvBtzw5v+Vvz7R2JWVwwFgWfoedK79for5LK+JSNnVUnWyPUNdgy1VWICmYHskXbEbTldLi0gn/Pu5sSpt/hiGMt6fHhbbLQS7is82MT/QiaAlQr2NfoRTmBflcnVo/HNIMPEVQdo5RgZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784618; c=relaxed/simple;
	bh=/H50R7wFAmiXT0IGtqVGHCeOsH9W2xoONWLkzDsl7yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9ppqR0TxWauoWDk6q9nqPQ+XSmnYDrC+K9gT1ei1GHrZuOf42FAOy3nSbZwzStIHmnIO3D5Ey3rIe9PRrK3VxyN0I4YGk1ClEKSRLb4WeEJPctW+ZrC7jckU3dqD9ZnnoM+HM9v+zcoj3JObVSOH64Uo+zEPzIHHRYZUtEbWxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsuWfqWJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsuWfqWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18871F00893;
	Wed, 30 Sep 2026 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784612;
	bh=ekh6Q2wGIvd0S4dnpUDyO6uVPP7fSnfRSz3g/h/+4Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsuWfqWJ2Utnro3JnK0y3C0uTnQx1L9J4pvx4cMPWsuhextbMxuykDl69uN2WxXpG
	 3V3WophNfI8v4D28B5y1U2+jFOw0htyCPxxk6hqPPL/Opy+Bo9vpfnIGVtkv8/ctte
	 fZpYY95Ki8KEGn2d2dk0G9JQhik0YweK9+DHwnb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/982] ksmbd: use connection ClientGUID for lease lookup
Date: Wed, 30 Sep 2026 17:15:54 +0200
Message-ID: <20260930152421.487910506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit fa111daae1a02dbff5693dfc12f368bccd9eb5f4 ]

MS-SMB2 defines the lease table lookup key as Connection.ClientGuid.
Use the connection ClientGUID consistently when checking for same-client
leases and duplicate lease keys.

Also preserve directory and parent lease metadata when copying an existing
lease state to a new open.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c  | 16 +++++++++-------
 fs/smb/server/oplock.h  |  2 +-
 fs/smb/server/smb2pdu.c |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 2414e103b79e3..0b71399af50cc 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -510,7 +510,7 @@ static inline int compare_guid_key(struct oplock_info *opinfo,
  * Return:      oplock(lease) object on success, otherwise NULL
  */
 static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
-						 char *client_guid,
+						 const char *client_guid,
 						 struct lease_ctx_info *lctx)
 {
 	int ret;
@@ -995,7 +995,7 @@ void destroy_lease_table(struct ksmbd_conn *conn)
 	write_unlock(&lease_list_lock);
 }
 
-int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
+int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx)
 {
 	struct oplock_info *opinfo;
@@ -1012,7 +1012,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 	}
 
 	list_for_each_entry(lb, &lease_table_list, l_entry) {
-		if (!memcmp(lb->client_guid, sess->ClientGUID,
+		if (!memcmp(lb->client_guid, conn->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE))
 			goto found;
 	}
@@ -1028,7 +1028,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 		rcu_read_unlock();
 		if (opinfo->o_fp->f_ci == ci)
 			goto op_next;
-		err = compare_guid_key(opinfo, sess->ClientGUID,
+		err = compare_guid_key(opinfo, conn->ClientGUID,
 				       lctx->lease_key);
 		if (err) {
 			err = -EINVAL;
@@ -1061,6 +1061,9 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
 	lease2->flags = lease1->flags;
 	lease2->epoch = lease1->epoch;
 	lease2->version = lease1->version;
+	lease2->is_dir = lease1->is_dir;
+	memcpy(lease2->parent_lease_key, lease1->parent_lease_key,
+	       SMB2_LEASE_KEY_SIZE);
 }
 
 static int add_lease_global_list(struct oplock_info *opinfo)
@@ -1209,7 +1212,6 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		     struct ksmbd_file *fp, __u16 tid,
 		     struct lease_ctx_info *lctx, int share_ret)
 {
-	struct ksmbd_session *sess = work->sess;
 	int err = 0;
 	struct oplock_info *opinfo = NULL, *prev_opinfo = NULL;
 	struct ksmbd_inode *ci = fp->f_ci;
@@ -1251,12 +1253,12 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		struct oplock_info *m_opinfo;
 
 		/* is lease already granted ? */
-		m_opinfo = same_client_has_lease(ci, sess->ClientGUID,
+		m_opinfo = same_client_has_lease(ci, work->conn->ClientGUID,
 						 lctx);
 		if (m_opinfo) {
 			copy_lease(m_opinfo, opinfo);
 			if (atomic_read(&m_opinfo->breaking_cnt))
-				opinfo->o_lease->flags =
+				opinfo->o_lease->flags |=
 					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
 			opinfo_put(m_opinfo);
 			goto out;
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 5b93ea9196c01..0e2b1d63ca26b 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -124,7 +124,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
-int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
+int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx);
 void destroy_lease_table(struct ksmbd_conn *conn);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4765edcff9dbd..e7cbc8944ca80 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3267,7 +3267,7 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB,
 				    "lease req for(%s) req oplock state 0x%x, lease state 0x%x\n",
 				    name, req_op_level, lc->req_state);
-			rc = find_same_lease_key(sess, fp->f_ci, lc);
+			rc = find_same_lease_key(conn, fp->f_ci, lc);
 			if (rc)
 				goto err_out1;
 		} else if (open_flags == O_RDONLY &&
-- 
2.53.0



