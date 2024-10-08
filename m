Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACA41E485;
	Tue,  8 Oct 2024 12:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389836; cv=none; b=F2QRt7VP5fA+t4em5Voq+/ZuB/8lJvlIYliYt9ESIb5AHZl7M5qDx3nsDbqvum2HLkPoffbIoozO3T7GRUktvVTroqSQ//ffWVSczUJwdF+M0YWuR/Qy9B3GAuD8rq2cYahNIQHuBJVNonmLHT8KDtq3f3Rp6tWWy1tA9kV1r+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389836; c=relaxed/simple;
	bh=KMasys8su+jvbIILVaud8/JC4No+mW8E4nC3Jy7I4+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swTQZkxMIhaSNaUox/uYJxBpphTs/piowEjc6d+UBPfKiBsOq65NbNNF0aJJlruUFOcnqqAup9v+1qorbg5Ve6k/QOcRd2yfYDsY/m6gcswj1fw60nEc7c9Y64C2CH6LVdzmMTIavmVbNCUegs9esvAyi1eMcQYwIJ40ygWtO9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0NWPXHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0NWPXHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73994C4CEC7;
	Tue,  8 Oct 2024 12:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389836;
	bh=KMasys8su+jvbIILVaud8/JC4No+mW8E4nC3Jy7I4+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0NWPXHpjuzNSGrOJ+XUiVGbgj10gscuD+fEd7Y4A096VoIBAY4uTaXq89WC+v4SN
	 zQpv5grHODIE/AakzHe/XwqFKD/8n3y6w0XeoQe/yutEw33SsbP+6budn2ha6JdZDr
	 H79bsuR4fOb7+H+t6N3B6GIif//uJ+4r8Bs8Cu5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 110/482] nvme-tcp: sanitize TLS key handling
Date: Tue,  8 Oct 2024 14:02:53 +0200
Message-ID: <20241008115652.636995398@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 363895767fbfa05891b0b4d9e06ebde7a10c6a07 ]

