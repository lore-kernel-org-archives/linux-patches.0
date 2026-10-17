Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1123138F658;
	Sat, 17 Oct 2026 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259990; cv=none; b=iGE3z7O/DUQIOiEKwUvnPh0ZlRQJ+bonAHq7XL4eiHAXP/3X4/2ru8NpHu2VDjJvgpVbph3Tv4Yposk5qQhszJNN2kOGuDeYcQ0G5Bv9EqU+Z2eEtbZHCGglXfhF9dViKyPEetPg7/4yfZHhv/R8Pk7ZLylGgWqvqNeDlDBm1Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259990; c=relaxed/simple;
	bh=NizYdhhvT5om4ijBrBQcVs+10HBt9gcuCd+uNGTWMJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iT2/B2Jo+yle5gGIot2M2KJcyTaSTFmzLrPRn2ivU+IKSvHVmLZvc+EE/z/tPdoXB7GGTRXCfTi5B59rxZUAzyOBPIjHtgkUiIikU/nyqwDFclHfZqFy8EZZ5EY/Di+GQFOrwBoT7g8z3i47Aj3ghw60BTvWa6FGb7BzZFXBVgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yi2azGsZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yi2azGsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119081F000C4;
	Sat, 17 Oct 2026 17:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259988;
	bh=I6gNj56hgFG2EW/tIaqkdUI6MFTWTZnFDtr/NdNV4jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yi2azGsZqXK3gxgwNz2INGcBJB0PM0Ok8vrzCCnnkelcIT0jMLI8qGRM17eB4T/Ee
	 J6z2CM0gQ3vJb0adGeTp5Ke0zw8StjtwoVIk6zzJAIaGBIqyQo3tjxmbOYCGAcJ1yr
	 hA8IOuMlFbjIL7cW6LxwGj0pWHFySoD08sUKlHWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1395/1674] ksmbd: scope session state changes to bound connections
Date: Sat, 17 Oct 2026 18:01:07 +0200
Message-ID: <20261017160506.982089559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c50e628122aed077695669e25b842e778511a43d ]

ksmbd_all_conn_set_status() treats every connection whose transient
binding flag is set as belonging to the target SessionId.  A logoff or
session replacement can consequently move an unrelated connection to
NEED_RECONNECT or NEED_SETUP.

Pass the target session itself and select connections using either the
connection-local session xarray or the session's permanent channel list.
Use the same association test while waiting for requests to drain.

Serialize session-wide status changes under request_lock and do not
overwrite EXITING or RELEASING. Protect the shutdown transition with the
same lock so a concurrent session update cannot revive a closing
connection.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Fixes: abcc506a9a71 ("ksmbd: fix racy issue from smb2 close and logoff with multichannel")
Fixes: c444139cb747 ("ksmbd: rewrite stop_sessions() with restartable iteration")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c        | 35 ++++++++++++++++++++++++++-----
 fs/smb/server/connection.h        |  7 +++++--
 fs/smb/server/mgmt/user_session.c |  8 +++----
 fs/smb/server/smb2pdu.c           |  6 ++----
 4 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 8edae6eada3d1..35971331a785d 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -242,15 +242,37 @@ void ksmbd_conn_unlock(struct ksmbd_conn *conn)
 	mutex_unlock(&conn->srv_mutex);
 }
 
-void ksmbd_all_conn_set_status(u64 sess_id, u32 status)
+static bool ksmbd_session_is_bound_to_conn(struct ksmbd_session *sess,
+					   struct ksmbd_conn *conn)
+{
+	bool found;
+
+	rcu_read_lock();
+	found = xa_load(&conn->sessions, sess->id) == sess;
+	rcu_read_unlock();
+	if (found)
+		return true;
+
+	down_read(&sess->chann_lock);
+	found = xa_load(&sess->ksmbd_chann_list, (long)conn);
+	up_read(&sess->chann_lock);
+	return found;
+}
+
+void ksmbd_all_conn_set_status(struct ksmbd_session *sess, u32 status)
 {
 	struct ksmbd_conn *conn;
 	int bkt;
 
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, bkt, conn, hlist) {
-		if (conn->binding || xa_load(&conn->sessions, sess_id))
-			WRITE_ONCE(conn->status, status);
+		if (ksmbd_session_is_bound_to_conn(sess, conn)) {
+			spin_lock(&conn->request_lock);
+			if (!ksmbd_conn_exiting(conn) &&
+			    !ksmbd_conn_releasing(conn))
+				WRITE_ONCE(conn->status, status);
+			spin_unlock(&conn->request_lock);
+		}
 	}
 	up_read(&conn_list_lock);
 }
