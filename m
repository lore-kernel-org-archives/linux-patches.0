Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704282;
	b=DSgFmMOJO1+FFbjh/GW3mNOzIxhrK2GTo2m9QYNT6zrcRIHwQLl0kl+PKSXEKWpdhgnj
	 4G48bQYaiPYRKVxOHZb3vndUvE4+4lQf+WJXn4ncQae52k0TwLFuL0TTFAtMu82Z5wohp
	 eTdJCdG1N0kDii4JhHd/SCs41P2i1aJcUOVx2IXSYhkQtBsWpHv0qlNA793RXGvgG8dhv
	 /PcspojteA9WcKgrPnZ6A9HqpJUhMMzo3CXGlQ93J0eY4YYvZbFZHjInsN+ajlIAd+FpU
	 po6+LCfQuCKiSyxAS7qDWRa5hkYzQBWbVyvyTvrpGiBFxvKjDWRNz6Z6sGkovV1LiXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=meZFR3TLdcWtImpEA8STfE+KY5WQdvUU8pcvx8gjeuA=;
	b=sFIrmGUlEXe4A7RXHtVYbhmIrg2W1gHbiuX5Y5gKileq5ZNk808lZKRb5JUqpd8HVgWS
	 PuW1d/e1VoeimmD4NmCcojNhB2zmbNPWgTDyRf1q6DHmHgU3hSN2jmtQXZmXLXNDv5pkt
	 qXZOGg7sdcloexHL8rkzvEQK3EKRy//X86PNtHpMu+y96eGtgTS24BkjoO5/tOTZHbWYE
	 rtl6Egx8OfwFjzmxX4gjmdjrrW0EPxzIzHyynPizmc0K7fIfE/yy7kTH2SQYTWi3Hfsls
	 w6Bq0z6SJlNLCr0yJUdstc9/lQDZTm+JHg02gbmCDjKymjDKv/FZky+O2pVQvMEXhwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvPEgxj9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087C3606A330;
	Thu, 26 Nov 2026 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvPEgxj9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3871F000D2;
	Thu, 26 Nov 2026 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704281;
	bh=meZFR3TLdcWtImpEA8STfE+KY5WQdvUU8pcvx8gjeuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvPEgxj9XQ0am3oDqbMoCx+Hu/VYA7h1v4js8kBxqNYlpBkPLM3WNjXuyH8sw6Rnh
	 mOTBFhG0MemZ3a4OwWhg+ePq5yH2itiQThQDUNk38zbqCxnD6wU9WaghP4VFAz57m9
	 khTu3GHBvG5+uvBBJ3i2y5zb3f2MppXGSDPcy2LA=
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
Subject: [PATCH 5.10 069/265] nvmet-rdma: queue the release work under the mutex
Date: Thu, 26 Nov 2026 15:36:39 +0100
Message-ID: <20261126143609.912941343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7a7aeac657819..7292eb1f4262f 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1701,17 +1701,17 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 
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



