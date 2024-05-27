Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF63E17E90E;
	Mon, 27 May 2024 19:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837288; cv=none; b=X3fH4sk1sXBuvEwzeuwX3hB9F8u3QpzRsM4TNvKEhIYotq5cAyp1UN2gqZTiA5+NR1FMmDBrkH8cDyTKsGx9XwZVF/4853/9fp31r1X+RAEe+qjig3k7Co6WqTTop2cz3xc4haSmBkxI4OcwOp4URNQkhxJllUPZvQZKgf17bN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837288; c=relaxed/simple;
	bh=J+eyzz/ym8sjNNG8KRrD4QoJa4hm0P+YvU3ay8Oku1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7dzU2vgx6X79qzdX1vtgxjw7K3tdKrXDDPn6fL0tXOQCjPCsmK+ABfIN8wsN6Ub6wQEFTO4SvqkJdE2zo8kNn6x/FagZBAxW9CHWCU9OgPE2wtfe5ipInOvoGv+nz9bROY6G2eWEFCKNuPX9x+Q6xLyr+eOiM1uGTIikh/R58U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmbxLtpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmbxLtpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853D7C2BBFC;
	Mon, 27 May 2024 19:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837287;
	bh=J+eyzz/ym8sjNNG8KRrD4QoJa4hm0P+YvU3ay8Oku1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmbxLtpceDr474tOuKdyLtC+tSaqNE5YNbj99KhI24QjZqv75N1ZaaH6pezy009qc
	 yc9EVoFgnU/jqR6oY0bfKzs9ufwJk68dFVdvIcn7anwkrp3d+nsvyxM6G9pNeuAmxV
	 CtweUYa0XKVMteRGgDehuGOaOOF1TJskAPWAcKKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 383/427] RDMA/mana_ib: Introduce helpers to create and destroy mana queues
Date: Mon, 27 May 2024 20:57:10 +0200
Message-ID: <20240527185634.590641344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 46f5be7cd4bceb3a503c544b3dab7b75fe4bb96b ]

Intoduce helpers to work with mana ib queues (struct mana_ib_queue).
A queue always consists of umem, gdma_region, and id.
A queue can become a WQ or a CQ.

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://lore.kernel.org/r/1711483688-24358-2-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: f79edef79b6a ("RDMA/mana_ib: boundary check before installing cq callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c    | 43 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h | 10 +++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 71e33feee61bb..4524c6b807487 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -237,6 +237,49 @@ void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 		ibdev_dbg(ibdev, "Failed to destroy doorbell page %d\n", ret);
 }
 
+int mana_ib_create_queue(struct mana_ib_dev *mdev, u64 addr, u32 size,
+			 struct mana_ib_queue *queue)
+{
+	struct ib_umem *umem;
+	int err;
+
+	queue->umem = NULL;
+	queue->id = INVALID_QUEUE_ID;
+	queue->gdma_region = GDMA_INVALID_DMA_REGION;
+
+	umem = ib_umem_get(&mdev->ib_dev, addr, size, IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(umem)) {
+		err = PTR_ERR(umem);
+		ibdev_dbg(&mdev->ib_dev, "Failed to get umem, %d\n", err);
+		return err;
+	}
+
+	err = mana_ib_create_zero_offset_dma_region(mdev, umem, &queue->gdma_region);
+	if (err) {
+		ibdev_dbg(&mdev->ib_dev, "Failed to create dma region, %d\n", err);
+		goto free_umem;
+	}
+	queue->umem = umem;
+
+	ibdev_dbg(&mdev->ib_dev,
+		  "create_dma_region ret %d gdma_region 0x%llx\n",
+		  err, queue->gdma_region);
+
+	return 0;
+free_umem:
+	ib_umem_release(umem);
+	return err;
+}
+
+void mana_ib_destroy_queue(struct mana_ib_dev *mdev, struct mana_ib_queue *queue)
+{
+	/* Ignore return code as there is not much we can do about it.
+	 * The error message is printed inside.
+	 */
+	mana_ib_gd_destroy_dma_region(mdev, queue->gdma_region);
+	ib_umem_release(queue->umem);
+}
+
 static int
 mana_ib_gd_first_dma_region(struct mana_ib_dev *dev,
 			    struct gdma_context *gc,
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index f83390eebb7d7..859fd3bfc764f 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -45,6 +45,12 @@ struct mana_ib_adapter_caps {
 	u32 max_inline_data_size;
 };
 
+struct mana_ib_queue {
+	struct ib_umem *umem;
+	u64 gdma_region;
+	u64 id;
+};
+
 struct mana_ib_dev {
 	struct ib_device ib_dev;
 	struct gdma_dev *gdma_dev;
@@ -169,6 +175,10 @@ int mana_ib_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
 int mana_ib_gd_destroy_dma_region(struct mana_ib_dev *dev,
 				  mana_handle_t gdma_region);
 
+int mana_ib_create_queue(struct mana_ib_dev *mdev, u64 addr, u32 size,
+			 struct mana_ib_queue *queue);
+void mana_ib_destroy_queue(struct mana_ib_dev *mdev, struct mana_ib_queue *queue);
+
 struct ib_wq *mana_ib_create_wq(struct ib_pd *pd,
 				struct ib_wq_init_attr *init_attr,
 				struct ib_udata *udata);
-- 
2.43.0



