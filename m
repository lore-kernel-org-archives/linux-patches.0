Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182E048784;
	Wed, 20 Dec 2023 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqH8szJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92262C433C8;
	Wed, 20 Dec 2023 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088803;
	bh=/bcVDI2QUDlE9y9P1GlFwrW3//Sz9cRAAW7j30RA7hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqH8szJqI+mUNms0QGzEbfgDfTpldhjTeBEASZO7T69+IEpEF1fU38LA9DsPgScnX
	 MwROS5SFOS0CRMbLaUZBZbdo4LWe5W1GmEC7Frz5IPjWBA9I5387KDzMAjxynv/odb
	 cw/ST7YZUxh3V/khjMQ7A/jzf1Pu8fHCoSdEeCQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 035/159] ksmbd: smbd: simplify tracking pending packets
Date: Wed, 20 Dec 2023 17:08:20 +0100
Message-ID: <20231220160932.924450293@linuxfoundation.org>
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

[ Upstream commit 11659a8ddbd9c4c1ab6f3b8f52837178ef121b20 ]

Because we don't have to tracking pending packets
by dividing these into packets with payload and
packets without payload, merge the tracking code.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -157,8 +157,6 @@ struct smb_direct_transport {
 	mempool_t		*recvmsg_mempool;
 	struct kmem_cache	*recvmsg_cache;
 
-	wait_queue_head_t	wait_send_payload_pending;
-	atomic_t		send_payload_pending;
 	wait_queue_head_t	wait_send_pending;
 	atomic_t		send_pending;
 
@@ -392,8 +390,6 @@ static struct smb_direct_transport *allo
 	spin_lock_init(&t->empty_recvmsg_queue_lock);
 	INIT_LIST_HEAD(&t->empty_recvmsg_queue);
 
-	init_waitqueue_head(&t->wait_send_payload_pending);
-	atomic_set(&t->send_payload_pending, 0);
 	init_waitqueue_head(&t->wait_send_pending);
 	atomic_set(&t->send_pending, 0);
 
@@ -423,8 +419,6 @@ static void free_transport(struct smb_di
 	wake_up_interruptible(&t->wait_send_credits);
 
 	ksmbd_debug(RDMA, "wait for all send posted to IB to finish\n");
-	wait_event(t->wait_send_payload_pending,
-		   atomic_read(&t->send_payload_pending) == 0);
 	wait_event(t->wait_send_pending,
 		   atomic_read(&t->send_pending) == 0);
 
@@ -879,13 +873,8 @@ static void send_done(struct ib_cq *cq,
 		smb_direct_disconnect_rdma_connection(t);
 	}
 
-	if (sendmsg->num_sge > 1) {
-		if (atomic_dec_and_test(&t->send_payload_pending))
-			wake_up(&t->wait_send_payload_pending);
-	} else {
-		if (atomic_dec_and_test(&t->send_pending))
-			wake_up(&t->wait_send_pending);
-	}
+	if (atomic_dec_and_test(&t->send_pending))
+		wake_up(&t->wait_send_pending);
 
 	/* iterate and free the list of messages in reverse. the list's head
 	 * is invalid.
@@ -917,21 +906,12 @@ static int smb_direct_post_send(struct s
 {
 	int ret;
 
-	if (wr->num_sge > 1)
-		atomic_inc(&t->send_payload_pending);
-	else
-		atomic_inc(&t->send_pending);
-
+	atomic_inc(&t->send_pending);
 	ret = ib_post_send(t->qp, wr, NULL);
 	if (ret) {
 		pr_err("failed to post send: %d\n", ret);
-		if (wr->num_sge > 1) {
-			if (atomic_dec_and_test(&t->send_payload_pending))
-				wake_up(&t->wait_send_payload_pending);
-		} else {
-			if (atomic_dec_and_test(&t->send_pending))
-				wake_up(&t->wait_send_pending);
-		}
+		if (atomic_dec_and_test(&t->send_pending))
+			wake_up(&t->wait_send_pending);
 		smb_direct_disconnect_rdma_connection(t);
 	}
 	return ret;
@@ -1332,8 +1312,8 @@ done:
 	 * that means all the I/Os have been out and we are good to return
 	 */
 
-	wait_event(st->wait_send_payload_pending,
-		   atomic_read(&st->send_payload_pending) == 0);
+	wait_event(st->wait_send_pending,
+		   atomic_read(&st->send_pending) == 0);
 	return ret;
 }
 


