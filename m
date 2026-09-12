Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51DB2F617C;
	Sat, 12 Sep 2026 18:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238606; cv=none; b=Edm4IcQ8axVNMYcjI3k2UJfwK9Q8EALT+HEpSd6D9pxKwIY6Lj3v3TBzSufPSsotULLOlv5bSdeHBh1/AmAzYdljWu8xcVaCgyJCjwc4NqQYjEjBNvSLEKXK46I6G0WoU26bLyE+7BJqAUpaWPZ7iYyqeUp3otcsnZ+hCahIAuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238606; c=relaxed/simple;
	bh=lB6GbOjneTef4TA+nXEny+qz+sz7uniq94zLIRJV4BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNw1i3dC2IX65aQbiQ+RXcNbVDgTtIj5SErPfpgBadjR8mpL33Ec0ddIP4CNqonz1tcaQGPRoLUW/1z2cUBYZowjtsgz0t4u/jHMdsh0Ju670moW34bfvONyI5S/yHTgGkHvqt/VS8gKuf8ueU4dIZs4xgJycfaJNWEGTWJc3u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsgCledt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsgCledt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5161F000FF;
	Sat, 12 Sep 2026 18:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238605;
	bh=iBeM+paYB0ulpXYUIyo11f/tRS/njC8NsNOvIMZzjkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsgCledt8kRPcJtj1yaavKCwi0VejtJBVxAMI7kp414JEj5x5TwG8hNaXO99/9MKM
	 6Y0MHQoDrEFzDW8qH2sWMBLGIbeU39bf/9LNc1t7+UdsGanhYM3nJFF+dDHTepM1MV
	 SACXGkvKBrva5tDRHau2P4ufoMCqZpBd5kZ0Ztco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/935] nvmet-rdma: avoid circular locking dependency on install_queue()
Date: Sat, 12 Sep 2026 08:57:53 +0200
Message-ID: <20260912065536.991672518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ca21cd66b1f4e..afdbe0506df5d 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -36,6 +36,8 @@
 #define NVMET_RDMA_MAX_MDTS			8
 #define NVMET_RDMA_MAX_METADATA_MDTS		5
 
+#define NVMET_RDMA_BACKLOG 128
+
 struct nvmet_rdma_srq;
 
 struct nvmet_rdma_cmd {
@@ -1589,8 +1591,19 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
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
@@ -1886,7 +1899,7 @@ static int nvmet_rdma_enable_port(struct nvmet_rdma_port *port)
 		goto out_destroy_id;
 	}
 
-	ret = rdma_listen(cm_id, 128);
+	ret = rdma_listen(cm_id, NVMET_RDMA_BACKLOG);
 	if (ret) {
 		pr_err("listening to %pISpcs failed (%d)\n", addr, ret);
 		goto out_destroy_id;
-- 
2.53.0



