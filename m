Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7235C6B3;
	Tue, 21 Jul 2026 21:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670628; cv=none; b=S7hSqJi5ljvgdJss9YdJExg72gO4TdQG+hJPjZVzQMLuLelIwmmLav4Rii3Pa/1IB4bOWyq/DTf1It1PpC2pmyDiMWNP0k9vPsRrQO4gSMYL7usQqDJTOmFhghPxQ4chmrLRIMa5ONbWVwWhxZwHW8L5gJWjWtmtu/HZ+biHx6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670628; c=relaxed/simple;
	bh=1xMEszpp2NxDkaU1Swr2SzkRbgBsv1DmK0kBvpww4LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERDnmAuEnaQa+/23MOBuXerJuHmaWNVlopFgYXUQiIVTXKB8jC/Z6DFz48GF13fxGKxwwdGNO9Nce3N8lBwOJ9SZx0xY/GMbU7a4aSstOCg3yi7oI3BlY/Kph3OhVhad8k3ydvXix/MEgwrnXQsFfDG1F0Hqw1IoYp5bhTmHsIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqUQ2ad2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqUQ2ad2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FBA1F00A3A;
	Tue, 21 Jul 2026 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670626;
	bh=ci08ZGakTP2t6FsihU4P74XZioV8SPbdq0AxoRucKqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqUQ2ad2joRH2zFZ4/w27P3YPuwZxrTUVq5jiLeFgnHJyPo+tBBrn6mZvoVbUwR/S
	 BIEldMzUIwO517jrJWRyqOCh1mEjCEG2n8VdQnB9C+gqv4YlWtVl526ch+uWf/hV5V
	 TcKUCTFP6p4lYrxnsuVXHOWJ5RLeJPcWd63cZlHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1004/1067] ksmbd: centralize ksmbd_conn final release to plug transport leak
Date: Tue, 21 Jul 2026 17:26:45 +0200
Message-ID: <20260721152447.028922765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit b1f1e80620deb49daf63c2e677046599b693dc1f ]

ksmbd_conn_free() is one of four sites that can observe the last
refcount drop of a struct ksmbd_conn.  The other three

    fs/smb/server/connection.c    ksmbd_conn_r_count_dec()
    fs/smb/server/oplock.c        __free_opinfo()
    fs/smb/server/vfs_cache.c     session_fd_check()

end the conn with a bare kfree(), skipping
ida_destroy(&conn->async_ida) and
conn->transport->ops->free_transport(conn->transport).  Whenever one
of them is the last putter, the embedded async_ida and the entire
transport struct leak -- for TCP, that is also the struct socket and
the kvec iov.

__free_opinfo() being a final putter is not theoretical.  opinfo_put()
queues the callback via call_rcu(&opinfo->rcu, free_opinfo_rcu), so
ksmbd_server_terminate_conn() can deposit N opinfo releases in RCU and
have ksmbd_conn_free() run in the handler thread before any of them
fire.  ksmbd_conn_free() then observes refcnt > 0 and short-circuits;
the last RCU-delivered __free_opinfo() falls onto its bare kfree(conn)
branch and the transport is lost.

A/B validation in a QEMU/virtme guest, mounting //127.0.0.1/testshare:
each iteration holds 8 files open via sleep processes, force-closes
TCP with "ss -K sport = :445", kills the holders, lazy-umounts;
repeated 10 times, then ksmbd shutdown and kmemleak scan.

    state         conn_alloc  conn_free  tcp_free  opi_rcu  kmemleak
    ----------    ----------  ---------  --------  -------  --------
    pre-patch         20          20        10       160        7
    with patch        20          20        20       160        0

Pre-patch conn_free=20 with tcp_free=10 directly demonstrates the
bare-kfree paths skipping transport cleanup; kmemleak backtraces point
into struct tcp_transport / iov.  With this patch tcp_free matches
conn_free at 20/20 and kmemleak is clean.

Move the per-struct final release into __ksmbd_conn_release_work() and
route the three bare-kfree final-put sites through a new
ksmbd_conn_put().  Those sites now pair ida_destroy() and
free_transport() with kfree(conn) regardless of which holder happens
to release the last reference.  stop_sessions() only triggers the
transport shutdown and does not itself drop the last conn reference,
so it is unaffected.

The centralized release reaches sock_release() -> tcp_close() ->
lock_sock_nested() (might_sleep) from every final putter, including
__free_opinfo() invoked from an RCU softirq callback, which trips
CONFIG_DEBUG_ATOMIC_SLEEP.  Defer the release to a dedicated
ksmbd_conn_wq workqueue so ksmbd_conn_put() is safe from any
non-sleeping context.

Make ksmbd_file own a strong connection reference while fp->conn is
non-NULL so durable-preserve and final-close paths cannot dereference
a stale connection.  ksmbd_open_fd() and ksmbd_reopen_durable_fd()
take the reference via ksmbd_conn_get() (the latter also reorders the
fp->conn / fp->tcon assignments before __open_id() so the published fp
is never observed with fp->conn == NULL); session_fd_check() and
__ksmbd_close_fd() drop it via ksmbd_conn_put().  With that invariant,
session_fd_check() can take a local conn pointer once and use it
across the m_op_list and lock_list iterations even though op->conn
puts may otherwise drop the last reference.

At module exit the workqueue is flushed and destroyed after
rcu_barrier(), so any release queued by a trailing RCU callback is
drained before the inode hash and module text go away.

