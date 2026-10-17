Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0667621FF23;
	Sat, 17 Oct 2026 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259794; cv=none; b=ueyV1EvMBTGquM/bfqMfedRLJlECJOGcCFV5eWZ+/0nR95FDs62n81c2YwkqWklnrRUxEyFs8oNYOb2slfrX4lpIQgC+NaHGzmUb3tyiiXCBvSY63hK9Lnk3qWaHGgbuHgaWOLsS3MeUstTC9ArTg4+FgPwSuopB3DtpHQLrH8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259794; c=relaxed/simple;
	bh=hMQhJkVGKN9Oo/OqOXSy7AHAMxgrVMw5RtcWwsMJ6eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaYpY0wfGJ1ELaBc/Dkl6ZXxMBOTlrvYNno02D95YIfjUGTo2cxVyN3lGdAO3oEogQOaWdvyxrAmZ8GL1J3Qem5sYAKdihaiPxYNVwe0V6UgDOUq6SrElyNzctzO7PiW36SQkIFoSLRj1EfUaf2Cux/9XxOo1ItjN5Nfh3UqNMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4gR0uPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4gR0uPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCE11F000C4;
	Sat, 17 Oct 2026 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259792;
	bh=/eBBT0DpFmHh9b2/4MN6/dBDfZv4Zeoq1tlYTKoTlTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4gR0uPx8GXR4zJi0gNwIVGY05LaVUTcrxBAc3lj43fp6/IksludYQnwegjQ85d0h
	 NxZfl90kZCFXe8+dysw0KFFYMpo/QQaAI22Eqtd74JIQgIQy6PzbSn9QFNjrtAc1e0
	 GOzvuZGHFExdaQ63bhOElWGlcipTwGfE+00FWtNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <cenzhang@linux.microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1333/1674] ksmbd: fix tree connection use-after-free in smb2_tree_connect()
Date: Sat, 17 Oct 2026 18:00:05 +0200
Message-ID: <20261017160505.362046836@linuxfoundation.org>
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
 fs/smb/server/mgmt/tree_connect.c | 20 ++++++++------------
 fs/smb/server/smb2pdu.c           | 28 ++++++++++++++--------------
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index 9bde1b58f9c46..8f963602935cd 100644
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
@@ -108,6 +108,12 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
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
index 4f4307ce1482d..90186e062257a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1991,6 +1991,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	struct ksmbd_session *sess = work->sess;
 	char *treename = NULL, *name = NULL;
 	struct ksmbd_tree_conn_status status;
+	struct ksmbd_tree_connect *tree_conn = NULL;
 	struct ksmbd_share_config *share = NULL;
 	int rc = -EINVAL;
 
@@ -2015,10 +2016,12 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		    name, treename);
 
 	status = ksmbd_tree_conn_connect(work, name);
-	if (status.ret == KSMBD_TREE_CONN_STATUS_OK)
+	if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
+		tree_conn = status.tree_conn;
 		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
-	else
+	} else {
 		goto out_err1;
+	}
 
 	share = status.tree_conn->share_conf;
 	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
@@ -2049,8 +2052,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
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
 	/*
@@ -2100,6 +2108,9 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (status.ret != KSMBD_TREE_CONN_STATUS_OK)
 		smb2_set_err_rsp(work);
 
+	if (tree_conn)
+		ksmbd_tree_connect_put(tree_conn);
+
 	return rc;
 }
 
@@ -2201,17 +2212,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 
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



