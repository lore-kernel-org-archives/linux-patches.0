Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705227;
	b=G4zk5CISNk9lhkHfXeMTh38rbI4Rmgvyrf/Wr5ukZx9CdGrccuA0ofw94pm6sf/2+FgI
	 Sbn2WbVGZwBo4pznLGBoL9m/Qpczt6bTyRkpX2gzYiTNIATwUxd2ahH3s0DKAsaDG/80o
	 WiGQQDtxalgUV9G3gzgHiqpqvHLF5dpQqL1W/42YOOMKSuUl8OWb/YMMVCboe+g9hI58o
	 jgeB1EpF69qlvzLGzQAINNHd48V6eXmIDh/L4MWc1+ODoBozGvQG7YeH3C7wvHAbZ0RaJ
	 3gbxqPbOf7abVJkyQeM+P7h7MO1nnurcvGTOx4li5HQMvAyUulmT8oKbea1ICo9yuDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=We6iPzmm/Bs7YC7JUEfUcK9DqY2lICsFLKn23PHX6cU=;
	b=KIQ4/1JVyoW+8BiimtLtk2InHqZa09bOQ8Q45E3M5iP4Jl/f6suCV0v9Qaoh2WZfwwhV
	 D8GZIe8RzM+VKJQBf32lnxzQmllIYV01k0Mfx8Rru4DVAlgVOYgzAsgjrZidv6aOefgCx
	 jRP2seXT3ct/F/ogOdgngtpYQawCP5H9H95PjAw54s8lWt4JZFw6OXUVrkDFrU5+jycth
	 uxPMIkoGn6Da6gW9rMSFOEnMbslffN4ZZ2EbWxSVtjqwSVkWmNQyLqdJ/a99XKgRJ3iM3
	 e19ggU1y4GOc2BV5Y5Y/+HHRtPG/0PPcSKgga9LwHGM4VhP/0jRRFl3uNYdlo2+nDtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x4gIxp/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABCB606A31C;
	Thu, 26 Nov 2026 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x4gIxp/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9901F000C0;
	Thu, 26 Nov 2026 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705227;
	bh=We6iPzmm/Bs7YC7JUEfUcK9DqY2lICsFLKn23PHX6cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4gIxp/M4/l3w9mczw9hkZrVBxr5FFFtZdWqtzu1/PXJW6uzucdCJXo8y/SYLXVr7
	 DLoBDfHr7UPH8ZIlmjl0+Phmm46nSL0OZEvzOLJj1Rz3vbPFlrvLjeW+rEiI2f9gV/
	 /zPrZVZeOMitoeEuMbVUeSvJ2PI8ujrGpT/zHvGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/319] nvmet-rdma: queue the release work under the mutex
Date: Thu, 26 Nov 2026 15:37:30 +0100
Message-ID: <20261126144008.593780181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 80095787f776967361cca76357f19e5445e0cd75 ]

nvmet_rdma_remove_one() takes the queue mutex, unlists each queue of
the device and queues its release work, then flushes nvmet-wq. So a
queue that still holds objects on the device must either be on the
list or have its release work queued. nvmet_rdma_queue_disconnect()
breaks that: it unlists the queue under the mutex, drops it, and only
then calls __nvmet_rdma_queue_disconnect() to queue the work. A device
removal in that window finds nothing to wait for, and the release work
then destroys the QP and CQ share on a freed device.

Queue the work before dropping the mutex, as nvmet_rdma_remove_one()
itself does. That's safe now that rdma_disconnect() no longer sleeps on
an iWARP event that needs the same mutex.

Fixes: f1d4ef7d8883 ("nvmet-rdma: register ib_client to not deadlock in device removal")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 995e2c112cc6d..0487ed0aeb1d3 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1741,17 +1741,17 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 
 static void nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 {
-	bool disconnect = false;
-
+	/*
+	 * Queue the release work with &nvmet_rdma_queue_mutex held, so that
+	 * nvmet_rdma_remove_one() either finds the queue on the list or the
+	 * work has already been queued.
+	 */
 	mutex_lock(&nvmet_rdma_queue_mutex);
 	if (!list_empty(&queue->queue_list)) {
 		list_del_init(&queue->queue_list);
-		disconnect = true;
+		__nvmet_rdma_queue_disconnect(queue);
 	}
 	mutex_unlock(&nvmet_rdma_queue_mutex);
-
-	if (disconnect)
-		__nvmet_rdma_queue_disconnect(queue);
 }
 
 static void nvmet_rdma_queue_connect_fail(struct rdma_cm_id *cm_id,
-- 
2.53.0