Fixes: ee426bfb9d09 ("ksmbd: add refcnt to ksmbd_conn struct")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: c1016dd1d8b2 ("ksmbd: track the connection owning a byte-range lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |   49 +++++++++++++++++++++++++++++++++++++++++++--
 fs/smb/server/connection.h |    3 ++
 fs/smb/server/oplock.c     |    4 +--
 fs/smb/server/vfs_cache.c  |   18 +++++++++++++++-
 4 files changed, 69 insertions(+), 5 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -23,6 +23,43 @@ LIST_HEAD(conn_list);
 DECLARE_RWSEM(conn_list_lock);
 
 /**
+ * ksmbd_conn_get() - take a reference on @conn and return it.
+ *
+ * Returns @conn unchanged so callers can write
+ * "fp->conn = ksmbd_conn_get(work->conn);" in one expression.  Returns NULL
+ * if @conn is NULL.
+ */
+struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn)
+{
+	if (!conn)
+		return NULL;
+
+	atomic_inc(&conn->refcnt);
+	return conn;
+}
+
+/**
+ * ksmbd_conn_put() - drop a reference and, if it was the last, perform the
+ * final, once-per-struct release of a ksmbd_conn.
+ *
+ * The transport is not released here: free_transport() releases it after
+ * calling ksmbd_conn_free().  The final release therefore only pairs
+ * ida_destroy() with kfree(), reaches no sleeping teardown and is safe
+ * from any context, including the RCU callback that frees an opinfo
+ * holding a connection reference.
+ */
+void ksmbd_conn_put(struct ksmbd_conn *conn)
+{
+	if (!conn)
+		return;
+
+	if (atomic_dec_and_test(&conn->refcnt)) {
+		ida_destroy(&conn->async_ida);
+		kfree(conn);
+	}
+}
+
+/**
  * ksmbd_conn_free() - free resources of the connection instance
  *
  * @conn:	connection instance to be cleand up
@@ -36,12 +73,19 @@ void ksmbd_conn_free(struct ksmbd_conn *
 	list_del(&conn->conns_list);
 	up_write(&conn_list_lock);
 
+	/*
+	 * request_buf / preauth_info / mechToken are only ever accessed by the
+	 * connection handler thread that owns @conn.  ksmbd_conn_free() is
+	 * called from the transport free_transport() path when that thread is
+	 * exiting, so it is safe to release them unconditionally even when
+	 * ksmbd_conn_put() below is not the final putter (oplock / ksmbd_file
+	 * holders only retain the conn pointer, not these per-thread buffers).
+	 */
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
-	ida_destroy(&conn->async_ida);
-	kfree(conn);
+	ksmbd_conn_put(conn);
 }
 
 /**
@@ -70,6 +114,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 		conn->um = NULL;
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
+	atomic_set(&conn->refcnt, 1);
 	conn->total_credits = 1;
 	conn->outstanding_credits = 0;
 
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -112,6 +112,7 @@ struct ksmbd_conn {
 	bool				signing_negotiated;
 	__le16				signing_algorithm;
 	bool				binding;
+	atomic_t			refcnt;
 };
 
 struct ksmbd_conn_ops {
@@ -154,6 +155,8 @@ bool ksmbd_conn_alive(struct ksmbd_conn
 void ksmbd_conn_wait_idle(struct ksmbd_conn *conn, u64 sess_id);
 struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
+struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
+void ksmbd_conn_put(struct ksmbd_conn *conn);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -30,7 +30,6 @@ static DEFINE_RWLOCK(lease_list_lock);
 static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 					u64 id, __u16 Tid)
 {
-	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct oplock_info *opinfo;
 
@@ -39,7 +38,7 @@ static struct oplock_info *alloc_opinfo(
 		return NULL;
 
 	opinfo->sess = sess;
-	opinfo->conn = conn;
+	opinfo->conn = ksmbd_conn_get(work->conn);
 	opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	opinfo->pending_break = 0;
@@ -124,6 +123,7 @@ static void free_opinfo(struct oplock_in
 {
 	if (opinfo->is_lease)
 		free_lease(opinfo);
+	ksmbd_conn_put(opinfo->conn);
 	kfree(opinfo);
 }
 
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -328,6 +328,14 @@ static void __ksmbd_close_fd(struct ksmb
 		kfree(smb_lock);
 	}
 
+	/*
+	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd()).
+	 */
+	if (fp->conn) {
+		ksmbd_conn_put(fp->conn);
+		fp->conn = NULL;
+	}
+
 	if (ksmbd_stream_fd(fp))
 		kfree(fp->stream.name);
 	kmem_cache_free(filp_cache, fp);
@@ -580,7 +588,13 @@ struct ksmbd_file *ksmbd_open_fd(struct
 	atomic_set(&fp->refcount, 1);
 
 	fp->filp		= filp;
-	fp->conn		= work->conn;
+	/*
+	 * fp owns a strong reference on fp->conn for as long as fp->conn is
+	 * non-NULL, so __ksmbd_close_fd() never dereferences a dangling
+	 * pointer.  Paired with ksmbd_conn_put() in __ksmbd_close_fd()
+	 * (final close) and on the error paths below.
+	 */
+	fp->conn		= ksmbd_conn_get(work->conn);
 	fp->tcon		= work->tcon;
 	fp->volatile_id		= KSMBD_NO_FID;
 	fp->persistent_id	= KSMBD_NO_FID;
@@ -602,6 +616,8 @@ struct ksmbd_file *ksmbd_open_fd(struct
 	return fp;
 
 err_out:
+	/* fp->conn was set and refcounted before every branch here. */
+	ksmbd_conn_put(fp->conn);
 	kmem_cache_free(filp_cache, fp);
 	return ERR_PTR(ret);
 }


