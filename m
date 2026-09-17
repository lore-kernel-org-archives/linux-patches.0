Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3101653B325;
	Thu, 17 Sep 2026 17:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664694; cv=none; b=mS3nssZk+AwLugirnuTZL/z3NFUqOBlZLbgjpiPHZQv2HHb/nPV1dVsZ4A8D9+Xyz7vk6OovNza3WJcUDynK1fhrp+ScAY0N3MoQC7Z9gFjpl1RI5YzGRISUdt26uL0UhOt1VquR4P7RyIH8/cHopGyo4iY8C4g7cr49PDgftlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664694; c=relaxed/simple;
	bh=M8JZtYYltaQxwjh6HsuCO+2HkeKUtH88cfaiMAUlDCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbhE9VP7RiyUErrGva5USVQeR5w/Wp3FkXOM3j93aXF2ePsJpVld7YB0pkUFHLoBJ8Qv/bR+01vAmlws3FBFZMPtM6zSWzNnRhJCYv5v62yx6IoLTyaImODsTEpzM3sIhlqdqnLXQ+JqlnIxsrwSw1m44rKIDLVGVMwKYe2hnEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YH2WKRq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YH2WKRq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1E71F000FF;
	Thu, 17 Sep 2026 17:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664693;
	bh=pfFOjMvV1B75sk4lPo2iO2Cf2UEUqY6u2wubE4GTqMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YH2WKRq73PYk/qLeDQTkJcKOE2GyXCabyCe/36vKVgWegYglsnooObRBlutz4QsEH
	 B1z9R491YdW/gF8OC80IKkVL/036E2MWXJqU/EXvu11G/95UUd3yJBSHHAFbsZgH4m
	 YlDp2K1WuNcy+rH7qTyxjw0rd+kjVxzkLKAcozYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0457/1250] ksmbd: use connection ClientGUID for lease lookup
Date: Thu, 17 Sep 2026 16:04:12 +0100
Message-ID: <20260917151604.371425008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index a98377f2a8030..7883ee63a0ff7 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -520,7 +520,7 @@ static inline int compare_guid_key(struct oplock_info *opinfo,
  * Return:      oplock(lease) object on success, otherwise NULL
  */
 static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
-						 char *client_guid,
+						 const char *client_guid,
 						 struct lease_ctx_info *lctx)
 {
 	int ret;
@@ -1051,7 +1051,7 @@ void destroy_lease_table(struct ksmbd_conn *conn)
 	write_unlock(&lease_list_lock);
 }
 
-int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
+int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx)
 {
 	struct oplock_info *opinfo;
@@ -1068,7 +1068,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 	}
 
 	list_for_each_entry(lb, &lease_table_list, l_entry) {
-		if (!memcmp(lb->client_guid, sess->ClientGUID,
+		if (!memcmp(lb->client_guid, conn->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE))
 			goto found;
 	}
@@ -1084,7 +1084,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 		rcu_read_unlock();
 		if (opinfo->o_fp->f_ci == ci)
 			goto op_next;
-		err = compare_guid_key(opinfo, sess->ClientGUID,
+		err = compare_guid_key(opinfo, conn->ClientGUID,
 				       lctx->lease_key);
 		if (err) {
 			err = -EINVAL;
@@ -1117,6 +1117,9 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
 	lease2->flags = lease1->flags;
 	lease2->epoch = lease1->epoch;
 	lease2->version = lease1->version;
+	lease2->is_dir = lease1->is_dir;
+	memcpy(lease2->parent_lease_key, lease1->parent_lease_key,
+	       SMB2_LEASE_KEY_SIZE);
 }
 
 static void add_lease_global_list(struct oplock_info *opinfo,
@@ -1255,7 +1258,6 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		     struct ksmbd_file *fp, __u16 tid,
 		     struct lease_ctx_info *lctx, int share_ret)
 {
-	struct ksmbd_session *sess = work->sess;
 	int err = 0;
 	struct oplock_info *opinfo = NULL, *prev_opinfo = NULL;
 	struct ksmbd_inode *ci = fp->f_ci;
@@ -1298,12 +1300,12 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
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
index d91a8266e065e..795a9119dad9a 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -116,7 +116,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
-int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
+int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx);
 void destroy_lease_table(struct ksmbd_conn *conn);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8d8d5baa58121..c15dde5193d4b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3533,7 +3533,7 @@ int smb2_open(struct ksmbd_work *work)
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



