Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ABB3D1CA8;
	Tue,  3 Feb 2026 16:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136220; cv=none; b=eM4DJOaXu7IQJJDRgMNK7OMFx6PJfPJycVzkwFcEQkjAyIUFixpzMxM33DeSnjZrjhEeWVsKU9fCNtbv+4NJxCXWYzEYh66tvGf3FW83qyanrm7/1uC2q7bxIvOxlf2PSSJo7NxqREhvc4skTSfQ04S3+OgEPRfv04uO6Fax5uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136220; c=relaxed/simple;
	bh=YLhurln1Qpsrds86Ove/2+NodwhaBlhKxHIBrnVHOtg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=L5zqkjedTNHyV/yY8GgGF9xv1Iy3uKSHMpBO1sIHBSZ3nh5o7L9vFUG93BnQS7Twb4xnf+jVbdzMA+t/KaAatEq1zzQgJX4TBBbxVZe3YaKNTVUWyo8Hspvuf1Ija8qpYHjreoJ8ZxS6JkDmbV7YWnq+YRsN4Au3X38YCdbPu8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SO0Eg0qB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SO0Eg0qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA9FC116D0;
	Tue,  3 Feb 2026 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770136220;
	bh=YLhurln1Qpsrds86Ove/2+NodwhaBlhKxHIBrnVHOtg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=SO0Eg0qBRFRJcHHJVC/D+GX/UdIvBXycDqpACRg8NrSUAYo/q2Nz+hkHEgrpMM+u7
	 rVAe23Ew/rMqZERFceRM6aEoeCSrz5NPewxSB4cjSKcvo6JRtWWCEpI+ckFxh8DfOz
	 0Fp8zNn7oJaAWnTqKd3yWaKD8Wlts9wv6RZ2asD0=
Subject: Patch "ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency" has been added to the 5.15-stable tree
To: 681739313@139.com,gregkh@linuxfoundation.org,hyc.lee@gmail.com,linkinjeon@kernel.org,liuzhitong1993@gmail.com,patches@lists.linux.dev,pioooooooooip@gmail.com,senozhatsky@chromium.org,sfrench@samba.org,stfrench@microsoft.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 03 Feb 2026 17:29:23 +0100
In-Reply-To: <20260122034212.3111671-1-681739313@139.com>
Message-ID: <2026020323-immersion-explain-7aac@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ksmbd-fix-use-after-free-in-ksmbd_tree_connect_put-under-concurrency.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-211192-greg=kroah.com@vger.kernel.org Thu Jan 22 04:56:32 2026
From: Rajani Kantha <681739313@139.com>
Date: Thu, 22 Jan 2026 11:42:12 +0800
Subject: ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, linkinjeon@kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, senozhatsky@chromium.org, sfrench@samba.org, hyc.lee@gmail.com, linux-cifs@vger.kernel.org, pioooooooooip@gmail.com, liuzhitong1993@gmail.com, stfrench@microsoft.com
Message-ID: <20260122034212.3111671-1-681739313@139.com>

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


Patches currently in stable-queue which might be from 681739313@139.com are

queue-5.15/ksmbd-fix-use-after-free-in-ksmbd_tree_connect_put-under-concurrency.patch
