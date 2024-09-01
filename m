Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF0C1C68C;
	Sun,  1 Sep 2024 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208893; cv=none; b=aNYnJUp39pzEbaG4P0ckhkG4V5cvNfVDp9nlGvFpNaT9q9fhWwo7RK99yMe1GxUNIQ/Foquof3oK24Ut5o4SGA4ynzi1G0zp2aQuXDiZ+/1ivR0hDlbxMQJtEgYOtVAwa8CrbYrmAaVV2Tio7F8+eTkosDvwqXc5OqUabZ0LXAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208893; c=relaxed/simple;
	bh=cDQYgZ3wFd5Dcx32HriffctQochTF49ssn4m1Gp8AMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUNW3ospRcbPz0Na6JyYdF8OG5dPjYudU1XRBfiuhhyormhgfLRNvb0Ypka3QieS2Tz/GIdBhXhb+dQYONg87UjLcHB7CGHYtDVCzCaPcZBsYLiehoHFRNg1WX6nzYbO8NLXP2RSnY/Ssp6qFkZiVImtpBzM82sdSOElhAPGVIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTLWah1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTLWah1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432C8C4CEC3;
	Sun,  1 Sep 2024 16:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208892;
	bh=cDQYgZ3wFd5Dcx32HriffctQochTF49ssn4m1Gp8AMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTLWah1QtzO/JW/Id2kzAX3IPAMUhJA9hJo4BpoqoXrp7i76gHea2V3sXfw1UguiO
	 vrq3hBTGdF9TULDvnnl14qMOIKUDzQBpY2ySLAAsZXMEuEVhAjtS+D5k2sQijmixjO
	 amF9WVnCZd5/IDHAz5t5QsVw4sZQccMIatwiI5L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/134] nvmet-rdma: fix possible bad dereference when freeing rsps
Date: Sun,  1 Sep 2024 18:16:58 +0200
Message-ID: <20240901160812.811590025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 50e2007092bc0..ae41b6001c7e2 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -428,12 +428,8 @@ nvmet_rdma_alloc_rsps(struct nvmet_rdma_queue *queue)
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
@@ -444,12 +440,8 @@ static void nvmet_rdma_free_rsps(struct nvmet_rdma_queue *queue)
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