@@ -276,7 +298,8 @@ void ksmbd_conn_wait_idle(struct ksmbd_conn *conn)
 	wait_event(conn->req_running_q, atomic_read(&conn->req_running) < 2);
 }
 
-int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
+int ksmbd_conn_wait_idle_sess(struct ksmbd_conn *curr_conn,
+			      struct ksmbd_session *sess)
 {
 	struct ksmbd_conn *conn;
 	int rc, retry_count = 0, max_timeout = 120;
@@ -288,7 +311,7 @@ int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
 
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, bkt, conn, hlist) {
-		if (conn->binding || xa_load(&conn->sessions, sess_id)) {
+		if (ksmbd_session_is_bound_to_conn(sess, conn)) {
 			rcount = (conn == curr_conn) ? 2 : 1;
 			if (atomic_read(&conn->req_running) >= rcount) {
 				rc = wait_event_timeout(conn->req_running_q,
@@ -589,7 +612,9 @@ static void stop_sessions(void)
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, bkt, conn, hlist) {
 		t = conn->transport;
+		spin_lock(&conn->request_lock);
 		ksmbd_conn_set_exiting(conn);
+		spin_unlock(&conn->request_lock);
 		if (t->ops->shutdown) {
 			up_read(&conn_list_lock);
 			t->ops->shutdown(t);
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 01b9020146a41..e7559ba2eabb8 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -20,6 +20,8 @@
 #include "smb_common.h"
 #include "ksmbd_work.h"
 
+struct ksmbd_session;
+
 #define KSMBD_SOCKET_BACKLOG		16
 
 enum {
@@ -160,7 +162,8 @@ extern struct rw_semaphore conn_list_lock;
 
 bool ksmbd_conn_alive(struct ksmbd_conn *conn);
 void ksmbd_conn_wait_idle(struct ksmbd_conn *conn);
-int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id);
+int ksmbd_conn_wait_idle_sess(struct ksmbd_conn *curr_conn,
+			      struct ksmbd_session *sess);
 struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
@@ -265,5 +268,5 @@ static inline void ksmbd_conn_set_releasing(struct ksmbd_conn *conn)
 	WRITE_ONCE(conn->status, KSMBD_SESS_RELEASING);
 }
 
-void ksmbd_all_conn_set_status(u64 sess_id, u32 status);
+void ksmbd_all_conn_set_status(struct ksmbd_session *sess, u32 status);
 #endif /* __CONNECTION_H__ */
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 3c10a928e325a..e55b95d22e169 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -412,16 +412,16 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
 		goto out;
 
-	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_RECONNECT);
-	err = ksmbd_conn_wait_idle_sess_id(conn, id);
+	ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_NEED_RECONNECT);
+	err = ksmbd_conn_wait_idle_sess(conn, prev_sess);
 	if (err) {
-		ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_SETUP);
+		ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_NEED_SETUP);
 		goto out;
 	}
 
 	ksmbd_destroy_file_table(prev_sess);
 	prev_sess->state = SMB2_SESSION_EXPIRED;
-	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_SETUP);
+	ksmbd_all_conn_set_status(prev_sess, KSMBD_SESS_NEED_SETUP);
 	ksmbd_launch_ksmbd_durable_scavenger();
 out:
 	up_write(&conn->session_lock);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 71156b94b85d2..8f9f4f9360bbb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2246,7 +2246,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	struct smb2_logoff_req *req;
 	struct smb2_logoff_rsp *rsp;
-	u64 sess_id;
 	int err;
 
 	WORK_BUFFERS(work, req, rsp);
@@ -2260,8 +2259,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 		smb2_set_err_rsp(work);
 		return -ENOENT;
 	}
-	sess_id = le64_to_cpu(req->hdr.SessionId);
-	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_RECONNECT);
+	ksmbd_all_conn_set_status(sess, KSMBD_SESS_NEED_RECONNECT);
 	ksmbd_conn_unlock(conn);
 
 	ksmbd_close_session_fds(work);
@@ -2278,7 +2276,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
+	ksmbd_all_conn_set_status(sess, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_logoff_rsp));
-- 
2.53.0



