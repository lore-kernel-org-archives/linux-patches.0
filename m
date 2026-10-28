Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216193;
	b=dJDs9nTBhH9BvYHsePDb8ejhYUVUVYYlytaoSTqvreOczWEainKdoBKqVCP3BhesfgbI
	 D33k5XWv8ddaWGbf3CsV9wUPHjWGgh6Dng/tfSXMqboYEdRwX+KCK12cSha5fvlXvjhi8
	 BF8Fg4untG4MSTOMxIziOrc2vp5a3xaACJJKr1CmsT9oTyMURfo9xmLdwThIzKIfOuAS+
	 RVLpK31mybOkWBe0IlXkxYRqQDUu8Z15bnmU+pkDl2We5JDLinCm6Vf+/sJfTGFve7CLv
	 /ifl7bKZhJM5bZ7zTUFsJv4PWV3+KShLeDou0cSMdlB2P8blP78Ca/V1e2uIGBCwtOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/zhbimnptEWOb+wZUf0NX4+nQI6OMzOenzJDwhpaPq4=;
	b=yMj2ndrccGmOjCmxhH2Bo/Qb91DFIu77pwnas67CwB+nVUR8OhQY0R+RxH+ofGoTW6ap
	 j7Iz42G62Jq3RYkuyy1I0txrKf2COQ8oVn6ztVKT1yCZYFPZmKrqM/VXvTrp2SNFo041r
	 drHva1y7s1rZTm2BkZvPnkXMDh2x7rGdvQEIt8QqB+lSJLFBJWTvZRX7j/6908fapGSuo
	 UnXkCmuZbADZicZUUeMWqL7W26zk2m5CMPObWLTPJ0ml/SzSZSdbk8Zos2tEQ9zITqd9g
	 EJZKTXC62R4NnP8qlkEE67eYnGzjrrs8eTlSTvs/HRBFmOnYNRWq0qDKOWCd0ky5LAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ybkOy6PA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711F1606A31A;
	Wed, 28 Oct 2026 19:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ybkOy6PA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6B31F01825;
	Wed, 28 Oct 2026 19:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216193;
	bh=/zhbimnptEWOb+wZUf0NX4+nQI6OMzOenzJDwhpaPq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybkOy6PAtUuDlzJQ9qsJzPf48flrF1FPf85gkpek6LDinJGeFp0Owkef+b/0wVZhL
	 Ep89QxIS7DP1XuY2qLPuNsBjI9L3vnfVyaRdfAry2R5YkvGVEf0nI4AovLCPJI+UIB
	 sQNrj3rsgZ96wiFbiXiOD7kOqxKrtrkTqWTMZqcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1474/1887] ksmbd: fix tree connection use-after-free in smb2_tree_connect()
Date: Wed, 28 Oct 2026 17:59:30 +0100
Message-ID: <20261028170532.998816085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/mgmt/tree_connect.c | 28 +++++++++++--------------
 fs/smb/server/smb2pdu.c           | 34 +++++++++++++++++--------------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index 9bde1b58f9c46..02c46e07aa87a 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -76,7 +76,7 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 	tree_conn->share_conf = sc;
 	tree_conn->t_state = TREE_NEW;
 	status.tree_conn = tree_conn;
-	atomic_set(&tree_conn->refcount, 1);
+	atomic_set(&tree_conn->refcount, 2);
 
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      GFP_KERNEL));
@@ -98,8 +98,10 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 
 void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon)
 {
-	if (atomic_dec_and_test(&tcon->refcount))
+	if (atomic_dec_and_test(&tcon->refcount)) {
+		ksmbd_share_config_put(tcon->share_conf);
 		kfree(tcon);
+	}
 }
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
@@ -108,14 +110,18 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
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
-		kfree(tree_conn);
+	ksmbd_tree_connect_put(tree_conn);
 	return ret;
 }
 
@@ -146,18 +152,8 @@ int ksmbd_tree_conn_session_logoff(struct ksmbd_session *sess)
 	if (!sess)
 		return -EINVAL;
 
-	xa_for_each(&sess->tree_conns, id, tc) {
-		write_lock(&sess->tree_conns_lock);
-		if (tc->t_state == TREE_DISCONNECTED) {
-			write_unlock(&sess->tree_conns_lock);
-			ret = -ENOENT;
-			continue;
-		}
-		tc->t_state = TREE_DISCONNECTED;
-		write_unlock(&sess->tree_conns_lock);
-
+	xa_for_each(&sess->tree_conns, id, tc)
 		ret |= ksmbd_tree_conn_disconnect(sess, tc);
-	}
 	xa_destroy(&sess->tree_conns);
 	return ret;
 }
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 487aff42b912c..7112d013b3529 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2008,6 +2008,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
+	struct ksmbd_tree_connect *tree_conn = NULL;
 	struct ksmbd_share_config *share;
 	int rc = -EINVAL;
 
@@ -2032,9 +2033,10 @@ int smb2_tree_connect(struct ksmbd_work *work)
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
@@ -2066,8 +2068,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		status.tree_conn->posix_extensions = true;
 
 	write_lock(&sess->tree_conns_lock);
-	status.tree_conn->t_state = TREE_CONNECTED;
+	if (status.tree_conn->t_state == TREE_DISCONNECTED)
+		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
+	else
+		status.tree_conn->t_state = TREE_CONNECTED;
 	write_unlock(&sess->tree_conns_lock);
+	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+		goto out_err1;
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
 	rsp->Capabilities = 0;
@@ -2076,8 +2083,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
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
@@ -2113,6 +2125,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
 		smb2_set_err_rsp(work);
 
+	if (tree_conn)
+		ksmbd_tree_connect_put(tree_conn);
+
 	return rc;
 }
 
@@ -2214,17 +2229,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 
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



