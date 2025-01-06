Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456C513E02D;
	Mon,  6 Jan 2025 15:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178800; cv=none; b=CS/xadeNfvNgdH25wTGXmZo+AT7IFk8O20cY/UVfX1YGqJy28sxVBaNp47Zofw25Oshtvu8rObgZk9kuFfqUqmNKlHL5ylpiMPvB19T0ahj23r3JnAf2JoSYx7Zzk1cSA2WJNUkpDLJB6XVz9ISUG7EtzYjqGvdC3nOtaXWeJyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178800; c=relaxed/simple;
	bh=gSTC7CZi/pRVPDd58NHVNxoWTddemfz9T+xTyjKoeew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbHLYjPBcshUS2CZ6tQa2E+8F0oNTGeiEUbMJWmJDKU5AHGKDB0G7pNZqgHZ/sqcdeiBb2W8PpozSF50c9drc/US7/rTKLHLAQupytuF3IofuvIv4Q3+o5EtYRh04C0vdTt1Tc8dOZua9A8hE5liB1gMtirC54bSBrh6o2Yb3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6ynNyIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6ynNyIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1C0C4CED2;
	Mon,  6 Jan 2025 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178800;
	bh=gSTC7CZi/pRVPDd58NHVNxoWTddemfz9T+xTyjKoeew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6ynNyICDM+l7/LHTMn4Oh0Ao/eUzBCUPIej2AKBXjBYCx+Zdq3C4v96VkJCTR157
	 uv77H3izkoBpNVX/3a+Hd6bIloIhp/qRdyaM1I1oBe5wQ/QoM9+zl1grIMvdCSyHBm
	 7oZxCsr3cjbRp4fLPeoJz6UrCslW8FqJMOYP14hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 096/168] ksmbd: fix racy issue from session lookup and expire
Date: Mon,  6 Jan 2025 16:16:44 +0100
Message-ID: <20250106151142.089605605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit b95629435b84b9ecc0c765995204a4d8a913ed52 ]

Increment the session reference count within the lock for lookup to avoid
racy issue with session expire.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-25737
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/auth.c              |  2 ++
 fs/ksmbd/mgmt/user_session.c |  6 +++++-
 fs/ksmbd/server.c            |  4 ++--
 fs/ksmbd/smb2pdu.c           | 27 ++++++++++++++-------------
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 9a08e6a90b94..3b776b5de7db 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -1010,6 +1010,8 @@ static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 
 	ses_enc_key = enc ? sess->smb3encryptionkey :
 		sess->smb3decryptionkey;
+	if (enc)
+		ksmbd_user_session_get(sess);
 	memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
 
 	return 0;
diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index 844db95e6651..1cee9733bdac 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -257,8 +257,10 @@ struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
 
 	down_read(&conn->session_lock);
 	sess = xa_load(&conn->sessions, id);
-	if (sess)
+	if (sess) {
 		sess->last_active = jiffies;
+		ksmbd_user_session_get(sess);
+	}
 	up_read(&conn->session_lock);
 	return sess;
 }
@@ -269,6 +271,8 @@ struct ksmbd_session *ksmbd_session_lookup_slowpath(unsigned long long id)
 
 	down_read(&sessions_table_lock);
 	sess = __session_lookup(id);
+	if (sess)
+		ksmbd_user_session_get(sess);
 	up_read(&sessions_table_lock);
 
 	return sess;
diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index da5b9678ad05..27d8d6c6fdac 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -241,14 +241,14 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	if (work->tcon)
 		ksmbd_tree_connect_put(work->tcon);
 	smb3_preauth_hash_rsp(work);
-	if (work->sess)
-		ksmbd_user_session_put(work->sess);
 	if (work->sess && work->sess->enc && work->encrypted &&
 	    conn->ops->encrypt_resp) {
 		rc = conn->ops->encrypt_resp(work);
 		if (rc < 0)
 			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
 	}
+	if (work->sess)
+		ksmbd_user_session_put(work->sess);
 
 	ksmbd_conn_write(work);
 }
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 0f97830d1ebc..7f9297a5f3ef 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -67,8 +67,10 @@ static inline bool check_session_id(struct ksmbd_conn *conn, u64 id)
 		return false;
 
 	sess = ksmbd_session_lookup_all(conn, id);
-	if (sess)
+	if (sess) {
+		ksmbd_user_session_put(sess);
 		return true;
+	}
 	pr_err("Invalid user session id: %llu\n", id);
 	return false;
 }
@@ -606,10 +608,8 @@ int smb2_check_user_session(struct ksmbd_work *work)
 
 	/* Check for validity of user session */
 	work->sess = ksmbd_session_lookup_all(conn, sess_id);
-	if (work->sess) {
-		ksmbd_user_session_get(work->sess);
+	if (work->sess)
 		return 1;
-	}
 	ksmbd_debug(SMB, "Invalid user session, Uid %llu\n", sess_id);
 	return -ENOENT;
 }
@@ -1722,29 +1722,35 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (conn->dialect != sess->dialect) {
 			rc = -EINVAL;
+			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
 
 		if (!(req->hdr.Flags & SMB2_FLAGS_SIGNED)) {
 			rc = -EINVAL;
+			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
 
 		if (strncmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
+			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
 
 		if (sess->state == SMB2_SESSION_IN_PROGRESS) {
 			rc = -EACCES;
+			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
 
 		if (sess->state == SMB2_SESSION_EXPIRED) {
 			rc = -EFAULT;
+			ksmbd_user_session_put(sess);
 			goto out_err;
 		}
+		ksmbd_user_session_put(sess);
 
 		if (ksmbd_conn_need_reconnect(conn)) {
 			rc = -EFAULT;
@@ -1752,7 +1758,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (ksmbd_session_lookup(conn, sess_id)) {
+		sess = ksmbd_session_lookup(conn, sess_id);
+		if (!sess) {
 			rc = -EACCES;
 			goto out_err;
 		}
@@ -1763,7 +1770,6 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		}
 
 		conn->binding = true;
-		ksmbd_user_session_get(sess);
 	} else if ((conn->dialect < SMB30_PROT_ID ||
 		    server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
 		   (req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
@@ -1790,7 +1796,6 @@ int smb2_sess_setup(struct ksmbd_work *work)
 		}
 
 		conn->binding = false;
-		ksmbd_user_session_get(sess);
 	}
 	work->sess = sess;
 
@@ -2202,9 +2207,9 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 int smb2_session_logoff(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
+	struct ksmbd_session *sess = work->sess;
 	struct smb2_logoff_req *req;
 	struct smb2_logoff_rsp *rsp;
-	struct ksmbd_session *sess;
 	u64 sess_id;
 	int err;
 
@@ -2226,11 +2231,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	ksmbd_close_session_fds(work);
 	ksmbd_conn_wait_idle(conn, sess_id);
 
-	/*
-	 * Re-lookup session to validate if session is deleted
-	 * while waiting request complete
-	 */
-	sess = ksmbd_session_lookup_all(conn, sess_id);
 	if (ksmbd_tree_conn_session_logoff(sess)) {
 		ksmbd_debug(SMB, "Invalid tid %d\n", req->hdr.Id.SyncId.TreeId);
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
@@ -8660,6 +8660,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		       le64_to_cpu(tr_hdr->SessionId));
 		return -ECONNABORTED;
 	}
+	ksmbd_user_session_put(sess);
 
 	iov[0].iov_base = buf;
 	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
-- 
2.39.5



