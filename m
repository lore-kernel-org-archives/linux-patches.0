Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826996;
	b=PzCLG0VxEqCOZYO32kOOYI+2wmP0s88c44HsTlIb5bzKItVYP6FsCoCG8cJSGjVfimZ4
	 LW4gLcb1I4454Q13Y4857vFxHTlHMpT6Ln9zz8f2SgyS9m6EuADHF1kzy3ottyRgrdFfd
	 fefHl/GX2KtDPOw10QpGHhacWjo1q6nENt2SI4KrsURKINUuhDyuEcULmudY1xzmAmJVA
	 cf5teXFluJGo/57F6+/xt89D/iZz6R/+GHqdmwbHCx1x7fCe+fEDA4ktgu2A6BLMdYEZ/
	 kH3RpmpBWYBmQITXHjzaRBpoGTZe63D1xd2TbDIZFmlp9VonIyhs4/+IxbJtLaYFjGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IF67/jjhM1qR+nkan370YqmV6nwZhQgzlV/d/pbPZUQ=;
	b=N2GOJjE5rCrpPWR0QgfvqUojCO528k8erOS9ovSj1m15J7nrDKoGDvh80DIkwcCZ7ros
	 5pf2y+oOMtnFAac9ZcDzHchNfpXyeM2BkNhYEWdpOvKt/qi2gluSK3DWDH8sRZG5fHocT
	 MG40ALf0aCkF1BfoUHF+iFJbiyBNGl47QluZ7cO2NOunJ44TXrMr8nzwLtoMLpOcJFMIk
	 XhNwvMeFl3sAV3gdKyLM7gUraUfkmqhTYbEyqnnVA6zFmqHdugap+Kka1poH8XnWrvzcJ
	 T8WNKfpccYeKUMXNbq1w1SBO3oEUxiBwh2RGBoNNBDdbrE94HzcZSK6v2o6LARTguJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTgyesZ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD0E6074906;
	Wed,  4 Nov 2026 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTgyesZ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314781F00A16;
	Wed,  4 Nov 2026 21:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826995;
	bh=IF67/jjhM1qR+nkan370YqmV6nwZhQgzlV/d/pbPZUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTgyesZ7dIA83+m8s3HgXeahoVlEpGFawwjd/13XQYg2GMOFosq5qdhuAWrpy/amr
	 7bomJ4kP7z2HPnWVEiCRvizMj2NgHx0gNuH49nvkg6E0EXA1OITfMvjtgvhLN+sx2O
	 g/z9TrgOjYwxnhZN0LefVLSCcp0MpvY6q96WkC8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 130/547] ksmbd: reclaim ended sessions on logoff and expiration
Date: Wed,  4 Nov 2026 16:05:14 -0500
Message-ID: <20261104211041.872784592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 26534ef335e92b028eb58e44d98d46a0e26af0ec upstream.

LOGOFF and previous-session replacement leave sessions Expired with a
zero credential expiry. Ended sessions can retain their memory and
connection slots when no further setup arrives on the owning connection.

Unpublish a logged-off session while the request reference keeps its
response signing and encryption keys alive. Remove its procfs entry
before dropping the table reference so a reader cannot remove its own
entry on the last put. Clear proc_entry after removal to avoid removing
it twice.

Reclaim ended sessions from the global table in the existing expiration
worker before it acquires conn_list_lock. Only select Expired sessions
with zero credential expiry and no references beyond the table
reference. Keep sessions whose Kerberos credentials expired available
for reauthentication.

Unlink the session from its setup connection and all channel
connections, so SMB2 sessions and sessions with only secondary SMB3
channels are covered. The session already holds connection references,
and sessions_table_lock prevents concurrent channel removal. Queue
sessions on a separate disposal list, leaving their hash nodes unhashed,
and remove procfs entries and drop table references outside the locks.

Keep the pending setup check before allocating a new session so
abandoned InProgress sessions can release their slots even at the
connection limit. Retain the timeout and reference checks and dispose of
those sessions outside the locks. Leave ended Expired sessions to the
expiration worker.

Fixes: d7fd1f98607f ("ksmbd: follow SMB2 session expiration semantics")
Cc: stable@vger.kernel.org
Reported-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c        |    1 
 fs/smb/server/mgmt/user_session.c |   94 ++++++++++++++++++++++++++++++--------
 fs/smb/server/mgmt/user_session.h |    3 +
 fs/smb/server/smb2pdu.c           |    7 ++
 4 files changed, 86 insertions(+), 19 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -642,6 +642,7 @@ static void ksmbd_session_expiration_wor
 		goto reschedule;
 
 	ksmbd_expire_sessions();
