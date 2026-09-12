Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F3A4BEE20;
	Sat, 12 Sep 2026 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222729; cv=none; b=XVLBxpZONIvsSnpIYtX1V0ns3tX3haMSPwk9zOyiaMJJyoqvEJsr8BPmkgvjnRgf/+gcbUx4zYs8lizsUaCvnBv+JIDIqiRf63qiWo82irbU3kmofhB2GlejWxdwS+l5/n538NZYHHlNxyh9afikIxYBVo3Qatg5pFD1G8WjGN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222729; c=relaxed/simple;
	bh=W5Lk5iS5rgWUL3EIiFY5dQLe6OJjVPgtZp3OdebpSlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ8husrdVyq7lnoMYPttKGZLBj/vJaePMh2a7GjEVZW+UgksX0qFcI2vlxbunbBwpUQXRWYzhn7/O24b8k5hMXW+5Q/yqxZqOys/JhX1a6R1kwkotmQ76LOWsQAsa7Uu1+rElxuObXUl5QMscU92cdX4fkIJOtTMhbVg3VvttVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbalp4aD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbalp4aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D2D1F000FF;
	Sat, 12 Sep 2026 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222727;
	bh=CsLn8EeoQp870ZtFPi4zt5fw/1Wg2Zm/A037P8S5e30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbalp4aDwuQTzibG3EPIy5QoOUpZvpOoRGv7LVwDpLR1/XPqj98WdWpHK4lVE/s9O
	 oTFNoL/oBqa2ZrjbEvpBN8wmMUuKGacnm3dTU5td9FqLRaxsM+gfZZLHjxMp4PP9Jj
	 f00wSuhVM0SjiIesKcyRpNQQe/xnHB1PupAYDJCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0646/1424] nvmet-rdma: avoid circular locking dependency on install_queue()
Date: Sat, 12 Sep 2026 08:51:18 +0200
Message-ID: <20260912065621.757115949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 31deaeb11ba7a885116c9c30892b9f763c04d59c ]

nvmet_rdma_install_queue() is driven from the ->io_work workqueue
function, but will call flush_workqueue() which might trigger
->release_work() which in itself calls flush_work on ->io_work.

To avoid that check for pending queue in disconnecting status,
and return 'controller busy' when we reached a certain threshold.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 0114dd303b37 ("nvmet-rdma: fix response resource leak on queue teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 32632e8af832d..ee56cf84627e9 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -37,6 +37,8 @@
 #define NVMET_RDMA_MAX_MDTS			8
 #define NVMET_RDMA_MAX_METADATA_MDTS		5
 
+#define NVMET_RDMA_BACKLOG 128
+
 struct nvmet_rdma_srq;
 
 struct nvmet_rdma_cmd {
@@ -1590,8 +1592,19 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 	}
 
 	if (queue->host_qid == 0) {
-		/* Let inflight controller teardown complete */
-		flush_workqueue(nvmet_wq);
+		struct nvmet_rdma_queue *q;
+		int pending = 0;
+
+		/* Check for pending controller teardown */
+		mutex_lock(&nvmet_rdma_queue_mutex);
+		list_for_each_entry(q, &nvmet_rdma_queue_list, queue_list) {
+			if (q->nvme_sq.ctrl == queue->nvme_sq.ctrl &&
+			    q->state == NVMET_RDMA_Q_DISCONNECTING)
+				pending++;
+		}
+		mutex_unlock(&nvmet_rdma_queue_mutex);
+		if (pending > NVMET_RDMA_BACKLOG)
+			return NVME_SC_CONNECT_CTRL_BUSY;
 	}
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
@@ -1887,7 +1900,7 @@ static int nvmet_rdma_enable_port(struct nvmet_rdma_port *port)
 		goto out_destroy_id;
 	}
 
-	ret = rdma_listen(cm_id, 128);
+	ret = rdma_listen(cm_id, NVMET_RDMA_BACKLOG);
 	if (ret) {
 		pr_err("listening to %pISpcs failed (%d)\n", addr, ret);
 		goto out_destroy_id;
-- 
2.53.0



