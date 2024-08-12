Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C39183CA6;
	Mon, 12 Aug 2024 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479898; cv=none; b=PN/nJEevZCZiCl8WqjY8fiJ6tMBOIOOJNOgrPe1H4lYv4tV/Gtoq/Y2rCdmAXN5GMKqv5DRFq7sqt0Ajsx72PcYrndqWkOCVONjOJIXN90RTsLFtVaEX+2nYGhtbzZnVoXcko77VN0Wb1fguCnH/xY1UGR5tmq2Q9E9drmIQWlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479898; c=relaxed/simple;
	bh=O5WDk00NDH2p8IX4IWS08Y5Eg1plsb7w3Lt9FxtBpbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yjge5KAGLZFhRemLvvbMZx1V39da5o8GbsR8ukH6waOl9skrQnKln+4rnQnGPNiz2/P41VkhLBUqsYnFr29gbFnw4Ez3AG8RB2i/AR9fnl4NGQl0vlR5DEZEWBEUCrgl5DHFsrwMiQ6YJnmPHFfpw80eq9C6tVTV1dszAw4nCpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyS2YgNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyS2YgNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1E5C32782;
	Mon, 12 Aug 2024 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479897;
	bh=O5WDk00NDH2p8IX4IWS08Y5Eg1plsb7w3Lt9FxtBpbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyS2YgNNWZUNbnyi1Eq0x832i2WnToO/HoFtosE/1XTl4+yjjQL9DAhH5QW0vRksG
	 2Lkj/zVA6Ae6y1bAqhnv8/vAWfucYRBKU02DwFpugkCfvPfekeDWPh6k7//PL3hWpw
	 8R+ucU4lh3trsunE4AC1w+1llM03ygfbLnXmczR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Simon Horman <horms@kernel.org>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 034/263] idpf: fix UAFs when destroying the queues
Date: Mon, 12 Aug 2024 18:00:35 +0200
Message-ID: <20240812160147.848372384@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 290f1c033281c1a502a3cd1c53c3a549259c491f ]

The second tagged commit started sometimes (very rarely, but possible)
throwing WARNs from
net/core/page_pool.c:page_pool_disable_direct_recycling().
Turned out idpf frees interrupt vectors with embedded NAPIs *before*
freeing the queues making page_pools' NAPI pointers lead to freed
memory before these pools are destroyed by libeth.
It's not clear whether there are other accesses to the freed vectors
when destroying the queues, but anyway, we usually free queue/interrupt
vectors only when the queues are destroyed and the NAPIs are guaranteed
to not be referenced anywhere.

Invert the allocation and freeing logic making queue/interrupt vectors
be allocated first and freed last. Vectors don't require queues to be
present, so this is safe. Additionally, this change allows to remove
that useless queue->q_vector pointer cleanup, as vectors are still
valid when freeing the queues (+ both are freed within one function,
so it's not clear why nullify the pointers at all).

Fixes: 1c325aac10a8 ("idpf: configure resources for TX queues")
Fixes: 90912f9f4f2d ("idpf: convert header split mode to libeth + napi_build_skb()")
Reported-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20240806220923.3359860-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c  | 24 ++++++++++-----------
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 24 +--------------------
 2 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 32b6f0d52e3c5..3ac9d7ab83f20 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -905,8 +905,8 @@ static void idpf_vport_stop(struct idpf_vport *vport)
 
 	vport->link_up = false;
 	idpf_vport_intr_deinit(vport);
-	idpf_vport_intr_rel(vport);
 	idpf_vport_queues_rel(vport);
+	idpf_vport_intr_rel(vport);
 	np->state = __IDPF_VPORT_DOWN;
 }
 
@@ -1351,43 +1351,43 @@ static int idpf_vport_open(struct idpf_vport *vport)
 	/* we do not allow interface up just yet */
 	netif_carrier_off(vport->netdev);
 
-	err = idpf_vport_queues_alloc(vport);
-	if (err)
-		return err;
-
 	err = idpf_vport_intr_alloc(vport);
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to allocate interrupts for vport %u: %d\n",
 			vport->vport_id, err);
-		goto queues_rel;
+		return err;
 	}
 
+	err = idpf_vport_queues_alloc(vport);
+	if (err)
+		goto intr_rel;
+
 	err = idpf_vport_queue_ids_init(vport);
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to initialize queue ids for vport %u: %d\n",
 			vport->vport_id, err);
-		goto intr_rel;
+		goto queues_rel;
 	}
 
 	err = idpf_vport_intr_init(vport);
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to initialize interrupts for vport %u: %d\n",
 			vport->vport_id, err);
-		goto intr_rel;
+		goto queues_rel;
 	}
 
 	err = idpf_rx_bufs_init_all(vport);
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to initialize RX buffers for vport %u: %d\n",
 			vport->vport_id, err);
-		goto intr_rel;
+		goto queues_rel;
 	}
 
 	err = idpf_queue_reg_init(vport);
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to initialize queue registers for vport %u: %d\n",
 			vport->vport_id, err);
-		goto intr_rel;
+		goto queues_rel;
 	}
 
 	idpf_rx_init_buf_tail(vport);
@@ -1454,10 +1454,10 @@ static int idpf_vport_open(struct idpf_vport *vport)
 	idpf_send_map_unmap_queue_vector_msg(vport, false);
 intr_deinit:
 	idpf_vport_intr_deinit(vport);
-intr_rel:
-	idpf_vport_intr_rel(vport);
 queues_rel:
 	idpf_vport_queues_rel(vport);
+intr_rel:
+	idpf_vport_intr_rel(vport);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index b023704bbbdab..0c22e524e56db 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3436,9 +3436,7 @@ static void idpf_vport_intr_napi_dis_all(struct idpf_vport *vport)
  */
 void idpf_vport_intr_rel(struct idpf_vport *vport)
 {
-	int i, j, v_idx;
-
-	for (v_idx = 0; v_idx < vport->num_q_vectors; v_idx++) {
+	for (u32 v_idx = 0; v_idx < vport->num_q_vectors; v_idx++) {
 		struct idpf_q_vector *q_vector = &vport->q_vectors[v_idx];
 
 		kfree(q_vector->bufq);
@@ -3449,26 +3447,6 @@ void idpf_vport_intr_rel(struct idpf_vport *vport)
 		q_vector->rx = NULL;
 	}
 
-	/* Clean up the mapping of queues to vectors */
-	for (i = 0; i < vport->num_rxq_grp; i++) {
-		struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
-
-		if (idpf_is_queue_model_split(vport->rxq_model))
-			for (j = 0; j < rx_qgrp->splitq.num_rxq_sets; j++)
-				rx_qgrp->splitq.rxq_sets[j]->rxq.q_vector = NULL;
-		else
-			for (j = 0; j < rx_qgrp->singleq.num_rxq; j++)
-				rx_qgrp->singleq.rxqs[j]->q_vector = NULL;
-	}
-
-	if (idpf_is_queue_model_split(vport->txq_model))
-		for (i = 0; i < vport->num_txq_grp; i++)
-			vport->txq_grps[i].complq->q_vector = NULL;
-	else
-		for (i = 0; i < vport->num_txq_grp; i++)
-			for (j = 0; j < vport->txq_grps[i].num_txq; j++)
-				vport->txq_grps[i].txqs[j]->q_vector = NULL;
-
 	kfree(vport->q_vectors);
 	vport->q_vectors = NULL;
 }
-- 
2.43.0