There is a difference between TLS configured (ie the user has
provisioned/requested a key) and TLS enabled (ie the connection
is encrypted with TLS). This becomes important for secure concatenation,
where the initial authentication is run on an unencrypted connection
(ie with TLS configured, but not enabled), and then the queue is reset to
run over TLS (ie TLS configured _and_ enabled).
So to differentiate between those two states store the generated
key in opts->tls_key (as we're using the same TLS key for all queues),
the key serial of the resulting TLS handshake in ctrl->tls_pskid
(to signal that TLS on the admin queue is enabled), and a simple
flag for the queues to indicated that TLS has been enabled.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c  |  1 -
 drivers/nvme/host/nvme.h  |  2 +-
 drivers/nvme/host/sysfs.c |  4 +--
 drivers/nvme/host/tcp.c   | 53 +++++++++++++++++++++++++++++----------
 4 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5569cf4183b2a..415ede9886c12 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4587,7 +4587,6 @@ static void nvme_free_ctrl(struct device *dev)
 
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
-	key_put(ctrl->tls_key);
 	nvme_free_cels(ctrl);
 	nvme_mpath_uninit(ctrl);
 	cleanup_srcu_struct(&ctrl->srcu);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ff1769172778b..cde1cb906dbf2 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -375,7 +375,7 @@ struct nvme_ctrl {
 	struct nvme_dhchap_key *ctrl_key;
 	u16 transaction;
 #endif
-	struct key *tls_key;
+	key_serial_t tls_pskid;
 
 	/* Power saving configuration */
 	u64 ps_max_latency_us;
diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 3c55f7edd1819..5b1dee8a66ef8 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -671,9 +671,9 @@ static ssize_t tls_key_show(struct device *dev,
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
 
-	if (!ctrl->tls_key)
+	if (!ctrl->tls_pskid)
 		return 0;
-	return sysfs_emit(buf, "%08x", key_serial(ctrl->tls_key));
+	return sysfs_emit(buf, "%08x", ctrl->tls_pskid);
 }
 static DEVICE_ATTR_RO(tls_key);
 #endif
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8b5e4327fe83b..f551609691807 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -165,6 +165,7 @@ struct nvme_tcp_queue {
 
 	bool			hdr_digest;
 	bool			data_digest;
+	bool			tls_enabled;
 	struct ahash_request	*rcv_hash;
 	struct ahash_request	*snd_hash;
 	__le32			exp_ddgst;
@@ -213,7 +214,21 @@ static inline int nvme_tcp_queue_id(struct nvme_tcp_queue *queue)
 	return queue - queue->ctrl->queues;
 }
 
-static inline bool nvme_tcp_tls(struct nvme_ctrl *ctrl)
+/*
+ * Check if the queue is TLS encrypted
+ */
+static inline bool nvme_tcp_queue_tls(struct nvme_tcp_queue *queue)
+{
+	if (!IS_ENABLED(CONFIG_NVME_TCP_TLS))
+		return 0;
+
+	return queue->tls_enabled;
+}
+
+/*
+ * Check if TLS is configured for the controller.
+ */
+static inline bool nvme_tcp_tls_configured(struct nvme_ctrl *ctrl)
 {
 	if (!IS_ENABLED(CONFIG_NVME_TCP_TLS))
 		return 0;
@@ -368,7 +383,7 @@ static inline bool nvme_tcp_queue_has_pending(struct nvme_tcp_queue *queue)
 
 static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
 {
-	return !nvme_tcp_tls(&queue->ctrl->ctrl) &&
+	return !nvme_tcp_queue_tls(queue) &&
 		nvme_tcp_queue_has_pending(queue);
 }
 
@@ -1427,7 +1442,7 @@ static int nvme_tcp_init_connection(struct nvme_tcp_queue *queue)
 	memset(&msg, 0, sizeof(msg));
 	iov.iov_base = icresp;
 	iov.iov_len = sizeof(*icresp);
-	if (nvme_tcp_tls(&queue->ctrl->ctrl)) {
+	if (nvme_tcp_queue_tls(queue)) {
 		msg.msg_control = cbuf;
 		msg.msg_controllen = sizeof(cbuf);
 	}
@@ -1439,7 +1454,7 @@ static int nvme_tcp_init_connection(struct nvme_tcp_queue *queue)
 		goto free_icresp;
 	}
 	ret = -ENOTCONN;
-	if (nvme_tcp_tls(&queue->ctrl->ctrl)) {
+	if (nvme_tcp_queue_tls(queue)) {
 		ctype = tls_get_record_type(queue->sock->sk,
 					    (struct cmsghdr *)cbuf);
 		if (ctype != TLS_RECORD_TYPE_DATA) {
@@ -1587,7 +1602,10 @@ static void nvme_tcp_tls_done(void *data, int status, key_serial_t pskid)
 			 qid, pskid);
 		queue->tls_err = -ENOKEY;
 	} else {
-		ctrl->ctrl.tls_key = tls_key;
+		queue->tls_enabled = true;
+		if (qid == 0)
+			ctrl->ctrl.tls_pskid = key_serial(tls_key);
+		key_put(tls_key);
 		queue->tls_err = 0;
 	}
 
@@ -1768,7 +1786,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 	}
 
 	/* If PSKs are configured try to start TLS */
-	if (IS_ENABLED(CONFIG_NVME_TCP_TLS) && pskid) {
+	if (nvme_tcp_tls_configured(nctrl) && pskid) {
 		ret = nvme_tcp_start_tls(nctrl, queue, pskid);
 		if (ret)
 			goto err_init_connect;
@@ -1829,6 +1847,8 @@ static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
 	mutex_lock(&queue->queue_lock);
 	if (test_and_clear_bit(NVME_TCP_Q_LIVE, &queue->flags))
 		__nvme_tcp_stop_queue(queue);
+	/* Stopping the queue will disable TLS */
+	queue->tls_enabled = false;
 	mutex_unlock(&queue->queue_lock);
 }
 
@@ -1925,16 +1945,17 @@ static int nvme_tcp_alloc_admin_queue(struct nvme_ctrl *ctrl)
 	int ret;
 	key_serial_t pskid = 0;
 
-	if (nvme_tcp_tls(ctrl)) {
+	if (nvme_tcp_tls_configured(ctrl)) {
 		if (ctrl->opts->tls_key)
 			pskid = key_serial(ctrl->opts->tls_key);
-		else
+		else {
 			pskid = nvme_tls_psk_default(ctrl->opts->keyring,
 						      ctrl->opts->host->nqn,
 						      ctrl->opts->subsysnqn);
-		if (!pskid) {
-			dev_err(ctrl->device, "no valid PSK found\n");
-			return -ENOKEY;
+			if (!pskid) {
+				dev_err(ctrl->device, "no valid PSK found\n");
+				return -ENOKEY;
+			}
 		}
 	}
 
@@ -1957,13 +1978,14 @@ static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 {
 	int i, ret;
 
-	if (nvme_tcp_tls(ctrl) && !ctrl->tls_key) {
+	if (nvme_tcp_tls_configured(ctrl) && !ctrl->tls_pskid) {
 		dev_err(ctrl->device, "no PSK negotiated\n");
 		return -ENOKEY;
 	}
+
 	for (i = 1; i < ctrl->queue_count; i++) {
 		ret = nvme_tcp_alloc_queue(ctrl, i,
-				key_serial(ctrl->tls_key));
+				ctrl->tls_pskid);
 		if (ret)
 			goto out_free_queues;
 	}
@@ -2144,6 +2166,11 @@ static void nvme_tcp_teardown_admin_queue(struct nvme_ctrl *ctrl,
 	if (remove)
 		nvme_unquiesce_admin_queue(ctrl);
 	nvme_tcp_destroy_admin_queue(ctrl, remove);
+	if (ctrl->tls_pskid) {
+		dev_dbg(ctrl->device, "Wipe negotiated TLS_PSK %08x\n",
+			ctrl->tls_pskid);
+		ctrl->tls_pskid = 0;
+	}
 }
 
 static void nvme_tcp_teardown_io_queues(struct nvme_ctrl *ctrl,
-- 
2.43.0