+	ksmbd_reclaim_ended_sessions();
 
 	/*
 	 * An old connection without a Valid or Expired session must be
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -231,8 +231,10 @@ static int create_proc_session(struct ks
 
 static void delete_proc_session(struct ksmbd_session *sess)
 {
-	if (sess->proc_entry)
+	if (sess->proc_entry) {
 		proc_remove(sess->proc_entry);
+		sess->proc_entry = NULL;
+	}
 }
 
 static int show_proc_sessions(struct seq_file *m, void *v)
@@ -449,6 +451,17 @@ static void ksmbd_session_remove_from_ta
 	ksmbd_counter_dec(KSMBD_COUNTER_SESSIONS);
 }
 
+static void ksmbd_dispose_sessions(struct list_head *dispose)
+{
+	struct ksmbd_session *sess, *tmp;
+
+	list_for_each_entry_safe(sess, tmp, dispose, dispose_entry) {
+		list_del_init(&sess->dispose_entry);
+		delete_proc_session(sess);
+		ksmbd_user_session_put(sess);
+	}
+}
+
 struct ksmbd_session *__session_lookup(unsigned long long id)
 {
 	struct ksmbd_session *sess;
@@ -462,8 +475,9 @@ struct ksmbd_session *__session_lookup(u
 	return NULL;
 }
 
-static bool ksmbd_too_many_session_setups(struct ksmbd_conn *conn)
+bool ksmbd_too_many_session_setups(struct ksmbd_conn *conn)
 {
+	LIST_HEAD(dispose);
 	unsigned long id;
 	struct ksmbd_session *sess;
 	unsigned int pending = 0;
@@ -474,18 +488,20 @@ static bool ksmbd_too_many_session_setup
 		if (READ_ONCE(sess->state) != SMB2_SESSION_IN_PROGRESS)
 			continue;
 
-		if (atomic_read(&sess->refcnt) <= 1 &&
+		/* Keep response signing keys until every request has dropped its reference. */
+		if (atomic_read(&sess->refcnt) == 1 &&
 		    time_after(jiffies, sess->last_active +
 			       KSMBD_UNAUTHENTICATED_CONN_TIMEOUT)) {
 			xa_erase(&conn->sessions, sess->id);
 			ksmbd_session_remove_from_table(sess);
-			ksmbd_session_destroy(sess);
+			list_add_tail(&sess->dispose_entry, &dispose);
 			continue;
 		}
 		pending++;
 	}
 	up_write(&conn->session_lock);
 	up_write(&sessions_table_lock);
+	ksmbd_dispose_sessions(&dispose);
 	return pending >= KSMBD_MAX_PENDING_SESSIONS;
 }
 
