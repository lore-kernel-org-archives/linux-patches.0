Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA24442B23;
	Mon, 31 Aug 2026 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183534; cv=none; b=t6VMUphkLb+eacRFN1x0A8WLuJ7Tbwx40wQLEw4wFbRf5HWtSjQhPEBx9+G8QtptdvNPwwFOVTSpOTiqrz3KNfRzMzknx6dzZSTKBqqk/Uoc3RtVgXWAHNTqyxI8XUHmc+nKLMN/Hc/Fkne2DoLB+yZRmLilfh3XbuTo3DmxxaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183534; c=relaxed/simple;
	bh=YTraFIcrvluVgwUmVi4C5Suqyl513wOqOsEXEUb+7YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kY3uh3jPUhRestq36EQRJztfU0HOqa6oXREpK8cp+dghLb1QI7JQomqqolC3LE/hsk2w00cdva+a3jZU4tZ4JMFT8YYlh5P5n2IkxeZamMWp0jYE2K6znT50gwfJYOvZHmYYYI1gce0dTVObxAaJRksA4/ugBcxGun9UgutI/HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5uVklfe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5uVklfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F2D1F00A3E;
	Mon, 31 Aug 2026 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183532;
	bh=XDB11obtOhj9qmGLPBayVN7veF2ZfsUHdU6HTXgaX/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5uVklfeQR8nhYP+0nMycJjUPpXM/3yjyCmjxJo9KzQdAJTXFTsZE036C2y9fhQrx
	 EEWAchJfNvIC2JS5NPbfu57PdjvFAntowVpCWN4lBT2TQQDabzPgx+/PXiwBiYArLK
	 cOasJvP7fzdfwN1WMqw7wkxAtgxhJfw0614oliwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 03/71] nvme-tcp: fix usage of page_frag_cache
Date: Mon, 31 Aug 2026 15:33:28 +0200
Message-ID: <20260831133359.207505961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 36ac05f7cfd59d90c597071304b14e98090d5dd1 ]

nvme uses page_frag_cache to preallocate PDU for each preallocated request
of block device. Block devices are created in parallel threads,
consequently page_frag_cache is used in not thread-safe manner.
That leads to incorrect refcounting of backstore pages and premature free.

That can be catched by !sendpage_ok inside network stack:

WARNING: CPU: 7 PID: 467 at ../net/core/skbuff.c:6931 skb_splice_from_iter+0xfa/0x310.
	tcp_sendmsg_locked+0x782/0xce0
	tcp_sendmsg+0x27/0x40
	sock_sendmsg+0x8b/0xa0
	nvme_tcp_try_send_cmd_pdu+0x149/0x2a0
Then random panic may occur.

Fix that by serializing the usage of page_frag_cache.

Fixes: 4e893ca81170 ("nvme_core: scan namespaces asynchronously")
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index ba5c7b3e2a7c6..dd40798bc2487 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -108,6 +108,7 @@ struct nvme_tcp_queue {
 
 	struct mutex		queue_lock;
 	struct mutex		send_mutex;
+	struct mutex		pf_cache_lock;
 	struct llist_head	req_list;
 	struct list_head	send_list;
 
@@ -550,9 +551,11 @@ static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
 	struct nvme_tcp_queue *queue = &ctrl->queues[queue_idx];
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 
+	mutex_lock(&queue->pf_cache_lock);
 	req->pdu = page_frag_alloc(&queue->pf_cache,
 		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
 		GFP_KERNEL | __GFP_ZERO);
+	mutex_unlock(&queue->pf_cache_lock);
 	if (!req->pdu)
 		return -ENOMEM;
 
@@ -1417,9 +1420,11 @@ static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
 	struct nvme_tcp_request *async = &ctrl->async_req;
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 
+	mutex_lock(&queue->pf_cache_lock);
 	async->pdu = page_frag_alloc(&queue->pf_cache,
 		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
 		GFP_KERNEL | __GFP_ZERO);
+	mutex_unlock(&queue->pf_cache_lock);
 	if (!async->pdu)
 		return -ENOMEM;
 
@@ -1461,6 +1466,7 @@ static void nvme_tcp_free_queue(struct nvme_ctrl *nctrl, int qid)
 	kfree(queue->pdu);
 	mutex_destroy(&queue->send_mutex);
 	mutex_destroy(&queue->queue_lock);
+	mutex_destroy(&queue->pf_cache_lock);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	lockdep_unregister_key(&queue->nvme_tcp_sk_key);
@@ -1788,6 +1794,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 	INIT_LIST_HEAD(&queue->send_list);
 	mutex_init(&queue->send_mutex);
 	INIT_WORK(&queue->io_work, nvme_tcp_io_work);
+	mutex_init(&queue->pf_cache_lock);
 
 	if (qid > 0)
 		queue->cmnd_capsule_len = nctrl->ioccsz * 16;
@@ -1928,6 +1935,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 err_destroy_mutex:
 	mutex_destroy(&queue->send_mutex);
 	mutex_destroy(&queue->queue_lock);
+	mutex_destroy(&queue->pf_cache_lock);
 	return ret;
 }
 
-- 
2.53.0



