Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624453;
	b=XpQXhUrdveAVbX8hJDGAI7mRo11wONVoLUCA96ttJuja5vXAJ72TZWSCThK2bQ3GiIRq
	 u5sQ1O5VOIuPElZqT7tF8qhTHzDmzn/5FLOAhD4rCWfmR0X8qB2NgRSLKFzBHKi477/86
	 AGmdQESt9ARtWqs16cDrqFCeApFAstWMS4NZDPutIdmhBa033H8kj9LpaApFXVVmHgFy5
	 t8HbZ6HUV63BQR4+1Tz3IpqIMitKhSYEOE4nUN9GTl3PKVb1rDgbiv5Wzg2H93s8EQ828
	 bAjHsWyEHod5Qki/6nKiwLPB9mQqUOExMapoRKY+GmWaNTHfXRh2l/VMK+vNDa/Dc6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJv5i7wizsTxGx/QsB2m9aIPujGF9eJ5jvkeSACpA/U=;
	b=tgrAWOjrE6moaAaC96GBWBRHQi17bznNkMDYUKyGa8p2am1akyOnmZ2uNr/7quZtwnQr
	 gFB965OfODx1h59pFCV4WNX6YDfU0oC1eJEsOQQNLqrtcSq7qT9aTsBFSDbO0R/r8O1X2
	 1po6sO0lJ1aZKhhfpggV9pePDpClK7WqBhf0ViHZCiXpX0OQ1NSeky6EjmA3h3drF6zwq
	 UrYoY/jTmTsmySy4jTPPbBcTGUkxoxgznGjOlv0qUEonz0yCY6FpyH0nr20qeY7I9LHT/
	 xlCKhqFEhWdCq3CVKQuyJ7F5EjyfLgwMc3/90di2F5rVp67EEfZFtVS8cevtbfcfxgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLq3fLua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DD9606A33F;
	Wed, 25 Nov 2026 16:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLq3fLua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC621F000C4;
	Wed, 25 Nov 2026 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624452;
	bh=TJv5i7wizsTxGx/QsB2m9aIPujGF9eJ5jvkeSACpA/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLq3fLua7JseCa7IDELEjsKpj7P7wyKw066/FvrlHmbmzPpCn8d2dOcM8223VcHk3
	 4uzw6Ds5R61szxrN1UzVlB2VyFLHm+8JajcFJtk+unKc7ovNf70YPgGO8ytYDsirhc
	 y+SgEPoAJdxDcHgShmBJAMuHMrn9T8/GdtamFIHk=
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
Subject: [PATCH 6.12 197/816] nvmet-rdma: queue the release work under the mutex
Date: Wed, 25 Nov 2026 15:29:05 +0100
Message-ID: <20261125143853.752867141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cff39abc4f981..78b541a6fb089 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1740,17 +1740,17 @@ static void __nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue)
 
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



