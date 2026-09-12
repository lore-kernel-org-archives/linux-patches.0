Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF1938F949;
	Sat, 12 Sep 2026 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232388; cv=none; b=Lra8/d5GPDpgD0zV3vUs8YpmuprlEBZWnp/wiolW2UdNJXZfSrAiCXId1KMbSI3Olr3pTPtmvchV+rakTb3tInYqGqeSdwzu1k6hbdpDL18czNLPXfML86Kjwjl1klX6UiSUGqMRzrYOwaqQ13lPU/+glbWk7+gOk1UeV0re9yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232388; c=relaxed/simple;
	bh=O/PvsZXVYktqEOblQpoAuF9cUSDuPvdFbhCy6FAG/O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAjFzxi+RLoFhddq/WwEzRU8wCQbf+eWkeZYT2ifkoXuNE06M+K71BmeQAgYYHdPgAXBDsEXUqDST67iIUkHdtBzXVxe/A79am7f+DKHwNkMCZYt2f/TbsUHdO0muebYnvo3g3Vdcx2Qw8EGWvb6hWJrv0475LdkX9LUKO1LjG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtNZXcvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtNZXcvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998401F000FF;
	Sat, 12 Sep 2026 16:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232387;
	bh=A0a8h7baiQXvSnfWfIXOmDV6jupkDuJ4cEQdkLUdjRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtNZXcvxW62l2f0q/umUsfD9e+A1qHXk/Szm8TZ3cUXOURnJq0+VfelG2VOPTPWnP
	 xTQEMFyvG5IwHeBOWuDLAWXY1Z1Jl9C0x7PQLnMcksB6kkBmAGa6c8x5nuz2pzbQpo
	 +USZkzzoi0Tf9Ah3hORIlN/7lgd+3UxTeHQtEqqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 1190/1191] nvmet-rdma: fix queue leak when connect backlog is exceeded
Date: Sat, 12 Sep 2026 09:05:18 +0200
Message-ID: <20260912065614.862118785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

commit fb1ed67788e21832b614c23767a088c08cfdd2f2 upstream.

When pending disconnecting queues exceed the backlog limit, the
connect path only drops the device reference and leaks the newly
allocated queue and its IB resources.

Fixes: badc53620fe8 ("nvme: target: rdma: fix ndev refcount leak on queue connect")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/rdma.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1628,19 +1628,13 @@ static int nvmet_rdma_queue_connect(stru
 		mutex_unlock(&nvmet_rdma_queue_mutex);
 		if (pending > NVMET_RDMA_BACKLOG) {
 			ret = NVME_SC_CONNECT_CTRL_BUSY;
-			goto put_device;
+			goto free_queue;
 		}
 	}
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
-	if (ret) {
-		/*
-		 * Don't destroy the cm_id in free path, as we implicitly
-		 * destroy the cm_id here with non-zero ret code.
-		 */
-		queue->cm_id = NULL;
+	if (ret)
 		goto free_queue;
-	}
 
 	mutex_lock(&nvmet_rdma_queue_mutex);
 	list_add_tail(&queue->queue_list, &nvmet_rdma_queue_list);
@@ -1649,6 +1643,11 @@ static int nvmet_rdma_queue_connect(stru
 	return 0;
 
 free_queue:
+	/*
+	 * Don't destroy the cm_id in free path, as we implicitly
+	 * destroy the cm_id here with non-zero ret code.
+	 */
+	queue->cm_id = NULL;
 	nvmet_rdma_free_queue(queue);
 put_device:
 	kref_put(&ndev->ref, nvmet_rdma_free_dev);


