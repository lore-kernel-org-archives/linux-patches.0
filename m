Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E262C6AF;
	Sun,  1 Sep 2024 17:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210263; cv=none; b=D4VGzdSTWoaFAH03HDlFr/ErGNaLfyW7El3KOThzM58k7xASv16o2O0ISfBXnZUSRo94Ju2dW6ZDiOAgeGbktv0px5xfF93LPrOs9wMGMmEKwq31X2wSNn1UT+o0+ASvYR2QR0epRvED6z6ilTYY9X1YtFMyfYO6oAoFBbtLBr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210263; c=relaxed/simple;
	bh=azef8RR3SUT1zIhdW1AglG3mPDqLdB4XRgqNxV58Rfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTfbrCFdT5iDCja43Gtmd7GRCEb/1Yn8uemkxLjt8UApLWXiFSD23xmg8DGxG/FwThkvC3fJDNlFuieYnelsfF6jM9AeTn967I+UXzSwyRvqsA486LMSx2jQ7uT4cGXBTbbo5mgLWsGSEA8ZthX8WmgtrqfDMdMtHZztXcMdz2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BX36yeSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BX36yeSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BF2C4CEC3;
	Sun,  1 Sep 2024 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210263;
	bh=azef8RR3SUT1zIhdW1AglG3mPDqLdB4XRgqNxV58Rfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BX36yeSDBRc7sIGAq4hCGRQj16jNapdxIA6MH0Y88+Oos3Jv7X/z/UkgubVEceKTM
	 RI7arCFy/MOxXmUJdXmNwZeyPsrkPuPVSpUHvWh1Xdb/ibNbWFBu+RgGJQd3tYwU6d
	 3WHXsN9g5TaVBbkE3GPiDPaEwGMbW1fMNw+UUXVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/215] nvmet-rdma: fix possible bad dereference when freeing rsps
Date: Sun,  1 Sep 2024 18:16:58 +0200
Message-ID: <20240901160827.353003082@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 18e082091c821..9561ba3d43138 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -472,12 +472,8 @@ nvmet_rdma_alloc_rsps(struct nvmet_rdma_queue *queue)
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
@@ -488,12 +484,8 @@ static void nvmet_rdma_free_rsps(struct nvmet_rdma_queue *queue)
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



