Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD92C47A6C;
	Wed, 20 Dec 2023 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROW1lrE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B9EC433C8;
	Wed, 20 Dec 2023 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088675;
	bh=umMyhwSNRhOvFZcZkaGgeOAfOMWdqqstC7V9QoiycPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROW1lrE+E8Bipbf4P99SeMqromJl7HSnupxMTOIsCZBB/5ZOL/bHxgtPSBxO3ybCJ
	 JQgPlW5UFfRszOlsXc+gErW1jW2BnCibt06ZU2rdoSjnNZitXPVGnHa1taakcbA8v1
	 mDg2xwBuJXMi71OvSErN0EjvxOQzyLZGWOfErgQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 018/159] ksmbd: smbd: call rdma_accept() under CM handler
Date: Wed, 20 Dec 2023 17:08:03 +0100
Message-ID: <20231220160932.123921668@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 99b7650ac51847e81b4d5139824e321e6cb76130 ]

if CONFIG_LOCKDEP is enabled, the following
kernel warning message is generated because
rdma_accept() checks whehter the handler_mutex
is held by lockdep_assert_held. CM(Connection
Manager) holds the mutex before CM handler
callback is called.

[   63.211405 ] WARNING: CPU: 1 PID: 345 at drivers/infiniband/core/cma.c:4405 rdma_accept+0x17a/0x350
[   63.212080 ] RIP: 0010:rdma_accept+0x17a/0x350
...
[   63.214036 ] Call Trace:
[   63.214098 ]  <TASK>
[   63.214185 ]  smb_direct_accept_client+0xb4/0x170 [ksmbd]
[   63.214412 ]  smb_direct_prepare+0x322/0x8c0 [ksmbd]
[   63.214555 ]  ? rcu_read_lock_sched_held+0x3a/0x70
[   63.214700 ]  ksmbd_conn_handler_loop+0x63/0x270 [ksmbd]
[   63.214826 ]  ? ksmbd_conn_alive+0x80/0x80 [ksmbd]
[   63.214952 ]  kthread+0x171/0x1a0
[   63.215039 ]  ? set_kthread_struct+0x40/0x40
[   63.215128 ]  ret_from_fork+0x22/0x30

To avoid this, move creating a queue pair and accepting
a client from transport_ops->prepare() to
smb_direct_handle_connect_request().

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |  102 ++++++++++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 43 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -574,6 +574,7 @@ static void recv_done(struct ib_cq *cq,
 		}
 		t->negotiation_requested = true;
 		t->full_packet_received = true;
+		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		break;
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
@@ -1600,19 +1601,13 @@ static int smb_direct_accept_client(stru
 		pr_err("error at rdma_accept: %d\n", ret);
 		return ret;
 	}
-
-	wait_event_interruptible(t->wait_status,
-				 t->status != SMB_DIRECT_CS_NEW);
-	if (t->status != SMB_DIRECT_CS_CONNECTED)
-		return -ENOTCONN;
 	return 0;
 }
 
