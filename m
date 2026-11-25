Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622460;
	b=HQgFp1xfByUQnzqgwuQSaQVAr0OPteTgntcnLqmzg+xqq+4DGbCGnB13+wKNBR0SpvLm
	 FwFaotW8fl3W3VrOzmVA/WoJmp2FZ/Ki1e14FO4I32hmt2cHjrMIpSEt73EPe5YylLiaL
	 UtECIoa4r+Ry10A4VsOtrw0yj4kcohgTJzxwl5V3qbeVPgc9w8wQb62QeDOHV+sMpvLBI
	 NNF6RFOxqmAWEo9ySfP8TLCo2aVG7id8kyPTZf96nyNjJhw8qlIJxfnf+kLWWxE2nfOgF
	 HiTFDwbhmM/2WOwd4tYgs9PHEtfLJmlqWdByPYa5d/Uj+/Zoy6ANg2KyHoTsc9cJB3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zyj30SGv4MgiBCiqCI3I0MMkStL7tFbsXz/MAKewbdw=;
	b=maM0kyHYPE2tQrr3N6ZE8Dv5CuGRkxdRgia3jR3iClN4DZQ+3KtXUzggtnRt4Gdqh1VA
	 GO5KELTui2pnoSPZeWKrxS/1bEKPXNbII3LG5gtUupeta22qdLha3e3AL6P1OnWbQ46GK
	 oa9R/DH7pmAkhJHW0WW9Lcjk7UUzeN7VcdUL2yEoMRrx6vn09RQjwn08T3TzxswXsYUAD
	 t0xY2/aBPI4kUfcpZZbYaH0WmbQnm4/amqQN9Noqstmmed2c1WYxbw8w3G88BwHyaPP1k
	 c/zrTFGJMXvjBgNyfByLkH1N3jLT+HCZt+WrWL4ok6PA4lA+Bzg11Wv/Kf8PS5kCl+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uwaAkaiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A54F606A323;
	Wed, 25 Nov 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uwaAkaiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA0E1F000C0;
	Wed, 25 Nov 2026 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622459;
	bh=Zyj30SGv4MgiBCiqCI3I0MMkStL7tFbsXz/MAKewbdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwaAkaiZgnK05RpD+nNRJloudQ4FUfJPlJWyLGPFvxrc7d4cBcEKgqj2JdpIVpaFC
	 TFSaqMsUfpvsfp2nbEUsCpTw5FYwCnZrqSwKU+Bb59fDpDQ1rZ2jI8/v9EnL3A/fac
	 kwRrn3eIOtD7WcYAqNFftecHHGxS8xYBdqht+Sio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/990] nvme-tcp: Validate the queue state under the queue lock in the address attribute
Date: Wed, 25 Nov 2026 15:31:07 +0100
Message-ID: <20261125143833.809729934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 2eeeaa9c1ff0c429096acc2947c296db6a56f96d ]

Reading the "address" sysfs attribute calls kernel_getsockname() on the
admin queue socket, which can race with the queue teardown during
connection error recovery: a reader can observe NVME_TCP_Q_LIVE set,
then block on the queue lock while nvme_tcp_free_queue() releases the
socket and clears queue->sock without holding the lock.  Once the
reader acquires the lock it dereferences the NULL socket pointer.

Commit 76d54bf20cdc ("nvme-tcp: don't access released socket during
error recovery") had the queue liveness check inside the lock.
Commit 782373ba2766 ("nvme: tcp: avoid race between queue_lock lock
and destroy") moved it back out because the lock itself is destroyed
in nvme_tcp_free_queue(), so a reader arriving late trips
mutex_destroy().

Check the queue liveness inside the queue lock, and clear queue->sock
under the same lock.  The teardown clears NVME_TCP_Q_LIVE under the
lock well before the socket is released, so a reader either sees the
bit cleared or a socket that cannot be released while it holds the
lock.  To also close the lock lifetime race, the queue locks are now
owned by the controller: they are initialized with the queue array and
only destroyed when the controller is freed, which cannot happen while
a sysfs attribute read is still in progress.  The queue count is
computed by the NVME_TCP_OPT_NR_QUEUES() macro from the original
connect options for both initialization and destruction, as reconnects
may shrink ctrl->queue_count.

Fixes: 782373ba2766 ("nvme: tcp: avoid race between queue_lock lock and destroy")
Cc: stable@vger.kernel.org
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ sashal: Context adapted for older teardown code (fput, memalloc_noreclaim, list_empty) and per-queue pf_cache_lock init kept, while queue_lock init/destroy moves to the controller. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 52 +++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 72afdd73939f8..d97ef58b834a3 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -154,6 +154,9 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_IO_CPU_SET	= 3,
 };
 
+#define NVME_TCP_OPT_NR_QUEUES(opts) ((opts)->nr_io_queues + \
+	(opts)->nr_write_queues + (opts)->nr_poll_queues + 1)
+
 enum nvme_tcp_recv_state {
 	NVME_TCP_RECV_PDU = 0,
 	NVME_TCP_RECV_DATA,
@@ -1547,14 +1550,22 @@ static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 	page_frag_cache_drain(&queue->pf_cache);
 
 	noreclaim_flag = memalloc_noreclaim_save();
+	/*
+	 * Clear queue->sock under the queue lock so that a sysfs reader in
+	 * nvme_tcp_get_address() either observes the NVME_TCP_Q_LIVE bit
+	 * cleared or a still valid socket.  The queue lock itself is owned
+	 * by the controller and only destroyed when the controller is
+	 * freed, so readers blocked on it cannot race its teardown.
+	 */
+	mutex_lock(&queue->queue_lock);
 	/* ->sock will be released by fput() */
 	fput(queue->sock->file);
 	queue->sock = NULL;
+	mutex_unlock(&queue->queue_lock);
 	memalloc_noreclaim_restore(noreclaim_flag);
 
 	kfree(queue->pdu);
 	mutex_destroy(&queue->send_mutex);
-	mutex_destroy(&queue->queue_lock);
 	mutex_destroy(&queue->pf_cache_lock);
 }
 
