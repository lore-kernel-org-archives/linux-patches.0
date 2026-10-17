Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE217381B0D;
	Sat, 17 Oct 2026 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254840; cv=none; b=XKoat91oA6GRzQ50DtFNVmnxVomfaptsOXGxT8QhvmZIRb1LwKOpXpfufDm0dCDhH3q3TDHYf77SJYgnct4tmOU3AbJ0T3+gp4vQ+NAsX6f+8iJ/cWEYg6g+xiu2Qus9+d2hlq935t/ZKUyKOVauptU7x3Uv7urVurg+dxPaNcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254840; c=relaxed/simple;
	bh=KeLxWsuYqTuuTTEmkkRGagqwqQFw7jjRtpl+QcW5hko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qs59frpVycG5vZ5r0ISxRA63Vz9v0QloNAmmVNTweQ8yrSrTyY85hAGhNc+4rYFf/hCgHEzTrpPXV/+EmLSzDfzVtBJ5NvItPQOVED/2U5T1WM0PR6DKswZxMBqiJej66Sxq3FYDvWjrsxjgNKZ3qmq+zb8hBdE5sjB7go+2Nhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZvg2VeY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZvg2VeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5FE1F000C4;
	Sat, 17 Oct 2026 16:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254838;
	bh=YBG8+OPxgcQZ4vGeSpw2QRAoPNLMF4Bki2MqccKT2WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZvg2VeYTB80G75H5eFmEbJd/le/ieqw+hiOshgQnlCYYE4Mn6qhvuM1N38CSgRrl
	 a0KrmluVPMQv+SQ29JroOdXGHNHye2c9AF0aF19Fr/NiEpZmLpGvw55+o/4r4vFqNT
	 4ooj3xbliOkZ89x2jbhbmE/F52Ehty5qOBZexPbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 579/869] ksmbd: fix tree connection use-after-free in smb2_tree_connect()
Date: Sat, 17 Oct 2026 17:57:00 +0200
Message-ID: <20261017160051.904014868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>

[ Upstream commit b5ec6c462aab1062cf5d1e667ba7c6442f737055 ]

ksmbd_tree_conn_connect() publishes a new tree connection in
sess->tree_conns with a single reference and returns its pointer to
smb2_tree_connect(). The handler continues to initialize the object and
build the response after publication. A concurrent session logoff can
erase the connection and drop that reference, freeing the object while
the handler still uses it.

BUG: KASAN: slab-use-after-free in smb2_tree_connect+0xe3d/0xf90
  smb2_tree_connect (fs/smb/server/smb2pdu.c:2872)
  handle_ksmbd_work
  process_one_work
  worker_thread
  kthread

After xa_store() succeeds, take a second reference before releasing
tree_conns_lock. The original reference belongs to the xarray entry and
the second belongs to the creating smb2_tree_connect() handler.

Keep the references balanced in every path:

- On normal exit or an error after publication, smb2_tree_connect()
  drops its creator reference. Error cleanup also calls
  ksmbd_tree_conn_disconnect(), which drops the xarray reference only if
  it removes the exact entry.
- SMB2 TREE_DISCONNECT uses the same helper to remove the entry and drop
  its xarray reference. The request's existing lookup reference remains
  owned by the request and is released by the existing cleanup.
- Session LOGOFF removes each entry and drops its xarray reference. If
  it wins the race, later cleanup sees that the entry is gone and does
  not drop that reference again.

To enforce this ownership, claim the disconnected state and erase the
exact entry atomically under tree_conns_lock. This guarantees one drop
for the xarray reference and one drop by each in-flight user, regardless
of which teardown path wins. If logoff removes the entry before
initialization completes, fail the connect instead of marking the
detached object TREE_CONNECTED.

Fixes: 33b235a6e6eb ("ksmbd: fix race condition between tree conn lookup and disconnect")
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Cc: AutonomousCodeSecurity@microsoft.com
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/tree_connect.c | 26 +++++++++++-----------
 fs/smb/server/smb2pdu.c           | 36 ++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index d3483d9c757c7..5f75f19f9f9f9 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -77,7 +77,7 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 	tree_conn->share_conf = sc;
 	tree_conn->t_state = TREE_NEW;
 	status.tree_conn = tree_conn;
