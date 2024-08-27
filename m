Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82931C8FCF;
	Tue, 27 Aug 2024 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772510; cv=none; b=h3EN8e8Gew+zdftnImUqieG+dtGZrhdANRry0yQWSuZBsKn6Ilnu7c8ILMJFZ1OVAJdQQaNT4cvvFrQrQtCYKIS0OxZDDQibQd7UzfqmO3nV4KAYUUds45/pgJj3n3c6Z5aWEf7Sg8ZX1apnYwNtac7Ow9pT8R60k3KvnSlw/iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772510; c=relaxed/simple;
	bh=15ND0/OmnlhDWZQU/Pfj1+qXlnppLPNQlonez7Tw9QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJSkaX+wJUvx/6vekYqGxZnHyB6tuAUbPtGv1B9EP7Ra+ixpivqBq5BHcdHmxYgIwBfCzVIs8G/FGWT/3RlSCS9h/If/ISRg+ZjmnxMYDTlHl9tZHh6VUrfJF1O5yET0Rl7rqXX3SFcaFUxZmKI10+mLayO29rO+1vSSsdJEWBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5qLgZLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5qLgZLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D85C6104E;
	Tue, 27 Aug 2024 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772509;
	bh=15ND0/OmnlhDWZQU/Pfj1+qXlnppLPNQlonez7Tw9QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5qLgZLCPHgHdE9/ZcSmICGbQyFCaAxfLcrRosKz/3yjJ+pUU2MVAF1tYXTOusBj8
	 Q2BH1xtMO+Iels9cB223SdHL8mtZY+a1rnyQAdQ4PZ+0LKwfcVOZcvlTIB/oYlgwLT
	 S843TIhCG1QVg2P6lJL8pS8/PgMxZ+h92b/tsK+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/321] nvmet-rdma: fix possible bad dereference when freeing rsps
Date: Tue, 27 Aug 2024 16:38:33 +0200
Message-ID: <20240827143846.037511249@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 73964c1d07c054376f1b32a62548571795159148 ]

It is possible that the host connected and saw a cm established
event and started sending nvme capsules on the qp, however the
ctrl did not yet see an established event. This is why the
rsp_wait_list exists (for async handling of these cmds, we move
them to a pending list).

Furthermore, it is possible that the ctrl cm times out, resulting
in a connect-error cm event. in this case we hit a bad deref [1]
because in nvmet_rdma_free_rsps we assume that all the responses
are in the free list.

We are freeing the cmds array anyways, so don't even bother to
remove the rsp from the free_list. It is also guaranteed that we
are not racing anything when we are releasing the queue so no
other context accessing this array should be running.

[1]:
--
Workqueue: nvmet-free-wq nvmet_rdma_free_queue_work [nvmet_rdma]
[...]
pc : nvmet_rdma_free_rsps+0x78/0xb8 [nvmet_rdma]
lr : nvmet_rdma_free_queue_work+0x88/0x120 [nvmet_rdma]
 Call trace:
 nvmet_rdma_free_rsps+0x78/0xb8 [nvmet_rdma]
 nvmet_rdma_free_queue_work+0x88/0x120 [nvmet_rdma]
 process_one_work+0x1ec/0x4a0
 worker_thread+0x48/0x490
 kthread+0x158/0x160
 ret_from_fork+0x10/0x18
--

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 4597bca43a6d8..a6d55ebb82382 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -473,12 +473,8 @@ nvmet_rdma_alloc_rsps(struct nvmet_rdma_queue *queue)
 	return 0;
 
 out_free:
-	while (--i >= 0) {
-		struct nvmet_rdma_rsp *rsp = &queue->rsps[i];
-
-		list_del(&rsp->free_list);
-		nvmet_rdma_free_rsp(ndev, rsp);
-	}
+	while (--i >= 0)
+		nvmet_rdma_free_rsp(ndev, &queue->rsps[i]);
 	kfree(queue->rsps);
 out:
 	return ret;
@@ -489,12 +485,8 @@ static void nvmet_rdma_free_rsps(struct nvmet_rdma_queue *queue)
 	struct nvmet_rdma_device *ndev = queue->dev;
 	int i, nr_rsps = queue->recv_queue_size * 2;
 
-	for (i = 0; i < nr_rsps; i++) {
-		struct nvmet_rdma_rsp *rsp = &queue->rsps[i];
-
-		list_del(&rsp->free_list);
-		nvmet_rdma_free_rsp(ndev, rsp);
-	}
+	for (i = 0; i < nr_rsps; i++)
+		nvmet_rdma_free_rsp(ndev, &queue->rsps[i]);
 	kfree(queue->rsps);
 }
 
-- 
2.43.0