@@ -496,12 +512,8 @@ int ksmbd_session_register(struct ksmbd_
 
 	sess->dialect = conn->dialect;
 	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
-	/* Bound abandoned SessionId-zero authentication exchanges. */
-	if (ksmbd_too_many_session_setups(conn))
-		ret = -ENOSPC;
-	else
-		ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
-				      KSMBD_DEFAULT_GFP));
+	ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
+			      KSMBD_DEFAULT_GFP));
 	if (ret) {
 		down_write(&sessions_table_lock);
 		ksmbd_session_remove_from_table(sess);
@@ -513,8 +525,9 @@ int ksmbd_session_register(struct ksmbd_
 	return ret;
 }
 
-void ksmbd_session_unregister(struct ksmbd_conn *conn,
-			      struct ksmbd_session *sess)
+/* The caller holds sessions_table_lock for writing. */
+static bool __ksmbd_session_unregister(struct ksmbd_conn *conn,
+				       struct ksmbd_session *sess)
 {
 	struct ksmbd_conn *session_conns[KSMBD_MAX_CHANNELS];
 	struct channel *chann;
@@ -522,10 +535,13 @@ void ksmbd_session_unregister(struct ksm
 	unsigned int nr_conns = 0, i;
 	bool removed = false;
 
-	down_write(&sessions_table_lock);
+	lockdep_assert_held_write(&sessions_table_lock);
 	if (!hlist_unhashed(&sess->hlist)) {
-		/* Keep each channel connection stable under sessions_table_lock. */
+		/* Existing references stay valid under sessions_table_lock. */
 		down_read(&sess->chann_lock);
+		/* SMB2.0/2.1 sessions have no channel holding their connection. */
+		if (sess->setup_conn)
+			session_conns[nr_conns++] = sess->setup_conn;
 		xa_for_each(&sess->ksmbd_chann_list, index, chann) {
 			if (nr_conns == ARRAY_SIZE(session_conns))
 				break;
@@ -537,10 +553,12 @@ void ksmbd_session_unregister(struct ksm
 		removed = true;
 	}
 
-	down_write(&conn->session_lock);
-	if (xa_load(&conn->sessions, sess->id) == sess)
-		xa_erase(&conn->sessions, sess->id);
-	up_write(&conn->session_lock);
+	if (conn) {
+		down_write(&conn->session_lock);
+		if (xa_load(&conn->sessions, sess->id) == sess)
+			xa_erase(&conn->sessions, sess->id);
+		up_write(&conn->session_lock);
+	}
 	for (i = 0; i < nr_conns; i++) {
 		if (session_conns[i] == conn)
 			continue;
@@ -549,10 +567,47 @@ void ksmbd_session_unregister(struct ksm
 			xa_erase(&session_conns[i]->sessions, sess->id);
 		up_write(&session_conns[i]->session_lock);
 	}
+	return removed;
+}
+
+void ksmbd_session_unregister(struct ksmbd_conn *conn,
+			      struct ksmbd_session *sess)
+{
+	bool removed;
+
+	down_write(&sessions_table_lock);
+	removed = __ksmbd_session_unregister(conn, sess);
 	up_write(&sessions_table_lock);
 
-	if (removed)
+	if (removed) {
+		/*
+		 * Keep the table reference until procfs readers have finished,
+		 * so none can remove its own proc entry on the last put.
+		 */
+		delete_proc_session(sess);
 		ksmbd_user_session_put(sess);
+	}
+}
+
+void ksmbd_reclaim_ended_sessions(void)
+{
+	LIST_HEAD(dispose);
+	struct ksmbd_session *sess;
+	struct hlist_node *tmp;
+	int bkt;
+
+	down_write(&sessions_table_lock);
+	hash_for_each_safe(sessions_table, bkt, tmp, sess, hlist) {
+		if (READ_ONCE(sess->state) != SMB2_SESSION_EXPIRED ||
+		    READ_ONCE(sess->kerberos_expiry) ||
+		    atomic_read(&sess->refcnt) != 1)
+			continue;
+
+		__ksmbd_session_unregister(NULL, sess);
+		list_add_tail(&sess->dispose_entry, &dispose);
+	}
+	up_write(&sessions_table_lock);
+	ksmbd_dispose_sessions(&dispose);
 }
 
 bool ksmbd_conn_has_valid_or_expired_session(struct ksmbd_conn *conn)
@@ -893,6 +948,7 @@ static struct ksmbd_session *__session_c
 	xa_init(&sess->tree_conns);
 	xa_init(&sess->ksmbd_chann_list);
 	xa_init(&sess->rpc_handle_list);
+	INIT_LIST_HEAD(&sess->dispose_entry);
 	sess->sequence_number = 1;
 	atomic_set(&sess->refcnt, 2);
 	init_rwsem(&sess->tree_conns_lock);
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -53,6 +53,7 @@ struct ksmbd_session {
 	u64				kerberos_expiry;
 
 	struct hlist_node		hlist;
+	struct list_head		dispose_entry;
 	struct rw_semaphore		chann_lock;
 	struct xarray			ksmbd_chann_list;
 	struct xarray			tree_conns;
@@ -102,6 +103,7 @@ struct ksmbd_session *ksmbd_session_look
 					   unsigned long long id);
 bool is_ksmbd_session_in_connection(struct ksmbd_conn *conn,
 				     unsigned long long id);
+bool ksmbd_too_many_session_setups(struct ksmbd_conn *conn);
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess);
 void ksmbd_session_unregister(struct ksmbd_conn *conn,
@@ -109,6 +111,7 @@ void ksmbd_session_unregister(struct ksm
 void ksmbd_conn_sessions_cleanup(struct ksmbd_conn *conn);
 bool ksmbd_conn_has_valid_or_expired_session(struct ksmbd_conn *conn);
 void ksmbd_expire_sessions(void);
+void ksmbd_reclaim_ended_sessions(void);
 struct ksmbd_session *__session_lookup(unsigned long long id);
 struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 					       unsigned long long id);
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2475,6 +2475,11 @@ int smb2_sess_setup(struct ksmbd_work *w
 
 	ksmbd_conn_lock(conn);
 	if (!req->hdr.SessionId) {
+		/* Bound abandoned SessionId-zero authentication exchanges. */
+		if (ksmbd_too_many_session_setups(conn)) {
+			rc = -ENOSPC;
+			goto out_err;
+		}
 		sess = ksmbd_smb2_session_create(conn);
 		if (!sess) {
 			rc = -ENOMEM;
@@ -3173,6 +3178,8 @@ int smb2_session_logoff(struct ksmbd_wor
 	up_write(&conn->session_lock);
 
 	ksmbd_all_conn_set_status(sess, KSMBD_SESS_NEED_SETUP);
+	/* Drop the table reference while work->sess pins the response keys. */
+	ksmbd_session_unregister(conn, sess);
 
 	if (err)
 		return err;


