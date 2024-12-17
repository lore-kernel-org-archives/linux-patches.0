Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E931F76C3;
	Tue, 17 Dec 2024 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455735; cv=none; b=GUcAaLCj3nmdXUz9xcrS9TItbErlu+jQw3vMPp0sUhuTkc4XKH2VoeeKFENqlG9iW9yGAJvR0TFda+yuP5OLtXR4N0J9aTiPYNgLUy6N6TF/HMqTWJJ0jncsLW3glY1GHnIWjx/H9L3Db7/tS55rem01hIVmA7oElp9fCcRuXeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455735; c=relaxed/simple;
	bh=3MdYlA+ZPy/ObZVo01+5NCSIxDkmEb2ZgXrsx9fs9MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XB+j+sr97KXu6aHp16kyVIWp2CTv5GWDSwVnADrpYWJ2cwUxMttbFsW3ZsNGWWcqj3rIQaK3ock/BnkPA9QC5ERVGvsX2P7wrD3ehsCD4I9SBenN1ppHPNAlgaCJbajiLtg2iaUiU+Fjin9tQgzDEohZ0v3I1/3EmQOoYjBnNDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEm+jR2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEm+jR2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F198C4CED3;
	Tue, 17 Dec 2024 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455735;
	bh=3MdYlA+ZPy/ObZVo01+5NCSIxDkmEb2ZgXrsx9fs9MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEm+jR2nBWy32m0qCtj4gmZ+W3a4hGoX4V4kp35HvI9JF8q3YKnUdx1OyBJrgKCLF
	 VC0t6u5nj62AFbxUX7ELI81YVvtIDyrXYGnrGbmIMswOdaLNp7Ucgr136eU5Ti0QmW
	 5D14XkuDmwjO58gDXlT9ODNdSSR2QG2Wg+SX6nDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 02/76] ksmbd: fix racy issue from session lookup and expire
Date: Tue, 17 Dec 2024 18:06:42 +0100
Message-ID: <20241217170526.341049487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit b95629435b84b9ecc0c765995204a4d8a913ed52 upstream.

Increment the session reference count within the lock for lookup to avoid
racy issue with session expire.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-25737
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c              |    2 ++
 fs/smb/server/mgmt/user_session.c |    6 +++++-
 fs/smb/server/server.c            |    4 ++--
 fs/smb/server/smb2pdu.c           |   27 ++++++++++++++-------------
 4 files changed, 23 insertions(+), 16 deletions(-)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -1010,6 +1010,8 @@ static int ksmbd_get_encryption_key(stru
 
 	ses_enc_key = enc ? sess->smb3encryptionkey :
 		sess->smb3decryptionkey;
+	if (enc)
+		ksmbd_user_session_get(sess);
 	memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
 
 	return 0;
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -262,8 +262,10 @@ struct ksmbd_session *ksmbd_session_look
 
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
@@ -274,6 +276,8 @@ struct ksmbd_session *ksmbd_session_look
 
 	down_read(&sessions_table_lock);
 	sess = __session_lookup(id);
+	if (sess)
+		ksmbd_user_session_get(sess);
 	up_read(&sessions_table_lock);
 
 	return sess;
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -241,14 +241,14 @@ send:
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
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -66,8 +66,10 @@ static inline bool check_session_id(stru
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
@@ -604,10 +606,8 @@ int smb2_check_user_session(struct ksmbd
 
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
@@ -1720,29 +1720,35 @@ int smb2_sess_setup(struct ksmbd_work *w
 
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
@@ -1750,7 +1756,8 @@ int smb2_sess_setup(struct ksmbd_work *w
 			goto out_err;
 		}
 
-		if (ksmbd_session_lookup(conn, sess_id)) {
+		sess = ksmbd_session_lookup(conn, sess_id);
+		if (!sess) {
 			rc = -EACCES;
 			goto out_err;
 		}
@@ -1761,7 +1768,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 		}
 
 		conn->binding = true;
-		ksmbd_user_session_get(sess);
 	} else if ((conn->dialect < SMB30_PROT_ID ||
 		    server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
 		   (req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
@@ -1788,7 +1794,6 @@ int smb2_sess_setup(struct ksmbd_work *w
 		}
 
 		conn->binding = false;
-		ksmbd_user_session_get(sess);
 	}
 	work->sess = sess;
 
@@ -2207,9 +2212,9 @@ err_out:
 int smb2_session_logoff(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
+	struct ksmbd_session *sess = work->sess;
 	struct smb2_logoff_req *req;
 	struct smb2_logoff_rsp *rsp;
-	struct ksmbd_session *sess;
 	u64 sess_id;
 	int err;
 
@@ -2231,11 +2236,6 @@ int smb2_session_logoff(struct ksmbd_wor
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
@@ -8682,6 +8682,7 @@ int smb3_decrypt_req(struct ksmbd_work *
 		       le64_to_cpu(tr_hdr->SessionId));
 		return -ECONNABORTED;
 	}
+	ksmbd_user_session_put(sess);
 
 	iov[0].iov_base = buf;
 	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;