-static int smb_direct_negotiate(struct smb_direct_transport *t)
+static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 {
 	int ret;
 	struct smb_direct_recvmsg *recvmsg;
-	struct smb_direct_negotiate_req *req;
 
 	recvmsg = get_free_recvmsg(t);
 	if (!recvmsg)
@@ -1622,44 +1617,20 @@ static int smb_direct_negotiate(struct s
 	ret = smb_direct_post_recv(t, recvmsg);
 	if (ret) {
 		pr_err("Can't post recv: %d\n", ret);
-		goto out;
+		goto out_err;
 	}
 
 	t->negotiation_requested = false;
 	ret = smb_direct_accept_client(t);
 	if (ret) {
 		pr_err("Can't accept client\n");
-		goto out;
+		goto out_err;
 	}
 
 	smb_direct_post_recv_credits(&t->post_recv_credits_work.work);
-
-	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
-	ret = wait_event_interruptible_timeout(t->wait_status,
-					       t->negotiation_requested ||
-						t->status == SMB_DIRECT_CS_DISCONNECTED,
-					       SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
-	if (ret <= 0 || t->status == SMB_DIRECT_CS_DISCONNECTED) {
-		ret = ret < 0 ? ret : -ETIMEDOUT;
-		goto out;
-	}
-
-	ret = smb_direct_check_recvmsg(recvmsg);
-	if (ret == -ECONNABORTED)
-		goto out;
-
-	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
-	t->max_recv_size = min_t(int, t->max_recv_size,
-				 le32_to_cpu(req->preferred_send_size));
-	t->max_send_size = min_t(int, t->max_send_size,
-				 le32_to_cpu(req->max_receive_size));
-	t->max_fragmented_send_size =
-			le32_to_cpu(req->max_fragmented_size);
-
-	ret = smb_direct_send_negotiate_response(t, ret);
-out:
-	if (recvmsg)
-		put_recvmsg(t, recvmsg);
+	return 0;
+out_err:
+	put_recvmsg(t, recvmsg);
 	return ret;
 }
 
@@ -1896,6 +1867,47 @@ err:
 static int smb_direct_prepare(struct ksmbd_transport *t)
 {
 	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+	struct smb_direct_recvmsg *recvmsg;
+	struct smb_direct_negotiate_req *req;
+	int ret;
+
+	ksmbd_debug(RDMA, "Waiting for SMB_DIRECT negotiate request\n");
+	ret = wait_event_interruptible_timeout(st->wait_status,
+					       st->negotiation_requested ||
+					       st->status == SMB_DIRECT_CS_DISCONNECTED,
+					       SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
+	if (ret <= 0 || st->status == SMB_DIRECT_CS_DISCONNECTED)
+		return ret < 0 ? ret : -ETIMEDOUT;
+
+	recvmsg = get_first_reassembly(st);
+	if (!recvmsg)
+		return -ECONNABORTED;
+
+	ret = smb_direct_check_recvmsg(recvmsg);
+	if (ret == -ECONNABORTED)
+		goto out;
+
+	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
+	st->max_recv_size = min_t(int, st->max_recv_size,
+				  le32_to_cpu(req->preferred_send_size));
+	st->max_send_size = min_t(int, st->max_send_size,
+				  le32_to_cpu(req->max_receive_size));
+	st->max_fragmented_send_size =
+			le32_to_cpu(req->max_fragmented_size);
+
+	ret = smb_direct_send_negotiate_response(st, ret);
+out:
+	spin_lock_irq(&st->reassembly_queue_lock);
+	st->reassembly_queue_length--;
+	list_del(&recvmsg->list);
+	spin_unlock_irq(&st->reassembly_queue_lock);
+	put_recvmsg(st, recvmsg);
+
+	return ret;
+}
+
+static int smb_direct_connect(struct smb_direct_transport *st)
+{
 	int ret;
 	struct ib_qp_cap qp_cap;
 
@@ -1917,13 +1929,11 @@ static int smb_direct_prepare(struct ksm
 		return ret;
 	}
 
-	ret = smb_direct_negotiate(st);
+	ret = smb_direct_prepare_negotiation(st);
 	if (ret) {
 		pr_err("Can't negotiate: %d\n", ret);
 		return ret;
 	}
-
-	st->status = SMB_DIRECT_CS_CONNECTED;
 	return 0;
 }
 
@@ -1939,6 +1949,7 @@ static bool rdma_frwr_is_supported(struc
 static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
 {
 	struct smb_direct_transport *t;
+	int ret;
 
 	if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
 		ksmbd_debug(RDMA,
@@ -1951,18 +1962,23 @@ static int smb_direct_handle_connect_req
 	if (!t)
 		return -ENOMEM;
 
+	ret = smb_direct_connect(t);
+	if (ret)
+		goto out_err;
+
 	KSMBD_TRANS(t)->handler = kthread_run(ksmbd_conn_handler_loop,
 					      KSMBD_TRANS(t)->conn, "ksmbd:r%u",
 					      smb_direct_port);
 	if (IS_ERR(KSMBD_TRANS(t)->handler)) {
-		int ret = PTR_ERR(KSMBD_TRANS(t)->handler);
-
+		ret = PTR_ERR(KSMBD_TRANS(t)->handler);
 		pr_err("Can't start thread\n");
-		free_transport(t);
-		return ret;
+		goto out_err;
 	}
 
 	return 0;
+out_err:
+	free_transport(t);
+	return ret;
 }
 
 static int smb_direct_listen_handler(struct rdma_cm_id *cm_id,


