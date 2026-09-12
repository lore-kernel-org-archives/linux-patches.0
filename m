Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8794C39A803;
	Sat, 12 Sep 2026 07:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196696; cv=none; b=X1iW71hVePODcaYExFpyxU5WDLEwez95pkMmXlFyEWnLtj8f02QbUJqvVFOzRSbyxHOi0YwKxmdIT5THNbZ3i9W4Gidzc/eopGWGHDe3+X/T09hNoQDTxnv8e2jeye+ZI1wsaqDoh7nBw/PFSKAdza6XVLHLUonS0yC6GFCGMDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196696; c=relaxed/simple;
	bh=1FMOELNBhkq8LNrYzdBdnp00ZnHvAUeTZ4hC3ybwGaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhWl/XKPLEVsofap7KbS2Ln2dALr1/plQTm+d7YuzMuiXCUAGwjrrE89GDPvp3586/c3cxwUdz/BRiVnVQsBfkTA5nGZuKP0iQ+4au5D3U3JnPWh1YTwd7mhZobmPlrwzxMqgQlcA3x8br/rSQPCju7NjbslSBCiulSpbcPFvNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRfcqKqm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRfcqKqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4085A1F000FF;
	Sat, 12 Sep 2026 07:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196694;
	bh=3kI9D+MjA4hgm/F0WO6InM/7y3MyXeB1I2T54aLm10s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRfcqKqm1ydCEhjY1c6PSelKQT7Ae/0A//ag/4F6ymvvlU/31+tvsA5Y/rXOrVIys
	 TCTOtCZAOaVt/W6N3l4GE71kwqoTULUxwXwlKh0HgwLDEO8PbNPNrNyxhtIGC4ogNy
	 nB20Gu7JPZV5AP11KXhR4a665RbsLxEAxGsm66yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0019/1815] ksmbd: fix tree connection use-after-free in smb2_tree_connect()
Date: Sat, 12 Sep 2026 08:29:29 +0200
Message-ID: <20260912065649.458608624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>

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
[ added braces around the successful-connect if branch to accommodate the new tree_conn assignment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/tree_connect.c |    8 ++++++++
 fs/smb/server/smb2pdu.c           |   32 +++++++++++++++-----------------
 2 files changed, 23 insertions(+), 17 deletions(-)

--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -82,6 +82,8 @@ ksmbd_tree_conn_connect(struct ksmbd_wor
 	down_write(&sess->tree_conns_lock);
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      KSMBD_DEFAULT_GFP));
+	if (!ret)
+		atomic_inc(&tree_conn->refcount);
 	up_write(&sess->tree_conns_lock);
 	if (ret) {
 		status.ret = -ENOMEM;
@@ -127,6 +129,12 @@ int ksmbd_tree_conn_disconnect(struct ks
 			       struct ksmbd_tree_connect *tree_conn)
 {
 	down_write(&sess->tree_conns_lock);
+	if (tree_conn->t_state == TREE_DISCONNECTED ||
+	    xa_load(&sess->tree_conns, tree_conn->id) != tree_conn) {
+		up_write(&sess->tree_conns_lock);
+		return -ENOENT;
+	}
+	tree_conn->t_state = TREE_DISCONNECTED;
 	xa_erase(&sess->tree_conns, tree_conn->id);
 	up_write(&sess->tree_conns_lock);
 
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2251,6 +2251,7 @@ int smb2_tree_connect(struct ksmbd_work
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
+	struct ksmbd_tree_connect *tree_conn = NULL;
 	struct ksmbd_share_config *share = NULL;
 	int rc = -EINVAL;
 
@@ -2277,9 +2278,10 @@ int smb2_tree_connect(struct ksmbd_work
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
@@ -2311,8 +2313,15 @@ int smb2_tree_connect(struct ksmbd_work
 		status.tree_conn->posix_extensions = true;
 
 	down_write(&sess->tree_conns_lock);
-	status.tree_conn->t_state = TREE_CONNECTED;
+	if (status.tree_conn->t_state == TREE_DISCONNECTED) {
+		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
+		share = NULL;
+	} else {
+		status.tree_conn->t_state = TREE_CONNECTED;
+	}
 	up_write(&sess->tree_conns_lock);
+	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
+		goto out_err1;
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE && share &&
@@ -2332,9 +2341,6 @@ out_err1:
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
 	if (rc) {
 		if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
-			down_write(&sess->tree_conns_lock);
-			status.tree_conn->t_state = TREE_DISCONNECTED;
-			up_write(&sess->tree_conns_lock);
 			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
 			status.tree_conn = NULL;
 		}
@@ -2375,6 +2381,9 @@ out_err1:
 	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
 		smb2_set_err_rsp(work);
 
+	if (tree_conn)
+		ksmbd_tree_connect_put(tree_conn);
+
 	return rc;
 }
 
@@ -2478,17 +2487,6 @@ int smb2_tree_disconnect(struct ksmbd_wo
 
 	ksmbd_close_tree_conn_fds(work);
 
-	down_write(&sess->tree_conns_lock);
-	if (tcon->t_state == TREE_DISCONNECTED) {
-		up_write(&sess->tree_conns_lock);
-		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
-		err = -ENOENT;
-		goto err_out;
-	}
-
-	tcon->t_state = TREE_DISCONNECTED;
-	up_write(&sess->tree_conns_lock);
-
 	err = ksmbd_tree_conn_disconnect(sess, tcon);
 	if (err) {
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;


