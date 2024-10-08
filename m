Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC5A1DE2A5;
	Tue,  8 Oct 2024 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391492; cv=none; b=LqoKYhO8ldNnCcJUtZa0XamIxsUQ8UhQP4QBlYcX8Ipe4tGS40JblCjW4mOpJatbqBVMy0TIsPDK5DB00OHgAbjBbyMwP+cWmKkxnv6nJJ3HRlKTl+MLtHY0S3iIYZvtUFk5jfQoWA/dF6c5itK1/Muc8GxFzVtYaUtc9HSf0FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391492; c=relaxed/simple;
	bh=lR4nGwnMgcV3KPcE/Jb+ePYoRypcDJZJqmiH2K9AVB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lt2XCcg8XiEGotpsH365bNV6fN1wz1rFhsbZUGqVaTrnUcV7ja1A5InoMC0hG7Ds7j7mmoshzpRCrQ1+nGnEfu+ziDDbcMLXoqiTe31B2svvBFNcruiTbTQ8BohfShC6EPBWwDcvbLrAzna3s3IKA9hSnPdO25uXg4M/kkdu/D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Etw503qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Etw503qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DBAC4CEC7;
	Tue,  8 Oct 2024 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391492;
	bh=lR4nGwnMgcV3KPcE/Jb+ePYoRypcDJZJqmiH2K9AVB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Etw503qv7SZM7vVtb3tUjp6aBXHGwbmp91DmDsBni+mY97MK0D75Uv3+Ie86bIWwr
	 as2pZUDEMJAOgiw0kgG1X32Wc8rKoPfoiSbXYsokLnBNo9pmRXi3HiyuDXjzs4o0Fj
	 MUDIWoE3EcsNz2RXH38vmmfq85wYaWJlFKiMEC8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 131/558] nvme-tcp: sanitize TLS key handling
Date: Tue,  8 Oct 2024 14:02:41 +0200
Message-ID: <20241008115707.519856734@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 983909a600adb..a6fb1359a7e14 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4678,7 +4678,6 @@ static void nvme_free_ctrl(struct device *dev)
 
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
-	key_put(ctrl->tls_key);
 	nvme_free_cels(ctrl);
 	nvme_mpath_uninit(ctrl);
 	cleanup_srcu_struct(&ctrl->srcu);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index e01b1332d245a..313a4f978a2cf 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -377,7 +377,7 @@ struct nvme_ctrl {
 	struct nvme_dhchap_key *ctrl_key;
 	u16 transaction;
 #endif
-	struct key *tls_key;
+	key_serial_t tls_pskid;
 
 	/* Power saving configuration */
 	u64 ps_max_latency_us;
diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index ba05faaac562d..72675b59a7a73 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -670,9 +670,9 @@ static ssize_t tls_key_show(struct device *dev,
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
index a2a47d3ab99f0..b305873e588e6 100644
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