-	atomic_set(&tree_conn->refcount, 1);
+	atomic_set(&tree_conn->refcount, 2);
 
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      KSMBD_DEFAULT_GFP));
@@ -99,8 +99,10 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 
 void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon)
 {
-	if (atomic_dec_and_test(&tcon->refcount))
+	if (atomic_dec_and_test(&tcon->refcount)) {
+		ksmbd_share_config_put(tcon->share_conf);
 		kfree(tcon);
+	}
 }
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
@@ -109,14 +111,21 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 	int ret;
 
 	write_lock(&sess->tree_conns_lock);
+	if (tree_conn->t_state == TREE_DISCONNECTED ||
+	    xa_load(&sess->tree_conns, tree_conn->id) != tree_conn) {
+		write_unlock(&sess->tree_conns_lock);
+		return -ENOENT;
+	}
+	tree_conn->t_state = TREE_DISCONNECTED;
 	xa_erase(&sess->tree_conns, tree_conn->id);
 	write_unlock(&sess->tree_conns_lock);
 
 	ret = ksmbd_ipc_tree_disconnect_request(sess->id, tree_conn->id);
 	ksmbd_release_tree_conn_id(sess, tree_conn->id);
-	ksmbd_share_config_put(tree_conn->share_conf);
-	if (atomic_dec_and_test(&tree_conn->refcount))
+	if (atomic_dec_and_test(&tree_conn->refcount)) {
+		ksmbd_share_config_put(tree_conn->share_conf);
 		kfree(tree_conn);
+	}
 	return ret;
 }
 
@@ -148,15 +157,6 @@ int ksmbd_tree_conn_session_logoff(struct ksmbd_session *sess)
 		return -EINVAL;
 
 	xa_for_each(&sess->tree_conns, id, tc) {
-		write_lock(&sess->tree_conns_lock);
-		if (tc->t_state == TREE_DISCONNECTED) {
-			write_unlock(&sess->tree_conns_lock);
-			ret = -ENOENT;
-			continue;
-		}
-		tc->t_state = TREE_DISCONNECTED;
-		write_unlock(&sess->tree_conns_lock);
-
 		ret |= ksmbd_tree_conn_disconnect(sess, tc);
 	}
 	xa_destroy(&sess->tree_conns);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5795a19bb4cb9..892fcc06c1ab0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2001,6 +2001,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
+	struct ksmbd_tree_connect *tree_conn = NULL;
 	struct ksmbd_share_config *share = NULL;
 	int rc = -EINVAL;
 
@@ -2025,9 +2026,10 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		    name, treename);
 
 	status = ksmbd_tree_conn_connect(work, name);
-	if (status.ret == KSMBD_TREE_CONN_STATUS_OK)
+	if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
+		tree_conn = status.tree_conn;
 		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
-	else
+	} else
 		goto out_err1;
 
 	share = status.tree_conn->share_conf;
@@ -2059,8 +2061,15 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		status.tree_conn->posix_extensions = true;
 
 	write_lock(&sess->tree_conns_lock);
-	status.tree_conn->t_state = TREE_CONNECTED;
+	if (status.tree_conn->t_state == TREE_DISCONNECTED) {
+		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
+		share = NULL;
+	} else {
+		status.tree_conn->t_state = TREE_CONNECTED;
+	}
 	write_unlock(&sess->tree_conns_lock);
+	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+		goto out_err1;
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
 	/*
@@ -2073,8 +2082,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
 
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
-	if (rc)
+	if (rc) {
+		if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
+			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
+			status.tree_conn = NULL;
+		}
 		status.ret = KSMBD_TREE_CONN_STATUS_NOMEM;
+	}
 
 	if (!IS_ERR(treename))
 		kfree(treename);
@@ -2110,6 +2124,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
 		smb2_set_err_rsp(work);
 
+	if (tree_conn)
+		ksmbd_tree_connect_put(tree_conn);
+
 	return rc;
 }
 
@@ -2213,17 +2230,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 
 	ksmbd_close_tree_conn_fds(work);
 
-	write_lock(&sess->tree_conns_lock);
-	if (tcon->t_state == TREE_DISCONNECTED) {
-		write_unlock(&sess->tree_conns_lock);
-		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
-		err = -ENOENT;
-		goto err_out;
-	}
-
-	tcon->t_state = TREE_DISCONNECTED;
-	write_unlock(&sess->tree_conns_lock);
-
 	err = ksmbd_tree_conn_disconnect(sess, tcon);
 	if (err) {
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
-- 
2.53.0



