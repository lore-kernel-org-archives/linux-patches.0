Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590116;
	b=B5S25zkCqis4Ok/l2yYBYGdsNPCOgnMkFJCrY4DimwnFa0GfHb7s3zRTzu8sRSsSZ3FF
	 kQKJrRPFjPEObEWhssKUMp+GOQu0Dw5TfQUp3tp3Xztp89KTLjIIXmfeKZlz0xvymrxpa
	 eNCznmLuYW7dxrLR2CqsFA8GQ33XMdSsBJTlOJWVlekW225Qx/YVOuA4v/iYfCwrdJiFX
	 lRh9dBFSLI5m9I6ryWAx1q0mkF8zQ8jQKxR97/CnMQHBar/t1+Dvup03edfUiOQUCEP7I
	 MRL0X1DJ2DUm49bv7Uge7mzpn5bicVbVE7WGJrxw1gWfICfZZBW4rvvBVmug5Z+vzQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AFeJo6v9o5SIjktA/RkLQyyOYC6iA5CXEzblNziamzc=;
	b=myPdDVt1oRRazdNyW28teW0U92637pL9q30z3wuK8wbvFeycuBzlgAZMDfhYCl1QP0Ws
	 wQ4rtNiDjSPz1mCQfUxQF/1nsHe6sEC7TrET8nAEbavWxm29UyGUIVLT2VoBiQNOVFEtG
	 ngkfyFbunHfEZYkyvkgm0qHNbZEwyMGu7K9gSTtKUrsXOggCmF5YvEu3KqaXVYduv8yk9
	 4yyvGJFGixIjP+cfM4iaBlsehJkr4vCCvpwr5NyrvLkiLtC75LEBG8XUfk9pyD87dqHc1
	 DqjrYwLNt3sjt80hlCSukV6ihbUsFwhBuzKmrO4W8fMy/z49xi9mQdqTlEVSG365Cmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y439CHDl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5F8606B22B;
	Fri, 13 Nov 2026 17:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y439CHDl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A711F000C4;
	Fri, 13 Nov 2026 17:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590116;
	bh=AFeJo6v9o5SIjktA/RkLQyyOYC6iA5CXEzblNziamzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y439CHDlDsOKopzERzqQiBhYX3ddUrnuBZObrlRfI/D95jNZSwna3X9mcbRuI31NR
	 MyHO+zvqN2C0owIjDfBZ+AZqFDhdvaSlNoXUZdJiYIXg44jV0zT8yOPO69Goyq8Rcd
	 szqYb28LOYGy1OPc4L+g5JN1TZAlL8Urq8h/VYnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/686] ksmbd: fix tree connection use-after-free in smb2_tree_connect()
Date: Fri, 13 Nov 2026 10:43:47 -0500
Message-ID: <20261113153824.052795198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the smb2_tree_connect() hunk to the older brace-less if/else layout and fixed the context for the missing counter-decrement line in tree_connect.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/tree_connect.c |  8 ++++++++
 fs/smb/server/smb2pdu.c           | 32 +++++++++++++++----------------
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index c7a89eddcda7b..6d8f3ebcbc53d 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -82,6 +82,8 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 	down_write(&sess->tree_conns_lock);
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      KSMBD_DEFAULT_GFP));
+	if (!ret)
+		atomic_inc(&tree_conn->refcount);
 	up_write(&sess->tree_conns_lock);
 	if (ret) {
 		status.ret = -ENOMEM;
@@ -122,6 +124,12 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
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
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1cbc425d7273e..40d86993dbe3d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2023,6 +2023,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
+	struct ksmbd_tree_connect *tree_conn = NULL;
 	struct ksmbd_share_config *share = NULL;
 	int rc = -EINVAL;
 
@@ -2049,9 +2050,10 @@ int smb2_tree_connect(struct ksmbd_work *work)
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
@@ -2083,8 +2085,15 @@ int smb2_tree_connect(struct ksmbd_work *work)
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
 	/*
@@ -2099,9 +2108,6 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
 	if (rc) {
 		if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
-			down_write(&sess->tree_conns_lock);
-			status.tree_conn->t_state = TREE_DISCONNECTED;
-			up_write(&sess->tree_conns_lock);
 			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
 			status.tree_conn = NULL;
 		}
@@ -2142,6 +2148,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
 		smb2_set_err_rsp(work);
 
+	if (tree_conn)
+		ksmbd_tree_connect_put(tree_conn);
+
 	return rc;
 }
 
@@ -2245,17 +2254,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 
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
-- 
2.53.0



