Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585920;
	b=DQuiYivmNqeHvt2R09qeZmHsOEJUfdEwhAzfaktv/mFoheDL3us2xbtdyZeaY3lxmWw7
	 4tFpNhNvmbAlH9jOFN26cSld8Ir6/tKChhk6SKb4YYTVacLaHYCXRgZjWQ6p3AEwmlv8s
	 xAogZI067x3k123WMsMGdzKkvOHyWd7Atu3peV+Qc3zPbk6kXEhSdeUi6j6zuGMyGkK/Z
	 /BbiQ1o9CVcq0iO/n0en9seCFVX0q3AakDGoDrkxX66ZoNC5ZPA9F/YV8kOqSmr6RBnWD
	 Riw3pX+e6fqZAGZgrGAWwaAjDqvDSnQhsvug0Et0+HG2dun579BZqNgaEPXk6Ke0oyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vDmGFYNqsCmWswlXSdiNOroNGM7WrezaZDV1b9ePKI=;
	b=wSX+YJT7kAFh2F1LWMOdY3h+J27CSA0Ks1LxknvYOolN7uxF/VNRbIkDYvMb2uoWNN0J
	 j9WYJ7E4062NSAhVMBLSQoNZ0eI5d58L6vF/1epgr+4VQabx/1l0YEQzAHL1/lhWaTf5t
	 T93yAeTc28VbNfZSlMB2VhPKjuhVDavFhQqUosOnN2eOuPfpygNxFjDLW2uMfoFQprZD7
	 ehJ2jvvDI6TlSNVaGVcDtWt0Likm/QKS/Fg1jqHG+DHqDfqrApQ7s+KCb0XtN2HmLYlAL
	 RT+whnDpkGh8tsoHfbVt3gUW+WJFA2pRRJ1s6R0b9IQx2whcK/yq2M0jBdcqFMIExPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEhGSNsg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537836070223;
	Fri, 13 Nov 2026 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEhGSNsg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20171F000C4;
	Fri, 13 Nov 2026 16:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585920;
	bh=9vDmGFYNqsCmWswlXSdiNOroNGM7WrezaZDV1b9ePKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEhGSNsgVyr3T0eGVokoN68mIgwEANNnhsgXU8if848VTmtqW+Cw5dIsGnuLQJLHR
	 qypLwjr1UUtQej7b5R8Q3aNvhXiI5BiWauqEABxrDeEuIYJkDC2wlRyDhjrfAy5GXl
	 SU9WdcrfbEiPnUT8mb2k1fv8MuAv35TZkwHVn8Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 481/507] nvme-tcp: Validate the queue state under the queue lock in the address attribute
Date: Fri, 13 Nov 2026 10:53:05 -0500
Message-ID: <20261113153813.336843319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Added a standalone queue_lock initialization loop because the upstream page-fragment cache initialization loop is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 51 +++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 2c7e9cfa2253e..50297ce8bdde6 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -117,6 +117,9 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_IO_CPU_SET	= 3,
 };
 
+#define NVME_TCP_OPT_NR_QUEUES(opts) ((opts)->nr_io_queues + \
+	(opts)->nr_write_queues + (opts)->nr_poll_queues + 1)
+
 enum nvme_tcp_recv_state {
 	NVME_TCP_RECV_PDU = 0,
 	NVME_TCP_RECV_DATA,
@@ -1556,14 +1559,21 @@ static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 	 * nvme_reset_ctrl_work(), queue teardown is immediately followed by
 	 * re-allocation. fput() defers socket cleanup to delayed_fput_work
 	 * in workqueue context, which can race with new queue setup.
+	 *
+	 * Clear queue->sock under the queue lock so that a sysfs reader in
+	 * nvme_tcp_get_address() either observes the NVME_TCP_Q_LIVE bit
+	 * cleared or a still valid socket.  The queue lock itself is owned
+	 * by the controller and only destroyed when the controller is
+	 * freed, so readers blocked on it cannot race its teardown.
 	 */
+	mutex_lock(&queue->queue_lock);
 	__fput_sync(queue->sock->file);
 	queue->sock = NULL;
+	mutex_unlock(&queue->queue_lock);
 	memalloc_noio_restore(noio_flag);
 
 	kfree(queue->pdu);
 	mutex_destroy(&queue->send_mutex);
-	mutex_destroy(&queue->queue_lock);
 	mutex_destroy(&queue->pf_cache_lock);
 }
 
@@ -1995,7 +2005,6 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 	int ret, rcv_pdu_size;
 	struct file *sock_file;
 
-	mutex_init(&queue->queue_lock);
 	queue->ctrl = ctrl;
 	init_llist_head(&queue->req_list);
 	INIT_LIST_HEAD(&queue->send_list);
@@ -2133,7 +2142,6 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 	queue->sock = NULL;
 err_destroy_mutex:
 	mutex_destroy(&queue->send_mutex);
-	mutex_destroy(&queue->queue_lock);
 	mutex_destroy(&queue->pf_cache_lock);
 	return ret;
 }
@@ -2783,6 +2791,9 @@ static void nvme_tcp_stop_ctrl(struct nvme_ctrl *ctrl)
 static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
+	/* the same count used to size and initialize the queue array */
+	unsigned int nr_queues = NVME_TCP_OPT_NR_QUEUES(nctrl->opts);
+	unsigned int i;
 
 	if (list_empty_careful(&ctrl->list))
 		goto free_ctrl;
@@ -2793,6 +2804,8 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
+	for (i = 0; i < nr_queues; i++)
+		mutex_destroy(&ctrl->queues[i].queue_lock);
 	kfree(ctrl->queues);
 	kfree(ctrl);
 }
@@ -3045,17 +3058,18 @@ static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 
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
@@ -3121,7 +3135,7 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
 	struct nvme_tcp_ctrl *ctrl;
-	int ret;
+	int ret, i;
 
 	ctrl = kzalloc_obj(*ctrl);
 	if (!ctrl)
@@ -3132,8 +3146,7 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 	 */
 	context_unsafe(INIT_LIST_HEAD(&ctrl->list));
 	ctrl->ctrl.opts = opts;
-	ctrl->ctrl.queue_count = opts->nr_io_queues + opts->nr_write_queues +
-				opts->nr_poll_queues + 1;
+	ctrl->ctrl.queue_count = NVME_TCP_OPT_NR_QUEUES(opts);
 	ctrl->ctrl.sqsize = opts->queue_size - 1;
 	ctrl->ctrl.kato = opts->kato;
 
@@ -3191,6 +3204,14 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
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
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_tcp_ctrl_ops, 0);
 	if (ret)
 		goto out_kfree_queues;
-- 
2.53.0



