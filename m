Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D89828853A;
	Wed,  4 Feb 2026 15:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217275; cv=none; b=OQadao3av72NbL/+a39+mQ9/b3QVk63LJD+WbZF7Y2BInKm8Glyx/EUH90GjhcBX68axsfYFVCAkaommkU4980X1LO6mcs94zLp0JPvmmwR0uIX94IHWxQTJ+Ms90+fLNt2xQnunx2pQKQvxutHSbT4fk4XT7/muiYQAcwU+pfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217275; c=relaxed/simple;
	bh=FCM45A789tGL89W4sQ+jJj9aX6lwFMqIZ5iokV/7IbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+QJp0jkmixraHiatmTp8ZTx6LdhGvCwaydJLi8QyueSmQSm76+a40ES0247d3OEmFKl0joWmYdrQi6NaNvx7LebJmB2wocOqKW20sh4QyW4vTJBL26ffH9WWsXs7HJgqTEzzv3b3dJ5W66GhXjqaC1M9+BDej6Co1AQHtWP84I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRy+iaBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRy+iaBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BA6C116C6;
	Wed,  4 Feb 2026 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217275;
	bh=FCM45A789tGL89W4sQ+jJj9aX6lwFMqIZ5iokV/7IbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRy+iaBxQLXhATSIExSN1aoR/e+3LmAuSSICYPOLxxyrBtcXhxz69/Ml+bMmCut5r
	 ItsC1yvl6nFTrV7SVufjUpsZlUFMpMpH+sx8KLjau/Ga1bwVugmc5tsNH8w5e2tVwn
	 AQeJaPIdkiLIj1TMIU5ZZjKIQYFashEmYbXl2XCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 5.15 176/206] ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency
Date: Wed,  4 Feb 2026 15:40:07 +0100
Message-ID: <20260204143904.552224393@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/mgmt/tree_connect.c |   18 ++++--------------
 fs/ksmbd/mgmt/tree_connect.h |    1 -
 fs/ksmbd/smb2pdu.c           |    3 ---
 3 files changed, 4 insertions(+), 18 deletions(-)

--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -76,7 +76,6 @@ ksmbd_tree_conn_connect(struct ksmbd_con
 	tree_conn->t_state = TREE_NEW;
 	status.tree_conn = tree_conn;
 	atomic_set(&tree_conn->refcount, 1);
-	init_waitqueue_head(&tree_conn->refcount_q);
 
 	ret = xa_err(xa_store(&sess->tree_conns, tree_conn->id, tree_conn,
 			      GFP_KERNEL));
@@ -98,14 +97,8 @@ out_error:
 
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
@@ -117,14 +110,11 @@ int ksmbd_tree_conn_disconnect(struct ks
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
 
--- a/fs/ksmbd/mgmt/tree_connect.h
+++ b/fs/ksmbd/mgmt/tree_connect.h
@@ -32,7 +32,6 @@ struct ksmbd_tree_connect {
 	int				maximal_access;
 	bool				posix_extensions;
 	atomic_t			refcount;
-	wait_queue_head_t		refcount_q;
 	unsigned int			t_state;
 };
 
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2169,7 +2169,6 @@ int smb2_tree_disconnect(struct ksmbd_wo
 		goto err_out;
 	}
 
-	WARN_ON_ONCE(atomic_dec_and_test(&tcon->refcount));
 	tcon->t_state = TREE_DISCONNECTED;
 	write_unlock(&sess->tree_conns_lock);
 
@@ -2179,8 +2178,6 @@ int smb2_tree_disconnect(struct ksmbd_wo
 		goto err_out;
 	}
 
-	work->tcon = NULL;
-
 	rsp->StructureSize = cpu_to_le16(4);
 	err = ksmbd_iov_pin_rsp(work, rsp,
 				sizeof(struct smb2_tree_disconnect_rsp));


