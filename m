Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29154F68C5;
	Tue, 13 Oct 2026 12:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894345; cv=none; b=RbtBb73vKjkdKDgDfWUMf+GV/ExABuCGMZT8SyUbvjnlusLRbeFQV6yb2OFqBhEZTIz0m8F26WP/tOUGyhkbERO9AGR0K9EWC1V64xg49z9BQq511SCbfbcVI/1r+LbAuVabiMfdUp+E/3DEW9jZWOYrXPgVri850/x7dCbDmDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894345; c=relaxed/simple;
	bh=QGZYI+jwyhsn3SGOegdSwCxJlRCveLJ7PmxdXno1SDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fE/yvNC9aWOhLiyxzGQ2dGVuC1WL2e1LjH7NnKyIcaPf+BbEc5xxvflFeehIyfDwdkt5AHIKDm6q/Qs2ZPHyH9pXyvaGHqXWd2e5Udy35CSHknSkzWxLkSeutEE94Bgx0DQc/jkHioeEcMkpSrDc5GeZhLKxB9JtuGvxJ327j2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi6JDu48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi6JDu48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6BD1F000FF;
	Tue, 13 Oct 2026 12:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894344;
	bh=ljxsMHskqle87zwb4t6KM4qwVpniqbFhrvAo04BS13c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vi6JDu48+ml9kNe6qSzhHhtZmSYLbkUigid0e32Cy0X3QtniizRMTYB0yESUlCoFt
	 xCeIkPrD+mPv/iftSTnmA8nwzGJmXeITsRQeU/TWS8ghNxzXLJnEeFOSBSmRDzvkDs
	 JEAvDm/H7x8x0L2VBJxUOiwdg4pC309JKDnZdg0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 527/621] ksmbd: convert tree_conns_lock to rw_semaphore
Date: Tue, 13 Oct 2026 13:38:42 +0200
Message-ID: <20261013112933.327588086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

[ Upstream commit 31b9028c77dc279d720412013e95b279b1385aed ]

Converts tree_conns_lock to an rw_semaphore to allow sleeping while
the lock is held. Additionally, it simplifies the locking logic in
ksmbd_tree_conn_session_logoff() and introduces
__ksmbd_tree_conn_disconnect() to avoid redundant locking.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 39f203209671 ("smb/server: fix tree connection leak in smb2_tree_connect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/tree_connect.c | 33 ++++++++++++++++++++-----------
 fs/smb/server/mgmt/user_session.c |  2 +-
 fs/smb/server/mgmt/user_session.h |  2 +-
 fs/smb/server/smb2pdu.c           | 10 +++++-----
 4 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index d3483d9c757c7..c7a89eddcda7b 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -79,8 +79,10 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 	status.tree_conn = tree_conn;
 	atomic_set(&tree_conn->refcount, 1);
 
+	down_write(&sess->tree_conns_lock);
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      KSMBD_DEFAULT_GFP));
+	up_write(&sess->tree_conns_lock);
 	if (ret) {
 		status.ret = -ENOMEM;
 		goto out_error;
@@ -103,15 +105,11 @@ void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon)
 		kfree(tcon);
 }
 
-int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
-			       struct ksmbd_tree_connect *tree_conn)
+static int __ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
+					struct ksmbd_tree_connect *tree_conn)
 {
 	int ret;
 
-	write_lock(&sess->tree_conns_lock);
-	xa_erase(&sess->tree_conns, tree_conn->id);
-	write_unlock(&sess->tree_conns_lock);
-
 	ret = ksmbd_ipc_tree_disconnect_request(sess->id, tree_conn->id);
 	ksmbd_release_tree_conn_id(sess, tree_conn->id);
 	ksmbd_share_config_put(tree_conn->share_conf);
@@ -120,12 +118,22 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 	return ret;
 }
 
