Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75D11C6891;
	Tue, 27 Aug 2024 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770379; cv=none; b=L1qf/7ogrTTS1YLMWWJ3DbrSRhlHPD52gs17a5T2jiqKZeiYlGp8rjmg9GwIO5PNZz+0V7DAVGyc9q6eloA8mdAbyJAwxfJhVH3nFaMPzWPqyaZHaUeN7BRlUxazQ/af6qFbiXAMe0tCkAHcvYpP9y3L/Htiykon7aXj5lOmJCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770379; c=relaxed/simple;
	bh=fVmHMFrXpARnYJmG0PPY9N5UvxHct60YcI1OkkJ55do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssi9E2wxhOpNwR9OzzKXq/o9Mnv6MD/iPJm986v3D0fE6NJA9nx14kapvCzLUQfBuGEPHmDgRh2aErPyZ/nWzNuJ2HLSqkpkB9tYaVClqoTBr2cVx5EZLjcqoDi8pZzgBXvoCqGbOvosk9E9TammOKDd7GfhNHRVFeYRKOCIEuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/d/jYea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/d/jYea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19CFC61042;
	Tue, 27 Aug 2024 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770379;
	bh=fVmHMFrXpARnYJmG0PPY9N5UvxHct60YcI1OkkJ55do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/d/jYeabAGc4eoNZ57uale6l+CuXWS5MmjSLlrG+E/Lc8VU46too1bc7Y6Eu31ck
	 UZp4QkZWyJdapagAcXMR/2dWLsT34ut1vLQdjhmVv5N26Titg/cB8vV4h1QsS8h4il
	 fi8U/wIsCzi8xl8vFAzW0Tr0qleH2qSIFIlkVevc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/341] nvmet-rdma: fix possible bad dereference when freeing rsps
Date: Tue, 27 Aug 2024 16:37:22 +0200
Message-ID: <20240827143851.440991942@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