@@ -1986,7 +1997,6 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 	int ret, rcv_pdu_size;
 	struct file *sock_file;
 
-	mutex_init(&queue->queue_lock);
 	queue->ctrl = ctrl;
 	init_llist_head(&queue->req_list);
 	INIT_LIST_HEAD(&queue->send_list);
@@ -2124,7 +2134,6 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 	queue->sock = NULL;
 err_destroy_mutex:
 	mutex_destroy(&queue->send_mutex);
-	mutex_destroy(&queue->queue_lock);
 	mutex_destroy(&queue->pf_cache_lock);
 	return ret;
 }
@@ -2772,6 +2781,9 @@ static void nvme_tcp_stop_ctrl(struct nvme_ctrl *ctrl)
 static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
+	/* the same count used to size and initialize the queue array */
+	unsigned int nr_queues = NVME_TCP_OPT_NR_QUEUES(nctrl->opts);
+	unsigned int i;
 
 	if (list_empty(&ctrl->list))
 		goto free_ctrl;
@@ -2783,6 +2795,8 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
 	put_net(ctrl->net);
+	for (i = 0; i < nr_queues; i++)
+		mutex_destroy(&ctrl->queues[i].queue_lock);
 	kfree(ctrl->queues);
 	kfree(ctrl);
 }
@@ -3035,17 +3049,18 @@ static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 
 	len = nvmf_get_address(ctrl, buf, size);
 
-	if (!test_bit(NVME_TCP_Q_LIVE, &queue->flags))
-		return len;
-
 	mutex_lock(&queue->queue_lock);
 
-	ret = kernel_getsockname(queue->sock, (struct sockaddr *)&src_addr);
-	if (ret > 0) {
-		if (len > 0)
-			len--; /* strip trailing newline */
-		len += scnprintf(buf + len, size - len, "%ssrc_addr=%pISc\n",
-				(len) ? "," : "", &src_addr);
+	if (test_bit(NVME_TCP_Q_LIVE, &queue->flags)) {
+		ret = kernel_getsockname(queue->sock,
+				(struct sockaddr *)&src_addr);
+		if (ret > 0) {
+			if (len > 0)
+				len--; /* strip trailing newline */
+			len += scnprintf(buf + len, size - len,
+					"%ssrc_addr=%pISc\n",
+					(len) ? "," : "", &src_addr);
+		}
 	}
 
 	mutex_unlock(&queue->queue_lock);
@@ -3111,7 +3126,7 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
 	struct nvme_tcp_ctrl *ctrl;
-	int ret;
+	int ret, i;
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl)
@@ -3119,8 +3134,7 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 
 	INIT_LIST_HEAD(&ctrl->list);
 	ctrl->ctrl.opts = opts;
-	ctrl->ctrl.queue_count = opts->nr_io_queues + opts->nr_write_queues +
-				opts->nr_poll_queues + 1;
+	ctrl->ctrl.queue_count = NVME_TCP_OPT_NR_QUEUES(opts);
 	ctrl->ctrl.sqsize = opts->queue_size - 1;
 	ctrl->ctrl.kato = opts->kato;
 
@@ -3179,6 +3193,14 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		goto out_free_ctrl;
 	}
 
+	/*
+	 * The queue locks are owned by the controller, not the queues:
+	 * they outlive the per-queue connect/disconnect cycles so that
+	 * sysfs readers can never race their destruction.
+	 */
+	for (i = 0; i < ctrl->ctrl.queue_count; i++)
+		mutex_init(&ctrl->queues[i].queue_lock);
+
 	ctrl->net = get_net(current->nsproxy->net_ns);
 
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_tcp_ctrl_ops, 0);
-- 
2.53.0