+int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
+			       struct ksmbd_tree_connect *tree_conn)
+{
+	down_write(&sess->tree_conns_lock);
+	xa_erase(&sess->tree_conns, tree_conn->id);
+	up_write(&sess->tree_conns_lock);
+
+	return __ksmbd_tree_conn_disconnect(sess, tree_conn);
+}
+
 struct ksmbd_tree_connect *ksmbd_tree_conn_lookup(struct ksmbd_session *sess,
 						  unsigned int id)
 {
 	struct ksmbd_tree_connect *tcon;
 
-	read_lock(&sess->tree_conns_lock);
+	down_read(&sess->tree_conns_lock);
 	tcon = xa_load(&sess->tree_conns, id);
 	if (tcon) {
 		if (tcon->t_state != TREE_CONNECTED)
@@ -133,7 +141,7 @@ struct ksmbd_tree_connect *ksmbd_tree_conn_lookup(struct ksmbd_session *sess,
 		else if (!atomic_inc_not_zero(&tcon->refcount))
 			tcon = NULL;
 	}
-	read_unlock(&sess->tree_conns_lock);
+	up_read(&sess->tree_conns_lock);
 
 	return tcon;
 }
@@ -147,18 +155,19 @@ int ksmbd_tree_conn_session_logoff(struct ksmbd_session *sess)
 	if (!sess)
 		return -EINVAL;
 
+	down_write(&sess->tree_conns_lock);
 	xa_for_each(&sess->tree_conns, id, tc) {
-		write_lock(&sess->tree_conns_lock);
 		if (tc->t_state == TREE_DISCONNECTED) {
-			write_unlock(&sess->tree_conns_lock);
 			ret = -ENOENT;
 			continue;
 		}
 		tc->t_state = TREE_DISCONNECTED;
-		write_unlock(&sess->tree_conns_lock);
 
-		ret |= ksmbd_tree_conn_disconnect(sess, tc);
+		xa_erase(&sess->tree_conns, tc->id);
+		ret |= __ksmbd_tree_conn_disconnect(sess, tc);
 	}
 	xa_destroy(&sess->tree_conns);
+	up_write(&sess->tree_conns_lock);
+
 	return ret;
 }
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 03ed052a636be..3a2591434b5f8 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -481,8 +481,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	xa_init(&sess->ksmbd_chann_list);
 	xa_init(&sess->rpc_handle_list);
 	sess->sequence_number = 1;
-	rwlock_init(&sess->tree_conns_lock);
 	atomic_set(&sess->refcnt, 2);
+	init_rwsem(&sess->tree_conns_lock);
 	init_rwsem(&sess->rpc_lock);
 	init_rwsem(&sess->chann_lock);
 
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 525650d6876c3..10132a3f1e4af 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -61,7 +61,7 @@ struct ksmbd_session {
 
 	struct ksmbd_file_table		file_table;
 	unsigned long			last_active;
-	rwlock_t			tree_conns_lock;
+	struct rw_semaphore		tree_conns_lock;
 
 	atomic_t			refcnt;
 	struct rw_semaphore		rpc_lock;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f2bb853b0198d..bbbdc117fc112 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2051,9 +2051,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (conn->posix_ext_supported)
 		status.tree_conn->posix_extensions = true;
 
-	write_lock(&sess->tree_conns_lock);
+	down_write(&sess->tree_conns_lock);
 	status.tree_conn->t_state = TREE_CONNECTED;
-	write_unlock(&sess->tree_conns_lock);
+	up_write(&sess->tree_conns_lock);
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
 	/*
@@ -2206,16 +2206,16 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 
 	ksmbd_close_tree_conn_fds(work);
 
-	write_lock(&sess->tree_conns_lock);
+	down_write(&sess->tree_conns_lock);
 	if (tcon->t_state == TREE_DISCONNECTED) {
-		write_unlock(&sess->tree_conns_lock);
+		up_write(&sess->tree_conns_lock);
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
 		err = -ENOENT;
 		goto err_out;
 	}
 
 	tcon->t_state = TREE_DISCONNECTED;
-	write_unlock(&sess->tree_conns_lock);
+	up_write(&sess->tree_conns_lock);
 
 	err = ksmbd_tree_conn_disconnect(sess, tcon);
 	if (err) {
-- 
2.53.0



