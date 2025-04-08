Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F2A267F57;
	Tue,  8 Apr 2025 11:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112740; cv=none; b=WGFOI2gXh5ZUper5lIO7frZBdGp6MmzPbUD/qJl8S4Oymi0/9KXIjn0Z1al9HeucNBiUM/wDjELzPPl8I4Q2bK6ha7a4GhnsYhj06Li7M8rWE7sWL5h28Mv5+RZLqBT7sgCvNY7A4lR7LBP4SE/inwjWrGditaYRZfh2X/PklpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112740; c=relaxed/simple;
	bh=Nztg4FQECDN7QHbJw1bChN1wDgM6HUHhbzi46pM/l0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UjPZ8zsct99tjUbKE7pgNIs0hZwjdszcvZgoqYry2vikppsELb28fwrUQcfigSlCDHOZGv7uO+dCe+0vCUDhgbUQOUBUUYy38QEGKgY08uGVsk+VhrmI/6B8oeCbooYxUd726iAv6kURKt2iIWiVoFVY1GKbjY6Axp7057HQvvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZukXzov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZukXzov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE9FC4CEE5;
	Tue,  8 Apr 2025 11:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112740;
	bh=Nztg4FQECDN7QHbJw1bChN1wDgM6HUHhbzi46pM/l0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZukXzovpVpVd6fOU3XQNu/TGT8NwsIzWyOUHnyiHeUWqDQkp4P8ebKOF8GLe74nG
	 mAm8wvnck2nW0cdj6G1MoiuJ4Fg07dANb+oudwtVXEZT8AnEq7K8A028rOJ1Fgitkc
	 3hWreqAVVBZzLBYUW+Nu76CDD2iFpQcAdjyHnPoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/279] IB/mad: Check available slots before posting receive WRs
Date: Tue,  8 Apr 2025 12:49:24 +0200
Message-ID: <20250408104831.217984125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 37826f0a8c2f6b6add5179003b8597e32a445362 ]

The ib_post_receive_mads() function handles posting receive work
requests (WRs) to MAD QPs and is called in two cases:
1) When a MAD port is opened.
2) When a receive WQE is consumed upon receiving a new MAD.

Whereas, if MADs arrive during the port open phase, a race condition
might cause an extra WR to be posted, exceeding the QP’s capacity.
This leads to failures such as:
infiniband mlx5_0: ib_post_recv failed: -12
infiniband mlx5_0: Couldn't post receive WRs
infiniband mlx5_0: Couldn't start port
infiniband mlx5_0: Couldn't open port 1

Fix this by checking the current receive count before posting a new WR.
If the QP’s receive queue is full, do not post additional WRs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Link: https://patch.msgid.link/c4984ba3c3a98a5711a558bccefcad789587ecf1.1741875592.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 38 ++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 58befbaaf0ad5..242434c09e8d8 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2671,11 +2671,11 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 				    struct ib_mad_private *mad)
 {
 	unsigned long flags;
-	int post, ret;
 	struct ib_mad_private *mad_priv;
 	struct ib_sge sg_list;
 	struct ib_recv_wr recv_wr;
 	struct ib_mad_queue *recv_queue = &qp_info->recv_queue;
+	int ret = 0;
 
 	/* Initialize common scatter list fields */
 	sg_list.lkey = qp_info->port_priv->pd->local_dma_lkey;
@@ -2685,7 +2685,7 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 	recv_wr.sg_list = &sg_list;
 	recv_wr.num_sge = 1;
 
-	do {
+	while (true) {
 		/* Allocate and map receive buffer */
 		if (mad) {
 			mad_priv = mad;
@@ -2693,10 +2693,8 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 		} else {
 			mad_priv = alloc_mad_private(port_mad_size(qp_info->port_priv),
 						     GFP_ATOMIC);
-			if (!mad_priv) {
-				ret = -ENOMEM;
-				break;
-			}
+			if (!mad_priv)
+				return -ENOMEM;
 		}
 		sg_list.length = mad_priv_dma_size(mad_priv);
 		sg_list.addr = ib_dma_map_single(qp_info->port_priv->device,
@@ -2705,37 +2703,41 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 						 DMA_FROM_DEVICE);
 		if (unlikely(ib_dma_mapping_error(qp_info->port_priv->device,
 						  sg_list.addr))) {
-			kfree(mad_priv);
 			ret = -ENOMEM;
-			break;
+			goto free_mad_priv;
 		}
 		mad_priv->header.mapping = sg_list.addr;
 		mad_priv->header.mad_list.mad_queue = recv_queue;
 		mad_priv->header.mad_list.cqe.done = ib_mad_recv_done;
 		recv_wr.wr_cqe = &mad_priv->header.mad_list.cqe;
-
-		/* Post receive WR */
 		spin_lock_irqsave(&recv_queue->lock, flags);
-		post = (++recv_queue->count < recv_queue->max_active);
-		list_add_tail(&mad_priv->header.mad_list.list, &recv_queue->list);
+		if (recv_queue->count >= recv_queue->max_active) {
+			/* Fully populated the receive queue */
+			spin_unlock_irqrestore(&recv_queue->lock, flags);
+			break;
+		}
+		recv_queue->count++;
+		list_add_tail(&mad_priv->header.mad_list.list,
+			      &recv_queue->list);
 		spin_unlock_irqrestore(&recv_queue->lock, flags);
+
 		ret = ib_post_recv(qp_info->qp, &recv_wr, NULL);
 		if (ret) {
 			spin_lock_irqsave(&recv_queue->lock, flags);
 			list_del(&mad_priv->header.mad_list.list);
 			recv_queue->count--;
 			spin_unlock_irqrestore(&recv_queue->lock, flags);
-			ib_dma_unmap_single(qp_info->port_priv->device,
-					    mad_priv->header.mapping,
-					    mad_priv_dma_size(mad_priv),
-					    DMA_FROM_DEVICE);
-			kfree(mad_priv);
 			dev_err(&qp_info->port_priv->device->dev,
 				"ib_post_recv failed: %d\n", ret);
 			break;
 		}
-	} while (post);
+	}
 
+	ib_dma_unmap_single(qp_info->port_priv->device,
+			    mad_priv->header.mapping,
+			    mad_priv_dma_size(mad_priv), DMA_FROM_DEVICE);
+free_mad_priv:
+	kfree(mad_priv);
 	return ret;
 }
 
-- 
2.39.5



