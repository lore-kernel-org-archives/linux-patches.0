Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621493;
	b=keVmRReJvQZmMFrxDOZ5t7+4ATAIL4tLcl5IcaAh7LRHvHN4sSmHPzrcSjKvofmx17Bw
	 zcHXSZune6ZmrQ0oC9SOfO6rD50CHlJRP7SEFHGH5uppWLpB+lf4BXwPRuFdPt69PNyUX
	 MH6djb/GIzcvua3p5Q8/48ODEFdM6GuRaW+u/6o3QLY3gXzHYaF4+thTE3Tgyq2gV/NC0
	 r0VUUOV7ECxVP93hH3W4ZzGtEt6xIcOVNA8oXBJdoiTWISKYvSfmDKk8ruLvSLQBb4RWt
	 YVf/o4BBFeN6wd56AIx6qB63rCNXhCPLAbQXYvAawKyqStMqgF18tW+quXaaNp3s8rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yEXaiAqxXd+d6zB0+MQLDudbjKuf+msfwNYDPzTGWoA=;
	b=YUEepqHzQEzRRNAWiyJwP/6WQcNlzm+EnqBj4FR+aUz7g7A3qJDHZcnvOJrjz3I9tnLF
	 X3sxVIgS2ku4lQdNTLnxkVtcZO0+6W8bcFc/s/2nTxD5FyYiT39baivyqvAlricwDlSlb
	 qN7aptceRrMpKXmjJTQHI2XKhAQh9LSdf0++DBasL3d4HnTWyhcUvJa+Wm784V/oO52GC
	 5Lv67ocl3LxPxB+K18zoBXEZN/FWRhHCSoD1NlXTMwPWRZ6ldWB0QbOyWFDS5G6/UopJ1
	 AZeHEIjIsCcAtKPktl6xi/6BToVS+LdEwXFJ7R1RlQL3Znw5J3ScPPbB4j4TJPiMjgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ETZc3wUP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF375606A321;
	Wed, 25 Nov 2026 15:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ETZc3wUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA31F000C4;
	Wed, 25 Nov 2026 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621492;
	bh=yEXaiAqxXd+d6zB0+MQLDudbjKuf+msfwNYDPzTGWoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETZc3wUPTblKFQpJO+DhXyQWrbwRqx7xdtLG1OjdGyor+0tY0bs1EwTpUJrbBbqW7
	 1oaCnkwucsNCxA1m1LpuVSIlbF8Rw4w1I+QFvp7Ze1GFeEmFde0w5SqBQXYiN9lJUZ
	 tcm7+hH7IoMRNIyMPcrw/6ct/Vfp5Kj9D8lnJ80Y=
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
Subject: [PATCH 6.18 241/990] nvmet-rdma: queue the release work under the mutex
Date: Wed, 25 Nov 2026 15:26:48 +0100
Message-ID: <20261125143827.735193624@linuxfoundation.org>
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
index 816ad550d1fc8..58fc89b22c98c 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1742,17 +1742,17 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 
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



