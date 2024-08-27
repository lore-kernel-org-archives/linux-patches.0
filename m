Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C2E1A01C8;
	Tue, 27 Aug 2024 14:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770798; cv=none; b=j4eq64DksLJV/6Jx6WSsHArq/A3m9E5EuOnizjA1L6XPQY1NeXxRtSr5M+lbgnQC5S9ZqdqqCd1dEhHMd6R2QBRU6WELFha/Tqu4uxHamTKoKYIe05usPQcgSpQAcaPnrVkT6PUDDOUxApUJKLe54RK6KwxStWL6uS0Q0iaoGZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770798; c=relaxed/simple;
	bh=I6JIMr3WZ9N65riXj+JLhaDaziwnoHEtxHjB0cX9uz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdK5MuGPQCXqCo2eDiv1LPUQluMi/w11poW/m2kV+XCV6+Loxsl6j8eLIya9Wwi+ATXfANL/RUtiWt/4q0pRXmIEyCUie4fiJjCAhM8Ad70ND525S9+iCDqf8XtSnIizALgpsurZFlDKpeGf8ttQ/h+E16fvemhvV4tV80dxO+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1R2LUOLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R2LUOLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36577C4AF1A;
	Tue, 27 Aug 2024 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770798;
	bh=I6JIMr3WZ9N65riXj+JLhaDaziwnoHEtxHjB0cX9uz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1R2LUOLwYgOxVBDTCMKnpOntR/Fpr4JBj/AOQ1vI8T/WJXggQgAc50mVaZbrH/P5r
	 qjgm08bkdRQW6SfCJhIqoRjoA5urU3NyAr/N8NB0oOe9vrV/QyYQifIDoskQkBpcbP
	 TQ/1XQTq+pPUAUdRl+1xKICT1Tb/h9KSEmZHNNIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.6 338/341] ksmbd: fix race condition between destroy_previous_session() and smb2 operations()
Date: Tue, 27 Aug 2024 16:39:29 +0200
Message-ID: <20240827143856.254733076@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

[ Upstream commit 76e98a158b207771a6c9a0de0a60522a446a3447 ]

If there is ->PreviousSessionId field in the session setup request,
The session of the previous connection should be destroyed.
During this, if the smb2 operation requests in the previous session are
being processed, a racy issue could happen with ksmbd_destroy_file_table().
This patch sets conn->status to KSMBD_SESS_NEED_RECONNECT to block
incoming  operations and waits until on-going operations are complete
(i.e. idle) before desctorying the previous session.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Cc: stable@vger.kernel.org # v6.6+
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-25040
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c        |   34 +++++++++++++++++++++++++++++++++-
 fs/smb/server/connection.h        |    3 ++-
 fs/smb/server/mgmt/user_session.c |    8 ++++++++
 fs/smb/server/smb2pdu.c           |    2 +-
 4 files changed, 44 insertions(+), 3 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -165,11 +165,43 @@ void ksmbd_all_conn_set_status(u64 sess_
 	up_read(&conn_list_lock);
 }
 
-void ksmbd_conn_wait_idle(struct ksmbd_conn *conn, u64 sess_id)
+void ksmbd_conn_wait_idle(struct ksmbd_conn *conn)
 {
 	wait_event(conn->req_running_q, atomic_read(&conn->req_running) < 2);
 }
 
+int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
+{
+	struct ksmbd_conn *conn;
+	int rc, retry_count = 0, max_timeout = 120;
+	int rcount = 1;
+
+retry_idle:
+	if (retry_count >= max_timeout)
+		return -EIO;
+
+	down_read(&conn_list_lock);
+	list_for_each_entry(conn, &conn_list, conns_list) {
+		if (conn->binding || xa_load(&conn->sessions, sess_id)) {
+			if (conn == curr_conn)
+				rcount = 2;
+			if (atomic_read(&conn->req_running) >= rcount) {
+				rc = wait_event_timeout(conn->req_running_q,
+					atomic_read(&conn->req_running) < rcount,
+					HZ);
+				if (!rc) {
+					up_read(&conn_list_lock);
+					retry_count++;
+					goto retry_idle;
+				}
+			}
+		}
+	}
+	up_read(&conn_list_lock);
+
+	return 0;
+}
+
 int ksmbd_conn_write(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -145,7 +145,8 @@ extern struct list_head conn_list;
 extern struct rw_semaphore conn_list_lock;
 
 bool ksmbd_conn_alive(struct ksmbd_conn *conn);
-void ksmbd_conn_wait_idle(struct ksmbd_conn *conn, u64 sess_id);
+void ksmbd_conn_wait_idle(struct ksmbd_conn *conn);
+int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id);
 struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -310,6 +310,7 @@ void destroy_previous_session(struct ksm
 {
 	struct ksmbd_session *prev_sess;
 	struct ksmbd_user *prev_user;
+	int err;
 
 	down_write(&sessions_table_lock);
 	down_write(&conn->session_lock);
@@ -324,8 +325,15 @@ void destroy_previous_session(struct ksm
 	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
 		goto out;
 
+	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_RECONNECT);
+	err = ksmbd_conn_wait_idle_sess_id(conn, id);
+	if (err) {
+		ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_NEGOTIATE);
+		goto out;
+	}
 	ksmbd_destroy_file_table(&prev_sess->file_table);
 	prev_sess->state = SMB2_SESSION_EXPIRED;
+	ksmbd_all_conn_set_status(id, KSMBD_SESS_NEED_NEGOTIATE);
 out:
 	up_write(&conn->session_lock);
 	up_write(&sessions_table_lock);
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2210,7 +2210,7 @@ int smb2_session_logoff(struct ksmbd_wor
 	ksmbd_conn_unlock(conn);
 
 	ksmbd_close_session_fds(work);
-	ksmbd_conn_wait_idle(conn, sess_id);
+	ksmbd_conn_wait_idle(conn);
 
 	/*
 	 * Re-lookup session to validate if session is deleted


