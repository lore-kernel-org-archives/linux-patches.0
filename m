Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66AA347FD0;
	Tue,  6 Jan 2026 17:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719884; cv=none; b=N+nyqBgY5fbvGS+3Is+Teh6vNkjGOq0o+50hMFFiiza+5I7Pjao5xhhkEZkhWkwb4jKviREqco2etbIAXoyz+W9ps0Yc2MEGAX45fMEvvQ6v3D7EYD4n/dUiJCHX5MNgIF0ASlEs0xLintnxyYrtC/8FzeAotcvTAJqKvYaMqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719884; c=relaxed/simple;
	bh=dDt7IDTu5F1hqNeCwPp0BATHDU4OavLjJ4O5+H4X3ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5XzSJvi5DRiNi3pHg+1/eBAtPQY0Ro0a3CeQI+y3CgBnBuTNHd3WUTYfhbbhsAtToEpUgfSvOU89yu+u1RhqyMwgYcDTJD9Bg4SkOiFFXYbkwDK5hkoTi5Cr4TeyaQAAWjE1kON2NchzY+7r6qU96w6pris18SZG9XzMyKv8HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRG/9XW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRG/9XW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB90C116C6;
	Tue,  6 Jan 2026 17:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719884;
	bh=dDt7IDTu5F1hqNeCwPp0BATHDU4OavLjJ4O5+H4X3ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRG/9XW/OctSGv1Qg10BIEVO0I2qTkn8EQ3jJtrS2yFTqmvhI4k8YTf11C9z5TmX2
	 m6yTqYTBOvUQGfxSvulv0oUR5ZMiqU/A5Ad8YKkYpflxQAp/S7Wly3BjJ36i2ffi9r
	 oiczLN/eUIwycvQBKCZHaLRMaNSogIvg3NM9u9rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/567] ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency
Date: Tue,  6 Jan 2026 17:56:59 +0100
Message-ID: <20260106170452.712061082@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit b39a1833cc4a2755b02603eec3a71a85e9dff926 ]

Under high concurrency, A tree-connection object (tcon) is freed on
a disconnect path while another path still holds a reference and later
executes *_put()/write on it.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/tree_connect.c | 18 ++++--------------
 fs/smb/server/mgmt/tree_connect.h |  1 -
 fs/smb/server/smb2pdu.c           |  3 ---
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/mgmt/tree_connect.c b/fs/smb/server/mgmt/tree_connect.c
index ecfc575086712..d3483d9c757c7 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -78,7 +78,6 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 	tree_conn->t_state = TREE_NEW;
 	status.tree_conn = tree_conn;
 	atomic_set(&tree_conn->refcount, 1);
-	init_waitqueue_head(&tree_conn->refcount_q);
 
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      KSMBD_DEFAULT_GFP));
@@ -100,14 +99,8 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 
 void ksmbd_tree_connect_put(struct ksmbd_tree_connect *tcon)
 {
-	/*
-	 * Checking waitqueue to releasing tree connect on
-	 * tree disconnect. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	if (!atomic_dec_return(&tcon->refcount) &&
-	    waitqueue_active(&tcon->refcount_q))
-		wake_up(&tcon->refcount_q);
+	if (atomic_dec_and_test(&tcon->refcount))
+		kfree(tcon);
 }
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
@@ -119,14 +112,11 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 	xa_erase(&sess->tree_conns, tree_conn->id);
 	write_unlock(&sess->tree_conns_lock);
 
-	if (!atomic_dec_and_test(&tree_conn->refcount))
-		wait_event(tree_conn->refcount_q,
-			   atomic_read(&tree_conn->refcount) == 0);
-
 	ret = ksmbd_ipc_tree_disconnect_request(sess->id, tree_conn->id);
 	ksmbd_release_tree_conn_id(sess, tree_conn->id);
 	ksmbd_share_config_put(tree_conn->share_conf);
-	kfree(tree_conn);
+	if (atomic_dec_and_test(&tree_conn->refcount))
+		kfree(tree_conn);
 	return ret;
 }
 
diff --git a/fs/smb/server/mgmt/tree_connect.h b/fs/smb/server/mgmt/tree_connect.h
index a42cdd0510411..f0023d86716f2 100644
--- a/fs/smb/server/mgmt/tree_connect.h
+++ b/fs/smb/server/mgmt/tree_connect.h
@@ -33,7 +33,6 @@ struct ksmbd_tree_connect {
 	int				maximal_access;
 	bool				posix_extensions;
 	atomic_t			refcount;
-	wait_queue_head_t		refcount_q;
 	unsigned int			t_state;
 };
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d9e28191c267e..b32df37da70d4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2190,7 +2190,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	WARN_ON_ONCE(atomic_dec_and_test(&tcon->refcount));
 	tcon->t_state = TREE_DISCONNECTED;
 	write_unlock(&sess->tree_conns_lock);
 
@@ -2200,8 +2199,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	work->tcon = NULL;
-
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp,
 				sizeof(struct smb2_tree_disconnect_rsp));
-- 
2.51.0



