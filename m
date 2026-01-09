Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A9C1946C8;
	Fri,  9 Jan 2026 12:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960308; cv=none; b=OsauNsSU47UPGybJEpw0SorrfyB/SA2kuR9tVzewt+rFAqnMACtODAxWjCJmQR/IF2F9gz7MUZw18TGpRTCRYxopqqz4oJuecb2QGtBPrRi9UTniwis//ktxHMfNs9C+TzhyLlw34KQAIgAXLPTIxV9pGf4ZwBvWASq6CKfdtss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960308; c=relaxed/simple;
	bh=Ph6djnrdvqy3jE4J9JqA8tQW+qOJV7gLLQhHWplItDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KA3EihD0HWPpVhXDmPJB4UUGD3PUsl2eHeKngdKvLMbm23s7mORgNCAWAgYp9SFRRwZwSh//TjWWiadLhYqywL1glZoD7cTdEU8seJgR3JNVURMVRXti9wwnaAf4w5hPop+1YoPYxA1U35EnHezhb4QJ0/P2fmocORmqFkq6RnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ok6PFDCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ok6PFDCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CF4C4CEF1;
	Fri,  9 Jan 2026 12:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960308;
	bh=Ph6djnrdvqy3jE4J9JqA8tQW+qOJV7gLLQhHWplItDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ok6PFDCHBAnTneyYBItk3KQzMmQ6grzgyHbhkIuP7748+TXe440NaKyj7ieoKs0N4
	 M0/Yb9141kQts5pHAGRffaaz7X3ztJCotAFwC9/3/t6tn+d/DSjZ5L+tTFBGXDjJkR
	 LL5M6asy6WpYH5QzxN9VLEL4N6gnE+1uexnB//Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 326/737] ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency
Date: Fri,  9 Jan 2026 12:37:45 +0100
Message-ID: <20260109112146.259804906@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 94a52a75014a4..9bde1b58f9c46 100644
--- a/fs/smb/server/mgmt/tree_connect.c
+++ b/fs/smb/server/mgmt/tree_connect.c
@@ -77,7 +77,6 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 	tree_conn->t_state = TREE_NEW;
 	status.tree_conn = tree_conn;
 	atomic_set(&tree_conn->refcount, 1);
-	init_waitqueue_head(&tree_conn->refcount_q);
 
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      GFP_KERNEL));
@@ -99,14 +98,8 @@ ksmbd_tree_conn_connect(struct ksmbd_work *work, const char *share_name)
 
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
@@ -118,14 +111,11 @@ int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
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
index 8fa68c3b24f3f..77b06fd984be6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2183,7 +2183,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	WARN_ON_ONCE(atomic_dec_and_test(&tcon->refcount));
 	tcon->t_state = TREE_DISCONNECTED;
 	write_unlock(&sess->tree_conns_lock);
 
@@ -2193,8 +2192,6 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	work->tcon = NULL;
-
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp,
 				sizeof(struct smb2_tree_disconnect_rsp));
-- 
2.51.0



